Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9471722B59F
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810224; cv=none; b=ORFZKlCdVF0bIlGsgXuJVuWQGr1gSKCFqJANzjcomZIfEJ8lFwZo/q9wNuI7iFoIGntXJg/l13J9QrOEM/HBZGDQ22FH8BajH8rEpRqRCSsnRR/UA8ZLxEnu7oJqMI954Oe8f8TpHbCN25tZ7a8BeeS3PF7qsf6yhF4Dt6Z5+1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810224; c=relaxed/simple;
	bh=XPh0+Rr+R964H/rZFfWv0puI6J1X0RHc0/MYTvCovHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xtcp5AKSHdV8fTwqpPunAnPTIp88SMFq8I8qVg2hrfUmWV8jFpglmaEWJ/uDxO7E82izAMeiAv7oFnaoZ82zFPsARcdh9nDo1mBe8A0PdIFaecZd2fzhMb8QGLQCAtmFn3hbxwBDgSUEZreLYAW98U6dAqiekmbXa9ouMJNE6WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4477D339;
	Mon,  9 Dec 2024 21:57:30 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 23A9B3F58B;
	Mon,  9 Dec 2024 21:56:57 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: ryan.roberts@arm.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH V2 44/46] KVM: arm64: nv: Add FEAT_FGT2 registers access from virtual EL2
Date: Tue, 10 Dec 2024 11:23:09 +0530
Message-Id: <20241210055311.780688-45-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241210055311.780688-1-anshuman.khandual@arm.com>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds VNCR-capable HDFGRTR2_EL2, HDFGWTR2_EL2, HFGRTR2_EL2, HFGWTR2_EL2
and HFGITR2_EL2 FEAT_FGT2 registers into enum vcpu_sysreg, and also enables
their access from virtual EL2 environment.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_host.h     | 5 +++++
 arch/arm64/include/asm/vncr_mapping.h | 5 +++++
 arch/arm64/kvm/sys_regs.c             | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..73ff8772ac22 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -548,6 +548,11 @@ enum vcpu_sysreg {
 	VNCR(HDFGWTR_EL2),
 	VNCR(HAFGRTR_EL2),
 
+	VNCR(HDFGRTR2_EL2),
+	VNCR(HDFGWTR2_EL2),
+	VNCR(HFGITR2_EL2),
+	VNCR(HFGRTR2_EL2),
+	VNCR(HFGWTR2_EL2),
 	VNCR(CNTVOFF_EL2),
 	VNCR(CNTV_CVAL_EL0),
 	VNCR(CNTV_CTL_EL0),
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 4f9bbd4d6c26..d6110d7c36e2 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -38,6 +38,8 @@
 #define VNCR_HFGRTR_EL2		0x1B8
 #define VNCR_HFGWTR_EL2		0x1C0
 #define VNCR_HFGITR_EL2		0x1C8
+#define VNCR_HDFGRTR2_EL2	0x1A0
+#define VNCR_HDFGWTR2_EL2	0x1B0
 #define VNCR_HDFGRTR_EL2	0x1D0
 #define VNCR_HDFGWTR_EL2	0x1D8
 #define VNCR_ZCR_EL1            0x1E0
@@ -52,6 +54,9 @@
 #define VNCR_PIRE0_EL1		0x290
 #define VNCR_PIR_EL1		0x2A0
 #define VNCR_POR_EL1		0x2A8
+#define VNCR_HFGRTR2_EL2	0x2C0
+#define VNCR_HFGWTR2_EL2	0x2C8
+#define VNCR_HFGITR2_EL2	0x310
 #define VNCR_ICH_LR0_EL2        0x400
 #define VNCR_ICH_LR1_EL2        0x408
 #define VNCR_ICH_LR2_EL2        0x410
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 83c6b4a07ef5..c9e0e9322bd3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3004,9 +3004,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
 	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
+	EL2_REG_VNCR(HDFGRTR2_EL2, reset_val, 0),
+	EL2_REG_VNCR(HDFGWTR2_EL2, reset_val, 0),
+	EL2_REG_VNCR(HFGRTR2_EL2, reset_val, 0),
+	EL2_REG_VNCR(HFGWTR2_EL2, reset_val, 0),
 	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HDFGWTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HAFGRTR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HFGITR2_EL2, reset_val, 0),
 	EL2_REG_REDIR(SPSR_EL2, reset_val, 0),
 	EL2_REG_REDIR(ELR_EL2, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
-- 
2.25.1

