Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6563049F13E;
	Tue,  1 Sep 2026 18:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288638; cv=none; b=jCaksuBRQULIIWOwsrXnYQB+YiWnpSoAc3cy54tVPxHU7KKDlsSF0jRwgHHLHxlRcKbCLotsappJAsOLyjInLOsXeIrpWGykpIO96D1k2D9rLNDyVBqptt7ICNA861l5GVFaSluryBbShJwAJ/irXFlT+V9o0pg5ce4Hw0XuhNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288638; c=relaxed/simple;
	bh=DK8u6eI1AOLX9khBmbKeOjy8kwTjeZcin0pkZ329WfM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V+8IrzyniHfLPeyCrX6qWF6hcav8x5Y74Xu8qdZKAmZS4sW45+TdUivmQXSSNqOrKwd5ZOCks5ypxa5Ior3f/I7lthQkodG9Br+04sDPANYWF9fuPxXGQua2+pEBBUkXcYDJsi4qMGqka4KR/tEUi4TswVAZVG6I36lMyXIlZKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDlvA4dG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDlvA4dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65B11F00A3A;
	Tue,  1 Sep 2026 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288637;
	bh=OQ9SblTR7KigLdZW5ofDTAUXhaHQsNkXQ2cHNbZ5LSc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cDlvA4dGAtxLOMJpzFhaaMwO3SBy9e00KvGHUsjkIHyz6fcJ6qA3n1Eg9/KFSJzYL
	 xlP2FH868/AGwxW+qEWUUIXdzkEmZE1BUoP27ctyNlcBpWyFc+OwS6iuPIC94JGnSy
	 xq+HrgMdL/dnNXJQsjBtTORBG+u59mZNe7YwstaOkatLgdAsSjc6niFq0OlZgLEyLB
	 Ga5jMEqKztl/7EymkWYWWI9mjJA7QLWDCHc5XyfZtQdD54KTavkVyx1HC5mx6aoKc2
	 DF5yIIqfgR+RYfGy79Zb+c34ENkuCNO50N7YM+NkRGPDRvZYO0QvhdDGTP/yTWTGuR
	 WCSOOQXmp03QQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 19:50:03 +0100
Subject: [PATCH v7 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validatity checks non-fatal
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-kvm-arm64-set-id-regs-aarch64-v7-3-7b065b0bda9a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3509; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DK8u6eI1AOLX9khBmbKeOjy8kwTjeZcin0pkZ329WfM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqlx5vFfA5TBXqZTm9RESQKPkEYmGomOK7bKpCu
 yoX5NxuPw6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapcebwAKCRAk1otyXVSH
 0K3jB/wKdc9NLJQNkeJMnA76qdaC3faq9RLbaUAB3f8p0lQBC07Qnf8x0PeGgZdnF8z9o3dRYor
 R1HLih7WtdM0rqktJBXnXnsHCT2iWhooJhBWu/EG9tCWAA8kXgjf2vspNmt6mkx69KWB8V7f4Y2
 pv3uu4+hGTo8IurIMwMp/T/ovEPjPFJOwNn6cbeG6y3qPy7d6nS4hiB59YMCd1ZELmDHUYwqdIE
 Wf+n0J2XwS9x55F/RXxyFw4id4gYrIKoyo4MjZPfiFTV3ENHig6AcmYRBHJ7hrT5u1/dQh1XPzC
 J2fy5pQnWTW4nIX+mLzG7eLkBgwp6l0L6oKNFjybl/LnzDEn
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently when set_id_regs encounters a problem checking validation of
writes to feature registers it uses an immediately fatal assert to report
the problem. This is not idiomatic for kselftest, and it is also not great
for usability. The affected bitfield is not clearly reported and further
tests do not have their results reported.

Switch to using standard kselftest result reporting for the two asserts
we do, these are non-fatal asserts so allow the program to continue and the
test names include the affected field.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 3aa8886e8b70..385e1f1c0133 100644
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
@@ -462,7 +467,10 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 		    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
 
 	val = vcpu_get_reg(vcpu, reg);
-	TEST_ASSERT_EQ(val, old_val);
+	match = val == old_val;
+	if (!match)
+		ksft_print_msg("%lx != %lx\n", val, old_val);
+	ksft_test_result(match, "%s invalid write rejected\n", ftr_bits->name);
 }
 
 static u64 test_reg_vals[KVM_ARM_FEATURE_ID_RANGE_SIZE];
@@ -502,7 +510,11 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
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
@@ -514,8 +526,6 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 
 			test_reg_vals[idx] = test_reg_set_success(vcpu, reg,
 								  &ftr_bits[j]);
-
-			ksft_test_result_pass("%s\n", ftr_bits[j].name);
 		}
 	}
 }
@@ -882,7 +892,7 @@ int main(void)
 		ID_REG_RESET_UNCHANGED_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
-			test_cnt++;
+			test_cnt += 2;
 
 	ksft_set_plan(test_cnt);
 

-- 
2.47.3

