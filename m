From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/13] arm64: Virtualization Host Extension support
Date: Wed,  8 Jul 2015 17:19:03 +0100
Message-ID: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64F4580E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:07:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GqaG7fSlY4PB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:07:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67603580D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:07:57 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
short), which enables simpler support of Type-2 hypervisors.

This extension allows the kernel to directly run at EL2, and
significantly reduces the number of system registers shared between
host and guest, reducing the overhead of virtualization.

In order to have the same kernel binary running on all versions of the
architecture, this series makes heavy use of runtime code patching.

The first ten patches massage the KVM code to deal with VHE and enable
Linux to run at EL2.

The next patch catches an ugly case when VHE capable CPUs are paired
with some of their less capable siblings. This should never happen,
but hey...

The last two patches add an optimisation allowing a physical interrupt
to be serviced on the host without doing a full save/restore, leading
to potential reduction in interrupt latency.

This has been tested on the FVP_Base_SLV-V8-A model, and based on
v4.2-rc1. I've put a branch out on:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vhe

Marc Zyngier (13):
  arm/arm64: Add new is_kernel_in_hyp_mode predicate
  arm64: Allow the arch timer to use the HYP timer
  arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
  arm64: KVM: skip HYP setup when already running in HYP
  arm64: KVM: VHE: macroize VTCR_EL2 setup
  arm64: KVM: VHE: Patch out kern_hyp_va
  arm64: KVM: VHE: Patch out use of HVC
  arm64: KVM: VHE: Preserve VHE config in world switch
  arm64: KVM: VHE: Add alternatives for VHE-enabled world-switch
  arm64: Add support for running Linux in EL2 mode
  arm64: Panic when VHE and non VHE CPUs coexist
  arm64: KVM: Split sysreg save/restore
  arm64: KVM: VHE: Early interrupt handling

 arch/arm/include/asm/virt.h          |   5 +
 arch/arm/kvm/arm.c                   | 134 ++++++++-----
 arch/arm/kvm/mmu.c                   |   6 +
 arch/arm64/include/asm/cpufeature.h  |   3 +-
 arch/arm64/include/asm/kvm_arm.h     |   1 +
 arch/arm64/include/asm/kvm_asm.h     |  40 +++-
 arch/arm64/include/asm/kvm_emulate.h |   2 +
 arch/arm64/include/asm/kvm_mmu.h     |  24 ++-
 arch/arm64/include/asm/virt.h        |  25 +++
 arch/arm64/kernel/cpufeature.c       |  11 ++
 arch/arm64/kernel/head.S             |  38 +++-
 arch/arm64/kernel/smp.c              |   4 +
 arch/arm64/kvm/hyp-init.S            |   9 +-
 arch/arm64/kvm/hyp.S                 | 363 ++++++++++++++++++++++++-----------
 arch/arm64/kvm/vgic-v2-switch.S      |  19 +-
 arch/arm64/kvm/vgic-v3-switch.S      |  33 ++--
 arch/arm64/kvm/vhe-macros.h          |  54 ++++++
 drivers/clocksource/arm_arch_timer.c |  96 +++++----
 18 files changed, 638 insertions(+), 229 deletions(-)
 create mode 100644 arch/arm64/kvm/vhe-macros.h

-- 
2.1.4
