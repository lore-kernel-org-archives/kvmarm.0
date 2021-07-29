Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACBAC4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3237E60184
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3237E60184
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7C04B0E4;
	Thu, 29 Jul 2021 09:28:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v10L5PPvpc9S; Thu, 29 Jul 2021 09:28:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D02CA4B0F4;
	Thu, 29 Jul 2021 09:28:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B24D640256
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BOgGfMvs1her for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:48 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9493D40D0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:48 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 q10-20020a05622a04cab0290267bc0213a9so2777374qtx.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=K2yJYY4AwV+vn/rNuC2tG6Gq9ljpo+CbL9CfXBwYhKs=;
 b=QOeabQvhK+pjySXM7mdcCBpwBPGxHA2Aapue3mH3nglJQ48pdBSi1Gn+iql4C+ZGom
 yxB9Fd0YJyOA5p4oPp5VddH6E/ae1UId3M3sSiQLeXVEXTAyT8WEuAcHH4S3tIGW4GL7
 7wL1UZpRFNTcYPQ5V4zS3cIm55suJij7Ous/EuOVId5PU1TniXtP5Aqb0dVNxvTPxtlj
 KiaaQa51mTF7lD9V2qlqCFAKM3pn6tq7MWusSXIEem4MarzZ67Wycb9NnvuHlTS06wLf
 E0b4JNz5c1tJLmgcdHVU3XSzLEhKhe3NqjOJO2gPG+nEK+YdR7Kj2Kw1hj8Xb/tq07w5
 5N5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=K2yJYY4AwV+vn/rNuC2tG6Gq9ljpo+CbL9CfXBwYhKs=;
 b=Ut3RO6wPxDgH2VmVhst5gAS3gP82TZR3jEkd1/Vt8Mp24EGjJZAt6ZZBVGxQYak6n6
 s5BZzN+c8FkMl7sgRLzd0xg7gr7rF+hMf1pQvfkP0+GDbrTcDA+XxQes2mmAOXuXSKNE
 HWBzMzXKbiQg+Eyl+QQ4WKgNGObXP61KGxy0yb7VHGm+0KKrqMWHvW8tNSgkTdWPXtYu
 knpb6sMR9yt4p17MyrMeoS5DngymUG0ry907CLLRsBztn0+ljm2p11pMHLOJo4e+H8Yf
 Ymj9i0dd0QzFDYXewVVN9zP6MLhO+yPOleKcMcqvrHzbqQj6b4dDJTU67PSuzZs/b8/8
 bOHw==
X-Gm-Message-State: AOAM533U77nyrpBtm+8jZ8twut1hvtAv3HJGnsXwC3D+QaaEgP+RkvqT
 8xCaIkg7R34Afkw3XxyaGTN2JLnGOHoj
X-Google-Smtp-Source: ABdhPJxz1R05cTjKGeAzbyffgsjdEJ6FuTW+MEeZoslgi5BQPfW/okp9D2w7vU3mDjPYNqOPOTSTUIW1Zb/l
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:10c8:: with SMTP id
 r8mr5270070qvs.28.1627565328196; Thu, 29 Jul 2021 06:28:48 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:08 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-12-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 11/21] KVM: arm64: Allow populating software bits
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

Introduce infrastructure allowing to manipulate software bits in stage-1
and stage-2 page-tables using additional entries in the kvm_pgtable_prot
enum.

This is heavily inspired by Marc's implementation of a similar feature
in the NV patch series, but adapted to allow stage-1 changes as well:

  https://lore.kernel.org/kvmarm/20210510165920.1913477-56-maz@kernel.org/

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 12 +++++++++++-
 arch/arm64/kvm/hyp/pgtable.c         |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index ba7dcade2798..d5ca9b6ce241 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -121,6 +121,10 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
+ * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
+ * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
+ * @KVM_PGTABLE_PROT_SW3:	Software bit 3.
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -128,6 +132,11 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+
+	KVM_PGTABLE_PROT_SW0			= BIT(55),
+	KVM_PGTABLE_PROT_SW1			= BIT(56),
+	KVM_PGTABLE_PROT_SW2			= BIT(57),
+	KVM_PGTABLE_PROT_SW3			= BIT(58),
 };
 
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
@@ -419,7 +428,8 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
  * If there is a valid, leaf page-table entry used to translate @addr, then
  * relax the permissions in that entry according to the read, write and
  * execute permissions specified by @prot. No permissions are removed, and
- * TLB invalidation is performed after updating the entry.
+ * TLB invalidation is performed after updating the entry. Software bits cannot
+ * be set or cleared using kvm_pgtable_stage2_relax_perms().
  *
  * Return: 0 on success, negative error code on failure.
  */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bcc02e6e0f62..1915489bb127 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -357,6 +357,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
@@ -558,6 +559,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
@@ -1025,6 +1027,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	u32 level;
 	kvm_pte_t set = 0, clr = 0;
 
+	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
+		return -EINVAL;
+
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
