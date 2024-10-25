Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3E20F3F1
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880666; cv=none; b=ucfpYyy+VzjxGIPvZufN5cSG+DrQ6hmPD8eI6soQoqg9mLWo0tAh/y/VCj73tdD46yePXTEJgO8x7c70lrIQuYbhXTiEsx4tAQzOZvpVTzMPMxouP71cgcE6nqbFxh3KBxYkEIrcbFhV1Y+vEKuRTQkWg3/opZ/93OS7OWGdH60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880666; c=relaxed/simple;
	bh=3EsE2vEicI2ETRqCYydgDpIAjz4gjCDUHguJ3uyP0r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFKMRKWvkpQ3T8cTuNDKY44w52WuoWMafep9bWB4JdtKragS7tn2ujSt0YKr0WDPf6qaeNvNpoIEux4rOW/RmY9fpucNm6/AtGAz+MG/DTjxQ+dGvaga16tsij3xRcnPbHqKIQVRVJBuoIitDWxtL4pjdKmNkGW4SMND2LOAlxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D1ftKHiL; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D1ftKHiL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n/vLH7IaL0kII0g5Ri1DQb8sfURLSg7RQrQ+zZ1bWxc=;
	b=D1ftKHiLBpxZpeDW3gJBo1dAzJERsV8gyxofBmZSunivwtLQlRAhy7K2YacZwCqOBZrGm7
	XQOAkbDvOaaz9sEOBFnw9/dDMWqSxLBdVTKjRWA0w0k4e5YKosTP1IlAJv4YY/E9Z9DpnB
	Uqx7iHkDcrI8GLQhVJgDE0M39PUFC8Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 07/18] KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
Date: Fri, 25 Oct 2024 18:23:42 +0000
Message-ID: <20241025182354.3364124-8-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

