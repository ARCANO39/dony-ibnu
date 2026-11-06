-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Enums for Roles & Status
create type user_role as enum ('super_admin', 'cashier', 'technician', 'warehouse', 'customer');
create type ticket_status as enum ('queue', 'diagnosing', 'waiting_approval', 'in_progress', 'qc', 'ready', 'closed', 'cancelled');
create type payment_method as enum ('cash', 'qris', 'transfer', 'edc');

-- 1. Profiles Table (Extended Auth)
create table public.profiles (
    id uuid references auth.users on delete cascade primary key,
    full_name text not null,
    role user_role not null default 'customer',
    phone text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Spareparts Table (Inventory)
create table public.spareparts (
    id uuid default uuid_generate_v4() primary key,
    sku text unique not null,
    name text not null,
    category text not null,
    compatibility text,
    buy_price numeric(12,2) not null default 0,
    sell_price numeric(12,2) not null default 0,
    stock integer not null default 0,
    min_stock integer not null default 3,
    rack_location text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Service Tickets Table
create table public.service_tickets (
    id uuid default uuid_generate_v4() primary key,
    ticket_no text unique not null,
    customer_name text not null,
    customer_phone text not null,
    customer_address text,
    device_brand text not null,
    device_model text not null,
    serial_number text,
    device_password text,
    physical_checklist jsonb default '{}'::jsonb,
    initial_condition_photos text[] default '{}',
    status ticket_status not null default 'queue',
    assigned_technician_id uuid references public.profiles(id),
    service_fee numeric(12,2) default 0,
    estimated_cost numeric(12,2) default 0,
    dp_amount numeric(12,2) default 0,
    is_approved boolean default false,
    warranty_days integer default 30,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Ticket Spareparts (Items used in service)
create table public.ticket_spareparts (
    id uuid default uuid_generate_v4() primary key,
    ticket_id uuid references public.service_tickets(id) on delete cascade,
    sparepart_id uuid references public.spareparts(id),
    qty integer not null default 1,
    unit_price numeric(12,2) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. Technician Work Logs
create table public.work_logs (
    id uuid default uuid_generate_v4() primary key,
    ticket_id uuid references public.service_tickets(id) on delete cascade,
    technician_id uuid references public.profiles(id),
    internal_notes text,
    customer_notes text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 6. Transactions / POS Payments
create table public.transactions (
    id uuid default uuid_generate_v4() primary key,
    invoice_no text unique not null,
    ticket_id uuid references public.service_tickets(id),
    cashier_id uuid references public.profiles(id),
    total_amount numeric(12,2) not null,
    payment_method payment_method not null,
    payment_status text default 'paid',
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- TRIGGER: Automatic stock deduction when sparepart is added to ticket
create or replace function deduct_sparepart_stock()
returns trigger as $$
begin
    update public.spareparts
    set stock = stock - new.qty
    where id = new.sparepart_id;
    return new;
end;
$$ language plpgsql;

create trigger tr_deduct_stock
after insert on public.ticket_spareparts
for each row
execute function deduct_sparepart_stock();
