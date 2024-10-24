Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D588F1C2335
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 09:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762846; cv=none; b=Ks8YlcfOamw5IDigsg4Nrs7RMYefmU4680uicAbeGmyQSLobnmdBpNmSgvZZ3TSiiQYaOuX+4JNPGNa5NTpdIT0kRRv3/J7O3sdaLsXQTtjWsuKlFFH7kwxScmEwgXpL9hS/Uwt5kD1j3hSD6/K4pWCJCLh0ZJKwa+CFwGHaVHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762846; c=relaxed/simple;
	bh=geqWcSE3nv6Bg45W2dC9RlzM/Kx8Db+sCEyyAOdxBWE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mehS3e62MpRosbnh1imMXzeigbErotOo4U/bE+FDfE06ZbyZdYXHD2KMfqKPmc1KDY4AMMwiY9SeHNc6Umk7B4V3XKUKeos8jiy2IGJ/XYUki4TGFW6o13nZXTjql0U+/TbWNRS5uBkUgSNO21cLg1FI0UKUnKUAlFVrpPxsgnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ17b5vC3z6K5yF;
	Thu, 24 Oct 2024 17:38:35 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id E3AB9140D1A;
	Thu, 24 Oct 2024 17:40:41 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 11:40:35 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 1/3] KVM: arm64: Add hypercall support for retrieving migration targets
Date: Thu, 24 Oct 2024 10:40:10 +0100
Message-ID: <20241024094012.29452-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 frapeml500008.china.huawei.com (7.182.85.71)

If the VM requires migration to multiple targets, these hypercalls
will provide a way to inform the Guest kernel about those targets.
These hypercalls must be handled by userspace VMM to provide the
required details. In subsequent patches Guest kernel will use
these hypercalls to retrieve the target CPU information.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 Documentation/virt/kvm/arm/hypercalls.rst | 77 +++++++++++++++++++++++
 include/linux/arm-smccc.h                 | 13 ++++
 2 files changed, 90 insertions(+)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index af7bc2c2e0cb..ebd59fb72567 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -142,3 +142,80 @@ region is equal to the memory protection granule advertised by
 |                     |          |    +---------------------------------------------+
 |                     |          |    | ``INVALID_PARAMETER (-3)``                  |
 +---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID``
+------------------------------------------------------
+
+Query total number of migration target CPUs the Guest VM will be running during its
+lifetime and version information applicable to the data format used for
+``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID``. The maximum number of targets
+supported is 64. Also the version number supported currently is 1.0. This hypercall
+must be handled by the userspace VMM.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional; KVM/ARM64 Guests only                             |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC600007D                                       |
++---------------------+----------+--------------------------------------------------+
+| Arguments:          | None                                                        |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``NOT_SUPPORTED (-1)`` on error, else       |
+|                     |          |    | [0-31] total migration targets              |
+|                     |          |    | [32-63] version number                      |
++---------------------+----------+----+---------------------------------------------+
+|                     | (uint64) | R1 | Reserved / Must be zero                     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID``
+-------------------------------------------------------
+
+Request migration target CPU information for the Guest VM. The information must be
+provided as per the format described by the version info in
+``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID``. At present, we only support
+the below format which corresponds to version 1.0. This hypercall will always be
+preceded by ``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID`` and may be
+invoked multiple times to retrieve the total number of target CPUs information
+advertised. This hypercall must be handled by the userspace VMM.
+
+A typical userspace usage scenario will be like below:
+
+1. Receives ``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID``
+
+   * Returns total number of migration targets and version number
+   * Reset current target index to zero
+2. Receives ``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID``
+
+   * Returns MIDR/REVIDR info in return register fields. Can return up to 4
+   * Update current target index based on returned target info
+   * If there are remaining register fields, return zero to indicate the end
+   * Repeat step 2 until current target index == total number of migration targets
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional; KVM/ARM64 Guests only                             |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC600007E                                       |
++---------------------+----------+----+---------------------------------------------+
+| Arguments:          | None                                                        |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``NOT_SUPPORTED (-1)`` on error, else       |
+|                     |          |    | [0-31] MIDR, [31-63] REVIDR, else           |
+|                     |          |    | [0-63] Zero to mark end.                    |
++---------------------+----------+----+---------------------------------------------+
+|                     | (uint64) | R1 | [0-31] MIDR, [32-63] REVIDR, else           |
+|                     |          |    | [0-63] Zero to mark end.                    |
++---------------------+----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | [0-31] MIDR, [32-63] REVIDR, else           |
+|                     |          |    | [0-63] Zero to mark end.                    |
++---------------------+----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | [0-31] MIDR, [32-63] REVIDR, else           |
+|                     |          |    | [0-63] Zero to mark end.                    |
++---------------------+----------+----+---------------------------------------------+
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f59099a213d0..df87ce48ae9e 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -179,6 +179,8 @@
 #define ARM_SMCCC_KVM_FUNC_PKVM_RESV_62		62
 #define ARM_SMCCC_KVM_FUNC_PKVM_RESV_63		63
 /* End of pKVM hypercall range */
+#define ARM_SMCCC_KVM_FUNC_MIGRN_TARGET_NUM	125
+#define ARM_SMCCC_KVM_FUNC_MIGRN_TARGET_CPUS	126
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -225,6 +227,17 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID	\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_MIGRN_TARGET_NUM)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID	\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_MIGRN_TARGET_CPUS)
 /* ptp_kvm counter type ID */
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
-- 
2.45.2

