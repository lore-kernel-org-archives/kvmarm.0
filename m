Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1DA32
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738761794; cv=none; b=ajSbF6Ft9tmvovhI6SJ13d7SljBmgRSJo79ynoBy4LR6Ixu+kM4CJtNo8FFzyPom3FJ5aaPswUsxMGp8MaT0guQRvgVl1Mt9Hag53z5E5o8DeOkVipBGZON1poVt/GWqSZTmBoi/aIJrpDQV4wvJuIGCGCsGUOQ0Ct/Hl8Tcxbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738761794; c=relaxed/simple;
	bh=Prap320kNj3UTYPXBTXnMVH89ls/14mv/Q5TOMs1abM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttEk5Lr2Gda8l65EXLyMYW5HfsBE9LDmUDTikabNYx0lRlRO/J06SoVKv3tFolB0P9kn4EKhXKZCVE4YnVrSpsBWEseHK5SPbALvXB3/+7EK/lztMh2MZX/37+m08u3ZTf5GPRz3ptDpr4W4/StRmzri4MQkyeK48MbRGTylfTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Yp19c6NvKz6HJbM;
	Wed,  5 Feb 2025 21:22:12 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B6FE140516;
	Wed,  5 Feb 2025 21:23:08 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Feb 2025 14:23:00 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v6 2/4] KVM: arm64: Introduce hypercall support for retrieving target implementations
Date: Wed, 5 Feb 2025 13:22:20 +0000
Message-ID: <20250205132222.55816-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
References: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

If the Guest requires migration to multiple targets, these hypercalls
will provide a way to retrieve the target CPU implementations from
the user space VMM.

Subsequent patch will use this to enable the associated errata.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 Documentation/virt/kvm/arm/hypercalls.rst | 59 +++++++++++++++++++++++
 include/linux/arm-smccc.h                 | 15 ++++++
 2 files changed, 74 insertions(+)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index af7bc2c2e0cb..7400a89aabf8 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -142,3 +142,62 @@ region is equal to the memory protection granule advertised by
 |                     |          |    +---------------------------------------------+
 |                     |          |    | ``INVALID_PARAMETER (-3)``                  |
 +---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID``
+-------------------------------------------------------
+Request the target CPU implementation version information and the number of target
+implementations for the Guest VM.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional;  KVM/ARM64 Guests only                            |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC6000040                                       |
++---------------------+----------+--------------------------------------------------+
+| Arguments:          | None                                                        |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``SUCCESS (0)``                             |
+|                     |          |    +---------------------------------------------+
+|                     |          |    | ``NOT_SUPPORTED (-1)``                      |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R1 | Bits [63:32] Reserved/Must be zero          |
+|                     |          |    +---------------------------------------------+
+|                     |          |    | Bits [31:16] Major version                  |
+|                     |          |    +---------------------------------------------+
+|                     |          |    | Bits [15:0] Minor version                   |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | Number of target implementations            |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID``
+-------------------------------------------------------
+
+Request the target CPU implementation information for the Guest VM. The Guest kernel
+will use this information to enable the associated errata.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Optional;  KVM/ARM64 Guests only                            |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC64                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0xC6000041                                       |
++---------------------+----------+----+---------------------------------------------+
+| Arguments:          | (uint64) | R1 | selected implementation index               |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | Reserved / Must be zero                     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | Reserved / Must be zero                     |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (int64)  | R0 | ``SUCCESS (0)``                             |
+|                     |          |    +---------------------------------------------+
+|                     |          |    | ``INVALID_PARAMETER (-3)``                  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R1 | MIDR_EL1 of the selected implementation     |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R2 | REVIDR_EL1 of the selected implementation   |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint64) | R3 | AIDR_EL1  of the selected implementation    |
++---------------------+----------+----+---------------------------------------------+
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 67f6fdf2e7cd..f19be5754090 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -179,6 +179,9 @@
 #define ARM_SMCCC_KVM_FUNC_PKVM_RESV_62		62
 #define ARM_SMCCC_KVM_FUNC_PKVM_RESV_63		63
 /* End of pKVM hypercall range */
+#define ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER	64
+#define ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS	65
+
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -225,6 +228,18 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS)
+
 /* ptp_kvm counter type ID */
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
-- 
2.47.0

