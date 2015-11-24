From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 6/8] KVM: arm/arm64: vgic: Trust the LR state for HW IRQs
Date: Tue, 24 Nov 2015 18:35:34 +0100
Message-ID: <1448386536-30118-7-git-send-email-christoffer.dall@linaro.org>
References: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAACD49790
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oEP4pv+feZHW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:34:25 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B48A41145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:24 -0500 (EST)
Received: by wmec201 with SMTP id c201so220449075wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:35:22 -0800 (PST)
In-Reply-To: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We were probing the physial distributor state for the active state of a
HW virtual IRQ, because we had seen evidence that the LR state was not
cleared when the guest deactivated a virtual interrupted.

However, this issue turned out to be a software bug in the GIC, which
was solved by: 84aab5e68c2a5e1e18d81ae8308c3ce25d501b29
(KVM: arm/arm64: arch_timer: Preserve physical dist. active
state on LR.active, 2015-11-24)

Therefore, get rid of the complexities and just look at the LR.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 97e2c08..65461f8 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1417,25 +1417,13 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	struct irq_phys_map *map;
-	bool phys_active;
 	bool level_pending;
-	int ret;
 
 	if (!(vlr.state & LR_HW))
 		return false;
 
-	map = vgic_irq_map_search(vcpu, vlr.irq);
-	BUG_ON(!map);
-
-	ret = irq_get_irqchip_state(map->irq,
-				    IRQCHIP_STATE_ACTIVE,
-				    &phys_active);
-
-	WARN_ON(ret);
-
-	if (phys_active)
-		return 0;
+	if (vlr.state & LR_STATE_ACTIVE)
+		return false;
 
 	spin_lock(&dist->lock);
 	level_pending = process_queued_irq(vcpu, lr, vlr);
-- 
2.1.2.330.g565301e.dirty
