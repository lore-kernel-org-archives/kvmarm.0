From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 00/37] Optimize KVM/ARM for VHE systems
Date: Thu, 12 Oct 2017 12:41:04 +0200
Message-ID: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E12349D5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4kSBJAYM7Y6r for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:40:58 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE13E49D25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:40:58 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id i124so12072247wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:43 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This series redesigns parts of KVM/ARM to optimize the performance on
VHE systems.  The general approach is to try to do as little work as
possible when transitioning betwen the VM and the hypervisor.  This has
the benefit of lower latency when waiting for interrupts and delivering
virtual interrupts, and reduces the overhead of emulating behavior and
I/O in the host kernel.

Patches 01 through 04 are not VHE specific, but rework parts of KVM/ARM
that can be generally improved.  We then add infrastructure to move more
logic into vcpu_load and vcpu_put, we improve handling of VFP and debug
registers.

We then introduce a new world-switch function for VHE systems, which we
can tweak and optimize for VHE systems.  To do that, we rework a lot of
the sytem register save/restore handling and emulation code that may
need access to system registers, so that we can defer as many system
register save/restore operations to vcpu_load and vcpu_put, and move
this logic out of the VHE world switch function.

We then optimize the configuration of traps.  On non-VHE systems, both
the host and VM kernels run in EL1, but because the host kernel should
have full access to the underlying hardware, but the VM kernel should
not, we essentially make the host kernel more privieleged than the VM
kernel despite them both running at the same privilege level by enabling
VE traps when entering the VM and disabling those traps when exiting the
VM.  On VHE systems, the host kernel runs in EL2 and has full access to
the hardware (as much as allowed by secure side software), and is
unaffected by the trap configuration.  That means we can configure the
traps for VMs running in EL1 once, and don't have to switch them on and
off for every entry/exit to/from the VM.

Finally, we improve our VGIC handling by moving all save/restore logic
out of the VHE world-switch, and we make it possible to truly only
evaluate if the AP list is empty and not do *any* VGIC work if that is
the case, and only do the minimal amount of work required in the course
of the VGIC processing when we have virtual interrupts in flight.

The patches are based on v4.14-rc2 plus the timer optimization series
[1] and the patches that use the TPIDR_EL2 for per-cpu offsets in the
host kernel and stops storing the VCPU pointer in TPIDR_EL2 from the
SDEI series [2].

I've given the patches a fair amount of testing on Thunder-X, Mustang,
Seattle, and TC2 (32-bit) for non-VHE testing, and tested VHE
functionality on the Foundation model, running both 64-bit VMs and
32-bit VMs side-by-side and using both GICv3-on-GICv3 and
GICv2-on-GICv3.

The paches are also available in the vhe-optimize branch on my
kernel.org repository [3].

Thanks,
-Christoffer

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2017-September/027245.html
[2]: https://lists.cs.columbia.edu/pipermail/kvmarm/2017-September/027230.html
[3]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git vhe-optimize

Christoffer Dall (36):
  KVM: arm64: Avoid storing the vcpu pointer on the stack
  KVM: arm64: Rework hyp_panic for VHE and non-VHE
  KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
  KVM: Record the executing ioctl number on the vcpu struct
  KVM: arm/arm64: Only load/put VCPU state for KVM_RUN
  KVM: arm/arm64: Add kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs
  KVM: arm64: Defer restoring host VFP state to vcpu_put
  KVM: arm64: Move debug dirty flag calculation out of world switch
  KVM: arm64: Slightly improve debug save/restore functions
  KVM: arm64: Improve debug register save/restore flow
  KVM: arm64: Factor out fault info population and gic workarounds
  KVM: arm64: Introduce VHE-specific kvm_vcpu_run
  KVM: arm64: Remove kern_hyp_va() use in VHE switch function
  KVM: arm64: Don't deactivate VM on VHE systems
  KVM: arm64: Remove noop calls to timer save/restore from VHE switch
  KVM: arm64: Move userspace system registers into separate function
  KVM: arm64: Rewrite sysreg alternatives to static keys
  KVM: arm64: Introduce separate VHE/non-VHE sysreg save/restore
    functions
  KVM: arm64: Unify non-VHE host/guest sysreg save and restore functions
  KVM: arm64: Don't save the host ELR_EL2 and SPSR_EL2 on VHE systems
  KVM: arm64: Change 32-bit handling of VM system registers
  KVM: arm64: Prepare to handle traps on deferred VM sysregs
  KVM: arm64: Prepare to handle traps on deferred EL0 sysregs
  KVM: arm64: Prepare to handle traps on remaining deferred EL1 sysregs
  KVM: arm64: Prepare to handle traps on deferred AArch32 sysregs
  KVM: arm64: Defer saving/restoring system registers to vcpu load/put
    on VHE
  KVM: arm64: Move common VHE/non-VHE trap config in separate functions
  KVM: arm64: Configure FPSIMD traps on vcpu load/put for VHE
  KVM: arm64: Configure c15, PMU, and debug register traps on cpu
    load/put for VHE
  KVM: arm64: Separate activate_traps and deactive_traps for VHE and
    non-VHE
  KVM: arm/arm64: Handle VGICv2 save/restore from the main VGIC code
  KVM: arm/arm64: Move arm64-only vgic-v2-sr.c file to arm64
  KVM: arm/arm64: Handle VGICv3 save/restore from the main VGIC code on
    VHE
  KVM: arm/arm64: Get rid of vgic_elrsr
  KVM: arm/arm64: Move VGIC APR save/restore to vgic put/load
  KVM: arm/arm64: Avoid VGICv3 save/restore on VHE with no IRQs

