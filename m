Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B712E5B08
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995731; cv=none; b=KGQwkzKNB3YRmfO+laN8HZ8kiHwzsa83vt4KAG82v4Vhu62A6P9dPfEO1ahS5YlTD5FX41sGgNKa0vFrA02kwQFYylh/z3ZIUrJgV4A4aqRPGxw7hZGb1Xc8L4LYqDgT+RlbbgAjHGwxsbfZZ/xbL9cqMtf8pWbqB1zvOX1hBf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995731; c=relaxed/simple;
	bh=UZRpZ0L93Z+Z7PTg4DMbqzA+PE/qvVh94QeXN+4ZiX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pLNbcqqvnNKjtsT4w3TDuHCc/VVpeWFp2sJHK/Zx/PTuqYPTqvDpLeyDDt+KUXg7XfMIvLVbviVimqKSRljntTgtIm9S70Y6F0tlTXFwKlW/2GfrCRhW1NZ3s8BnpbkeUCnXk6lnVlJP97J+DyNXJPqXLByX2diU1rFzEGM8xVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSZTyvjP; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSZTyvjP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOObrjkI0xmQz2iU3X1NitX+tYyY/TfTTj7iMbXo6/I=;
	b=cSZTyvjPr2EMxZkBkK4z7g1Slsg7IQRUzJCQaW93n14lqvmkr4NXSk8nSdByTz6plXXOfd
	G+zIlLxdPzE11Kx+uJ1lmPG3k1tPmfDesYgrUp1rt0Rxvpek5kQx4asqbcOUIh8o9rUtuc
	oTb7J7uNnMdxEyujyxQUxJ23sIZnV18=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 27/27] KVM: arm64: selftests: Catch up set_id_regs with the kernel
Date: Tue,  8 Jul 2025 10:25:32 -0700
Message-Id: <20250708172532.1699409-28-oliver.upton@linux.dev>
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

Add test coverage for ID_AA64MMFR3_EL1 and the recently added
FEAT_DoubleFault2.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 8f422bfdfcb9..d3bf9204409c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -139,6 +139,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 };
 
 static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),
@@ -187,6 +188,14 @@ static const struct reg_ftr_bits ftr_id_aa64mmfr2_el1[] = {
 	REG_FTR_END,
 };
 
+static const struct reg_ftr_bits ftr_id_aa64mmfr3_el1[] = {
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR3_EL1, S1POE, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR3_EL1, S1PIE, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR3_EL1, SCTLRX, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR3_EL1, TCRX, 0),
+	REG_FTR_END,
+};
+
 static const struct reg_ftr_bits ftr_id_aa64zfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ZFR0_EL1, F64MM, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ZFR0_EL1, F32MM, 0),
@@ -217,6 +226,7 @@ static struct test_feature_reg test_regs[] = {
 	TEST_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0_el1),
 	TEST_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1_el1),
 	TEST_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2_el1),
+	TEST_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3_el1),
 	TEST_REG(SYS_ID_AA64ZFR0_EL1, ftr_id_aa64zfr0_el1),
 };
 
@@ -774,8 +784,8 @@ int main(void)
 		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64pfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr2_el1) +
-		   ARRAY_SIZE(ftr_id_aa64zfr0_el1) - ARRAY_SIZE(test_regs) + 3 +
-		   MPAM_IDREG_TEST + MTE_IDREG_TEST;
+		   ARRAY_SIZE(ftr_id_aa64mmfr3_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
+		   ARRAY_SIZE(test_regs) + 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
 
 	ksft_set_plan(test_cnt);
 
-- 
2.39.5

