Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A22923E33D;
	Sun, 19 Jul 2026 19:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784489269; cv=none; b=V6fOmwctvrSi3UvBCSNDw9R016X5xWHRXHH0rWi5v+EFdymES8r8n8Ml6lhB40Wz/cwPVjvUNxDVxqNRdmXVQcNVknex4T2nxRmjUKCK2EiCBcKc3UTzFJmcxgv+swXWR/bq2UTgajG3eZk0SlPGhcErnGIqEBZ5vZGOk+UPSd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784489269; c=relaxed/simple;
	bh=IJUCIxvw4excQxKCa7m51cgP09d2ulJBN4CshTpCm2I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fdh0fzD2hRFeqLJraXfr0z9MryGqxaIpRHefL+DVZ1e8OOzyD7JuX492zZcFOd32jNHHDq6j0PVqKQJLh/9PPAaZDtjxcjCd4rT4ZSV3ZjGq+zOaXh4t3yZz0gECvoH077+9LNCPZzC1SESg7d4TVAAouBwMwpBx+So7v2syv7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bgFOyh3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bgFOyh3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E360A1F000E9;
	Sun, 19 Jul 2026 19:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784489268;
	bh=1vfSs3xN+iG2ar+D4KsRWb6ogp8LrkeeccY8yQZbssA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bgFOyh3TiTo8/28FIMnEDqPS1XToNuZhoOoul2+x34855j09a2WWFz/wZCLIn9v9r
	 WIb8HUDOPlIESu9Z+pEVbqnpYZmaizBPZF9hZmhtcACZvaw7aR9aagCbeA1LhO7Rdl
	 OF3vr7Bmfu7uelTjgxH11qer2/dwIiAmtyLPX+/RaN0HXG+pT5PmFqgPVqVfESYnOe
	 Tz7fwXCxZ5lry8t9IMHDkebaWnIKEmtC7f2mJvqsVKy8uubKD7CIcDObGl6oF9F2og
	 YiEWjAW+9uJ4Y/x1jAPt5ySTlZKX9C+QAZLkRCOWDUhrTkUQcx/35aJTGsjjd1Km7M
	 0rA9n+6jz902Q==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 19 Jul 2026 20:24:41 +0100
Subject: [PATCH v6 2/3] KVM: selftests: arm64: Report register reset tests
 individually
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260719-kvm-arm64-set-id-regs-aarch64-v6-2-724287f5f108@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2517; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IJUCIxvw4excQxKCa7m51cgP09d2ulJBN4CshTpCm2I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXSUqNPlopUVi10luMCHqIc0BWU7OoV+DV5/10
 +5CCEx3XM2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal0lKgAKCRAk1otyXVSH
 0CLCB/4sTJQIBl44wnRefXp4qppuX404jEjFkQCC2mwAFci6f/31YJd8feBHQH6pgbRbaq/Fb+M
 Tx8GfMJzo3gcNR/PJ3xBTafaVgK7KAbcMoZHwVpVX7ljTkF/xcBUBGDTYNxbWW/lXknzsC5MrAh
 teed0YTCD92jS73spYGDz/EDytpwDQD2FEcjSuotQaagZ5jKB5dtkBSFLGkiySFGDeGh1OI/V7O
 D4tTzmqyx+yzDrTIS708d7RKFMYHI/5h2Sey4g16jV7/v7m3GTH68RZbCtyR94XGtgcsEkZtdNt
 1v8BtfxPkhIhCXIZbJp4oJRFzULLe13xuLF4SSXTkvpePVu6
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

set_id_regs tests that registers have their values preserved over reset.
Currently it reports all registers in a single test with an instantly fatal
assert which isn't great for diagnostics, it's hard to tell which register
failed or if it's just one register. Change this to report each register as
a separate test so that it's clear from the program output which registers
have problems.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index db6414a93ad3..3aa8886e8b70 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -819,13 +819,21 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
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
@@ -843,8 +851,6 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
-
-	ksft_test_result_pass("%s\n", __func__);
 }
 
 int main(void)
@@ -872,7 +878,8 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
+	test_cnt = 2 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST +
+		ID_REG_RESET_UNCHANGED_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;

-- 
2.47.3

