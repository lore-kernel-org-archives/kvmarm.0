Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479DAC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E796364FB1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E796364FB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 990D74B6A7;
	Wed, 10 Mar 2021 12:58:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FMYyuHU9GCcY; Wed, 10 Mar 2021 12:58:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CDB94B625;
	Wed, 10 Mar 2021 12:58:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9F7C4B41F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I92dpcUikwge for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:53 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7A114B62B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:52 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id a11so8533393qtd.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qkIv/Dj8eNtVWTw/hqhsYIXxQswk0/NCtZ2mXt61vt4=;
 b=Yd6qXdpHhKJCGS2nS6b73itvEp4TXHoB4WqOXle6O5tLkJBJPw/XtiPR/uKeu43swS
 2hvS/aF6Anvw1YMOPyb5/0LqiiPvfB0aL64RNhlAz42c75kMdBUkplEzK+yFBXNQ6fyQ
 J/nbBIcWvsjxT1kGPNG/ru1ol04BtoCNsl4j5yN3RA+BegfK37UCg92KsBMRdyqOwIKd
 jYHjj6ABnTFkH96MW2j3xNeVLtIeiTKy+FdXKciOBIb7A4k5eusNa3eNL2V3Pe6/NjVY
 Cfa4vxJHinlwjdhhlyquWiYMJZUzIssWJwFW9dFCLf208MYkzWGv7Z4GyP9hNnulY8Hr
 GKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qkIv/Dj8eNtVWTw/hqhsYIXxQswk0/NCtZ2mXt61vt4=;
 b=mjsswU2DF7dbjb21FWjwlWV6WIYL4PuSn7exWwr2kGWNrn3zfrcWEFUhFJ388lEITY
 5OKesbkvWluXjzMufjEsoHRa8TxCzn6h6hwPcne5Vu9CD62l48RBVBAt1u3e73Tery8o
 GfyAGX0R3UH2w+PZ+Zaa6Z9tQ66HeV4BstAO1EKDKj07wW2oEi2L0YjDRSBwLcZQJJyh
 bg00c5mxWE368PzezCvbpqIeLKZlVAzlhXTa//GjzT/Q89o2gUJIt++eJrMWrqQHLWD+
 dL+2vz9YRXLwLKm0B4swlHv0bYtpvoizhAUMNb5ezzR+8zJ3FuqW95UA69Df36lkaI40
 Exew==
X-Gm-Message-State: AOAM531qE+mNGxuHgQFA34QxlRz6jtrXWRIoIsh2AbBX79ui9LQrF38R
 fkN3L4wAy8ltuHGTLOrgMr2AY9tjcgUW
X-Google-Smtp-Source: ABdhPJxlCTx9p7rzRSKY5hPCMXHH9PbCR3/vxNwiQaM6JpLBZ/W3y1yrQSuLj+BwkUwpvNqFCqkE++nkXuKm
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:1909:: with SMTP id
 er9mr4159347qvb.5.1615399132338; Wed, 10 Mar 2021 09:58:52 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:43 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-27-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 26/34] KVM: arm64: Sort the hypervisor memblocks
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
