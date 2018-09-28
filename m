From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 19/23] KVM: arm64/sve: Report and enable SVE API
 extensions for userspace
Date: Fri, 28 Sep 2018 14:39:23 +0100
Message-ID: <1538141967-15375-20-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E0964A21B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xFUvBgyjAQVu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:54 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5381A4A1FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:53 -0400 (EDT)
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

This patch adds the necessary API extensions to allow userspace to
detect SVE support for guests and enable it.

A new capability KVM_CAP_ARM_SVE is defined to allow userspace to
detect the availability of the KVM SVE API extensions in the usual
way.

Userspace needs to enable SVE explicitly per vcpu and configure the
set of SVE vector lengths available to the guest before the vcpu is
allowed to run.  For these purposes, a new arm64-specific vcpu
ioctl KVM_ARM_SVE_CONFIG is added, with the following subcommands
(in rough order of expected use):

KVM_ARM_SVE_CONFIG_QUERY: report the set of vector lengths
    supported by this host.

    The resulting set can be supplied directly to
    KVM_ARM_SVE_CONFIG_SET in order to obtain the maximal possible
    set, or used to inform userspace's decision on the appropriate
    set of vector lengths (possibly taking into account the
    configuration of other nodes in the cluster so that the VM can
    migrate freely).

KVM_ARM_SVE_CONFIG_SET: enable SVE for this vcpu and configure the
    set of vector lengths it offers to the guest.

    This can only be done once, before the vcpu is run.

KVM_ARM_SVE_CONFIG_GET: report the set of vector lengths available
    to the guest on this vcpu (for use when snapshotting or
    migrating a VM).

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---

Changes since RFCv1:

 * The new feature bit for PREFERRED_TARGET / VCPU_INIT is gone in
   favour of a capability and a new ioctl to enable/configure SVE.

   Perhaps the SVE configuration could be done via device attributes,
   but it still has to be done early, so crowbarring support for this
   behind a generic API may cause more trouble than it solves.

   This is still up for discussion if anybody feels strongly about it.

 * An ioctl KVM_ARM_SVE_CONFIG has been added to report the set of
   vector lengths available and configure SVE for a vcpu.

   To reduce ioctl namespace pollution the new operations are grouped
   as subcommands under a single ioctl, since they use the same
   argument format anyway.
---
 arch/arm64/include/asm/kvm_host.h |   8 +-
 arch/arm64/include/uapi/asm/kvm.h |  14 ++++
 arch/arm64/kvm/guest.c            | 164 +++++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c            |  50 ++++++++++++
 include/uapi/linux/kvm.h          |   4 +
 5 files changed, 238 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bbde597..5225485 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -52,6 +52,12 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+#ifdef CONFIG_ARM64_SVE
+bool kvm_sve_supported(void);
+#else
+static inline bool kvm_sve_supported(void) { return false; }
+#endif
+
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
@@ -441,7 +447,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-static inline void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1ff68fa..94f6932 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -32,6 +32,7 @@
 #define KVM_NR_SPSR	5
 
 #ifndef __ASSEMBLY__
+#include <linux/kernel.h>
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
@@ -108,6 +109,19 @@ struct kvm_vcpu_init {
 	__u32 features[7];
 };
 
+/* Vector length set for KVM_ARM_SVE_CONFIG */
+struct kvm_sve_vls {
+	__u16 cmd;
+	__u16 max_vq;
+	__u16 _reserved[2];
+	__u64 required_vqs[__KERNEL_DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+};
+
+/* values for cmd: */
+#define KVM_ARM_SVE_CONFIG_QUERY	0 /* query what the host can support */
+#define KVM_ARM_SVE_CONFIG_SET		1 /* enable SVE for vcpu and set VLs */
+#define KVM_ARM_SVE_CONFIG_GET		2 /* read the set of VLs for a vcpu */
+
 struct kvm_sregs {
 };
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 331b85e..d96145a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -26,6 +26,9 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
 #include <kvm/arm_psci.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
@@ -56,6 +59,11 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.sve_state);
+}
+
 static u64 core_reg_offset_from_id(u64 id)
 {
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
@@ -546,10 +554,164 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 	return 0;
 }
 
