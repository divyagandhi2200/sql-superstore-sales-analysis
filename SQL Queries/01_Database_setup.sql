/*
===============================================================================
                      DATABASE SETUP
===============================================================================

Project : Superstore Sales Analysis
Dataset : Sample Superstore
Tool    : Microsoft SQL Server

Project Description:
This project analyzes retail sales data from a Superstore to identify
sales trends, customer behavior, product performance, regional profitability,
and business opportunities using SQL.

This file contains the database setup required before starting the analysis.

===============================================================================
*/

/*
===============================================================================
Step 1: Create Database

Purpose:
Create a dedicated database to store the Superstore dataset.

Note:
Run this statement only once.
===============================================================================
*/

CREATE DATABASE Superstore;
GO

/*
===============================================================================
Step 2: Select Database

Purpose:
Set Superstore as the active database for all subsequent operations.

===============================================================================
*/

USE Superstore;
GO

/*
===============================================================================
Dataset Import

The Sample Superstore CSV file was imported into SQL Server using
the SQL Server Import Wizard.

Table Name:
dbo.superstore

===============================================================================
*/
