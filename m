Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA231C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8EC9D206F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="l8EUVZgC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EC9D206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46E124B2AA;
	Wed, 22 Jul 2020 12:45:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q4PVQBYtZhLf; Wed, 22 Jul 2020 12:45:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD594B297;
	Wed, 22 Jul 2020 12:45:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276164B2A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WH91y+gyPFAl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:45:02 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1331E4B2A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:02 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id 9so2505243wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 09:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=6iEzS/K7FKWZpD3ua8htStuWzJAGtakSYjlBsBpxZ/4=;
 b=l8EUVZgCpIRU1QL7F3sHnMulBx+ndcr+hiyAH/9TDLEfZ3e4nRnvYcMRlw8pJ1RZDD
 usP3/tJ/orr9olI8t2Qx+Sj/5tEnhSWSaxwGyGsDcxf+AzwpzLvAQgo1GARi5BT9Pose
 fSVvL492qfWaMefMcn5RNZm4KMBSxUa2R4mITHBHTG4G42tVvAyz5XC8X1EHjDPKKVTC
 gnO+1g9xzqhkqboMF9feb+jULlJjKVO8BTsdu5IB3Jql+dhjkP+s/fUtYQxamWeUqX3k
 YELPwGsw80aBmerABn4F7VHRlZuY5XWbtJqzVum5e1OoTgXIAeaBwQQFl2H3zHD4YBs6
 8Exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6iEzS/K7FKWZpD3ua8htStuWzJAGtakSYjlBsBpxZ/4=;
 b=MtrDBpPLQs6uT7rC3KE//ouugCAFDWwy9vVNV01jepuHxZzfOFQat3b+yNFrHFOoAb
 Swp8opsk4L7d7qZaEEzUXu1yMuMSFAzZYl4nNQFHKdD2x5oaiLe7JnswKHQKSrChBVv6
 gqh5ODd/9aelL+x2P/nzwGN92THqdZbWf6J5YVP9Fb2K7nYzxkkeEgS5jw7jh1BfW6SA
 j8vMkTMK+voa+LAFz6MIz7S02hAm5+RTH2NifYo9SShkca68xEVY3mF6eVQGS/zm5rvU
 pfMccoVPONc0OQYnp7ZzsBEiPczk8We3PDEhpLHa0lEu7ISndlRmvVCP7bx5Y5KgxWQy
 Zp2A==
X-Gm-Message-State: AOAM532HhcJsBk8+L55nYaBJRW2AHgHr0CubYlkuP6ctdfKbf7j4MMAz
 jaw1YTwpv76HUFpFc5GUmI9BLw==
X-Google-Smtp-Source: ABdhPJyvvcrdUvKbE/hxCmWbSibjaaJ7nEtZ3HDL894GJKBpxshjcuwx5vl2E/hVxnCbvqkXRidabQ==
X-Received: by 2002:a1c:a756:: with SMTP id q83mr457233wme.168.1595436300851; 
 Wed, 22 Jul 2020 09:45:00 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b0ee:900a:e004:b9d0])
 by smtp.gmail.com with ESMTPSA id u20sm265826wmm.15.2020.07.22.09.44.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jul 2020 09:45:00 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/9] Macros to override naming of percpu symbols and sections
Date: Wed, 22 Jul 2020 17:44:16 +0100
Message-Id: <20200722164424.42225-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200722164424.42225-1-dbrazdil@google.com>
References: <20200722164424.42225-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@google.com, kvmarm@lists.cs.columbia.edu,
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
index db600ef218d7..1bfc002ecfce 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -892,6 +892,20 @@
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
@@ -903,7 +917,7 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..percpu..decrypted)					\
+	*(PERCPU_SECTION_NAME(..decrypted))				\
 	. = ALIGN(PAGE_SIZE);
 #else
 #define PERCPU_DECRYPTED_SECTION
@@ -947,17 +961,17 @@
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
@@ -984,11 +998,11 @@
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
@@ -1004,8 +1018,8 @@
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
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
