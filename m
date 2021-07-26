Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9184C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FB3D60243
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7FB3D60243
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 334D549F92;
	Mon, 26 Jul 2021 05:29:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RhBl8nt9vVzO; Mon, 26 Jul 2021 05:29:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 879094A534;
	Mon, 26 Jul 2021 05:29:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FDD94B099
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJqwf2vgOrct for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:31 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5114A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:31 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 v16-20020a0562140510b029032511e85975so6668197qvw.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hjv3q9oqO8KJkTui97+bkuRVMGWdHhFVwbAOefAmuts=;
 b=K4Np44DCnp9BZz24AKPA6E28uJ8LOJp91dy0Wm/EHbQJI7pAQDa2a8mi+EA/DZXSlk
 GoG2gmduJ7YZYfatlUidQ9d0VAniN3/JmTbPm71T6b4P77OPCFz9BNUKp8ONmEowp3w/
 +EHlEkCKgDkbLFk9y1zDY6RfRxq2WiIl0Og9u8g5HrFr4JTxKUxlrLo4+zEdUifNs6W8
 JmhIv0lqvT/uAvDr5GgydXVCEY8FGiCe07r7MYrwAi0db/RDEYrNT00/DpYdaeNPmkQ8
 ZLKO/aUnD0MVomB9CV6RjJbp1KN1Bzw9DuQJdFYBlMJBVi2xfvWSfOA8vbkSqq6lKfjK
 aBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hjv3q9oqO8KJkTui97+bkuRVMGWdHhFVwbAOefAmuts=;
 b=OQX+MBLh9vF8oSY0HZQZ38R60d+auZUndcA/KGaXOT/xfskXtUCBx0S3XZiVIen09a
 5kY35JXS0+iSRi3rFxxXwYfC/uIF/7wN9oFfpx3H3C/z1qAHdMW0xjVBgzG96VDomlyI
 QVPSO6RRdGoAxK41ZL94+W0WsDpzGnwQevcjTeSY1O5B1AD6E1knVbf6gMwKzRay9QAD
 onAH3w/h9G/EKib92xs9lL94cMGnroYKCZl4pSwMUYSe+EvQlmZRvDDMfKJ01kF5edb8
 UWmkr6di+U//jZj8ub696yClCJEQG0kRpSgckOsb+NqHHyTVH8HzPrG8fgNM4bqcCRrb
 NtuA==
X-Gm-Message-State: AOAM530yqmWvf4WQed94Xq5O+ejs3YpZ5GPqtKhDH+sRDVWBAT1p3wix
 Ff2vqBSZ2lVA/w0N3055U8Oz/VqRj6ct
X-Google-Smtp-Source: ABdhPJzI3c0tpPwx43KTm4Da4gOx40eS0i8088IhwtbH4MD7mLJsbFdIcU3LsaNGXrE1RIGFD4BUqlkCiWJN
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6214:ca5:: with SMTP id
 s5mr16960791qvs.58.1627291771064; Mon, 26 Jul 2021 02:29:31 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:58 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-10-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 09/16] KVM: arm64: Allow populating software bits
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
index 9246a27e2839..0be9f83974ad 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -108,6 +108,10 @@ enum kvm_pgtable_stage2_flags {
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
@@ -115,6 +119,11 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+
+	KVM_PGTABLE_PROT_SW0			= BIT(55),
+	KVM_PGTABLE_PROT_SW1			= BIT(56),
+	KVM_PGTABLE_PROT_SW2			= BIT(57),
+	KVM_PGTABLE_PROT_SW3			= BIT(58),
 };
 
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
@@ -406,7 +415,8 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
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
index e0cd748e4af6..bd409d524dea 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -370,6 +370,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
@@ -571,6 +572,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
@@ -1038,6 +1040,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
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
