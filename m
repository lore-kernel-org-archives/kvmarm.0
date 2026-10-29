Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313457;
	b=bS4XWwsITuzAJbmrTZoJV2ZbhorDipJM1et4ioVKwudB9QJXJccLWyXR3Lm/kdoSjqv3
	 toCr9Nj9FeAsk+TQuVsL4FcjPRPgfgSU6uzE05mjKQb5DaA6Wwi5O44uamtbkSYMxo9+x
	 Fj7jJ4gZ3ZB9H7Mo6N3jAradMcDtXFch6XgzewdIkSWILdxjyIFC8/n5tTSEYb37ybPDs
	 qm+jgdh/z3oYCFEt+ZoNN4ryeTfKXUPWPmrZkQb7p1/W4xn5u1i9pda4ZsQT51GVx4kLP
	 Drxcq3g4S5pwDgc+aQbXZOsRW+HEbmKL0pLSry29310ItiFIGmAT8XQHTYxY7+tjPJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=t4VxUKWdjyAZ56gQcFN8Wg+vwesecc6bI/bBELf0GNU=;
	b=VK88+Dxm3bxMvSsaehW2zJZh56e+5LkmCP3+O+vySo3FYgg2Na8ZLReHNyBdUOGFi7wb
	 6K1xzjmtSZurs+5+0CeQRjyxWkz6oznNoSJu5LvBAW7dHA8eaLpGJA8s7b7zm42h7EZZJ
	 /G54ovebX3Kie4dDWilKdgKFiRBfH4qXSJaLbX6vw/NtFe3ZzFd41HiuxW4Dq2g+0RXcm
	 0/WzVdiAfkawkJAsxpXrOgBR3w+eTOJTnqysU0XCCwfiHWgchLlrqqftC/chY2nsDT6VJ
	 rXarTVIHtUZ2c5X4u+sfyYU4/P4ioR9XW8ryIcWb5tXb8ijjb8pmi8Kbwgi2CdQY43w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EHEskEYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8C1606A338
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EHEskEYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4BC1F031EE;
	Thu, 29 Oct 2026 22:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793313456;
	bh=t4VxUKWdjyAZ56gQcFN8Wg+vwesecc6bI/bBELf0GNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHEskEYxCdF2VxO87drr9wMcRoE8DZQQbBGmRnVWEMylVGp/lQZGRkf6C5nyCSkld
	 9GTCZJH1t45fFBvqhC2OAjcWtXPkCC8dcA2u9EfupBAKeZKGt+te7sYbAw9t+QAo0k
	 6n3ooB76SYzA+75519EJrWRVGhh8qporeQN3rNW2DVFOiDe8eaPReNhNIaMTJ4lppn
	 QcOxZ/O38WoMqsS7NJvYDlLwIVTM5QPtY8wRz477L8FmpUM2VUmQl9xYK9JAPxnQcd
	 WgMdeb73vZ6kUtvaP1Bb8nf9qeu1UVq65f225r3xx2ikk8aCJxTG0e6zhfe14WlTjO
	 fjxB52zWKzvsA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 4/5] KVM: arm64: Convert TCR_EL2 to config-driven sanitisation
Date: Thu, 29 Oct 2026 15:37:31 -0700
Message-ID: <20261029223732.103785-5-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029223732.103785-1-oupton@kernel.org>
References: <20261029223732.103785-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wei-Lin Chang <weilin.chang@arm.com>

Feature dependencies of the fields in TCR_EL2 are extracted from
Registers.json of the BSD licenced AARCHMRS
(AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).

