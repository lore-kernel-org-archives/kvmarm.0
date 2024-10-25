Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303AB20EA5B
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880661; cv=none; b=jwU8wfZLq36Ec2x2C86qXtGfF8iqO4I6vYkkZlgX9E5+1p1zI/ijqeFJHONz84hj/PTdEWtDfpF+FZjk+WtzBS7sAqAk0By5piW/RlTOfLkw7/9YK0LI+RLs9eBXia/kchPcbog+Lq3Alu+aCZ/pn1+58h47MLc44UlybT7L6ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880661; c=relaxed/simple;
	bh=VYwuvl/xw3pSsqF154eu/B3sMo2iWzU5sAmrgp0ruZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFFYLVEAhGEUlPS7A1Z7wf5LIwQFZattqkilCzpHVEfUUQDciiDPyoMqcAzDqnTQlQz/NaSD28oIC7/sjGwqKrUfFoCTlASwkGNs1LG2TeAavLJCd5CRNrD1uHzRqTEskDit0RTrwzAwaHh/AoCNWymjiTPS1g2ghB50MA6eHSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GtvuLaGn; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GtvuLaGn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fmDWvCoZ7RJkt3LBlK0ytyCUy3NDKnSPU2karwJr82A=;
	b=GtvuLaGniKuhPHatIPMHOKL3PAWVdOsfWYvQBeWxdgjB6QLj/cIPjRdEvDn0cIc9yDDf1A
	rKRZRSmxTxvnn79TqAM6oF26UVi5MI/TijmZ9zO0fgOh6elsMGWOYxrLXD85SQVtaxiKky
	oMbONfZ6u7KfXH+L7ZHZ0HiS0vdVlP4=
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
Subject: [PATCH v4 05/18] KVM: arm64: Describe RES0/RES1 bits of MDCR_EL2
Date: Fri, 25 Oct 2024 18:23:40 +0000
Message-ID: <20241025182354.3364124-6-oliver.upton@linux.dev>
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

Add support for sanitising MDCR_EL2 and describe the RES0/RES1 bits
according to the feature set exposed to the VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/nested.c           | 37 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 07c7d2b7b3a3..ca8fe74920d4 100644
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
index b20b3bfb9cae..d256a495a6ba 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1186,5 +1186,42 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
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
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, MTPMU, IMP) ||
+	    kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
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
+	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		res0 |= MDCR_EL2_EnSTEPOP;
+	set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
+
 	return 0;
 }
-- 
2.47.0.163.g1226f6d8fa-goog

