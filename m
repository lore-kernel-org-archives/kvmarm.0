From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 22/24] KVM: arm64/sve: allow KVM_ARM_SVE_CONFIG_QUERY
 on vm fd
Date: Tue, 11 Dec 2018 23:28:59 +0000
Message-ID: <1544570941-7377-23-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D564A352
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9EMWAey2Q-4v for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCFA24A214
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:32 -0500 (EST)
In-Reply-To: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
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

Changes since RFC v2:

 * Removed the arch vm ioctl hook in favour of
   kvm_arm_vcpu_sve_config(NULL, ...).
---
 arch/arm64/kvm/guest.c | 7 +++++++
 virt/kvm/arm/arm.c     | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ffb2a25..85a112c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -675,6 +675,9 @@ static int kvm_vcpu_set_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
 	unsigned int vq, max_vq;
 	int ret;
 
+	if (!vcpu)
+		return -EINVAL; /* per-vcpu operation on vm fd */
+
 	if (vcpu->arch.has_run_once || vcpu_sve_config_done(vcpu))
 		return -EBADFD; /* too late, or already configured */
 
@@ -769,6 +772,9 @@ static int kvm_vcpu_query_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls
 static int kvm_vcpu_get_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
 		struct kvm_sve_vls __user *userp)
 {
+	if (!vcpu)
+		return -EINVAL; /* per-vcpu operation on vm fd */
+
 	if (!vcpu_sve_config_done(vcpu))
 		return -EBADFD; /* not configured yet */
 
@@ -778,6 +784,7 @@ static int kvm_vcpu_get_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
 			sve_vq_from_vl(vcpu->arch.sve_max_vl), userp);
 }
 
+/* vcpu may be NULL if this is called via a vm fd */
 int kvm_arm_vcpu_sve_config(struct kvm_vcpu *vcpu,
 			    struct kvm_sve_vls __user *userp)
 {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index cafd701..0f92d54 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1286,6 +1286,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		return 0;
 	}
+	case KVM_ARM_SVE_CONFIG:
+		return kvm_arm_vcpu_sve_config(NULL, argp);
+
 	default:
 		return -EINVAL;
 	}
-- 
2.1.4
