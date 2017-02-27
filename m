From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 4/5] KVM: arm/arm64: fix race in kvm_psci_vcpu_on
Date: Mon, 27 Feb 2017 18:55:03 +0100
Message-ID: <20170227175504.15751-5-drjones@redhat.com>
References: <20170227175504.15751-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5DB40C7D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NkHtgtRcdydO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 12:54:08 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7864540C45
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:08 -0500 (EST)
In-Reply-To: <20170227175504.15751-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Levente Kurusa <lkurusa@redhat.com>, marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Levente Kurusa <lkurusa@redhat.com>

When two vcpus issue PSCI_CPU_ON on the same core at the same time,
then it's possible for them to both enter the target vcpu's setup
at the same time. This results in unexpected behaviors at best,
and the potential for some nasty bugs at worst.

Signed-off-by: Levente Kurusa <lkurusa@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/psci.c      | 4 ++--
 include/linux/kvm_host.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 6c6255f9d8ff..1fccbeb1c0be 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -88,7 +88,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!__kvm_request_test(KVM_REQ_VCPU_POWER_OFF, vcpu)) {
+
+	if (!__kvm_request_test_and_clear(KVM_REQ_VCPU_POWER_OFF, vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -116,7 +117,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * the general puspose registers are undefined upon CPU_ON.
 	 */
 	vcpu_set_reg(vcpu, 0, context_id);
-	__kvm_request_clear(KVM_REQ_VCPU_POWER_OFF, vcpu);
 
 	wq = kvm_arch_vcpu_wq(vcpu);
 	swake_up(wq);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 97b6bd6318e5..df9df7677510 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1135,6 +1135,11 @@ static inline void __kvm_request_clear(unsigned req, struct kvm_vcpu *vcpu)
 	clear_bit(req, &vcpu->requests);
 }
 
+static inline bool __kvm_request_test_and_clear(unsigned req, struct kvm_vcpu *vcpu)
+{
+	return test_and_clear_bit(req, &vcpu->requests);
+}
+
 static inline bool kvm_request_test_and_clear(unsigned req, struct kvm_vcpu *vcpu)
 {
 	if (__kvm_request_test(req, vcpu)) {
-- 
2.9.3
