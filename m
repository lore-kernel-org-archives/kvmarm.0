Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E965DC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9AB5A61106
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9AB5A61106
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4504A19A;
	Mon, 13 Sep 2021 16:50:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MZmGGYj1A5gR; Mon, 13 Sep 2021 16:50:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6CA4B209;
	Mon, 13 Sep 2021 16:50:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECA5D4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:50:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uuGPqo3rqMLK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 16:50:02 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E0F84B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:50:01 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 i77-20020a25d150000000b005b1d20152b0so1406144ybg.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 13:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
 b=dkwAaN+LMm6q6/tB7urEEM/7txHMfCp1yhEmH8oTSSC5G1JbBVb95On7HExWMTLTlN
 3cXIoUFeGGMdfRQC4MNL7aP9VmrS4Fe+eHCP7yUL3arzSTlYuO8akfR5jS0vUHa7XXNA
 3OI8KyIk+mslCm7yPV1vhpfiA/Ba9h1lX5egHL2gxptQ2ch9lVlH+5iOx9HcJANmNn32
 rjz3vqIGy74jr984zD9uo9pXVr1CgydnPYgm1WnRKZ3FbdPGQyp5KCekA4D+3BtGI81G
 d6f8N2lvxT7WcHx/Otrt+PGPOnGMo6ISulk/Xzs+W71PNknHOah1LkDcX/gX9orguSK4
 vHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
 b=Wdxpbncf/SVN7/GGsOv51zuiiF1IQuTig5TQLdJsalkYGXktEdMadDptN7+4zFqzM9
 lhyWLn8mDmsfxN56cZRqDaajSlWb7fVzng0z+Cpts0Od10nS+wiAKyVFpQVe3CXqnOVu
 YxvokoptnsXH7dSxCB3TdRG7GXp7KQXEBQDKVaBKkG7aYDh1kWLF3jqebyJxVVwBOz0D
 rrQtIzF+BfPu2ZuCy6Fqo5KfBmDLVlE48fQOMJbhA1JCEuj8Bi0qojG1K50qOVxGNSAt
 yjdWWPy6UFs/UPiyfADVdR0hVcR9+2mS0w7CvtUnVZwdyI2MpVoM6NsrVDfoCmADjoOj
 IhdA==
X-Gm-Message-State: AOAM531SedUd0QQSu4tc581yWZ4cjz8+UB8XS4FCCed0ykU9yIyvSJRH
 FKGs5pU8ZHfjrTx/dSjKSiYMKSqAz3qy
X-Google-Smtp-Source: ABdhPJx7o2pSPQVSa/VQZq1XUtFrn7ZyngcYvhLBDeiBG0SA9xzMD53Z15pr27SHTsOPEN6MGy9A8rGlE4Tx
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:7146:: with SMTP id
 m67mr18421920ybc.353.1631566200594; Mon, 13 Sep 2021 13:50:00 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:49:24 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-9-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 08/14] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 265054c24481..515d04a3c27d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -172,4 +172,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
 #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
 #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
 
+static inline void local_irq_enable(void)
+{
+	asm volatile("msr daifclr, #3" : : : "memory");
+}
+
+static inline void local_irq_disable(void)
+{
+	asm volatile("msr daifset, #3" : : : "memory");
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
