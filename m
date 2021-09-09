Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8777C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 964476117A
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 964476117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CA7C4B090;
	Wed,  8 Sep 2021 21:38:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W9J2QMIv+zDI; Wed,  8 Sep 2021 21:38:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7C54B0D9;
	Wed,  8 Sep 2021 21:38:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D56AE4A524
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 08kjg1U92mp0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:45 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5DB14A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:44 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 g192-20020a25dbc9000000b0059bd2958c8aso426994ybf.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=joYYrt7hpuPfUeQcd44dEnmpKJRkC3m+olCPcRklPKY=;
 b=FmT4tXPeRDgw2DsrBZpZGU6PcjTlqMTB9wZqCZm9tFBuL4YGumdgIw8m9nJpGy7K2o
 QYsOw8LRgRYm95W4lSQlPjO7sHUsJHvmCf//Z9HkzC5WFE0ltOxtgtruZBHWU5+lyW8d
 tyISweHmsA2pL8jnZ1XopsISmcAGv1TGUh3i1sOmjVR+89zSpnjVbubTD5YxqU6axujR
 iC5Bo6uEchxMhU7sTZonLg1PKJy5nk4TN+T3O3lRQY+zvf8akm5MfKalvVWOHQh+ZZZh
 xa6NDR8lw9UzwQzVVyNZ4oE7mAM9CccSUMU4oq2kLeew6YO2bKG9NmIZqb2LZBM5sUaT
 cSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=joYYrt7hpuPfUeQcd44dEnmpKJRkC3m+olCPcRklPKY=;
 b=vA77bwqp4FXRefULLWnrI2KAD3oTe2TNsxrcS+wfu13fWnvokz9VN6SiAqUXmuqXMY
 L/OQghx48MKf4YtHX6dzaxopN90VdpwdFFI3Gd99Os/WNYtdHmdIeuZOIcroRMpBdIUQ
 2mHCO8+haZ7zc4Io3aSS1ZD/23x3x9w1iBC5q3FX86vt7IEDIDSZDmIhHvH/V1oNDpez
 hxevFpZdjEdl+YBsouLXnKxCTU76R0dqlP+fuxhgKgA2t+ofp+GeODyNKVHHBqfVXecU
 tyTLxLJ3pMew9dV6pGhUeiTuAcO2iMfGZxkhdYNu7lW7HWkVCWits977Eriy18pbfmYu
 MEjg==
X-Gm-Message-State: AOAM533emC/qL60bU9/jGtBA4oCCMzUxKdwgP7ibloXKxqGHLxLZs+Mk
 JrjWjRi942VNRzsOmBR1RdL7+ZK3/pmj
X-Google-Smtp-Source: ABdhPJwFC/OW1Z5F2EdPKG+1rynUG9GSXEW3pl0UpRo9goR7t0bNT4MLjGR/06vsJCUHuxOMHJCWVlVpiEKi
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:3894:: with SMTP id
 f142mr565481yba.464.1631151524424; Wed, 08 Sep 2021 18:38:44 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:08 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-9-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 08/18] KVM: arm64: selftests: Add support to disable and
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
index 166d273ad715..b6088c3c67a3 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -184,4 +184,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
