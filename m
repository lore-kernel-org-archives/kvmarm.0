Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05027C433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:17:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2EC4208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VDPMh54U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2EC4208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DFC54B23F;
	Thu,  3 Sep 2020 05:17:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PAe24ymQu7mC; Thu,  3 Sep 2020 05:17:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D327A4B21A;
	Thu,  3 Sep 2020 05:17:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7A64B210
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:17:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hb-+-nglrC0j for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 05:17:38 -0400 (EDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49DD44B20B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:17:38 -0400 (EDT)
Received: by mail-ed1-f41.google.com with SMTP id n22so1935352edt.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 02:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ks8zbpt3K53ylw0T/eWvGEXanQshe4hPX9kTva9RnTk=;
 b=VDPMh54UU9w25z4QHVBYJjPLF92rQvlDEmZh2WtnxD3Bzdp7sogs2sroU5P8Ur3FAw
 dv6ULAm2SlhYlvBSIAuPvDAxIDfiPm+Xl5qQW6TODWahjjtzYxh3+twFOVluLHMIgxz6
 w2Eh0wttggdlvWHo3aw1Rmp6MBbEUcdHEpVWstWJJH51qV9CchXfrCoAG4KXmvAEDlob
 46JIR8MQRfQ8Jfm3o1xNopn3QfNSGesPEGM2pKxNzZMTPmzwXW7dEhiRXFHJcAydDEnK
 dOqVw2ar8bKWyJY1V9CQN8WlsrUu+0XVUERIfK37nCxqpwsTFFpOaGTWPpcwdI2fGHIi
 AaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ks8zbpt3K53ylw0T/eWvGEXanQshe4hPX9kTva9RnTk=;
 b=KxNF3T7/T2ou7BVLqqx3maPXq/5qPV1FC1zLEmxXHt0O0Q7I2IWJfBndX1/YMOLktY
 Yj1WN9bPPKMug3dHe5pGH4idKm5VaNxjxPlvGlecM9ihhqoiieUZu7oU5140tqvZEb+n
 FyLxcJ/FfPe1I0Rst/ISnAcx74eqIm3ND9rCYigjiZMrPzDd8HsAPeOwczig8PGU2ZvY
 +lfpEqZi97ZgElT4u2MwHr0nMAnDeme5jruiZSEKg74116JD4UOBq/8Oq5jBwOax9niL
 n/9IThFTy0mzMMc62pP3XrvJsjwyisb+WShYH7vfepCD+kW79lLGlRXin91/PnbtRlRH
 LU2Q==
X-Gm-Message-State: AOAM531/JUFPtmcPnNMLWUqBp2MCnEOU12fVqByji+COPFc6yeKJA351
 x6xZYxTzpOKu4NQnH217O+GI6A==
X-Google-Smtp-Source: ABdhPJxWMzIchcIkSdxyCs4vGPUMhXltKg67YBEhN8oWRx/8t3VGb7k28L3pS6EUEDV05f+huINp0Q==
X-Received: by 2002:a50:f69a:: with SMTP id d26mr1970262edn.21.1599124657089; 
 Thu, 03 Sep 2020 02:17:37 -0700 (PDT)
Received: from localhost
 (dynamic-2a00-1028-919a-a06e-64ac-0036-822c-68d3.ipv6.broadband.iol.cz.
 [2a00:1028:919a:a06e:64ac:36:822c:68d3])
 by smtp.gmail.com with ESMTPSA id ot19sm2547529ejb.121.2020.09.03.02.17.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Sep 2020 02:17:36 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 01/10] Macros to override naming of percpu symbols and
 sections
Date: Thu,  3 Sep 2020 11:17:03 +0200
Message-Id: <20200903091712.46456-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903091712.46456-1-dbrazdil@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Modify generic linker script macros to generate section/symbol names for
percpu area using overridable macros. No functional changes.

This will allow arm64 linker script to define a second KVM-specific percpu
data section using the generic PERCPU_SECTION macro.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 include/asm-generic/vmlinux.lds.h | 40 +++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5430febd34be..8f3f5c45e891 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -920,6 +920,20 @@
 #define INIT_RAM_FS
 #endif
 
+/*
+ * Macros to override the naming of percpu symbols and sections.
+ * Used by arm64 linker script to define a separate percpu area for KVM.
+ */
+#define PERCPU_SECTION_BASE_NAME .data..percpu
+
+#ifndef PERCPU_SECTION_NAME
+#define PERCPU_SECTION_NAME(suffix) PERCPU_SECTION_BASE_NAME ## suffix
+#endif
+
+#ifndef PERCPU_SYMBOL_NAME
+#define PERCPU_SYMBOL_NAME(name) name
+#endif
+
 /*
  * Memory encryption operates on a page basis. Since we need to clear
  * the memory encryption mask for this section, it needs to be aligned
@@ -931,7 +945,7 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..percpu..decrypted)					\
+	*(PERCPU_SECTION_NAME(..decrypted))				\
 	. = ALIGN(PAGE_SIZE);
 #else
 #define PERCPU_DECRYPTED_SECTION
@@ -975,17 +989,17 @@
  * sharing between subsections for different purposes.
  */
 #define PERCPU_INPUT(cacheline)						\
-	__per_cpu_start = .;						\
-	*(.data..percpu..first)						\
+	PERCPU_SYMBOL_NAME(__per_cpu_start) = .;			\
+	*(PERCPU_SECTION_NAME(..first))					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..percpu..page_aligned)					\
+	*(PERCPU_SECTION_NAME(..page_aligned))				\
 	. = ALIGN(cacheline);						\
-	*(.data..percpu..read_mostly)					\
+	*(PERCPU_SECTION_NAME(..read_mostly))				\
 	. = ALIGN(cacheline);						\
-	*(.data..percpu)						\
-	*(.data..percpu..shared_aligned)				\
+	*(PERCPU_SECTION_NAME())					\
+	*(PERCPU_SECTION_NAME(..shared_aligned))			\
 	PERCPU_DECRYPTED_SECTION					\
-	__per_cpu_end = .;
+	PERCPU_SYMBOL_NAME(__per_cpu_end) = .;
 
 /**
  * PERCPU_VADDR - define output section for percpu area
@@ -1012,11 +1026,11 @@
  * address, use PERCPU_SECTION.
  */
 #define PERCPU_VADDR(cacheline, vaddr, phdr)				\
-	__per_cpu_load = .;						\
-	.data..percpu vaddr : AT(__per_cpu_load - LOAD_OFFSET) {	\
+	PERCPU_SYMBOL_NAME(__per_cpu_load) = .;				\
+	PERCPU_SECTION_NAME() vaddr : AT(PERCPU_SYMBOL_NAME(__per_cpu_load) - LOAD_OFFSET) { \
 		PERCPU_INPUT(cacheline)					\
 	} phdr								\
-	. = __per_cpu_load + SIZEOF(.data..percpu);
+	. = PERCPU_SYMBOL_NAME(__per_cpu_load) + SIZEOF(PERCPU_SECTION_NAME());
 
 /**
  * PERCPU_SECTION - define output section for percpu area, simple version
@@ -1032,8 +1046,8 @@
  */
 #define PERCPU_SECTION(cacheline)					\
 	. = ALIGN(PAGE_SIZE);						\
-	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
-		__per_cpu_load = .;					\
+	PERCPU_SECTION_NAME() : AT(ADDR(PERCPU_SECTION_NAME()) - LOAD_OFFSET) { \
+		PERCPU_SYMBOL_NAME(__per_cpu_load) = .;			\
 		PERCPU_INPUT(cacheline)					\
 	}
 
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
