From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 00/33] irqchip: Core support for GICv4
Date: Tue, 17 Jan 2017 10:20:21 +0000
Message-ID: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF77A4019A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CftQ7M8GjfIf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 780EA400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:24 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

This series implements the core support for GICv4. And despite its
size, it does exactly *nothing*. What it adds is an infrastructure
that a hypervisor (KVM) can use to route VLPIs to a guest.

>From the bit of documentation that is in patch #32:

WARNING: The blurb below assumes that you understand the
intricacies of GICv3, GICv4, and how a guest's view of a GICv3 gets
translated into GICv4 commands. So it effectively targets at most
two individuals. You know who you are.

The core GICv4 code is designed to *avoid* exposing too much of the
core GIC code (that would in turn leak into the hypervisor code),
and instead provide a hypervisor agnostic interface to the HW (of
course, the astute reader will quickly realize that hypervisor
agnostic actually means KVM-specific - what were you thinking?).

In order to achieve a modicum of isolation, we try to hide most of
the GICv4 "stuff" behind normal irqchip operations:

- Any guest-visible VLPI is backed by a Linux interrupt (and a
  physical LPI which gets deconfigured when the guest maps the
  VLPI). This allows the same DevID/Event pair to be either mapped
  to the LPI (host) or the VLPI (guest).

- Enabling/disabling a VLPI is done by issuing mask/unmask calls.

- Guest INT/CLEAR commands are implemented through
  irq_set_irqchip_state().

- The *bizarre* stuff (mapping/unmapping an interrupt to a VLPI, or
  issuing an INV after changing a priority) gets shoved into the
  irq_set_vcpu_affinity() method. While this is quite horrible
  (let's face it, this is the irqchip version of an ioctl), it
  confines the crap to a single location. And map/unmap really is
  about setting the affinity of a VLPI to a vcpu, so only INV is
  majorly out of place. So there.

But handling VLPIs is only one side of the job of the GICv4
code. The other (darker) side is to take care of the doorbell
interrupts which are delivered when a VLPI targeting a non-running
vcpu is being made pending.

The choice made here is that each vcpu (VPE in old northern GICv4
dialect) gets a single doorbell, no matter how many interrupts are
targeting it. This has a nice property, which is that the interrupt
becomes a handle for the VPE, and that the hypervisor code can
manipulate it through the normal interrupt API:

- VMs (or rather the VM abstraction that matters to the GIC)
  contain an irq domain where each interrupt maps to a VPE. In
  turn, this domain sits on top of the normal LPI allocator, and a
  specially crafted irq_chip implementation.

- mask/unmask do what is expected on the doorbell interrupt.

- irq_set_affinity is used to move a VPE from one redistributor to
  another.

- irq_set_vcpu_affinity once again gets hijacked for the purpose of
  creating a new sub-API, namely scheduling/descheduling a VPE and
  performing INVALL operations.


I'm posting these patches separately from the rest of the KVM work
because:

- they are complicated enough already
- I want to keep the interface as clean as possible
- the KVM device assignment is still in a state of flux

Patches on top of v4.10-rc3.

Marc Zyngier (33):
  irqchip/gic-v3: Add redistributor iterator
  irqchip/gic-v3: Add VLPI/DirectLPI discovery
  irqchip/gic-v3-its: Refactor command encoding
  irqchip/gic-v3-its: Move LPI definitions around
  irqchip/gic-v3-its: Zero command on allocation
  irqchip/gic-v3-its: Add probing for VLPI properties
  irqchip/gic-v3-its: Macro-ize its_send_single_command
  irqchip/gic-v3-its: Implement irq_set_irqchip_state for pending state
  irqchip/gic-v3-its: Split out property table allocation
  irqchip/gic-v4-its: Allow use of indirect VCPU tables
  irqchip/gic-v3-its: Split out pending table allocation
  irqchip/gic-v3-its: Rework LPI freeing
  irqchip/gic-v3-its: Generalize device table allocation
  irqchip/gic-v3-its: Generalize LPI configuration
  irqchip/gic-v4: Add management structure definitions
  irqchip/gic-v3-its: Add GICv4 ITS command definitions
  irqchip/gic-v3-its: Add VLPI configuration hook
  irqchip/gic-v3-its: Add VLPI map/unmap operations
  irqchip/gic-v3-its: Add VLPI configuration handling
  irqchip/gic-v3-its: Add VPE domain infrastructure
  irqchip/gic-v3-its: Add VPE irq domain allocation/teardown
  irqchip/gic-v3-its: Add VPE irq domain [de]activation
  irqchip/gic-v3-its: Add VPENDBASER/VPROPBASER accessors
  irqchip/gic-v3-its: Add VPE scheduling
  irqchip/gic-v3-its: Add VPE invalidation hook
  irqchip/gic-v3-its: Add VPE affinity changes
  irqchip/gic-v3-its: Add VPE interrupt masking
  irqchip/gic-v3-its: Support VPE doorbell invalidation even when
    !DirectLPI
  irqchip/gic-v4: Add per-VM VPE domain creation
  irqchip/gic-v4: Add VPE command interface
  irqchip/gic-v4: Add VLPI configuration interface
  irqchip/gic-v4: Add some basic documentation
  irqchip/gic-v4: Enable low-level GICv4 operations

 arch/arm/include/asm/arch_gicv3.h   |   28 +
 arch/arm64/include/asm/arch_gicv3.h |    5 +
 drivers/irqchip/Makefile            |    2 +-
 drivers/irqchip/irq-gic-v3-its.c    | 1183 +++++++++++++++++++++++++++++++----
 drivers/irqchip/irq-gic-v3.c        |   99 ++-
 drivers/irqchip/irq-gic-v4.c        |  241 +++++++
 include/linux/irqchip/arm-gic-v3.h  |   82 +++
 include/linux/irqchip/arm-gic-v4.h  |  102 +++
 8 files changed, 1602 insertions(+), 140 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v4.c
 create mode 100644 include/linux/irqchip/arm-gic-v4.h

-- 
2.1.4
