Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7564F8A2
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Sfgpf1STPz1P8r5;
	Tue, 28 Nov 2023 19:54:02 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 28 Nov 2023 19:57:38 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
	<sashal@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<andrew.murray@arm.com>, <mark.rutland@arm.com>, <suzuki.poulose@arm.com>,
	<wanghaibin.wang@huawei.com>, <will@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>
Subject: [for-5.4 2/2] KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
Date: Tue, 28 Nov 2023 19:57:25 +0800
Message-ID: <20231128115725.964-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20231128115725.964-1-yuzenghui@huawei.com>
References: <20231128115725.964-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/sysreg.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c       | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1ff93878c813..290a1fa7cacf 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -697,6 +697,12 @@
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
index a25f737dfa0b..5aae2f9f0ac8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1089,6 +1089,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
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

