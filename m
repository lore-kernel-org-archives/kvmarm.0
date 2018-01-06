From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Sun, 7 Jan 2018 00:02:55 +0800
Message-ID: <1515254577-6460-6-git-send-email-gengdongjiu@huawei.com>
References: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86BD049DBC
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Jan 2018 02:53:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AJOm5Ul-+9uU for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Jan 2018 02:53:38 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE30E49DAC
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Jan 2018 02:53:36 -0500 (EST)
In-Reply-To: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, robert.moore@intel.com, lv.zheng@intel.com, james.morse@arm.com, corbet@lwn.net, will.deacon@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: huangshaoyu@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

The ARM64 RAS SError Interrupt(SEI) syndrome value is specific to the
guest and user space needs a way to tell KVM this value. So we add a
new ioctl. Before user space specifies the Exception Syndrome Register
ESR(ESR), it firstly checks that whether KVM has the capability to
set the guest ESR, If has, will set it. Otherwise, nothing to do.

For this ESR specifying, Only support for AArch64, not support AArch32.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
change the name to KVM_CAP_ARM_INJECT_SERROR_ESR instead of
XXXXX_ARM_RAS_EXTENSION, suggested here

https://patchwork.kernel.org/patch/9925203/
---
 Documentation/virtual/kvm/api.txt | 11 +++++++++++
 arch/arm/include/asm/kvm_host.h   |  1 +
 arch/arm/kvm/guest.c              |  9 +++++++++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/guest.c            |  5 +++++
 arch/arm64/kvm/reset.c            |  3 +++
 include/uapi/linux/kvm.h          |  3 +++
 virt/kvm/arm/arm.c                |  7 +++++++
 8 files changed, 40 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e63a35f..6dfb9fc 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4347,3 +4347,14 @@ This capability indicates that userspace can load HV_X64_MSR_VP_INDEX msr.  Its
 value is used to denote the target vcpu for a SynIC interrupt.  For
 compatibilty, KVM initializes this msr to KVM's internal vcpu index.  When this
 capability is absent, userspace can still query this msr's value.
+
+8.13 KVM_CAP_ARM_SET_SERROR_ESR
+
+Architectures: arm, arm64
+
+This capability indicates that userspace can specify syndrome value reported to
+guest OS when guest takes a virtual SError interrupt exception.
+If KVM has this capability, userspace can only specify the ISS field for the ESR
+syndrome, can not specify the EC field which is not under control by KVM.
+If this virtual SError is taken to EL1 using AArch64, this value will be reported
+into ISS filed of ESR_EL1
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4a879f6..6cf5c7b 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ struct kvm_vcpu_stat {
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u32 *syndrome);
 unsigned long kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 1e0784e..1e15fa2 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -248,6 +248,15 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+/*
+ * we only support guest SError syndrome specifying
+ * for ARM64, not support it for ARM32.
+ */
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u32 *syndrome)
+{
+	return -EINVAL;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	switch (read_cpuid_part()) {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e923b58..769cc58 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -317,6 +317,7 @@ struct kvm_vcpu_stat {
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u32 *syndrome);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5c7f657..738ae90 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -277,6 +277,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u32 *syndrome)
+{
+	return -EINVAL;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	unsigned long implementor = read_cpuid_implementor();
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3256b92..38c8a64 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_arm_support_pmu_v3();
 		break;
+	case KVM_CAP_ARM_INJECT_SERROR_ESR:
+		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7e99999..0c861c4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -931,6 +931,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SMT_POSSIBLE 147
 #define KVM_CAP_HYPERV_SYNIC2 148
 #define KVM_CAP_HYPERV_VP_INDEX 149
+#define KVM_CAP_ARM_INJECT_SERROR_ESR 150
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1357,6 +1358,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_S390_CMMA_MIGRATION */
 #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
+/* Available with KVM_CAP_ARM_INJECT_SERROR_ESR */
+#define KVM_ARM_INJECT_SERROR_ESR   _IOW(KVMIO,  0xba, __u32)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 95cba07..60dea5f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1027,6 +1027,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_ARM_INJECT_SERROR_ESR: {
+		u32 syndrome;
+
+		if (copy_from_user(&syndrome, argp, sizeof(syndrome)))
+			return -EFAULT;
+		return kvm_arm_set_sei_esr(vcpu, &syndrome);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1
