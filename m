From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v7 2/4] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Tue, 17 Oct 2017 22:14:47 +0800
Message-ID: <1508249689-10350-3-git-send-email-gengdongjiu@huawei.com>
References: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2A0249D19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 09:49:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OXl0UROYoVII for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 09:49:13 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FF0D49D2A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 09:49:12 -0400 (EDT)
In-Reply-To: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, gengdongjiu@huawei.com, wuquanming@huawei.com, kristina.martsenko@arm.com, mingo@kernel.org, punit.agrawal@arm.com, stephen.boyd@linaro.org, kamensky@cisco.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On ARM64 SError syndrome value is specific to the model being
emulated for the guest and user space needs a way to tell the
kernel this value. userspace can specify different value to
affect guest OS error recovery behaviour.

We make this API ARM-specific as we haven't yet reached a consensus
for a generic API for all KVM architectures that will allow us to
do something like this.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming Wu <wuquanming@huawei.com>
---
 Documentation/virtual/kvm/api.txt | 11 +++++++++++
 arch/arm/include/asm/kvm_host.h   |  1 +
 arch/arm/kvm/guest.c              |  9 +++++++++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/guest.c            |  5 +++++
 arch/arm64/kvm/reset.c            |  3 +++
 include/uapi/linux/kvm.h          |  3 +++
 virt/kvm/arm/arm.c                |  7 +++++++
 8 files changed, 41 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e63a35f..b076fc8 100644
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
+software on taking a virtual SError interrupt exception.
+Userspace can only specify the ISS field for the ESR syndrome, EC field is set
+by hardware when the virtual SError interrupt is taken. If this virtual SError
+is taken to EL1 using AArch64, this value will be reported in ESR_EL1, otherwise
+if it is taken to EL1 using AArch32, this value will be reported in DFSR.{AET, ExT}.
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 127e2dd..3723138 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u64 *syndrome);
 unsigned long kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 1e0784e..309b236 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -248,6 +248,15 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+/*
+ * we only support SEI injection with specified synchronous
+ * in ARM64, not support it in ARM32.
+ */
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u64 *syndrome)
+{
+	return -EINVAL;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	switch (read_cpuid_part()) {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af55b3bc..dd4cb25 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -320,6 +320,8 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u64 *syndrome);
+
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm,
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5c7f657..0a08b05 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -277,6 +277,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u64 *syndrome)
+{
+	return -EINVAL;
+}
+
 int __attribute_const__ kvm_target_cpu(void)
 {
 	unsigned long implementor = read_cpuid_implementor();
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3256b92..9163628 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_arm_support_pmu_v3();
 		break;
+	case KVM_CAP_ARM_SET_SERROR_ESR:
+		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6cd63c1..aece611 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SMT_POSSIBLE 147
 #define KVM_CAP_HYPERV_SYNIC2 148
 #define KVM_CAP_HYPERV_VP_INDEX 149
+#define KVM_CAP_ARM_SET_SERROR_ESR 150
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1355,6 +1356,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_S390_CMMA_MIGRATION */
 #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
+/* Available with KVM_CAP_ARM_SET_SERROR_ESR */
+#define KVM_ARM_SET_SERROR_ESR       _IOW(KVMIO,  0xb10, __u64)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e1..2d8abeb 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1022,6 +1022,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_ARM_SET_SERROR_ESR: {
+		u64 syndrome;
+
+		if (copy_from_user(&syndrome, argp, sizeof(syndrome)))
+			return -EFAULT;
+		return kvm_arm_set_sei_esr(vcpu, &syndrome);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.10.1
