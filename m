From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 0/8] arm64: Support for systems without AArch32 state
Date: Thu, 25 Feb 2016 09:52:40 +0000
Message-ID: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, ynorov@caviumnetworks.com, catalin.marinas@arm.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This series add checks to make sure that the AArch32 state is
supported before we process the 32bit ID registers. Also
checks the same for COMPAT binary execution.

(Painfully) applies on top of 4.5-rc5 + [1] + [2].

Or it is available here :
  git://linux-arm.org/linux-skp.git noaarch32/v2-4.5-rc5

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/410556.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/401913.html

Changes since V1:
  - Prevent changing the personality to PER_LINUX32 by adding
    wrapper for personality() syscall.
  - Add the check to KVM before initialising a AArch32 vcpu
  - Tested on hardware.

Btw, linux32 doesn't complain when the personality() syscall fails to change
to PER_LINUX32. You can verify the personality by running 
 $ cat /proc/cpuinfo
 which would still list the 64bit features for the CPUs.


Suzuki K Poulose (7):
  arm64: hwcaps: Cleanup naming
  arm64: HWCAP: Split COMPAT HWCAP table entries
  arm64: Add helpers for detecting AArch32 support at EL0
  arm64: cpufeature: Check availability of AArch32
  arm64: cpufeature: Track 32bit EL0 support
  arm64: Add a wrapper for personality() syscall
  arm64: kvm: Check support for AArch32 for 32bit guests

Yury Norov (1):
  arm64: compat: Check for AArch32 state

 arch/arm/include/asm/kvm_host.h     |    5 +
 arch/arm/kvm/arm.c                  |    3 +
 arch/arm64/include/asm/cpufeature.h |   15 ++-
 arch/arm64/include/asm/elf.h        |    3 +-
 arch/arm64/include/asm/kvm_host.h   |    8 ++
 arch/arm64/include/asm/sysreg.h     |    1 +
 arch/arm64/kernel/cpufeature.c      |  184 +++++++++++++++++++++--------------
 arch/arm64/kernel/cpuinfo.c         |   37 +++----
 arch/arm64/kernel/sys.c             |   10 ++
 9 files changed, 173 insertions(+), 93 deletions(-)

-- 
1.7.9.5
