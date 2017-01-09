From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 00/55] Nested Virtualization on KVM/ARM
Date: Mon,  9 Jan 2017 01:23:56 -0500
Message-ID: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6909856152242293634=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6398C403F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EF5eJnUnddwe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:23:51 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C0A5400FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:50 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWWr017300
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:32 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 4BF4A83
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:32 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 0F0BC92
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:32 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PVXC056384
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:31 -0500
Received: by mail-qt0-f200.google.com with SMTP id l7so63073391qtd.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:31 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

--===============6909856152242293634==
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit

Nested virtualization is the ability to run a virtual machine inside another
virtual machine. In other words, it’s about running a hypervisor (the guest
hypervisor) on top of another hypervisor (the host hypervisor).

This series supports nested virtualization on arm64. ARM recently announced an
extension (ARMv8.3) which has support for nested virtualization[1]. This series
is based on the ARMv8.3 specification.

Supporting nested virtualization means that the hypervisor provides not only
EL0/EL1 execution environment with VMs as it usually does, but also the
virtualization extensions including EL2 execution environment with the VMs.
Once the host hypervisor provides those execution environment with the VMs,
then the guest hypervisor can run its own VMs (nested VMs) naturally.

To support nested virtualization on ARM the hypervisor must emulate a virtual
execution environment consisting of EL2, EL1, and EL0, as the guest hypervisor
will run in a virtual EL2 mode.  Normally KVM/ARM only emulated a VM supporting
EL1/0 running in their respective native CPU modes, but with nested
virtualization we deprivilege the guest hypervisor and emulate a virtual EL2
execution mode in EL1 using the hardware features provided by ARMv8.3 to trap
EL2 operations to EL1. To do that the host hypervisor needs to manage EL2
register state for the guest hypervisor, and shadow EL1 register state that
reflects the EL2 register state to run the guest hypervisor in EL1. See patch 6
through 10 for this.

For memory virtualization, the biggest issue is that we now have more than two
stages of translation when running nested VMs. We choose to merge two stage-2
page tables (one from the guest hypervisor and the other from the host
hypervisor) and create shadow stage-2 page tables, which have mappings from the
nested VM’s physical addresses to the machine physical addresses. Stage-1
translation is done by the hardware as is done for the normal VMs.

To provide VGIC support to the guest hypervisor, we emulate the GIC
virtualization extensions using trap-and-emulate to a virtual GIC Hypervisor
Control Interface.  Furthermore, we can still use the GIC VE hardware features
to deliver virtual interrupts to the nested VM, by directly mapping the GIC
VCPU interface to the nested VM and switching the content of the GIC Hypervisor
Control interface when alternating between a nested VM and a normal VM.  See
patches 25 through 32, and 50 through 52 for more information.

For timer virtualization, the guest hypervisor expects to have access to the
EL2 physical timer, the EL1 physical timer and the virtual timer. So, the host
hypervisor needs to provide all of them. The virtual timer is always available
to VMs. The physical timer is available to VMs via my previous patch series[3].
The EL2 physical timer is not supported yet in this RFC. We plan to support
this as it is required to run other guest hypervisors such as Xen.

Even though this work is not complete (see limitations below), I'd appreciate
early feedback on this RFC. Specifically, I'm interested in:
- Is it better to have a kernel config or to make it configurable at runtime?
- I wonder if the data structure for memory management makes sense.
- What architecture version do we support for the guest hypervisor, and how?
  For example, do we always support all architecture versions or the same
  architecture as the underlying hardware platform? Or is it better
  to make it configurable from the userspace?
- Initial comments on the overall design?

This patch series is based on kvm-arm-for-4.9-rc7 with the patch series to provide
VMs with the EL1 physical timer[2].

Git: https://github.com/columbia/nesting-pub/tree/rfc-v1

Testing:
We have tested this on ARMv8.0 (Applied Micro X-Gene)[3] since ARMv8.3 hardware
is not available yet. We have paravirtualized the guest hypervisor to trap to
EL2 as specified in ARMv8.3 specification using hvc instruction. We plan to
test this on ARMv8.3 model, and will post the result and v2 if necessary.

