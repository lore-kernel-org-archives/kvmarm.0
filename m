Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F3B5221E4;
	Wed, 30 Sep 2026 21:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804973; cv=none; b=dR0/EyMGEugn1B5ujiQflMw3PsqqzxSEvePDRc/DuK9yl0PxlU/hLTpY2hgodO7HVZVnv61eTl0B+Ve25Q8kqVuAO0r9rhyhDzkCDUm8AOegspPKaxDSSBe0OKKW2U9zJwGkIZyU8CwAetnvuGw6UJRjIfW1uJClugj2R+dJVYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804973; c=relaxed/simple;
	bh=JTor9Lxzhm4h9y/I5pbwM1ZZXnzU52yIxfAOX8qz2wc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LIYSfzdRhNlM79NfhV3pEUn7XhhCqLIQdhs/wsgv3d9I7r7mmiBrY21Z8JdAdSxzHOqkOsQwC6SSEsQvxnER95PRgLoXNHYCq9+pU3t5OqfPWfKsIhtUVktv/f6gggEJ9i0FvfHcnLXpWazAFwo3GglNYdR+H7wn08j9Joii8/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZ3HjDFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZ3HjDFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3B11F000FF;
	Wed, 30 Sep 2026 21:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804971;
	bh=QZ28KimG+sA29Zf5pARwG9R82neiorcaxW5Meg8/n6A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iZ3HjDFvbFex5g9q2a64XEmyyZs8RonDRPy7eQrkr0ybOz9oNP1NuT6W3tUo5W4L/
	 RtV3UiznAnNy7mhQb7hncDpOhYyZSSe0SHsw7JC/tlSSPxlF3nmMjmxToEOv+XmnPo
	 tq+dT9CR5t+TW2lEXd28UP7DfoMJaj6peKd2Eho7Tvfv0sA/iqCpOypA/2OKepxuyE
	 UEHXsvq0f9tJPAcV3yO198ns5zpQD2fvZYBZ6QUfxgvR+IfZJK4CYUvkI93tNPfcSY
	 e08jvZqsksoe2RAfSmVRDnw4YlzbOJbxvYqYRDUWunh39dEjZUYO2/CcLafu7KGYwx
	 H8Wr2aoCeQaoQ==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:20 +0100
Subject: [PATCH v21 10/15] KVM: selftests: arm64: Check that invalid
 feature combinations are rejected
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-10-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3874; i=broonie@kernel.org;
 h=from:subject:message-id; bh=JTor9Lxzhm4h9y/I5pbwM1ZZXnzU52yIxfAOX8qz2wc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO7wjG6Z2GuPWofP8i6Mr/VAYJ98hn1t+mMe
 QZkuQqpusaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DuwAKCRAk1otyXVSH
 0Ei6B/kBZ+dbCyKYXXnJ07EhGQ2MhZ2QjSZwNUd0X0zZn9h+bU/e5VRXIFLM2zwY2bPaTFuei+U
 AMcV36X/9auPS3zXxFoMuUhCtZAMCg/3gE9fuw8CzdT+LynwVnZA0tn/CLGCfBPyb0AGZsJOaGP
 ZywZHYhBbjhaH4k+SN5NOxfiYzK41phINfkd2S0J0/1B+06O3w8k1pLbYKnflaPWDXGd0TivscS
 t5w+9GicbfU63jdVIicSOrmzR9a2O7jN89BcoUZCoqDBoMga6TpYowNc/QDi13X45bLvuKBhGbx
 KOppyt7+0hMUoFmPYZJU+dcW/vrLKw+T+ImsLbfvsWPF1ZwV
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to optimise fast paths KVM explicitly rejects configurations with
S1PIE or S1POE but not TCR2, add coverage of this in the set_id_regs test.
We have a list of invalid configurations, for each of them we try to run a
VM and fail the test if it succeeds. We do feature detection by validating
that we can write the fields with failing values.

Since this misfiring can disrupt some of the other tests due to the kernel
refusing to start guests we run the new tests first, improving diagnostics
in the failing case.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 87 +++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..cb5e6358c59c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -803,6 +803,89 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
+struct reg_ftr_val {
+	u64 reg;
+	u64 mask;
+	u64 val;
+};
+
+#define REG_FTR_VAL(r, f, v)					\
+	{ .reg = ARM64_SYS_REG(sys_reg_Op0(SYS_ ## r),		\
+			       sys_reg_Op1(SYS_ ## r),		\
+			       sys_reg_CRn(SYS_ ## r),		\
+			       sys_reg_CRm(SYS_ ## r),		\
+			       sys_reg_Op2(SYS_ ## r)),		\
+	  .mask = r ## _ ## f ## _MASK,				\
+	  .val = (r ## _ ## f ## _ ## v  << r ## _ ## f ## _SHIFT) }
+
+static const struct reg_ftr_val s1pie_no_tcr2[] = {
+	REG_FTR_VAL(ID_AA64MMFR3_EL1, TCRX, NI),
+	REG_FTR_VAL(ID_AA64MMFR3_EL1, S1PIE, IMP),
+	{ }
+};
+
+static const struct reg_ftr_val s1poe_no_tcr2[] = {
+	REG_FTR_VAL(ID_AA64MMFR3_EL1, TCRX, NI),
+	REG_FTR_VAL(ID_AA64MMFR3_EL1, S1POE, IMP),
+	{ }
+};
+
+struct ftr_config {
+	const char *name;
+	const struct reg_ftr_val *regs;
+};
+
+static const struct ftr_config invalid_configs[] = {
+	{ .name = "S1PIE without TCRX", .regs = s1pie_no_tcr2 },
+	{ .name = "S1POE without TCRX", .regs = s1poe_no_tcr2 },
+};
+
+static void test_invalid_config(const struct ftr_config *config)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	const struct reg_ftr_val *field;
+	u64 val;
+	int ret;
+
+	vm = vm_create(1);
+	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	/*
+	 * If we don't manage to set any of the fields assume the
+	 * system does not support the feature and skip the test.
+	 */
+	for (field = config->regs; field->reg; field++) {
+		val = vcpu_get_reg(vcpu, field->reg);
+		val &= ~field->mask;
+		val |= field->val;
+		__vcpu_set_reg(vcpu, field->reg, val);
+
+		if (vcpu_get_reg(vcpu, field->reg) != val) {
+			ksft_print_msg("Test setup not supported\n");
+			ksft_test_result_skip("refuse %s\n", config->name);
+			goto out;
+		}
+	}
+
+	ret = _vcpu_run(vcpu);
+	ksft_test_result(ret < 0 && errno == EINVAL, "refuse %s\n",
+			 config->name);
+out:
+	kvm_vm_free(vm);
+}
+
+static void test_invalid_configs(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(invalid_configs); i++) {
+		test_invalid_config(&invalid_configs[i]);
+	}
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -829,12 +912,16 @@ int main(void)
 	ksft_print_header();
 
 	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt += ARRAY_SIZE(invalid_configs);
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;
 
 	ksft_set_plan(test_cnt);
 
+	/* Do this first in case a break interferes with other tests */
+	test_invalid_configs();
+
 	test_vm_ftr_id_regs(vcpu, aarch64_only);
 	test_vcpu_ftr_id_regs(vcpu);
 	test_vcpu_non_ftr_id_regs(vcpu);

-- 
2.47.3

