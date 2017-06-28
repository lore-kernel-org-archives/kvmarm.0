From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 41/52] KVM: arm/arm64: GICv4: Unmap VLPI when freeing an LPI
Date: Wed, 28 Jun 2017 16:04:00 +0100
Message-ID: <20170628150411.15846-42-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 382E549C2B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rzSIOQ08D0fe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A7B40D6B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:38 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

When freeing an LPI (on a DISCARD command, for example), we need
to unmap the VLPI down to the physical ITS level.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 255d29837514..ed52b94e8e6d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -623,8 +623,12 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	if (ite->irq)
+	if (ite->irq) {
+		if (ite->irq->hw)
+			its_unmap_vlpi(ite->irq->host_irq);
+
 		vgic_put_irq(kvm, ite->irq);
+	}
 
 	kfree(ite);
 }
-- 
2.11.0
