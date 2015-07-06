From: shannon.zhao@linaro.org
Subject: [PATCH 18/18] KVM: ARM64: Add KVM_CAP_ARM_PMU and KVM_ARM_PMU_SET_IRQ
Date: Mon,  6 Jul 2015 10:17:48 +0800
Message-ID: <1436149068-3784-19-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add KVM_CAP_ARM_PMU for userspace to check whether KVM supports PMU. Add
KVM_ARM_PMU_SET_IRQ for userspace to set PMU IRQ number.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm/kvm/arm.c       | 8 ++++++++
 include/kvm/arm_pmu.h    | 5 +++++
 include/uapi/linux/kvm.h | 4 ++++
 virt/kvm/arm/pmu.c       | 9 +++++++++
 4 files changed, 26 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 41eb063..350866e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -182,6 +182,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PSCI_0_2:
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
+	case KVM_CAP_ARM_PMU:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -816,6 +817,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -E2BIG;
 		return kvm_arm_copy_reg_indices(vcpu, user_list->reg);
 	}
+	case KVM_ARM_PMU_SET_IRQ: {
+		uint32_t irq;
+
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			return -EFAULT;
+		return kvm_pmu_set_irq_num(vcpu, irq);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 5bcf27b..1a93f53 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -58,6 +58,7 @@ void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, unsigned long val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx);
+int kvm_pmu_set_irq_num(struct kvm_vcpu *vcpu, u32 irq);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 #else
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
@@ -76,6 +77,10 @@ void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val) {}
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, unsigned long val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx) {}
+int kvm_pmu_set_irq_num(struct kvm_vcpu *vcpu, u32 irq)
+{
+	return -ENXIO;
+}
 static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
 #endif
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 716ad4a..90f5e73 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -817,6 +817,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_DISABLE_QUIRKS 116
 #define KVM_CAP_X86_SMM 117
 #define KVM_CAP_MULTI_ADDRESS_SPACE 118
+#define KVM_CAP_ARM_PMU 119
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1205,6 +1206,9 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_X86_SMM */
 #define KVM_SMI                   _IO(KVMIO,   0xb7)
 
+/* Available with KVM_CAP_ARM_PMU */
+#define KVM_ARM_PMU_SET_IRQ	  _IOW(KVMIO, 0xb8, __u32)
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index f957b85..57585e1 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -381,6 +381,15 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 	pmc->perf_event = event;
 }
 
+int kvm_pmu_set_irq_num(struct kvm_vcpu *vcpu, u32 irq)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	kvm_info("kvm_arm_set_pmu_irq: irq: %u\n", irq);
+	pmu->irq_num = irq;
+	return 0;
+}
+
 /**
  * kvm_pmu_init - Initialize global PMU state for per vcpu
  * @vcpu: The vcpu pointer
-- 
2.1.0

