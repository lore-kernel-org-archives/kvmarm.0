Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BF63644BF;
	Tue, 17 Mar 2026 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778259; cv=none; b=Pr3W01DZNT3HG2DogkYLKTz6tHYgb72s6GJUdMjyIppvh3FceEuSr+KkdQ0nHY4n/1nuMkNHTFrJCEOp+WInnJCKkXsHcIlWsKYiTy/8ZUXJ6mD13dJDuvzhHpeddCPpkRUVAk3OymlQ2dLy7kxss4ZDgACWDB98eSlffIOzyr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778259; c=relaxed/simple;
	bh=qjkFp7iedLQabJArWZg6nyU9Z143fBvz+MFdJAqkGlM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qVMwqmo7oglnR2gGPMx4mD7ChkQ/YOjHyopcj6uh1dEqUTbdBxRqjmRE5p6FFXpw5JmJPiZAzXZ8GVY/djPHYQamJMagC+DV6S8kZzyKm9eoDf0hsL4bTHbIwkbJ0WlWac8bEmRpef+rhUnkkxNGk7ea/KO6ic1Q2/v8Ynhi5T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tqJUDj6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tqJUDj6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2CCC19425;
	Tue, 17 Mar 2026 20:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773778259;
	bh=qjkFp7iedLQabJArWZg6nyU9Z143fBvz+MFdJAqkGlM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tqJUDj6rO/LGK7GVYF+91XYOBql5Ztf6MyAdEfZQHE2CfI4D8sdlJIj5mYnyIg2Gl
	 +Mc98qAmeEIC8uuVLY0C19YePAD4n+MlZdbgLLaiZG9TqsZHoB/fwkuQNlxvVcD+gO
	 Ms5EOxgQd70CnBg3b+eSsrMP1MJXwQD+0DfywB8DRiPKJzJ8bnAcnI4c2AIo9246TR
	 oYL4u0FK3FvoIfYMpHb/OotVImaavNY7vcD11+a05se7TGmGgHwwv0TktDaN0+q/9K
	 xfX7HNZy1xd+g+9eQBe7o7EfZiB4p0b5FYp9lViMqIfaIo8q2FiPkwzbfyLNIS3h/f
	 1YXRJkpJ90nRw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 17 Mar 2026 20:10:37 +0000
Subject: [PATCH v5 4/5] KVM: selftests: arm64: Skip all 32 bit IDs when
 set_id_regs is aarch64 only
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-kvm-arm64-set-id-regs-aarch64-v5-4-a60f2b956e22@kernel.org>
References: <20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org>
In-Reply-To: <20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-e1b5b
X-Developer-Signature: v=1; a=openpgp-sha256; l=4946; i=broonie@kernel.org;
 h=from:subject:message-id; bh=qjkFp7iedLQabJArWZg6nyU9Z143fBvz+MFdJAqkGlM=;
 b=owEBbAGT/pANAwAKASTWi3JdVIfQAcsmYgBpubVDktHRSlwlVT903e0/pOLpvx0ys9JhXg47v
 QuIf/MPKsyJATIEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCabm1QwAKCRAk1otyXVSH
 0M11B/iz341VPB5PCi1SkyWMy1du5Nzj1+xuY1MbAO3o/MONJUl3IYIhre4IAW3FhH4kxe4SDzk
 iFATSQ9Ofau1hWnSFoudpMr5CrFmvj4Srume0rj66N32aGKHjUqQSrBEc06HDv1Jrfkf8jZM+tY
 g44gZnXuP5PDlMcpz0r1ddVpYrNDxXKoCuKPxKV1wAETKGRW7X039LirzhM+yPsU6LIOmE7R0cG
 GJ6cwou0h8OjHEbnDqXUU+tfWOitz/BSfw02hU5tOJQnpbF5+wl2W4ylz8ceohER70A0hWkOG2L
 Hf4T2uCCvDe1MaXiYT1KwXrIR+YOr2Iq58SNmz8okW47X78=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

