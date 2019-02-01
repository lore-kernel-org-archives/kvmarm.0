From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH v2 0/5] arm/arm64: Add support for running
 under kvmtool
Date: Fri,  1 Feb 2019 11:16:36 +0000
Message-ID: <20190201111641.8299-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F1E4A330
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:16:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xIIjB31R3jFL for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 06:16:54 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 790514A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:16:54 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

kvm-unit-tests is designed to be run with QEMU as the virtual machine
monitor. It relies on devices emulated by QEMU (like isa-debug-exit or
testdev) and it makes certain assumptions based on the implicit QEMU
virtual environment configuration (like the serial base address).

kvmtool [1] is a lightweight virtual machine monitor for running KVM
guests. kvmtool has reduced complexity compared to QEMU and is easily
hackable.

This patch series aims to make it possible to run kvm-unit-tests using
kvmtool on the arm and arm64 architectures, with two caveats:

(1) When terminating a test, the userspace process won't exit with an exit
code that signals the success or failure of the test. Output from the test
can still be parsed to determine the outcome of the test.

(2) kvmtool has been designed to work with a linux guest and it
automatically generates the command line arguments for a Linux kernel. This
causes the arm/arm64 selftest and gic tests to fail because those tests are
very specific with regards to the command line arguments that are provided
by the virtual machine manager.

With regards to (2), a patch was posted that seeks too eliminate this
behavior for kvmtool [2].

The run scripts haven't been modified. To run a test under kvmtool, one
needs to launch kvmtool manually. For example, to run the timer test the
following command can be used:

lkvm run -c 1 --console=serial -k timer.flat.

Changes in v2:
* Generate lib/config.h when configuring kvm-unit-tests; arm/arm64 uses it
  to get the UART address.
* Added --vmm configure option for arm/arm64 which will set the UART
  address in lib/config.h when the tests are run under QEMU or kvmtool.
* Renamed psci_sys_reset() to psci_system_reset().
* Dropped patches that allowed a test to ignore unexpected command line
  arguments.

Summary:
* Patches 1, 2 and 3 add support for configuring kvm-unit-tests on arm and
  arm64 to use the ns16550a UART emulated by kvmtool.
* Patches 4 and 5 provide an alternative mechanism for terminating the
  virtual machine by using PSCI.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/
[2] https://www.spinics.net/lists/kvm-arm/msg34352.html

Alexandru Elisei (5):
  lib: arm: Use UART address from generated config.h
  configure: arm/arm64: Add --vmm option with no effect
  lib: arm: Use ns16550a UART when --vmm=kvmtool
  lib: arm: Implement PSCI SYSTEM_OFF in psci_system_off()
  lib: arm: Fallback to psci_system_off() in exit()

 configure          | 31 +++++++++++++++++++++++++++++++
 Makefile           |  2 +-
 lib/arm/asm/psci.h |  3 ++-
 lib/arm/io.c       | 34 ++++++++++++++++++++++------------
 lib/arm/psci.c     |  8 +++++++-
 .gitignore         |  1 +
 6 files changed, 64 insertions(+), 15 deletions(-)

-- 
2.17.0
