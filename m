Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61917212B2B
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115015; cv=none; b=IseLG7t3PgoXtlFgdS0vdReNth6SgFHiz9urvHP4WMKEyIThuohZg046jk6idabuRKyokRpQUs78BTiSPxuw/lDv5t7YszGALHFj+XXO7aq/+9d/nOZtq78bWG0IutvnnBSB9zhSHqDUgs2zYevGHUiXu8PoomvkrwYSE1khhNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115015; c=relaxed/simple;
	bh=hU2jh4uRf6ZYjrOT2heVpnm6vlvJX79AaTviLNbtIqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JWILpwdT/GSqoCaqGlSuGfQPR3DbBrPpszDBKWbW3wUq8iDMMxzCyO2rcghh5xCkkAUsxfOmX2BlDNqNtK5qMgbq2FA2Vj81q6x5R1pVdgqr3Dsra9wKZEB/IiFBywsOwSCODIOwLmptUoBPRBzVmdcuFFV7QSj9/iFp3KF5Fzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qfJrm9gZ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qfJrm9gZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LAdOlhGB2G0D94MCEp0PL/mBMLo7W5DWPi+URCDRt5U=;
	b=qfJrm9gZ3jK3I1R4Tva09m+JKriXapTXA9S2AhbjvaorTJI/KcSvpqYnWyBlF/xvapIJOX
	Mfclhm5rgJ1dWeyL+tA22LLOvQyH+XyRmalSHROk/mRvIHNm57Tw9oGRgLNOUoRSulTDDL
	fuB2+ENbrjjPSzp1d7VNjYUY8SUpN6Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 07/27] KVM: arm64: nv: Add FEAT_RAS vSError sys regs to table
Date: Mon, 16 Jun 2025 16:02:48 -0700
Message-Id: <20250616230308.1192565-8-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Prepare to implement RAS for NV by adding the missing EL2 sysregs for
the vSError context.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h     | 4 ++++
 arch/arm64/include/asm/vncr_mapping.h | 1 +
 arch/arm64/kvm/sys_regs.c             | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dd7405d676b3..3838af60fcd4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -565,6 +565,10 @@ enum vcpu_sysreg {
 
 	VNCR(POR_EL1),	/* Permission Overlay Register 1 (EL1) */
 
+	/* FEAT_RAS registers */
+	VNCR(VDISR_EL2),
+	VNCR(VSESR_EL2),
+
 	VNCR(HFGRTR_EL2),
 	VNCR(HFGWTR_EL2),
 	VNCR(HFGITR_EL2),
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 6f556e993644..f4ec53166d8e 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -84,6 +84,7 @@
 #define VNCR_ICH_HCR_EL2        0x4C0
 #define VNCR_ICH_VMCR_EL2       0x4C8
 #define VNCR_VDISR_EL2          0x500
+#define VNCR_VSESR_EL2		0x508
 #define VNCR_PMBLIMITR_EL1      0x800
 #define VNCR_PMBPTR_EL1         0x810
 #define VNCR_PMBSR_EL1          0x820
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..b6d75d473ab8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3344,6 +3344,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
 	EL2_REG_REDIR(ESR_EL2, reset_val, 0),
+	EL2_REG_VNCR(VSESR_EL2, reset_unknown, 0),
 	{ SYS_DESC(SYS_FPEXC32_EL2), undef_access, reset_val, FPEXC32_EL2, 0x700 },
 
 	EL2_REG_REDIR(FAR_EL2, reset_val, 0),
@@ -3372,6 +3373,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), undef_access },
+	EL2_REG_VNCR(VDISR_EL2, reset_unknown, 0),
 
 	EL2_REG_VNCR(ICH_AP0R0_EL2, reset_val, 0),
 	EL2_REG_VNCR(ICH_AP0R1_EL2, reset_val, 0),
-- 
2.39.5

