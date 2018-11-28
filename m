From: Steven Price <steven.price@arm.com>
Subject: [PATCH 00/12] arm64: Paravirtualized time support
Date: Wed, 28 Nov 2018 14:45:15 +0000
Message-ID: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 453084A348
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id flSCR+ynlhms for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D38364A32F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:28 -0500 (EST)
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
Patches 2-4, 8 and 11 provide some refactoring of existing code
Patch 5 implements the new PV_FEATURES discovery mechanism
Patches 6-7 implement live physical time
Patches 9-10 implement stolen time
Patch 12 adds the 'PV_TIME' device for user space to enable the features

Christoffer Dall (2):
  KVM: arm/arm64: Factor out hypercall handling from PSCI code
  KVM: Export mark_page_dirty_in_slot

Steven Price (10):
  KVM: arm64: Document PV-time interface
  arm/arm64: Provide a wrapper for SMCCC 1.1 calls
  arm/arm64: Make use of the SMCCC 1.1 wrapper
  KVM: arm64: Implement PV_FEATURES call
  KVM: arm64: Support Live Physical Time reporting
  clocksource: arm_arch_timer: Use paravirtualized LPT
  KVM: arm64: Support stolen time reporting via shared page
  arm64: Retrieve stolen time as paravirtualized guest
  KVM: Allow kvm_device_ops to be const
  KVM: arm64: Provide a PV_TIME device to user space

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
 drivers/clocksource/arm_arch_timer.c     | 176 ++++++++++++++-
 include/kvm/arm_arch_timer.h             |   2 +
 include/kvm/arm_hypercalls.h             |  44 ++++
 include/kvm/arm_psci.h                   |   2 +-
 include/kvm/arm_pv.h                     |  28 +++
 include/linux/arm-smccc.h                |  45 ++++
 include/linux/cpuhotplug.h               |   1 +
 include/linux/kvm_host.h                 |   5 +-
 include/linux/kvm_types.h                |   2 +
 include/uapi/linux/kvm.h                 |   2 +
 virt/kvm/arm/arm.c                       |  25 +-
 virt/kvm/arm/hypercalls.c                | 276 +++++++++++++++++++++++
 virt/kvm/arm/mmu.c                       |  44 ++++
 virt/kvm/arm/psci.c                      |  76 +------
 virt/kvm/arm/pvtime.c                    | 243 ++++++++++++++++++++
 virt/kvm/kvm_main.c                      |  12 +-
 32 files changed, 1348 insertions(+), 157 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h
 create mode 100644 arch/arm64/kernel/kvm.c
 create mode 100644 include/kvm/arm_hypercalls.h
 create mode 100644 include/kvm/arm_pv.h
 create mode 100644 virt/kvm/arm/hypercalls.c
 create mode 100644 virt/kvm/arm/pvtime.c

-- 
2.19.2
