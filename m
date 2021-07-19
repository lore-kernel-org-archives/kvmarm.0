Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418D5C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6DBE6147D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6DBE6147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAF44A1AF;
	Mon, 19 Jul 2021 12:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZofGZOSeZubU; Mon, 19 Jul 2021 12:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D41F4B0DB;
	Mon, 19 Jul 2021 12:04:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1044440667
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5oiemeghF-Ob for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:05 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E77EF4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:04 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 kj25-20020a0562145299b02902fbda5d4988so12161955qvb.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V9acI6EDUhR6tDfpqD9I6jrvJeuKAdMZUkQ+s858Nww=;
 b=BTpC1hwjiWVrUEkLbLdoxGFsQTsMQ7ua3qjmKq/cWq8pEdtqNoaW1vlJJr/8xIcdGW
 51tQOla73fd6ozBrfWwYvU0fK7r4h2tePvxtQPbPru4f1iWcoMPyT//2OXb5xJXcrfqE
 1SP8DZ1RGUOTDRVjV41OZd4ZWeitV/jtLi0aD5igfY9HwuF9Gqr3/G94dawfUHvXF+n4
 +Ne/qeTtowBLUGLppz/g3dF6GlHFHI7UvavDhFMcsQe9k+B0+rgDuHt/y6XME9JECePm
 9dPiB/I11y4V43mNctHB9+dR85b5cj49lv/wMFuuZcrYFhRc5D99vGZDsiqenb7SYaUf
 M+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V9acI6EDUhR6tDfpqD9I6jrvJeuKAdMZUkQ+s858Nww=;
 b=kDPlYNQrrrKwdcN1OnFVITcfMUmvOReR931z1y55+AXMAuliD5wANvChzS0gax/4Bg
 1WMUCXHJdmudmj4e8y7f+cjFxCkQGmDFtmjYNSMVYsN2sm2cFB/ztAnUBsxKB6G0lX5C
 KRyobY49RqGQMcVssxMRTt+Ue/agYSESfiBiMfL0dYbRv1hiRHTSOYdGKz8IfdZ0p3J9
 haDvafFGsQUVLPQ5wve+Qpuav3p9FSs3u9bEDwcOta0q8yaKJ/4SRMNkL9po8HwgygG8
 yKVaPOqSKK5BiOzXcFxhBsRoW5Jfuxzb9JlMkUrSSWCubDFrNh51kQwGD61kYNK3LiXI
 ULfQ==
X-Gm-Message-State: AOAM533e9jO+biXJTSQ/pUGWtkKPBVGWt04BC4DyWwynSoMHG6KR53On
 RkDWy3wdImwXTvEz1hSpmcQ5ghHUXLoBCOCnPzhpVCs2AdC5mz18KP0O5xpWgYlWZoTr6TL9k9U
 lwEpIIK0Q2uWUgSPv2kXvEqz0Xn0G4oNkfQ5T8w5KkgozmeJ90uoyxIP5V/GPhiuLVx0=
X-Google-Smtp-Source: ABdhPJyyKsZdgx86oOpgbZLiHegl5Y1zod3kRSEavOWe7KLm5NM5K6J05rrWMdpFS4IHz+JdQ3I7DZHEMg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:a321:: with SMTP id
 u30mr25473018qvu.57.1626710644424; 
 Mon, 19 Jul 2021 09:04:04 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:39 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-9-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 08/15] KVM: arm64: Add feature register flag definitions
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
index 326f49e7bd42..0b773037251c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -784,14 +784,13 @@
 #define ID_AA64PFR0_AMU			0x1
 #define ID_AA64PFR0_SVE			0x1
 #define ID_AA64PFR0_RAS_V1		0x1
+#define ID_AA64PFR0_RAS_ANY		0xf
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
