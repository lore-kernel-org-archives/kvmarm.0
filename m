From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 07/16] arm/arm64: KVM: Add PSCI version selection API
Date: Mon, 29 Jan 2018 17:45:50 +0000
Message-ID: <20180129174559.1866-8-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Although we've implemented PSCI 1.0 and 1.1, nothing can select them
Since all the new PSCI versions are backward compatible, we decide to
default to the latest version of the PSCI implementation. This is no
different from doing a firmware upgrade on KVM.

But in order to give a chance to hypothetical badly implemented guests
that would have a fit by discovering something other than PSCI 0.2,
let's provide a new API that allows userspace to pick one particular
version of the API.

This is implemented as a new class of "firmware" registers, where
we expose the PSCI version. This allows the PSCI version to be
save/restored as part of a guest migration, and also set to
any supported version if the guest requires it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt      |  3 +-
 Documentation/virtual/kvm/arm/psci.txt | 28 ++++++++++++++
 arch/arm/include/asm/kvm_host.h        |  3 ++
 arch/arm/include/uapi/asm/kvm.h        |  6 +++
 arch/arm/kvm/guest.c                   | 13 +++++++
 arch/arm64/include/asm/kvm_host.h      |  3 ++
 arch/arm64/include/uapi/asm/kvm.h      |  6 +++
 arch/arm64/kvm/guest.c                 | 14 ++++++-
 include/kvm/arm_psci.h                 |  9 +++++
 virt/kvm/arm/psci.c                    | 68 +++++++++++++++++++++++++++++++++-
 10 files changed, 149 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/psci.txt

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 57d3ee9e4bde..334905202141 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2493,7 +2493,8 @@ Possible features:
 	  and execute guest code when KVM_RUN is called.
 	- KVM_ARM_VCPU_EL1_32BIT: Starts the CPU in a 32bit mode.
 	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
-	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
+	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 (or a future revision
+          backward compatible with v0.2) for the CPU.
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
new file mode 100644
index 000000000000..2e49a4e9f084
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/psci.txt
@@ -0,0 +1,28 @@
+KVM implements the PSCI (Power State Coordination Interface)
+specification in order to provide services such as CPU on/off, reset
+and power-off to the guest.
+
+The PSCI specification is regularly updated to provide new features,
+and KVM implements these updates if they make sense from a virtualization
+point of view.
+
+This means that a guest booted on two different versions of KVM can
+observe two different "firmware" revisions. This could cause issues if
+a given guest is tied to a particular PSCI revision (unlikely), or if
+a migration causes a different PSCI version to be exposed out of the
+blue to an unsuspecting guest.
+
+In order to remedy this situation, KVM exposes a set of "firmware
+pseuodo-registers" that can be manipulated using the GET/SET_ONE_REG
+interface. These registers can be saved/restored by userspace, and set
+to a convenient value if required.
+
+The following register is defined:
+
+* KVM_REG_ARM_PSCI_VERSION:
+
+  - Only valid if the vcpu has KVM_ARM_VCPU_PSCI_0_2 feature set
+  - Returns the current PSCI version on GET_ONE_REG
+  - Allows any supported PSCI version compatible with v0.2 to be set
+    with SET_ONE_REG
+  - Affects the whole VM (even if the register view is per-vcpu)
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index acbf9ec7b396..e9d57060d88c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -75,6 +75,9 @@ struct kvm_arch {
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 	int max_vcpus;
+
+	/* Mandated version of PSCI */
+	u32 psci_version;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 6edd177bb1c7..47dfc99f5cd0 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -186,6 +186,12 @@ struct kvm_arch_memory_slot {
 #define KVM_REG_ARM_VFP_FPINST		0x1009
 #define KVM_REG_ARM_VFP_FPINST2		0x100A
 
+/* KVM-as-firmware specific pseudo-registers */
+#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
+					 KVM_REG_ARM_FW | ((r) & 0xffff))
+#define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 1e0784ebbfd6..a18f33edc471 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <kvm/arm_psci.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
 #include <asm/kvm.h>
@@ -176,6 +177,7 @@ static unsigned long num_core_regs(void)
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 {
 	return num_core_regs() + kvm_arm_num_coproc_regs(vcpu)
+		+ kvm_arm_get_fw_num_regs(vcpu)
 		+ NUM_TIMER_REGS;
 }
 
@@ -196,6 +198,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		uindices++;
 	}
 
