From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 21/23] KVM: arm64/sve: allow KVM_ARM_SVE_CONFIG_QUERY
 on vm fd
Date: Fri, 28 Sep 2018 14:39:25 +0100
Message-ID: <1538141967-15375-22-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B604A26A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vm6IGqelXo1h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:57 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 488734A0C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:57 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since userspace may need to decide on the set of vector lengths for
the guest before setting up a vm, it is onerous to require a vcpu
fd to be available first.  KVM_ARM_SVE_CONFIG_QUERY is not
vcpu-dependent anyway, so this patch wires up KVM_ARM_SVE_CONFIG to
be usable on a vm fd where appropriate.

Subcommands that are vcpu-dependent (currently
KVM_ARM_SVE_CONFIG_SET, KVM_ARM_SVE_CONFIG_GET) will return -EINVAL
if invoked on a vm fd.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f066b17..2313c22 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -574,6 +574,9 @@ static int kvm_vcpu_set_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
 	unsigned int vq, max_vq;
 	int ret;
 
+	if (!vcpu)
+		return -EINVAL; /* per-vcpu operation on vm fd */
+
 	if (vcpu->arch.has_run_once || vcpu_has_sve(vcpu))
 		return -EBADFD; /* too late, or already configured */
 
@@ -659,6 +662,9 @@ static int kvm_vcpu_query_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls
 static int kvm_vcpu_get_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
 		struct kvm_sve_vls __user *userp)
 {
+	if (!vcpu)
+		return -EINVAL; /* per-vcpu operation on vm fd */
+
 	if (!vcpu_has_sve(vcpu))
 		return -EBADFD; /* not configured yet */
 
@@ -668,6 +674,7 @@ static int kvm_vcpu_get_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
 			sve_vq_from_vl(vcpu->arch.sve_max_vl), userp);
 }
 
+/* vcpu may be NULL if this is called via a vm fd */
 static int kvm_vcpu_sve_config(struct kvm_vcpu *vcpu,
 			       struct kvm_sve_vls __user *userp)
 {
@@ -717,7 +724,15 @@ int kvm_arm_arch_vcpu_ioctl(struct kvm_vcpu *vcpu,
 int kvm_arm_arch_vm_ioctl(struct kvm *kvm,
 			  unsigned int ioctl, unsigned long arg)
 {
-	return -EINVAL;
+	void __user *userp = (void __user *)arg;
+
+	switch (ioctl) {
+	case KVM_ARM_SVE_CONFIG:
+		return kvm_vcpu_sve_config(NULL, userp);
+
+	default:
+		return -EINVAL;
+	}
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-- 
2.1.4
