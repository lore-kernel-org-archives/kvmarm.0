Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003CB4A0128;
	Tue,  1 Sep 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288633; cv=none; b=OUr6mMYjJxafOzMyovQPZVNIsVAAV/VZwHOX+t26B+95MDNuXT9mgEf2tsl7g2Lx3tYfDv6a3B/sc63XCOEzy3apiBSUn2zGuB0DAdvO/Q9jyj1u2SbV/unirsM8tIGe+yJEw7LMLAggvyamJyqg3mb7cmF8oDbJojbX9qmefOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288633; c=relaxed/simple;
	bh=Dq9vtXBLyKse2VOz1gRaM4Vx4EAQEeeDvaC3DkckGkY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fDRVGUVwZOZmCGrA/ko5JGDzyCv/tMy6F25AF2qaZhfmBV3c3qX3ESgQAz1K76xF27H+OEJiHc1tkF8p/NbAJqbnOoSY0o1VEx6qURtSArFdBZxrhWvJKeSrA0UiMqj8haBztAnuxVA/9z66uBSKiJ83CzKThByzBWEFf/KbygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCbwFOaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCbwFOaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3551F00A3A;
	Tue,  1 Sep 2026 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288631;
	bh=9NqxJmsuWMoYf8OnPUMFKRo/N07zFQiurv7rzMS8vA4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fCbwFOaaZ5TaCJ07HTDuI14a6Wt3VQYwUsfGi47Fo+sJl9mRhCXtkn1Z2BidsCeK4
	 meOnCYKLblK8Hv9TU++1EJ7y4i7s5e5Wl7mVp1Um5GxEyFYqxDFsh+kLTmX2IR1Pm2
	 Pyx0I++DPYt6+iQ9fj3eqPy3LK+oayLgBL+dKurEztoxSIEmWEKEBkBmH8M+40O+uZ
	 HapYelCAVy47RjFuQgZEPrAkiXnd3sNXZ91RxBTbePW/R0yMZPh964fUf3qItNwOOY
	 SEeFMEpsRFAV7faojBP+CmJpuh/IrBclD5qkdByXw2sSqAL/9XjWAJ8Rx5xSpH9FeR
	 Bw6XlBCbmrKPA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 19:50:01 +0100
Subject: [PATCH v7 1/3] KVM: selftests: arm64: Report set_id_reg reads of
 test registers as tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-kvm-arm64-set-id-regs-aarch64-v7-1-7b065b0bda9a@kernel.org>
References: <20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org>
In-Reply-To: <20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5645; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Dq9vtXBLyKse2VOz1gRaM4Vx4EAQEeeDvaC3DkckGkY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqlx5tkzX/Zo+kIfUCwJIGyWB33jelVzHSY682L
 lggyRJ3ZSGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapcebQAKCRAk1otyXVSH
 0DG3B/92L7FcF0nl0NbWHxSs9rjm0OwRi37m09qTBnIXZuoolRwAJv8mslwMjJ1eWe8WtUEaqg9
 33Scq/O2Yo6vPSsptv2Mq9mdwji5c9Y+GQ847NP3LPih9g/ahYzMBX1pPyWpLlXkOfL8wdotSRJ
 w6QI7tU/dUY4+neREkQs2IPk4xgnhN63rD4LtjMkUlJjJXlkK0esI9GVX1iWHB7nnHTJoowVjw4
 4taVtfumug46i0kTA0P7tZqQAXmpOTNaKvcqrWauIXLte/XpUxUEx35AumifV/mD0ZbmgsoFRHq
 X+HP2R2LyHhjiYbguAvzAWZdmjV7KQScJnnklcquwEH5rjiN
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

