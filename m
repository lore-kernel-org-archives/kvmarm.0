Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1407BC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1E7C64F45
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1E7C64F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63FCF4B767;
	Fri, 19 Mar 2021 06:02:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OyZSpc1tgv1Y; Fri, 19 Mar 2021 06:02:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 357194B758;
	Fri, 19 Mar 2021 06:02:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBFBB4B6FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dYe1HRD7O+Zk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:49 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2F234B4C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:48 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id j8so4392627wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mHH8Es+4fAlRYM4Ijk/d6yzRk425uhOb6R/MTFLjwSk=;
 b=vr1Infv0oafAKH5dGXpB2sE2KyY8fi5gKOdK/ZDQg7n6l7HYp1znPMsJ1FmWo/94JK
 Q5NROR6jLJt3VR5aSfrkA1bQgIaRMhSdmz+NnIsMQwE2dBMh+UmTvRoPHnfiQhfcFwfO
 z9G0L1zluGyUR3P2Y9Us278BSXQV9tvHCSMCUC7U9+Dz8+NCRrqR7VDXPTIy2SikDRtA
 MShb5pSNk0hjVysWrq0h3cQfJ3IkNYccRfdAT0wp2B/IxAsv0xmB3VFa01XInBM+pLas
 yrCIq+xqSV7/tjVFcM7LpFeCigsmwChqVLgHmV6PzL80NVLVOsm0q6iR9o2iafDyHt49
 XRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mHH8Es+4fAlRYM4Ijk/d6yzRk425uhOb6R/MTFLjwSk=;
 b=OIYJlMpyYjUqYeOO7jCzYOVtn9IaDfEYoDOkwMWYVVgN9OnmqG12qx0pBKnJxoahGs
 Xb+5Gzbc6YBknAGtaEdlDbddTZrvP9pRmFrVloXtK4HNqnpLz2luqNRD3LT98xIn5fJY
 EFNGZCPaqzzQ+7jNy5W3ltkiwBZG/bzwVfYXl8Fi/8CHT0I9208hO5PluJzEG2FqWXyG
 W3wUqv5/AnXUJJDzqaWkW7u9mNmNASPYY7+2OnpJHkg/4djtivHTgWe45sbr90yMZwyz
 eanIHUmefY0T+hit4rXDtTN44fGMiFVyt2IokX0qcwhOjh0Pu7v0ezcQ8JGr3VsKEECe
 JWBA==
X-Gm-Message-State: AOAM5336ZBOzEngbFtuEjCpqqUvdswAWWfzOl/s1EkRlEcfQbAYSx/uX
 Dhad77mNz5v/CLM98OgieTxfeH/K3XLE
X-Google-Smtp-Source: ABdhPJzSR52Pj+HsbOVVMC9NAbeAqKThSCb8Keh7yqOgsfK429inen/RmXXGyNghUdwdJ/4G7ZtObPiBgE+k
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:b70b:: with SMTP id
 h11mr2955172wmf.10.1616148167410; Fri, 19 Mar 2021 03:02:47 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:35 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-28-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 27/38] KVM: arm64: Sort the hypervisor memblocks
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

We will soon need to check if a Physical Address belongs to a memblock
at EL2, so make sure to sort them so this can be done efficiently.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/reserved_mem.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index fd42705a3c26..83ca23ac259b 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/memblock.h>
+#include <linux/sort.h>
 
 #include <asm/kvm_host.h>
 
@@ -18,6 +19,23 @@ static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
 phys_addr_t hyp_mem_base;
 phys_addr_t hyp_mem_size;
 
+static int cmp_hyp_memblock(const void *p1, const void *p2)
+{
+	const struct memblock_region *r1 = p1;
+	const struct memblock_region *r2 = p2;
+
+	return r1->base < r2->base ? -1 : (r1->base > r2->base);
+}
+
+static void __init sort_memblock_regions(void)
+{
+	sort(hyp_memory,
+	     *hyp_memblock_nr_ptr,
+	     sizeof(struct memblock_region),
+	     cmp_hyp_memblock,
+	     NULL);
+}
+
 static int __init register_memblock_regions(void)
 {
 	struct memblock_region *reg;
@@ -29,6 +47,7 @@ static int __init register_memblock_regions(void)
 		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
 		(*hyp_memblock_nr_ptr)++;
 	}
+	sort_memblock_regions();
 
 	return 0;
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
