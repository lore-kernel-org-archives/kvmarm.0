Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10004C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95D5A2080C
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="M2E0n8qJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95D5A2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5134B4F7;
	Wed, 16 Sep 2020 13:34:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yrCPx8BmsMop; Wed, 16 Sep 2020 13:34:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433E64B4E1;
	Wed, 16 Sep 2020 13:34:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 540674B44A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w26rWOmSdCid for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:34:51 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 883014B4A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:50 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id s12so7732415wrw.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Bb8x+HFH0B/5AJF/3eHINfl7a3Qa0+GTsxwxT6ItzrA=;
 b=M2E0n8qJMz1MSrSfqdhktCcaOa3AQGk1vmL6Kdjan+YvnN4Uq1JyhmWHaYif2qseKo
 7MBBvjOhBg96grbm9ZP7di/5Ks/FE2YU5A0RILohThIR4aygnTZpnOQeqCylD42bNDyZ
 /GHnv4SVspVP2I7UqGWfOnLnq5PZJXg+7LmAU0usi0LcCoKhWVg20JXWk1gD7Dx9jJ2h
 urT8MmXA1a4IPXVtGsD2MRKI6+46OC9ZsTGpnmm2FO5qccUyI+KkWdAiMgPH10nR7JU0
 V4lLP2rS82e7Q3ZSw1KO5ix3ERwkqgea+/sU+waTdQCUBZqwD4luhpsk5LacwlUFA16t
 6RIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Bb8x+HFH0B/5AJF/3eHINfl7a3Qa0+GTsxwxT6ItzrA=;
 b=Hil7NezsG18D8lAUwGiZAPFpAQhaVRLYsIa1CbHNAjUddx0mpclq0gFEXrmqcahuxI
 b15m9kiVp4dewFAGeD65dkYQjxw/JDilWURr7eUGxkV05D9stTTuSEjusCTyjww4tRQR
 X0Atpi1K63i/0Zd5VMp6TUL8P5XtS9ozIMuMhfRbcr5xXSdO6++jl/SIZupgj9kEEA+u
 vOiTgzBYYoiBM/fuxAtkwO49TYUtc4j63oDqhgOKS92H3WeKAvJu3q0AtsCO7KOxiJGC
 shd21y2TPxdVbAQnikNakwzsf/eeN0CSC4bahVfL4JJ19Fx+4xrO+X4bKEDb2z/9rdqd
 stjw==
X-Gm-Message-State: AOAM533mRzpgIk22cmq9gvSiLq7OKZkBAZwV4jBh3Ulh36gdtxnQkk+w
 RgYlykh0mY5NDsYlVm+jVUG8AVBoBpcR2THC
X-Google-Smtp-Source: ABdhPJyyusmPWRRPVeBCNm47H5a0PGpw8keKMBDtnH6wTG9FWTwQc0RSofvNwO/KVylWvPlmtAdRqQ==
X-Received: by 2002:adf:8162:: with SMTP id 89mr28955370wrm.237.1600277689224; 
 Wed, 16 Sep 2020 10:34:49 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id d19sm3530522wmd.0.2020.09.16.10.34.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:34:48 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 02/11] kvm: arm64: Move nVHE hyp namespace macros to
 hyp_image.h
Date: Wed, 16 Sep 2020 18:34:30 +0100
Message-Id: <20200916173439.32265-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916173439.32265-1-dbrazdil@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Minor cleanup to move all macros related to prefixing nVHE hyp section
and symbol names into one place: hyp_image.h.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 12 ++++++++++++
 arch/arm64/include/asm/kvm_asm.h   |  8 +-------
 arch/arm64/kernel/image-vars.h     |  2 --
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index 5b1e3b9ef376..9848de588238 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -7,6 +7,12 @@
 #ifndef __ARM64_HYP_IMAGE_H__
 #define __ARM64_HYP_IMAGE_H__
 
+/*
+ * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
+ * to separate it from the kernel proper.
+ */
+#define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+
 #ifdef LINKER_SCRIPT
 
 /*
@@ -19,6 +25,12 @@
 #define HYP_SECTION(NAME) \
 	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.[0-9a-zA-Z_]*) }
 
+/*
+ * Defines a linker script alias of a kernel-proper symbol referenced by
+ * KVM nVHE hyp code.
+ */
+#define KVM_NVHE_ALIAS(sym)	kvm_nvhe_sym(sym) = sym;
+
 #endif /* LINKER_SCRIPT */
 
 #endif /* __ARM64_HYP_IMAGE_H__ */
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6f98fbd0ac81..c085032e2e3e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -7,6 +7,7 @@
 #ifndef __ARM_KVM_ASM_H__
 #define __ARM_KVM_ASM_H__
 
+#include <asm/hyp_image.h>
 #include <asm/virt.h>
 
 #define	VCPU_WORKAROUND_2_FLAG_SHIFT	0
@@ -42,13 +43,6 @@
 
 #include <linux/mm.h>
 
-/*
- * Translate name of a symbol defined in nVHE hyp to the name seen
- * by kernel proper. All nVHE symbols are prefixed by the build system
- * to avoid clashes with the VHE variants.
- */
-#define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
-
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
 #define DECLARE_KVM_NVHE_SYM(sym)	extern char kvm_nvhe_sym(sym)[]
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8982b68289b7..76da2ad1010c 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,8 +61,6 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-#define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
-
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_enable_wa2_handling);
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
