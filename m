From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 25/27] KVM: arm/arm64: GICv4: Theory of operations
Date: Mon, 13 Nov 2017 10:17:50 +0100
Message-ID: <20171113091752.10663-26-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8001A49DC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x8rZB5CRZ4II for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:23 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ACC249DBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:23 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id b189so6525227wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:34 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Yet another braindump so I can free some cells...

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v4.c | 67 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index bf874dd01fc0..915d09dc2638 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -23,6 +23,73 @@
 
 #include "vgic.h"
 
+/*
+ * How KVM uses GICv4 (insert rude comments here):
+ *
+ * The vgic-v4 layer acts as a bridge between several entities:
+ * - The GICv4 ITS representation offered by the ITS driver
+ * - VFIO, which is in charge of the PCI endpoint
+ * - The virtual ITS, which is the only thing the guest sees
+ *
+ * The configuration of VLPIs is triggered by a callback from VFIO,
+ * instructing KVM that a PCI device has been configured to deliver
+ * MSIs to a vITS.
+ *
+ * kvm_vgic_v4_set_forwarding() is thus called with the routing entry,
+ * and this is used to find the corresponding vITS data structures
+ * (ITS instance, device, event and irq) using a process that is
+ * extremely similar to the injection of an MSI.
+ *
+ * At this stage, we can link the guest's view of an LPI (uniquely
+ * identified by the routing entry) and the host irq, using the GICv4
+ * driver mapping operation. Should the mapping succeed, we've then
+ * successfully upgraded the guest's LPI to a VLPI. We can then start
+ * with updating GICv4's view of the property table and generating an
+ * INValidation in order to kickstart the delivery of this VLPI to the
+ * guest directly, without software intervention. Well, almost.
+ *
+ * When the PCI endpoint is deconfigured, this operation is reversed
+ * with VFIO calling kvm_vgic_v4_unset_forwarding().
+ *
+ * Once the VLPI has been mapped, it needs to follow any change the
+ * guest performs on its LPI through the vITS. For that, a number of
+ * command handlers have hooks to communicate these changes to the HW:
+ * - Any invalidation triggers a call to its_prop_update_vlpi()
+ * - The INT command results in a irq_set_irqchip_state(), which
+ *   generates an INT on the corresponding VLPI.
+ * - The CLEAR command results in a irq_set_irqchip_state(), which
+ *   generates an CLEAR on the corresponding VLPI.
+ * - DISCARD translates into an unmap, similar to a call to
+ *   kvm_vgic_v4_unset_forwarding().
+ * - MOVI is translated by an update of the existing mapping, changing
+ *   the target vcpu, resulting in a VMOVI being generated.
+ * - MOVALL is translated by a string of mapping updates (similar to
+ *   the handling of MOVI). MOVALL is horrible.
+ *
+ * Note that a DISCARD/MAPTI sequence emitted from the guest without
+ * reprogramming the PCI endpoint after MAPTI does not result in a
+ * VLPI being mapped, as there is no callback from VFIO (the guest
+ * will get the interrupt via the normal SW injection). Fixing this is
+ * not trivial, and requires some horrible messing with the VFIO
+ * internals. Not fun. Don't do that.
+ *
+ * Then there is the scheduling. Each time a vcpu is about to run on a
+ * physical CPU, KVM must tell the corresponding redistributor about
+ * it. And if we've migrated our vcpu from one CPU to another, we must
+ * tell the ITS (so that the messages reach the right redistributor).
+ * This is done in two steps: first issue a irq_set_affinity() on the
+ * irq corresponding to the vcpu, then call its_schedule_vpe(). You
+ * must be in a non-preemptible context. On exit, another call to
+ * its_schedule_vpe() tells the redistributor that we're done with the
+ * vcpu.
+ *
+ * Finally, the doorbell handling: Each vcpu is allocated an interrupt
+ * which will fire each time a VLPI is made pending whilst the vcpu is
+ * not running. Each time the vcpu gets blocked, the doorbell
+ * interrupt gets enabled. When the vcpu is unblocked (for whatever
+ * reason), the doorbell interrupt is disabled.
+ */
+
 #define DB_IRQ_FLAGS	(IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY | IRQ_NO_BALANCING)
 
 static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
-- 
2.14.2
