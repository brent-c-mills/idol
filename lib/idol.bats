#!/usr/bin/env bats

load test_helper
fixtures bats
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/bats_current/bats_master.tar.gz" {
[[ -e bin/bats_current/bats_master.tar.gz ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/group_full_centos.sh" {
[[ -e bin/group_full_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/group_full_darwin.sh" {
[[ -e bin/group_full_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/group_full_ubuntu.sh" {
[[ -e bin/group_full_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/group_hash_centos.sh" {
[[ -e bin/group_hash_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/group_hash_darwin.sh" {
[[ -e bin/group_hash_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/group_hash_ubuntu.sh" {
[[ -e bin/group_hash_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/idol" {
[[ -e bin/idol ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/idol_create.sh" {
[[ -e bin/idol_create.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/idol_list.sh" {
[[ -e bin/idol_list.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/idol_package.sh" {
[[ -e bin/idol_package.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/idol_test.sh" {
[[ -e bin/idol_test.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/package_full_centos.sh" {
[[ -e bin/package_full_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/package_full_darwin.sh" {
[[ -e bin/package_full_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/package_full_ubuntu.sh" {
[[ -e bin/package_full_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/package_hash_centos.sh" {
[[ -e bin/package_hash_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/package_hash_darwin.sh" {
[[ -e bin/package_hash_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/package_hash_ubuntu.sh" {
[[ -e bin/package_hash_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/user_full_centos.sh" {
[[ -e bin/user_full_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/user_full_darwin.sh" {
[[ -e bin/user_full_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/user_full_ubuntu.sh" {
[[ -e bin/user_full_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/user_hash_centos.sh" {
[[ -e bin/user_hash_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/user_hash_darwin.sh" {
[[ -e bin/user_hash_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - bin/user_hash_ubuntu.sh" {
[[ -e bin/user_hash_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - install.sh" {
[[ -e install.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - lib/test_helper.bash" {
[[ -e lib/test_helper.bash ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - LICENSE" {
[[ -e LICENSE ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - man/idol_man.sh" {
[[ -e man/idol_man.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - package.sh" {
[[ -e package.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - README.md" {
[[ -e README.md ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ." {
[[ -e . ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./.git" {
[[ -e ./.git ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/bats_current/bats_master.tar.gz" {
[[ -e ./bin/bats_current/bats_master.tar.gz ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/group_full_centos.sh" {
[[ -e ./bin/group_full_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/group_full_darwin.sh" {
[[ -e ./bin/group_full_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/group_full_ubuntu.sh" {
[[ -e ./bin/group_full_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/group_hash_centos.sh" {
[[ -e ./bin/group_hash_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/group_hash_darwin.sh" {
[[ -e ./bin/group_hash_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/group_hash_ubuntu.sh" {
[[ -e ./bin/group_hash_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/idol_create.sh" {
[[ -e ./bin/idol_create.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/idol_list.sh" {
[[ -e ./bin/idol_list.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/idol_package.sh" {
[[ -e ./bin/idol_package.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/idol_test.sh" {
[[ -e ./bin/idol_test.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/package_full_centos.sh" {
[[ -e ./bin/package_full_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/package_full_darwin.sh" {
[[ -e ./bin/package_full_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/package_full_ubuntu.sh" {
[[ -e ./bin/package_full_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/package_hash_centos.sh" {
[[ -e ./bin/package_hash_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/package_hash_darwin.sh" {
[[ -e ./bin/package_hash_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/package_hash_ubuntu.sh" {
[[ -e ./bin/package_hash_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/user_full_centos.sh" {
[[ -e ./bin/user_full_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/user_full_darwin.sh" {
[[ -e ./bin/user_full_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/user_full_ubuntu.sh" {
[[ -e ./bin/user_full_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/user_hash_centos.sh" {
[[ -e ./bin/user_hash_centos.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/user_hash_darwin.sh" {
[[ -e ./bin/user_hash_darwin.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./bin/user_hash_ubuntu.sh" {
[[ -e ./bin/user_hash_ubuntu.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./install.sh" {
[[ -e ./install.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/dos_line.bats" {
[[ -e ./lib/fixtures/bats/dos_line.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/empty.bats" {
[[ -e ./lib/fixtures/bats/empty.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/environment.bats" {
[[ -e ./lib/fixtures/bats/environment.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/failing.bats" {
[[ -e ./lib/fixtures/bats/failing.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/failing_and_passing.bats" {
[[ -e ./lib/fixtures/bats/failing_and_passing.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/failing_helper.bats" {
[[ -e ./lib/fixtures/bats/failing_helper.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/failing_setup.bats" {
[[ -e ./lib/fixtures/bats/failing_setup.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/failing_teardown.bats" {
[[ -e ./lib/fixtures/bats/failing_teardown.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/intact.bats" {
[[ -e ./lib/fixtures/bats/intact.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/invalid_tap.bats" {
[[ -e ./lib/fixtures/bats/invalid_tap.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/load.bats" {
[[ -e ./lib/fixtures/bats/load.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/output.bats" {
[[ -e ./lib/fixtures/bats/output.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/passing.bats" {
[[ -e ./lib/fixtures/bats/passing.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/passing_and_failing.bats" {
[[ -e ./lib/fixtures/bats/passing_and_failing.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/passing_and_skipping.bats" {
[[ -e ./lib/fixtures/bats/passing_and_skipping.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/passing_failing_and_skipping.bats" {
[[ -e ./lib/fixtures/bats/passing_failing_and_skipping.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/setup.bats" {
[[ -e ./lib/fixtures/bats/setup.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/single_line.bats" {
[[ -e ./lib/fixtures/bats/single_line.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/skipped.bats" {
[[ -e ./lib/fixtures/bats/skipped.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/teardown.bats" {
[[ -e ./lib/fixtures/bats/teardown.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/test_helper.bash" {
[[ -e ./lib/fixtures/bats/test_helper.bash ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/bats/without_trailing_newline.bats" {
[[ -e ./lib/fixtures/bats/without_trailing_newline.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/suite/empty/.gitkeep" {
[[ -e ./lib/fixtures/suite/empty/.gitkeep ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/suite/multiple/a.bats" {
[[ -e ./lib/fixtures/suite/multiple/a.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/suite/multiple/b.bats" {
[[ -e ./lib/fixtures/suite/multiple/b.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/fixtures/suite/single/test.bats" {
[[ -e ./lib/fixtures/suite/single/test.bats ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./lib/test_helper.bash" {
[[ -e ./lib/test_helper.bash ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./man/idol_man.sh" {
[[ -e ./man/idol_man.sh ]]
}
 
@test "IDOL DIRECTORY STRUCTURE CHECK - ./README.md" {
[[ -e ./README.md ]]
}
 