Limitations:
- This patch series only supports arm64, not arm. All the patches compile on
  arm, but I haven't try to boot normal VMs on it.
- The guest hypervisor with VHE (ARMv8.1) is not supported in this RFC. I have
  patches for that, but they need to be cleaned up.
- Recursive nesting (i.e. emulating ARMv8.3 in the VM) is not tested yet.
- Other hypervisors (such as Xen) on KVM are not tested.

TODO:
- Test to boot normal VMs on arm architecture
- Test this on ARMv8.3 model
- Support the guest hypervisor with VHE
- Provide the guest hypervisor with the EL2 physical timer
- Run other hypervisors such as Xen on KVM

[1] https://www.community.arm.com/processors/b/blog/posts/armv8-a-architecture-2016-additions
[2] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-December/022825.html
[3] https://www.cloudlab.us/hardware.php#utah

Christoffer Dall (27):
  arm64: Add missing TCR hw defines
  KVM: arm64: Add nesting config option
  KVM: arm64: Add KVM nesting feature
  KVM: arm64: Allow userspace to set PSR_MODE_EL2x
  KVM: arm64: Add vcpu_mode_el2 primitive to support nesting
  KVM: arm/arm64: Add virtual EL2 state emulation framework
  KVM: arm64: Set virtual EL2 context depending on the guest exception
    level
  KVM: arm64: Set shadow EL1 registers for virtual EL2 execution
  KVM: arm64: Synchronize EL1 system registers on virtual EL2 entry and
    exit
  KVM: arm64: Trap EL1 VM register accesses in virtual EL2
  KVM: arm/arm64: Add VGIC data structures for the nesting
  KVM: arm/arm64: Inject maintenance interrupts to the guest hypervisor
  KVM: arm/arm64: Remove unused params in mmu functions
  KVM: arm/arm64: Abstract stage-2 MMU state into a separate structure
  KVM: arm/arm64: Support mmu for the virtual EL2 execution
  KVM: arm64: Invalidate virtual EL2 TLB entries when needed
  KVM: arm64: Setup vttbr_el2 on each VM entry
  KVM: arm/arm64: Make mmu functions non-static
  KVM: arm/arm64: Unmap/flush shadow stage 2 page tables
  KVM: arm64: Implement nested Stage-2 page table walk logic
  KVM: arm/arm64: Handle shadow stage 2 page faults
  KVM: arm/arm64: Move kvm_is_write_fault to header file
  KVM: arm64: KVM: Inject stage-2 page faults
  KVM: arm64: Add more info to the S2 translation result
  KVM: arm/arm64: Forward the guest hypervisor's stage 2 permission
    faults
  KVM: arm64: Emulate TLBI instruction
  KVM: arm64: Fixes to toggle_cache for nesting

