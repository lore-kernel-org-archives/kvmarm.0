From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v2 00/11] arm64/firmware: Software Delegated Exception Interface
Date: Tue,  8 Aug 2017 17:46:05 +0100
Message-ID: <20170808164616.25949-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hello!

The Software Delegated Exception Interface (SDEI) is an ARM specification
for registering callbacks from the platform firmware into the OS.
This is intended to be used to implement firmware-first RAS notifications,
but also supports vendor-defined events and binding IRQs as events.

The document is here:
http://infocenter.arm.com/help/topic/com.arm.doc.den0054a/ARM_DEN0054A_Software_Delegated_Exception_Interface.pdf

The major change in v2 is the way SDEI is exposed to KVM's user space. Now the
KVM SDEI capability has to be enabled to cause the SDEI portion of the
SMC-CC range to be handed to userspace as an 'hypercall' exit. This is intended
to be extended with any other SMC-CC ranges that we want handled by user space.


This series (juggles some registers with KVM+VHE, then) adds a DT binding to
trigger probing of the interface and support for the SDEI API.
The ACPI spec has the necessary parts to enable this to be used as a GHES
notification, I will post the patches to wire this up once the acpica support
has been merged [0].


SDEI runs between adjacent exception levels, so events will always be delivered
to EL2 if firmware is at EL3. For VHE hosts we run the SDEI event handler
behind KVM's back with all exceptions masked. Once the handler has done its
work we return to the appropriate vbar+irq entry. This allows KVM to
world-switch and deliver any signals sent by the handler to Qemu/kvmtool. We
do the same thing if we interrupt host EL0. If we interrupted code with
interrupts masked, we use a different API call to return to the interrupted
context.

What about non-VHE KVM? If you don't have VHE support and boot at EL2, the
kernel drops to EL1. This driver will print an error message then give up. This
is because events would still be delivered to EL2 hitting either KVM, or the
hyp-stub. Supporting this is complicated, but because the main use-case is
RAS, and ARM v8.2's RAS extensions imply v8.1's Virtual Host Extensions, we
can assume all platforms with SDEI will support VHE too. (I have some ideas
on how to support non-VHE if it turns out to be needed).

Running the event handler behind VHE-KVM's back has some side effects: The
event handler will blindly use any registers that are shared between the host
and guest. The two that I think matter are TPIDR_EL1, and the debug state. The
guest may have set MDSCR_EL1 so debug exceptions must remain masked. The
guest's TPIDR_EL1 will be used by the event handler if it accesses per-cpu
variables. This needs fixing. The first part of this series juggles KVMs use
of TPIDR_EL2 so that we share it with the host on VHE systems. An equivalent
change for 32bit is (still) on my todo list. (the alternative to this is to
have a parody world switch in the SDEI event handler, but this would mean
special casing interrupted guests, and be an ABI link to KVM.)

Is this another begins-with-S RAS mechanism for arm64? Yes.
Why? Any notification delivered as an exception will overwrite the exception
registers. This is fatal for the running thread if it happens during entry.S's
kernel_enter or kernel_exit. Instead of adding masking and routing controls,
events are delivered to a registered address at a fixed exception level and
don't change the exception registers when delivered.

This series can be retrieved from:
git://linux-arm.org/linux-jm.git -b sdei/v2/base

Questions and contradictions welcome!

Thanks,

James

[0] https://patchwork.kernel.org/patch/9878175/

Changes since v1:
 * Bug-fixes:
   * get_context is guaranteed to succeed, but magically fails if the returned
     register contained an error code...
   * sdei_event_register() allocates memory, pass gfp_t flags in to allow use
     during initcalls that have irqs masked.
   * Made the cpu_copy_el2regs() 'have I been patched' test re-store 0 in
     do_copyregs, just in case the compiler puts do_copyregs on the stack.

 * Review:
   * Have a CAP that needs enabling to pass SDEI HVC range to user space
   * Populate kvm_run structure
   * Update documents...
   * Described IRQ use-case in binding doc, referenced SMC-CC
   * Moved sdei dt-node under /firmware
   * Added code to discover the node and create a platform device, (sdei_init()
     may look funny, it gets extended to do ACPI too once the acpica updates
     are merged)

 * To aid EL2/HYP handling to ease any future non-vhe support:
   * Moved asm into sdei-entry.S
   * Moved sdei_arch_get_entry_point() into C code
   * Changed entry point to unsigned long
   * Made number of clobbered registers a variable


James Morse (11):
  KVM: arm64: Store vcpu on the stack during __guest_enter()
  KVM: arm/arm64: Convert kvm_host_cpu_state to a static per-cpu
    allocation
  KVM: arm64: Change hyp_panic()s dependency on tpidr_el2
  arm64: alternatives: use tpidr_el2 on VHE hosts
  KVM: arm64: Stop save/restoring host tpidr_el1 on VHE
  Docs: dt: add devicetree binding for describing arm64 SDEI firmware
  firmware: arm_sdei: Add driver for Software Delegated Exceptions
  arm64: kernel: Add arch-specific SDEI entry code and CPU masking
  firmware: arm_sdei: Add support for CPU and system power states
  firmware: arm_sdei: add support for CPU private events
  KVM: arm64: Allow user-space to claim guest SMC-CC ranges for SDEI

 .../devicetree/bindings/arm/firmware/sdei.txt      |   42 +
 Documentation/virtual/kvm/api.txt                  |   12 +-
 arch/arm64/Kconfig                                 |    2 +-
 arch/arm64/include/asm/assembler.h                 |    8 +
 arch/arm64/include/asm/kvm_host.h                  |    8 +
 arch/arm64/include/asm/percpu.h                    |   11 +-
 arch/arm64/include/asm/processor.h                 |    1 +
 arch/arm64/include/asm/sdei.h                      |   48 +
 arch/arm64/kernel/Makefile                         |    1 +
 arch/arm64/kernel/asm-offsets.c                    |    2 +
 arch/arm64/kernel/cpufeature.c                     |   23 +
 arch/arm64/kernel/sdei-entry.S                     |   92 ++
 arch/arm64/kernel/sdei.c                           |  119 +++
 arch/arm64/kernel/smp.c                            |    7 +
 arch/arm64/kvm/handle_exit.c                       |   28 +-
 arch/arm64/kvm/hyp-init.S                          |    4 +
 arch/arm64/kvm/hyp/entry.S                         |   10 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |   18 +-
 arch/arm64/kvm/hyp/switch.c                        |   25 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                     |   16 +-
 arch/arm64/mm/proc.S                               |    8 +
 drivers/firmware/Kconfig                           |    8 +
 drivers/firmware/Makefile                          |    1 +
 drivers/firmware/arm_sdei.c                        | 1052 ++++++++++++++++++++
 include/linux/cpuhotplug.h                         |    1 +
 include/linux/sdei.h                               |  104 ++
 include/uapi/linux/kvm.h                           |    1 +
 include/uapi/linux/sdei.h                          |   91 ++
 virt/kvm/arm/arm.c                                 |   47 +-
 29 files changed, 1740 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/sdei.txt
 create mode 100644 arch/arm64/include/asm/sdei.h
 create mode 100644 arch/arm64/kernel/sdei-entry.S
 create mode 100644 arch/arm64/kernel/sdei.c
 create mode 100644 drivers/firmware/arm_sdei.c
 create mode 100644 include/linux/sdei.h
 create mode 100644 include/uapi/linux/sdei.h

-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
