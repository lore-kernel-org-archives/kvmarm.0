Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DDD501F25;
	Tue, 29 Sep 2026 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699153; cv=none; b=ODB6KguYVSNk6fEQWB/MHeaQuufDktVuq/jY3KrV/i6ZLxV+q8gOnhGSGBMdJ19pwl8ado4Xpdpuz6DeXFT+PWV3M8ngI1GdLTuLoIl5ep9rMyO1DnkkgTLMviWcQ5RK7usdrDknLLBC8g5FGelr3XyaWWMEeXjpYDV02JVVaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699153; c=relaxed/simple;
	bh=Kwt7NK9oH5FmK5X09UqbhhtL97/yzBABChsZOu0XnUc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lPUMDY6naJ2xwsVsoO38oKLxRib7rr2YZBEQ4/jbg7c2DzDH5FOMEDd9Uwj3C1c4UGl5s75Iz0G4xxKD8hWXHZtR7Lem70FRO7FoePT0PEb+gmD58xCcC+shoiEKUyMTPcd6ACce4WvZmqhkBQied7zXWO1jCnqwBzYzpaUD8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6qOf9cS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6qOf9cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1E91F00893;
	Tue, 29 Sep 2026 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790699151;
	bh=FDsvSmIYjY7Wlu5xjH/XblAkB0TRMYrgy/Yq1eEWrDQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T6qOf9cS1m3QYKzDLkO+yE9M1yE4okzFEsCnW9ZxmdTNTyhgW+WTIbbgMOyFDWbkf
	 2NomCNw0Q5PN4n2w7oyNxstUvfJ+kOPCpWSYunwu9qyTDcQzJMIAV0pVL1sHrkq/vI
	 5/SUozIZv4GW9Ql1a+/UZIF41MCXgJ/Y5kX7u2odPS9T2mGMxlDHHwnN/QSNSEHZOn
	 pXr1mjS+uySi+wr4JF77nWG+Gz7ZjTPgyazZ/IF6J5smCsVt2KFwf0N22lrDQt7Lnu
	 I3hQ8M9j6SYGtvPqg8rEWfzyDq/uhUdS15j/jXUuShlPDM21udtaRxYfDc/zyzHW3B
	 U46GpymF6dIJA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 29 Sep 2026 17:16:54 +0100
Subject: [PATCH v8 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validity checks non-fatal
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-kvm-arm64-set-id-regs-aarch64-v8-3-58aabe2c2fac@kernel.org>
References: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>
In-Reply-To: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3917; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Kwt7NK9oH5FmK5X09UqbhhtL97/yzBABChsZOu0XnUc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqu+aBqXzx00nzUEuB2LfTbrWnbVSZTlb7CkI00
 lr3/p6auLyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCarvmgQAKCRAk1otyXVSH
 0FVSB/9oxGazFsvlXdHLhoAUYTxZ7MgTCm6AnNbR8S3Bo1cSBe98pqQklokTY94QfIQnBhqvGWr
 /3mWeQYDvkAfp+T3M+8q4TLwGx32vcdnuoi+erCxlvZJfqBWHejyH+OWgOOj14iY0FgIS0j1pPm
 UFzArso7o4QCiLfjUvGo/lCDIjHttYH5rW8Uo7O4ywvswSROtO6XBg48Kz3qt7eETZntI8fXVwd
 ErW4oQkcClL1DjiS/z8BTIeTacrXw0Ih6jfAuQ+HYDsTl+5KzgS6oVGuXdqxG0UphC5S78HhZqd
 +csfIxak8Vgw5PJltY57mZz9H5ez1FLywLN3q8pUBMPIEzSz
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
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 31 ++++++++++++++++++-------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 3aa8886e8b70..43dd9506036c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -422,6 +422,7 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
 	u8 shift = ftr_bits->shift;
 	u64 mask = ftr_bits->mask;
 	u64 val, new_val, ftr;
+	bool match;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
@@ -434,7 +435,10 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
 
 	vcpu_set_reg(vcpu, reg, val);
 	new_val = vcpu_get_reg(vcpu, reg);
-	TEST_ASSERT_EQ(new_val, val);
+	match = new_val == val;
+	if (!match)
+		ksft_print_msg("%lx != %lx\n", new_val, val);
+	ksft_test_result(match, "%s valid write succeeded\n", ftr_bits->name);
 
 	return new_val;
 }
@@ -446,6 +450,7 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 	u64 mask = ftr_bits->mask;
 	u64 val, old_val, ftr;
 	int r;
+	bool match;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
@@ -458,11 +463,19 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
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
@@ -502,7 +515,11 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
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
@@ -514,8 +531,6 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 
 			test_reg_vals[idx] = test_reg_set_success(vcpu, reg,
 								  &ftr_bits[j]);
-
-			ksft_test_result_pass("%s\n", ftr_bits[j].name);
 		}
 	}
 }
@@ -882,7 +897,7 @@ int main(void)
 		ID_REG_RESET_UNCHANGED_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
-			test_cnt++;
+			test_cnt += 2;
 
 	ksft_set_plan(test_cnt);
 

-- 
2.47.3

