Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87858C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3721064F69
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3721064F69
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD8634B206;
	Mon, 15 Mar 2021 10:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYdhqEIvmyFK; Mon, 15 Mar 2021 10:36:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 007BF4B6F7;
	Mon, 15 Mar 2021 10:36:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C72A04B4F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2DY6tlsubtuG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:37 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D071C4B6A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:36 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id z17so15172454wrv.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mHH8Es+4fAlRYM4Ijk/d6yzRk425uhOb6R/MTFLjwSk=;
 b=Beq9EHGg6u02WrMXoXiha76AJgeGR2zQYFWI3RMPQJ8SJPiBDvDJ2xvMRIKmzcyAPJ
 UdkFex3yHx9cFx5yrKJXLWNvnHoy/uBfu1nZrSwaDmXrLFXBxW6+W5ed22sngMc58syG
 np+9HkZ/7pbZEUpi4AtJa4M/Z2Me18qVCq1BStpWKDzWbRrAaeBTPVklx9FMlcr7Laoy
 MRBsVtZpcer8oyNqQ3cLKBt61n9YmSymtcE8XlwMe2yekPSUedzYitLSMS7CtpGMrvpB
 /GpMCQWS/OSbMjUqtSIatqCAg86kF5c+5NCA5VM56v/rAF6/dNyEi2smxz9rtCg3Ot4Y
 0pMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mHH8Es+4fAlRYM4Ijk/d6yzRk425uhOb6R/MTFLjwSk=;
 b=Wt+cTiwYTs/nrujV3v/XQ1CSGqYGgjDjf18w5kBrnprtA/TwRzu1Vc/Jm92a06g3Fw
 GM5FXsplRHKeJJjMnDfaCTNKUwGUReh6SDVTyT+zx9/9YKSQuWjVqOBn/GlI1puOIdPr
 XxBjei0KJ4Q0bzh8oGHewUMsRhG9oaPopYe7qcwpgMiH5t7BKTQ4gi8fmWq6gp0G1ot4
 +dAwL7b5sOewgAyX9Qa5JvJY9HZc1UgON2xcqYxBtWE9AbdZJLeUtStJzRzM88ReO0bq
 PWDXSSZFtoT3Wcz04g0UoqwAZ8mUxE4mzC/AvsPGhqnnyqX4+NS5S0HhCE8FG6UtmmGz
 I4pQ==
X-Gm-Message-State: AOAM533eRAg3huF7/god9KPYFT2vTtQ5DWgmhE/skhiIt7HjFlgjoFof
 Dn1saHOVpUaef/Pkuro53UleBj2/C0OT
X-Google-Smtp-Source: ABdhPJy/rlP2MoLwwsRH3zKIividik0vk4TUyDoTo37xUZHzbmBcrMY6wwSXCy8hyEXmtWB85Uy6Tkpm2kEw
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6000:191:: with SMTP id
 p17mr20999wrx.154.1615818996079; Mon, 15 Mar 2021 07:36:36 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:27 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-28-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 27/36] KVM: arm64: Sort the hypervisor memblocks
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
