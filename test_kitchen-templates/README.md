# Test Kitchen Templates

For Windows Workstations we could not find a reliable way of allowing for Test
Kitchen to operate on the virtualized instance. We realized that we would need
to allow a workstation, that we provide to the learner, to be able to generate
nodes for testing with Test Kitchen. However, we did not want to explicitly add
credentials to the workstation.

## kitchen-template

This template is designed for the Chef Essentials Windows course to be run
in the Training AWS. This kitchen template is suppose to replace the default
kitchen template that gets generated with the cookbook. This template allows
a workstation, when assigned the correct policy or keys, the ability to create
its own instances when using Test Kitchen.

SEE [Windows Install Scripts](../scripts)
