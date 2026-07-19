Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF786384CE1;
	Sun, 19 Jul 2026 23:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502729; cv=none; b=rk8Pz364iHUNxgeXpuwcfBvdUqS82KNUv3cSTELzy36E2lZoe7rgnvUJ/2BAMfna3ZPhENUa8sAGmDFFeB/HSmsFy87ab6x9lGEIsW5fjWwcLVZw3OJ5Qh7Gj4bJAeNzxcLb5ax2VYn6DWYzbW9hk+jaITR1yADu7jbGP7ePoBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502729; c=relaxed/simple;
	bh=DoSXFT1XFLMt5bL77ymD5uWM5fFd8Skxma7c37DB6O8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mJ54TH7Zblw+H0s2KloU81+5zymNVLHnuELpaCuOS3e5YmqbrBItM7TdalrvG2Onfxe0SPy2wgVIc7k7C9nHzfLu3+t1/EWjKzaSP68EKFrw0vuOcUTwbEjUqaxqvxHpQiTYSjcTm/WVoqccWGsKKBCqn66dmX0hvnkFlQGjOBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHItgEX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHItgEX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2801F000E9;
	Sun, 19 Jul 2026 23:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502727;
	bh=k6q2RcAVUcHJXSDerZte/wZkUxNLtsu6zF4B+0lVk2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VHItgEX6/YP2Ozy/roLHwG3vf3bR69hSpR1DUlRiB81FP7Gbm5ey4b6DhDJpNcmbr
	 TLk5dNTHYuEsw/0fZpNl6QDoGh0z6zUmlT2JJ20h9vCoDigNdDagYZRKqzlU+GhfcI
	 8x+uCcb2Yee4Y+quz/okcIyNoRuyDN03TYOrq7gZ/qiaGxgUmF4CJdXYpyPSwWLtwo
	 RAWgc4xkrEMp0j1KaL6F6nMMfNVbZ4/OzqIsSyrncER7wNtWkEq4zxMlyFocVDd/Uh
	 tJzgtloC8ctgNyMqkAGCgGSigPKJI7CiHVY6BI+CBHPZfp4LeuGF93jZsoPcP1XtPH
	 dVUKaBcSFMvuA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:57 +0100
Subject: [PATCH v13 30/32] KVM: arm64: selftests: Skip impossible invalid
 value tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-30-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3690; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DoSXFT1XFLMt5bL77ymD5uWM5fFd8Skxma7c37DB6O8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk+ePDwSiD4VpzeYE3Id9Rc+zhBWemm3WIxc
 k5BrRZvK1yJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZPgAKCRAk1otyXVSH
 0AdJB/wP/giklcwigwFEGFkW6wN64uXabgyc3gw+Vbq+QvoRCYFBOd/fUghgQKbm155Ze2D8KyK
 MnBusZQAzlKmg/sFstsLmakD/2vTWZOLjLblcx9dLnzlHoi/bCS8ynS0DYHu5RcDwdvT8sIs/Vg
 xzXqk3GCIdWl7L/Fe4ApJK65MYGRjFa91uJfHf+6EzuiGfEXhXZykSweG9xQe+qcFUzcPKe0E2t
 lJtfSUcnd5gbPzM5M4sxvdHL030+dol1TIi2qtt9C/QXkaWC1QuPZANzx57gIZ2Z1HB4EfEHSNr
 w5R5Www7gZwUifp6pFf1/H2RfcdcPriBjttYHs2MerjIUzVC
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The set_id_regs test currently assumes that there will always be invalid
values available in bitfields for it to generate but this may not be the
case if the architecture has defined meanings for every possible value for
the bitfield. An assert added in commit bf09ee918053e ("KVM: arm64:
selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user") refuses to
run for single bit fields which will show the issue most readily but there
is no reason wider ones can't show the same issue.

Rework the tests for invalid value to check if an invalid value can be
generated and skip the test if not, removing the assert.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 64 +++++++++++++++++++++----
 1 file changed, 54 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 9eceac84e297..da9349bf31ab 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -327,54 +327,95 @@ u64 get_safe_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 }
 
 /* Return an invalid value to a given ftr_bits an ftr value */
-u64 get_invalid_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
+u64 get_invalid_value(const struct reg_ftr_bits *ftr_bits, u64 ftr, bool *skip)
 {
 	u64 ftr_max = ftr_bits->mask >> ftr_bits->shift;
 
-	TEST_ASSERT(ftr_max > 1, "This test doesn't support single bit features");
+	*skip = false;
 
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = max((u64)ftr_bits->safe_val + 1, ftr + 1);
+			if (ftr >= ftr_max)
+				*skip = true;
 			break;
 		case FTR_LOWER_SAFE:
+			if (ftr == ftr_max)
+				*skip = true;
 			ftr++;
 			break;
 		case FTR_HIGHER_SAFE:
+			if (ftr == 0)
+				*skip = true;
 			ftr--;
 			break;
 		case FTR_HIGHER_OR_ZERO_SAFE:
-			if (ftr == 0)
+			switch (ftr) {
+			case 0:
 				ftr = ftr_max;
-			else
+				break;
+			case 1:
+				*skip = true;
+				break;
+			default:
 				ftr--;
+				break;
+			}
 			break;
 		default:
+			*skip = true;
 			break;
 		}
 	} else if (ftr != ftr_max) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = max((u64)ftr_bits->safe_val + 1, ftr + 1);
+			if (ftr >= ftr_max)
+				*skip = true;
 			break;
 		case FTR_LOWER_SAFE:
 			ftr++;
 			break;
 		case FTR_HIGHER_SAFE:
-			ftr--;
+			/* FIXME: "need to check for the actual highest." */
+			if (ftr == 0 || ftr == ftr_max)
+				*skip = true;
+			else
+				ftr--;
 			break;
 		case FTR_HIGHER_OR_ZERO_SAFE:
-			if (ftr == 0)
-				ftr = ftr_max - 1;
-			else
+			switch (ftr) {
+			case 0:
+				if (ftr_max > 1)
+					ftr = ftr_max - 1;
+				else
+					*skip = true;
+				break;
+			case 1:
+				*skip = true;
+				break;
+			default:
 				ftr--;
+				break;
+			}
 			break;
 		default:
+			*skip = true;
 			break;
 		}
 	} else {
-		ftr = 0;
+		switch (ftr_bits->type) {
+		case FTR_LOWER_SAFE:
+			if (ftr == 0)
+				*skip = true;
+			else
+				ftr = 0;
+			break;
+		default:
+			*skip = true;
+			break;
+		}
 	}
 
 	return ftr;
@@ -409,12 +450,15 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 	u8 shift = ftr_bits->shift;
 	u64 mask = ftr_bits->mask;
 	u64 val, old_val, ftr;
+	bool skip;
 	int r;
 
 	val = vcpu_get_reg(vcpu, reg);
 	ftr = (val & mask) >> shift;
 
-	ftr = get_invalid_value(ftr_bits, ftr);
+	ftr = get_invalid_value(ftr_bits, ftr, &skip);
+	if (skip)
+		return;
 
 	old_val = val;
 	ftr <<= shift;

-- 
2.47.3

