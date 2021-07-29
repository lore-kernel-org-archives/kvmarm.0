Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7206C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F75160F23
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5F75160F23
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 161E340256;
	Thu, 29 Jul 2021 09:28:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5edFw2frbNZy; Thu, 29 Jul 2021 09:28:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09CAD4B0D6;
	Thu, 29 Jul 2021 09:28:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2285F4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U9M2T40aOyKU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:34 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D52894B0B7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:32 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 c5-20020adfed850000b02901537ecbecc6so2224380wro.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Gjf1jLwbr60oU/lDUo56+HNoAVcvWGbxZryQe2MxgVI=;
 b=liAJ/B9k752zaUtEr2dNmyI6PNIq95D2uxyTofIPP2Y9x50NOXw4/JT8oVxsLvIkmc
 P7ulUWGLvyLx+t+fWD8rdAsH4RvIVZHUhm9AOhec5RvozMBkX+zZj7nLaIAXqPqIyTGm
 qMSgBtOd1z4GkgAg8Aq2iTh9+h3RRsOREBBjibJ8VnR4P30ZOtFv7y65TudPffgn0bRg
 RznpmwquKro9JhqASPV8OQxONr9moaG80DsU8VJsjXcHn5Yyqn3qHvtX9DT4MJ6bUy36
 iuW7lgbeDizByaPiTm3DcjyGsmrR4gr7L+ezKHNRzsImGGj1FE1SjSaaY2EcjvFz2eYA
 lr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Gjf1jLwbr60oU/lDUo56+HNoAVcvWGbxZryQe2MxgVI=;
 b=QuWr97y+NcIHXGuvzrXp34EtSUoEKpDx++TRtSMEQA00XKsM16U2VLdxHoOFnkSrvW
 GCll5pZ7vL7+WNVHw60CIVBdyr9y4rT8cWfdKLSn9gFnHKd6gQD0b02/QOuTM3fuX55o
 iJbaRs8jg3YptvCX8RDgynY4FSAl/mP3ymYcI1uCoO7g2TnwnETSK95zjR2snVALAYLw
 eltHxYBY9SUeInDFE+8OSMaoMNZhAXLZNyEBlckOh8m37oEF1s+8uNyVFVAuFxC6JBw8
 fH4lOBcfBm0SeKF5FIJ373ItToyIKlZuEFMbcDr8MZ6N9ogLzSXVsZkucFRjjc9yRtG7
 0uZg==
X-Gm-Message-State: AOAM531GeiFkVj8s7mKVUqfNk7VYhotw8t2E/bmYCsPDZ3ZbfxbDfnr5
 nuXKYWar6M8E/FNkg7hzq5TsUmavjALU
X-Google-Smtp-Source: ABdhPJyC7oJeo9hm9rZKLPbAlJuErb6lfSMGOtMtJPYFP3+ud7lcAhFVhw7sxxXnSC8c2pWtkaZZ9KzshhQh
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a7b:c147:: with SMTP id
 z7mr4842725wmi.10.1627565311894; Thu, 29 Jul 2021 06:28:31 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:01 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-5-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 04/21] KVM: arm64: Introduce helper to retrieve a PTE and
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
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
