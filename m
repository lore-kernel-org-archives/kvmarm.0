Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CB9C2DA
	for <kvmarm@lists.linux.dev>; Fri, 25 Aug 2023 09:36:25 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXF8R4527z6K659;
	Fri, 25 Aug 2023 17:31:51 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:16 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>, <will@kernel.org>,
	<catalin.marinas@arm.com>, <oliver.upton@linux.dev>
CC: <james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<zhukeqian1@huawei.com>, <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 1/8] arm64: cpufeature: Add API to report system support of HWDBM
Date: Fri, 25 Aug 2023 10:35:21 +0100
Message-ID: <20230825093528.1637-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

From: Keqian Zhu <zhukeqian1@huawei.com>

Though we already has a cpu capability named ARM64_HW_DBM, it's a
LOCAL_CPU cap and conditionally compiled by CONFIG_ARM64_HW_AFDBM.

This reports the system wide support of HW_DBM.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 96e50227f940..edb04e45e030 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -733,6 +733,21 @@ static inline bool system_supports_mixed_endian(void)
 	return val == 0x1;
 }
 
+static inline bool system_supports_hw_dbm(void)
+{
+	u64 mmfr1;
+	u32 val;
+
+	if (!IS_ENABLED(CONFIG_ARM64_HW_AFDBM))
+		return false;
+
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	val = cpuid_feature_extract_unsigned_field(mmfr1,
+						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
+
+	return val == ID_AA64MMFR1_EL1_HAFDBS_DBM;
+}
+
 static __always_inline bool system_supports_fpsimd(void)
 {
 	return !cpus_have_const_cap(ARM64_HAS_NO_FPSIMD);
-- 
2.34.1

