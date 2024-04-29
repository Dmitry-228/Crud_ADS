-- migrate:up

create extension if not exists "uuid-ossp";
 
create schema if not exists advertisements_data;

create table if not exists advertisements_data.author
(
	id uuid primary key default uuid_generate_v4(),
	name text not null
);

create table if not exists advertisements_data.ads
(
	id uuid primary key default uuid_generate_v4(),
	name text not null,
	description text,
	publish_date date not null,
	author_id uuid references advertisements_data.author
);

create table if not exists advertisements_data.sites
(
	id uuid primary key default uuid_generate_v4(),
	name text not null,
	url text not null,
	rating float
);

create table if not exists advertisements_data.ads_to_sites
(
	ad_id uuid references advertisements_data.ads,
	sites_id uuid references advertisements_data.sites,
	primary key (ad_id, sites_id)
);


-- migrate:down

drop table if exists advertisements_data.ads_to_sites, advertisements_data.ads, advertisements_data.author, advertisements_data.sites;
