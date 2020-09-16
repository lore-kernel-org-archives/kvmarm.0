Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5754C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5169F22453
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="qo4UjMaG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5169F22453
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAAFD4B50D;
	Wed, 16 Sep 2020 13:35:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KFnKXdX64zmj; Wed, 16 Sep 2020 13:35:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5EB4B4D2;
	Wed, 16 Sep 2020 13:35:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3664F4B47F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:35:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6X4lLt08B-5B for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:34:59 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E9EE4B4DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:58 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id z1so7796299wrt.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=jm9txujGRbU+DIE5pQGENaBdVyNjHKuT2OQRoaKu5mk=;
 b=qo4UjMaG+LBmqizh/dguDo/1ZgFI6RSCpgvcu7UWxVpteEpYt6NHNQhs2cLgolyhud
 x3Ot+cX0Sp2hdxCGGm2R7QvodsCr54yNugnLPLPt6pSz/0vqaUvUP1vkJImvPJavE1JU
 /KWaXjiMd2VyyjXhCcJVrjDOEZ7J/mXd9xq5tVPX0hBQl/hG2W1oMc+sNcdIQEjaEbyg
 P5irBhmyRSSZ3oYyYC65aFW/vOXx2S2ACJsVISa0BOHj761vLtFGseGu2WvmEE1bh+RI
 4Uivcqab87R5WzqTKUqjgCu6wND91b07/46tLA512z6Ayp8j0YmNjO6b4dewhw1zZG7S
 pKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=jm9txujGRbU+DIE5pQGENaBdVyNjHKuT2OQRoaKu5mk=;
 b=OsHVKHy2mC2eZ3x+92RQkdkQoA0PhAVMaX84pg0IfnyrVrtj4gGlLGqC6kVIrXPxWm
 hHZ9XRZFG1A98VGMD9OHxRO853d2OgFlbDxawBidr3x0VmYF4Xhp4AnK8uV7MsbzSIoi
 fRvzNFk/f/Hh/kbR8YcfxokMW0JA5dEe9gH6HTkSHvSa2cFlHE0SnF6lEUn+uY/PCaUh
 Mo7wFqFTe1c00W6U4C+xvOf7SlICgDFm8jgP4oGki5N5VyQ0fubkTxKOrQnJd7Z59BIW
 LKYkySqOFoA3mOaewoiefq7XdojbVSisitsraWsbKKxPxzZpttRKYqwS5ClJ+z/A+yVv
 9sNg==
X-Gm-Message-State: AOAM531NT0yzjSjuiw9QXmTLu2zmAM7eEXMKQqemO9VqsXFSC/TQ5F5a
 9U28hYhjytL6pVw2BRlFpt1XUOVY3z5aPswj
X-Google-Smtp-Source: ABdhPJwU4kbhpWG5C/yjfJonDHsb6tdTDo9eAoD2gMl5GCOkrw+z409Io9EwIzx1e93E00CEZFWrkw==
X-Received: by 2002:a05:6000:118a:: with SMTP id
 g10mr28697445wrx.67.1600277697172; 
 Wed, 16 Sep 2020 10:34:57 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id v204sm6596978wmg.20.2020.09.16.10.34.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:34:56 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 06/11] kvm: arm64: Add helpers for accessing nVHE hyp
 per-cpu vars
Date: Wed, 16 Sep 2020 18:34:34 +0100
Message-Id: <20200916173439.32265-7-dbrazdil@google.com>
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

Defining a per-CPU variable in hyp/nvhe will result in its name being
prefixed with __kvm_nvhe_. Add helpers for declaring these variables
in kernel proper and accessing them with this_cpu_ptr and per_cpu_ptr.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index cf9456663289..abc03f386b40 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -54,9 +54,21 @@
 	DECLARE_KVM_VHE_SYM(sym);		\
 	DECLARE_KVM_NVHE_SYM(sym)
 
+#define DECLARE_KVM_VHE_PER_CPU(type, sym)	\
+	DECLARE_PER_CPU(type, sym)
+#define DECLARE_KVM_NVHE_PER_CPU(type, sym)	\
+	DECLARE_PER_CPU(type, kvm_nvhe_sym(sym))
+
+#define DECLARE_KVM_HYP_PER_CPU(type, sym)	\
+	DECLARE_KVM_VHE_PER_CPU(type, sym);	\
+	DECLARE_KVM_NVHE_PER_CPU(type, sym)
+
 #define CHOOSE_VHE_SYM(sym)	sym
 #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
 
+#define this_cpu_ptr_nvhe(sym)		this_cpu_ptr(&kvm_nvhe_sym(sym))
+#define per_cpu_ptr_nvhe(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * BIG FAT WARNINGS:
@@ -69,12 +81,21 @@
  * - Don't let the nVHE hypervisor have access to this, as it will
  *   pick the *wrong* symbol (yes, it runs at EL2...).
  */
-#define CHOOSE_HYP_SYM(sym)	(is_kernel_in_hyp_mode() ? CHOOSE_VHE_SYM(sym) \
+#define CHOOSE_HYP_SYM(sym)		(is_kernel_in_hyp_mode()	\
+					   ? CHOOSE_VHE_SYM(sym)	\
 					   : CHOOSE_NVHE_SYM(sym))
+#define this_cpu_ptr_hyp(sym)		(is_kernel_in_hyp_mode()	\
+					   ? this_cpu_ptr(&sym)		\
+					   : this_cpu_ptr_nvhe(sym))
+#define per_cpu_ptr_hyp(sym, cpu)	(is_kernel_in_hyp_mode()	\
+					   ? per_cpu_ptr(&sym, cpu)	\
+					   : per_cpu_ptr_nvhe(sym, cpu))
 #else
 /* The nVHE hypervisor shouldn't even try to access anything */
 extern void *__nvhe_undefined_symbol;
-#define CHOOSE_HYP_SYM(sym)	__nvhe_undefined_symbol
+#define CHOOSE_HYP_SYM(sym)		__nvhe_undefined_symbol
+#define this_cpu_ptr_hyp(sym)		(&__nvhe_undefined_symbol)
+#define per_cpu_ptr_hyp(sym, cpu)	(&__nvhe_undefined_symbol)
 #endif
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
