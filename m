Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A311DD54A
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323186; cv=none; b=dMSpTJjkWT9ApFN2rK1d80sXoJUBFFEu1oC+1ZJ/w/AKPYFnGN+c8eYDbjpJPpBDvZkbjXruWNEwHCYJckjISEgnxUFrYXfq6A+BM2V73BnJb9rAGEDy42SM62PaE01WkHNVSojryYj2FAUNIQaBkmo5TM3C7kSh4j95F0n6yOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323186; c=relaxed/simple;
	bh=ND+AcjnKYs+qO/y6ysXun9VuvtBsv8acl6+o41c+WT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLiVwByAqpNsDbGXVkKwDjQ+4L35/IYM7gNB3CkpcLRxdXLr49zN2tTECFSjz5J1eTGdwSyYVoJ6aY8dXV4FDSOzTBQx+x/OiZNIWNhdCYgfT8XQEGsxR0RwS7C0YSUwoSDRBo7wV/3oG2PemelhCxyOWcmBcDDBYzswHLYTEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kCOZU9Fa; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kCOZU9Fa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YFvqeYodOzIxrO1jeImiKjWceGSyRLHxsuWgmjij7ko=;
	b=kCOZU9FaDNJobK2pgXZjqx9YlT0g1a4ZfAH8sZFDWdTfAWstsToqatmah//L++qJZkWcCs
	LArp9Q1ZygzGUA7A1xJpxdqfb43rOV6zxLEKbsav2wGkz4jnDf7lSd2bD5urQSGTV8+VOi
	I9JctXN6YnBsXg+3eDz6tEIBkjfK+Fk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 04/17] KVM: arm64: Describe RES0/RES1 bits of MDCR_EL2
Date: Mon,  7 Oct 2024 17:45:46 +0000
Message-ID: <20241007174559.1830205-5-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add support for sanitising MDCR_EL2 and describe the RES0/RES1 bits
according to the feature set exposed to the VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/nested.c           | 35 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7764ca71ac6e..98ae79f7e0bc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -464,7 +464,6 @@ enum vcpu_sysreg {
 	/* EL2 registers */
 	SCTLR_EL2,	/* System Control Register (EL2) */
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
-	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
 	ZCR_EL2,	/* SVE Control Register (EL2) */
@@ -492,6 +491,7 @@ enum vcpu_sysreg {
 
 	/* Anything from this can be RES0/RES1 sanitised */
 	MARKER(__SANITISED_REG_START__),
+	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b20b3bfb9cae..33d85db860f3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1186,5 +1186,40 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= SCTLR_EL1_EPAN;
 	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
 
+	/* MDCR_EL2 */
+	res0 = MDCR_EL2_RES0;
+	res1 = MDCR_EL2_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
+		res0 |= (MDCR_EL2_HPMN | MDCR_EL2_TPMCR |
+			 MDCR_EL2_TPM | MDCR_EL2_HPME);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP))
+		res0 |= MDCR_EL2_E2PB | MDCR_EL2_TPMS;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		res0 |= MDCR_EL2_EnSPM;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P1))
+		res0 |= MDCR_EL2_HPMD;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
+		res0 |= MDCR_EL2_TTRF;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
+		res0 |= MDCR_EL2_HCCD | MDCR_EL2_HLP;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
+		res0 |= MDCR_EL2_E2TB;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
+		res0 |= MDCR_EL2_TDCC;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, MTPMU, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
+		res0 |= MDCR_EL2_MTPME;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P7))
+		res0 |= MDCR_EL2_HPMFZO;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		res0 |= MDCR_EL2_PMSSE;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
+		res0 |= MDCR_EL2_HPMFZS;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP))
+		res0 |= MDCR_EL2_PMEE;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		res0 |= MDCR_EL2_EBWE;
+	set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
+
 	return 0;
 }
-- 
2.47.0.rc0.187.ge670bccf7e-goog

