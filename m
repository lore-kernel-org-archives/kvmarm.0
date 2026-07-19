Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C92FDC28;
	Sun, 19 Jul 2026 19:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784489267; cv=none; b=hRJ9B3GYPiFjFO+quh/CAj1PgI13wnG4v6SUtA0Bj6AtVfp5e+sxfur6lnQ6Xe8GIOd42YB3vrr4TEowMApPIZdfJRTCC1YP1g2u8+bBArPM+HEQ9dnTmSyM3n8xpehtfF6qNkXXJjseYgPKBsEXzkOzqlwKM9KOBOZHkOgPXC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784489267; c=relaxed/simple;
	bh=Dq9vtXBLyKse2VOz1gRaM4Vx4EAQEeeDvaC3DkckGkY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HwSV7nXxU2MD0mxO+dXMZDHovXXjXoju/2q5WLycX9QWJ137vJNWJaR6gpyXiEB3jJt5sXB5/NEE8PHHycQwwFgf6GOK75QQzEmDfLj/mi8ekiYZ0OafmMw4tGHsnRxSiW4ytKyzetaww56IHHb2/JDugi1fgb8cZc+DnPjShrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOKJeRIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOKJeRIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE191F00A3D;
	Sun, 19 Jul 2026 19:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784489265;
	bh=9NqxJmsuWMoYf8OnPUMFKRo/N07zFQiurv7rzMS8vA4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VOKJeRIMDcGKKyrglITtWuTUj9JMXvgDjSWgm8Lsp5N3udkFIUu99oqJHsyU6IZWD
	 oFmJa4IbZD9PNL3S6JW4KXQ+yiHOLjxESqqimRgk2xUSaxa9MZ1BQ65RCIniEpr32r
	 zoh610D0GU3LCBq9Sf99rwmPZY/ccl0pMMXZS/83W/RE5AN4lbZ5X62PMIybA3TQnb
	 6L3/SEMI7jFqU2D4K2Ph6qRtVS8dYHi6hvZzkIkE9ePpayoBdstk5BqMiuo/MxCNCP
	 bH+i1izSOol3JArkGc1jIGZsucuC7dZztSbQjhO04Xm9XcooRSZanZXHNroRjiRDgl
	 MajgB7vY9POBA==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 19 Jul 2026 20:24:40 +0100
Subject: [PATCH v6 1/3] KVM: selftests: arm64: Report set_id_reg reads of
 test registers as tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260719-kvm-arm64-set-id-regs-aarch64-v6-1-724287f5f108@kernel.org>
References: <20260719-kvm-arm64-set-id-regs-aarch64-v6-0-724287f5f108@kernel.org>
In-Reply-To: <20260719-kvm-arm64-set-id-regs-aarch64-v6-0-724287f5f108@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5645; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Dq9vtXBLyKse2VOz1gRaM4Vx4EAQEeeDvaC3DkckGkY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXSUq0364Iwd87N1A/Ysfd2v7q3JEhcNc5VLYT
 f0Unp+fwy2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal0lKgAKCRAk1otyXVSH
 0BwpB/99C3xklJ78HyEkcnoTuBhw82/E6Z/DJnXXDETpnWwOU9tPjuwZQBnlLb86Y98fbbRu2K9
 wAW6ZtBMKC1p20A91ojtyMWUI4WCwlSXdT2h2dkLx5fxlmCNnJ4/esKZXdvDEUwvtmaJY2kCE83
 YjC4o6mCnXkgHn3jNXOkdEHUouP6O06rIzShW+nZt+4zwP7fKTGCxZSWsgbk8MGZYMYvFjhR+4V
 zy8UympHmht/uQY0d20R4GtrzNFBrjHNAskWMyW2Io2rZKqW1nXFJ6zffhBWl5+d84yZlOrhR1O
 kNTdpT7yYV3TQb6Trz5lMrwXEfnLFafaWpgJVZUWqgMom+cg
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently when we run guest code to validate that the values we wrote to
the registers are seen by the guest we assert that these values match using
a KVM selftests level assert, resulting in unclear diagnostics if the test
fails. Replace this assert with reporting a kselftest test per register.

In order to support getting the names of the registers we repaint the array
of ID_ registers to store the names and open code the rest.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 82 +++++++++++++++++++------
 1 file changed, 63 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..db6414a93ad3 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -43,6 +43,7 @@ struct reg_ftr_bits {
 };
 
 struct test_feature_reg {
+	const char *name;
 	u32 reg;
 	const struct reg_ftr_bits *ftr_bits;
 };
