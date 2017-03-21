From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 04/10] KVM: arm/arm64: vgic: Only set underflow when
 actually out of LRs
Date: Tue, 21 Mar 2017 22:10:53 +0100
Message-ID: <20170321211059.8719-5-cdall@linaro.org>
References: <20170321211059.8719-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82AEA40C7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e0ruu6V10ZPL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 17:09:18 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 138C940C4E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:18 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id n11so21249237wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:11:05 -0700 (PDT)
In-Reply-To: <20170321211059.8719-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently assume that all the interrupts in our AP list will be
queued to LRs, but that's not necessarily the case, because some of them
could have been migrated away to different VCPUs and only the VCPU
thread itself can remove interrupts from its AP list.

Therefore, slightly change the logic to only setting the underflow
interrupt when we actually run out of LRs.

As it turns out, this allows us to further simplify the handling in
vgic_sync_hwstate in later patches.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
Changes since v1:
 - New patch

 virt/kvm/arm/vgic/vgic.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 1043291..442f7df 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -601,10 +601,8 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
 
-	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr) {
-		vgic_set_underflow(vcpu);
+	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr)
 		vgic_sort_ap_list(vcpu);
-	}
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
@@ -623,8 +621,12 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 next:
 		spin_unlock(&irq->irq_lock);
 
-		if (count == kvm_vgic_global_state.nr_lr)
+		if (count == kvm_vgic_global_state.nr_lr) {
+			if (!list_is_last(&irq->ap_list,
+					  &vgic_cpu->ap_list_head))
+				vgic_set_underflow(vcpu);
 			break;
+		}
 	}
 
 	vcpu->arch.vgic_cpu.used_lrs = count;
-- 
2.9.0
