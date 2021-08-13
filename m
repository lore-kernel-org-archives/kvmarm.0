Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D61CC4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D269061221
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D269061221
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D63B4B10B;
	Sun, 15 Aug 2021 13:01:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CX5tUS3fy30j; Sun, 15 Aug 2021 13:01:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D4E4B141;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBFF4AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m+Sr51TQYGnr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:41 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B99964B09F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:41 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 b190-20020a3767c70000b02903ca0967b842so8292954qkc.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
 b=r0k0+ikMP+nOEPjnHb3kh0VDZqt0D+H2nuLUBq14wDIIrLdIEvXnBOSas2Lnh/OyL4
 CXCi+1wjWGm+uuzR/+F4+YThArIna/irnOVVvryV+4tMHygQrOUqPqZi8WdxKxJCssC3
 GGElclHOo5x66fTisjkXmEvYKFvnK4UYX2rmblaHoaGqTnyhSr03Ife5Q1WvN/6wBlD4
 OT8YA8Le1w4fIoD/xTImcX8RrfIzUdwICHA6GscI1DM5iBC0lySuSVTjLB24pJz5dVcL
 zlwSYVMEvXdGNUEMSQLHiOeOEvpDdtEH8bg+WJBxGKBxUetDL3jnYAt9sBdzbaWmG3IB
 xXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
 b=kmvyW08hCjogEpkRl2rVDa3YweZO+twwSSqQlsfJjupLfqfjn/kOjB4SDgl6sYBxY8
 ILsfixUVwDhNjYgpbz6GTnn+nNjMv6c5Yhcl32CedcvWJ6Z9I+oFS/PXTqm0N1tBGEds
 f5aB/HKa9icGf36POlKsDihVZwMQueNdC7lMbu+wTG/OjMy3+KtGfblaNrFfvw2gl3rQ
 AKC+PsAXRV6BRgBBX2aIw9gtFj38jm3V4GwEa77Ls4vy4HJwTfYO1QGiW/DjdTZx3xk0
 lGGJ4m6TBOrr57LtXtsN+n4qHUabFsdyu5f76sjVvC4ggmXhtwrxqLPky89mAZdEOvDa
 3DgQ==
X-Gm-Message-State: AOAM533npp05dJOjFFYL79ndAQ/odyqoFHIvYFAPjGdj1yWq1OJyeorI
 ucf7A+faiJ3f6mwsGcH2QIsOAcI+RFel
X-Google-Smtp-Source: ABdhPJxjPFd/WGD8GEReOFcK3uuVRxEQIBB7zBhKOuKFdJXYU7cQwfdP28cvL37njnXSkd6SSW2+Pj0+Dz7M
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:ca2:: with SMTP id
 s2mr4551920qvs.35.1628889161419; Fri, 13 Aug 2021 14:12:41 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:07 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-7-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 06/10] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c83ff99282ed..ae7a079ae180 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -238,4 +238,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
