Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68D33F165E;
	Wed,  1 Apr 2026 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039795; cv=none; b=alZzp19T9t6mYPCW+ZpBZt02dkTcpjiul/HoJlWbsuYdu6a41DUMlLBTBEjp6kGBfMKtziyTDaBLEQ2b05ZGm8nZLTLTXaoaBNe3NV7Y/owuWK+pi5fZ6K+EZCAFaQbhRhgOMsVCvha+WhZfTBdMgq/L3j78BcT4cfG0JnFpu4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039795; c=relaxed/simple;
	bh=qbd0aMEPJKHVVmAHwyCANP8ji9lzQ91FdSs69l2DRFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEdL8KyJaPdtT2Y7Xk3787vcjh/fy93HVetArNwtSwxKZlWuTk/t3cGCMPZf/uxbUYDc3/rcNXvY/+jsYOwwm9nIKtF0LvcsbR7fWvukVlM/x9/cv+lT7WFYxOpttrMpYcpXRlt08ZO3e9mpBNx55lZefMhqYMwBXuK4Bv59yGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDj6nClE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDj6nClE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8974C4CEF7;
	Wed,  1 Apr 2026 10:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039794;
	bh=qbd0aMEPJKHVVmAHwyCANP8ji9lzQ91FdSs69l2DRFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDj6nClEjAAd9rLdWOKR8k9ByOWrXRBsM+TUa+DcAYRJQ4UDUUmoNh7z2TILrEgfa
	 yfAlhIiHHLUFCu6Pxzh6FezWgGtTpWmZsBd0g9IWRvkq4mKiqH50ARA+Upt5J1B2j8
	 lpjB+O9sslgZu1MgLJH0T7udFIUNmj0SCizrwD+cZRHeh8HKEMc+zC/Uz1ZeFP8ihE
	 ux+hfPZ3LsLpFUohPfUDJ7GWqZzyS2d8uR0X6H4EGeNhcERrwhrmzMUE7nUhdNr1YC
	 VcaeM+Nioo4Smxc0WV9+xTNMroqY6hF1mHf98WKm4jRDBsvbL+OuyNuLqRan8ZN+0g
	 48csUVOlWW2Mw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw4-00000007oRQ-33Xr;
	Wed, 01 Apr 2026 10:36:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 16/16] KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime
Date: Wed,  1 Apr 2026 11:36:11 +0100
Message-ID: <20260401103611.357092-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
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
index 73de5be58bab0..7899d557c70b6 100644
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
+	TEST_ASSERT_EQ(reset_mutable_bits(encoding, test_reg_vals[idx]),
+		       reset_mutable_bits(encoding, observed));
 }
 
 static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
-- 
2.47.3

