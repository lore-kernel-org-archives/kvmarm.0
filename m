Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9846A3803DC;
	Sun, 19 Jul 2026 23:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502737; cv=none; b=iHgOhOVYpT1GuE8ERInDNbRgZpI7I0hKKdoRDpr63lVgUZnyTQzlDKO160n4wusg1vwLNO0BOpwBlRXcitsGXWCNE2OXv9DwzIIvsnGSpMtVddR5yxksHhAEcwPCdKTmFJiEDD9hDj1xPvuoA2pvtsMOXwklsWyp7c6CLxGKPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502737; c=relaxed/simple;
	bh=q7gRFDO7XUzOJdjKk7dinZEmMYgpMJThzBI3Uxs/+tg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nPquszOeJ7EOXImaCFtxlqKl6bbSFUsLydY3Sxr2V4LA12P82kRkMCtjmVVcLT5lSTDuTnOgSv1TnAZ66bXyDXSDRUevXAggDB0+DCP5W/7NoiMNUvofA85spDSAiHLuPV3CNayXFdgpnA5iy5K6dyIAlospGoaQtxtKpTo7C4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGc7RTRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGc7RTRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4993D1F000E9;
	Sun, 19 Jul 2026 23:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502736;
	bh=XECF9ZZpHN11rgO/zTL5kqZIcvgfBhcTmPU6H51lc1c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TGc7RTRmFm6L7ZZkyZWskOec514SOobW5z7Se9S1hJWQjXZzHq9K+WCBoWz1SHIGO
	 c60uphJG67brwIYAOF77JF2/zSMcMzqARbTw9Vy40BYU+7NBWUXBjcvUPUmylcTz2G
	 YI5B4zwzf/03dZvRIRl0+2c5Ajvvch1kpJXyggXA4vAbCpnqup+CSuShLz0GZezcpD
	 HuGwqnijDJgR9WElWjL95BWbFoz6NRBo/Qf+vMfxnnjSx15oT6E+6nOUsUktE4FzaB
	 SUi2aP/JOFcP3fresAcVLj+dI7W1NHgf0ORx4zMVfYC4QTc7EBn1Px6mXqr4/UEi28
	 M1KWXxC6byH4Q==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:59 +0100
Subject: [PATCH v13 32/32] KVM: arm64: selftests: Add SME to set_id_regs
 test
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-32-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3538; i=broonie@kernel.org;
 h=from:subject:message-id; bh=q7gRFDO7XUzOJdjKk7dinZEmMYgpMJThzBI3Uxs/+tg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVlAU1/Dwy5C+mmI5SgTi15+8XjLgHbk8SqV6
 ShOKnvTPJqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZQAAKCRAk1otyXVSH
 0JuZB/4kseTKPVKXThQDY2bEISdVlTmhZqswc0T/a6N3EXUE7O+LA/5T8xG/qaDINMEH/2JfdAV
 7N/vRWuM7qp5aTXe1qUswh7YC8OFixPgivU8A70LQ5sOv/OtPN9b603WoW0aM0v3sG5Rw5VQquu
 7UCWgSftrnasfBvqCDFnOVe1Z+BJXwPH+gaWD1E4hB3jk1a/Fj/KcCtqRrcjIJlF/iLG971uLk8
 GF5PadJUrDWm8XdmMP6w73Px2LLPQ1Dm244nq4P8GTEyNJe8He0k8uXSG3Y96EbtdsbB5PmLYnx
 a8ckTP2dqHjpyQ09xqATpHMkOmsCyPb3dQ6wtSHy7wGJS8gB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Add coverage of the SME ID registers to set_id_regs, ID_AA64PFR1_EL1.SME
becomes writable and we add ID_AA64SMFR0_EL1 and it's subfields.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 30 +++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index da9349bf31ab..26db507f6e73 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -155,6 +155,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SME, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),
 	REG_FTR_END,
@@ -212,6 +213,33 @@ static const struct reg_ftr_bits ftr_id_aa64mmfr3_el1[] = {
 	REG_FTR_END,
 };
 
+static const struct reg_ftr_bits ftr_id_aa64smfr0_el1[] = {
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, FA64, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, LUTv2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SMEver, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, I16I64, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F64F64, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, I16I32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, B16B16, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F16F16, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F8F16, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F8F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, I8I32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F16F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, B16F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, BI32I32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F32F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SF8FMA, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SF8DP4, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SF8DP2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SBitPerm, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, AES, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SFEXPA, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, STMOP, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SMOP4, 0),
+	REG_FTR_END,
+};
+
 static const struct reg_ftr_bits ftr_id_aa64zfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ZFR0_EL1, F64MM, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ZFR0_EL1, F32MM, 0),
@@ -244,6 +272,7 @@ static struct test_feature_reg test_regs[] = {
 	TEST_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1_el1),
 	TEST_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2_el1),
 	TEST_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3_el1),
+	TEST_REG(SYS_ID_AA64SMFR0_EL1, ftr_id_aa64smfr0_el1),
 	TEST_REG(SYS_ID_AA64ZFR0_EL1, ftr_id_aa64zfr0_el1),
 };
 
@@ -263,6 +292,7 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
+	GUEST_REG_SYNC(SYS_ID_AA64SMFR0_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
 	GUEST_REG_SYNC(SYS_MPIDR_EL1);
 	GUEST_REG_SYNC(SYS_CLIDR_EL1);

-- 
2.47.3

