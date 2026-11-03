Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793730056;
	b=KuEMPGydP4x1DxqVO6hl+Wzkb7sTZwGaMyuM/CpIZ7rmUozgGflmEnNr2ZzRsb8B2hCW
	 +vBSqkthFEcOP3NQF9JCnrVaNmY+r09gIX5PXjWrn8Rf5WOya9kyDbJY8l3vU0HANF0Bu
	 2u+Haaf9ib4B41qbrorVJLXjpM1+4NWsLQwXTC6zPTGrH9H2/GXAf+RnuBlCWyGBDsjyH
	 65hcgTM+HEaO6eSphN5IT13zH1w4tfsPH3Oikr8sLWeNs6DIHOL95oUo3LgbgseXATEwV
	 PV1884I7eLxufl8K03u0c/fo5iual8gMOJEq5LPtVU+12A3BXYPYgdw4Nytupi9VbhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793730056;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=CPXc0O7MKcjSrwtn6DF7S5L9f42l8jD3XdoUxmsVzys=;
	b=bhvp+X6LGbkdFQP+F1vgcX15/YQ8AyfUpQMCU73J3p0/GkRYnkC/KlQfTB1Z8xodW8Gk
	 fVxkQEgFdLXmgvRybpI9Bewd4xRub5CV5F12eAiWpN5Z9+Zs88rI8ysE334BI9Dk6mqK2
	 /hk8k4jRz+QKSdgUvmJ6wPk2JiPi00iYKR3Amahyx2OGfXhh3GamOS4vgMQu3LlEmOhv2
	 lJdXd2hyZPStXYwn+MvIvHjoJZZljwpSGuL0KTMWB2NB92akfsnnpZmoL6k0NDvYy3WtT
	 RerTwJkdQbTBX0u3Aq0knR433qSx/f+qCEu9BWjLSPHcRF0tv92S6dBoCawDfieE03w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mk9KQ5XO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C75606A32F;
	Tue,  3 Nov 2026 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mk9KQ5XO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000E71F00A1D;
	Tue,  3 Nov 2026 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730056;
	bh=CPXc0O7MKcjSrwtn6DF7S5L9f42l8jD3XdoUxmsVzys=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mk9KQ5XOQnfQGcYANyqz4cYvRavaP5wjATSQoyUh0VUTh6j6Yb24flZdf/DcRyh3S
	 VufQJfUJsU8fPBglU4ck6NLkFHetD5bL7KqUqxGlWsQiIgpVUN9Odkvu4tJLRyhCTy
	 1fEbqyEhZdj9L0+ZQbj3rOtx4ong7/XRneCCw7Z6UT6jyb8rbMhxKtebf62fpfCjZA
	 Xi5mlwiLS8DkzdjTSJXSSuC3fYaBXqFEEnr3UKtnjL9rhs40pILFZXZUrlWP20zHVx
	 RRH8JIP1U0omxsKEc6NySr3b7VzJXstT+S4uGd5nkANJrIa9cBdZvVui2teBqeIbsr
	 nOyFGoKcFtoVg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 03 Nov 2026 18:19:22 +0000
Subject: [PATCH v9 2/3] KVM: selftests: arm64: Report register reset tests
 individually
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
Message-Id: <20261103-kvm-arm64-set-id-regs-aarch64-v9-2-ab32bc79fa9c@kernel.org>
References: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org>
In-Reply-To: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2558; i=broonie@kernel.org;
 h=from:subject:message-id; bh=JfGzRjUuJXbYAXGFKmvMsIMx4V5AP4Sez6FLWFTsalI=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLJeqf577MX1kGOfpc+laVd6vxj0VzQ+3H98fd1mKyO+9
 fb5s5c5dZSyMIhxMciKKbLEZXG/rC95vYbv4MI2mDmsTCBDGLg4BWAi898y/M9gYZzZlLy3vtJ4
 hZFl8N1vsWwZh7JfL13xdErJ4mXzT25m+F+26M3zy3MTU1WkDe1OLi1Y+aZZfRfXgruNs4V+bvP
 JEWMDAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

set_id_regs tests that registers have their values preserved over reset.
Currently it reports all registers in a single test with an instantly fatal
assert which isn't great for diagnostics, it's hard to tell which register
failed or if it's just one register. Change this to report each register as
a separate test so that it's clear from the program output which registers
have problems.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 0e6fd7b57e52..37107eadd985 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -820,13 +820,21 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
 static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, u32 encoding)
 {
 	size_t idx = encoding_to_range_idx(encoding);
-	u64 observed;
+	u64 observed, expected;
+	bool pass;
 
 	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
-	TEST_ASSERT_EQ(reset_mutable_bits(encoding, test_reg_vals[idx]),
-		       reset_mutable_bits(encoding, observed));
+	observed = reset_mutable_bits(encoding, observed);
+	expected = reset_mutable_bits(encoding, test_reg_vals[idx]);
+	pass = expected == observed;
+	if (!pass)
+		ksft_print_msg("%lx != %lx\n", expected, observed);
+	ksft_test_result(pass, "%s unchanged by reset\n",
+			 get_reg_name(encoding));
 }
 
+#define ID_REG_RESET_UNCHANGED_TEST (ARRAY_SIZE(test_regs) + NUM_EXTRA_REGS)
+
 static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -844,8 +852,6 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
-
-	ksft_test_result_pass("%s\n", __func__);
 }
 
 /*
@@ -985,7 +991,8 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
+	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST +
+		ID_REG_RESET_UNCHANGED_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;

-- 
2.47.3