BEHAVE_FORWARD_ANY is slightly ambiguous, especially since we're about
to cram some more information into the enum. Rephrase it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 93 +++++++++++++++++----------------
 1 file changed, 47 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index da7ab14e036d..e1a30d1bcd06 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -16,9 +16,10 @@
 
 enum trap_behaviour {
 	BEHAVE_HANDLE_LOCALLY	= 0,
+
 	BEHAVE_FORWARD_READ	= BIT(0),
 	BEHAVE_FORWARD_WRITE	= BIT(1),
-	BEHAVE_FORWARD_ANY	= BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
+	BEHAVE_FORWARD_RW	= BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
 };
 
 struct trap_bits {
@@ -138,7 +139,7 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= HCR_EL2,
 		.value 		= HCR_TID2,
 		.mask		= HCR_TID2,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TID3] = {
 		.index		= HCR_EL2,
@@ -162,37 +163,37 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TIDCP,
 		.mask		= HCR_TIDCP,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TACR] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TACR,
 		.mask		= HCR_TACR,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TSW] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TSW,
 		.mask		= HCR_TSW,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TPC] = { /* Also called TCPC when FEAT_DPB is implemented */
 		.index		= HCR_EL2,
 		.value		= HCR_TPC,
 		.mask		= HCR_TPC,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TPU] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TPU,
 		.mask		= HCR_TPU,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TTLB] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TTLB,
 		.mask		= HCR_TTLB,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TVM] = {
 		.index		= HCR_EL2,
@@ -204,7 +205,7 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TDZ,
 		.mask		= HCR_TDZ,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TRVM] = {
 		.index		= HCR_EL2,
@@ -216,205 +217,205 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TLOR,
 		.mask		= HCR_TLOR,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TERR] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TERR,
 		.mask		= HCR_TERR,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_APK] = {
 		.index		= HCR_EL2,
 		.value		= 0,
 		.mask		= HCR_APK,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_NV] = {
 		.index		= HCR_EL2,
 		.value		= HCR_NV,
 		.mask		= HCR_NV,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_NV_nNV2] = {
 		.index		= HCR_EL2,
 		.value		= HCR_NV,
 		.mask		= HCR_NV | HCR_NV2,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_NV1_nNV2] = {
 		.index		= HCR_EL2,
 		.value		= HCR_NV | HCR_NV1,
 		.mask		= HCR_NV | HCR_NV1 | HCR_NV2,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_AT] = {
 		.index		= HCR_EL2,
 		.value		= HCR_AT,
 		.mask		= HCR_AT,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_nFIEN] = {
 		.index		= HCR_EL2,
 		.value		= 0,
 		.mask		= HCR_FIEN,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TID4] = {
 		.index		= HCR_EL2,
 		.value 		= HCR_TID4,
 		.mask		= HCR_TID4,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TICAB] = {
 		.index		= HCR_EL2,
 		.value 		= HCR_TICAB,
 		.mask		= HCR_TICAB,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TOCU] = {
 		.index		= HCR_EL2,
 		.value 		= HCR_TOCU,
 		.mask		= HCR_TOCU,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_ENSCXT] = {
 		.index		= HCR_EL2,
 		.value 		= 0,
 		.mask		= HCR_ENSCXT,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TTLBIS] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TTLBIS,
 		.mask		= HCR_TTLBIS,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TTLBOS] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TTLBOS,
 		.mask		= HCR_TTLBOS,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TPMCR] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPMCR,
 		.mask		= MDCR_EL2_TPMCR,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TPM] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPM,
 		.mask		= MDCR_EL2_TPM,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TDE] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TDE,
 		.mask		= MDCR_EL2_TDE,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TDA] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TDA,
 		.mask		= MDCR_EL2_TDA,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TDOSA] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TDOSA,
 		.mask		= MDCR_EL2_TDOSA,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TDRA] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TDRA,
 		.mask		= MDCR_EL2_TDRA,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_E2PB] = {
 		.index		= MDCR_EL2,
 		.value		= 0,
 		.mask		= BIT(MDCR_EL2_E2PB_SHIFT),
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TPMS] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPMS,
 		.mask		= MDCR_EL2_TPMS,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TTRF] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TTRF,
 		.mask		= MDCR_EL2_TTRF,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_E2TB] = {
 		.index		= MDCR_EL2,
 		.value		= 0,
 		.mask		= BIT(MDCR_EL2_E2TB_SHIFT),
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_MDCR_TDCC] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TDCC,
 		.mask		= MDCR_EL2_TDCC,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_CPACR_E0POE] = {
 		.index		= CPTR_EL2,
 		.value		= CPACR_ELx_E0POE,
 		.mask		= CPACR_ELx_E0POE,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_CPTR_TAM] = {
 		.index		= CPTR_EL2,
 		.value		= CPTR_EL2_TAM,
 		.mask		= CPTR_EL2_TAM,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_CPTR_TCPAC] = {
 		.index		= CPTR_EL2,
 		.value		= CPTR_EL2_TCPAC,
 		.mask		= CPTR_EL2_TCPAC,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCRX_EnFPM] = {
 		.index		= HCRX_EL2,
 		.value 		= 0,
 		.mask		= HCRX_EL2_EnFPM,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCRX_TCR2En] = {
 		.index		= HCRX_EL2,
 		.value 		= 0,
 		.mask		= HCRX_EL2_TCR2En,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TC] = {
 		.index		= ICH_HCR_EL2,
 		.value		= ICH_HCR_TC,
 		.mask		= ICH_HCR_TC,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TALL0] = {
 		.index		= ICH_HCR_EL2,
 		.value		= ICH_HCR_TALL0,
 		.mask		= ICH_HCR_TALL0,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TALL1] = {
 		.index		= ICH_HCR_EL2,
 		.value		= ICH_HCR_TALL1,
 		.mask		= ICH_HCR_TALL1,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_ICH_HCR_TDIR] = {
 		.index		= ICH_HCR_EL2,
 		.value		= ICH_HCR_TDIR,
 		.mask		= ICH_HCR_TDIR,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 };
 
@@ -474,7 +475,7 @@ static enum trap_behaviour check_cnthctl_el1pcten(struct kvm_vcpu *vcpu)
 	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCTEN << 10))
 		return BEHAVE_HANDLE_LOCALLY;
 
-	return BEHAVE_FORWARD_ANY;
+	return BEHAVE_FORWARD_RW;
 }
 
 static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
@@ -482,7 +483,7 @@ static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
 	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCEN << 10))
 		return BEHAVE_HANDLE_LOCALLY;
 
-	return BEHAVE_FORWARD_ANY;
+	return BEHAVE_FORWARD_RW;
 }
 
 static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
@@ -493,7 +494,7 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 		val = translate_cptr_el2_to_cpacr_el1(val);
 
 	if (val & CPACR_ELx_TTA)
-		return BEHAVE_FORWARD_ANY;
+		return BEHAVE_FORWARD_RW;
 
 	return BEHAVE_HANDLE_LOCALLY;
 }
-- 
2.47.0.163.g1226f6d8fa-goog

