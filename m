Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880909;
	b=uPWnTOVn/z4lZ+0GeezocSfXMIUtv7yDG705EJ2jlcDNAPZ+ejpb7ej2u4Ow65fla5Yo
	 pUgykc/T+JwbHMjukQc/hGGcflPLn8gZOuQWcQD5Dt8zHCy5pKJ5rTzQcXb2EqWbS1r4p
	 N1hRlZekN0ZEczUhsyckOd5/YGa98vhA7DbNqsLbzq2Hmk6qIpVV19n50aODKUES38pSM
	 nc8GB4Qoya0XGWjLyd9lIMw+pbLWEGK7OrAveL4SRDtQx7enMNJ8kJUd9aoAR8tKf8M1j
	 /jRqH2jn7BJVI0gdkN37iL7aghmQhi8LqwnbuhMRfOxLbYqlRRQ43VALSSP5+GZy1fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880909;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=EjHHerbQtH8PkJVTm5A4n/paGtt5ATnY9+Koe88/4LE=;
	b=4UQLTIga0vONSU6f3Z05ZQ/bXxkGvekiJXamLVoIISQJAHIuRiWzDEdu88Yx7/+KxPwv
	 OWd7K7tDmUcTIjMwJWyIm9bW/E/cppVPci6QkdPmS1bx47oIZCKudVoGbcpeHnaucJRGH
	 I7P56bp8nJJvSvBbxh5qg1MEKFVcQBV+cBTSQiGODS9mXtzO0pb6CWWIaNiQxbP/hHT7b
	 N4Ea+FNjQUW9JSzZvlcsdP6feXL10gOZDkamoKlhcAcdO390Oc9oOSm3gxIUBkFB0dFGf
	 HHVtEn2mFr/0JTbo4O8qDiIWA5V+7+4wTq/d03MtiTm2q0MELpzy9EtpiZaTB84w85g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mA8OGImI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F3A606A331;
	Thu,  5 Nov 2026 12:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mA8OGImI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0E11F00A02;
	Thu,  5 Nov 2026 12:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880908;
	bh=EjHHerbQtH8PkJVTm5A4n/paGtt5ATnY9+Koe88/4LE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mA8OGImIAM2oSGIP6F5xMkpDWUGpMztlncn928slbRyyhHGiBi/3BaNJRuXq1Y/Cb
	 +GEX6MG5wvXI8aWsGMw4fevZeZdXBTz8CZUp894GolHb3rHvMRsVDmy+JJkMGuWgtW
	 v9/LchHxd26rFXUQ5+O8apewCW34AGL2TqroGTZDw0tz0KNGJUKyUAuede4TIaGCGV
	 E7Q2sWoRDtDSDNPcacMmJegj8QcxOvzkMd+7akCRkYbkeA+IhKX1Llkmy8GLVEQPkM
	 O/riGsnRp3QtG9sc2QGQcYq4GlDGaZYiUZUVzZsoJL5eSu2Nyr2N8lT3G+0witrb1L
	 4XlwTsCh0xUjQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 11:47:21 +0000
Subject: [PATCH v10 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validity checks non-fatal
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
Message-Id: <20261105-kvm-arm64-set-id-regs-aarch64-v10-3-d5a6aba69d19@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4751; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sCUDXK5zt6Sullbao2LmXhfh5JZy+wCGZCip8JVi8Mo=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLeFNv3bWz8fi7ymNTlDDbb398jIkX+MRu+WKO++IRtw
 obI3z5hHaUsDGJcDLJiiixxWdwv60ter+E7uLANZg4rE8gQBi5OAZjIdCmGP9x98gumb0799vhh
 v8CKitCpDMuT0szuqHd8fvhRIIPFfhMjw4GZbDNzTgqIftv2q1ieO37lqa8LbuxczDSdX8zFLum
 5OwsA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently when set_id_regs encounters a problem checking validation of
writes to feature registers it uses an immediately fatal assert to report
the problem. This is not idiomatic for kselftest, and it is also not great
for usability. The affected bitfield is not clearly reported and further
tests do not have their results reported.

Switch to using standard kselftest result reporting for the asserts we
do, these are non-fatal asserts so allow the program to continue and the
test names include the affected field.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 52 +++++++++++++++++--------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 69aebb3a28f4..8c484db65484 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -417,12 +417,14 @@ u64 get_invalid_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 	return ftr;
 }
 