Shih-Wei Li (1):
  KVM: arm64: Move HCR_INT_OVERRIDE to default HCR_EL2 guest flag

 arch/arm/include/asm/kvm_asm.h       |   4 +
 arch/arm/include/asm/kvm_emulate.h   |   9 +-
 arch/arm/include/asm/kvm_host.h      |   6 +-
 arch/arm/include/asm/kvm_hyp.h       |   4 +
 arch/arm/kvm/emulate.c               |   2 +-
 arch/arm/kvm/hyp/Makefile            |   1 -
 arch/arm/kvm/hyp/switch.c            |  14 +-
 arch/arm64/include/asm/kvm_arm.h     |   4 +-
 arch/arm64/include/asm/kvm_asm.h     |  22 ++
 arch/arm64/include/asm/kvm_emulate.h |  22 +-
 arch/arm64/include/asm/kvm_host.h    |  21 +-
 arch/arm64/include/asm/kvm_hyp.h     |  29 +--
 arch/arm64/kernel/asm-offsets.c      |   2 +
 arch/arm64/kvm/debug.c               |   9 +
 arch/arm64/kvm/hyp/Makefile          |   2 +-
 arch/arm64/kvm/hyp/debug-sr.c        |  84 ++++----
 arch/arm64/kvm/hyp/entry.S           |   8 +-
 arch/arm64/kvm/hyp/hyp-entry.S       |  39 ++--
 arch/arm64/kvm/hyp/switch.c          | 392 ++++++++++++++++++++---------------
 arch/arm64/kvm/hyp/sysreg-sr.c       | 160 +++++++++++---
 arch/arm64/kvm/hyp/vgic-v2-sr.c      |  77 +++++++
 arch/arm64/kvm/inject_fault.c        |  93 ++++++++-
 arch/arm64/kvm/sys_regs.c            |  76 ++++++-
 arch/arm64/kvm/sys_regs_generic_v8.c |   5 +-
 arch/x86/kvm/vmx.c                   |   2 +-
 arch/x86/kvm/x86.c                   |   8 +-
 include/kvm/arm_vgic.h               |   2 -
 include/linux/kvm_host.h             |   3 +-
 virt/kvm/arm/arm.c                   |  24 ++-
 virt/kvm/arm/hyp/timer-sr.c          |  10 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c        | 162 ---------------
 virt/kvm/arm/hyp/vgic-v3-sr.c        | 239 ++++++++++++---------
 virt/kvm/arm/mmu.c                   |   6 +-
 virt/kvm/arm/vgic/vgic-init.c        |  22 +-
 virt/kvm/arm/vgic/vgic-v2.c          |  72 ++++++-
 virt/kvm/arm/vgic/vgic-v3.c          |  12 +-
 virt/kvm/arm/vgic/vgic.c             |  22 ++
 virt/kvm/arm/vgic/vgic.h             |   5 +
 virt/kvm/kvm_main.c                  |   6 +-
 39 files changed, 1046 insertions(+), 634 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vgic-v2-sr.c
 delete mode 100644 virt/kvm/arm/hyp/vgic-v2-sr.c

-- 
2.9.0
