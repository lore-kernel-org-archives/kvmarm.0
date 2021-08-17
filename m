Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43FAC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A0CC60F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A0CC60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6A74B154;
	Tue, 17 Aug 2021 04:12:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OtdUHbfSrLNb; Tue, 17 Aug 2021 04:12:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 528724B173;
	Tue, 17 Aug 2021 04:12:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC964B173
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p+lX1C0XZ3b9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:09 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D08B64B165
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:56 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 u14-20020a7bcb0e0000b0290248831d46e4so606328wmj.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8n83SYPJFagVj2+maLVaB3cngisvORRV9MwxIVnJLmI=;
 b=QK/oT43c/HyLP/flGctPFGgv7ERt829+s64w8tFk/HXu62cv5ewT8zROH3wOTe2tvj
 /aS4rS4XvL+VdJ9fohamgn6Nyg59PZxWDrodzia7PUArQfMO26PTAh+H6xoSWEEE3mr9
 dDmCJJ0j+3nII+H807f9g0TIew5R2UMyYDEfLyjS2RBXhILL7blWPMY7mBzm07CD2FZV
 R8adqZDTDufewJarzOCN7pgqdsv7Vx+iayW4OdoLDVJoz3VzmOcOn+/+N4eEAJqA5HBX
 c3eEB1npKGLlrrR/cCsOka1MAFIAwLC4Wyfv2oF357gfPE6pnUPWzc5uT0kVfitF8n0b
 Bl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8n83SYPJFagVj2+maLVaB3cngisvORRV9MwxIVnJLmI=;
 b=HdPeagRlqqPiCmNK29RBMG4ig7xaJk4LgpQthlIQs2eKVNSKfdmf2/EMJJHZYQilBU
 XuY86HF2IJVHxLT2Zuan/T/P7OdTqxZ++jP18KZeAv2pQNtcaynB5dZGGJrvpjliFGRW
 vnQi8WmTAuDIXK4rOZKQzZcrfikwaxL/L8uuFdMC35EYVvjdcEpsyJFH6g5Qc7NGQboU
 6R6e9dnKS+sIOicgzY4WIkaOT3vhi2WdGb0XLchI0mOElJQDHFr3sOby8p/CpdOMH3fb
 BfQWla90COaRcexBZi+Du6Z/Lbg+ifHDI1/u98ZKdQemA/ZGTBSRUBY4HeFlUvRY0yqf
 nPIQ==
X-Gm-Message-State: AOAM531ktAO2f41rDB+ARBpCAZTo2iWR+6QYO4uYe20WfHwRDr9E/xZL
 NZe6lTT6dhn+geKzuYgq1znzbSmTalxByfXeXqa0jDId/yu94aFDnR1cWTKJrK+umLD/6NzmtNs
 +G2HcKhmYPk7Ipj1Lzk/02j/Xqa/P7wds6yLyA6Mn9nFwXEvTpqVWf1gukOo4fexzdXI=
X-Google-Smtp-Source: ABdhPJyTMMnMvo44W4iioAshOfXYGiB/EBOESDhi7wJydM3Tnpejk+WoPKZaFjTVp97hac/tbSdCEeXM2g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:5116:: with SMTP id
 o22mr227673wms.0.1629187915361; Tue, 17 Aug 2021 01:11:55 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:28 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-10-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 09/15] KVM: arm64: Add feature register flag definitions
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

Add feature register flag definitions to clarify which features
might be supported.

Consolidate the various ID_AA64PFR0_ELx flags for all ELs.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  4 ++--
 arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
 arch/arm64/kernel/cpufeature.c      |  8 ++++----
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9bb9d11750d7..b7d9bb17908d 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -602,14 +602,14 @@ static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
 {
 	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
 
-	return val == ID_AA64PFR0_EL1_32BIT_64BIT;
+	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
 }
 
 static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
 {
 	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
 
-	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
+	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
 }
 
 static inline bool id_aa64pfr0_sve(u64 pfr0)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 53a93a9c5253..f84a00f5874d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -784,14 +784,13 @@
 #define ID_AA64PFR0_AMU			0x1
 #define ID_AA64PFR0_SVE			0x1
 #define ID_AA64PFR0_RAS_V1		0x1
+#define ID_AA64PFR0_RAS_V1P1		0x2
 #define ID_AA64PFR0_FP_NI		0xf
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
-#define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
-#define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
-#define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
-#define ID_AA64PFR0_EL0_32BIT_64BIT	0x2
+#define ID_AA64PFR0_ELx_64BIT_ONLY	0x1
+#define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
@@ -847,12 +846,16 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ASID_8		0x0
+#define ID_AA64MMFR0_ASID_16		0x2
+
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_NI		0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_PARANGE_40		0x2
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -900,6 +903,7 @@
 #define ID_AA64MMFR2_CNP_SHIFT		0
 
 /* id_aa64dfr0 */
+#define ID_AA64DFR0_MTPMU_SHIFT		48
 #define ID_AA64DFR0_TRBE_SHIFT		44
 #define ID_AA64DFR0_TRACE_FILT_SHIFT	40
 #define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0ead8bfedf20..5b59fe5e26e4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -239,8 +239,8 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SHIFT, 4, ID_AA64PFR0_EL1_64BIT_ONLY),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL0_SHIFT, 4, ID_AA64PFR0_EL0_64BIT_ONLY),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SHIFT, 4, ID_AA64PFR0_ELx_64BIT_ONLY),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL0_SHIFT, 4, ID_AA64PFR0_ELx_64BIT_ONLY),
 	ARM64_FTR_END,
 };
 
@@ -1956,7 +1956,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
-		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
+		.min_field_value = ID_AA64PFR0_ELx_32BIT_64BIT,
 	},
 #ifdef CONFIG_KVM
 	{
@@ -1967,7 +1967,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_EL1_SHIFT,
-		.min_field_value = ID_AA64PFR0_EL1_32BIT_64BIT,
+		.min_field_value = ID_AA64PFR0_ELx_32BIT_64BIT,
 	},
 	{
 		.desc = "Protected KVM",
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
