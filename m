Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569A16F076
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750825; cv=none; b=qa8+zVMBZqDE3mZ3/bKU2c2uDJoBhoIAKDoboyY7+VoaKaPxmgHP0OmqHj26gbq4SzMUAhZkjf7NnLskdAP1ENgHm7QxGA78nEZ+NuEhxmqt+3FBZqAuikB4eMKQ6BhcFXBbOjucvbPfeHfT+iBz8A1+vuBNpnvZeUT70I/wwUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750825; c=relaxed/simple;
	bh=QGnBB22jmRptXYSHNoWtj18XmGZ3BQmCB3OHM2NXs4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=of/AkkX6kZUZCWQucs1zBWUg0GTvLZQdgCr1WT1tr/OylZ488YltOMRH4y23Rv96EEnism16kqIhFA3Hv5NfIcdeSssyPrtCwHzkYCfGeLQiXwerx9xLsinIAZUNDJtUSS4sNjVrGtSAuNKOU2U2EK8KC9P1DHALaZUDXqhuO1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82E6DDA7;
	Mon, 30 Sep 2024 19:47:33 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9A91A3F58B;
	Mon, 30 Sep 2024 19:47:00 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 45/47] KVM: arm64: nv: Add FEAT_FGT2 registers access from virtual EL2
Date: Tue,  1 Oct 2024 08:13:54 +0530
Message-Id: <20241001024356.1096072-46-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001024356.1096072-1-anshuman.khandual@arm.com>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
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
index 329619c6fa96..09291e1e42c9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -532,6 +532,11 @@ enum vcpu_sysreg {
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
index 06f8ec0906a6..8eab837196d0 100644
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
@@ -53,6 +55,9 @@
 #define VNCR_PIRE0_EL2		0x298
 #define VNCR_PIR_EL1		0x2A0
 #define VNCR_POR_EL1		0x2A8
+#define VNCR_HFGRTR2_EL2	0x2C0
+#define VNCR_HFGWTR2_EL2	0x2C8
+#define VNCR_HFGITR2_EL2	0x310
 #define VNCR_ICH_LR0_EL2        0x400
 #define VNCR_ICH_LR1_EL2        0x408
 #define VNCR_ICH_LR2_EL2        0x410
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dad88e31f953..778731491f79 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2794,9 +2794,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

