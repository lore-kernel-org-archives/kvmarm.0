Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752BDC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12E5C60FDC
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12E5C60FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD12F4B160;
	Wed,  1 Sep 2021 17:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t2hZUqIZmgKa; Wed,  1 Sep 2021 17:14:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D195E4B1A0;
	Wed,  1 Sep 2021 17:14:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA6D4B191
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wyJmmNzq1kc6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:14:35 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7702A4B14D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:35 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 q80-20020a25d953000000b0059a45a5f834so803532ybg.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=yth3I1/Bzi0ikfWfrqGMTpl+hA4YL1ynlKPMvmODV/s=;
 b=n+Mx5PnDMeXxTqhyx09Lxlu6aOsb0KQ/uyjPoe28ripI+2Ygdz2N3UndU2pED2GvKh
 L5Pu0q87yxjRhcfWRTRdqCXBHeLJfjJdU/MxvpDVmpYrA1KsFv9DEyy6GXeA7DCFEYTR
 775EpFel2mtm1UUP6GB8R4NlDQaEInR3n8US/9dTv5bltIYL9J3FJyesrvONIvCVlNOi
 1rdkU0Po7mNSxxZMaDFzJGjU7S/lsJNQ+HZEkNtuSPkjCfhDoOiPWfrSUWl2pL7T9sDg
 gJ7U1aqZ3OsAYAGIn5lbBtPyBNAn3/NdeU4t4RO0EFzppBJ+zT++m6/Awu/y7BXwc0Z6
 ItWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yth3I1/Bzi0ikfWfrqGMTpl+hA4YL1ynlKPMvmODV/s=;
 b=tw/Cm0way6oUeB9CTpzM1I+5b10ypZDK1A6G+5op7ISg8SHSGzgFAVOdYjKhzdepGZ
 rElrh50Po2yqVA/3ER9Kk4ILXQRvsm6Kp4AG8AEjZBlcvhm3px9YozEe0VDyVZuw4kZJ
 dM/oQ0NzIUGWl0/zfcrGnwizRWwtBjwoAA4mOmkeyPBkpqxBExNDuAtJPyylKykHeB+O
 SULvYZUhnLee59eGMlmsGXLVZfhdVxIP5svLPz8dR8/rpxRI0o4x5C6T6ydOcAQQlxRJ
 aYkDagYaTPYeZ+SDLkMQAicPNkbiY6X2DMBwdTJzvARRap4eKgJO8CyjPN3GHKxVFNT2
 AC2w==
X-Gm-Message-State: AOAM53077A48gtAUTZhTAVWr4f8vDvQ5L1HhrxBbSs5e4zZJX2ryZt5M
 rBTBYUJSQbekwKIzkBYWbbecY+ElWmJr
X-Google-Smtp-Source: ABdhPJz26u67QH5f0GMtWLqojzruIAuJdhj/sKV8WtFRpAoQZS8rLzSA3x/FYnDXY1vyi7ExgKp5zhxIPX+z
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c647:: with SMTP id
 k68mr2013806ybf.349.1630530875111; Wed, 01 Sep 2021 14:14:35 -0700 (PDT)
Date: Wed,  1 Sep 2021 21:14:06 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-7-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 06/12] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
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
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 78df059dc974..c35bb7b8e870 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -241,4 +241,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
