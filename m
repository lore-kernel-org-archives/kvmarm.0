Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814B3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD994B0B6;
	Fri, 15 Apr 2022 17:59:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j9tc6KJ3lXh9; Fri, 15 Apr 2022 17:59:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A65C4B159;
	Fri, 15 Apr 2022 17:59:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC23B4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pZSiYQd1JET9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:23 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FF8D49F55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:21 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 y13-20020a5e834d000000b0064fc8cd0bf1so3626773iom.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+7THeEZjrQkI4cL8qs69/ZVQNerdV4AViBcRVZLLx0E=;
 b=sgJWtGYVInFd1drSIPRRI4aezVykNPn0h3TZjKKiErpQM7sAIHOOKNGcQ0jWe9x2J3
 4uorM5vPe/np9qjkIYA4dfw4gtmkWWOabaU8tGatq8w8LsDoUg9+FMK0LVF1fX+QFyw6
 i9msKz6hKpt7r66C+xns81BxvuHbanyJZ610bbwgkWkEmS6Xl9AcIZ1z+pnbftljqbuV
 TZJnMR1dtR7pvNgtOgZtS1KwcCNK2XXzdflPkGu6sg9JhoQgHweTSx9tVIIm2620GETp
 v/lovjRa15qTioUPiP/HsnkVKkyBFJUAm8nxrDqS7jgG1Smlaj2NKciPmkptKeLE+kdI
 nEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+7THeEZjrQkI4cL8qs69/ZVQNerdV4AViBcRVZLLx0E=;
 b=fFwmWWoxnkSOIvWP+TV6Foj6SJ+NJT1EHje8AJwrFKCTDVAEJ4ZIoIuIX7h4Tdlsqz
 2DVkWrUWQLSq70qaHJ1Y9/12sIiTT756RjZYKTnirk039vgaxrqtbU9HO8hujLGbRHkp
 HBemGT3UOgPXqjAkkWYvDWtEB9G+XxQhXoRoicitBVjuZNNfsahwkPAx4pr3nYzralnM
 Ug0rW7DWF8oBDgBkdCzUqEkOGKpHKsV+IIPwZh2xWEmm9+6r2Ryl+e4xCZzyJSCWuZWC
 0+kktWVdhAKtxOYORDAeGzP/2sHrLpZ0fF01KZNrjhNpYFFFqqNdqrF6gdq4an6cEwI1
 DT1g==
X-Gm-Message-State: AOAM532BcKbSiEmN1ZZgbkda/g7MrawSxB6vl9URfWw4AfVXyu7u6tai
 JwSReiVuaXMnRibsxauHOzxxGLBA7C9x1TEuIk9KPT2VjgKJk5IWplWOhYsVuCEhbWZLQVk7vDJ
 6R6Q1UYTHFzFYi2nIO8f7M7ReWYgWwuVFKKNX2MUEPWZ+Nq7pj61hJmyeOL6bbhEArbGQGA==
X-Google-Smtp-Source: ABdhPJyV71KyX7wIk4SdepWHYsPDO7JEsMOtpP8Ew2zkdCBFEtHJx6sDDgdROjEilaiKBOX2bMTgAgDq5z4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:8a07:0:b0:64c:8b33:6d19 with
 SMTP id
 d7-20020a5e8a07000000b0064c8b336d19mr315910iok.170.1650059960675; Fri, 15 Apr
 2022 14:59:20 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:57 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-14-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 13/17] KVM: arm64: Setup cache for stage2 page headers
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

In order to punt the last reference drop on a page to an RCU
synchronization we need to get a pointer to the page to handle the
callback.

Set up a memcache for stage2 page headers, but do nothing with it for
now. Note that the kmem_cache is never destoyed as it is currently not
possible to build KVM/arm64 as a module.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/mmu.c              | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c8947597a619..a640d015790e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -374,6 +374,7 @@ struct kvm_vcpu_arch {
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_caches {
 		struct kvm_mmu_memory_cache page_cache;
+		struct kvm_mmu_memory_cache header_cache;
 	} mmu_caches;
 
 	/* Target CPU and feature flags */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7a588928740a..cc6ed6b06ec2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,6 +31,12 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
+static struct kmem_cache *stage2_page_header_cache;
+
+struct stage2_page_header {
+	struct rcu_head rcu_head;
+	struct page *page;
+};
 
 /*
  * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
@@ -1164,6 +1170,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			return ret;
+
+		ret = kvm_mmu_topup_memory_cache(&mmu_caches->header_cache,
+						 kvm_mmu_cache_min_pages(kvm));
+		if (ret)
+			return ret;
 	}
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
@@ -1589,6 +1600,13 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 	if (err)
 		goto out_destroy_pgtable;
 
+	stage2_page_header_cache = kmem_cache_create("stage2_page_header",
+						     sizeof(struct stage2_page_header),
+						     0, SLAB_ACCOUNT, NULL);
+
+	if (!stage2_page_header_cache)
+		goto out_destroy_pgtable;
+
 	io_map_base = hyp_idmap_start;
 	return 0;
 
@@ -1604,11 +1622,13 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.mmu_caches.page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->arch.mmu_caches.header_cache.kmem_cache = stage2_page_header_cache;
 }
 
 void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_caches.page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_caches.header_cache);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
