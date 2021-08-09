Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4C9C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D9816101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D9816101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EDBB4A319;
	Mon,  9 Aug 2021 11:25:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 41QGVobE1a0X; Mon,  9 Aug 2021 11:25:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DE44A4E5;
	Mon,  9 Aug 2021 11:25:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA51140569
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 80L9jD05JKBo for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:01 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D02C74A319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:00 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id
 kf21-20020a17090776d5b02905af6ad96f02so911512ejc.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GMZNfzuPpqQplgJREqrbVT8SGjVRH/ICHDZ3APociKw=;
 b=UHGjFJ88t++uDbi+ho+q/XdFtIa+W/7vj7rOtKa5ztsftv96V3hJF8oNqfWIZeOQaL
 aUP+VWMsxv/Ww6yCE/11VKrtsrFRo4r1jE9zZCcHCxeW4QTXs3Hf0eg59+DEpi0AsG9+
 pQpwB2Zfd62iUZFWqRr7WkBLq6/W/YQO57q79BUO2PTtMUj5uiQIu4UTW0GFsdzup9UE
 9v9sMuWxhogJDOCknqN7ch+GClEeK3D78t6XMjW2bjoowOIRZuE8PbSwxbSu3F3AkfXj
 J5a/V4E7m6hSw9dq9XYFJeT/AzeYnLZo6tEmPEs60tS9JdK639KAKwpr/ZkQ/mj98px6
 3hRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GMZNfzuPpqQplgJREqrbVT8SGjVRH/ICHDZ3APociKw=;
 b=IcnmUPTibYCV5zssJr16GmqwwO0ez5bGBDws4t7+APb0hHZN4pG2uuBenA0bLEmVAZ
 RHBhc4C7bvORoZX7L3vnCIaDnkbjilcavngdM6rDi4mL29glr8/gKFMnKgAMYLOW53tW
 fET0CWleHx6YFN9auzRUJ+GnCF1zeUSyVDiLCf+dSPq6vBfQkiOw2uy3/raMTezordQQ
 NqJ5ANS57uXncp73wKjF6FfKQV6PH1JGKZTKbBFS6vB9y8XFuatpgsQnsKxtM7ChHdis
 gnrWjVtaSF9mQkFgBQj5BuECeDRWYOCf45gW64dsXLHpVELgXQ9AZ44uhXhvgy4VUzZo
 Rx2w==
X-Gm-Message-State: AOAM533DE8UMZVKfMzWFmmCXmuyBiAbDIXfJGJmrXZQNfo+wtwf6IjxO
 k2rePUThiKMXaBxoy9IQKBqOTsqsrlP1
X-Google-Smtp-Source: ABdhPJyqzY0L1dCaL3AwOH4Fm7LMkYjK+OM+7knyOMrkv2ibGaXiqJGzChD13pqf4rXPj/gIvGULi/3nex3K
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:aa7:d899:: with SMTP id
 u25mr30548023edq.151.1628522699812; Mon, 09 Aug 2021 08:24:59 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:31 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-5-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 04/21] KVM: arm64: Introduce helper to retrieve a PTE and
 its level
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

From: Marc Zyngier <maz@kernel.org>

It is becoming a common need to fetch the PTE for a given address
together with its level. Add such a helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 39 ++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f004c0115d89..082b9d65f40b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -432,6 +432,25 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker);
 
+/**
+ * kvm_pgtable_get_leaf() - Walk a page-table and retrieve the leaf entry
+ *			    with its level.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
+ * @addr:	Input address for the start of the walk.
+ * @ptep:	Pointer to storage for the retrieved PTE.
+ * @level:	Pointer to storage for the level of the retrieved PTE.
+ *
+ * The offset of @addr within a page is ignored.
+ *
+ * The walker will walk the page-table entries corresponding to the input
+ * address specified, retrieving the leaf corresponding to this address.
+ * Invalid entries are treated as leaf entries.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
+			 kvm_pte_t *ptep, u32 *level);
+
 /**
  * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
  *				     Addresses with compatible permission
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 05321f4165e3..78f36bd5df6c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -326,6 +326,45 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return _kvm_pgtable_walk(&walk_data);
 }
 
+struct leaf_walk_data {
+	kvm_pte_t	pte;
+	u32		level;
+};
+
+static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+		       enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	struct leaf_walk_data *data = arg;
+
+	data->pte   = *ptep;
+	data->level = level;
+
+	return 0;
+}
+
+int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
+			 kvm_pte_t *ptep, u32 *level)
+{
+	struct leaf_walk_data data;
+	struct kvm_pgtable_walker walker = {
+		.cb	= leaf_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &data,
+	};
+	int ret;
+
+	ret = kvm_pgtable_walk(pgt, ALIGN_DOWN(addr, PAGE_SIZE),
+			       PAGE_SIZE, &walker);
+	if (!ret) {
+		if (ptep)
+			*ptep  = data.pte;
+		if (level)
+			*level = data.level;
+	}
+
+	return ret;
+}
+
 struct hyp_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