@@ -227,30 +228,32 @@ static const struct reg_ftr_bits ftr_id_aa64zfr0_el1[] = {
 
 #define TEST_REG(id, table)			\
 	{					\
-		.reg = id,			\
+		.name = #id,			\
+		.reg = SYS_ ## id,		\
 		.ftr_bits = &((table)[0]),	\
 	}
 
 static struct test_feature_reg test_regs[] = {
-	TEST_REG(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0_el1),
-	TEST_REG(SYS_ID_DFR0_EL1, ftr_id_dfr0_el1),
-	TEST_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0_el1),
-	TEST_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1_el1),
-	TEST_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2_el1),
-	TEST_REG(SYS_ID_AA64ISAR3_EL1, ftr_id_aa64isar3_el1),
-	TEST_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0_el1),
-	TEST_REG(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1_el1),
-	TEST_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0_el1),
-	TEST_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1_el1),
-	TEST_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2_el1),
-	TEST_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3_el1),
-	TEST_REG(SYS_ID_AA64ZFR0_EL1, ftr_id_aa64zfr0_el1),
+	TEST_REG(ID_AA64DFR0_EL1, ftr_id_aa64dfr0_el1),
+	TEST_REG(ID_DFR0_EL1, ftr_id_dfr0_el1),
+	TEST_REG(ID_AA64ISAR0_EL1, ftr_id_aa64isar0_el1),
+	TEST_REG(ID_AA64ISAR1_EL1, ftr_id_aa64isar1_el1),
+	TEST_REG(ID_AA64ISAR2_EL1, ftr_id_aa64isar2_el1),
+	TEST_REG(ID_AA64ISAR3_EL1, ftr_id_aa64isar3_el1),
+	TEST_REG(ID_AA64PFR0_EL1, ftr_id_aa64pfr0_el1),
+	TEST_REG(ID_AA64PFR1_EL1, ftr_id_aa64pfr1_el1),
+	TEST_REG(ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0_el1),
+	TEST_REG(ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1_el1),
+	TEST_REG(ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2_el1),
+	TEST_REG(ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3_el1),
+	TEST_REG(ID_AA64ZFR0_EL1, ftr_id_aa64zfr0_el1),
 };
 
 #define GUEST_REG_SYNC(id) GUEST_SYNC_ARGS(0, id, read_sysreg_s(id), 0, 0);
 
 static void guest_code(void)
 {
+	/* Registers in test_regs array */
 	GUEST_REG_SYNC(SYS_ID_AA64DFR0_EL1);
 	GUEST_REG_SYNC(SYS_ID_DFR0_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ISAR0_EL1);
@@ -264,6 +267,8 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
+
+	/* Additional registers counted in NUM_EXTRA_REGS */
 	GUEST_REG_SYNC(SYS_MPIDR_EL1);
 	GUEST_REG_SYNC(SYS_CLIDR_EL1);
 	GUEST_REG_SYNC(SYS_CTR_EL0);
@@ -274,6 +279,35 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
+#define NUM_EXTRA_REGS 6
+#define GUEST_READ_TEST (ARRAY_SIZE(test_regs) + NUM_EXTRA_REGS)
+
+static const char *get_reg_name(u64 id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
+		if (test_regs[i].reg == id)
+			return test_regs[i].name;
+
+	switch (id) {
+	case SYS_MPIDR_EL1:
+		return "MPIDR_EL1";
+	case SYS_CLIDR_EL1:
+		return "CLIDR_EL1";
+	case SYS_CTR_EL0:
+		return "CTR_EL0";
+	case SYS_MIDR_EL1:
+		return "MIDR_EL1";
+	case SYS_REVIDR_EL1:
+		return "REVIDR_EL1";
+	case SYS_AIDR_EL1:
+		return "AIDR_EL1";
+	default:
+		TEST_FAIL("Unknown register");
+	}
+}
+
 /* Return a safe value to a given ftr_bits an ftr value */
 u64 get_safe_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 {
@@ -674,7 +708,8 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 	struct ucall uc;
 
 	while (!done) {
-		u64 val;
+		u64 reg_id, expected_val, guest_val;
+		bool match;
 
 		vcpu_run(vcpu);
 
@@ -683,11 +718,20 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_SYNC:
-			val = test_reg_vals[encoding_to_range_idx(uc.args[2])];
-			val = reset_mutable_bits(uc.args[2], val);
+			expected_val = test_reg_vals[encoding_to_range_idx(uc.args[2])];
+			expected_val = reset_mutable_bits(uc.args[2], expected_val);
 
 			/* Make sure the written values are seen by guest */
-			TEST_ASSERT_EQ(val, reset_mutable_bits(uc.args[2], uc.args[3]));
+			reg_id = uc.args[2];
+			guest_val = reset_mutable_bits(uc.args[2], uc.args[3]);
+
+			match = expected_val == guest_val;
+			if (!match)
+				ksft_print_msg("%lx != %lx\n",
+					       expected_val, guest_val);
+			ksft_test_result(match,
+					 "%s value seen in guest\n",
+					 get_reg_name(reg_id));
 			break;
 		case UCALL_DONE:
 			done = true;
@@ -828,7 +872,7 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;

-- 
2.47.3

