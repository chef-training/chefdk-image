# AWS Objects

To setup the AWS environment to support the workstations/nodes necessary to
deliver training requires a few additional objects. This folder contains these
objects.

## IAM Role: Test Kitchen

For Windows Workstations we could not find a reliable way of allowing for Test
Kitchen to operate on the virtualized instance. We realized that we would need
to allow a workstation, that we provide to the learner, to be able to generate
nodes for testing with Test Kitchen. However, we did not want to explicitly add
credentials to the workstation.

The solution was to create a AWS IAM Role with the policy that allows for
instances that were given this policy the ability to create new instances.

SEE: [Test Kitchen Templates](../test_kitchen-templates)
