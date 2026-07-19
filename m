Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8493019BA;
	Sun, 19 Jul 2026 19:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784489273; cv=none; b=N2DozKXGwPkxLVG1uh/LJ05mVXEJqlXVh0/JUOgkkGbud7Bpi7lgdnu8PtV4Te4X40PNO3JQCocTwFJH0iBUTQO2jloAFkqZLzSgih/QcQGDHGakq1H31c1HgRrj6VNLC/Z8FxOdj/eLuBhJHU6EBqrzk/oGRtNW2fbCKwGIQ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784489273; c=relaxed/simple;
	bh=DK8u6eI1AOLX9khBmbKeOjy8kwTjeZcin0pkZ329WfM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iH0aQCi6XTEre16hmQq49mdFOYzClkR56QGfKGIh80W29ty+/oX6UFNzYHappaedJQAATeU4cBc8blCuMlUGyJDn8eOI5RnJwXCqsbw1aEqfweWTdbIuO6O2ocVkxMkKK96KrEhX30v39j0ocuwtgnC0IUIDm7j88GjABlFepgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pr8H2VLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pr8H2VLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9276B1F00A3A;
	Sun, 19 Jul 2026 19:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784489270;
	bh=OQ9SblTR7KigLdZW5ofDTAUXhaHQsNkXQ2cHNbZ5LSc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pr8H2VLCwW41lfa5NTejqUGUZlXiHZmblOSZV3DEkm+OFVpcJQ+W7IKtmKBfVgH6P
	 08fSNlJH41MWhRCV5jVTR0Kex56nQ8P4aoFnG8ebBqpuTAO+H9Mz8gt/nZ8RjS2TZW
	 ZIpa+6OxUUUCEFcdJ5xhjPAgARGA+uHMDYZcDw7Oe0EjBzYF/O/YcE7A2wJVtUc2yJ
	 MIWcqq85K9KpR6S8E1YLeewWL3Lz0N9C88NerDfLIQZ79hEeYSaGyN1ZmnCBj7ELkr
	 Qn01bhKrT1s3c8UdKue/3xRtVdEPEPARXBMRqiCOxfn9uY36tnHq8jUxCiWAVIrLcR
	 dXdbeF51LDfpg==
From: Mark Brown <broonie@kernel.org>
Date: Sun, 19 Jul 2026 20:24:42 +0100
Subject: [PATCH v6 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validatity checks non-fatal
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260719-kvm-arm64-set-id-regs-aarch64-v6-3-724287f5f108@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3509; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DK8u6eI1AOLX9khBmbKeOjy8kwTjeZcin0pkZ329WfM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXSUrpJq3vjSVtOaSeroeYgbbuyrVgFNCYdsju
 NhNlusit5GJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal0lKwAKCRAk1otyXVSH
 0GrOB/oC9jMowK2A16z7DlHP0OzNMjMvEpjKNVRF6rNJoGOPSbzXeXIp3KrMh5tVZ0kXmEyMKfr
 92T7FwEzvzApE0/mxX2vXrAQbQsJa0ZEcaGfr0HHKbo6EJvikD92ditRFFIevn+HvsMJRq2I0b4
 T9HmPWaHacqN5/qYGzhx4HuTUwvANVsxAW4C0rYV39iCme43GAP6Ww2/KrypK+Ms6g3N/eEhWQJ
 2Z5ZeQki+yAZUQ7u65Ci69OiGfo8SUldtcTclSXtxlcFm5S2sDB2k7TmsD8J87t3/DSrohcEULS
 paVV1Vwwy/dxlYjna6/hyhlvZ56OFFlJoKmMlMmqi5G/i8Y9
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

