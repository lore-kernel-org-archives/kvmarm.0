Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FD41FA4
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718177; cv=none; b=Hrb0InW8irI1Mizn/lAQ6BzsdPJkUpxu2Qym+ZjQpCUfxOqv0BExCuCOUDV/tDLCwrwaBDG9RKptdbZ0fc228KihEdhYsqeO3rWrHVV16C+/9eeRrUf3/xBhPc/ZbX4QMAL5oRGcgkT8TqJYHGl3FF10k/u1Bx234mCyLyJnUfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718177; c=relaxed/simple;
	bh=7LNuBlM2t7vMi3TyBXk+i/hLDs8RxwS2dAL2S8WzP7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRimvZ2oW97ThNPyyUR/nylxG23ddOsnRCTEEv4WRkjFL0I9giUD/CwZ7s12AhhywPwA6g09tLr462FWd5LZ5+eWQtnHsW3QwoUkuejspBnLTWtbeuC2zYSqleOKwcAH4+4XomWlYDuGb4Bc0bl5Xf3psIAzpcBw1ZbmTIaURco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CIprxckO; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CIprxckO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=edN516nQqpAhu4sFwCy/mUHJl5Ct678hewpupZXZv6A=;
	b=CIprxckOLnPvFNTntmoZiU7lASAWW3t0Cm91Mqq0ZTqpZ3PfkpC/5YmNRrj4j5b+xSKdBj
	0NqC4yk2TUMIlKaXob9NEUng93UnL4uSidAbiDg0JjXwHxYSJ8yZknVbySmeyaRlwj5jD6
	DLYC1VCvLXGnXuJVUbSI52ZBFUiHqLw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 03/12] KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
Date: Tue, 27 Aug 2024 00:22:26 +0000
Message-ID: <20240827002235.1753237-4-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/emulate-nested.c | 83 +++++++++++++++++----------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..26d32f308dd3 100644
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
@@ -130,7 +131,7 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= HCR_EL2,
 		.value 		= HCR_TID2,
 		.mask		= HCR_TID2,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TID3] = {
 		.index		= HCR_EL2,
@@ -154,37 +155,37 @@ static const struct trap_bits coarse_trap_bits[] = {
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
@@ -196,7 +197,7 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= HCR_EL2,
 		.value		= HCR_TDZ,
 		.mask		= HCR_TDZ,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 	[CGT_HCR_TRVM] = {
 		.index		= HCR_EL2,
@@ -208,175 +209,175 @@ static const struct trap_bits coarse_trap_bits[] = {
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
 	[CGT_HCRX_TCR2En] = {
 		.index		= HCRX_EL2,
 		.value 		= 0,
 		.mask		= HCRX_EL2_TCR2En,
-		.behaviour	= BEHAVE_FORWARD_ANY,
+		.behaviour	= BEHAVE_FORWARD_RW,
 	},
 };
 
@@ -434,7 +435,7 @@ static enum trap_behaviour check_cnthctl_el1pcten(struct kvm_vcpu *vcpu)
 	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCTEN << 10))
 		return BEHAVE_HANDLE_LOCALLY;
 
-	return BEHAVE_FORWARD_ANY;
+	return BEHAVE_FORWARD_RW;
 }
 
 static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
@@ -442,7 +443,7 @@ static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
 	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCEN << 10))
 		return BEHAVE_HANDLE_LOCALLY;
 
-	return BEHAVE_FORWARD_ANY;
+	return BEHAVE_FORWARD_RW;
 }
 
 static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
@@ -453,7 +454,7 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 		val = translate_cptr_el2_to_cpacr_el1(val);
 
 	if (val & CPACR_ELx_TTA)
-		return BEHAVE_FORWARD_ANY;
+		return BEHAVE_FORWARD_RW;
 
 	return BEHAVE_HANDLE_LOCALLY;
 }
-- 
2.46.0.295.g3b9ea8a38a-goog

