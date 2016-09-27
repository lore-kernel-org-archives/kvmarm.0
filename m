From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/50] KVM/ARM Changes for v4.9
Date: Tue, 27 Sep 2016 20:05:08 +0200
Message-ID: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A2FD4998D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5CnokuyYg2AG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:24 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30EDC412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:23 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id b130so27045865wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:47 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here are the KVM/ARM Changes for v4.9. They include:

 - Various cleanups and removal of redundant code
 - Two important fixes for not using an in-kernel irqchip
 - A bit of optimizations
 - Handle SError exceptions and present them to guests if appropriate
 - Proxying of GICV access at EL2 if guest mappings are unsafe
 - GICv3 on AArch32 on ARMv8
 - Preparations for GICv3 save/restore, including ABI docs


The following changes since commit 9ac7e3e815060efdc86b6d12448200e3c3597e01:

  KVM: nVMX: expose INS/OUTS information support (2016-09-07 19:34:30 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.9

for you to fetch changes up to 0099b7701f5296a758d9e6b945ec96f96847cc2f:

  KVM: arm/arm64: vgic: Don't flush/sync without a working vgic (2016-09-27 18:57:35 +0200)

Thanks,
-Christoffer

---

Christoffer Dall (6):
      KVM: arm/arm64: Add VGICv3 save/restore API documentation
      KVM: arm/arm64: Factor out vgic_attr_regs_access functionality
      KVM: arm/arm64: Rename vgic_attr_regs_access to vgic_attr_regs_access_v2
      KVM: arm/arm64: Get rid of exported aliases to static functions
      KVM: arm64: Require in-kernel irqchip for PMU support
      KVM: arm/arm64: vgic: Don't flush/sync without a working vgic

Marc Zyngier (28):
      KVM: arm: vgic: Drop build compatibility hack for older kernel versions
      arm64: KVM: Move kvm_vcpu_get_condition out of emulate.c
      arm64: KVM: Move the AArch32 conditional execution to common code
      arm: KVM: Use common AArch32 conditional execution code
      arm64: KVM: Make kvm_skip_instr32 available to HYP
      arm64: KVM: vgic-v2: Add the GICV emulation infrastructure
      arm64: KVM: vgic-v2: Add GICV access from HYP
      arm64: KVM: vgic-v2: Enable GICV access from HYP if access from guest is unsafe
      arm64: KVM: Rename HCR_VA to HCR_VSE
      arm64: KVM: Preserve pending vSError in world switch
      arm64: KVM: Add Virtual Abort injection helper
      arm64: KVM: Add exception code to report EL1 asynchronous aborts
      arm64: KVM: Add EL1 async abort handler
      arm64: KVM: Route asynchronous aborts
      arm64: KVM: Allow an exit code to be tagged with an SError
      arm64: KVM: Inject a Virtual SError if it was pending
      arm64: KVM: Handle async aborts delivered while at EL2
      arm: KVM: Preserve pending Virtual Abort in world switch
      arm: KVM: Add Virtual Abort injection helper
      arm: KVM: Add HYP async abort handler
      arm: KVM: Allow an exit code to be tagged with a Virtual Abort
      arm: KVM: Handle async aborts delivered while at HYP
      arm: KVM: Inject a Virtual Abort if it was pending
      arm: KVM: Drop unreachable HYP abort handlers
      arm/arm64: KVM: Inject virtual abort when guest exits on external abort
      arm/arm64: KVM: Remove external abort test from MMIO handling
      arm64: KVM: Inject a vSerror if detecting a bad GICV access at EL2
      ARM: gic-v3: Work around definition of gic_write_bpr1

Mark Rutland (2):
      arm/kvm: excise redundant cache maintenance
      arm64/kvm: remove unused stub functions

Paolo Bonzini (1):
      KVM: ARM: cleanup kvm_timer_hyp_init

Shanker Donthineni (1):
      arm64: KVM: Optimize __guest_enter/exit() to save a few instructions

Vladimir Murzin (12):
      arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2
      arm64: KVM: Use static keys for selecting the GIC backend
      arm64: KVM: Move GIC accessors to arch_gicv3.h
      arm64: KVM: Move vgic-v3 save/restore to virt/kvm/arm/hyp
      KVM: arm64: vgic-its: Introduce config option to guard ITS specific code
      KVM: arm: vgic: Fix compiler warnings when built for 32-bit
      KVM: arm: vgic: Support 64-bit data manipulation on 32-bit host systems
      ARM: Introduce MPIDR_LEVEL_SHIFT macro
      ARM: Move system register accessors to asm/cp15.h
      ARM: gic-v3: Introduce 32-to-64-bit mappings for GICv3 cpu registers
      ARM: KVM: Support vgic-v3
      arm64: KVM: Remove duplicating init code for setting VMID

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  38 ++++
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt  | 206 +++++++++++++++++++++
 Documentation/virtual/kvm/devices/arm-vgic.txt     |  52 ++----
 Documentation/virtual/kvm/devices/vcpu.txt         |   4 +-
 arch/arm/include/asm/arch_gicv3.h                  | 100 ++++++++--
 arch/arm/include/asm/cp15.h                        |  15 ++
 arch/arm/include/asm/cputype.h                     |   1 +
 arch/arm/include/asm/kvm_asm.h                     |   7 +
 arch/arm/include/asm/kvm_emulate.h                 |  35 +++-
 arch/arm/include/asm/kvm_host.h                    |   5 +
 arch/arm/include/asm/kvm_hyp.h                     |  18 +-
 arch/arm/include/asm/kvm_mmu.h                     |  28 +--
 arch/arm/include/uapi/asm/kvm.h                    |   7 +
 arch/arm/kvm/Makefile                              |   3 +
 arch/arm/kvm/arm.c                                 |  12 +-
 arch/arm/kvm/coproc.c                              |  35 ++++
 arch/arm/kvm/emulate.c                             | 111 ++---------
 arch/arm/kvm/handle_exit.c                         |  49 +++--
 arch/arm/kvm/hyp/Makefile                          |   1 +
 arch/arm/kvm/hyp/entry.S                           |  31 ++++
 arch/arm/kvm/hyp/hyp-entry.S                       |  16 +-
 arch/arm/kvm/hyp/switch.c                          |  25 ++-
 arch/arm/kvm/hyp/tlb.c                             |  15 +-
 arch/arm/kvm/mmio.c                                |   6 -
 arch/arm/kvm/mmu.c                                 |   7 +-
 arch/arm64/include/asm/arch_gicv3.h                |  13 ++
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_asm.h                   |   9 +-
 arch/arm64/include/asm/kvm_emulate.h               |  11 ++
 arch/arm64/include/asm/kvm_hyp.h                   |   1 +
 arch/arm64/include/asm/kvm_mmu.h                   |   6 -
 arch/arm64/kvm/Kconfig                             |   4 +-
 arch/arm64/kvm/Makefile                            |   3 +-
 arch/arm64/kvm/handle_exit.c                       |  23 +++
 arch/arm64/kvm/hyp/Makefile                        |   2 +-
 arch/arm64/kvm/hyp/debug-sr.c                      |   4 +-
 arch/arm64/kvm/hyp/entry.S                         | 128 ++++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S                     |  73 +++++---
 arch/arm64/kvm/hyp/switch.c                        |  84 +++++++--
 arch/arm64/kvm/hyp/tlb.c                           |  13 +-
 arch/arm64/kvm/inject_fault.c                      |  12 ++
 include/kvm/arm_vgic.h                             |  18 +-
 arch/arm64/kvm/emulate.c => virt/kvm/arm/aarch32.c |  25 +--
 virt/kvm/arm/arch_timer.c                          |   6 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c                      |  57 ++++++
 {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v3-sr.c  |  17 +-
 virt/kvm/arm/pmu.c                                 |   8 +
 virt/kvm/arm/vgic/vgic-init.c                      |   4 +
 virt/kvm/arm/vgic/vgic-irqfd.c                     |   6 -
 virt/kvm/arm/vgic/vgic-kvm-device.c                | 133 ++++++++-----
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |   8 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   2 -
 virt/kvm/arm/vgic/vgic-mmio.h                      |   4 +-
 virt/kvm/arm/vgic/vgic-v2.c                        |  71 ++++---
 virt/kvm/arm/vgic/vgic.c                           |   8 +-
 virt/kvm/arm/vgic/vgic.h                           |  54 +-----
 56 files changed, 1076 insertions(+), 562 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-its.txt
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt
 rename arch/arm64/kvm/emulate.c => virt/kvm/arm/aarch32.c (90%)
 rename {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v3-sr.c (94%)
