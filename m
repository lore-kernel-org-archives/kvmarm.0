Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E0DC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 687C022D57
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 687C022D57
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD8194B395;
	Tue,  5 Jan 2021 13:06:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HwhCm1CPLsmR; Tue,  5 Jan 2021 13:06:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7964B36F;
	Tue,  5 Jan 2021 13:06:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67F484B27D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7dAUnnyIbHT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:06:01 -0500 (EST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3FE74B0FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:00 -0500 (EST)
Received: by mail-wm1-f41.google.com with SMTP id q75so390044wme.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=4s4kC7CHwiZm9mv2QHLBsiW5mNoTxM3uNeHHcwGbjn8=;
 b=Xp8q0HPzSd/L5ty1dj9Lhbtp9EHrG0IFlx9wI2ylD0ujpGx5iKDRejeLVXFUQMsIC6
 GtYZ1r97VgBDtNlCFXQGyhBxyH2UgV0oAMFgNf+zfEn2uNaW5F5ZY5hFU4rBBotBttZV
 Ez9NqLsfLybCw1F6vLmJlhU41dkQdfwSjXaOlTM0w4sScV4zD8rB/ZQ+zzoZAlxO23um
 pTKRQ1kmXyWQBERElli5iZ6nuyYSAhtOUuugXxR7GluR3vLn7BwITKmm9cqdVPbQw+PH
 Xf5ji8WYrP2AnhiRdel2xu2wl3gBJQc6NlmPfhaPPqQ42kWvfaUkxEvmSf4xWnlilhU6
 zv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=4s4kC7CHwiZm9mv2QHLBsiW5mNoTxM3uNeHHcwGbjn8=;
 b=GlL+Yq9sCy7/uhJuPQoq8FogKiECSt8ZOnykudw5nPDLwTZzMyvXK+rFPcngOY4EsT
 cBvJO3TEYFafIK3ticdYppckiU6JxLvmr7ZgZPjgFdp9y19tQML67S6r0toJsibVD0US
 gq0163juChXNMKuVS2ZfgYeHFLuus0MD3HVEdf3FF/bSG+8hdM4QxjyKvdrqmWHXZAL/
 1HmzkAs3VactNvk03hpSNL/nnlITKRCPOPTsI9lpJL7VCLmRWxW5BK0VqHNS/t/glWHF
 lzjSwyxkeVvpYqyXpLmKfwcPAyhW0eQgNBSGsoNKNus5crE9nB/BtH6XZW1BRg7lUgeY
 RJoA==
X-Gm-Message-State: AOAM533lWSSYscn9vYK9aALK9WJ7ldnpqSeYHybawTvtGz6JnQgjAd2D
 cW5Rettcuyf/0UrEoFn7XXHUlzBkbW9x1Q==
X-Google-Smtp-Source: ABdhPJxRBFRzG613rtvyFJCeGLgpeoBl59v2l9QUF4TI9LzcY5VpziqmJ9QhA/8AH0mZ8DHe5XtmjA==
X-Received: by 2002:a1c:2d8a:: with SMTP id t132mr289011wmt.119.1609869959397; 
 Tue, 05 Jan 2021 10:05:59 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id t10sm745477wrp.39.2021.01.05.10.05.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:05:58 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/8] KVM: arm64: Add symbol at the beginning of each hyp
 section
Date: Tue,  5 Jan 2021 18:05:36 +0000
Message-Id: <20210105180541.65031-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

Generating hyp relocations will require referencing positions at a given
offset from the beginning of hyp sections. Since the final layout will
not be determined until the linking of `vmlinux`, modify the hyp linker
script to insert a symbol at the first byte of each hyp section to use
as an anchor. The linker of `vmlinux` will place the symbols together
with the sections.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 29 +++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  |  4 ++--
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index daa1a1da539e..f97b774b58f4 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -7,6 +7,9 @@
 #ifndef __ARM64_HYP_IMAGE_H__
 #define __ARM64_HYP_IMAGE_H__
 
+#define HYP_CONCAT(a, b)	__HYP_CONCAT(a, b)
+#define __HYP_CONCAT(a, b)	a ## b
+
 /*
  * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
  * to separate it from the kernel proper.
@@ -21,9 +24,31 @@
  */
 #define HYP_SECTION_NAME(NAME)	.hyp##NAME
 
+/* Symbol defined at the beginning of each hyp section. */
+#define HYP_SECTION_SYMBOL_NAME(NAME) \
+	HYP_CONCAT(__hyp_section_, HYP_SECTION_NAME(NAME))
+
+/*
+ * Helper to generate linker script statements starting a hyp section.
+ *
+ * A symbol with a well-known name is defined at the first byte. This
+ * is used as a base for hyp relocations (see gen-hyprel.c). It must
+ * be defined inside the section so the linker of `vmlinux` cannot
+ * separate it from the section data.
+ */
+#define BEGIN_HYP_SECTION(NAME)				\
+	HYP_SECTION_NAME(NAME) : {			\
+		HYP_SECTION_SYMBOL_NAME(NAME) = .;
+
+/* Helper to generate linker script statements ending a hyp section. */
+#define END_HYP_SECTION					\
+	}
+
 /* Defines an ELF hyp section from input section @NAME and its subsections. */
-#define HYP_SECTION(NAME) \
-	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.*) }
+#define HYP_SECTION(NAME)			\
+	BEGIN_HYP_SECTION(NAME)			\
+		*(NAME NAME##.*)		\
+	END_HYP_SECTION
 
 /*
  * Defines a linker script alias of a kernel-proper symbol referenced by
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index cfdc59b4329b..cd119d82d8e3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -22,7 +22,7 @@ SECTIONS {
 	 * alignment for when linking into vmlinux.
 	 */
 	. = ALIGN(PAGE_SIZE);
-	HYP_SECTION_NAME(.data..percpu) : {
+	BEGIN_HYP_SECTION(.data..percpu)
 		PERCPU_INPUT(L1_CACHE_BYTES)
-	}
+	END_HYP_SECTION
 }
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
