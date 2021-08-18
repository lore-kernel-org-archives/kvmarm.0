Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8053C4320E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75AFC610FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 75AFC610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B1964A523;
	Wed, 18 Aug 2021 16:00:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QosybWWQjoKK; Wed, 18 Aug 2021 16:00:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4EC14B105;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0125407EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id izdl2oYhZNbL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:31 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F131B400D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:30 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 135-20020a63058d0000b029023cdca61836so1959255pgf.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
 b=M4v7edVYyKBY+V84oWDNulNY+yx4Uze2wbZlUXRS2Aln9eqOffhXiBXP5DqvkJiSS6
 ixVqUwuDxfj3hQwR3DyYk3Rg1Es+zp4/+Bndw5JEEMqIa2SqRk9ViwSiUkA2wFuFM5xB
 EDVY79ZV26X/y44fJVpZSzHM0O24OQkHsMiGP5NVaAgMOxCNwyzeNlaj98UnYeNLSiVV
 3NPTU3nkl3+FXba1M7nb9zipmihuU6BPali7X4+fro6+nVTtq7oJkwx3jU0X53Bb+xsz
 zfnz4UOTYUCfp5iGx6vwnuOZu6kevvHSd+WSbDX4FYIDV6ERrruszwVx7V3PRnFU8XAO
 Dyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
 b=gZBkppt3k1xacs5v1wTuSi0wvyBnHpmqCPH3PdDe17Oq3CgYr8E9o58X7deePF6cF0
 FAiv6HIZzwohfpJCAweUfZfN1S08drSE10Bu5LUNTUri1SLaed8uB/kuX+x73TvaW8kN
 FtTTU+Wu6pFyezwi7zIKNrCAf4n0u3gPfrrh2LmhWmuHPILx3LP0/4I6697SZwerPyXJ
 SxlPBgtJ0tVX/nUNJnHHv/R4L7djG4MrHjcCFrrkwtzMFoivyPKyHmqXrqLSi1EU+lGm
 jq7C5MiT7Huwz0kIgRchu4JWMVDunrIOTR7BW21DFKQcFlXQWeomOxFOjpMUxwYzHegU
 wrPw==
X-Gm-Message-State: AOAM533uM3RDHGvcCz/xP4xpc6e6h6Vobb5y3A3rKL/r4zBR1Gd+SZ0n
 KA+9+80Wl8F9E+IWcECdo75aVe0XhnN3
X-Google-Smtp-Source: ABdhPJwYcXARLYf9x4AaQrRYJ8sgbNkV+MLILfJmXoYMtcvFdw4v4vbdtvvWUMKaPFR8/UlVv8HOd2W4xggq
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:e850:b0:12d:91c6:1cd with SMTP id
 t16-20020a170902e85000b0012d91c601cdmr8429954plg.16.1629312210095; Wed, 18
 Aug 2021 11:43:30 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:07 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-7-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 06/10] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
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
