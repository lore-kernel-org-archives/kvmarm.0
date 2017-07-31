From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 33/59] irqchip/gic-v4: Add some basic documentation
Date: Mon, 31 Jul 2017 18:26:11 +0100
Message-ID: <20170731172637.29355-34-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4580249C3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ie5oWhcjF7UB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B821E49C7C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:44 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Do a braindump of the way things are supposed to work.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c | 71 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 6fe2e09172ed..d10d73477d01 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -22,6 +22,77 @@
 
 #include <linux/irqchip/arm-gic-v4.h>
 
+/*
+ * WARNING: The blurb below assumes that you understand the
+ * intricacies of GICv3, GICv4, and how a guest's view of a GICv3 gets
+ * translated into GICv4 commands. So it effectively targets at most
+ * two individuals. You know who you are.
+ *
+ * The core GICv4 code is designed to *avoid* exposing too much of the
+ * core GIC code (that would in turn leak into the hypervisor code),
+ * and instead provide a hypervisor agnostic interface to the HW (of
+ * course, the astute reader will quickly realize that hypervisor
+ * agnostic actually means KVM-specific - what were you thinking?).
+ *
+ * In order to achieve a modicum of isolation, we try to hide most of
+ * the GICv4 "stuff" behind normal irqchip operations:
+ *
+ * - Any guest-visible VLPI is backed by a Linux interrupt (and a
+ *   physical LPI which gets unmapped when the guest maps the
+ *   VLPI). This allows the same DevID/EventID pair to be either
+ *   mapped to the LPI (host) or the VLPI (guest). Note that this is
+ *   exclusive, and you cannot have both.
+ *
+ * - Enabling/disabling a VLPI is done by issuing mask/unmask calls.
+ *
+ * - Guest INT/CLEAR commands are implemented through
+ *   irq_set_irqchip_state().
+ *
+ * - The *bizarre* stuff (mapping/unmapping an interrupt to a VLPI, or
+ *   issuing an INV after changing a priority) gets shoved into the
+ *   irq_set_vcpu_affinity() method. While this is quite horrible
+ *   (let's face it, this is the irqchip version of an ioctl), it
+ *   confines the crap to a single location. And map/unmap really is
+ *   about setting the affinity of a VLPI to a vcpu, so only INV is
+ *   majorly out of place. So there.
+ *
+ * A number of commands are simply not provided by this interface, as
+ * they do not make direct sense. For example, MAPD is purely local to
+ * the virtual ITS (because it references a virtual device, and the
+ * physical ITS is still very much in charge of the physical
+ * device). Same goes for things like MAPC (the physical ITS deals
+ * with the actual vPE affinity, and not the braindead concept of
+ * collection). SYNC is not provided either, as each and every command
+ * is followed by a VSYNC. This could be relaxed in the future, should
+ * this be seen as a bottleneck (yes, this means *never*).
+ *
+ * But handling VLPIs is only one side of the job of the GICv4
+ * code. The other (darker) side is to take care of the doorbell
+ * interrupts which are delivered when a VLPI targeting a non-running
+ * vcpu is being made pending.
+ *
+ * The choice made here is that each vcpu (VPE in old northern GICv4
+ * dialect) gets a single doorbell LPI, no matter how many interrupts
+ * are targeting it. This has a nice property, which is that the
+ * interrupt becomes a handle for the VPE, and that the hypervisor
+ * code can manipulate it through the normal interrupt API:
+ *
+ * - VMs (or rather the VM abstraction that matters to the GIC)
+ *   contain an irq domain where each interrupt maps to a VPE. In
+ *   turn, this domain sits on top of the normal LPI allocator, and a
+ *   specially crafted irq_chip implementation.
+ *
+ * - mask/unmask do what is expected on the doorbell interrupt.
+ *
+ * - irq_set_affinity is used to move a VPE from one redistributor to
+ *   another.
+ *
+ * - irq_set_vcpu_affinity once again gets hijacked for the purpose of
+ *   creating a new sub-API, namely scheduling/descheduling a VPE
+ *   (which involves programming GICR_V{PROP,PEND}BASER) and
+ *   performing INVALL operations.
+ */
+
 static struct irq_domain *gic_domain;
 static const struct irq_domain_ops *vpe_domain_ops;
 
-- 
2.11.0
