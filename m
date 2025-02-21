Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE035433DE
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740147001; cv=none; b=paG6FV2NcriQicwFLJU7npYaFagc6PDhew1f6qt5LpP48i0fkIxBKkeruIX8PsaYEs7IZjMDGQsVdjn0HpKeFnsTKIGx9f+vBYiBPbg7QgUoBWm8JkE3A4W6E9gs7HK5XaGDkUg2ieSWySNRBMb6yGcVrt3lzBAHbzvNElt/Iig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740147001; c=relaxed/simple;
	bh=/tvZ/O5YvhEaCmiagDCefZxPVhhaj3Z4Qqnl47ymJLU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKFQYfoy11p0dLOuZMIOxvvcNX7ThDDjt0Rwz59oJfFLoHFYPW3qgF2bNLy4P8PDqTTi8rux+YO1QwumnGIFbA92Lu3a0aQLegKe78mP3Kut7BrKZp/Z+CjurvLTEwmMRQlE+ArOdwp0e/pu619ARZCNOGl9AAYQg90yJIJ+vbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YzsRN65mhz6HJhN;
	Fri, 21 Feb 2025 22:08:16 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 54BAE140134;
	Fri, 21 Feb 2025 22:09:58 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Feb 2025 15:09:50 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v8 6/6] KVM: selftests: Add test for KVM_REG_ARM_VENDOR_HYP_BMAP_2
Date: Fri, 21 Feb 2025 14:02:29 +0000
Message-ID: <20250221140229.12588-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

One difference here with other pseudo-firmware bitmap registers
is that the default/reset value for the supported hypercall
function-ids is 0 at present. Hence, modify the test accordingly.

Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 tools/arch/arm64/include/uapi/asm/kvm.h       | 12 +++++
 .../selftests/kvm/arm64/get-reg-list.c        |  1 +
 .../testing/selftests/kvm/arm64/hypercalls.c  | 46 +++++++++++++++----
 3 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 66736ff04011..6d44f8c8a18f 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -374,6 +374,7 @@ enum {
 #endif
 };
 
+/* Vendor hyper call function numbers 0-63 */
 #define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
 
 enum {
@@ -384,6 +385,17 @@ enum {
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
diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index d43fb3f49050..d01798b6b3b4 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -332,6 +332,7 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(3),	/* KVM_REG_ARM_VENDOR_HYP_BMAP_2 */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index ec54ec7726e9..44cfcf8a7f46 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -21,22 +21,31 @@
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
 #define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_2_BIT_MAX   1
+
+#define KVM_REG_ARM_STD_BMAP_RESET_VAL		FW_REG_ULIMIT_VAL(KVM_REG_ARM_STD_BMAP_BIT_MAX)
+#define KVM_REG_ARM_STD_HYP_BMAP_RESET_VAL	FW_REG_ULIMIT_VAL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX)
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_RESET_VAL	FW_REG_ULIMIT_VAL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX)
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_2_RESET_VAL 0
 
 struct kvm_fw_reg_info {
 	uint64_t reg;		/* Register definition */
 	uint64_t max_feat_bit;	/* Bit that represents the upper limit of the feature-map */
+	uint64_t reset_val;	/* Reset value for the register */
 };
 
 #define FW_REG_INFO(r)			\
 	{					\
 		.reg = r,			\
 		.max_feat_bit = r##_BIT_MAX,	\
+		.reset_val = r##_RESET_VAL	\
 	}
 
 static const struct kvm_fw_reg_info fw_reg_info[] = {
 	FW_REG_INFO(KVM_REG_ARM_STD_BMAP),
 	FW_REG_INFO(KVM_REG_ARM_STD_HYP_BMAP),
 	FW_REG_INFO(KVM_REG_ARM_VENDOR_HYP_BMAP),
+	FW_REG_INFO(KVM_REG_ARM_VENDOR_HYP_BMAP_2),
 };
 
 enum test_stage {
@@ -171,22 +180,39 @@ static void test_fw_regs_before_vm_start(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
 		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
+		uint64_t set_val;
 
-		/* First 'read' should be an upper limit of the features supported */
+		/* First 'read' should be the reset value for the reg  */
 		val = vcpu_get_reg(vcpu, reg_info->reg);
-		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
-			"Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx",
-			reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
+		TEST_ASSERT(val == reg_info->reset_val,
+			"Unexpected reset value for reg: 0x%lx; expected: 0x%lx; read: 0x%lx",
+			reg_info->reg, reg_info->reset_val, val);
+
+		if (reg_info->reset_val)
+			set_val = 0;
+		else
+			set_val = FW_REG_ULIMIT_VAL(reg_info->max_feat_bit);
 
-		/* Test a 'write' by disabling all the features of the register map */
-		ret = __vcpu_set_reg(vcpu, reg_info->reg, 0);
+		ret = __vcpu_set_reg(vcpu, reg_info->reg, set_val);
 		TEST_ASSERT(ret == 0,
-			"Failed to clear all the features of reg: 0x%lx; ret: %d",
-			reg_info->reg, errno);
+			"Failed to %s all the features of reg: 0x%lx; ret: %d",
+			(set_val ? "set" : "clear"), reg_info->reg, errno);
 
 		val = vcpu_get_reg(vcpu, reg_info->reg);
-		TEST_ASSERT(val == 0,
-			"Expected all the features to be cleared for reg: 0x%lx", reg_info->reg);
+		TEST_ASSERT(val == set_val,
+			"Expected all the features to be %s for reg: 0x%lx",
+			(set_val ? "set" : "cleared"), reg_info->reg);
+
+		/*
+		 * If the reg has been set, clear it as test_fw_regs_after_vm_start()
+		 * expects it to be cleared.
+		 */
+		if (set_val) {
+			ret = __vcpu_set_reg(vcpu, reg_info->reg, 0);
+			TEST_ASSERT(ret == 0,
+			"Failed to clear all the features of reg: 0x%lx; ret: %d",
+			reg_info->reg, errno);
+		}
 
 		/*
 		 * Test enabling a feature that's not supported.
-- 
2.47.0

