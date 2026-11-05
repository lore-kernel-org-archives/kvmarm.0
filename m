Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880903;
	b=pGu1QfVCEaBEd7mhGegFAQADDWRLejNczxNxTQ/Tp6RCWVBAQyCcWShnxWsbAdUzbUZm
	 j74jxk5OyeMZth5ZbfxV4LL1tN8te63QWFrXkP0ivrz94vfTXDLMgqnmT5O7BZlXbIi/s
	 DAzCIokkBD2r33Fbzl+leSIDaRy0uQ4adcXozL+qzK0U20KvBeAtVfmi4gIU2ZpNXDvSh
	 BmE5V1rOYoJ7EUMSf0IrykMojMHtbBeH/IsSH4ZHghjat8ZUnz0EldDx1LMPOhAy3QA3I
	 nSooSkIiZQ3wpO20tQNutoqzvi2BAwfKefYMdNMfDQdUrzithjTE/Icjlu6MQQGnwXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880903;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=gvu63V7M7umrgDXBMaR7yNvzMp7zi7dv7vshULv5LKg=;
	b=MWdwaUS4pNS+w/IgTHOwglOfGtue4ANgWuvjR7m9DV0oKasfOaugPbV76FrcMU3PKkcV
	 OLcqkKvg233zuxEIzQOgfo+CfCbzURrVFybzzz91YJtBQfBhREEuK5XJtEb6Kp6g+NodH
	 3WQCADRCUT9nbrLcyy4xiR+b+5GwVyjbXMbfHptkpVKrIIq5zWB3Ysg9GOT62WUGGOHeR
	 O+WPaqDp0Kr7uTHtur0jxt4QMxP8XdqjeRIswr5LCR3ZSFCI+J+9xv5fw9DBf2rG83gtE
	 JIao30XJdrKmdyaJhSIU+s0ikyJ+CIqLWo4lJkNBZvRyFab1EGnGC/N2EklfvuPs/ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HET13OAy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34165606D814;
	Thu,  5 Nov 2026 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HET13OAy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487341F00919;
	Thu,  5 Nov 2026 12:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880902;
	bh=gvu63V7M7umrgDXBMaR7yNvzMp7zi7dv7vshULv5LKg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HET13OAy3FUdTTo+2EzEyE3RfiUN0e+t0GHlqQm9HJ107JUgX63LRFE8riBZWBLD1
	 BAEbfqTrpAaFsD7PWYTgCvOaTpU9EfEqALcG65bmOd4B8byXRssb7hfMeq9ejKE4ci
	 s88WorSvUKWKiQSOln2j3u/Ls3cP7K0VRQU4WPpmn88AZ5p2f36b9oQnyeHL+99CCU
	 SPjskO+97HsWTagEYlgTfAGcS09ynBh5+z5xzDMEeTVLx25BseBcBAABB4criekHK5
	 R3bDitpl6ryr9XZDjaLmboiiUG3Yz9irI1WuvdIhXyVPOVoH5WOUE114uecnsBUVW9
	 UbjOeaIXx8hjA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 11:47:19 +0000
Subject: [PATCH v10 1/3] KVM: selftests: arm64: Report set_id_reg reads of
 test registers as tests
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-kvm-arm64-set-id-regs-aarch64-v10-1-d5a6aba69d19@kernel.org>
References: <20261105-kvm-arm64-set-id-regs-aarch64-v10-0-d5a6aba69d19@kernel.org>
In-Reply-To: <20261105-kvm-arm64-set-id-regs-aarch64-v10-0-d5a6aba69d19@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Sebastian Ott <sebott@redhat.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5737; i=broonie@kernel.org;
 h=from:subject:message-id; bh=hAmt2QTBd6TcJcaAcp6zUczcT8F3PROgm10FL3FF92M=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLeFNu/N1cWC/M74L92we/c2iqT5mbd0r+zrUqXWpTKn
 vGR2Lu6o5SFQYyLQVZMkSUui/tlfcnrNXwHF7bBzGFlAhnCwMUpABPJm8bwPyO7Niyu+s2Mdaa/
 A9eWrbm4rODznYP+Jy68r1e+8vZzzmZGhoOq8tydXHE/Jv3dcDGYZ32fsyiT4zLG2zt8rVqeV1Y
 UsQAA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently when we run guest code to validate that the values we wrote to
the registers are seen by the guest we assert that these values match using
a KVM selftests level assert, resulting in unclear diagnostics if the test
fails. Replace this assert with reporting a kselftest test per register.

In order to support getting the names of the registers we repaint the array
of ID_ registers to store the names and open code the rest.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 83 +++++++++++++++++++------
 1 file changed, 64 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 1d2cc25cb3f4..ef833ab3e6ce 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -44,6 +44,7 @@ struct reg_ftr_bits {
 };
 
 struct test_feature_reg {
+	const char *name;
 	u32 reg;
 	const struct reg_ftr_bits *ftr_bits;
 };
@@ -228,30 +229,32 @@ static const struct reg_ftr_bits ftr_id_aa64zfr0_el1[] = {
 
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
@@ -265,6 +268,8 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
+
+	/* Additional registers counted in NUM_EXTRA_REGS */
 	GUEST_REG_SYNC(SYS_MPIDR_EL1);
 	GUEST_REG_SYNC(SYS_CLIDR_EL1);
 	GUEST_REG_SYNC(SYS_CTR_EL0);
@@ -275,6 +280,35 @@ static void guest_code(void)
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
@@ -675,7 +709,8 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 	struct ucall uc;
 
 	while (!done) {
-		u64 val;
+		u64 reg_id, expected_val, guest_val;
+		bool match;
 
 		vcpu_run(vcpu);
 
@@ -684,11 +719,21 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_SYNC:
-			val = test_reg_vals[encoding_to_range_idx(uc.args[2])];
-			val = reset_mutable_bits(uc.args[2], val);
+			reg_id = uc.args[2];
+
+			expected_val = test_reg_vals[encoding_to_range_idx(reg_id)];
+			expected_val = reset_mutable_bits(reg_id, expected_val);
 
 			/* Make sure the written values are seen by guest */
-			TEST_ASSERT_EQ(val, reset_mutable_bits(uc.args[2], uc.args[3]));
+			guest_val = reset_mutable_bits(reg_id, uc.args[3]);
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
@@ -941,7 +986,7 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;

-- 
2.47.3

