From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 21/24] KVM: arm64/sve: Report and enable SVE API
 extensions for userspace
Date: Tue, 11 Dec 2018 23:28:58 +0000
Message-ID: <1544570941-7377-22-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1940D4A33F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e8jKJDb1TNy1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7E6C4A37F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:30 -0500 (EST)
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

This patch adds the necessary API extensions to allow userspace to
detect SVE support for guests and enable it.

A new capability KVM_CAP_ARM_SVE is defined to allow userspace to
detect the availability of the KVM SVE API extensions in the usual
way.  In addition, userspace must opt into these extensions by
passing the new KVM_VM_TYPE_ARM_SVE flag to KVM_CREATE_VM.

Userspace needs to enable or disable SVE explicitly per vcpu and
configure the set of SVE vector lengths available to the guest
before non-trivial ioctls (including KVM_ARM_VCPU_INIT and KVM_RUN)
are allowed on the vcpu.  For these purposes, a new arm64-specific
vcpu ioctl KVM_ARM_SVE_CONFIG is added, with the following
subcommands (in rough order of expected use):

KVM_ARM_SVE_CONFIG_QUERY: report the set of vector lengths
    supported by this host.

    The resulting set can be supplied directly to
    KVM_ARM_SVE_CONFIG_SET in order to obtain the maximal possible
    set, or used to inform userspace's decision on the appropriate
    set of vector lengths (possibly taking into account the
    configuration of other nodes in the cluster so that the VM can
    migrate freely).

KVM_ARM_SVE_CONFIG_SET: enable or disable SVE for this vcpu and
    configure the set of vector lengths it offers to the guest (in
    the enabled case).

    This can only be done once, before the vcpu is run.

KVM_ARM_SVE_CONFIG_GET: report the set of vector lengths available
    to the guest on this vcpu (for use when snapshotting or
    migrating a VM).

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since RFC v2:

 * Removed the arch vcpu ioctl hook in favour or
   kvm_arm_vcpu_sve_config() (with a suitable dummy version for
   arch/arm.  The ioctl is not relevant for arm, so a dummy struct
   kvm_sve_vls definition is added for the purpose of compiling related
   declarations).

 * Add a kvm-arm specific helper for freeing the SVE state, instead
   of using kvm_arm_arch_vcpu_uninit() (which is otherwise unneeded
   and is dropped from the series).

 * Drop the homebrew "kvm_err_once" implementation for platforms with
   mismatched vector length support.  Adding a common implementation
   is also probably not worthwhile just for this, so a bare
   printk_once(KERN_ERR) is used instead.

 * Migrate to a more robust protocol for avoiding drift in the set of
   registers available etc. when other vcpu ioctls cross over
   KVM_ARM_SVE_CONFIG_SET.

   Instead, KVM_ARM_SVE_CONFIG_SET is considered an early configuration
   ioctl and must be issued before KVM_ARM_VCPU_INIT and other
   non-trivial vcpu ioctls.

   Existing software would not know to do this, so an explicit opt-in
   is required via a new KVM_VM_TYPE_ARM_SVE flag passed to
   KVM_CREATE_VM.
---
 arch/arm/include/asm/kvm_host.h   |  12 +++
 arch/arm/include/uapi/asm/kvm.h   |   3 +
 arch/arm64/include/asm/kvm_host.h |  25 +++++-
 arch/arm64/include/uapi/asm/kvm.h |  14 ++++
 arch/arm64/kvm/guest.c            | 163 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c            |  61 ++++++++++++++
 include/uapi/linux/kvm.h          |  13 +++
 virt/kvm/arm/arm.c                |   3 +-
 8 files changed, 292 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d61077c..e0e6fa1 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -278,6 +278,12 @@ static inline int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return 0;
 }
 
+static inline int kvm_arm_vcpu_sve_config(struct kvm_vcpu *vcpu,
+					  struct kvm_sve_vls *userp)
+{
+	return -EINVAL;
+}
+
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
@@ -302,6 +308,7 @@ static inline bool kvm_arm_handle_step_debug(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static inline void kvm_arm_vcpu_free_sve(struct kvm_vcpu *vcpu) {}
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
@@ -365,6 +372,11 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type)
 	return 0;
 }
 
+static inline int kvm_arm_setup_vm(struct kvm *kvm, unsigned long *type)
+{
+	return 0;
+}
+
 /* Forbid "ordinary" vcpu ioctls if this returns true: */
 #define vcpu_needs_configuration(vcpu) false
 
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 4602464..64684e4 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -106,6 +106,9 @@ struct kvm_vcpu_init {
 	__u32 features[7];
 };
 
+struct kvm_sve_vls {
+};
+
 struct kvm_sregs {
 };
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7599c70..6717356 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -52,9 +52,17 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+#ifdef CONFIG_ARM64_SVE
+bool kvm_sve_supported(void);
+#else
+static inline bool kvm_sve_supported(void) { return false; }
+#endif
+
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
+int kvm_arm_vcpu_sve_config(struct kvm_vcpu *vcpu,
+			    struct kvm_sve_vls __user *userp);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
 struct kvm_arch {
@@ -81,10 +89,15 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/* KVM_ARM64_VM_* flags */
+	int flags;
 };
 
 #define KVM_NR_MEM_OBJS     40
 
+#define KVM_ARM64_VM_SVE_API (1 << 0)
+
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
  * enough memory for a single page fault in a cache.
