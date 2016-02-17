From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 16/17] arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit
Date: Wed, 17 Feb 2016 16:40:48 +0000
Message-ID: <1455727249-24752-17-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

So far, we're always writing all possible LRs, setting the empty
ones with a zero value. This is obvious doing a low of work for
nothing, and we're better off clearing those we've actually
dirtied on the exit path (it is very rare to inject more than one
interrupt at a time anyway).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index ff67296..5f12c57 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -199,6 +199,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			}
 
 			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
+			__gic_v3_set_lr(0, i);
 		}
 
 		switch (nr_pri_bits) {
@@ -296,12 +297,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
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

