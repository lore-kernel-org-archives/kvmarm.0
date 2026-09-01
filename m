Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4927D39A4B3;
	Tue,  1 Sep 2026 21:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299474; cv=none; b=nPY+liTgqyOw2hIveLO4Pybsk1F/6SAmIRkxQkxsnWNbcmUGeK+ExTVogJKbnS8cKx+v1aZoNqFZ6aoVaRlzn0T9JM1GIZN2KrPl25CUKrWJeWWiGfjqO7OkWyO6X+OiZ3cR1Z6NxG/RZFTGgI3B8RIeUJJwUKHamkvHXjQLn/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299474; c=relaxed/simple;
	bh=xg1pj0+0KbUi3OkikMffllT1hzgPv//XZnVR7ZYSlfM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XXjlH8b9K3Vr1HdxHrdNhjShCxCJzk7cVfn4MGE2oSutd2BUrYCF7flruFuy1GS8weL9CS+fOnt+OCoYfVKaPqR9OYOPK+0LTsn1xC5nv8TJdQWC7Ej6Jx1qRqjpl+hKZ+o44TnVJ6TTRkqFEO5FWdaLj2MQvMCa/96i3gL6ErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqQPdV4Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqQPdV4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B87E1F000E9;
	Tue,  1 Sep 2026 21:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299472;
	bh=bWXcOIpJt0ovJU16FmG1ZP6mcgZr3j3D33y4oNpUlCk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dqQPdV4QMg72eA3iW8tJJRqLOIA3F5BlZLW8dD7q2dPiYVDJSr359F5NR7j9vFmVK
	 Mon/0Z7P6jlrpCzz57D+uRnz17CO7t9tUixggeqoFi9iTrpZVsdOCllWeWffL5P2Ag
	 zT9PxufQBtqGq8pFC2mmiqZZk2XQ+Lo1DniFYpMwCdgxHrbVrYdhWFD9XCF5/KA3sb
	 t/+EUNtjlm4NxkQ+TlLOSVgUbAmYeeuGgqKEm38P8dBr9mnR4h4QlPS2wuWaA/O6vr
	 sgs0fT4pD/srWe/TfPBaFkI6Jy5RfyZHHsYg9XfkiUqFy4SG9RmPqmf4W8etOqcQg0
	 xiZ6R3NdXTo0w==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:47:08 +0100
Subject: [PATCH v20 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-10-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
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
 h=from:subject:message-id; bh=xg1pj0+0KbUi3OkikMffllT1hzgPv//XZnVR7ZYSlfM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0ikrF8qYlqNzoV4imfln/ELsFLZ1ykMLSIE4
 /+fOyDllMyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdIpAAKCRAk1otyXVSH
 0JrCB/9O6BHtHIZ3KZPo6pGnkjDz4YRHxA3MD7UGXtBSYcGJjGcJUACQ47c+uH3kQ3awMogdvcx
 5+UI+3m3pCYcWqfTgRVLDrEIPK+jYxUujMZ2uKoylHw5P3eHxB1F0CsdXRet7bPkTQynABylSnU
 gvvl/zH7Nh9Q+kGPXEwPfx7dKflhY6IyyKB1uQqKKoOD4PtVcDK3GE2XoktOtpQ3keY9+v+ch23
 9m0qx3MaIPD64YXK1g70TJ1FoqaTrToFlt2r8ETrGp3pahKQmbtlQ/6nhtxzD9b/BkxUVUNEPPW
 3R1vJR68Kj1fbfR+TJb2Wck5I8NlysmJChEfo6RdGZa0TCkU
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
index 533994687b5d..5c1469153b6c 100644
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
+	SYS_REG(GCSPR_EL2),
+	SYS_REG(GCSCR_EL2),
 	SYS_REG(HDFGRTR2_EL2),
 	SYS_REG(HDFGWTR2_EL2),
 	SYS_REG(HFGRTR2_EL2),

-- 
2.47.3

