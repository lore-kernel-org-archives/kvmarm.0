From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 27/27] KVM: arm/arm64: Don't queue VLPIs on INV/INVALL
Date: Mon, 13 Nov 2017 10:17:52 +0100
Message-ID: <20171113091752.10663-28-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E424249DD3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z9MIix40GKfK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:26 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 166EE49D86
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:26 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id l8so7822561wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:36 -0800 (PST)
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

Since VLPIs are injected directly by the hardware there's no need to
mark these as pending in software and queue them on the AP list.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c93ecd4a903b..a3754ec719c4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -292,11 +292,14 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 		irq->priority = LPI_PROP_PRIORITY(prop);
 		irq->enabled = LPI_PROP_ENABLE_BIT(prop);
 
-		vgic_queue_irq_unlock(kvm, irq, flags);
-	} else {
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		if (!irq->hw) {
+			vgic_queue_irq_unlock(kvm, irq, flags);
+			return 0;
+		}
 	}
 
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
+
 	if (irq->hw)
 		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
 
-- 
2.14.2