-static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
-				const struct reg_ftr_bits *ftr_bits)
+static void test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
+				 const struct reg_ftr_bits *ftr_bits)
 {
 	u8 shift = ftr_bits->shift;
 	u64 mask = ftr_bits->mask;
 	u64 val, new_val, ftr;
+	bool pass;
+	int ret;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
@@ -433,11 +435,17 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
 	val &= ~mask;
 	val |= ftr;
 
-	vcpu_set_reg(vcpu, reg, val);
-	new_val = vcpu_get_reg(vcpu, reg);
-	TEST_ASSERT_EQ(new_val, val);
-
-	return new_val;
+	ret = __vcpu_set_reg(vcpu, reg, val);
+	if (ret == 0) {
+		new_val = vcpu_get_reg(vcpu, reg);
+		pass = new_val == val;
+		if (!pass)
+			ksft_print_msg("%lx != %lx\n", new_val, val);
+	} else {
+		ksft_print_msg("Write of 0x%lx failed: %d\n", val, ret);
+		pass = false;
+	}
+	ksft_test_result(pass, "%s valid write succeeded\n", ftr_bits->name);
 }
 
 static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
@@ -447,6 +455,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 	u64 mask = ftr_bits->mask;
 	u64 val, old_val, ftr;
 	int r;
+	bool match;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
@@ -459,11 +468,19 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 	val |= ftr;
 
 	r = __vcpu_set_reg(vcpu, reg, val);
-	TEST_ASSERT(r < 0 && errno == EINVAL,
-		    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+	if (r >= 0 || errno != EINVAL) {
+		ksft_print_msg("Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d (%s)\n",
+			       r, errno, strerror(errno));
+		ksft_test_result_fail("%s invalid write rejected\n",
+				      ftr_bits->name);
+		return;
+	}
 
 	val = vcpu_get_reg(vcpu, reg);
-	TEST_ASSERT_EQ(val, old_val);
+	match = val == old_val;
+	if (!match)
+		ksft_print_msg("%lx != %lx\n", val, old_val);
+	ksft_test_result(match, "%s invalid write rejected\n", ftr_bits->name);
 }
 
 static u64 test_reg_vals[KVM_ARM_FEATURE_ID_RANGE_SIZE];
@@ -503,7 +520,11 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 		for (int j = 0;  ftr_bits[j].type != FTR_END; j++) {
 			/* Skip aarch32 reg on aarch64 only system, since they are RAZ/WI. */
 			if (aarch64_only && sys_reg_CRm(reg_id) < 4) {
-				ksft_test_result_skip("%s on AARCH64 only system\n",
+				ksft_print_msg("%s on AARCH64 only system\n",
+					       ftr_bits[j].name);
+				ksft_test_result_skip("%s invalid write rejected\n",
+						      ftr_bits[j].name);
+				ksft_test_result_skip("%s valid write succeeded\n",
 						      ftr_bits[j].name);
 				continue;
 			}
@@ -512,11 +533,8 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 			TEST_ASSERT_EQ(masks[idx] & ftr_bits[j].mask, ftr_bits[j].mask);
 
 			test_reg_set_fail(vcpu, reg, &ftr_bits[j]);
-
-			test_reg_vals[idx] = test_reg_set_success(vcpu, reg,
-								  &ftr_bits[j]);
-
-			ksft_test_result_pass("%s\n", ftr_bits[j].name);
+			test_reg_set_success(vcpu, reg, &ftr_bits[j]);
+			test_reg_vals[idx] = vcpu_get_reg(vcpu, reg);
 		}
 	}
 }
@@ -996,7 +1014,7 @@ int main(void)
 		ID_REG_RESET_UNCHANGED_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
-			test_cnt++;
+			test_cnt += 2;
 
 	ksft_set_plan(test_cnt);
 

-- 
2.47.3

