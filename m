Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2BAC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF4F760F42
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF4F760F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72AED4A19B;
	Mon, 26 Jul 2021 05:29:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I96XVhaIkEXf; Mon, 26 Jul 2021 05:29:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DDE14A2E5;
	Mon, 26 Jul 2021 05:29:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B291149DE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Beqgpvnc+qi8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:13 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9FD949F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:13 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 l24-20020ac872580000b029024e988e8277so3978634qtp.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Gjf1jLwbr60oU/lDUo56+HNoAVcvWGbxZryQe2MxgVI=;
 b=DUXlt4CIx1Jj1CbDy7cdGv8bTdi62I2RYHsrT/s+KJOvTfJ/fwZsR6eGvk7It8rJcN
 bBoWcqIo5xKqnQFtfIFlQBaEBPm+SOq7Xuyw31L0WnzSfdn2t6kbbMQIZzXB0MUUPX8Q
 wxW+8/zX7bGrdM87rM65vxKXgcwv/bXY77icyCnicQZ+mAEy26wCuFtcvS96nYsEpGkg
 0z8vJbr77sREiu6d0IOmXfqa+VIbetUENBqdqiS0fCh4TnmOc6+k33nLzzQDzu0GsDiL
 pmQlhJkSyvFpULMaSDUptBv+CZ5WsBH34jLy6q57bE4W63AjjHdbQf7QAxbCShWBSI8V
 MdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Gjf1jLwbr60oU/lDUo56+HNoAVcvWGbxZryQe2MxgVI=;
 b=SU/8YnncPGbPAGOTnYQO88neFtyhhfi9XpMfGbN6XAcNxCuSxlnhNVublkBlAD4qSG
 YCHsVZtKpyI3fjRTaNz9fZ6nm2rfBEXxQ2C9Uj1zx7cx96lXdPjz+Sr/Gl2jTpuE5OBv
 KMKBEpXXSqudKHIcFC+FSXC7u3HoIZpx2+hrFOEZnNpPoV39dclR3+Uc9vvCUta10GkN
 Y5dqx4bipce6tT2T/DMjZhiqLj4rSVkRzz8syn+QKv+Ocv+7T/QikKZadHw2UQfgmFp/
 qlQo+ilaFQiJItFx57+WEkHFtL/lhxoqQ/ndC3MxTwixrmXpZ8jZ/E9B2Bi26i40uwrk
 R7hw==
X-Gm-Message-State: AOAM532SBQrzze2DtiKK0jSZSuLRKtyIG0dGYFuaObltUh7V4TuiiWFu
 EB9Hg4dPXZBrLNxCLex+on4fW8QtE94J
X-Google-Smtp-Source: ABdhPJwsdWxD5Vpv+7zklcHUJYq1XgMklZukeoIEPoWdSvMcON5nO372Kxs1TISOnicfY2UxNWOoh5v1fVJj
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6214:dce:: with SMTP id
 14mr16478055qvt.40.1627291753422; Mon, 26 Jul 2021 02:29:13 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:50 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-2-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 01/16] KVM: arm64: Introduce helper to retrieve a PTE and
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
