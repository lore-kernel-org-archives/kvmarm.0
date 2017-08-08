From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v2 11/11] KVM: arm64: Allow user-space to claim guest SMC-CC ranges for SDEI
Date: Tue,  8 Aug 2017 17:46:16 +0100
Message-ID: <20170808164616.25949-12-james.morse@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170808164616.25949-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Instead of supporting SDEI in KVM, and providing a new API to
control and configure the in-kernel support, allow user-space to
request particular SMC-CC ranges from guest HVC calls to be handled
by user-space.

This requires two KVM capabilities, KVM_CAP_ARM_SDEI_1_0 advertises
that KVM knows how match SDEI SMC-CC calls from a guest. To pass these
calls to user-space requires this cap to be enabled using
KVM_CAP_ENABLE_CAP_VM.

Calls are passed with exit_reason = KVM_EXIT_HYPERCALL, the kvm_run
structure has copies of the first 6 registers and the guest pstate.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
While I'm in here, remove KVM_CAP_ARM_SET_DEVICE_ADDR's extra entry
for r=1;break?

Changes from v1:
 * all of it

 Documentation/virtual/kvm/api.txt | 12 +++++++++---
 arch/arm64/include/asm/kvm_host.h |  6 ++++++
 arch/arm64/kvm/handle_exit.c      | 28 +++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h          |  1 +
 virt/kvm/arm/arm.c                | 29 +++++++++++++++++++++++++++--
 5 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e63a35fafef0..740288d6e894 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1012,7 +1012,7 @@ documentation when it pops into existence).
 4.37 KVM_ENABLE_CAP
 
 Capability: KVM_CAP_ENABLE_CAP, KVM_CAP_ENABLE_CAP_VM
-Architectures: x86 (only KVM_CAP_ENABLE_CAP_VM),
+Architectures: x86, arm, arm64 (only KVM_CAP_ENABLE_CAP_VM),
 	       mips (only KVM_CAP_ENABLE_CAP), ppc, s390
 Type: vcpu ioctl, vm ioctl (with KVM_CAP_ENABLE_CAP_VM)
 Parameters: struct kvm_enable_cap (in)
@@ -3540,10 +3540,16 @@ pending operations.
 			__u32 pad;
 		} hypercall;
 
-Unused.  This was once used for 'hypercall to userspace'.  To implement
-such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
+This was once used for 'hypercall to userspace'.  To implement such
+functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
 Note KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
 
+On arm64 this is used to complete guest hypercalls (HVC) in user space.
+e.g. Configuring SDEI or communicating with an emulated TEE.
+The required HVC ranges must first be enabled by KVM_CAP_ENABLE_CAP_VM.
+The 'args' array contains a copy of r0-r5 and 'longmode' contains a copy
+of the CPSR/PSTATE.
+
 		/* KVM_EXIT_TPR_ACCESS */
 		struct {
 			__u64 rip;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7733492d9a35..77b8436e745e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -71,8 +71,14 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
+
+	/* SMC-CC/HVC ranges user space has requested */
+	u32	hvc_passthrough_ranges;
 };
 
+/* SMC-CC/HVC ranges that can be passed to user space */
+#define	KVM_HVC_RANGE_SDEI	1
+
 #define KVM_NR_MEM_OBJS     40
 
 /*
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a1677a0b..22eadf2cd82f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -21,6 +21,7 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/sdei.h>
 
 #include <asm/esr.h>
 #include <asm/kvm_asm.h>
@@ -34,15 +35,40 @@
 
 typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
 
+#define HVC_PASSTHROUGH(kvm, range) (kvm->arch.hvc_passthrough_ranges & range)
+
+/*
+ * The guest made an SMC-CC call that user-space has claimed.
+ */
+static int populate_hypercall_exit(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int i;
+
+	run->exit_reason = KVM_EXIT_HYPERCALL;
+
+	for (i = 0 ; i < ARRAY_SIZE(run->hypercall.args); i++)
+		run->hypercall.args[i] = vcpu_get_reg(vcpu, i);
+
+	run->hypercall.longmode = *vcpu_cpsr(vcpu);
+
+	return 0;
+}
+
 static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long x0 = vcpu_get_reg(vcpu, 0);
 
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
-	ret = kvm_psci_call(vcpu);
+	if (IS_SDEI_CALL(x0) && HVC_PASSTHROUGH(kvm, KVM_HVC_RANGE_SDEI))
+		ret = populate_hypercall_exit(vcpu, run);
+	else
+		ret = kvm_psci_call(vcpu);
+
 	if (ret < 0) {
 		kvm_inject_undefined(vcpu);
 		return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6cd63c18708a..8e6bc6ba918d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SMT_POSSIBLE 147
 #define KVM_CAP_HYPERV_SYNIC2 148
 #define KVM_CAP_HYPERV_VP_INDEX 149
+#define KVM_CAP_ARM_SDEI_1_0 150
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index e9765ee6d769..b8657b68fea7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -206,8 +206,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
-		r = 1;
-		break;
+	case KVM_CAP_ENABLE_CAP_VM:
+#ifdef CONFIG_ARM64
+	case KVM_CAP_ARM_SDEI_1_0:
+#endif
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
 		r = 1;
 		break;
@@ -1082,6 +1084,21 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
+static int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *req)
+{
+	int err = -EINVAL;
+
+	if (req->flags)
+		return err;
+
+	if (IS_ENABLED(CONFIG_ARM64) && req->cap == KVM_CAP_ARM_SDEI_1_0) {
+		kvm->arch.hvc_passthrough_ranges |= KVM_HVC_RANGE_SDEI;
+		err = 0;
+	}
+
+	return err;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -1118,6 +1135,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		return 0;
 	}
+	case KVM_ENABLE_CAP: {
+		struct kvm_enable_cap req;
+
+		if (copy_from_user(&req, argp, sizeof(req)))
+			return -EFAULT;
+
+		return kvm_vm_ioctl_enable_cap(kvm, &req);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
