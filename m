From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v6 00/16] arm64/firmware: Software Delegated Exception Interface
Date: Mon,  8 Jan 2018 15:38:02 +0000
Message-ID: <20180108153818.22743-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series is rebased onto arm64's kpti-base tag, with v2 of Will's kpti
series[0]. The changes were only due to code moving around, but its now
all been tested together. As before patches 15 and 16 contain the extra
kpti trampoline stuff.

The Software Delegated Exception Interface (SDEI) is an ARM specification
for registering callbacks from the platform firmware into the OS.
This is intended to be used to implement firmware-first RAS notifications,
but also supports vendor-defined events and binding IRQs as events.

The document is here:
http://infocenter.arm.com/help/topic/com.arm.doc.den0054a/ARM_DEN0054A_Software_
Delegated_Exception_Interface.pdf

I anticipate once reviewed this series will go via the arm64 tree as it has
an ever closer interaction with the arch code. Despite the bulk of the code
being under /drivers/firmware/.

The relevant change in v5 was a three-way lockdep issue via the hotplug
state machine. (I argue it can't happen, but lockdep doesn't care.) Now the
hotplug callbacks save nothing, and restore the OS-view of registered/enabled.
This makes bound-interrupts harder to work with. I dropped Catalin's ack on
all affected patches.

For your regular boiler-plate cover-letter, please see [1].

Thanks,

James

[0] https://www.spinics.net/lists/arm-kernel/msg626876.html
[1] https://patchwork.ozlabs.org/cover/845290/


James Morse (16):
  KVM: arm64: Store vcpu on the stack during __guest_enter()
  KVM: arm/arm64: Convert kvm_host_cpu_state to a static per-cpu
    allocation
  KVM: arm64: Change hyp_panic()s dependency on tpidr_el2
  arm64: alternatives: use tpidr_el2 on VHE hosts
  KVM: arm64: Stop save/restoring host tpidr_el1 on VHE
  Docs: dt: add devicetree binding for describing arm64 SDEI firmware
  firmware: arm_sdei: Add driver for Software Delegated Exceptions
  arm64: Add vmap_stack header file
  arm64: uaccess: Add PAN helper
  arm64: kernel: Add arch-specific SDEI entry code and CPU masking
  firmware: arm_sdei: Add support for CPU and system power states
  firmware: arm_sdei: add support for CPU private events
  arm64: acpi: Remove __init from acpi_psci_use_hvc() for use by SDEI
  firmware: arm_sdei: Discover SDEI support via ACPI
  arm64: mmu: add the entry trampolines start/end section markers into
    sections.h
  arm64: sdei: Add trampoline code for remapping the kernel

 .../devicetree/bindings/arm/firmware/sdei.txt      |   42 +
 MAINTAINERS                                        |    9 +
 arch/arm64/include/asm/alternative.h               |    2 +
 arch/arm64/include/asm/assembler.h                 |    8 +
 arch/arm64/include/asm/kvm_host.h                  |    2 +
 arch/arm64/include/asm/mmu.h                       |    3 +-
 arch/arm64/include/asm/percpu.h                    |   11 +-
 arch/arm64/include/asm/sdei.h                      |   57 +
 arch/arm64/include/asm/sections.h                  |    1 +
 arch/arm64/include/asm/stacktrace.h                |    3 +
 arch/arm64/include/asm/uaccess.h                   |   12 +
 arch/arm64/include/asm/vmap_stack.h                |   28 +
 arch/arm64/kernel/Makefile                         |    1 +
 arch/arm64/kernel/acpi.c                           |    2 +-
 arch/arm64/kernel/alternative.c                    |    9 +-
 arch/arm64/kernel/asm-offsets.c                    |    5 +
 arch/arm64/kernel/cpufeature.c                     |   17 +
 arch/arm64/kernel/entry.S                          |  177 ++++
 arch/arm64/kernel/irq.c                            |   13 +-
 arch/arm64/kernel/sdei.c                           |  235 +++++
 arch/arm64/kernel/smp.c                            |   11 +-
 arch/arm64/kernel/suspend.c                        |    4 +-
 arch/arm64/kvm/hyp-init.S                          |    4 +
 arch/arm64/kvm/hyp/entry.S                         |   10 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |   18 +-
 arch/arm64/kvm/hyp/switch.c                        |   25 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                     |   16 +-
 arch/arm64/mm/mmu.c                                |    2 -
 arch/arm64/mm/proc.S                               |    8 +
 drivers/firmware/Kconfig                           |    8 +
 drivers/firmware/Makefile                          |    1 +
 drivers/firmware/arm_sdei.c                        | 1091 ++++++++++++++++++++
 include/linux/arm_sdei.h                           |   79 ++
 include/linux/cpuhotplug.h                         |    1 +
 include/linux/psci.h                               |    3 +-
 include/uapi/linux/arm_sdei.h                      |   73 ++
 virt/kvm/arm/arm.c                                 |   18 +-
 37 files changed, 1943 insertions(+), 66 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/sdei.txt
 create mode 100644 arch/arm64/include/asm/sdei.h
 create mode 100644 arch/arm64/include/asm/vmap_stack.h
 create mode 100644 arch/arm64/kernel/sdei.c
 create mode 100644 drivers/firmware/arm_sdei.c
 create mode 100644 include/linux/arm_sdei.h
 create mode 100644 include/uapi/linux/arm_sdei.h

-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
