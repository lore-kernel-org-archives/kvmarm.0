Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D71F03C7
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 20:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625064; cv=none; b=CbylxKb/1VroAAdNJm7lXLt1k0xAJZj+0EaEfCbLZ1Y+vrHh44/zdyuUHIt8zuJt2jK8MYot9uqKhOREbmIbXAgLZ2o1uKcU2mTiMozoIvO/RPxC4cg1RF4OC15h5h56RgkPooiJ5l2yrcNlk12FTf9HhzFB4w8eAo6qDlz9dMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625064; c=relaxed/simple;
	bh=Hrbs5oiNfF1XAKaiQ1EzR20XW9F/k56Soff2WBWjRWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SGlCVNLB5+onCLvgMSnRxUDCCjxyddaGV3R8jSvUxv3RJEiCOEc0xw9Z9DyQ4wn5d5gKdysrk3/slwzl6kDKwYujFEX56dd4kWITfZPLOLTs6Y5xk0wTwdGrLD0PTIwdgi36blM6xiuivivTP5HnvMe66w6lL0VcIYOHUpsEbPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fBBowCR0; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fBBowCR0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743625060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5VFjv9axYd3nLzFHQh0frmDwP7bptAFpdVNxJ3yCdXY=;
	b=fBBowCR0385y6ZMECjbvs/wm+qpnW7cnUUwrhLU73dc9HyArGIxiy1ViKb9s3jrZOxFkih
	I528tevx0dRc/tdlK89ZwytEMZb4DCe/X3XJPVfl2hpcKNKMdvYw1WPtpV0lQw+NxVoQX3
	419NkqROrBlbLG/Wsz4o3ERgTo19hFE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/3] KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
Date: Wed,  2 Apr 2025 13:17:23 -0700
Message-Id: <20250402201725.2963645-2-oliver.upton@linux.dev>
In-Reply-To: <20250402201725.2963645-1-oliver.upton@linux.dev>
References: <20250402201725.2963645-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM's logic for deciding when HPFAR_EL2 is UNKNOWN doesn't align with
the architecture. Most notably, KVM assumes HPFAR_EL2 contains the
faulting IPA even in the case of an SEA.

Align the logic with the architecture rather than attempting to
paraphrase it. Additionally, take the opportunity to improve the
language around ARM erratum #834220 such that it actually describes the
bug.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/esr.h           | 22 ++++++++++--
 arch/arm64/kvm/hyp/include/hyp/fault.h | 46 ++++++++++++++++----------
 2 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d1b1a33f9a8b..92fb26e90840 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -121,6 +121,15 @@
 #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
 #define ESR_ELx_FSC_SECC	(0x18)
 #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
+#define ESR_ELx_FSC_ADDRSZ	(0x00)
+
+/*
+ * Annoyingly, the negative levels for Address size faults aren't laid out
+ * contiguously (or in the desired order)
+ */
+#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x25 : 0x2C)
+#define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
+						   (ESR_ELx_FSC_ADDRSZ + (n)))
 
 /* Status codes for individual page table levels */
 #define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))
@@ -161,8 +170,6 @@
 #define ESR_ELx_Xs_MASK		(GENMASK_ULL(4, 0))
 
 /* ISS field definitions for exceptions taken in to Hyp */
-#define ESR_ELx_FSC_ADDRSZ	(0x00)
-#define ESR_ELx_FSC_ADDRSZ_L(n)	(ESR_ELx_FSC_ADDRSZ + (n))
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
@@ -464,6 +471,17 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_ACCESS_L(0));
 }
 
+static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
+{
+	esr &= ESR_ELx_FSC;
+
+	return (esr == ESR_ELx_FSC_ADDRSZ_L(3))	||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(2))	||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(1)) ||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(0))	||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(-1));
+}
+
 /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
 static inline bool esr_iss_is_eretax(unsigned long esr)
 {
diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 17df94570f03..59409685c14f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -44,31 +44,41 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
+/*
+ * Checks for the conditions when HPFAR_EL2 is written, per ARM ARM R_FKLWR.
+ */
+static inline bool __hpfar_valid(u64 esr)
+{
+	/*
+	 * CPUs affected by ARM erratum #834220 may incorrectly report a
+	 * stage-2 translation fault when a stage-1 permission fault occurs.
+	 *
+	 * Re-walk the page tables to determine if a stage-1 fault actually
+	 * occurred.
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_834220) &&
+	    esr_fsc_is_translation_fault(esr))
+		return false;
+
+	if (esr_fsc_is_translation_fault(esr) || esr_fsc_is_access_flag_fault(esr))
+		return true;
+
+	if ((esr & ESR_ELx_S1PTW) && esr_fsc_is_permission_fault(esr))
+		return true;
+
+	return esr_fsc_is_addr_sz_fault(esr);
+}
+
 static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 {
 	u64 hpfar, far;
 
 	far = read_sysreg_el2(SYS_FAR);
 
-	/*
-	 * The HPFAR can be invalid if the stage 2 fault did not
-	 * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
-	 * bit is clear) and one of the two following cases are true:
-	 *   1. The fault was due to a permission fault
-	 *   2. The processor carries errata 834220
-	 *
-	 * Therefore, for all non S1PTW faults where we either have a
-	 * permission fault or the errata workaround is enabled, we
-	 * resolve the IPA using the AT instruction.
-	 */
-	if (!(esr & ESR_ELx_S1PTW) &&
-	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
-	     esr_fsc_is_permission_fault(esr))) {
-		if (!__translate_far_to_hpfar(far, &hpfar))
-			return false;
-	} else {
+	if (__hpfar_valid(esr))
 		hpfar = read_sysreg(hpfar_el2);
-	}
+	else if (!__translate_far_to_hpfar(far, &hpfar))
+		return false;
 
 	fault->far_el2 = far;
 	fault->hpfar_el2 = hpfar;
-- 
2.39.5

