From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] KVM: arm/arm64: vgic-v3: Fix off-by-one LR access
Date: Mon, 10 Apr 2017 10:19:44 +0100
Message-ID: <20170410091944.19963-3-marc.zyngier@arm.com>
References: <20170410091944.19963-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 949A740C55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 05:17:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b81SdD8LB-AN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Apr 2017 05:17:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC27340CD1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 05:17:39 -0400 (EDT)
In-Reply-To: <20170410091944.19963-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When iterating over the used LRs, be careful not to try to access
an unused LR, or even an unimplemented one if you're unlucky...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 91922c1eddc8..bce6037cf01d 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -143,7 +143,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		val = read_gicreg(ICH_VTR_EL2);
 		nr_pri_bits = vtr_to_nr_pri_bits(val);
 
-		for (i = 0; i <= used_lrs; i++) {
+		for (i = 0; i < used_lrs; i++) {
 			if (cpu_if->vgic_elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
 			else
-- 
2.11.0