On an aarch64 only system the 32 bit ID registers have UNDEFINED values.
As a result set_id_regs skips tests for setting fields in these registers
when testing an aarch64 only guest. This has the side effect of meaning
that we don't record an expected value for these registers, meaning that
when the subsequent tests for values being visible in guests and preserved
over reset check the value they can spuriously fail. This can be seen by
running on an emulated system with both NV and 32 bit enabled, NV will
result in the guests created by the test program being 64 bit only but
the 32 bit ID registers will have values.

Also skip those tests that use the values set in the field setting tests
for aarch64 only guests in order to avoid these spurious failures.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 49 ++++++++++++++++++-------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 60e7f0c1bc26..127defebb35a 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -294,6 +294,13 @@ static const char *get_reg_name(u64 id)
 	}
 }
 
+static inline bool is_aarch32_id_reg(u64 id)
+{
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) <= 3);
+}
+
 /* Return a safe value to a given ftr_bits an ftr value */
 uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
@@ -674,7 +681,7 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 		ksft_test_result_pass("ID_AA64PFR1_EL1.MTE_frac no longer 0xF\n");
 }
 
-static void test_guest_reg_read(struct kvm_vcpu *vcpu)
+static void test_guest_reg_read(struct kvm_vcpu *vcpu, bool aarch64_only)
 {
 	bool done = false;
 	struct ucall uc;
@@ -693,6 +700,13 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 			reg_id = uc.args[2];
 			guest_val = uc.args[3];
 			expected_val = test_reg_vals[encoding_to_range_idx(reg_id)];
+
+			if (aarch64_only && is_aarch32_id_reg(reg_id)) {
+				ksft_test_result_skip("%s value seen in guest\n",
+						      get_reg_name(reg_id));
+				break;
+			}
+
 			match = expected_val == guest_val;
 			if (!match)
 				ksft_print_msg("%lx != %lx\n",
@@ -784,12 +798,19 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
-static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encoding)
+static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encoding,
+					 bool aarch64_only)
 {
 	size_t idx = encoding_to_range_idx(encoding);
 	uint64_t observed;
 	bool pass;
 
+	if (aarch64_only && is_aarch32_id_reg(encoding)) {
+		ksft_test_result_skip("%s unchanged by reset\n",
+				      get_reg_name(encoding));
+		return;
+	}
+
 	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
 	pass = test_reg_vals[idx] == observed;
 	if (!pass)
@@ -800,7 +821,8 @@ static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encodin
 
 #define ID_REG_RESET_UNCHANGED_TEST (ARRAY_SIZE(test_regs) + 6)
 
-static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
+static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu,
+					 bool aarch64_only)
 {
 	/*
 	 * Calls KVM_ARM_VCPU_INIT behind the scenes, which will do an
@@ -809,14 +831,15 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	aarch64_vcpu_setup(vcpu, NULL);
 
 	for (int i = 0; i < ARRAY_SIZE(test_regs); i++)
-		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
-
-	test_assert_id_reg_unchanged(vcpu, SYS_MPIDR_EL1);
-	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
-	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
-	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
-	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
-	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
+		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg,
+					     aarch64_only);
+
+	test_assert_id_reg_unchanged(vcpu, SYS_MPIDR_EL1, aarch64_only);
+	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1, aarch64_only);
+	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0, aarch64_only);
+	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1, aarch64_only);
+	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1, aarch64_only);
+	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1, aarch64_only);
 }
 
 int main(void)
@@ -858,9 +881,9 @@ int main(void)
 	test_user_set_mpam_reg(vcpu);
 	test_user_set_mte_reg(vcpu);
 
-	test_guest_reg_read(vcpu);
+	test_guest_reg_read(vcpu, aarch64_only);
 
-	test_reset_preserves_id_regs(vcpu);
+	test_reset_preserves_id_regs(vcpu, aarch64_only);
 
 	kvm_vm_free(vm);
 

-- 
2.47.3

