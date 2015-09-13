From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/4] arm/arm64: KVM: Fix PSCI affinity info return value for non valid cores
Date: Sun, 13 Sep 2015 11:56:38 +0100
Message-ID: <1442141798-19191-5-git-send-email-marc.zyngier@arm.com>
References: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>, Alvise Rigo <a.rigo@virtualopensystems.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>

If a guest requests the affinity info for a non-existing vCPU we need to
properly return an error, instead of erroneously reporting an off state.

Signed-off-by: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
Signed-off-by: Alvise Rigo <a.rigo@virtualopensystems.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/psci.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 4b94b51..ad6f642 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -126,7 +126,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 {
-	int i;
+	int i, matching_cpus = 0;
 	unsigned long mpidr;
 	unsigned long target_affinity;
 	unsigned long target_affinity_mask;
@@ -151,12 +151,16 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	 */
 	kvm_for_each_vcpu(i, tmp, kvm) {
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
-		if (((mpidr & target_affinity_mask) == target_affinity) &&
-		    !tmp->arch.pause) {
-			return PSCI_0_2_AFFINITY_LEVEL_ON;
+		if ((mpidr & target_affinity_mask) == target_affinity) {
+			matching_cpus++;
+			if (!tmp->arch.pause)
+				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
 
+	if (!matching_cpus)
+		return PSCI_RET_INVALID_PARAMS;
+
 	return PSCI_0_2_AFFINITY_LEVEL_OFF;
 }
 
-- 
2.1.4

