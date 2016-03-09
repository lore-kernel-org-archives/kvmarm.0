From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 95/95] arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit
Date: Wed,  9 Mar 2016 07:31:29 +0000
Message-ID: <1457508689-19672-96-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D036941145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5uhRNUSOMJ0L for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:36:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BDA49BFA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:15 -0500 (EST)
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
ones with a zero value. This is obvious doing a low of work for
nothing, and we're better off clearing those we've actually
dirtied on the exit path (it is very rare to inject more than one
interrupt at a time anyway).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 8134947..fff7cd4 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -196,6 +196,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			}
 
 			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
+			__gic_v3_set_lr(0, i);
 		}
 
 		switch (nr_pri_bits) {
@@ -293,12 +294,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 		}
 
 		for (i = 0; i <= max_lr_idx; i++) {
-			val = 0;
-
-			if (live_lrs & (1 << i))
-				val = cpu_if->vgic_lr[i];
+			if (!(live_lrs & (1 << i)))
+				continue;
 
-			__gic_v3_set_lr(val, i);
+			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
 		}
 	}
 
-- 
2.1.4
