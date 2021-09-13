Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF7DC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C1166113B
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C1166113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4D304B215;
	Mon, 13 Sep 2021 19:10:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l4ZRQZE5Tp6D; Mon, 13 Sep 2021 19:10:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7354B1F4;
	Mon, 13 Sep 2021 19:10:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 922D44B212
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FmVMoPXGAddp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 19:10:20 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F8074B222
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:19 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 a22-20020ac86116000000b002a1463f30ddso57813676qtm.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
 b=DNkbp/sqJ7JxIvPqWv1ccqgt18UNr/1F5XiXnLeubqboraLkX5zaOi5Y9u+dmJkNxD
 5Jx8B7jRUF8KPPuuLbDtxtU3wcNdxfelulEqIFT9UGvhK/RcZ0SmaE6MhFDsTdh432bu
 1rmsvCUZ07vzLQpkhiW4MGccfZPXlQ/K3TK6KGTP7hexs1mQjzYIQeJMu65H10YvUID0
 LB1gvoLPjtnO1R25IEC+6GXtKzS9NajXeNsAsGbMbEpDzFE6GT5IOyCPA5lH+CYBTzRb
 Jv1YRL4hzPZkCOi78vCwUYYYZ66OUXkW6k0450vgVMQjYDJ6DqSMiOhNJIfHtNhd5dGw
 GZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
 b=l/fx/sfmaOyQhtQrdS8zqSVai06LpEZKeoI6DSckt7M9uI9XczjveJ1cWCwgNS64Bh
 /TPFbP0HnAer+oc+EMmv2wKYk+bDNmoHJTWHuXgRZ3zYCe2E+TeLdyV5NAy/kECxab5X
 u9KLoQJ7q9ZPia+ApeJjTzvyyW2zyiZM1iF6cXiVNGhDtiGm742rTWJbTf0JtP6apdsa
 +fk8fSJu4yWQe6ucd9i9UQzYJFGmj91EdqKQ1IzxkOWTEVQsVgjyPMPbe3qBAyfSNJRw
 k0q416Rpde04AELd9YGxdzeAWK/Ssc/TzmOvC5QnoYjkSIxsaFRwhZWg3Wr5O/P1Ta9a
 HL1g==
X-Gm-Message-State: AOAM530rxt6YnzO/oKEgurx72/bCK6QAlF0WDjeFQ1xKsejRiFmnVQSW
 yv3ih+zqCEG38QEf5BIoQpcpYmIEzXRb
X-Google-Smtp-Source: ABdhPJziLpu27fJWsU3sVkITkceR26u6rR5Y64vk/3J+BiXXBYz7MRm7l9Do6/o6LTGAZ3FTVFMfj0dfAm9D
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0c:db0a:: with SMTP id
 d10mr2288345qvk.28.1631574619217; Mon, 13 Sep 2021 16:10:19 -0700 (PDT)
Date: Mon, 13 Sep 2021 23:09:49 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-9-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 08/14] KVM: arm64: selftests: Add support to disable and
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
