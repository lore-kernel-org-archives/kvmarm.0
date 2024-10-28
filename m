Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74AD18CC1F
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 05:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093700; cv=none; b=DbG44Y4XfMXaAVEs29d1E3OYM2y3Rsga/vzDER7Uq//2ne7nB6vyCG1fNzwpYg/eU5gR7kEbS6k3hU3GelOqrBobg9NF2UHiJwoqf5NkRehJu4jX2wBfyCVT90VREBQxmOfbCVxUC80ZugN5n+Z6cdB8ggZEDegUL8Yl71rOAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093700; c=relaxed/simple;
	bh=ShmzgYBWJS9FOhUzx3tAhqp5xovGEdeE1ph89mUqQA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LGYyh/jkvAJGzz8Dhu0xOWpZmgQJHK0Zbc+f3OSWa1/rO+CaEQaTzCz8pq+RpX6ui9JzlYO7albth+bi4TihHLuFk8ergwCyDGVh6eY/YeOmPJtRM5zCIpATEAxmmGmT7mS6hDVdI6KhHN4UGtg1gdKQIgwISQyV7tdODle1xGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AC5C13D5;
	Sun, 27 Oct 2024 22:35:28 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BDC073F66E;
	Sun, 27 Oct 2024 22:34:54 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V2 5/7] arm64/cpufeature: Add field details for ID_AA64DFR1_EL1 register
Date: Mon, 28 Oct 2024 11:04:24 +0530
Message-Id: <20241028053426.2486633-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241028053426.2486633-1-anshuman.khandual@arm.com>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
ftr_raz[] array which is now redundant. These register fields will be used
to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
later.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 718728a85430..bd4d85f5dd92 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -530,6 +530,21 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_mvfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_EL1_FPRound_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_EL1_FPShVec_SHIFT, 4, 0),
@@ -708,10 +723,6 @@ static const struct arm64_ftr_bits ftr_single32[] = {
 	ARM64_FTR_END,
 };
 
-static const struct arm64_ftr_bits ftr_raz[] = {
-	ARM64_FTR_END,
-};
-
 #define __ARM64_FTR_REG_OVERRIDE(id_str, id, table, ovr) {	\
 		.sys_id = id,					\
 		.reg = 	&(struct arm64_ftr_reg){		\
@@ -784,7 +795,7 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 0, CRm = 5 */
 	ARM64_FTR_REG(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0),
-	ARM64_FTR_REG(SYS_ID_AA64DFR1_EL1, ftr_raz),
+	ARM64_FTR_REG(SYS_ID_AA64DFR1_EL1, ftr_id_aa64dfr1),
 
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
-- 
2.25.1

