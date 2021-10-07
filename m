Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8380CC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 336DF61501
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 336DF61501
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC7194B269;
	Thu,  7 Oct 2021 19:35:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WM-ZdZTld205; Thu,  7 Oct 2021 19:35:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE314B255;
	Thu,  7 Oct 2021 19:35:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752434B1DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yr4TvMadWfSA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:35:08 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D2364B19D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:08 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 b17-20020a17090a551100b001a03bb6c4f1so2713646pji.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ii6HvMNSDW3BECmvGstwgeSfkGwZjjRRnxyRpuZ+gSA=;
 b=Z+0lI+jtnSx8SUemH3b2pgvauES0Ucd5KziWgSI89l0ig5r8XtisCnFktIPqEwwa+v
 hKDJf57FdnosDHfhcObFHEjYaQ+3t6pZCwTE85sMEcnc6JxtznxnQzFTzHOFEGbFFt4+
 N8f2bkng2JTK87mrc1T/8dLn8Kw+f2zatc65wShnQY4y09db5OpeXQTwSXscOi779xs4
 Tr2LXQqqG5+aPy8/DXYq8IubgajqT6SEfWb1n+aaNkrpwvmJwiy8aocWwQ5joTgJiyi1
 JokJlT5zZlCRa4Vmet3RO/QPrA5oMfrre19vU9zDXBwjCPuFb1XSzKtS7OR02CLfNwGx
 +tfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ii6HvMNSDW3BECmvGstwgeSfkGwZjjRRnxyRpuZ+gSA=;
 b=fWptfydgH7bNJFDAVV7fsP5cIqsvdDj/pkd2b1mI/qxyoT5yG7G7lAmpVUGDVi+sNa
 a5kLBbFn40PBGglQaqN35wrqsPy+uwcCkeUxcwnwCzLjDbbg1odh0Yhpc/yDAQYSgCqd
 WSzP1bUsGxJdy0xRTm9veTWlvd/umI6F2tY+0ba2NBNhG+vJOQS2Dmzb+z20NyP6PUtf
 hqzlf/cP4dsvPDjHDkxjRpwlht0qk8IiLNnL/SlI+5Gp9e4AH1P1dbVLtq7xOgjsFT3V
 Qa77lb0Lq2t+879PBArqkgDKMfyPXDZeR/H0PBhSmWdV3tb69sjB0+Y9xdAzcpKGF03e
 n16A==
X-Gm-Message-State: AOAM532emaCj232o4MzCyz3mCAnfeuMmq8d7RSp+AQFXRSYulTSPVxoJ
 UYM3ynDLJkWVBwW4pwxZdC3e00fFWZDM
X-Google-Smtp-Source: ABdhPJwRp5MH/8qbQoCZh65bLmby+gfdQyt8NwHGByXSBx4EmaopUZA+ULvoOqaFJ97bqMwaMnmuIlGdKs0S
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:d254:: with SMTP id
 o20mr8508742pjw.226.1633649707151; Thu, 07 Oct 2021 16:35:07 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:32 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-9-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 08/15] KVM: arm64: selftests: Add support to disable and
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