+#define VQS_PER_U64 64
+#define vq_word(vqs, vq) (&(vqs)[((vq) - SVE_VQ_MIN) / VQS_PER_U64])
+#define vq_mask(vq) ((u64)1 << (((vq) - SVE_VQ_MIN) % VQS_PER_U64))
+
+static void set_vq(u64 *vqs, unsigned int vq)
+{
+	*vq_word(vqs, vq) |= vq_mask(vq);
+}
+
+static bool vq_set(const u64 *vqs, unsigned int vq)
+{
+	return *vq_word(vqs, vq) & vq_mask(vq);
+}
+
+static int kvm_vcpu_set_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
+		struct kvm_sve_vls __user *userp)
+{
+	unsigned int vq, max_vq;
+	int ret;
+
+	if (vcpu->arch.has_run_once || vcpu_has_sve(vcpu))
+		return -EBADFD; /* too late, or already configured */
+
+	BUG_ON(vcpu->arch.sve_max_vl || vcpu->arch.sve_state);
+
+	if (vls->max_vq < SVE_VQ_MIN || vls->max_vq > SVE_VQ_MAX)
+		return -EINVAL;
+
+	max_vq = 0;
+	for (vq = SVE_VQ_MIN; vq <= vls->max_vq; ++vq) {
+		bool available = sve_vq_available(vq);
+		bool required = vq_set(vls->required_vqs, vq);
+
+		if (required != available)
+			break;
+
+		if (required)
+			max_vq = vq;
+	}
+
+	if (max_vq < SVE_VQ_MIN)
+		return -EINVAL;
+
+	vls->max_vq = max_vq;
+	ret = put_user(vls->max_vq, &userp->max_vq);
+	if (ret)
+		return ret;
+
+	/*
+	 * kvm_reset_vcpu() may already have run in KVM_VCPU_INIT, so we
+	 * rely on kzalloc() being sufficient to reset the guest SVE
+	 * state here for a new vcpu.
+	 *
+	 * Subsequent resets after vcpu initialisation are handled by
+	 * kvm_reset_sve().
+	 */
+	vcpu->arch.sve_state = kzalloc(SVE_SIG_REGS_SIZE(vls->max_vq),
+				       GFP_KERNEL);
+	if (!vcpu->arch.sve_state)
+		return -ENOMEM;
+
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
+	vcpu->arch.sve_max_vl = sve_vl_from_vq(vls->max_vq);
+
+	return 0;
+}
+
+static int __kvm_vcpu_query_sve_vls(struct kvm_sve_vls *vls,
+		unsigned int max_vq, struct kvm_sve_vls __user *userp)
+{
+	unsigned int vq, max_available_vq;
+
+	memset(&vls->required_vqs, 0, sizeof(vls->required_vqs));
+
+	BUG_ON(max_vq < SVE_VQ_MIN || max_vq > SVE_VQ_MAX);
+
+	max_available_vq = 0;
+	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
+		if (sve_vq_available(vq)) {
+			set_vq(vls->required_vqs, vq);
+			max_available_vq = vq;
+		}
+
+	if (WARN_ON(max_available_vq < SVE_VQ_MIN))
+		return -EIO;
+
+	vls->max_vq = max_available_vq;
+	if (copy_to_user(userp, vls, sizeof(*vls)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vcpu_query_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
+		struct kvm_sve_vls __user *userp)
+{
+	BUG_ON(!sve_vl_valid(sve_max_vl));
+
+	return __kvm_vcpu_query_sve_vls(vls,
+			sve_vq_from_vl(sve_max_vl), userp);
+}
+
+static int kvm_vcpu_get_sve_vls(struct kvm_vcpu *vcpu, struct kvm_sve_vls *vls,
+		struct kvm_sve_vls __user *userp)
+{
+	if (!vcpu_has_sve(vcpu))
+		return -EBADFD; /* not configured yet */
+
+	BUG_ON(!sve_vl_valid(vcpu->arch.sve_max_vl));
+
+	return __kvm_vcpu_query_sve_vls(vls,
+			sve_vq_from_vl(vcpu->arch.sve_max_vl), userp);
+}
+
+static int kvm_vcpu_sve_config(struct kvm_vcpu *vcpu,
+			       struct kvm_sve_vls __user *userp)
+{
+	struct kvm_sve_vls vls;
+
+	if (!kvm_sve_supported())
+		return -EINVAL;
+
+	if (copy_from_user(&vls, userp, sizeof(vls)))
+		return -EFAULT;
+
+	/*
+	 * For forwards compatibility, flush any set bits in _reserved[]
+	 * to tell userspace that we didn't look at them:
+	 */
+	memset(&vls._reserved, 0, sizeof vls._reserved);
+
+	switch (vls.cmd) {
+	case KVM_ARM_SVE_CONFIG_QUERY:
+		return kvm_vcpu_query_sve_vls(vcpu, &vls, userp);
+
+	case KVM_ARM_SVE_CONFIG_SET:
+		return kvm_vcpu_set_sve_vls(vcpu, &vls, userp);
+
+	case KVM_ARM_SVE_CONFIG_GET:
+		return kvm_vcpu_get_sve_vls(vcpu, &vls, userp);
+
+	default:
+		return -EINVAL;
+	}
+}
+
 int kvm_arm_arch_vcpu_ioctl(struct kvm_vcpu *vcpu,
 			    unsigned int ioctl, unsigned long arg)
 {
-	return -EINVAL;
+	void __user *userp = (void __user *)arg;
+
+	switch (ioctl) {
+	case KVM_ARM_SVE_CONFIG:
+		return kvm_vcpu_sve_config(vcpu, userp);
+
+	default:
+		return -EINVAL;
+	}
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e37c78b..c2edcde 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -19,10 +19,12 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/atomic.h>
 #include <linux/errno.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/string.h>
 
 #include <kvm/arm_arch_timer.h>
 
@@ -54,6 +56,31 @@ static bool cpu_has_32bit_el1(void)
 	return !!(pfr0 & 0x20);
 }
 
+#ifdef CONFIG_ARM64_SVE
+bool kvm_sve_supported(void)
+{
+	static bool warn_printed = false;
+
+	if (!system_supports_sve())
+		return false;
+
+	/*
+	 * For now, consider the hardware broken if implementation
+	 * differences between CPUs in the system result in the set of
+	 * vector lengths safely virtualisable for guests being less
+	 * than the set provided to userspace:
+	 */
+	if (sve_max_virtualisable_vl != sve_max_vl) {
+		if (!xchg(&warn_printed, true))
+			kvm_err("Hardware SVE implementations mismatched: suppressing SVE for guests.");
+
+		return false;
+	}
+
+	return true;
+}
+#endif
+
 /**
  * kvm_arch_dev_ioctl_check_extension
  *
@@ -85,6 +112,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_SVE:
+		r = kvm_sve_supported();
+		break;
 	default:
 		r = 0;
 	}
@@ -92,6 +122,21 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+int kvm_reset_sve(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	if (WARN_ON(!vcpu->arch.sve_state ||
+		    !sve_vl_valid(vcpu->arch.sve_max_vl)))
+		return -EIO;
+
+	memset(vcpu->arch.sve_state, 0,
+	       SVE_SIG_REGS_SIZE(sve_vq_from_vl(vcpu->arch.sve_max_vl)));
+
+	return 0;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -103,6 +148,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	const struct kvm_regs *cpu_reset;
+	int ret;
 
 	switch (vcpu->arch.target) {
 	default:
@@ -120,6 +166,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	/* Reset core registers */
 	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
 
+	ret = kvm_reset_sve(vcpu);
+	if (ret)
+		return ret;
+
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7c3c5cc..488ca56 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -953,6 +953,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_NESTED_STATE 157
 #define KVM_CAP_ARM_INJECT_SERROR_ESR 158
 #define KVM_CAP_MSR_PLATFORM_INFO 159
+#define KVM_CAP_ARM_SVE 160
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1400,6 +1401,9 @@ struct kvm_enc_region {
 #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
 #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
 
+/* Available with KVM_CAP_ARM_SVE */
+#define KVM_ARM_SVE_CONFIG	  _IOWR(KVMIO,  0xc0, struct kvm_sve_vls)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.1.4
