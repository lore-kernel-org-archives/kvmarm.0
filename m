Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA114C432BE
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46BC961244
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 46BC961244
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4AA4B153;
	Sun, 15 Aug 2021 13:01:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eAj9q6tNCnkC; Sun, 15 Aug 2021 13:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 761FE4B130;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25A434B09F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id orB0x5OrpmFY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:29 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4780F49FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:29 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 i32-20020a25b2200000b02904ed415d9d84so10409270ybj.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
 b=LJO5U00ZjaOZ215Q3zQBNAPbMmqLU4kJbRYeMS0C3oR9Q0pS36G9P72tHYnL9f1TmL
 eYQtnM3qkeMEicbovSeP50ZrM2B4Np2JYkPEvunq2dUIfENdFZ6WwmmWce5QmsnmA5Yq
 uRyfhUD58L5wJfyrxi+LZwfuf8b0+BGTDjTkWEkbvgyPao9BFLbHpzjXr7ZcRY/OJuWb
 yR3u7arud7z7b3q+ApZGI0ojHzeCHi9oNV9STxe2ldebvsT5G3mTIDv/VRIxQ5AwvJoF
 mDMepVoQek8NI1KclrY1V+3lfCc823x0+5eK1b/OJvdkyXV7fz/7wW60yRevcXCZr7VG
 0/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
 b=XdQ/YVKuekG1qUIQ1riOpdzvfvmZTgHmnxMxnNr+KF7A8ttaQbLxwUWJZQB3YVs7Mk
 3gJECf/41k0+X6HI7NDocWGypNEbO+38MRnCNruy6r+L3SIeelXzTiI3eO1eEWZg1Unv
 5pdDhXmQ36EOfSgrpcAmkC0MhlPlymBeoCNYSXhkaknqIh3kjPPcSibn/YLrujK0Yqvr
 M81V5odj8NKD2wfRLGBUysO3c4HI2xTiLUiMvb36AWF+9aZjtT1gdfSCYnS53ldIhAPE
 hMAL5kqE6X+lWVXhLsd8lRkzd8RCXge76L5nsRH11BMu70LDm7svRUyqloPFF68A9qVO
 bkqg==
X-Gm-Message-State: AOAM533MZK9FUesRsPze5t+SfJxK7YNvUsItK4EOEvOVtYVv0vabFD9b
 A719CvVevaadz3TH2elNUDh6hCvGgb/S
X-Google-Smtp-Source: ABdhPJxmtYDI1q+46n5THoeKsu7C2PelKcdfRaw5GLTlL9837eljYe1WdU4FvJftPG+amvHn+6hOD64bw2YW
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:25ce:: with SMTP id
 l197mr5713620ybl.255.1628889148791; Fri, 13 Aug 2021 14:12:28 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:02 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-2-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 01/10] KVM: arm64: selftests: Add MMIO readl/writel support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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

Define the readl() and writel() functions for the guests to
access (4-byte) the MMIO region.

The routines, and their dependents, are inspired from the kernel's
arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 27dc5c2e56b9..14f68bf55036 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -127,6 +127,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 	val;								  \
 })
 
-#define isb()	asm volatile("isb" : : : "memory")
+#define isb()		asm volatile("isb" : : : "memory")
+#define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
+#define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
+
+#define dma_wmb()	dmb(oshst)
+#define __iowmb()	dma_wmb()
+
+#define dma_rmb()	dmb(oshld)
+
+#define __iormb(v)							\
+({									\
+	unsigned long tmp;						\
+									\
+	dma_rmb();							\
+									\
+	/*								\
+	 * Courtesy of arch/arm64/include/asm/io.h:			\
+	 * Create a dummy control dependency from the IO read to any	\
+	 * later instructions. This ensures that a subsequent call	\
+	 * to udelay() will be ordered due to the ISB in __delay().	\
+	 */								\
+	asm volatile("eor	%0, %1, %1\n"				\
+		     "cbnz	%0, ."					\
+		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
+		     : "memory");					\
+})
+
+static __always_inline void __raw_writel(u32 val, volatile void *addr)
+{
+	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
+}
+
+static __always_inline u32 __raw_readl(const volatile void *addr)
+{
+	u32 val;
+	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+#define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
+#define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })
+
+#define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
+#define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
