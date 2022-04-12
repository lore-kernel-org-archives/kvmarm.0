Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DEDC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:32:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0784B296;
	Tue, 12 Apr 2022 09:32:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d8707ARiqfV0; Tue, 12 Apr 2022 09:32:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D11904B24B;
	Tue, 12 Apr 2022 09:32:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A3F4B1AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id REQO7mu2zEAe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:32:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB314088C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E29D6150C;
 Tue, 12 Apr 2022 06:32:36 -0700 (PDT)
Received: from e121798.arm.com (unknown [10.57.11.98])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 78B233F70D;
 Tue, 12 Apr 2022 06:32:35 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 00/11] arm64: Improve PMU support on heterogeneous
 systems
Date: Tue, 12 Apr 2022 14:32:20 +0100
Message-Id: <20220412133231.35355-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The series can be found at [1].

The series adds support for the KVM_ARM_VCPU_PMU_V3_SET_PMU PMU attribute,
which allows userspace to set a PMU for a VCPU. This PMU is used by KVM
when creating perf events to emulate the guest PMU.

Without settings this attribute, the PMU used when creating events is the
first one that successfully probed when booting, but this is unreliable as
the probe order can change (if the order of the PMUs is changed in the DTB
or if asynchronous driver probing is enabled on the host's command line),
and furthermore it requires the user to have intimate knowledge of how the
PMU was chosen in order to pin the VM on the correct physical CPUs.

With KVM_ARM_VCPU_PMU_V3_SET_PMU, the user is still expected to pin the
VCPUs on a particular set of CPUs, but now it can be any CPUs as long as
they share the same PMU. The set does not depend anymore on the driver
probe order and all that is necessary for the user to know is which CPUs
share the same PMU, which I believe is a more reasonable expectation for
the average user. Pinning the VCPU threads on the desired CPUs can be done
using two methods:

1. By pinning the kvmtool process using taskset.

2. By pinning only the VCPU threads using the kvmtool command line argument
--vcpu-affinity, which this series introduces.

Regarding method #1, the series has the potential to break users of kvmtool
on heterogeneous systems. For example, launching kvmtool like this:

./lkvm run -c2 -m512 -k <kernel> -d <disk> --pmu

will exit with an error when Linux migrates a VCPU thread to a physical CPU
which has a different PMU than the PMU associated with the main thread when
the emulated PMU has been set for the entire VM. I believe this is an
improvement over the current behaviour for two reasons:

* PMU events would have stopped working anyway when the thread migration
  happens, but now KVM kills the VM instead of events silently stopping.
  This can save someone a lot of time and pain debugging the VM.

* Using taskset to pin kvmtool to a set of CPUs which have a particular PMU
  now works.

However, I understand that breaking existing scripts/use cases might not be
desirable, and if requested I can change the series to set the PMU only
when --vcpu-affinity is specified and preserve the current behaviour.

Patches #1-#3 are fixes and can be taken independently of this series.

Patches #4-#7 move the PMU code to aarch64, where it belongs, because the
PMU has never been supported on KVM for arm. This also paves the way for
pulling in the KVM_ARM_VCPU_PMU_V3_SET_PMU attribute, which was not defined
for KVM for arm (when KVM supported arm). This also can be merged right
now, independently of the other patches.

Patch #8 adds the cpumask_* functions which are necessary for subsequent
patches.

Patch #10 adds basic support for KVM_ARM_VCPU_PMU_V3_SET_PMU; the user is
still expected to use taskset to pin the entire VM to the correct CPUs.

Patch #11 expands on #10 by adding the --vcpu-affinity command line
argument to pin VCPUs to the correct CPUs without pinning the rest of the
kvmtool threads.

Changes from v2:

* Patch #3 (" arm/arm64: pmu.h: Add missing header guards") is new.
* Use __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__ as per C preprocessor
  common predefined macros [2].
* Do not die if kvmtool is not able to find a PMU associated with the CPUs
  specified by the user with --vcpu-affinity. There are valid reasons for
  someone to do this (like testing what happens with the default PMU, or
  what happens to a guest when PMU events are not working, etc).
* Updated --pmu help text to explain how the PMU is chosen.
* Minor cosmetic fixes.

Changes from v1:

* Patch #2 ("bitops.h: Include wordsize.h to provide the __WORDSIZE
  define") is new.
* Added for_each_cpu(), cpumask_and() and cpumask_subset() functions and
  all the cpumask_* functions are added in one patch.
* Bumped NR_CPUS fro arm64 to 4096 to match the Linux Kconfig option.
* Reworked the way kvmtool specific header files were included to use
  quotes to clearly differentiate them from the system level headers and to
  keep the style consistent with the current code (for example, #include
  <linux/bitops.h> is now "linux/bitops.h").
* Patch #10 ("arm64: Add --vcpu-affinity command line argument") is new.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v3
[2] https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

Alexandru Elisei (11):
  linux/err.h: Add missing stdbool.h include
  linux/bitops.h: Include wordsize.h to provide the __WORDSIZE define
  arm/arm64: pmu.h: Add missing header guards
  arm: Move arch specific VCPU features to the arch specific function
  arm: Get rid of the ARM_VCPU_FEATURE_FLAGS() macro
  arm: Make the PMUv3 emulation code arm64 specific
  arm64: Rework set_pmu_attr()
  Add cpumask functions
  update_headers.sh: Sync ABI headers with Linux v5.18-rc2
  arm64: Add support for KVM_ARM_VCPU_PMU_V3_SET_PMU
  arm64: Add --vcpu-affinity command line argument

 Makefile                                      |   8 +-
 arm/aarch32/include/asm/kernel.h              |   8 +
 arm/aarch32/include/kvm/kvm-cpu-arch.h        |   4 -
 arm/aarch64/arm-cpu.c                         |   3 +-
 arm/aarch64/include/asm/kernel.h              |   8 +
 arm/aarch64/include/asm/kvm.h                 |  11 +
 .../arm-common => aarch64/include/asm}/pmu.h  |   4 +
 arm/aarch64/include/kvm/kvm-config-arch.h     |   9 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h        |   6 -
 arm/aarch64/kvm-cpu.c                         |  21 ++
 arm/aarch64/kvm.c                             |  32 +++
 arm/aarch64/pmu.c                             | 237 ++++++++++++++++
 arm/include/arm-common/kvm-arch.h             |   7 +
 arm/include/arm-common/kvm-config-arch.h      |   1 +
 arm/kvm-cpu.c                                 |  14 +-
 arm/pmu.c                                     |  76 ------
 include/linux/bitmap.h                        |  71 +++++
 include/linux/bitops.h                        |   4 +
 include/linux/bits.h                          |   8 +
 include/linux/cpumask.h                       |  67 +++++
 include/linux/err.h                           |   2 +
 include/linux/find.h                          |  30 ++
 include/linux/kernel.h                        |   6 +
 include/linux/kvm.h                           |  15 +-
 mips/include/asm/kernel.h                     |   8 +
 powerpc/include/asm/kernel.h                  |   8 +
 util/bitmap.c                                 | 256 ++++++++++++++++++
 util/find.c                                   |  40 +++
 x86/include/asm/kernel.h                      |   8 +
 29 files changed, 870 insertions(+), 102 deletions(-)
 create mode 100644 arm/aarch32/include/asm/kernel.h
 create mode 100644 arm/aarch64/include/asm/kernel.h
 rename arm/{include/arm-common => aarch64/include/asm}/pmu.h (55%)
 create mode 100644 arm/aarch64/pmu.c
 delete mode 100644 arm/pmu.c
 create mode 100644 include/linux/bitmap.h
 create mode 100644 include/linux/bits.h
 create mode 100644 include/linux/cpumask.h
 create mode 100644 include/linux/find.h
 create mode 100644 mips/include/asm/kernel.h
 create mode 100644 powerpc/include/asm/kernel.h
 create mode 100644 util/bitmap.c
 create mode 100644 util/find.c
 create mode 100644 x86/include/asm/kernel.h

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
