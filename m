Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2F212FA7
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743547371; cv=none; b=KaQo4xHe/PPZPi9Q4Nr3wlVQV5jNuYK9oIHoJwJ8zDqtlfxWHGpYDqBPOQK0vegyybaTMmmbz1Y5OSs0u+f5KKwWuLJsS3uk6mwYbjPbwYTCqja7eYR2JkfJ++idzWNlzDj+4qhs6bBUvT3SN1/hSzKzje+PeqjA93RGdwMB7Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743547371; c=relaxed/simple;
	bh=8ehPsGz/98r4MEPPh6uUCkJSYumAaxNkAiF9Im2lR9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XkCOyxx+quiEFDLXG4WiMKhkAVrn7eFPdgYxbLFh1DIoiD4C4DjY4NUYoV4vcLmL5hKJ49psQzo5nSYGKvRHm/znr82pJ05kNi2D4yTvqltSQR5a+ClD/ZQqXNtqO3od85Sw3qh7vY3VmGQvD3lyJa9vpgpsJbWMPCqn0mQwMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lq7vSi1p; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lq7vSi1p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743547365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jai2bWmDberXlCk5zPagDV7rWyhqs4PByckwUJfq6sY=;
	b=lq7vSi1pctUCMrBqtlyQ/BRBforE4h5AHA4Qt172Aynd6MSx6DQugJOw98n0QPxETvOzoS
	rrPoozOYD+WHVm2P1ln/tH3snzcBjlpmvsCVB1HLRG9pSXHxdLlNtNTG3b34LTAC4qRpvC
	J9h08Z1LTghlNGAxzN+yR0GGVgkc1ls=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
Date: Tue,  1 Apr 2025 15:42:32 -0700
Message-Id: <20250401224234.2906739-2-oliver.upton@linux.dev>
In-Reply-To: <20250401224234.2906739-1-oliver.upton@linux.dev>
References: <20250401224234.2906739-1-oliver.upton@linux.dev>
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
 arch/arm64/include/asm/esr.h           |  1 +
 arch/arm64/kvm/hyp/include/hyp/fault.h | 46 ++++++++++++++++----------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d1b1a33f9a8b..7b096ed87360 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -121,6 +121,7 @@
 #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
 #define ESR_ELx_FSC_SECC	(0x18)
 #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
+#define ESR_ELx_FSC_ADDRESS	(0x00)
 
 /* Status codes for individual page table levels */
 #define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))
diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 17df94570f03..84d165e17bd0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -44,31 +44,41 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
+/*
+ * Checks for the conditions when HPFAR_EL2 is written, per DDI0487L.a D24.2.70.
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
+	return (esr & ESR_ELx_FSC) == ESR_ELx_FSC_ADDRESS;
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

