From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 10/12] arm64: KVM: vgic-v3: Do not save an LR known to be empty
Date: Mon,  7 Mar 2016 09:33:32 +0000
Message-ID: <1457343214-19547-11-git-send-email-marc.zyngier@arm.com>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On exit, any empty LR will be signaled in ICH_ELRSR_EL2. Which
means that we do not have to save it, and we can just clear
its state in the in-memory copy.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 61a5e46..0db426e 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -187,8 +187,15 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		save_maint_int_state(vcpu, max_lr_idx + 1);
 
 		for (i = 0; i <= max_lr_idx; i++) {
-			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
-				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
+			if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
+				continue;
+
+			if (cpu_if->vgic_elrsr & (1 << i)) {
+				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
+				continue;
+			}
+
+			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 		}
 
 		switch (nr_pri_bits) {
-- 
2.1.4

