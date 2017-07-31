From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 42/59] KVM: arm/arm64: GICv4: Handle INT command applied to
 a VLPI
Date: Mon, 31 Jul 2017 18:26:20 +0100
Message-ID: <20170731172637.29355-43-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4661240D44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m8BdEojHWsM8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:27:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D3BB49C3A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:05 -0400 (EDT)
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

If the guest issues an INT command targetting a VLPI, let's
call into the irq_set_irqchip_state() helper to make it pending
on the physical side.

This works just as well if userspace decides to inject an interrupt
using the normal userspace API...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a2217f53bbe5..40aeadef33fe 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -573,6 +573,10 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	if (err)
 		return err;
 
+	if (irq->hw)
+		return irq_set_irqchip_state(irq->host_irq,
+					     IRQCHIP_STATE_PENDING, true);
+
 	spin_lock(&irq->irq_lock);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq);
-- 
2.11.0
