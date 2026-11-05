Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880906;
	b=LhtZ7FK1Bv/+YropBpG2ZX3Xga7+T4bVy/04KNAmMafeqXDyUD2MIUDbzU30BG8WF0sF
	 +EwdemqQVnXNvlFy0seiC8JfAfGxax+1+rtGGuL5k1UuXyq63+TKJQ2cf0GjJjOov7RfE
	 hrvw0ZeWUDLcByJodXM9bkOyyTz2oGpuAXROHxTNsi2pe3dlkG9MiAMKhDCsppeT8dCuc
	 D6lf62pHDa2BEgZZWLqFBa0d6ACXY9xJZVR9BSZC21PfLmQOYv8WGNik1eg6/P5uxW65e
	 8iCK50N+qRWXVoVH9f0DGag9i3nuumgjpdskjh+4AFgKstVbUOggdIsD5YkCe2h9MaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880906;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=LwBXqwHoOGI50IkmfmuD/vtXnhABlbS2mlsg3C2//RA=;
	b=ZoleW+zvwblyg5gZWgPvi3Zck3yz+JgpY5hQ7SvZw2RSapKzc3CwpEICuUqREZpGTxWA
	 U2SR8OQWCPnjTInRsRSmkQZJkTJ4YHz6F5ZcP14Fwv+rFf3Ej1Sp/BOhwxe2PHSAGqYHJ
	 z4aMyJWC+kHZLkwtokjcGcNTTAaDqZcgHNO/JQOEXx8wLOciq9VPWXh2sCgmxmceAkhYo
	 dYr25xgnrN0YjiYRTRhS74guQIaNcNQD/zdZDK8tSy7bT76JBQb44AuK7l/egGbtOyJNT
	 aDF0zzxAguKeTmKDelSM7Byw/CUMj6Hl2jpPBeYg1fhXVMGFJeFvLI+BSzyUb/kWH7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Go/RiaDC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB9C606D80A;
	Thu,  5 Nov 2026 12:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Go/RiaDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CAE1F000C1;
	Thu,  5 Nov 2026 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880906;
	bh=LwBXqwHoOGI50IkmfmuD/vtXnhABlbS2mlsg3C2//RA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Go/RiaDCjnitljKY9hChsi2K9rd+amQQ4J7+VzabKenrgKh/YowB7TQz/+1y7h4Rz
	 wJOGuSgK6MeWUuAVmKVBkOKa946LIUCL9AteHHeQDARC2oa+QCloqbLGNXbeB1bkF0
	 cBM3nMlcwwQlynmtn8iknLspkt+r983Yu4Xe2Sbt4cKWA+Y8vnG5R8Fwrum2DN6YMg
	 LUZipJ/ZWI6J03dLouOwKyq5gMkm4pqmpRSgMR/7CGaC/9E2M+6yUylIVA6ROMndj7
	 rJTORXTHnwDkU3/ZeDKxbONAAztweLFc5yzyVcKh6R4hwNfUK9FZAuDoeYCJG/qgeB
	 DQ7mxc1uHhkOg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 11:47:20 +0000
Subject: [PATCH v10 2/3] KVM: selftests: arm64: Report register reset tests
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
Message-Id: <20261105-kvm-arm64-set-id-regs-aarch64-v10-2-d5a6aba69d19@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2606; i=broonie@kernel.org;
 h=from:subject:message-id; bh=M8ccLSUmMl/2YCdNvTWoufobRy8bJ7EzYBruWb7nFtA=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLeFNs/mddfcab+rb/uG84O6fsXTpjcsp3iNnEzw+bbG
 tXVZ7vjO0pZGMS4GGTFFFnisrhf1pe8XsN3cGEbzBxWJpAhDFycAjARV1tGhuvnN8u6i+4psry9
 osSA/bd5tGAu+2yOR6cL3j09n/G30pnhf/3EeXJ1G34x2Oz5knTkjp18z7frmYp1WrviVBW0S2/
 FMgMA
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
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index ef833ab3e6ce..69aebb3a28f4 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -821,13 +821,21 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
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
@@ -845,8 +853,6 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
-
-	ksft_test_result_pass("%s\n", __func__);
 }
 
 /*
@@ -986,7 +992,8 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
+	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST +
+		ID_REG_RESET_UNCHANGED_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;

-- 
2.47.3

