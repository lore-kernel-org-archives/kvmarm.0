From: Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v2 05/12] KVM: arm64: Implement PV_FEATURES call
Date: Wed, 12 Dec 2018 15:02:19 +0000
Message-ID: <20181212150226.38051-6-steven.price@arm.com>
References: <20181212150226.38051-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84AB64A2BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 24IiJ0JzEfib for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 10:03:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A5B4A327
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 10:03:08 -0500 (EST)
In-Reply-To: <20181212150226.38051-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This provides a mechanism for querying which paravirtualized features
are available in this hypervisor.

Also add the header file which defines the ABI for the paravirtualized
clock features we're about to add.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/pvclock-abi.h | 32 ++++++++++++++++++++++++++++
 include/linux/arm-smccc.h            | 20 +++++++++++++++++
 virt/kvm/arm/hypercalls.c            |  9 ++++++++
 3 files changed, 61 insertions(+)
 create mode 100644 arch/arm64/include/asm/pvclock-abi.h

diff --git a/arch/arm64/include/asm/pvclock-abi.h b/arch/arm64/include/asm/pvclock-abi.h
new file mode 100644
index 000000000000..4f710dec6592
--- /dev/null
+++ b/arch/arm64/include/asm/pvclock-abi.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Arm Ltd. */
+
+#ifndef __ASM_PVCLOCK_ABI_H
+#define __ASM_PVCLOCK_ABI_H
+
+/* The below structures and constants are defined in ARM DEN0057A */
+
+struct pvclock_vm_time_info {
+	__le32 revision;
+	__le32 attributes;
+	__le64 sequence_number;
+	__le64 scale_mult;
+	__le32 shift;
+	__le32 reserved;
+	__le64 native_freq;
+	__le64 pv_freq;
+	__le64 div_by_pv_freq_mult;
+} __packed;
+
+struct pvclock_vcpu_stolen_time_info {
+	__le32 revision;
+	__le32 attributes;
+	__le64 stolen_time;
+	/* Structure must be 64 byte aligned, pad to that size */
+	u8 padding[48];
+} __packed;
+
+#define PV_VM_TIME_NOT_SUPPORTED	-1
+#define PV_VM_TIME_INVALID_PARAMETERS	-2
+
+#endif
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 4d5ec5f10a51..12e88e1ba222 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -54,6 +54,7 @@
 #define ARM_SMCCC_OWNER_SIP		2
 #define ARM_SMCCC_OWNER_OEM		3
 #define ARM_SMCCC_OWNER_STANDARD	4
+#define ARM_SMCCC_OWNER_STANDARD_HYP	5
 #define ARM_SMCCC_OWNER_TRUSTED_APP	48
 #define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
@@ -355,5 +356,24 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 		method;							\
 	})
 
+/* Paravirtualised time calls (defined by ARM DEN0057A) */
+#define ARM_SMCCC_HV_PV_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_TIME_LPT				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x21)
+
+#define ARM_SMCCC_HV_PV_TIME_ST					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x22)
+
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index 153aa7642100..ba13b798f0f8 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/pvclock-abi.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
@@ -40,6 +41,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				break;
 			}
 			break;
+		case ARM_SMCCC_HV_PV_FEATURES:
+			val = SMCCC_RET_SUCCESS;
+			break;
+		}
+		break;
+	case ARM_SMCCC_HV_PV_FEATURES:
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
 		}
 		break;
 	default:
-- 
2.19.2
