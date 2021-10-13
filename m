Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79765C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 239F761168
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 239F761168
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2AB4B14D;
	Wed, 13 Oct 2021 11:58:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OFMbNA8c6vrz; Wed, 13 Oct 2021 11:58:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEB34B149;
	Wed, 13 Oct 2021 11:58:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E85644B15D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QU+afZLzDuuT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:54 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB274B0CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:53 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 j19-20020adfb313000000b00160a9de13b3so2359783wrd.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AEhoESi+JSkIpPsgLf7KV5M6/nV8qQxTUg3eRSjbv/s=;
 b=NP+XPmDRgtbMk4UIWYD0pQZRkJlQstYb8HVcLmqCidCTYbYQHgdI3Cqdyg2BMtg0E7
 ZxXptk9cPKAKddslAHjToBYwGC6dKSDDr9i8XsvIRpIAqZgNZspy3rXJluomIH6ikRPq
 GMD7xgTJYC+p2iKq4nOwt1vtc3aTDy8Q23TqJt8WOdZ/2LNtMpxarqRE3/Usq/0MBwRm
 F24k7V9pBdz5RsbhTu2S+G4qNUwnwip22wK2jS4gWU/A4VAEAeayNExRA5QBw9pLIcnf
 3MZvLAInURcb+xfCjWAMcRLKWeqYTvvi+usmLYswXOEB2/t+ULFEJXEMzeRdLXCgdOA+
 H7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AEhoESi+JSkIpPsgLf7KV5M6/nV8qQxTUg3eRSjbv/s=;
 b=6QX2q6BBczXcEHezrXSs0VQdQ00PfkP4wHmStpz7PcsqyXB5OFu9w9R1mRRfdnT32M
 gMYYGZeLK4tbRzUDTRRwXKd7euIUJtfEyQ2i1/cTmXKTOeqRx6wbM7fb/IqstAcqwUd1
 F5W9V65KxZXrFV6gWOSflZuB3im4A8js3JKM2NSTOgX/oXjjM7jvC2LXXw89ImXqbqK4
 kMNvl9jGglxPJet54uL5pKkPQ4MeLtC2O57J1UcivDn5sX9eBBa0qejLtduEDbqyKYTN
 5/zV+svnelMJz/o+JIDPn4AdpBpvPyk/K2OdXX5fYFrVIUobB26knwRZ9MZI/MEaj2gw
 WslA==
X-Gm-Message-State: AOAM531oGAMNMkaLwr0PXN70dfI8heFwiSsaslHouucGG/rPAaMxZjD/
 gUno+S6/awhUnvRW9whGSFGvc5V4j7n9
X-Google-Smtp-Source: ABdhPJypaaFzh/P/CSod5M2Uoyrzi+tFUaTYoQ7iBeHY7wDaUM4H3CebTBes5FVoowLKxoASMH9NbGCZR+8e
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a7b:c76e:: with SMTP id
 x14mr13634245wmk.47.1634140732732; Wed, 13 Oct 2021 08:58:52 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:23 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-9-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 08/16] KVM: arm64: Fixup hyp stage-1 refcount
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In nVHE-protected mode, the hyp stage-1 page-table refcount is broken
due to the lack of refcount support in the early allocator. Fix-up the
refcount in the finalize walker, once the 'hyp_vmemmap' is up and running.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 57c27846320f..ad89801dfed7 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -166,12 +166,22 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 {
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	kvm_pte_t pte = *ptep;
 	phys_addr_t phys;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
 
+	/*
+	 * Fix-up the refcount for the page-table pages as the early allocator
+	 * was unable to access the hyp_vmemmap and so the buddy allocator has
+	 * initialised the refcount to '1'.
+	 */
+	mm_ops->get_page(ptep);
+	if (flag != KVM_PGTABLE_WALK_LEAF)
+		return 0;
+
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -204,7 +214,8 @@ static int finalize_host_mappings(void)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= finalize_host_mappings_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pkvm_pgtable.mm_ops,
 	};
 
 	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
@@ -229,19 +240,19 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = finalize_host_mappings();
-	if (ret)
-		goto out;
-
 	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
-		.zalloc_page = hyp_zalloc_hyp_page,
-		.phys_to_virt = hyp_phys_to_virt,
-		.virt_to_phys = hyp_virt_to_phys,
-		.get_page = hpool_get_page,
-		.put_page = hpool_put_page,
+		.zalloc_page	= hyp_zalloc_hyp_page,
+		.phys_to_virt	= hyp_phys_to_virt,
+		.virt_to_phys	= hyp_virt_to_phys,
+		.get_page	= hpool_get_page,
+		.put_page	= hpool_put_page,
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
+	ret = finalize_host_mappings();
+	if (ret)
+		goto out;
+
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
