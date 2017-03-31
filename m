From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 8/9] KVM: arm/arm64: fix race in kvm_psci_vcpu_on
Date: Fri, 31 Mar 2017 18:06:57 +0200
Message-ID: <20170331160658.4331-9-drjones@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170331160658.4331-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, Levente Kurusa <lkurusa@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Levente Kurusa <lkurusa@redhat.com>

When two vcpus issue PSCI_CPU_ON on the same core at the same time,
then it's possible for them to both enter the target vcpu's setup
at the same time. This results in unexpected behaviors at best,
and the potential for some nasty bugs at worst.

Signed-off-by: Levente Kurusa <lkurusa@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/psci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index f732484abc7a..0204daa899b1 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -88,7 +88,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!test_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
+
+	if (!test_and_clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -116,7 +117,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * the general puspose registers are undefined upon CPU_ON.
 	 */
 	vcpu_set_reg(vcpu, 0, context_id);
-	clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
 
 	wq = kvm_arch_vcpu_wq(vcpu);
 	swake_up(wq);
-- 
2.9.3
