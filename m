Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F55842BEA3;
	Fri, 31 Jul 2026 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501485; cv=none; b=YdsaZXZ15EIZumB2re/TwMwZj3A293UNAo6diI06bGf9dpgR0ipsizSXzdNl/L+q+bYKL08RB7NVAyj6QdnJvG2noK3voadeaOR1xSQ+9ssOI72HqSZOehsMHYO6nH/BZ8Hus1X/DzOMGDTdA21RgRtFe/DjbQ7L2797xgy6VRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501485; c=relaxed/simple;
	bh=x/NyWOEjcB/F6JMOnzCDYHGfRJ2QUgSpQz1YI/6NIkY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OrriGHelWeTqHfIWvzAHLGlZXSOJGX9alLDFfuQcthRIvyMZxoBNg0VPVI8sswFHc4W/OC3y+kVw5rjc4l+xlN8joAfuZUxqn+VHnAgP5k1zWQNpmo0QWtcX6lQsCEYcKoQQSqIQ5wuC5yTfW8xlYxgZE13++4/KLlmKaxcB42g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWEUiTAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWEUiTAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36891F00A3A;
	Fri, 31 Jul 2026 12:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501482;
	bh=Zs8h/ZlYcgiMps09bsMhKzLrZXzp5ZWhzxMXQNOv8Lc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FWEUiTAP0lmVexbyGg6FFweNhvYIU6uAJeQenVTXAdqbBGl3bYBW0/yFR/Me+K619
	 jB8bwi/C9fGUrBdYI6urMsaeFwy+vUft80eGGrBkToKJnID8EGYU7RIa3eWlNaFuEZ
	 sbNNs6JDNippWD+psBV8KP8Fd7BkKVgpfuDtgQidj8TF4OV4W8Q471bN5M/c5LHoQq
	 tOES0fjHrESzNVOXdoDYuz2V3CV8rDEcAvKvAtbXZrtRQwJT/eTxwl2GxRjYKqpBDH
	 HXDREe9V23m/A1CGgzhmzRtxJ2FhhOV1BG0p251s318pSMdtdfeE/SmVY2Hv/stu+6
	 oR7khKp+wrpaQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:48 +0100
Subject: [PATCH v17 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-10-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Thiago Jung Bauermann <thiago.bauermann@linaro.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2406; i=broonie@kernel.org;
 h=from:subject:message-id; bh=x/NyWOEjcB/F6JMOnzCDYHGfRJ2QUgSpQz1YI/6NIkY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJcDsHuk50tntRYM5p8Lt3OB3bbr1vfWD+as+
 D7h6WxOuduJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyXAwAKCRAk1otyXVSH
 0JNQB/47FMvE4dhAzhw2vrOqEXN97l1FVErCz+sK7v2m0uDFKluRmIDYIk2dSQHX52aRCQFq0eR
 tdrYKEhwgkIqGnajX//xKSqSV8RXA8bBiaz3HgNd2sefX9jNRpc8X74oS2oEcBG5NAI32gAiexW
 vQEuUpxAPY0FYvKiwItIg4LblAXLo6zOKi4b8Q6Wdhpl0oYCN1mVQkjSc2LiDh8RAurU4i2rY+t
 dfw6XCa5nphDZSnkTU8+b0gfvKpnfAyOZZ8nGVVWoMQl8yWG6Q3ZZZygL/ZYYjgKq/YVKSsyTFx
 uTIFkSKrW4TcVsecH9763Y8Z6LaXwwl7PhJ/U+D5yuTYw2ll
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
index 0a3a94c4cca1..774a3aa6f096 100644
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
@@ -757,6 +767,8 @@ static __u64 el2_regs[] = {
 	SYS_REG(PIRE0_EL2),
 	SYS_REG(PIR_EL2),
 	SYS_REG(POR_EL2),
+	SYS_REG(GCSPR_EL2),
+	SYS_REG(GCSCR_EL2),
 	SYS_REG(AMAIR_EL2),
 	SYS_REG(VBAR_EL2),
 	SYS_REG(CONTEXTIDR_EL2),

-- 
2.47.3

