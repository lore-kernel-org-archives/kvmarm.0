Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DDF26ED28
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288018; cv=none; b=DnEltOPiYT5NlmYR3UNJmqIloq6oqgrMtm5PqmzM1nK/VhuXf/+/5T/p6+n4oFnNOz8+xwSrBLkngBYXdjZ4Lf8y++MCfZ85wn/BWTgLOkFLostF6pBawjek5WneHjEid5jkpzQMKngny+J1HUYhzqxzD9kQW93gIHEYAsqnpU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288018; c=relaxed/simple;
	bh=cyADZ9NAmmVw6DXEt8XTqLzsSVTUO02DgLX3MND3plw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fv5vXaovhQZSYMAgz0LGJuhET54urHj+XSoffyaTiQmkjBVkJcX1OnjDh9FPlQUrS5BI7jDXQkZtpRdXMt6pRTIMoPEk5KT3FkiLUN7kmmZ7nwFn3O78zb+8PI3RatNWOnI1i1/d7VZeSvvDv2YLx1RrSEdSd1UO3uGowW7WI20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAMvzguF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAMvzguF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0B9C2BC9E;
	Mon, 23 Mar 2026 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774288018;
	bh=cyADZ9NAmmVw6DXEt8XTqLzsSVTUO02DgLX3MND3plw=;
	h=From:To:Cc:Subject:Date:From;
	b=UAMvzguFqw7l8E04akXR2DAi3tC8rDn/FLDt8xxkmA5qEwlx5ozAhlENGBr7/S3i/
	 aYOJ8zGdC/h0L8WXB3NXAuPY+hEzl4QRSDoDBSchHroyMJgNiJkdrOjj1G+jM9EMlb
	 d/9hF5mj0cE17Znj5CirDtDv+QEGcyTd5DE91O0t1rJaRhweKOD3O5T58Flwbckugc
	 gX58KagYf7SdYdLlpZ+u9boMPzMwxrmzWykD/deksMIWj58MRCosnvSon72JyMXLGa
	 uYZTkvK4SSBwcpWt3HqmTsgQopRWSxpqpGkhc30Em6T8br9SxT1mHxPW1huBsqGRnR
	 hogx5xAFoQ0Nw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4jMe-00000004pwY-06KE;
	Mon, 23 Mar 2026 17:46:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime
Date: Mon, 23 Mar 2026 17:46:42 +0000
Message-ID: <20260323174642.3183075-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

set_id_regs creates a GIC3 guest when possible, and then proceeds
to write the ID registers as if they were not affected by the presence
of a GIC. As it turns out, ID_AA64PFR1_EL1 is the proof of the
contrary.

KVM now makes a point in exposing the GIC support to the guest,
no matter what userspace says (userspace such as QEMU is known to
write silly things at times).

Accommodate for this level of nonsense by teaching set_id_regs about
fields that are mutable, and only compare registers that have been
re-sanitised first.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../testing/selftests/kvm/arm64/set_id_regs.c | 52 ++++++++++++++++---
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 73de5be58bab0..24f70312b3557 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -37,6 +37,9 @@ struct reg_ftr_bits {
 	 * For FTR_LOWER_SAFE, safe_val is used as the minimal safe value.
 	 */
 	int64_t safe_val;
+
+	/* Allowed to be changed by the host after run */
+	bool mutable;
 };
 
 struct test_feature_reg {
@@ -44,7 +47,7 @@ struct test_feature_reg {
 	const struct reg_ftr_bits *ftr_bits;
 };
 
-#define __REG_FTR_BITS(NAME, SIGNED, TYPE, SHIFT, MASK, SAFE_VAL)	\
+#define __REG_FTR_BITS(NAME, SIGNED, TYPE, SHIFT, MASK, SAFE_VAL, MUT)	\
 	{								\
 		.name = #NAME,						\
 		.sign = SIGNED,						\
@@ -52,15 +55,20 @@ struct test_feature_reg {
 		.shift = SHIFT,						\
 		.mask = MASK,						\
 		.safe_val = SAFE_VAL,					\
+		.mutable = MUT,						\
 	}
 
 #define REG_FTR_BITS(type, reg, field, safe_val) \
 	__REG_FTR_BITS(reg##_##field, FTR_UNSIGNED, type, reg##_##field##_SHIFT, \
-		       reg##_##field##_MASK, safe_val)
+		       reg##_##field##_MASK, safe_val, false)
+
+#define REG_FTR_BITS_MUTABLE(type, reg, field, safe_val) \
+	__REG_FTR_BITS(reg##_##field, FTR_UNSIGNED, type, reg##_##field##_SHIFT, \
+		       reg##_##field##_MASK, safe_val, true)
 
 #define S_REG_FTR_BITS(type, reg, field, safe_val) \
 	__REG_FTR_BITS(reg##_##field, FTR_SIGNED, type, reg##_##field##_SHIFT, \
-		       reg##_##field##_MASK, safe_val)
+		       reg##_##field##_MASK, safe_val, false)
 
 #define REG_FTR_END					\
 	{						\
@@ -134,7 +142,8 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, CSV2, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, DIT, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, SEL2, 0),
-	REG_FTR_BITS(FTR_EXACT, ID_AA64PFR0_EL1, GIC, 0),
+	/* GICv3 support will be forced at run time if available */
+	REG_FTR_BITS_MUTABLE(FTR_EXACT, ID_AA64PFR0_EL1, GIC, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL3, 1),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL2, 1),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL1, 1),
@@ -634,12 +643,38 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 		ksft_test_result_pass("ID_AA64PFR1_EL1.MTE_frac no longer 0xF\n");
 }
 
+static uint64_t reset_mutable_bits(uint32_t id, uint64_t val)
+{
+	struct test_feature_reg *reg = NULL;
+
+	for (int i = 0; i < ARRAY_SIZE(test_regs); i++) {
+		if (test_regs[i].reg == id) {
+			reg = &test_regs[i];
+			break;
+		}
+	}
+
+	if (!reg)
+		return val;
+
+	for (const struct reg_ftr_bits *bits = reg->ftr_bits; bits->type != FTR_END; bits++) {
+		if (bits->mutable) {
+			val &= ~bits->mask;
+			val |= bits->safe_val << bits->shift;
+		}
+	}
+
+	return val;
+}
+
 static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 {
 	bool done = false;
 	struct ucall uc;
 
 	while (!done) {
+		uint64_t val;
+
 		vcpu_run(vcpu);
 
 		switch (get_ucall(vcpu, &uc)) {
@@ -647,9 +682,11 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_SYNC:
+			val = test_reg_vals[encoding_to_range_idx(uc.args[2])];
+			val = reset_mutable_bits(uc.args[2], val);
+
 			/* Make sure the written values are seen by guest */
-			TEST_ASSERT_EQ(test_reg_vals[encoding_to_range_idx(uc.args[2])],
-				       uc.args[3]);
+			TEST_ASSERT_EQ(val, reset_mutable_bits(uc.args[2], uc.args[3]));
 			break;
 		case UCALL_DONE:
 			done = true;
@@ -740,7 +777,8 @@ static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encodin
 	uint64_t observed;
 
 	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
-	TEST_ASSERT_EQ(test_reg_vals[idx], observed);
+	TEST_ASSERT_EQ(reset_mutable_bits(test_reg_vals[idx], encoding),
+		       reset_mutable_bits(observed, encoding));
 }
 
 static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
-- 
2.47.3