@@ -317,6 +330,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
+#define KVM_ARM64_VCPU_SVE_CONFIGURED	(1 << 6) /* SVE configuration done */
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
@@ -458,6 +472,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 bool kvm_arm_handle_step_debug(struct kvm_vcpu *vcpu, struct kvm_run *run);
+void kvm_arm_vcpu_free_sve(struct kvm_vcpu *vcpu);
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
@@ -535,8 +550,16 @@ struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type);
+int kvm_arm_setup_vm(struct kvm *kvm, unsigned long *type);
+
+#define vcpu_using_sve_api(vcpu) \
+	(!!((vcpu)->kvm->arch.flags & KVM_ARM64_VM_SVE_API))
+
+#define vcpu_sve_config_done(vcpu) \
+	(!!((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_CONFIGURED))
 
 /* Forbid "ordinary" vcpu ioctls if this returns true: */
-#define vcpu_needs_configuration(vcpu) false
+#define vcpu_needs_configuration(vcpu) \
+	(vcpu_using_sve_api(vcpu) && !vcpu_sve_config_done(vcpu))
 
 #endif /* __ARM64_KVM_HOST_H__ */
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
index 9657e9d..ffb2a25 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -27,6 +27,9 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
 #include <kvm/arm_psci.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
@@ -57,6 +60,11 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_arm_vcpu_free_sve(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.sve_state);
+}
+
 static u64 core_reg_offset_from_id(u64 id)
 {
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
@@ -647,6 +655,161 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
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
+	if (vcpu->arch.has_run_once || vcpu_sve_config_done(vcpu))
+		return -EBADFD; /* too late, or already configured */
+
+	BUG_ON(vcpu->arch.sve_max_vl || vcpu->arch.sve_state);
+
+	/* max_vq == 0 disables SVE for this vcpu */
+	if (!vls->max_vq) {
+		vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_CONFIGURED;
+		return 0;
+	}
+
+	/* Otherwise, try to enable SVE with the requested set of VLs: */
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
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE |
+			    KVM_ARM64_VCPU_SVE_CONFIGURED;
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
+	if (!vcpu_sve_config_done(vcpu))
+		return -EBADFD; /* not configured yet */
+
+	BUG_ON(!sve_vl_valid(vcpu->arch.sve_max_vl));
+
+	return __kvm_vcpu_query_sve_vls(vls,
+			sve_vq_from_vl(vcpu->arch.sve_max_vl), userp);
+}
+
+int kvm_arm_vcpu_sve_config(struct kvm_vcpu *vcpu,
+			    struct kvm_sve_vls __user *userp)
+{
+	struct kvm_sve_vls vls;
+
+	if (!kvm_sve_supported() || !vcpu_using_sve_api(vcpu))
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
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	return -EINVAL;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 9503fec..33c6948 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -23,6 +23,7 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/string.h>
 
 #include <kvm/arm_arch_timer.h>
 
@@ -58,6 +59,28 @@ static bool cpu_has_32bit_el1(void)
 	return !!(pfr0 & 0x20);
 }
 
+#ifdef CONFIG_ARM64_SVE
+bool kvm_sve_supported(void)
+{
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
+		printk_once(KERN_ERR "kvm [%i]: Hardware SVE implementations mismatched: suppressing SVE for guests.\n",
+			    task_pid_nr(current));
+		return false;
+	}
+
+	return true;
+}
+#endif
+
 /**
  * kvm_arch_vm_ioctl_check_extension
  *
@@ -90,6 +113,8 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 		r = kvm_ipa_limit;
+	case KVM_CAP_ARM_SVE:
+		r = kvm_sve_supported();
 		break;
 	default:
 		r = 0;
@@ -98,6 +123,21 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
@@ -109,6 +149,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	const struct kvm_regs *cpu_reset;
+	int ret;
 
 	switch (vcpu->arch.target) {
 	default:
@@ -126,6 +167,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	/* Reset core registers */
 	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
 
+	ret = kvm_reset_sve(vcpu);
+	if (ret)
+		return ret;
+
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
 
@@ -233,3 +278,19 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type)
 	kvm->arch.vtcr = vtcr;
 	return 0;
 }
+
+/*
+ * Additional machine-type dependent setup: mark this VM as using the
+ * SVE KVM API if requested.
+ */
+int kvm_arm_setup_vm(struct kvm *kvm, unsigned long *type)
+{
+	unsigned long flag = *type & KVM_VM_TYPE_ARM_SVE;
+
+	if (flag) {
+		kvm->arch.flags |= KVM_ARM64_VM_SVE_API;
+		*type &= ~flag;
+	}
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e1e8b08..e82a35c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -766,6 +766,15 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+/*
+ * On arm64, enables the SVE API extensions for KVM.
+ * This enables the KVM_ARM_SVE_CONFIG ioctl.  With this flag set,
+ * KVM_ARM_SVE_CONFIG_SET must be used to configure each newly-created
+ * vcpu before further ioctls will work on it.
+ */
+#define KVM_VM_TYPE_ARM_SVE	(1 << 8)
+
 /*
  * ioctls for /dev/kvm fds:
  */
@@ -975,6 +984,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163
 #define KVM_CAP_EXCEPTION_PAYLOAD 164
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
+#define KVM_CAP_ARM_SVE 166
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1422,6 +1432,9 @@ struct kvm_enc_region {
 #define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
 #define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
 
+/* Available with KVM_CAP_ARM_SVE */
+#define KVM_ARM_SVE_CONFIG	  _IOWR(KVMIO,  0xc0, struct kvm_sve_vls)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7bfc06d..cafd701 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1090,7 +1090,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	struct kvm_device_attr attr;
 	long r;
 
-	/* Early configuration ioctls will be handled here */
+	if (ioctl == KVM_ARM_SVE_CONFIG)
+		return kvm_arm_vcpu_sve_config(vcpu, argp);
 
 	/* Other ioctls require configuration to have been done first: */
 	if (vcpu_needs_configuration(vcpu))
-- 
2.1.4
