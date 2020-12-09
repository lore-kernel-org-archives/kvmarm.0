Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6FEC4361B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE06F23340
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE06F23340
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D324B2C9;
	Wed,  9 Dec 2020 08:18:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lS9h2G2ACpCH; Wed,  9 Dec 2020 08:18:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 942914B2A4;
	Wed,  9 Dec 2020 08:18:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5754B2C5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zolxufGVty8c for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:17:59 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB91A4B2D1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:59 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id g185so1638296wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=1ZeZvh+Y/5GhqSEze9JV4PDzqUs6TgMApcSFco5AbC8=;
 b=FSv0XsPfA6t0nU+P8LEUQP0tv0hSw7PcN78XgG+fOiyTmrIZsXkOpEb6lrmGaeXIac
 A7LoODo6KlWtNVNCtHJMeRB5YtnDXbwXILbLgoPcp9yrkSGDrWJr6zQJ1Zz/9k6w/o2/
 m7MPV/g+eUqmVdskv7+Bj5LRzZt1V1cqdJlLlZ9TypxfYszydTO37FmVk7alAZSWCILM
 Pvzt0D0eeNv/KhxW1CbNgh0s4SACLOu+kP+NBHG8gsiDH/2tA8ezrIpogJ1e38XC3wYr
 +/mEZJ2kxdrxADV+SiyFvqLXlubb0CDfu1J35+gPzN4lowUTKo2vnwK3b7PkeDyroIf/
 vr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=1ZeZvh+Y/5GhqSEze9JV4PDzqUs6TgMApcSFco5AbC8=;
 b=uHuHwn5ElbQW8X1+pet2L+lVy9C8OFlCUH5dwK5G/3Dl6+A7Q4tosS0ASm6WjZ6/xj
 qa62WPMK6hMNk/BRdbbgtxwgcctKAs14XkVJIB/86LBiHxG/ftEbBpz5lFFr7EGthhTm
 /JwIilgBf//a16Xb2LhqYlzCkDGimljVWksVImfahrtPa6dDMnf0LRS3Wnx0w1w0663+
 Hnuo3sZ63+LDwx2yF/QVWOOpp8ej8rLnMopHHu3GrQVbNv93cZU4wbv27rQkrXYBA6Qa
 lPiK9wJkCgK4l0LECLyPNUYYZzsnplBhMbk3o5THzN/frD/fGHp0r3LyGbrYDT+Bkubf
 39BQ==
X-Gm-Message-State: AOAM533NFwfJ5P9aj1ujek45aX5iV+Hs/RFT2xjnseBamW222mjf2Qo5
 xfwoZgxM27ZjMdp2NXJt7hVNED77NsILwQ==
X-Google-Smtp-Source: ABdhPJwBw6fUgCRvWYXkUr8RF5AcTIkAYAGAsL4FDkvYjYFMccPRebZNbR1xN6emEzWHsqOjDqACIA==
X-Received: by 2002:a7b:c406:: with SMTP id k6mr2792910wmi.90.1607519878533;
 Wed, 09 Dec 2020 05:17:58 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id j7sm3159281wmb.40.2020.12.09.05.17.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:17:57 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/9] KVM: arm64: Add symbol at the beginning of each hyp
 section
Date: Wed,  9 Dec 2020 13:17:41 +0000
Message-Id: <20201209131746.85622-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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
index daa1a1da539e..65e8008da932 100644
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
+#define BEGIN_HYP_SECTION(NAME) 			\
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
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
