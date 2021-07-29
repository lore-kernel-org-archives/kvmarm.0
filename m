Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1584C4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63EAA60F48
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 63EAA60F48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19DE34B10D;
	Thu, 29 Jul 2021 09:28:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id awwjn+gjiMN1; Thu, 29 Jul 2021 09:28:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CDF84A5A0;
	Thu, 29 Jul 2021 09:28:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BA94B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UURdqRJX4lM9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:51 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7450A40D0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:51 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 o11-20020a5d474b0000b02901533f8ed22cso2234817wrs.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=H72uhE5VGkDx1jb1MVcWxLaZfSQPWlRzbrWGol5Bg8o=;
 b=HTncpCcFrfYqsq+B0XVUZSJV3OsWsCbXAq0Nsc6wlmDYOhwALGBrA3jJ41pZG0qqMI
 BUp7QdvrQdj2zE8BkjdDej0plVEuMnXHWUQxTorC7+RLWrL1Cl5SNZOzSPQYcIPsiBfy
 PrIxNokt9gtSQCGyTC4CeE1TIB4Vpi45IPhQSXcZ31S+u0qfhpB+xXZJnFGTLgqBW/FK
 8j7S1I+GtzmzNFPDXkOtQ4OpR5EBk196h65xM3EPu3FNApwn8htU1h7pYOsraR/C0MHV
 Et3C8vRAcLob23EWSpeVAA0PxgEvB3ZxKyeGA3rhHcr1KBj7OXeo6C86lTupLKh5WO3I
 vGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=H72uhE5VGkDx1jb1MVcWxLaZfSQPWlRzbrWGol5Bg8o=;
 b=KLvRci13YDG9Z3RlStyNOjF2xlYRVKrUHdbm9HGX36tcBvpA5jiJkX2RtgrT0Le21n
 fjWQU64DFoWgIbgsJPn6IkSrEX1A61cHeyh/wK9Dc5fBhIbit8bHqPtfmmrECE/hQ4XI
 v/xF5KnK2NVvbMSYhjtVCn23kyVLbPACacIBDeg5zgS4Odl73nOjQzOapuYxlyIG4MvM
 kIkQ+4gXFUxzHSZOXML+b8vVkW2gVIEdwdv4RgaEDYy02QfBZ6VJ2oKj9KT9MKegTHSK
 wuDcRHKuouVqt57gwmxzfq7HriILiT5r/OxBZHRoDL0CZKa/s4vNDkTx/I4G/RvvL4/a
 +BLw==
X-Gm-Message-State: AOAM532QspIKFa4wiNgoeuyV8DrczYxm6fF6ch1GHAksJ5/bwIPwHBUY
 sf/UrjWuMu16LfppEClK0EOS7xgCQexk
X-Google-Smtp-Source: ABdhPJzn1rlmoNXXKLmPJSHjhbkDAjV7ZnprHUg6PgSi5S1PmeBEhPufv9qLwdFykhgetYoUfULvmrtzd+sc
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a1c:a78a:: with SMTP id
 q132mr4804653wme.76.1627565330622; Thu, 29 Jul 2021 06:28:50 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:09 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-13-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 12/21] KVM: arm64: Add helpers to tag shared pages in SW
 bits
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

We will soon start annotating shared pages in page-tables in nVHE
protected mode. Define all the states in which a page can be (owned,
shared and owned, shared and borrowed), and provide helpers allowing to
convert this into SW bits annotations using the matching prot
attributes.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 9c227d87c36d..ae355bfd8c01 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -12,6 +12,32 @@
 #include <asm/virt.h>
 #include <nvhe/spinlock.h>
 
+/*
+ * SW bits 0-1 are reserved to track the memory ownership state of each page:
+ *   00: The page is owned solely by the page-table owner.
+ *   01: The page is owned by the page-table owner, but is shared
+ *       with another entity.
+ *   10: The page is shared with, but not owned by the page-table owner.
+ *   11: Reserved for future use (lending).
+ */
+enum pkvm_page_state {
+	PKVM_PAGE_OWNED			= 0ULL,
+	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
+	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+};
+
+#define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
+static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
+						 enum pkvm_page_state state)
+{
+	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
+}
+
+static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
+{
+	return prot & PKVM_PAGE_STATE_PROT_MASK;
+}
+
 struct host_kvm {
 	struct kvm_arch arch;
 	struct kvm_pgtable pgt;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
