Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63D3C4727E
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 629FC2371F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="b4hrojdQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 629FC2371F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A054B0CA;
	Tue, 22 Sep 2020 16:49:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W2gRqPGLG3mh; Tue, 22 Sep 2020 16:49:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E33E94B0B9;
	Tue, 22 Sep 2020 16:49:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C32284B2DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g43ceKEAkQA5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:18 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CECAC4B2F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:17 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id o5so18532948wrn.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=cgWGlE2IBAlgCGkRWqoEQwRpT6/N3qd1Q+BRhcwZDZc=;
 b=b4hrojdQte8QWeYLCiPSNSABZw4R7mloaUzWFqKdtEwXnDHSrp6nbwKdmyu8HK98o6
 vPD8drmTTIg5ifxhTwMCmoHLD7hzPwIlFTDYOQk6cF6TVWmxz9jpMH1T0jYa60fQs9OS
 bH08OtNrvCR3ATTNf1AQQBBfgX6GWOqg9o0+CkUbVV5U+OAqayr9kzVgamtFvpCoLWeU
 fmZZe4HhaYMMFGDD6wFT4bv5KFDYUOymBK3OTeXXRCvb3VnUvf2dMCpAYEVOJsKM4L+G
 4aYOyaVxESzEoNF2pZBGWBsUFCdN1xyc2AHOYj+OmDmIzGaJQLBX8gDaXmFvUy2BMWvD
 m12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=cgWGlE2IBAlgCGkRWqoEQwRpT6/N3qd1Q+BRhcwZDZc=;
 b=cs9I7Dt+n3g1lu9nOPwaaTw+Ibp55mvjvwdzEgdvsOZsFu4mhdhGgFnuuHGCRCp8Ep
 A+NhIRHF9sZMoZBCQcwln9TzrD1V/mrXjDfkUi1qmAb4xk39906Ap4bnuis9ZKWE61JJ
 C4xcE0MZx+OATBQMk+LGrjHL6yH09gT74Vj8HPFCF0gXeHLs9F0VAniAP8cRojvMJ0BA
 yIkNdlLLzZnAZU0msBW620QV4DcfDBYyT8RN2bzg7Z1EpdfFuoyVU3hHD2lUimN1dBxm
 ZHGeOvnnF/WQcnQaHfAoWzo1ksF02CVSOVBNv5AZ+1FB+Ys5v9YlFOEGfjYX8u4S+0yg
 XEKA==
X-Gm-Message-State: AOAM530heRX8rvFROuJgPxN2wPzFJUwwixvDxCNTQ3AcJpVdVGmaLjE+
 /1aA0S5Jg6jWc720pvYCJCZffz3K+nSKRGKQ
X-Google-Smtp-Source: ABdhPJwQOkTmORTiH0kGK9fq+pg0w2lWJEG8QjDiGw0F0wP+anozS8vVGWhXnKQJuGWHRjKKKiXLmw==
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr7415703wrj.1.1600807756554;
 Tue, 22 Sep 2020 13:49:16 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id 92sm29084887wra.19.2020.09.22.13.49.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:15 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 02/10] kvm: arm64: Move nVHE hyp namespace macros to
 hyp_image.h
Date: Tue, 22 Sep 2020 21:49:02 +0100
Message-Id: <20200922204910.7265-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 12 ++++++++++++
 arch/arm64/include/asm/kvm_asm.h   |  8 +-------
 arch/arm64/kernel/image-vars.h     |  2 --
 arch/arm64/kernel/vmlinux.lds.S    |  1 +
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index 2e38fcda02fc..daa1a1da539e 100644
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
 	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.*) }
 
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
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7cba7623fcec..fbb13f38d0c5 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -9,6 +9,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
+#include <asm/hyp_image.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/page.h>
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
