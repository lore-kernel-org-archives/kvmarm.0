Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489F6367293;
	Wed, 12 Aug 2026 19:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562029; cv=none; b=dbQPPL1Q7c4oZwR62zFS7ZXWMx5yZwh7kzHPzYFwk7r+GPK/Uyx72PWlD6Je230kGGnLvFHsGX/fQbSN3na9jrKc5lNh965jdYXI4nFgyn/59URPO/BhGs/RQ5QUhNR8iW4gREVVNTy6f1pbAYfbZ6oB7j1XMwpNdO3ynAgY9EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562029; c=relaxed/simple;
	bh=2xfMsfrPWEY4R10fqa4A/v2lxK8A8Oi+kaz7fCzAl/Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=biPTKA/WRrTWqIW6eoMKbWOeJyNp8tYLBzPfYhozOfuZMZfcmVcLcaAjmKnk8FOf7a5SjLuxNq8Mvz1aly6PVbN6XR9TVCmd0lS04L1zyGrCpRuKGQVVd9US5VXJYt/IG6APX+dimg2+XIMRNX7l+RnPhJSaFHosnNlwWWdGTpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecdw4OkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecdw4OkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209901F00A3A;
	Wed, 12 Aug 2026 19:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562028;
	bh=dJCqL2eqPlwjEMli5RhMxuoH1kWXulj7dYwiP95H9BM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ecdw4OkBOeCHij6iG2DkQh9bagoXi8J4LH2Ex4XeaJL+Q8PccCpn74DFrJ8bMf1SX
	 fdEpLhUKrrnol4dZJc9OqKLCAXsFaMfsjHl57AFBp+H9fn9CXtd7NjwAvP6CtJkvH5
	 E0pbf2PWGFgEmw2zE4LV3mtT+ET9MM29AnTH7SX7GyPWog1eCemhzWpECJxs2SzlnV
	 Fi+Mzf/XFNxFFyYzeqOd55wdCjb6e4gE4XzLsUbWUGw1bYE/4Km1XfI0OSW+ZlbFkq
	 17kv0likF47IRIYSencLdHJa+2oNknHZcPGH8HAWtVI3sMmgGcwRx/lmiTCLb5ftfm
	 CUOMDdxxYka1Q==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:09 +0100
Subject: [PATCH v19 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-10-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, 
 Thiago Jung Bauermann <thiago.bauermann@linaro.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2412; i=broonie@kernel.org;
 h=from:subject:message-id; bh=2xfMsfrPWEY4R10fqa4A/v2lxK8A8Oi+kaz7fCzAl/Q=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMXCjy4Isd7wifcakR/Fz5oXRGAlMdWNtY9Nh
 HcW8FMdHQyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFwgAKCRAk1otyXVSH
 0AkVB/44s/eVk+dQKxM5c8hN6Axcf0UdTHcybX6F6PGvXiGJwuwarIbBtOF7yu3yclgqERAjVW7
 xVuCjS1cIOXhfP0jsnB+eUMyTkty3N2je7pD0tR3Th+QpaMGXVHuhFPtOJGBFOD+q4sDHRANuCp
 D+YqsnIZdmpvuS5ljmdxdDL0ztGAtgHpON6n/QEVn8znK9ZHLYurtg/2SsTtkwhWOnJTXS0rav3
 /3fuArkfUQZE0RdkVQPJiZTFqBze5dNFXEuljBgknyCpqN/OY+mq718Ger4/wH60iZoRFKjp0hU
 0W3p89lC95g5r4CWMfpy3B5YvhAA0gzxcc1puH61z1g1O0bB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

GCS adds new registers GCSCR_ELx, GCSCRE0_EL1 and GCSPR_ELx. Add
these to those validated by get-reg-list.

Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 0a3a94c4cca1..6a93136d153f 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -42,6 +42,12 @@ struct feature_id_reg {
 static struct feature_id_reg feat_id_regs[] = {
 	REG_FEAT(TCR2_EL1,	ID_AA64MMFR3_EL1, TCRX, IMP),
 	REG_FEAT(TCR2_EL2,	ID_AA64MMFR3_EL1, TCRX, IMP),
+	REG_FEAT(GCSPR_EL0,	ID_AA64PFR1_EL1, GCS, IMP),
+	REG_FEAT(GCSPR_EL1,	ID_AA64PFR1_EL1, GCS, IMP),
+	REG_FEAT(GCSPR_EL2,	ID_AA64PFR1_EL1, GCS, IMP),
+	REG_FEAT(GCSCRE0_EL1,	ID_AA64PFR1_EL1, GCS, IMP),
+	REG_FEAT(GCSCR_EL1,	ID_AA64PFR1_EL1, GCS, IMP),
+	REG_FEAT(GCSCR_EL2,	ID_AA64PFR1_EL1, GCS, IMP),
 	REG_FEAT(PIRE0_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
 	REG_FEAT(PIRE0_EL2,	ID_AA64MMFR3_EL1, S1PIE, IMP),
 	REG_FEAT(PIR_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
@@ -502,6 +508,9 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 3),	/* TCR2_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 5, 0),	/* GCSCR_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 5, 1),	/* GCSPR_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 5, 2),	/* GCSCRE0_EL1 */
 	ARM64_SYS_REG(3, 0, 5, 1, 0),	/* AFSR0_EL1 */
 	ARM64_SYS_REG(3, 0, 5, 1, 1),	/* AFSR1_EL1 */
 	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
@@ -518,6 +527,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 2, 5, 1),	/* GCSPR_EL0 */
 	ARM64_SYS_REG(3, 3, 10, 2, 4),	/* POR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
@@ -738,6 +748,8 @@ static __u64 el2_regs[] = {
 	SYS_REG(VTTBR_EL2),
 	SYS_REG(VTCR_EL2),
 	SYS_REG(VNCR_EL2),
+	SYS_REG(GCSPR_EL2),
+	SYS_REG(GCSCR_EL2),
 	SYS_REG(HDFGRTR2_EL2),
 	SYS_REG(HDFGWTR2_EL2),
 	SYS_REG(HFGRTR2_EL2),

-- 
2.47.3

