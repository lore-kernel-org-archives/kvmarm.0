From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 11/27] KVM: arm/arm64: GICv4: Unmap VLPI when freeing an LPI
Date: Mon, 13 Nov 2017 10:17:36 +0100
Message-ID: <20171113091752.10663-12-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When freeing an LPI (on a DISCARD command, for example), we need
to unmap the VLPI down to the physical ITS level.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 590f794b7330..ad14af8a4412 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -631,8 +631,12 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	if (ite->irq)
+	if (ite->irq) {
+		if (ite->irq->hw)
+			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+
 		vgic_put_irq(kvm, ite->irq);
+	}
 
 	kfree(ite);
 }
-- 
2.14.2
