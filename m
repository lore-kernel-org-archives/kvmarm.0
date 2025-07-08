Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AF52E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995632; cv=none; b=savfjbxywjkk9jjZ2H/Lhz1C3Pe1ay90TpahK948+VUWPXwkz6yM6nwlBg6INQ12CIL8/pnJnfEEf5HVygW1lO/IJElI/3AkXdW5l22JvU8wXTt5DDBQqAsm+1gPm4EVZLRNOnoE3eHqJzyjngjInel+6E1vRHYT08h4DaKqgM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995632; c=relaxed/simple;
	bh=cDvvZ4OW9DcGDiFsZeq4FzPe2HuTq5OVeL2N97LuDSM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a5vZous+fmQKN7FGGTRNHR6jJM8+RtuCYgiW104aZGPN6SK4YD2eMy71HeUNO2OJVDWu0+mNyJxZ4QWO7sNyrSYCB2bBRGjA1UEnNwj2Y9hu8JX47tWssBhdKoTC3WMLBe4VM7z3Dcrb7txmC+gnjYkmXiCvW3fEWnUXm/Yt4Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fptS+SZd; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fptS+SZd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKpEQmrGaaKUkeuntsyyeHHtQt46MmT3V6BoxssvgEY=;
	b=fptS+SZdh6drd5dLOWboA6nKUVZA5scEq+5GkD+DKiCf7xzXhThFFn6ZG874um4IuK6mlN
	NRNPyun534EdvPMSqCLO/o1v5bxlZYQmnWoSZG0GlZyR4SDyT49RIuFmqbOPYpvwomU6hE
	DHICZljoz6G1bKRKeB3B9QQPn03AR0M=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 10/27] KVM: arm64: nv: Describe trap behavior of SCTLR2_EL1
Date: Tue,  8 Jul 2025 10:25:15 -0700
Message-Id: <20250708172532.1699409-11-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the complete trap description for SCTLR2_EL1, including FGT and the
inverted HCRX bit.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b01a482b41be..ff53109caa05 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -88,6 +88,7 @@ enum cgt_group_id {
 
 	CGT_HCRX_EnFPM,
 	CGT_HCRX_TCR2En,
+	CGT_HCRX_SCTLR2En,
 
 	CGT_CNTHCTL_EL1TVT,
 	CGT_CNTHCTL_EL1TVCT,
@@ -108,6 +109,7 @@ enum cgt_group_id {
 	CGT_HCR_TTLB_TTLBOS,
 	CGT_HCR_TVM_TRVM,
 	CGT_HCR_TVM_TRVM_HCRX_TCR2En,
+	CGT_HCR_TVM_TRVM_HCRX_SCTLR2En,
 	CGT_HCR_TPU_TICAB,
 	CGT_HCR_TPU_TOCU,
 	CGT_HCR_NV1_nNV2_ENSCXT,
@@ -398,6 +400,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= HCRX_EL2_TCR2En,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
+	[CGT_HCRX_SCTLR2En] = {
+		.index		= HCRX_EL2,
+		.value		= 0,
+		.mask		= HCRX_EL2_SCTLR2En,
+		.behaviour	= BEHAVE_FORWARD_RW,
+	},
 	[CGT_CNTHCTL_EL1TVT] = {
 		.index		= CNTHCTL_EL2,
 		.value		= CNTHCTL_EL1TVT,
@@ -449,6 +457,8 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 	MCB(CGT_HCR_TVM_TRVM,		CGT_HCR_TVM, CGT_HCR_TRVM),
 	MCB(CGT_HCR_TVM_TRVM_HCRX_TCR2En,
 					CGT_HCR_TVM, CGT_HCR_TRVM, CGT_HCRX_TCR2En),
+	MCB(CGT_HCR_TVM_TRVM_HCRX_SCTLR2En,
+					CGT_HCR_TVM, CGT_HCR_TRVM, CGT_HCRX_SCTLR2En),
 	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
 	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
 	MCB(CGT_HCR_NV1_nNV2_ENSCXT,	CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
@@ -782,6 +792,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(OP_TLBI_RVALE1OSNXS,	CGT_HCR_TTLB_TTLBOS),
 	SR_TRAP(OP_TLBI_RVAALE1OSNXS,	CGT_HCR_TTLB_TTLBOS),
 	SR_TRAP(SYS_SCTLR_EL1,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_SCTLR2_EL1,		CGT_HCR_TVM_TRVM_HCRX_SCTLR2En),
 	SR_TRAP(SYS_TTBR0_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_TTBR1_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_TCR_EL1,		CGT_HCR_TVM_TRVM),
@@ -1354,6 +1365,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_SCXTNUM_EL0,		HFGRTR, SCXTNUM_EL0, 1),
 	SR_FGT(SYS_SCXTNUM_EL1, 	HFGRTR, SCXTNUM_EL1, 1),
 	SR_FGT(SYS_SCTLR_EL1, 		HFGRTR, SCTLR_EL1, 1),
+	SR_FGT(SYS_SCTLR2_EL1,		HFGRTR, SCTLR_EL1, 1),
 	SR_FGT(SYS_REVIDR_EL1, 		HFGRTR, REVIDR_EL1, 1),
 	SR_FGT(SYS_PAR_EL1, 		HFGRTR, PAR_EL1, 1),
 	SR_FGT(SYS_MPIDR_EL1, 		HFGRTR, MPIDR_EL1, 1),
-- 
2.39.5

