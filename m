From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 89/95] KVM: arm/arm64: vgic-v2: Only wipe LRs on vcpu exit
Date: Wed,  9 Mar 2016 07:31:23 +0000
Message-ID: <1457508689-19672-90-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B9349B77
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tmvhxcVq1XG3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 915FA49BF2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:58 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

So far, we're always writing all possible LRs, setting the empty
ones with a zero value. This is obvious doing a lot of work for
nothing, and we're better off clearing those we've actually
dirtied on the exit path (it is very rare to inject more than one
interrupt at a time anyway).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 6d4dd78..674bdf8 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -99,6 +99,7 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 		}
 
 		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
+		writel_relaxed(0, base + GICH_LR0 + (i * 4));
 	}
 }
 
@@ -156,12 +157,11 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
 		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
 		for (i = 0; i < nr_lr; i++) {
-			u32 val = 0;
-
-			if (live_lrs & (1UL << i))
-				val = cpu_if->vgic_lr[i];
+			if (!(live_lrs & (1UL << i)))
+				continue;
 
-			writel_relaxed(val, base + GICH_LR0 + (i * 4));
+			writel_relaxed(cpu_if->vgic_lr[i],
+				       base + GICH_LR0 + (i * 4));
 		}
 	}
 
-- 
2.1.4
