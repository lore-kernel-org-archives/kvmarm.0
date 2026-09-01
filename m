Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9090349F13A;
	Tue,  1 Sep 2026 18:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288635; cv=none; b=sW6DdYEeY67ibaaZTmqopWQs7kw/zSd1kMg5UZk38Sl+YnwwKNFR/Cvxt9hgqiMSvjKy1eiaI180KJ7+YiQyiYppX48DDUslwxXRcUTnN1S4E8aOp++DIKcXIw5VAdcy/MqTSQW+pEjl4Kts9Xy3i6kjzQqB/G0z5KSwApK28k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288635; c=relaxed/simple;
	bh=IJUCIxvw4excQxKCa7m51cgP09d2ulJBN4CshTpCm2I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NLePt17cVI21j9oSyeulkGy8M7QgSCJg92Akg3e8AcORhtDgSYvJYzYF1sRsfRIyE+KhQuB8ZTHgRtVQ/Ol+a+inDGV4eaVCSWIdtxanjlMtvWGCn5NrQSdFYghGbd6G/+lDUYrGaR50n+35kygfmHAYmTdpSeQ6vtW8bZE3Z/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTQF3wTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTQF3wTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032C71F00A3E;
	Tue,  1 Sep 2026 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288634;
	bh=1vfSs3xN+iG2ar+D4KsRWb6ogp8LrkeeccY8yQZbssA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MTQF3wTz6mge6aB5BcAmGhovOr+XA62scho4yDtybvhT26OB7WDhSm8UPmI3SdORv
	 mUk0eCRUxozo7XXcsYlawwaTP+yzE+svY5DglOggpbfodaR7euTxRwe68E2RpO2+oM
	 WrIFW9Q0X+5TRtegXhQNOx2U8L07gSAp70NiB6UP2TvEwoJ91gbrtEvIFRFk5h7Csy
	 ogWMQ5mVFmt+T5ss29q43d6RRReoqTYsECc/W+0KiRFBvwAThirFOhMQ6aLw9vZYfe
	 siCoXYpoCyS67VjeRP5urrWIv31FSgCvGLWkE5k5tyo5wbcpsNChvZ5ZssZn238e3E
	 fAxa1NcxixfTw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 19:50:02 +0100
Subject: [PATCH v7 2/3] KVM: selftests: arm64: Report register reset tests
 individually
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-kvm-arm64-set-id-regs-aarch64-v7-2-7b065b0bda9a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2517; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IJUCIxvw4excQxKCa7m51cgP09d2ulJBN4CshTpCm2I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqlx5uHauy2nPZ39n1Y2+yXb687AUsWqaPEafsY
 4heIIgryTuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapcebgAKCRAk1otyXVSH
 0J9GB/9BZYNZD4i2aVDyjLq+RjhBS8e7S/GWU8Q4H1og7kCIhDy3U5ynKD6BiX8irz/Zr0/HBa3
 +D89+Hh99ft2fbOdULjO0CjTdRCezg/OHmJ2ZYkH3Rs6I7QfTPuoD1oJj58YFzYedj/fYFrhiMy
 MPkNj6kOLf5AbZFUrPqIWut5zH5r+2oQsIBCTrTuD0SpPuzmuZmDVXsAYwf6/T2BfkGu3Osdlh1
 pcO8BZTu1cfz0VNWbjqdeYLGBFIQf0CsRmLBAMAmShYF0rYJkZXbV9lpR7PIhYbSTd5U71uUpVX
 mQSfEeb9II0YIeWZe4YS3D+BBrgy737dd3Dmw2UFAgCF4J/V
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

