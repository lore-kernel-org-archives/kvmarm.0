Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44512C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 00:27:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1E2D60F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 00:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1E2D60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232BB4B0BC;
	Mon, 16 Aug 2021 20:27:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GO8tDtCcqa60; Mon, 16 Aug 2021 20:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 350274B0E5;
	Mon, 16 Aug 2021 20:26:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740AB4B0BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 20:26:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NJT-Y6hHWuTJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Aug 2021 20:26:54 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DACB4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 20:26:54 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 p7-20020a170902b087b029012c2879a885so11891894plr.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 17:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=GmFYFWgSJqnYvi5uzE7wopljyXsB3O7OfGsKWKCJGuY=;
 b=b4f1FMtWLjJ9VYPvJ9oT6EDEBvLQnL/BGyFRDQvrfDTfhb/IPPcBSbd2AzesdLwfxg
 bxUJuh3+aPqAi8foBEiinZTVoFhUv176g47LSxpy9liUchTLJS9ngNH4whJOedOlHVTZ
 8Uvq00WwgvyiWrrWjeESLEcjTBevgNer8H7o2acqcvKM7ZHizu6tzw2EuOC/4HvamaRq
 0f6W98eLb2ofHtM1vizH8yxC7vt5oLiyCDEWUFE6qi0w5T+G9fyc5IDG7DwL3kw/rCKM
 zmrv739kbhLM5gPECbcHsF2HwQp0SgyKQwe/guyHZBFK0EAKNWGHtZZDTsOvlDPAA8Cx
 iYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=GmFYFWgSJqnYvi5uzE7wopljyXsB3O7OfGsKWKCJGuY=;
 b=ZtPPR2rRr5StwWNX1GKKrFZRiTtGkG/J3lU/b/Yi/pwVM3mU+873iMRiL4B09tWZRE
 YBXUMu3EDIncX534F+mcxeTZu/wyJfZoJVyS114miIXQF0zVqyDo8ZUqEoJDJZyRIL5B
 qY1ffrsDdDYIVsUOmBxgWSu6+R204UpW7VXc1F+mn31KFS7bsgKkZAq5odR6lO2cAOWp
 stUfyfMLdDD5vSBQfG7xflbnsBjTMdeb8ydfPHBngF5Y6onJG1gmxrb5DQ1wv5cVdMbD
 AuMJOGBE3MgHhZQdv4d0dMV3o/vO4PO3+K6RUL0limWWJjjKlG36lqIiWMLg3XrNwBn/
 NqIQ==
X-Gm-Message-State: AOAM5305xpEhl+zg1lLSbcojnXmtfi2GLPuYmRqb+pzEQzDpm/G4d7WN
 OUVjRNLIiix/9MGTK7jGSTZRfOXXikD9grHHAw==
X-Google-Smtp-Source: ABdhPJyFaF0EVkxwXDmU6xb8bee1RXFu3kmq7woIq1DfWxoQUoXXuCJt0ujRSFs/vD/RyaMoFKYq5CC/RLU8ApIr4Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:902:cec3:b0:12d:92c4:1ea6 with
 SMTP id d3-20020a170902cec300b0012d92c41ea6mr563343plg.36.1629160013007; Mon,
 16 Aug 2021 17:26:53 -0700 (PDT)
Date: Tue, 17 Aug 2021 00:26:39 +0000
Message-Id: <20210817002639.3856694-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] KVM: stats: Add VM stat for remote tlb flush requests
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 Marc Zyngier <maz@kernel.org>
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

Add a new stat that counts the number of times a remote TLB flush is
requested, regardless of whether it kicks vCPUs out of guest mode. This
allows us to look at how often flushes are initiated.

Original-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c      | 1 +
 include/linux/kvm_host.h  | 3 ++-
 include/linux/kvm_types.h | 1 +
 virt/kvm/kvm_main.c       | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..f5bb235bbb59 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -80,6 +80,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	++kvm->stat.generic.remote_tlb_flush_requests;
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..27cb69e564cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1444,7 +1444,8 @@ struct _kvm_stats_desc {
 		KVM_STATS_BASE_POW10, -9, sz)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush_requests)
 
 #define KVM_GENERIC_VCPU_STATS()					       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index de7fb5f364d8..2237abb93ccd 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -80,6 +80,7 @@ struct kvm_mmu_memory_cache {
 
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
+	u64 remote_tlb_flush_requests;
 };
 
 struct kvm_vcpu_stat_generic {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..26b77ab98a04 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -318,6 +318,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 */
 	long dirty_count = smp_load_acquire(&kvm->tlbs_dirty);
 
+	++kvm->stat.generic.remote_tlb_flush_requests;
 	/*
 	 * We want to publish modifications to the page tables before reading
 	 * mode. Pairs with a memory barrier in arch-specific code.

base-commit: a3e0b8bd99ab098514bde2434301fa6fde040da2
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
