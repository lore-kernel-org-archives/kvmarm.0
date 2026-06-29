Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581913BA22C;
	Mon, 29 Jun 2026 11:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731926; cv=none; b=knc1VMme09DbJCC+/5QmRhj+RATB/FFkSx+FdlEoLKbIhKxQ1v7DCv0cuCAXOQ8xF0h0Nucf62KT0zexAuoM67bHE10LKjYqhlQV1lhxgDt3F21Od9QgkDNu93mHYPfkWpPV2NGwYtMRrl3NGG4rL4KI5M07IOOQpd3jmu+SN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731926; c=relaxed/simple;
	bh=NTafxyWoQwJKQypfZbrK+JAZLsXTRtv4BmZq2vRk5sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK2zkwNMS9uMeN7F/wEjRWeAlufCF4MrzCfoZ0Qc9Yq7m0luBCQohB1kFh04NbL5FyeIzi+oIRRvype+IkTr1l9FRQz8ItxEk5IakeN/a9Ok8/w8My02/C8/kYuNqErs79ddcDN9A5ett3JwgvaURKs6YyfLLfJuukJ9/Q6m6oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b+cV4nBL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b+cV4nBL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56D64169E;
	Mon, 29 Jun 2026 04:18:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9807B3FA21;
	Mon, 29 Jun 2026 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731924; bh=NTafxyWoQwJKQypfZbrK+JAZLsXTRtv4BmZq2vRk5sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+cV4nBLpd58NT7CzVHKhE/LrFLTUMtKHbSCNk5xlTO5v4EeSgcQT9yLjp1yonnPa
	 nW2CLokvw/8pCDg2/3HvTbaaF6qDe1qBtDmnM6IxdL3x0SAdYLJ9HoT8FfDGoR8Xcn
	 Gn4CNVZNuuyi9xa397bLCmmaeIOf7IhPmn4JmhMY=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 03/13] arm64/cpufeature: Add system-wide FEAT_HACDBS detection
Date: Mon, 29 Jun 2026 12:17:51 +0100
Message-ID: <20260629111820.1873540-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629111820.1873540-1-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4237; i=leo.bras@arm.com; h=from:subject; bh=NTafxyWoQwJKQypfZbrK+JAZLsXTRtv4BmZq2vRk5sI=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQhLmxTSuYI1hUlX1LhJOX9/f8Ucr5QqHwd/2IpXL+ e/Y2uZ1lLIwiHExyIopssg+mr+K5/uUjCNXfiyAmcPKBDKEgYtTACZiZsLwv7Zs8pFt/doeeqEe 0Twhed5aK2OKNj+3OuX82+db/pzNbQz/Kzkiz2V+VVJlizo8na879flfmyny96/dkn+//GpF/ow +VgA=
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

FEAT_HACDBS will only be used for dirty-bit cleaning if it is detected in
all running cpus.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 5 +++++
 arch/arm64/kernel/cpufeature.c      | 8 ++++++++
 arch/arm64/tools/cpucaps            | 1 +
 3 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index bdfab086fd94..620ae4cddb76 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -861,20 +861,25 @@ static inline bool system_supports_gcs(void)
 static inline bool system_supports_haft(void)
 {
 	return cpus_have_final_cap(ARM64_HAFT);
 }
 
 static inline bool system_supports_hdbss(void)
 {
 	return cpus_have_final_cap(ARM64_HAS_HDBSS);
 }
 
+static inline bool system_supports_hacdbs(void)
+{
+	return cpus_have_final_cap(ARM64_HACDBS);
+}
+
 static __always_inline bool system_supports_mpam(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM);
 }
 
 static __always_inline bool system_supports_mpam_hcr(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
 }
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index aa327eebaf1c..62f56bbd0a65 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -516,20 +516,21 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 		       FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_SCTLRX_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_TCRX_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_HACDBS_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
 static const struct arm64_ftr_bits ftr_ctr[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1), /* RES1 */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_DIC_SHIFT, 1, 1),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_IDC_SHIFT, 1, 1),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, CTR_EL0_CWG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, CTR_EL0_ERG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_DminLine_SHIFT, 4, 1),
@@ -2764,20 +2765,27 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Hardware dirty bit management",
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		.capability = ARM64_HW_DBM,
 		.matches = has_hw_dbm,
 		.cpu_enable = cpu_enable_hw_dbm,
 		.cpus = &dbm_cpus,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, DBM)
 	},
 #endif
+	{
+		.desc = "Hardware dirty bit Cleaning",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HACDBS,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, HACDBS, IMP)
+	},
 #ifdef CONFIG_ARM64_HAFT
 	{
 		.desc = "Hardware managed Access Flag for Table Descriptors",
 		/*
 		 * Contrary to the page/block access flag, the table access flag
 		 * cannot be emulated in software (no access fault will occur).
 		 * Therefore this should be used only if it's supported system
 		 * wide.
 		 */
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index a87706c9d160..bd2c0bb98da6 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -65,20 +65,21 @@ HAS_STAGE2_FWB
 HAS_TCR2
 HAS_TIDCP1
 HAS_TLB_RANGE
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HAS_XNX
 HAS_HDBSS
 HAFT
 HW_DBM
+HACDBS
 KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MPAM
 MPAM_HCR
 MTE
 MTE_ASYMM
 MTE_FAR
 MTE_STORE_ONLY
 SME
-- 
2.54.0

