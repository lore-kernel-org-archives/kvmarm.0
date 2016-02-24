From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/3] arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before ICH_APR1Rn_EL2
Date: Wed, 24 Feb 2016 17:33:44 +0000
Message-ID: <1456335224-20603-4-git-send-email-marc.zyngier@arm.com>
References: <1456335224-20603-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456335224-20603-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

The GICv3 architecture spec says:

Writing to the active priority registers in any order other than
the following order will result in UNPREDICTABLE behavior:
- ICH_AP0R<n>_EL2.
- ICH_AP1R<n>_EL2.

So let's not pointlessly go against the rule...

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 9142e082..5dd2a26 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -149,16 +149,6 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 
 	switch (nr_pri_bits) {
 	case 7:
-		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
-		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
-	case 6:
-		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
-	default:
-		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
-	}	 	                           
-		 	                           
-	switch (nr_pri_bits) {
-	case 7:
 		 write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
 		 write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
 	case 6:
@@ -167,6 +157,16 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 		 write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
 	}
 
+	switch (nr_pri_bits) {
+	case 7:
+		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
+		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
+	case 6:
+		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
+	default:
+		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
+	}
+
 	switch (max_lr_idx) {
 	case 15:
 		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)], ICH_LR15_EL2);
-- 
2.1.4

