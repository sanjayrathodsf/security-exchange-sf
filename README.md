# Highlevel Solution Design 

- Platform events where used to process the order fullfilment asynchronously. Whenever an Exchange Order is created/updated/deleted a Platform event is inserted, which then invokes the logic of order management. 
- To match the orders first the Buy orders are sorted in Descending order with highest bid at the first of the list and Sell orders are sorted ascending order.
- Then based on each security in the list the orders are matched against the open Sell orders and fullfilled based on best price. The logic currently matches the quantity and does not do partial fullfilment, but can be scaled to achieve parital fill orders. Once the order is matched an exchange match order record is created looking upto to the buy and sell orders and price it was filled at and the orders which were filled are marked as Filled and updated.
- A Batch apex runs every day after market close to look for all the open day orders and are cancelled. 
- A REST API exposes an endpoint which can be consumed to query an order, the securities and also perform operations like order creation and update.
- Swagger file for the same has been added to the src file which can be used to consume this API. 



# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
