From: Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v2 00/12] arm64: Paravirtualized time support
Date: Wed, 12 Dec 2018 15:02:14 +0000
Message-ID: <20181212150226.38051-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E60E4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1i9VSMH6YnAp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 10:02:54 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32EFA4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:02:54 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This series add support for paravirtualized time for Arm64 guests and
KVM hosts following the specification in Arm's document DEN 0057A:

https://developer.arm.com/docs/den0057/a

It implements support for Live Physical Time (LPT) which provides the
guest with a method to derive a stable counter of time during which the
guest is executing even when the guest is being migrated between hosts
with different physical counter frequencies.

It also implements support for stolen time, allowing the guest to
identify time when it is forcibly not executing.

Patch 1 provides some documentation
Patches 2-4 and 8 provide some refactoring of existing code
Patches 5-7 and 9 implement cmmon code and support for stolen time
Patches 10-12 implement Live Physical Time

Changes since v1:
 * Live physical time changes split up and moved to the last three patches
   of the series.
 * Renamed arm_smccc_1_1 to arm_smccc_1_1_call to match Mark Rutland's series
   tidying SMCCC up. Potentially these changes can be dropped in favour of
   Mark's series.
 * Renamed things to avoid use of "page" as the shared structures are not
   necessarily an entire/single page.
 * Moved the contents of include/kvm/arm_pv.h to include/linux/arm-smccc.h
 * Fix definition of GPA_INVALID to be sign-extension safe

Christoffer Dall (1):
  KVM: arm/arm64: Factor out hypercall handling from PSCI code

Steven Price (11):
  KVM: arm64: Document PV-time interface
  arm/arm64: Provide a wrapper for SMCCC 1.1 calls
  arm/arm64: Make use of the SMCCC 1.1 wrapper
  KVM: arm64: Implement PV_FEATURES call
  KVM: arm64: Support stolen time reporting via shared structure
  arm64: Retrieve stolen time as paravirtualized guest
  KVM: Allow kvm_device_ops to be const
  KVM: arm64: Provide a PV_TIME device to user space
  KVM: arm64: Support Live Physical Time reporting
  clocksource: arm_arch_timer: Use paravirtualized LPT
  KVM: arm64: Export LPT using PV_TIME device

 Documentation/virtual/kvm/arm/pvtime.txt | 169 ++++++++++++++
 arch/arm/kvm/Makefile                    |   2 +-
 arch/arm/kvm/handle_exit.c               |   2 +-
 arch/arm/mm/proc-v7-bugs.c               |  46 ++--
 arch/arm64/include/asm/arch_timer.h      |  32 ++-
 arch/arm64/include/asm/kvm_host.h        |  16 ++
 arch/arm64/include/asm/kvm_mmu.h         |   2 +
 arch/arm64/include/asm/pvclock-abi.h     |  32 +++
 arch/arm64/include/uapi/asm/kvm.h        |   8 +
 arch/arm64/kernel/Makefile               |   1 +
 arch/arm64/kernel/cpu_errata.c           |  47 +---
 arch/arm64/kernel/cpuinfo.c              |   2 +-
 arch/arm64/kernel/kvm.c                  | 156 +++++++++++++
 arch/arm64/kvm/Kconfig                   |   1 +
 arch/arm64/kvm/Makefile                  |   2 +
 arch/arm64/kvm/handle_exit.c             |   4 +-
 drivers/clocksource/arm_arch_timer.c     | 177 ++++++++++++++-
 include/kvm/arm_arch_timer.h             |   2 +
 include/kvm/arm_hypercalls.h             |  44 ++++
 include/kvm/arm_psci.h                   |   2 +-
 include/linux/arm-smccc.h                |  64 ++++++
 include/linux/cpuhotplug.h               |   1 +
 include/linux/kvm_host.h                 |   4 +-
 include/linux/kvm_types.h                |   2 +
 include/uapi/linux/kvm.h                 |   2 +
 virt/kvm/arm/arm.c                       |  25 ++-
 virt/kvm/arm/hypercalls.c                | 271 +++++++++++++++++++++++
 virt/kvm/arm/mmu.c                       |  44 ++++
 virt/kvm/arm/psci.c                      |  76 +------
 virt/kvm/arm/pvtime.c                    | 244 ++++++++++++++++++++
 virt/kvm/kvm_main.c                      |   6 +-
 31 files changed, 1333 insertions(+), 153 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h
 create mode 100644 arch/arm64/kernel/kvm.c
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 virt/kvm/arm/hypercalls.c
 create mode 100644 virt/kvm/arm/pvtime.c

-- 
2.19.2
