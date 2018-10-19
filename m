From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL 00/26] KVM/arm updates for 4.20
Date: Fri, 19 Oct 2018 13:58:35 +0100
Message-ID: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFDF4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 08:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jEhdpIhj-ZSC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 08:59:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 220FD49F94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 08:59:19 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is the bulk of the KVM/arm changes for 4.20. This time, the
biggest change by far is the support for variable addressing range in
guests, allowing userspace to size arm64 VMs from 32 to 52bits instead
of the hard-coded 40bits we've enjoyed so far. Other than that, we
have a random selection of small fixes and cleanups.

Note that this will generate a few minor conflicts with the arm64 tree,
which should be resolved as per this branch[1].

Please pull,

	M.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git merge-resolution-4.20

The following changes since commit 6bf4ca7fbc85d80446ac01c0d1d77db4d91a6d84:

  Linux 4.19-rc5 (2018-09-23 19:15:18 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v4.20

for you to fetch changes up to e4e11cc0f81ee7be17d6f6fb96128a6d51c0e838:

  KVM: arm64: Safety check PSTATE when entering guest and handle IL (2018-10-19 11:13:03 +0100)

----------------------------------------------------------------
KVM/arm updates for 4.20

- Improved guest IPA space support (32 to 52 bits)
- RAS event delivery for 32bit
- PMU fixes
- Guest entry hardening
- Various cleanups

----------------------------------------------------------------
Christoffer Dall (1):
      KVM: arm64: Safety check PSTATE when entering guest and handle IL

Dongjiu Geng (2):
      arm/arm64: KVM: Rename function kvm_arch_dev_ioctl_check_extension()
      arm/arm64: KVM: Enable 32 bits kvm vcpu events support

Kristina Martsenko (1):
      vgic: Add support for 52bit guest physical address

Marc Zyngier (2):
      KVM: arm/arm64: Rename kvm_arm_config_vm to kvm_arm_setup_stage2
      KVM: arm64: Drop __cpu_init_stage2 on the VHE path

Mark Rutland (1):
      KVM: arm64: Fix caching of host MDCR_EL2 value

Punit Agrawal (1):
      KVM: arm/arm64: Ensure only THP is candidate for adjustment

Suzuki K Poulose (17):
      kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
      kvm: arm/arm64: Remove spurious WARN_ON
      kvm: arm64: Add helper for loading the stage2 setting for a VM
      arm64: Add a helper for PARange to physical shift conversion
      kvm: arm64: Clean up VTCR_EL2 initialisation
      kvm: arm/arm64: Allow arch specific configurations for VM
      kvm: arm64: Configure VTCR_EL2 per VM
      kvm: arm/arm64: Prepare for VM specific stage2 translations
      kvm: arm64: Prepare for dynamic stage2 page table layout
      kvm: arm64: Make stage2 page table layout dynamic
      kvm: arm64: Dynamic configuration of VTTBR mask
      kvm: arm64: Configure VTCR_EL2.SL0 per VM
      kvm: arm64: Switch to per VM IPA limit
      kvm: arm64: Add 52bit support for PAR to HPFAR conversoin
      kvm: arm64: Set a limit on the IPA size
      kvm: arm64: Limit the minimum number of page table levels
      kvm: arm64: Allow tuning the physical address size for VM

zhong jiang (1):
      arm64: KVM: Remove some extra semicolon in kvm_target_cpu

 Documentation/virtual/kvm/api.txt             |  31 ++++
 arch/arm/include/asm/kvm_arm.h                |   3 +-
 arch/arm/include/asm/kvm_host.h               |  13 +-
 arch/arm/include/asm/kvm_mmu.h                |  15 +-
 arch/arm/include/asm/stage2_pgtable.h         |  54 +++---
 arch/arm64/include/asm/cpufeature.h           |  20 +++
 arch/arm64/include/asm/kvm_arm.h              | 155 +++++++++++++----
 arch/arm64/include/asm/kvm_asm.h              |   3 +-
 arch/arm64/include/asm/kvm_host.h             |  18 +-
 arch/arm64/include/asm/kvm_hyp.h              |  10 ++
 arch/arm64/include/asm/kvm_mmu.h              |  42 ++++-
 arch/arm64/include/asm/ptrace.h               |   3 +
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 -----
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 -----
 arch/arm64/include/asm/stage2_pgtable.h       | 236 +++++++++++++++++++-------
 arch/arm64/kvm/guest.c                        |   6 +-
 arch/arm64/kvm/handle_exit.c                  |   7 +
 arch/arm64/kvm/hyp/Makefile                   |   1 -
 arch/arm64/kvm/hyp/hyp-entry.S                |  16 +-
 arch/arm64/kvm/hyp/s2-setup.c                 |  90 ----------
 arch/arm64/kvm/hyp/switch.c                   |   4 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                |  19 ++-
 arch/arm64/kvm/hyp/tlb.c                      |   4 +-
 arch/arm64/kvm/reset.c                        | 108 +++++++++++-
 include/linux/irqchip/arm-gic-v3.h            |   5 +
 include/uapi/linux/kvm.h                      |  10 ++
 virt/kvm/arm/arm.c                            |  26 ++-
 virt/kvm/arm/mmu.c                            | 128 +++++++-------
 virt/kvm/arm/vgic/vgic-its.c                  |  36 ++--
 virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c              |   2 -
 31 files changed, 717 insertions(+), 431 deletions(-)
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
 delete mode 100644 arch/arm64/kvm/hyp/s2-setup.c
