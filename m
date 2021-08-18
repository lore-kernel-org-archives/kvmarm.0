Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95311C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 344CD610FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 344CD610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD6C64A1AF;
	Wed, 18 Aug 2021 16:00:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7z19wFY6c9oV; Wed, 18 Aug 2021 15:59:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E7C34B0F0;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4941B400D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7D2ztX7LmZoW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:20 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4256440162
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:20 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 o3-20020a625a030000b02903c9ba4d8a70so1780767pfb.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
 b=KyWRMVB2YjHXSj3SrlXBQ1vUcQjS4upaB1ecKlUekeQMP3aw4uhnG6uXijlPT/31ui
 Z28ax39JzZAx1Z7J8FJei5MIVv98GH6r7vIQCEG3PfaFCvB4WEuqVRxab5ga+fSTQmeY
 j5QUx4OUcKTj4AdUaQMpWPvrugwRMTrM64LTE1De5ouxE5IHLW5fPrrULhaBEHdcoHGo
 hmbDITScovX72Zyu4nY8lVbvpgAGK8k1T0EtpyvDMXvLOlNKXz+0BX/BgPjyaT1zNHnT
 rqsSfheHhwSn27ZcOd/7GIFehJ32fm81DLLxjUIGrGL2qdhydKSCw30/2SGJncJylHge
 2juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
 b=U1KG2rSFJG0X3mcyzaSaGXdC50uAOcJgB5dY3u9T3W9mshsXHbfz39UcIfnkOMOfg0
 TZLYnykL9JANIYuZCNs2Ojz0xt/Mc4Bh/lzgyOnBmcpIXZkovvPiugoGGb0ZQr6O8zmm
 rw167eqO+buYsl9/P1Zgms0A6ybXITRraPSRQ7A4DxNjNJsY9bCS2LbHxDVDKZvbLYYy
 GK9ZHavrdB7AKHLrMKEkGJCk39s4GFFkbwmql/0/Z+cougnz4tvtBiXAWGna8eLlK4nj
 dd5YIarBbLVwtE9IeqHS91HBjrHP91M71uvN/OHM3U1Lh1zT+2vTup8LGAKlPZdVMsi1
 ddAw==
X-Gm-Message-State: AOAM532/Va1ynAN+LKir96wTN4JG0SUmxEoZzUXoYr90LszhTyTdRNHU
 Ku/5PHZbHZRuiuzc3fi8EecMKzZsYip2
X-Google-Smtp-Source: ABdhPJwpulpudlfIiB7CO8SfhZeZ9mfxxExEhDLOhAm5IzLeR7emCgSi+C7ROeGvaAWlJ6EMz8iciBV4Xt6V
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:396:: with SMTP id
 ga22mr92005pjb.0.1629312198788; Wed, 18 Aug 2021 11:43:18 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:02 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-2-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 01/10] KVM: arm64: selftests: Add MMIO readl/writel support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
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