Places where we slightly deviate from the above:

 - Stick to the ARM ARM M.c requirement for TCR_EL2.TCMA*, which only
   depends on FEAT_MTE2. This avoids updating ID_AA64PFR2_EL1 with new
   VMTE* definitions that we don't know the meaning of, as they aren't
   present in the ARM ARM yet.

 - Ignore TCR_EL2.DS's requirement of needing the effective value of
   TCR2_EL2.D128 be 0. This requires runtime detection of TCR2_EL2.D128
   and we don't have D128 support yet.

 - TCR_EL2.AS is dependent on FEAT_ASID16, this information is missing
   from the json.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   2 +-
 arch/arm64/kvm/config.c           | 112 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c           |   4 ++
 3 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 95de3dd23fa1..eda8bfcc5eaa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -598,7 +598,6 @@ enum vcpu_sysreg {
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
-	TCR_EL2,	/* Translation Control Register (EL2) */
 	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
 	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
 	POR_EL2,	/* Permission Overlay Register 2 (EL2) */
@@ -623,6 +622,7 @@ enum vcpu_sysreg {
 	/* Anything from this can be RES0/RES1 sanitised */
 	MARKER(__SANITISED_REG_START__),
 	SCTLR_EL2,	/* System Control Register (EL2) */
+	TCR_EL2,	/* Translation Control Register (EL2) */
 	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
 	SCTLR2_EL2,	/* System Control Register 2 (EL2) */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index cfdb6c713320..31ceac9f271a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -219,7 +219,9 @@ struct reg_feat_map_desc {
 #define FEAT_CPA2		ID_AA64ISAR3_EL1, CPA, CPA2
 #define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
+#define FEAT_HAF		ID_AA64MMFR1_EL1, HAFDBS, AF
 #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
+#define FEAT_HAFDBS		ID_AA64MMFR1_EL1, HAFDBS, DBM
 #define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
 #define FEAT_HPDS		ID_AA64MMFR1_EL1, HPDS, IMP
 #define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
@@ -232,6 +234,10 @@ struct reg_feat_map_desc {
 #define FEAT_MixedEndEL0	ID_AA64MMFR0_EL1, BIGENDEL0, IMP
 #define FEAT_MTE_ASYNC		ID_AA64PFR1_EL1, MTE_frac, ASYNC
 #define FEAT_MTE_STORE_ONLY	ID_AA64PFR2_EL1, MTESTOREONLY, IMP
+#define FEAT_MTE_CANONICAL_TAGS	ID_AA64PFR1_EL1, MTEX, MTE4
+#define FEAT_MTE_NO_ADDRESS_TAGS	ID_AA64PFR1_EL1, MTEX, MTE4
+#define FEAT_E0PD		ID_AA64MMFR2_EL1, E0PD, IMP
+#define FEAT_SVE		ID_AA64PFR0_EL1, SVE, IMP
 #define FEAT_PAN		ID_AA64MMFR1_EL1, PAN, IMP
 #define FEAT_PAN3		ID_AA64MMFR1_EL1, PAN, PAN3
 #define FEAT_SSBS		ID_AA64PFR1_EL1, SSBS, IMP
@@ -244,6 +250,19 @@ struct reg_feat_map_desc {
 #define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
 #define FEAT_NV3		ID_AA64MMFR4_EL1, NV_frac, NV3
 
+static bool feat_asid16(struct kvm *kvm)
+{
+	return kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16);
+}
+
+static bool feat_mte_no_addr_tags_or_canonical_tags(struct kvm *kvm)
+{
+	bool no_addr_tags = kvm_has_feat(kvm, FEAT_MTE_NO_ADDRESS_TAGS);
+	bool canonical_tags = kvm_has_feat(kvm, FEAT_MTE_CANONICAL_TAGS);
+
+	return no_addr_tags || canonical_tags;
+}
+
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
 	return !kvm_has_feat(kvm, FEAT_AA64EL3);
@@ -1080,6 +1099,91 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
 			      sctlr2_feat_map, FEAT_SCTLR2);
 
+static const struct reg_bits_to_feat_map vhe_tcr_el2_feat_map[] = {
+	NEEDS_FEAT(VHE_TCR_EL2_MTX1	|
+		   VHE_TCR_EL2_MTX0,
+		   feat_mte_no_addr_tags_or_canonical_tags),
+	NEEDS_FEAT(VHE_TCR_EL2_DS, feat_lpa2),
+	NEEDS_FEAT(VHE_TCR_EL2_TCMA1	|
+		   VHE_TCR_EL2_TCMA0,
+		   FEAT_MTE2),
+	NEEDS_FEAT(VHE_TCR_EL2_E0PD1	|
+		   VHE_TCR_EL2_E0PD0,
+		   FEAT_E0PD),
+	NEEDS_FEAT(VHE_TCR_EL2_NFD1	|
+		   VHE_TCR_EL2_NFD0,
+		   FEAT_SVE),
+	NEEDS_FEAT(VHE_TCR_EL2_TBID1	|
+		   VHE_TCR_EL2_TBID0,
+		   feat_pauth),
+	NEEDS_FEAT(VHE_TCR_EL2_HWU162	|
+		   VHE_TCR_EL2_HWU161	|
+		   VHE_TCR_EL2_HWU160	|
+		   VHE_TCR_EL2_HWU159	|
+		   VHE_TCR_EL2_HWU062	|
+		   VHE_TCR_EL2_HWU061	|
+		   VHE_TCR_EL2_HWU060	|
+		   VHE_TCR_EL2_HWU059,
+		   FEAT_HPDS2),
+	NEEDS_FEAT(VHE_TCR_EL2_HPD1	|
+		   VHE_TCR_EL2_HPD0,
+		   FEAT_HPDS),
+	NEEDS_FEAT(VHE_TCR_EL2_HD, FEAT_HAFDBS),
+	NEEDS_FEAT(VHE_TCR_EL2_HA, FEAT_HAF),
+	NEEDS_FEAT(VHE_TCR_EL2_AS, feat_asid16),
+	NEEDS_FEAT(VHE_TCR_EL2_TBI1		|
+		   VHE_TCR_EL2_TBI0		|
+		   VHE_TCR_EL2_IPS		|
+		   VHE_TCR_EL2_TG1		|
+		   VHE_TCR_EL2_SH1		|
+		   VHE_TCR_EL2_ORGN1		|
+		   VHE_TCR_EL2_IRGN1		|
+		   VHE_TCR_EL2_EPD1		|
+		   VHE_TCR_EL2_A1		|
+		   VHE_TCR_EL2_T1SZ		|
+		   VHE_TCR_EL2_TG0		|
+		   VHE_TCR_EL2_SH0		|
+		   VHE_TCR_EL2_ORGN0		|
+		   VHE_TCR_EL2_IRGN0		|
+		   VHE_TCR_EL2_EPD0		|
+		   VHE_TCR_EL2_T0SZ,
+		   FEAT_AA64EL2),
+	FORCE_RES0(VHE_TCR_EL2_RES0),
+	FORCE_RES1(VHE_TCR_EL2_RES1),
+};
+
+static const DECLARE_FEAT_MAP(vhe_tcr_el2_desc, VHE_TCR_EL2,
+			      vhe_tcr_el2_feat_map, FEAT_AA64EL2);
+
+static const struct reg_bits_to_feat_map tcr_el2_feat_map[] = {
+	NEEDS_FEAT(TCR_EL2_MTX,
+		   feat_mte_no_addr_tags_or_canonical_tags),
+	NEEDS_FEAT(TCR_EL2_DS, feat_lpa2),
+	NEEDS_FEAT(TCR_EL2_TCMA, FEAT_MTE2),
+	NEEDS_FEAT(TCR_EL2_TBID, feat_pauth),
+	NEEDS_FEAT(TCR_EL2_HWU62	|
+		   TCR_EL2_HWU61	|
+		   TCR_EL2_HWU60	|
+		   TCR_EL2_HWU59,
+		   FEAT_HPDS2),
+	NEEDS_FEAT(TCR_EL2_HPD, FEAT_HPDS),
+	NEEDS_FEAT(TCR_EL2_HD, FEAT_HAFDBS),
+	NEEDS_FEAT(TCR_EL2_HA, FEAT_HAF),
+	NEEDS_FEAT(TCR_EL2_TBI		|
+		   TCR_EL2_PS		|
+		   TCR_EL2_TG0		|
+		   TCR_EL2_SH0		|
+		   TCR_EL2_ORGN0	|
+		   TCR_EL2_IRGN0	|
+		   TCR_EL2_T0SZ,
+		   FEAT_AA64EL2),
+	FORCE_RES0(TCR_EL2_RES0),
+	FORCE_RES1(TCR_EL2_RES1),
+};
+
+static const DECLARE_FEAT_MAP(tcr_el2_desc, TCR_EL2,
+			      tcr_el2_feat_map, FEAT_AA64EL2);
+
 static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT_FLAG(TCR2_EL2_FNG1	|
 			TCR2_EL2_FNG0	|
@@ -1442,6 +1546,8 @@ void __init check_feature_map(void)
 	check_reg_desc(&hcr_desc);
 	check_reg_desc(&nvhcr_desc);
 	check_reg_desc(&sctlr2_desc);
+	check_reg_desc(&vhe_tcr_el2_desc);
+	check_reg_desc(&tcr_el2_desc);
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
 	check_reg_desc(&sctlr_el2_desc);
@@ -1689,6 +1795,12 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 	case SCTLR2_EL2:
 		resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
 		break;
+	case TCR_EL2:
+		if (kvm_has_feat(kvm, FEAT_E2H0))
+			resx = compute_reg_resx_bits(kvm, &tcr_el2_desc, 0, 0);
+		else
+			resx = compute_reg_resx_bits(kvm, &vhe_tcr_el2_desc, 0, 0);
+		break;
 	case TCR2_EL2:
 		resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
 		break;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cd0dabcf3f81..78fa433774c6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -2101,6 +2101,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	resx = get_reg_fixed_bits(kvm, HFGITR2_EL2);
 	set_sysreg_masks(kvm, HFGITR2_EL2, resx);
 
+	/* TCR_EL2 */
+	resx = get_reg_fixed_bits(kvm, TCR_EL2);
+	set_sysreg_masks(kvm, TCR_EL2, resx);
+
 	/* TCR2_EL2 */
 	resx = get_reg_fixed_bits(kvm, TCR2_EL2);
 	set_sysreg_masks(kvm, TCR2_EL2, resx);
-- 
2.47.3