Jintack Lim (28):
  KVM: arm64: Add EL2 execution context for nesting
  KVM: arm64: Emulate taking an exception to the guest hypervisor
  KVM: arm64: Handle EL2 register access traps
  KVM: arm64: Handle eret instruction traps
  KVM: arm64: Take account of system instruction traps
  KVM: arm64: Forward VM reg traps to the guest hypervisor
  KVM: arm64: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 in virtual EL2
  KVM: arm64: Forward traps due to HCR_EL2.NV1 bit to the guest
    hypervisor
  KVM: arm64: Trap CPACR_EL1 access in virtual EL2
  KVM: arm64: Forward CPACR_EL1 traps to the guest hypervisor
  KVM: arm64: Forward HVC instruction to the guest hypervisor
  KVM: arm64: Handle PSCI call from the guest
  KVM: arm64: Forward WFX to the guest hypervisor
  KVM: arm64: Forward FP exceptions to the guest hypervisor
  KVM: arm/arm64: Let vcpu thread modify its own active state
  KVM: arm/arm64: Emulate GICH interface on GICv2
  KVM: arm/arm64: Prepare vgic state for the nested VM
  KVM: arm/arm64: Set up the prepared vgic state
  KVM: arm/arm64: Inject irqs to the guest hypervisor
  KVM: arm/arm64: register GICH iodev for the guest hypervisor
  KVM: arm/arm64: Add mmu context for the nesting
  KVM: arm/arm64: Handle vttbr_el2 write operation from the guest
    hypervisor
  KVM: arm/arm64: Abstract kvm_phys_addr_ioremap() function
  KVM: arm64: Expose physical address of vcpu interface
  KVM: arm/arm64: Create a vcpu mapping for the nested VM
  KVM: arm64: Reflect shadow VMPIDR_EL2 value to MPIDR_EL1
  KVM: arm/arm64: Adjust virtual offset considering nesting
  KVM: arm64: Enable nested virtualization

 arch/arm/include/asm/kvm_asm.h         |   7 +-
 arch/arm/include/asm/kvm_emulate.h     |  54 ++++
 arch/arm/include/asm/kvm_host.h        |  34 ++-
 arch/arm/include/asm/kvm_mmu.h         |  39 +++
 arch/arm/kvm/arm.c                     |  79 ++++--
 arch/arm/kvm/hyp/switch.c              |   3 +-
 arch/arm/kvm/hyp/tlb.c                 |  15 +-
 arch/arm/kvm/mmio.c                    |  12 +-
 arch/arm/kvm/mmu.c                     | 386 +++++++++++++++++--------
 arch/arm64/include/asm/esr.h           |   2 +
 arch/arm64/include/asm/kvm_arm.h       |   3 +
 arch/arm64/include/asm/kvm_asm.h       |   7 +-
 arch/arm64/include/asm/kvm_coproc.h    |   2 +-
 arch/arm64/include/asm/kvm_emulate.h   |  68 +++++
 arch/arm64/include/asm/kvm_host.h      |  96 ++++++-
 arch/arm64/include/asm/kvm_mmu.h       | 110 +++++++-
 arch/arm64/include/asm/kvm_nested.h    |   7 +
 arch/arm64/include/asm/pgtable-hwdef.h |   6 +
 arch/arm64/include/uapi/asm/kvm.h      |   7 +
 arch/arm64/kernel/asm-offsets.c        |   1 +
 arch/arm64/kvm/Kconfig                 |   6 +
 arch/arm64/kvm/Makefile                |   7 +-
 arch/arm64/kvm/context.c               | 212 ++++++++++++++
 arch/arm64/kvm/emulate-nested.c        |  66 +++++
 arch/arm64/kvm/guest.c                 |   2 +
 arch/arm64/kvm/handle_exit.c           |  62 +++-
 arch/arm64/kvm/handle_exit_nested.c    |  51 ++++
 arch/arm64/kvm/hyp/entry.S             |  14 +
 arch/arm64/kvm/hyp/hyp-entry.S         |   2 +-
 arch/arm64/kvm/hyp/switch.c            |  15 +-
 arch/arm64/kvm/hyp/sysreg-sr.c         | 109 +++----
 arch/arm64/kvm/hyp/tlb.c               |  16 +-
 arch/arm64/kvm/mmu-nested.c            | 501 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c                 |   8 +
 arch/arm64/kvm/sys_regs.c              | 287 ++++++++++++++++++-
 arch/arm64/kvm/sys_regs.h              |   7 +
 arch/arm64/kvm/trace.h                 |  43 ++-
 include/kvm/arm_vgic.h                 |  36 ++-
 virt/kvm/arm/arch_timer.c              |   3 +-
 virt/kvm/arm/hyp/timer-sr.c            |   5 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c          |  15 +-
 virt/kvm/arm/vgic/vgic-init.c          |   3 +
 virt/kvm/arm/vgic/vgic-mmio.c          |  11 +-
 virt/kvm/arm/vgic/vgic-v2-nested.c     | 346 +++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c            |  13 +
 virt/kvm/arm/vgic/vgic.c               |  23 ++
 virt/kvm/arm/vgic/vgic.h               |  17 ++
 47 files changed, 2542 insertions(+), 276 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/kvm/context.c
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/handle_exit_nested.c
 create mode 100644 arch/arm64/kvm/mmu-nested.c
 create mode 100644 virt/kvm/arm/vgic/vgic-v2-nested.c

-- 
1.9.1



--===============6909856152242293634==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6909856152242293634==--
