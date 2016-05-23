From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/7] KVM: arm/arm64: vgic-v3: Clear all dirty LRs
Date: Mon, 23 May 2016 13:36:58 +0100
Message-ID: <1464007023-11736-3-git-send-email-marc.zyngier@arm.com>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79FAB49B4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2016 08:33:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NzRCvWU3KPCT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2016 08:33:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F60449B42
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2016 08:33:43 -0400 (EDT)
In-Reply-To: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When saving the state of the list registers, it is critical to
reset them zero, as we could otherwise leave unexpected EOI
interrupts pending for virtual level interrupts.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index fff7cd4..3129df9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -190,12 +190,11 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
 				continue;
 
-			if (cpu_if->vgic_elrsr & (1 << i)) {
+			if (cpu_if->vgic_elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
-				continue;
-			}
+			else
+				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 
-			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 			__gic_v3_set_lr(0, i);
 		}
 
-- 
2.1.4
