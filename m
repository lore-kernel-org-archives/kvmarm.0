Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFC4C636C9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CEAF61220
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CEAF61220
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 011DC407F1;
	Mon, 19 Jul 2021 06:48:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0q1PVhjQJvRG; Mon, 19 Jul 2021 06:48:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACAF54A1A7;
	Mon, 19 Jul 2021 06:48:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CDE49D50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rDl8Z0yvRZA0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:48:00 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EDC34B081
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:00 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 n15-20020a7bcbcf0000b029023ab2f18796so2066668wmi.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jCVZUl7mrKXhOgc92CUwmjy/8GLL8qBZeqvKPdsULBo=;
 b=Iv6HLotZSYKnqU+lUooERsXuSEAWx3VwKrcAVoV7fvzbOe+NzdG1VEHTwtAWje0rIB
 FBjobDwaueZrOJExzeI7sdg7O2/F4Y5IOMh136apaQCyUSWAEPqaYj8KLp39ymbgQFzN
 AyCeCZTZKejh/1vxFoUB+cZ5GImkWfPknL6py9BFxSeKNLh1bEqTIwkkWL6/9QrqiZhx
 bufScWZMa+3N64Gm/bfzeL1huLY0dIepVZRrRZvKUeSf1CMleCvkwSbfE+lOV7YzkSqj
 LXRGJqpFmm/qRenArrM8tK3lx0xGKtC867Gs8dXTkq9S3SqJLJMrrTHmRgHEhXRK2f7q
 F7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jCVZUl7mrKXhOgc92CUwmjy/8GLL8qBZeqvKPdsULBo=;
 b=mZdRgQnvnNXy1ZT4R/t4UNWbqLjnSkuu4JfoXkVkDY1E6TV5cwSljZFKyauaCaocQz
 6Jx6vHduT9aEKt9dFmbZoGUEpd958l30qBLJI5dSnkhs9wEhlZNaPPXd5m6+NvMHb/xT
 Tm45jh72JkYXEVetigL+tERpbdVkuTxDE4j56ZIuBD3ufdgFfyp6BtYIAqKpSAGEbR+o
 UNwTl863T61O69oAYHkdMHVcYOTrVWx6FP1Ai7o+3T4dhUSYS4lXVoBjOV7SA0/aOSQi
 pG69+vehi5qO/g6bLQkt+jznfl/5pvHj4xZHdZryOmKmRdOpsyzMnDS+h4WAdYUPxCIK
 nGdg==
X-Gm-Message-State: AOAM530JCLQ9o8G9xYqeAZWWVR+3oeSRTXp6kdq3/4/2/TWijSkMjrmP
 RWie/6EwoMjkg8Gmg+oc664/0WAzU9Vb
X-Google-Smtp-Source: ABdhPJzWhrN0PU3u2TAQJIPoHRtvJQ+RMyNfI8W8ip/YuHiS+H6N8RNCyCq0QLT9GDqXoBSdi1WyWB01xUsv
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a05:600c:287:: with SMTP id
 7mr25592126wmk.1.1626691679361; Mon, 19 Jul 2021 03:47:59 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:29 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-9-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 08/14] KVM: arm64: Add support for tagging shared pages in
 page-table
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

The hypervisor will soon be in charge of tracking ownership of all
memory pages in the system. The current page-tracking infrastructure at
EL2 only allows binary states: a page is either owned or not by an
entity. But a number of use-cases will require more complex states for
pages that are shared between two entities (host, hypervisor, or guests).

In preparation for supporting these use-cases, introduce in the KVM
page-table library some infrastructure allowing to tag shared pages
using ignored bits (a.k.a. software bits) in PTEs.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 25 +++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index dd72653314c7..f6d3d5c8910d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -81,6 +81,8 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_STATE_SHARED:	Page shared with another entity.
+ * @KVM_PGTABLE_STATE_BORROWED:	Page borrowed from another entity.
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -88,6 +90,9 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+
+	KVM_PGTABLE_STATE_SHARED		= BIT(4),
+	KVM_PGTABLE_STATE_BORROWED		= BIT(5),
 };
 
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5bdbe7a31551..51598b79dafc 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -211,6 +211,29 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
 	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
 }
 
+static kvm_pte_t pte_ignored_bit_prot(enum kvm_pgtable_prot prot)
+{
+	kvm_pte_t ignored_bits = 0;
+
+	/*
+	 * Ignored bits 0 and 1 are reserved to track the memory ownership
+	 * state of each page:
+	 *   00: The page is owned solely by the page-table owner.
+	 *   01: The page is owned by the page-table owner, but is shared
+	 *       with another entity.
+	 *   10: The page is shared with, but not owned by the page-table owner.
+	 *   11: Reserved for future use (lending).
+	 */
+	if (prot & KVM_PGTABLE_STATE_SHARED) {
+		if (prot & KVM_PGTABLE_STATE_BORROWED)
+			ignored_bits |= BIT(1);
+		else
+			ignored_bits |= BIT(0);
+	}
+
+	return FIELD_PREP(KVM_PTE_LEAF_ATTR_IGNORED, ignored_bits);
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -357,6 +380,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
+	attr |= pte_ignored_bit_prot(prot);
 	*ptep = attr;
 
 	return 0;
@@ -558,6 +582,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	attr |= pte_ignored_bit_prot(prot);
 	*ptep = attr;
 
 	return 0;
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
