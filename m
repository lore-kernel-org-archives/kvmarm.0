Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A9209F46
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633156; cv=none; b=i9orFY/sDw17qXEVmxB1XOYtbeW/bD/7UoHsGESggBvtO1oDBsuiSs1vp97WQLwOWW0j3mJXXymajdyztgeq0xg+quR+POqK0Gidr7s5Z/ahUlyP9Cu9xOir0nB1jepLGnJattgHvLmygW44bKmp/yoAXgA2nAuU5KbEO6uRzSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633156; c=relaxed/simple;
	bh=EGMNxsq+ae7mMtsKJOytwtZamVz3iSBFK/NcfU+dakk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhGPwFRlu8Q1oDcEVpvl7f/EfycDc3GnUKRz7nroGNWm9TwHKywTGfrAUCkp3qa4x6Wm4okLeleSRU8uxdrxQV3ji8fc1acH6n8EvA37vrIGAmSqYmgHFzjozP8OT12LKrvu0vcl97LUbwsU9451hZ0M5jVELkl+/vNznq7/vBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzJB0qV2z6GFGy;
	Fri, 11 Oct 2024 15:48:10 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 125D3140451;
	Fri, 11 Oct 2024 15:52:32 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:52:24 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 4/6] KVM: arm64: Add hypercall support for retrieving migration errata bitmap
Date: Fri, 11 Oct 2024 08:50:51 +0100
Message-ID: <20241011075053.80540-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

If the VM requires migration and has set the list of target CPUs, retrieve
the errata bitmap for those targets. The Guest can use this hypercall
to get the errata bitmap. The bitmaps will be returned in R0-R3 registers.

ToDo: For now, reused one of the reserved pKVM hypercall value for this
as I noticed that the vendor_hyp_bmap size needs to be adjusted to have
anything > 63 set.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/hypercalls.c       | 20 ++++++++++++++++++++
 include/linux/arm-smccc.h         |  8 +++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 321f86d747c8..a518cb3a744b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -379,6 +379,7 @@ enum {
 enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
+	KVM_REG_ARM_VENDOR_HYP_BIT_MIGRN_ERRATA	= 5,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5763d979d8ca..4433cd56cbc2 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -116,6 +116,9 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA:
+		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_MIGRN_ERRATA,
+				&smccc_feat->vendor_hyp_bmap);
 	default:
 		return false;
 	}
@@ -364,6 +367,23 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA: {
+		struct migrn_target_cpu *migrn_cpu = vcpu->kvm->arch.migrn_cpu;
+		unsigned long *errata_map;
+
+		if (!migrn_cpu || (ARM64_NCAPS > (BITS_PER_LONG * 4)))
+			goto out;
+
+		errata_map = bitmap_zalloc(ARM64_NCAPS, GFP_KERNEL);
+		if (!errata_map)
+			goto out;
+		for (int i = 0; i < vcpu->kvm->arch.num_migrn_cpus; i++, migrn_cpu++)
+			arm_get_migrn_errata_map(migrn_cpu, errata_map);
+
+		bitmap_to_arr64(val, errata_map, ARM64_NCAPS);
+		bitmap_free(errata_map);
+		break;
+	}
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f59099a213d0..839b3dfad590 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -119,7 +119,7 @@
 #define ARM_SMCCC_KVM_FUNC_HYP_MEMINFO		2
 #define ARM_SMCCC_KVM_FUNC_MEM_SHARE		3
 #define ARM_SMCCC_KVM_FUNC_MEM_UNSHARE		4
-#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_5		5
+#define ARM_SMCCC_KVM_FUNC_MIGRN_ERRATA		5
 #define ARM_SMCCC_KVM_FUNC_PKVM_RESV_6		6
 #define ARM_SMCCC_KVM_FUNC_MMIO_GUARD		7
 #define ARM_SMCCC_KVM_FUNC_PKVM_RESV_8		8
@@ -225,6 +225,12 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_MIGRN_ERRATA)
+
 /* ptp_kvm counter type ID */
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
-- 
2.45.2

