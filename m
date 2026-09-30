Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7204F53160C;
	Wed, 30 Sep 2026 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804977; cv=none; b=FDYSt5DagjQIR/GTE6cOHx5127B4l45C86qZnqo24l740CpFMditnlPD10rBt5RpOVye4lvl/G1SpbTRSBQwbnkQgsZO+uc4j+iqI1mVdcvYXW6qyDm1tGw0Slowv/UxAzsxuPIAv6V/aTH+wzo64kTlUbcu2e9jdTk+3KwMguk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804977; c=relaxed/simple;
	bh=72ACJI/cJk1wqzghWVp8GJhHfQXGaj1gc2q43XRzx90=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H/zaflNdvNa02pfP8C28818ge8t/DSVHiAJ6uklMMUWP7E4G30dR5s9uoBLtd67s5v1l8wlgzMnq7M2rv2AMvqcTJ40QZl+cABw23HXg8uyGcgX2MlcQdnLXHKj5oBJ5WLX7L3BNra4x4BAre6I2jaBh5J7TK9qQM1tqiTMwIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2pFgqxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2pFgqxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96771F00898;
	Wed, 30 Sep 2026 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804975;
	bh=NDDm+a34EvcRId8lWDE4aHYbVSzH6REPnYRckEl93Ck=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C2pFgqxrKa6EaED+HUjuk1CfGE7aanUWw7cRzx7JtgwVkd6AKu5IKzTK6W1DMZ9ty
	 BAMZCTPiCZKQIKGgoK8vcbm4f1KnD2CaJ27Cxqw/m/74pxgak++v4jHVJ9DCdn6LxE
	 aR5f9Jl15zV6yXkZONFKUcnQWX1qAeovLcMLrNJFMnuQHQCO0UgRe6H7AoJyz7Slcw
	 TYhHWV5oCbcjMnDsDy7mg4V9KO7HSMBqpH1rBTnHSEPDQTsLbsqv0xTbOUL2u9Yp6z
	 i1Rgo0FKUDM2N3nMl/lbNo9zWptd6gWTi4J78diwyTv/3Qd28SqvwrATb8aslnDS+5
	 z8CW7ZK2jzPCA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:21 +0100
Subject: [PATCH v21 11/15] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-11-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, 
 Thiago Jung Bauermann <thiago.bauermann@linaro.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2412; i=broonie@kernel.org;
 h=from:subject:message-id; bh=72ACJI/cJk1wqzghWVp8GJhHfQXGaj1gc2q43XRzx90=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO8zdfdjgisAjpwzhRQStgXuo4X2zVSo+4tL
 889ySYMMKmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DvAAKCRAk1otyXVSH
 0Kl4B/4yq1siA8k8JbouKK1Q3ZhTDAE1elUgMuFxC2MOs3Ql20vli7wPsgRftQ9LjpNZk3T2yN8
 umyuArJUwy620EfsG1E3kQjk4xtI0s8uDtQDu8jWf2BJ8uLQjvcCoTAm4gfJi/zf/OQ2KlF8pwq
 71nVllCsd6dXttzyHGpfDz1d4h72noQRYm629RLbIa3rhHl+0PWKh/1w9CHNwCGxJiYgeTQpz01
 RJ5D1zejGqMAp8LG+fz9Q+RaHgmjhYgqu/sqDINPKJNnM46vxnwi7J69+B3JP9cPOYp2bbZFm+x
 LO2wOYWGZaHz7Xib7aoA3KX3ksYSuvlBA1XHpP3JFYb+8iG0
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
index 533994687b5d..b895d2ba387d 100644
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
@@ -503,6 +509,9 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 3),	/* TCR2_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 5, 0),	/* GCSCR_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 5, 1),	/* GCSPR_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 5, 2),	/* GCSCRE0_EL1 */
 	ARM64_SYS_REG(3, 0, 5, 1, 0),	/* AFSR0_EL1 */
 	ARM64_SYS_REG(3, 0, 5, 1, 1),	/* AFSR1_EL1 */
 	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
@@ -519,6 +528,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 2, 5, 1),	/* GCSPR_EL0 */
 	ARM64_SYS_REG(3, 3, 10, 2, 4),	/* POR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
@@ -740,6 +750,8 @@ static __u64 el2_regs[] = {
 	SYS_REG(VTTBR_EL2),
 	SYS_REG(VTCR_EL2),
 	SYS_REG(VNCR_EL2),
+	SYS_REG(GCSCR_EL2),
+	SYS_REG(GCSPR_EL2),
 	SYS_REG(HDFGRTR2_EL2),
 	SYS_REG(HDFGWTR2_EL2),
 	SYS_REG(HFGRTR2_EL2),

-- 
2.47.3

