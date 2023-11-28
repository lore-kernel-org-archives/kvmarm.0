Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD3314003
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 07:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SfZD04b2HzMnPs;
	Tue, 28 Nov 2023 15:42:08 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 28 Nov 2023 15:46:57 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
	<sashal@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<andrew.murray@arm.com>, <mark.rutland@arm.com>, <suzuki.poulose@arm.com>,
	<wanghaibin.wang@huawei.com>, <will@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>
Subject: [for-4.19 2/2] KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
Date: Tue, 28 Nov 2023 15:46:33 +0800
Message-ID: <20231128074633.646-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20231128074633.646-1-yuzenghui@huawei.com>
References: <20231128074633.646-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

From: Andrew Murray <andrew.murray@arm.com>

commit c854188ea01062f5a5fd7f05658feb1863774eaa upstream.

We currently expose the PMU version of the host to the guest via
emulation of the DFR0_EL1 and AA64DFR0_EL1 debug feature registers.
However many of the features offered beyond PMUv3 for 8.1 are not
supported in KVM. Examples of this include support for the PMMIR
registers (added in PMUv3 for ARMv8.4) and 64-bit event counters
added in (PMUv3 for ARMv8.5).

Let's trap the Debug Feature Registers in order to limit
PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.1
to avoid unexpected behaviour.

Both ID_AA64DFR0.PMUVer and ID_DFR0.PerfMon follow the "Alternative ID
scheme used for the Performance Monitors Extension version" where 0xF
means an IMPLEMENTATION DEFINED PMU is implemented, and values 0x0-0xE
are treated as with an unsigned field (with 0x0 meaning no PMU is
present). As we don't expect to expose an IMPLEMENTATION DEFINED PMU,
and our cap is below 0xF, we can treat these fields as unsigned when
applying the cap.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Mark: make field names consistent, use perfmon cap]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[yuzenghui@huawei.com: adjust the context in read_id_reg()]
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/sysreg.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c       | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 22266c7e2cc1..0a8342de5796 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -622,6 +622,12 @@
 #define ID_AA64DFR0_TRACEVER_SHIFT	4
 #define ID_AA64DFR0_DEBUGVER_SHIFT	0
 
+#define ID_AA64DFR0_PMUVER_8_1		0x4
+
+#define ID_DFR0_PERFMON_SHIFT		24
+
+#define ID_DFR0_PERFMON_8_1		0x4
+
 #define ID_ISAR5_RDM_SHIFT		24
 #define ID_ISAR5_CRC32_SHIFT		16
 #define ID_ISAR5_SHA2_SHIFT		12
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f06629bf2be1..2799e7e9915a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1049,6 +1049,16 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
+	} else if (id == SYS_ID_AA64DFR0_EL1) {
+		/* Limit guests to PMUv3 for ARMv8.1 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						ID_AA64DFR0_PMUVER_SHIFT,
+						ID_AA64DFR0_PMUVER_8_1);
+	} else if (id == SYS_ID_DFR0_EL1) {
+		/* Limit guests to PMUv3 for ARMv8.1 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_1);
 	}
 
 	return val;
-- 
2.33.0

