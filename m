Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36BE382F07;
	Mon,  3 Aug 2026 23:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798862; cv=none; b=qVgUZqPeTbIJQ4rY/ks7aHQn41oafkkYzu7vh7O/4HVPhCDOdCa3BQDyPxbuUg2IBXLkb+KsBduVGW4kR8sr4/CvT0Jyu5H7bC5mH3B1Tf4QU2KFYN3yMwFgUuIr0TRmMIpUFWqh8X+fIyAzatp2Jxab0159m5FPp/kh/EPmt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798862; c=relaxed/simple;
	bh=2xfMsfrPWEY4R10fqa4A/v2lxK8A8Oi+kaz7fCzAl/Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YFiDmwyOWAG1Y0ckAbCYEgto31YSmtSzBYDoNzl05FU0c/s9yfWSUfnNV1SWGYTi84weO8kN5KghqqXLwlzRlSSzs7770UOqo7U2APEK2vhV+fvP9ORrtNjJ8rnjco8FbuGX7QxW4xb6SUjx+Wts3Ur0aWZX+bWpncbdNIxm5qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AHAKRtz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AHAKRtz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FCA1F00A3D;
	Mon,  3 Aug 2026 23:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798857;
	bh=dJCqL2eqPlwjEMli5RhMxuoH1kWXulj7dYwiP95H9BM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AHAKRtz72OkQjQlbao/1hq6WwkRjhIDkecv8IOk6GnmrqBYluogRWKYDGVo89/kvi
	 DYMsu8ORMLnAWMo4L59wgOQ2n4hVqdRPAmFe+fdH7akrwftyalR1KGFiMyhAgblWbS
	 H6I1+2twLfqc0ndQK0Iap4oUUDa2ICQjaHmoggkfjzfW88zVf/A2mMfzgcmGixYKk8
	 wEOcw4YYbFHDMK+yfU9pVps/1D3eMJn4TTP6Tyko8iwPnvAS1EeQ2S0g+EJdY4Qx6L
	 IVCW9Z0Mm3qZPS0aA03GHPvsR6MQoGiIE40kXiOJ20fZl9W+XOpcZCn6D5FSIa3Y1/
	 6yomboabZB9Sw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:55 +0100
Subject: [PATCH v18 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-10-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2412; i=broonie@kernel.org;
 h=from:subject:message-id; bh=2xfMsfrPWEY4R10fqa4A/v2lxK8A8Oi+kaz7fCzAl/Q=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSChzLSD2uIWIY79NCmpHepWj8kzDtsZjG7FW
 Jd4i91i+jeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgoQAKCRAk1otyXVSH
 0FpgB/9dBSsBi60LjPJ9Ioa7XO1W+TCqZcUihB67UbvVDUFZGCoeNuffVkdZ35IDzGvGw+tw6tT
 /AAPrXDF7Um4PIYE6kok654XNc42+8uIiKPO7x/bNMsXZlNT2nhndy5w4OjK2Bk/9P7bQJEAfNB
 6z0eogmJzw/ZSsYWtb9mQZOOwm/RVzVI/1cYdtyanG7gDaCyOIcW6oMF+bYd74umSb0w2V2ezQE
 4Xlq+iH+lEGR535qi8LErbNLExY9qBxRbXcOLgkZuXWaGtgMAe/l8Vl8ncgVVm5LPNnyygcZi4q
 PDchyAzWhfDKCL0wPCY7nqmSCttiP8iPRF4IK1fkb0IPsF92
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

