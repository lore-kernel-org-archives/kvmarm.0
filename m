From: James Morse <james.morse@arm.com>
Subject: [PATCH 00/11] arm64/firmware: Software Delegated Exception Interface
Date: Mon, 15 May 2017 18:43:48 +0100
Message-ID: <20170515174400.29735-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20E2440905
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3TVvO52a3aih for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 13:42:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C3740187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:00 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hello!

The Software Delegated Exception Interface (SDEI) is an ARM specification
for registering callbacks from the platform firmware into the OS.
This is intended to be used to implement firmware-first RAS notifications.

The document is here:
http://infocenter.arm.com/help/topic/com.arm.doc.den0054a/ARM_DEN0054A_Software_Delegated_Exception_Interface.pdf

This series (juggles some registers with KVM+VHE, then) adds a DT binding to
trigger probing of the interface and support for the SDEI API.
A future version of the ACPI spec should add the necessary parts to enable this
to be used as a GHES notification.


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
change for 32bit is on my todo list. (one alternative to this is to have a
parody world switch in the SDEI event handler, but this would mean special
casing interrupted guests, and be an ABI link to KVM.)

Causing a synchronous exception from an event handler will cause KVM to
hyp-panic, but may silently succeed if the event didn't interrupt a guest.
(I may WARN_ON() if this happens in a later patch). You because of this you
should not kprobe anything that handles SDE events. Once we've called
nmi_enter(), ftrace and friends should be safe.

Is this another begins-with-S RAS mechanism for arm64? Yes.
Why? Any notification delivered as an exception will overwrite the exception
registers. This is fatal for the running thread if it happens during entry.S's
kernel_enter or kernel_exit. Instead of adding masking and routing controls,
events are delivered to a registered address at a fixed exception level and
don't change the exception registers when delivered.

This series can be retrieved from:
git://linux-arm.org/linux-jm.git -b sdei/v1/base

Questions and contradictions welcome!


James Morse (11):
  KVM: arm64: Store vcpu on the stack during __guest_enter()
  KVM: arm/arm64: Convert kvm_host_cpu_state to a static per-cpu
    allocation
  KVM: arm64: Change hyp_panic()s dependency on tpidr_el2
  arm64: alternatives: use tpidr_el2 on VHE hosts
  arm64: KVM: Stop save/restoring host tpidr_el1 on VHE
  dt-bindings: add devicetree binding for describing arm64 SDEI firmware
  firmware: arm_sdei: Add driver for Software Delegated Exceptions
  arm64: kernel: Add arch-specific SDEI entry code and CPU masking
  firmware: arm_sdei: Add support for CPU and system power states
  firmware: arm_sdei: add support for CPU private events
  KVM: arm64: Delegate support for SDEI to userspace

 Documentation/devicetree/bindings/arm/sdei.txt |   37 +
 arch/arm64/Kconfig                             |    1 +
 arch/arm64/include/asm/assembler.h             |    8 +
 arch/arm64/include/asm/kvm_host.h              |    2 +
 arch/arm64/include/asm/percpu.h                |   11 +-
 arch/arm64/include/asm/processor.h             |    1 +
 arch/arm64/include/asm/sdei.h                  |   45 +
 arch/arm64/kernel/Makefile                     |    1 +
 arch/arm64/kernel/asm-offsets.c                |    2 +
 arch/arm64/kernel/cpufeature.c                 |   22 +
 arch/arm64/kernel/entry.S                      |   68 ++
 arch/arm64/kernel/sdei.c                       |  106 +++
 arch/arm64/kernel/smp.c                        |    7 +
 arch/arm64/kvm/handle_exit.c                   |   10 +-
 arch/arm64/kvm/hyp-init.S                      |    4 +
 arch/arm64/kvm/hyp/entry.S                     |   12 +-
 arch/arm64/kvm/hyp/hyp-entry.S                 |   13 +-
 arch/arm64/kvm/hyp/switch.c                    |   25 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                 |   16 +-
 arch/arm64/mm/proc.S                           |    8 +
 drivers/firmware/Kconfig                       |    8 +
 drivers/firmware/Makefile                      |    1 +
 drivers/firmware/arm_sdei.c                    | 1055 ++++++++++++++++++++++++
 include/linux/cpuhotplug.h                     |    1 +
 include/linux/sdei.h                           |  102 +++
 include/uapi/linux/kvm.h                       |    1 +
 include/uapi/linux/sdei.h                      |   91 ++
 virt/kvm/arm/arm.c                             |   23 +-
 28 files changed, 1634 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/sdei.txt
 create mode 100644 arch/arm64/include/asm/sdei.h
 create mode 100644 arch/arm64/kernel/sdei.c
 create mode 100644 drivers/firmware/arm_sdei.c
 create mode 100644 include/linux/sdei.h
 create mode 100644 include/uapi/linux/sdei.h

-- 
2.10.1
