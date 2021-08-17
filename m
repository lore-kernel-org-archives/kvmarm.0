Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB3DC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A582B60F5E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A582B60F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 594864B158;
	Tue, 17 Aug 2021 04:12:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 58n142rSQJKT; Tue, 17 Aug 2021 04:12:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C026E4B170;
	Tue, 17 Aug 2021 04:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9FF4B152
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D9B6YyC8f5Qy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:11:50 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28B6D4B155
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:48 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 t15-20020a5d42cf000000b001565f9c9ee8so4130664wrr.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5N9sL5FNi9qrbBCH60+h/5aGjehNQlmcB8JtRn+LK/Y=;
 b=Y9gCxjQgu8WBnIwLq0UnpoEyfcwWFnZk9EOwZk5QUmzoT9Svlr1th34g/QjJoDB+ab
 zZpl5TBx3FL7mnwXSLgADzhf+2CGRAZKZPKiRZG8VEUibVmKP6KFg43r/Zuk9kLL9/b8
 7HgYGzFNzdIWRuNIiIEYlCrw/dyiXXnwehzp+vdn8LEVLVirVyBVfp6PWmmHWXvpzbIk
 5qhABEIRo/VBXLlpfwYDVise2mty3JtejTP/fFRusuZFO+fWkOh+g0d9z64EQvhG/bOn
 LnGLykAU1b2fZ75hPyAVrZwKB3SovLgzHvEaY0MjwGovwohFLcZHWhiOd53DkJ6y7GaK
 0gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5N9sL5FNi9qrbBCH60+h/5aGjehNQlmcB8JtRn+LK/Y=;
 b=oXTOLVQIpBueaI+UhV8cxAohFnHz+LML3vYGxD0819+ChciBKvGhOr1rbSJ7IXeDNr
 0ixWsWkQJ3hLVbmuPFf4b4l7je9rnb3PwrS32zd63TApc/LHUH+rm79HFlxdJ5gYZ93s
 pQffPPI8j20JCFL8FQxv4TnwMqRRjNBpumaZkIb538Fi7i75pMV6JKHK/FIUf0nzHvTK
 f5pnrzlzYw/xkKEdC+/772Vq5I5p2IxvAObkMyMWfBjnafpKo2SvMVLPhREqGe+EVGw8
 p0VzrHJ6qN2tdfmAOhKBezoOS5YlYV0Xz9wqNsW5F6jrW+inZ0W1fTwB0JHCaCabRHJb
 ES0Q==
X-Gm-Message-State: AOAM532Uk7VwVvbAqC7mWmVZGeWniJKmJRxd9QoOYofY2wfJgywzPROn
 b3j2pMUXuAptjRgM7n/9yKI1hOJkXDLv3iZJpkOx5fOA4NeqYL/TTk3yavcpcDrvkMJgwW6l1O5
 u//LupgedEYSe8bGrQpXZ5Ck5UhdXiTvwh/rSp1Dg7Db7vUyzKPLytN6RcYaT/uYFlyw=
X-Google-Smtp-Source: ABdhPJzt7u4Sk+ACYI0cSDXGAWDWaXIZ7nNJ6bvJ191RPxt+qLvQzW+ZQUSMtv7dbzAVAyk+72BhiULwOQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:5116:: with SMTP id
 o22mr227600wms.0.1629187906624; Tue, 17 Aug 2021 01:11:46 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:24 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-6-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Refactor sys_regs.h and sys_regs.c to make it easier to reuse
common code. It will be used in nVHE in a later patch.

Note that the refactored code uses __inline_bsearch for find_reg
instead of bsearch to avoid copying the bsearch code for nVHE.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h |  5 +++
 arch/arm64/kvm/sys_regs.c       | 60 +++++++++------------------------
 arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++
 3 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..53a93a9c5253 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1153,6 +1153,11 @@
 #define ICH_VTR_A3V_SHIFT	21
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
 
+#define ARM64_FEATURE_FIELD_BITS	4
+
+/* Create a mask for the feature bits of the specified feature. */
+#define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
+
 #ifdef __ASSEMBLY__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 80a6e41cadad..b6a2f8e890db 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,10 +44,6 @@
  * 64bit interface.
  */
 
-#define reg_to_encoding(x)						\
-	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
-		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
-
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
-
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -1038,40 +1032,40 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
-			val &= ~FEATURE(ID_AA64PFR0_SVE);
-		val &= ~FEATURE(ID_AA64PFR0_AMU);
-		val &= ~FEATURE(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~FEATURE(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		val &= ~FEATURE(ID_AA64PFR1_MTE);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		if (kvm_has_mte(vcpu->kvm)) {
 			u64 pfr, mte;
 
 			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(FEATURE(ID_AA64PFR1_MTE), mte);
+			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
 		}
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
-				 FEATURE(ID_AA64ISAR1_API) |
-				 FEATURE(ID_AA64ISAR1_GPA) |
-				 FEATURE(ID_AA64ISAR1_GPI));
+			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
-		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
 		/* Hide SPE from guests */
-		val &= ~FEATURE(ID_AA64DFR0_PMSVER);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
 		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.4 */
@@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-static int match_sys_reg(const void *key, const void *elt)
-{
-	const unsigned long pval = (unsigned long)key;
-	const struct sys_reg_desc *r = elt;
-
-	return pval - reg_to_encoding(r);
-}
-
-static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
-					 const struct sys_reg_desc table[],
-					 unsigned int num)
-{
-	unsigned long pval = reg_to_encoding(params);
-
-	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
-}
-
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
 	kvm_inject_undefined(vcpu);
@@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
-	params.Op0 = (esr >> 20) & 3;
-	params.Op1 = (esr >> 14) & 0x7;
-	params.CRn = (esr >> 10) & 0xf;
-	params.CRm = (esr >> 1) & 0xf;
-	params.Op2 = (esr >> 17) & 0x7;
+	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-	params.is_write = !(esr & 1);
 
 	ret = emulate_sys_reg(vcpu, &params);
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9d0621417c2a..cc0cc95a0280 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -11,6 +11,12 @@
 #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
 #define __ARM64_KVM_SYS_REGS_LOCAL_H__
 
+#include <linux/bsearch.h>
+
+#define reg_to_encoding(x)						\
+	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
+		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
+
 struct sys_reg_params {
 	u8	Op0;
 	u8	Op1;
@@ -21,6 +27,14 @@ struct sys_reg_params {
 	bool	is_write;
 };
 
+#define esr_sys64_to_params(esr)                                               \
+	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
+				  .Op1 = ((esr) >> 14) & 0x7,                  \
+				  .CRn = ((esr) >> 10) & 0xf,                  \
+				  .CRm = ((esr) >> 1) & 0xf,                   \
+				  .Op2 = ((esr) >> 17) & 0x7,                  \
+				  .is_write = !((esr) & 1) })
+
 struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
@@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 	return i1->Op2 - i2->Op2;
 }
 
+static inline int match_sys_reg(const void *key, const void *elt)
+{
+	const unsigned long pval = (unsigned long)key;
+	const struct sys_reg_desc *r = elt;
+
+	return pval - reg_to_encoding(r);
+}
+
+static inline const struct sys_reg_desc *
+find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
+	 unsigned int num)
+{
+	unsigned long pval = reg_to_encoding(params);
+
+	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
+}
+
 const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  struct sys_reg_params *params,
 					  const struct sys_reg_desc table[],
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