+	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
+	if (ret)
+		return ret;
+	uindices += kvm_arm_get_fw_num_regs(vcpu);
+
 	ret = copy_timer_indices(vcpu, uindices);
 	if (ret)
 		return ret;
@@ -214,6 +221,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
 		return get_core_reg(vcpu, reg);
 
+	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
+		return kvm_arm_get_fw_reg(vcpu, reg);
+
 	if (is_timer_reg(reg->id))
 		return get_timer_reg(vcpu, reg);
 
@@ -230,6 +240,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
 		return set_core_reg(vcpu, reg);
 
+	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
+		return kvm_arm_set_fw_reg(vcpu, reg);
+
 	if (is_timer_reg(reg->id))
 		return set_timer_reg(vcpu, reg);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4485ae8e98de..10af386642c6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -73,6 +73,9 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
+
+	/* Mandated version of PSCI */
+	u32 psci_version;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9abbf3044654..04b3256f8e6d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -206,6 +206,12 @@ struct kvm_arch_memory_slot {
 #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
 
+/* KVM-as-firmware specific pseudo-registers */
+#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
+					 KVM_REG_ARM_FW | ((r) & 0xffff))
+#define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5c7f657dd207..811f04c5760e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <kvm/arm_psci.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
 #include <asm/kvm.h>
@@ -205,7 +206,7 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 {
 	return num_core_regs() + kvm_arm_num_sys_reg_descs(vcpu)
-                + NUM_TIMER_REGS;
+		+ kvm_arm_get_fw_num_regs(vcpu)	+ NUM_TIMER_REGS;
 }
 
 /**
@@ -225,6 +226,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		uindices++;
 	}
 
+	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
+	if (ret)
+		return ret;
+	uindices += kvm_arm_get_fw_num_regs(vcpu);
+
 	ret = copy_timer_indices(vcpu, uindices);
 	if (ret)
 		return ret;
@@ -243,6 +249,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
 		return get_core_reg(vcpu, reg);
 
+	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
+		return kvm_arm_get_fw_reg(vcpu, reg);
+
 	if (is_timer_reg(reg->id))
 		return get_timer_reg(vcpu, reg);
 
@@ -259,6 +268,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
 		return set_core_reg(vcpu, reg);
 
+	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
+		return kvm_arm_set_fw_reg(vcpu, reg);
+
 	if (is_timer_reg(reg->id))
 		return set_timer_reg(vcpu, reg);
 
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index e7f69c0dc249..f2fa7d752c4e 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -23,7 +23,16 @@
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
 
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
+
 int kvm_psci_version(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
+struct kvm_one_reg;
+
+int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
+int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
+int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+
 #endif /* __KVM_ARM_PSCI_H__ */
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 6299501f7664..682f9be6264b 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -17,6 +17,7 @@
 
 #include <linux/preempt.h>
 #include <linux/kvm_host.h>
+#include <linux/uaccess.h>
 #include <linux/wait.h>
 
 #include <asm/cputype.h>
@@ -235,8 +236,19 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 
 int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
-	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
-		return KVM_ARM_PSCI_0_2;
+	/*
+	 * Our PSCI implementation stays the same across versions from
+	 * v0.2 onward, only adding the few mandatory functions (such
+	 * as FEATURES with 1.0) that are required by newer
+	 * revisions. It is thus safe to return the latest, unless
+	 * userspace has instructed us otherwise.
+	 */
+	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
+		if (vcpu->kvm->arch.psci_version)
+			return vcpu->kvm->arch.psci_version;
+
+		return KVM_ARM_PSCI_LATEST;
+	}
 
 	return KVM_ARM_PSCI_0_1;
 }
@@ -408,3 +420,55 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	};
 }
+
+int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
+{
+	return 1;		/* PSCI version */
+}
+
+int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
+{
+	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
+		void __user *uaddr = (void __user *)(long)reg->addr;
+		u64 val;
+
+		val = kvm_psci_version(vcpu, vcpu->kvm);
+		if (val == KVM_ARM_PSCI_0_1)
+			return -EINVAL;
+		if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (reg->id == KVM_REG_ARM_PSCI_VERSION &&
+	    test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
+		void __user *uaddr = (void __user *)(long)reg->addr;
+		u64 val;
+
+		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+			return -EFAULT;
+
+		switch (val) {
+		case KVM_ARM_PSCI_0_2:
+		case KVM_ARM_PSCI_1_0:
+			vcpu->kvm->arch.psci_version = val;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
-- 
2.14.2
