Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F6AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:12:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B17E4B126;
	Wed, 15 Dec 2021 11:12:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gK0oQtVFJz7A; Wed, 15 Dec 2021 11:12:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 347674B192;
	Wed, 15 Dec 2021 11:12:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4094B126
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dT4YLDwBtLU6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:12:49 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 059A14B139
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:49 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 h7-20020adfaa87000000b001885269a937so6068700wrc.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0T7H/Y38j6+Gwobm57eeLVycbzCrTBaKznUeZZoLnRY=;
 b=BJgpzkCwe1j3WJWKVWNOBVvJCvYLLVWrwYVZlEgV11DB1tQCznJlUwNpFmhV4nNJoe
 x4rhNTLCG8yYgsw9qn3v98zaLBUf6DRqrpAxVZbBAjhXEVgrI+0cEITsahoz+mFGbZDN
 Bp1fk3yZMsNpaQ/kcxbipbrFTeC4FKeQzjHWuTODjU6dTmT/KxlZ4zLtMB3B6sO8lBac
 aiE3ccRuO3vXHCM3Hg3g4J+Vl6C6MJQg8BNnXZo8Z3UDpyroafFj247opJNvQJOLHj8k
 4RoVVrI1fiVAJ51smFgIMMfMRq9NWs8SnpWjMzKbPiX2hUX7nBHyLwXOKfUlvLf6MO9S
 RKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0T7H/Y38j6+Gwobm57eeLVycbzCrTBaKznUeZZoLnRY=;
 b=qr8JMgWgcJ9oKJmgMEtuGE6ofgftpToGxC3icI2lAhgEU+cT0W7R0ZN59bpNL0XOdS
 /SbDpkJ1WlP3HoMWKD+YK+t9V3fsxsQSdvYDCWCn6KWWenvCVUf5tdCTeMEXDG2jFzfT
 nMQiAhLFsqunvOO2XFiuZO3lx+boxn765mvzhIMUK2ZA+FPs7OybQSSASWIkCEkKNmZe
 f6EQRZBHt1BFYeGKxARx6QU5FAkWEIU+fJi7XRgNQBV9Jq1d+XWIqXxc07mpMhuOPQsn
 cNdbQO1lwGHlihzHOss4/1Q9sBwArsTAtf824xICxwRIi1pUyDMvMKWiwruJWVganMkm
 oAOw==
X-Gm-Message-State: AOAM531HZXwu5FAukHnZ9+PZLRLX1Tq0RLTkO5WrMO4cyzA1d2ZV+SV7
 Ix/0/QpCK/Hsh9xyoG+f1ZMgYum8KPzA
X-Google-Smtp-Source: ABdhPJxs0xcgsWgPokAD4PgxH1YFZ/1fp7HGONpVZTXN+N1q3NOGytELjmmCe6UxqHhDjxU63cTx8+yucVmW
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a05:600c:3ac3:: with SMTP id
 d3mr527291wms.174.1639584768216; Wed, 15 Dec 2021 08:12:48 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:20 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-4-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 03/14] KVM: arm64: Fixup hyp stage-1 refcount
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: qwandor@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e31149965204..ab44e004e6d3 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -166,6 +166,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 					 enum kvm_pgtable_walk_flags flag,
 					 void * const arg)
 {
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
 	kvm_pte_t pte = *ptep;
@@ -174,6 +175,15 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
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
 
@@ -206,7 +216,8 @@ static int finalize_host_mappings(void)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= finalize_host_mappings_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pkvm_pgtable.mm_ops,
 	};
 	int i, ret;
 
@@ -241,10 +252,6 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = finalize_host_mappings();
-	if (ret)
-		goto out;
-
 	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_page = hyp_zalloc_hyp_page,
 		.phys_to_virt = hyp_phys_to_virt,
@@ -254,6 +261,10 @@ void __noreturn __pkvm_init_finalise(void)
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
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
