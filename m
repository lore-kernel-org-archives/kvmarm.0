Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE4F3595C
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739546081; cv=none; b=ZUyForl+FRBRYPpQVXX6fNBNHSQJVbUz5Wl1j8aNBNXSyEWvgVTTN1butrfp8cZf2aKNt3HzMLvrU5KD2T2lbhYOtzvfj0zZm4ZwnqmNvwCZicqAd1JBeXPqbP7o63WOHz3uPki5gZb4aX8qRIPVNR61sCqBGlmu7JoY+EOwlFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739546081; c=relaxed/simple;
	bh=ndvbDj8UdNMo2vAHfj+FIB2j8IfXmaEUqkuhDqHw8JE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HpUTn5f5ktJ3tpfMAAT35DpUZfqhK4mgx5bGja40mxVEdHfNO2OkQMr93W3JlG5iNcldUtuEgwfKzwbuFx05HQaP7/0klLrZGciUeMF3+N9mNF50T7PYp7EWV/rYff3msG8kbDqZK0J9Hmzh9wT816DmjJpyB7XvjqulZEZ1YCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Yvb9b1L2rz6L50b;
	Fri, 14 Feb 2025 23:11:31 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id F2EBF140B38;
	Fri, 14 Feb 2025 23:14:37 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Feb 2025 16:14:30 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v7 3/5] KVM: arm64: Introduce KVM_REG_ARM_VENDOR_HYP_BMAP_2
Date: Fri, 14 Feb 2025 15:13:41 +0000
Message-ID: <20250214151343.61348-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
References: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

The vendor_hyp_bmap bitmap holds the information about the Vendor Hyp
services available to the user space and can be get/set using
{G, S}ET_ONE_REG interfaces. This is done using the pseudo-firmware
bitmap register KVM_REG_ARM_VENDOR_HYP_BMAP.

At present, this bitmap is a 64 bit one and since the function numbers
for newly added DISCOVER_IPML_* hypercalls are 64-65, introduce
another pseudo-firmware bitmap register KVM_REG_ARM_VENDOR_HYP_BMAP_2.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../virt/kvm/arm/fw-pseudo-registers.rst          | 15 ++++++++++++++-
 arch/arm64/include/asm/kvm_host.h                 |  3 ++-
 arch/arm64/include/uapi/asm/kvm.h                 | 12 ++++++++++++
 arch/arm64/kvm/hypercalls.c                       | 13 +++++++++++++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/arm/fw-pseudo-registers.rst b/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
index b90fd0b0fa66..d78b53b05dfc 100644
--- a/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
+++ b/Documentation/virt/kvm/arm/fw-pseudo-registers.rst
@@ -116,7 +116,7 @@ The pseudo-firmware bitmap register are as follows:
       ARM DEN0057A.
 
 * KVM_REG_ARM_VENDOR_HYP_BMAP:
-    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls[0-63].
 
   The following bits are accepted:
 
@@ -127,6 +127,19 @@ The pseudo-firmware bitmap register are as follows:
     Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
       The bit represents the Precision Time Protocol KVM service.
 
+* KVM_REG_ARM_VENDOR_HYP_BMAP_2:
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls[64-127].
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_DISCOVER_IMPL_VER
+      This represents the ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID
+      function-id. This is reset to 0.
+
+    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_DISCOVER_IMPL_CPUS
+      This represents the ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID
+      function-id. This is reset to 0.
+
 Errors:
 
     =======  =============================================================
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..4cea172ebaaa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -237,7 +237,8 @@ struct kvm_arch_memory_slot {
 struct kvm_smccc_features {
 	unsigned long std_bmap;
 	unsigned long std_hyp_bmap;
-	unsigned long vendor_hyp_bmap;
+	unsigned long vendor_hyp_bmap; /* Function numbers 0-63 */
+	unsigned long vendor_hyp_bmap_2; /* Function numbers 64-127 */
 };
 
 typedef unsigned int pkvm_handle_t;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 568bf858f319..072feeff74d0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -371,6 +371,7 @@ enum {
 #endif
 };
 
+/* Vendor hyper call function numbers 0-63 */
 #define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
 
 enum {
@@ -381,6 +382,17 @@ enum {
 #endif
 };
 
+/* Vendor hyper call function numbers 64-127 */
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_2		KVM_REG_ARM_FW_FEAT_BMAP_REG(3)
+
+enum {
+	KVM_REG_ARM_VENDOR_HYP_BIT_DISCOVER_IMPL_VER	= 0,
+	KVM_REG_ARM_VENDOR_HYP_BIT_DISCOVER_IMPL_CPUS	= 1,
+#ifdef __KERNEL__
+	KVM_REG_ARM_VENDOR_HYP_BMAP_2_BIT_COUNT,
+#endif
+};
+
 /* Device Control API on vm fd */
 #define KVM_ARM_VM_SMCCC_CTRL		0
 #define   KVM_ARM_VM_SMCCC_FILTER	0
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 27ce4cb44904..569941eeb3fe 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -15,6 +15,8 @@
 	GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_COUNT - 1, 0)
 #define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES			\
 	GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT - 1, 0)
+#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES_2			\
+	GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_2_BIT_COUNT - 1, 0)
 
 static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 {
@@ -360,6 +362,8 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = smccc_feat->vendor_hyp_bmap;
+		/* Function numbers 2-63 are reserved for pKVM for now */
+		val[2] = smccc_feat->vendor_hyp_bmap_2;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -387,6 +391,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
 	KVM_REG_ARM_VENDOR_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP_2,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -497,6 +502,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_VENDOR_HYP_BMAP:
 		val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP_2:
+		val = READ_ONCE(smccc_feat->vendor_hyp_bmap_2);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -527,6 +535,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
 		fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP_2:
+		fw_reg_bmap = &smccc_feat->vendor_hyp_bmap_2;
+		fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES_2;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -633,6 +645,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 	case KVM_REG_ARM_STD_HYP_BMAP:
 	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+	case KVM_REG_ARM_VENDOR_HYP_BMAP_2:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
-- 
2.47.0

