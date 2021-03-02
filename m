Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F493C433E9
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCF1564F3A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCF1564F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E1BD4B60A;
	Tue,  2 Mar 2021 10:01:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yPbThMc4-aDI; Tue,  2 Mar 2021 10:01:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F00E04B692;
	Tue,  2 Mar 2021 10:01:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C74E74B68E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6qeA9zb6z3nb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:01:03 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D66564B508
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:03 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id t19so2546155qta.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=0DGi8WZ41csXemjNsmACrndajQddZ4pCIIm4i2MnuBE=;
 b=NE6Q1GAgjfYI2WSnlZK6ccjnYEU6vpTfApOHpsJa8pc8twhDpFxuOBo32r89W8t2Kc
 YIB2XzSRTuyKBC2SBUZYIpJ7X4Lwzup0jJUpmkpiEcqkF3y7b0xBe/fYkbHGMCWJVaUl
 +pZoQqqiNkX+eDaJA/FSLnqVZb4bFe+3fBD3LjgG7dXQpUDq1BampNoAf4Yqpv6jDuu2
 qsKdLOcxfPInMZ+6hngaTT3gdvCEg2NqfDhIB467NAn1rkMN9qG1UhjNDSuKBp35gTvX
 Z0FQb+JQ83j4h0wmWUQ5CY9BbZ2yBx+w4CwV0O68SlSrz6GTdXVcdwtswSt+dQHcseV+
 WnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0DGi8WZ41csXemjNsmACrndajQddZ4pCIIm4i2MnuBE=;
 b=S0jaa1t8l0plqbSBklwUVlKmqkAn00wcTQahiJn2GkHehmGJOVelgjP6E2VZEzlm6G
 0WHAwedIIxcW4L+mdNS6YNi+h1OcqM2A3VS89eVbeBZFXyxpVD3LJt7OTSs9EpIAISus
 LIg2c/vOHMHkEI1QvCkk4IWSPFBVitZ/3qymxEEvvWf5wOyDTDsmJ3w2cPBkhU80DlFO
 WYhbLPBJBZCmHdgXKGw2pEgak1QdLdqtfuhQDr0qCT4eRvnc0aW1vuFqI5SpDBRyhyzQ
 EubEMVc+O4E+ZFT4Gdzi17NDj116TC8JgE3cR7Ow2Ai95cqF633QTPjLu9Yn5ds3jLXc
 y2wA==
X-Gm-Message-State: AOAM532E6Bptt17YYZccVTqVaIxqVrQGIteHsE/6rfppbEdGtmVfAJOz
 xyUmNORGacXmq0H4QDkOO95qxIY/hp0w
X-Google-Smtp-Source: ABdhPJxW29HrCwNVsnKe95k20fj29Sf36Q0W3cKnVBDqrtxU2VNcdgoeoSV78CPoA72FRV1PB5O9++BrTYke
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:ed45:: with SMTP id
 v5mr19863045qvq.13.1614697263353; Tue, 02 Mar 2021 07:01:03 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:55 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-26-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 25/32] KVM: arm64: Sort the hypervisor memblocks
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
