Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1595C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E1A561026
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E1A561026
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B444B0DF;
	Mon, 19 Jul 2021 06:48:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c4ltXJXz-omV; Mon, 19 Jul 2021 06:48:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 053EE4B0D1;
	Mon, 19 Jul 2021 06:48:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0474A193
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BcOLabwMYXJa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:48:05 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFB774A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:04 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 d8-20020adf9c880000b0290141a87409b5so7793965wre.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CdbaQ8ErF1YpwqlK/5v4bHdri/rt0mg1VAsqwWTr/Tw=;
 b=aS8jkLkK2wa4INhA28hZzPjEUZaTZKmwenqCsFfJQTdAz0UFabdJsQo6ri3VfTWEFw
 RGYXatDhYnjA27xu0fDx7wkypb2FYIlxvf85tFl8oYsJq2rHaR4IgkQpa+q4+FwBsWna
 y/5f6F8ckCQplGSacvD6+H8TPidKSuTLdk1aFl3aPp9BvtHNW1S7YV6XGANf94XI+K92
 wG0tzBduwioFtmG8ODCJFZhpzoP2jF27+9hOe1r+E4fg0ujsayMVKVG7rMKfXMgeAsAF
 CGBfReNZE1y1Up6lw+wxGzVUgnz28Z7y6A7GjkAKvbDoo8/B1qcvnhtx5JDqVDbCH60+
 RlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CdbaQ8ErF1YpwqlK/5v4bHdri/rt0mg1VAsqwWTr/Tw=;
 b=qPqf4R5HRq8ufUJ60IuIA0gfLsQJMN3HgP9cNOwM/Z4cr0HMzoVOQbM1iH7Ck836eV
 m5Ly2d+hlWOD01drxQWziCvU0sPSJO2gHFHLZBKrVnfUEqizle10kSVf6GNUSbIgEtmm
 84E4hrQsYrJqfvAP/FkVPhc51qu8R5+YdgPhIXPBd7pbHe7UMdw8b3whRVrV1rHTcBAH
 nN0B7lcw8toSaygTXLWWvUi1uPXwuEvubeMmIus22nRDPvzAe1FFdcAEyaVbhrxdPlD9
 DHU92ftDJkpeidTq+zm611TwDTW+SOHUH59pmyWgJMVeYbQHy3vfTcbQcsMYqUYa+hvv
 mxsQ==
X-Gm-Message-State: AOAM533OD3alLyqNtWX8vzmmaKZsa+UWi64ZU9PgvP8XLFsw+zbEM7s8
 ypqfCp4E1K2u3MPbgPJkX3jjkoF9dNW6
X-Google-Smtp-Source: ABdhPJznScsyUNWBAsIAI2Jzd/ytZ2sHt95anHYybQcNiWFSnjuNiVNyg44CFTl1PSMEfVjtqavG8Cwof0vY
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a7b:ca50:: with SMTP id
 m16mr31242327wml.140.1626691683897; Mon, 19 Jul 2021 03:48:03 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:31 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-11-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 10/14] KVM: arm64: Enable retrieving protections attributes of
 PTEs
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

Introduce helper functions in the KVM stage-2 and stage-1 page-table
manipulation library allowing to retrieve the enum kvm_pgtable_prot of a
PTE. This will be useful to implement custom walkers outside of
pgtable.c.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 20 ++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 49 ++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f6d3d5c8910d..1aa49d6aabb7 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -467,4 +467,24 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  */
 int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
 				  int owner, struct kvm_mem_range *range);
+
+/**
+ * kvm_pgtable_stage2_pte_prot() - Retrieve the protection attributes of a
+ *				   stage-2 Page-Table Entry.
+ * @pte:	Page-table entry
+ *
+ * Return: protection attributes of the page-table entry in the enum
+ *	   kvm_pgtable_prot format.
+ */
+enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
+
+/**
+ * kvm_pgtable_hyp_pte_prot() - Retrieve the protection attributes of a stage-1
+ *				Page-Table Entry.
+ * @pte:	Page-table entry
+ *
+ * Return: protection attributes of the page-table entry in the enum
+ *	   kvm_pgtable_prot format.
+ */
+enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 51598b79dafc..c7120797404a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -234,6 +234,20 @@ static kvm_pte_t pte_ignored_bit_prot(enum kvm_pgtable_prot prot)
 	return FIELD_PREP(KVM_PTE_LEAF_ATTR_IGNORED, ignored_bits);
 }
 
+static enum kvm_pgtable_prot pte_read_ignored_bits_prot(kvm_pte_t pte)
+{
+	enum kvm_pgtable_prot prot = 0;
+	kvm_pte_t ignored_bits = 0;
+
+	ignored_bits = FIELD_GET(KVM_PTE_LEAF_ATTR_IGNORED, pte);
+	if (ignored_bits & BIT(1))
+		prot |= KVM_PGTABLE_STATE_BORROWED | KVM_PGTABLE_STATE_SHARED;
+	if (ignored_bits & BIT(0))
+		prot |= KVM_PGTABLE_STATE_SHARED;
+
+	return prot;
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -386,6 +400,25 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	return 0;
 }
 
+enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
+{
+	enum kvm_pgtable_prot prot = 0;
+	u32 ap;
+
+	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
+	if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
+		prot |= KVM_PGTABLE_PROT_R;
+	else if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RW)
+		prot |= KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
+
+	prot |= pte_read_ignored_bits_prot(pte);
+
+	return prot;
+}
+
 static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
 {
 	if (old == new)
@@ -588,6 +621,22 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	return 0;
 }
 
+enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
+{
+	enum kvm_pgtable_prot prot = 0;
+
+	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
+		prot |= KVM_PGTABLE_PROT_R;
+	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
+		prot |= KVM_PGTABLE_PROT_W;
+	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	prot |= pte_read_ignored_bits_prot(pte);
+
+	return prot;
+}
+
 static bool stage2_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
 {
 	if (!kvm_pte_valid(old) || !kvm_pte_valid(new))
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
