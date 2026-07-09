Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61113AFD16;
	Thu,  9 Jul 2026 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558481; cv=none; b=Lhfrqv6d+bFf3lljyH4xFwoXlTVNMdc8jdUJUUhvPrLL+VerSZCf4MhEgvLehX2NNUzTzOn3zDltbWLqnJiyqY8HxNjFnuj4L4SnOt7mUwBAYzDYbjJWi2pYMnIKHKLE23pO4UpQY2R2FNtzhyox/J/MpqeUUBR9MAwSZv8ED3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558481; c=relaxed/simple;
	bh=I21JH58CR/AbSnYTHYyjog9l03x/hS5CLetpI7AAePU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CcvKm4pXcGjEoeawkLNQC9mB+e8ASVj9fkLMkeB2kF/lBqqw99Z1rxhege8I1uxPXok7e5vgqdR3isBEqCCbVfkCZB1hEjzZkD57VAj/ef1VxbQlRUbePWamEs8faefNQOYfdFWdK+skROB2VcR199IOKHDuAIE44wup9/VKru8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0UCo1w6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0UCo1w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7D11F00A3A;
	Thu,  9 Jul 2026 00:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558479;
	bh=xQPjYFjbIcAmw/vy47XjvylGbXgKpoMyOES+M/yVDZc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L0UCo1w66dIXkOmj6OlCnCaTk05u2WUS+CTky+Or6XMgVigQKTrcdFqnDz5BYWGRX
	 cq9C9ZbrvMz9WsbXNV4DDNaIQWRaQjl4xAuXazWLTORBKbk48eS+uTcRc7uIje8FDF
	 ggD2uG0YQUvKWvm0sjr1nzsiUO9y7CMp/KbFF6+hI2ENInsPUjvkENxjNyaYUBf8f9
	 rvdNvbOLM8spq/DVuHqAp83gXqDnMB0KAkJ1ul8hJa5/GnQQt8eNhePHvo1ndG+Dyn
	 C1PFW6oiSrLJZUPLtmVukBtxEd9AO2i1hw1WGFqJEcNAKJlAwJvhwA/SNEL+Do2cQ+
	 2IWnuTqKO9D6w==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:52:05 +0100
Subject: [PATCH v11 28/29] KVM: arm64: selftests: Add SME system registers
 to get-reg-list
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-28-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3018; i=broonie@kernel.org;
 h=from:subject:message-id; bh=I21JH58CR/AbSnYTHYyjog9l03x/hS5CLetpI7AAePU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDPT/5s3J64ZtgpksZ9CDujFzO33r82x9ClM
 JXlbXX5uZ6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wzwAKCRAk1otyXVSH
 0KiSB/0WxlPlFTpFT6ZEz0++tXb5lmXKQznm4eFEHXlEjnwLm2LcJb3q4zz/1puH2O4WUc0LhWF
 /HWyzeBBl3FK4MqlfkczK+4jTB7AlWIHBXhRXoNt5XUP8GAZm/Afc8g54DmEIhZTbnOTMapQKz+
 01EM360TrkzFRF0jgcjyJoXbiagmWDwgGqaKSgHsKM75wqkRZCTXFEnnGRkX+Z+j3beB2qdJ/K8
 PlhX9UE8dNitiu9iBmEIbYi9nRfMOjIt7BUp50e5rJw1darMrXhbrwRFHqcjG6sOp37St6zvRUP
 jbg43k6JIy8g84KTULXokFKC7xR5avPw7EjcnqCZ6MB1XR0N
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME adds a number of new system registers, update get-reg-list to check for
them based on the visibility of SME.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 0a3a94c4cca1..876c4719e2e2 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -61,7 +61,13 @@ static struct feature_id_reg feat_id_regs[] = {
 	REG_FEAT(HFGITR2_EL2,	ID_AA64MMFR0_EL1, FGT, FGT2),
 	REG_FEAT(HDFGRTR2_EL2,	ID_AA64MMFR0_EL1, FGT, FGT2),
 	REG_FEAT(HDFGWTR2_EL2,	ID_AA64MMFR0_EL1, FGT, FGT2),
-	REG_FEAT(ZCR_EL2,	ID_AA64PFR0_EL1, SVE, IMP),
+	REG_FEAT(SMCR_EL1,	ID_AA64PFR1_EL1, SME, IMP),
+	REG_FEAT(SMCR_EL2,	ID_AA64PFR1_EL1, SME, IMP),
+	REG_FEAT(SMIDR_EL1,	ID_AA64PFR1_EL1, SME, IMP),
+	REG_FEAT(SMPRI_EL1,	ID_AA64PFR1_EL1, SME, IMP),
+	REG_FEAT(SMPRIMAP_EL2,	ID_AA64PFR1_EL1, SME, IMP),
+	REG_FEAT(TPIDR2_EL0,	ID_AA64PFR1_EL1, SME, IMP),
+	REG_FEAT(SVCR,		ID_AA64PFR1_EL1, SME, IMP),
 	REG_FEAT(SCTLR2_EL1,	ID_AA64MMFR3_EL1, SCTLRX, IMP),
 	REG_FEAT(SCTLR2_EL2,	ID_AA64MMFR3_EL1, SCTLRX, IMP),
 	REG_FEAT(VDISR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
@@ -367,6 +373,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 0, 0, 0),	/* MIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 0, 6),	/* REVIDR_EL1 */
 	ARM64_SYS_REG(3, 1, 0, 0, 1),	/* CLIDR_EL1 */
+	ARM64_SYS_REG(3, 1, 0, 0, 6),	/* SMIDR_EL1 */
 	ARM64_SYS_REG(3, 1, 0, 0, 7),	/* AIDR_EL1 */
 	ARM64_SYS_REG(3, 3, 0, 0, 1),	/* CTR_EL0 */
 	ARM64_SYS_REG(2, 0, 0, 0, 4),
@@ -498,6 +505,8 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 1, 0, 1),	/* ACTLR_EL1 */
 	ARM64_SYS_REG(3, 0, 1, 0, 2),	/* CPACR_EL1 */
 	KVM_ARM64_SYS_REG(SYS_SCTLR2_EL1),
+	ARM64_SYS_REG(3, 0, 1, 2, 4),	/* SMPRI_EL1 */
+	ARM64_SYS_REG(3, 0, 1, 2, 6),	/* SMCR_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 0),	/* TTBR0_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
@@ -518,9 +527,11 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 4, 2, 2),	/* SVCR */
 	ARM64_SYS_REG(3, 3, 10, 2, 4),	/* POR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
+	ARM64_SYS_REG(3, 3, 13, 0, 5),	/* TPIDR2_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 1),	/* CNTPCT_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 2, 1),	/* CNTP_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 2, 2),	/* CNTP_CVAL_EL0 */
@@ -730,6 +741,8 @@ static __u64 el2_regs[] = {
 	SYS_REG(HFGITR_EL2),
 	SYS_REG(HACR_EL2),
 	SYS_REG(ZCR_EL2),
+	SYS_REG(SMPRIMAP_EL2),
+	SYS_REG(SMCR_EL2),
 	SYS_REG(HCRX_EL2),
 	SYS_REG(TTBR0_EL2),
 	SYS_REG(TTBR1_EL2),

-- 
2.47.3

