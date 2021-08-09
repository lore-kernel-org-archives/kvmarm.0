Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BFBC4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D5D261052
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D5D261052
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9BD4B0EF;
	Mon,  9 Aug 2021 11:25:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YnnGwiaaLlsd; Mon,  9 Aug 2021 11:25:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B50DC4B103;
	Mon,  9 Aug 2021 11:25:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 572C94A1A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zAtjHXzxVdoV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:27 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39D7F4B102
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:27 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 i6-20020a05600c3546b029025b0d825fd2so118092wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=aj8MBR15jNb/eqSbuMjCVp1+vMaSCorP22m0gXjnWP4=;
 b=KglZAeR1qSe4Fux9NKVSqLH5ETyNyLwo5BwAI8rIRoar0U1eIzKsZBbQskglFPq/tl
 5wqV/Ut+gPY5oqueMzmWHR5oDZDZJeH0fiPF9GJU/HsJOHnSdK+3cGq7qAQUidtxQH/R
 7TVpr0n9seO4pWJOJIN2bYZ0Tx4rSBgKFVt4FjlPQyP6I0BU+Lww/FVIozy0ZUYBFzRr
 23ElyYL09R13mKCKacrpORmkccN37M4BnHPdt9fwA1QAK9rJOYlIOiqiUwwVUoAnbfkK
 INPA8y0/M0cYEr4FkzwW5r1AbfmtNKc81EiE4J3BrikgtA/oqRHJPLojwEKVnIbWh5de
 NQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=aj8MBR15jNb/eqSbuMjCVp1+vMaSCorP22m0gXjnWP4=;
 b=Kr8KHUs9oQOK3nDIo9Oxt1DrzdmHW421Me8oe+FP1aLhRCdGQU6MUnYhxvMNZMBlRr
 TCEz+npYfVNXj7G//C6b3eSX76MdzVTY8srm4yA6wyFURfYbVZSyQBd88DmLZU5nnBNu
 MbyVywjj5AwpxoaoVHxjfynYAQKH3njKpUIgAnZcnOOSG1QgEUvPojqt0Rkpic9stbFv
 7/+pn2QggqggilEC0OUuSgQsMYLMfc1pZcN4j1UD+U786GW1Yzd9Z9iXuSQsVkDw1PFH
 ZBdrlnf5gN7+kW/I6yBjGG2MO3yMrIzDu6Z+s6xIpupxPhSv5QRPHjhWK1/YqOvLSl47
 laCg==
X-Gm-Message-State: AOAM533xm8ewFwMgFddM7HoHM2ycXl3BzGNrZMx2JQqZxKEtFyEA+1Cw
 32uG+lzyNMYsjgqFOKonahcSQeAlWGTQ
X-Google-Smtp-Source: ABdhPJxO6Ief2rDrUHALAL2m66Q1K9ZTpGeNI4IRrYBo8N3BxkN9OXPutXcNR00+t/uvXxU7PCGCiVC7nza1
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a7b:cb09:: with SMTP id
 u9mr34069444wmj.63.1628522726484; Mon, 09 Aug 2021 08:25:26 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:43 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-17-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 16/21] KVM: arm64: Enable retrieving protections attributes
 of PTEs
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
 arch/arm64/include/asm/kvm_pgtable.h | 20 +++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 37 ++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index ff9d52f8073a..f1651e0153ad 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -506,4 +506,24 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  */
 int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
 			 kvm_pte_t *ptep, u32 *level);
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
index cff744136044..f8ceebe4982e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -363,6 +363,26 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	return 0;
 }
 
+enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
+{
+	enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
+	u32 ap;
+
+	if (!kvm_pte_valid(pte))
+		return prot;
+
+	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
+	if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
+		prot |= KVM_PGTABLE_PROT_R;
+	else if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RW)
+		prot |= KVM_PGTABLE_PROT_RW;
+
+	return prot;
+}
+
 static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
 {
 	/*
@@ -565,6 +585,23 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	return 0;
 }
 
+enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
+{
+	enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
+
+	if (!kvm_pte_valid(pte))
+		return prot;
+
+	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
+		prot |= KVM_PGTABLE_PROT_R;
+	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
+		prot |= KVM_PGTABLE_PROT_W;
+	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	return prot;
+}
+
 static bool stage2_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
 {
 	if (!kvm_pte_valid(old) || !kvm_pte_valid(new))
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
