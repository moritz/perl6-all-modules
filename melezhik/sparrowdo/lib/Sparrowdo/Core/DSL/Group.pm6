use v6;

unit module Sparrowdo::Core::DSL::Group;

use Sparrowdo;

sub group-create ( $group_id ) is export {

    task_run  %(
      task => "create group $group_id",
      plugin => 'group',
      parameters => %(
        name        => $group_id,
        action      => 'create',
      )
    );

}

multi sub group ( $group_id, %args? ) is export {

    my $action = %args<action>;

    task_run  %(
      task => "$action group $group_id",
      plugin => 'group',
      parameters => %(
        name        => $group_id,
        action      => $action,
      )
    );

}

multi sub group ( $group_id )  is export { group-create $group_id }

sub group-delete ( $group_id ) is export {

    task_run  %(
      task => "delete group $group_id",
      plugin => 'group',
      parameters => %(
        name        => $group_id,
        action      => 'delete',
      )
    );

}

