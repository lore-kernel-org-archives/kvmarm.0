Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45302C10F31
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F254F4BA87;
	Thu,  8 Dec 2022 14:40:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RhT53aRU4UHR; Thu,  8 Dec 2022 14:39:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94CD34BA6C;
	Thu,  8 Dec 2022 14:39:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0012D4BA2F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZfB-DZ9afL+Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:55 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAC834BA21
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:52 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3d2994e2d7dso24580237b3.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=dgqMnMt1QIlmBLa3o//o520F4RUXcCCtqFrzTbNkpWk=;
 b=f4QHeg61IzowzK+7yuPHF1TXnPTFwNskqnQKjcsu0WxAKIY1McB7wZRn+VuSfBM9b8
 ylyyA9kcFWxQm6+GX+bMJZFHcWTGXb7YNV/fpxz2TqMv2QX/5/VLhbXkWs5BZNCv8lvE
 iAqaka88+2+N5tw21tP1s0c6lUAdukNFngVoXini/VGsGOpfrraDUlE9nKTf3FFTHm9y
 KUTGqSOH2A4NquRC0hECU12i0F9wQKuKP4xBOjtC4vxLFMrVdTK8VzxOC9xjDjBZVdgu
 7TIFyQpSoyu3BW883wqt4S03Vt2JnLjwrIPiyoLIXLGjApjxjBQRjkRdpzCFxXjOiqSy
 115A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=dgqMnMt1QIlmBLa3o//o520F4RUXcCCtqFrzTbNkpWk=;
 b=Chy14gN717Z+eJ6FICwaKv9IWCfCL/+2fzanzuJx3FiO1LsSOYHPmFaGyI2YB5lVDE
 cb2kAQ2dUUuaT7XqOYxkYO2t/3rOsDyXSvJXcnNG47yIni3LhlPJ1ZQ9He34djrNrOHb
 JNx5LaSpF7APQGIRLNNyL6crmt8EOMASFXaMNcAvcLI/J1tMn4WOPHuUU4Uj4uMLWFtq
 E7vcrHvyIvmR59afWqkGAl0UiBgitA0Nalq7fdX2mTzXnWnXdB3RsUcBJx7qSFXet2nb
 9H8UJ9YqKuDxrGAEdSqzS2E/bnf+RArjBVovjKO1nE9bPIhHg121NG2w1VmiD984RYAF
 QAZQ==
X-Gm-Message-State: ANoB5plq7QEqJ4u3fOvERs84wXUyq9tcv/wsea5+LCC3Z2TnSozkU0EP
 GsKy117DZNNx1wm0A9/RcA2omNrpLXDXDg==
X-Google-Smtp-Source: AA0mqf5mi9mDJ9tYVtakRomun512INrgKlNeUrlvHGHQBPGnddPX6ZC9IDNboVvCBGP15bWz6s6DsMaL8j57qA==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:b885:0:b0:701:49ca:8ae8 with SMTP id
 w5-20020a25b885000000b0070149ca8ae8mr16438842ybj.553.1670528392392; Thu, 08
 Dec 2022 11:39:52 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:47 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-28-dmatlack@google.com>
Subject: [RFC PATCH 27/37] KVM: MMU: Move mmu_page_header_cache to common code
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

Move vcpu->arch.mmu_page_header_cache and its backing kmem_cache to common code
in preparation for moving the TDP MMU to common code in a future commit.

The kmem_cache is still only initialized and used on x86 for the time being to
avoid affecting other architectures. A future commit can move the code to
manage this cache to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 11 +++++------
 arch/x86/kvm/mmu/mmu_internal.h |  2 --
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 include/kvm/mmu.h               |  2 ++
 include/linux/kvm_host.h        |  3 +++
 virt/kvm/kvm_main.c             |  1 +
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a845e9141ad4..f01ee01f3509 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -163,7 +163,6 @@ struct kvm_shadow_walk_iterator {
 	     __shadow_walk_next(&(_walker), spte))
 
 static struct kmem_cache *pte_list_desc_cache;
-struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
@@ -674,7 +673,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		if (r)
 			return r;
 	}
-	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	return kvm_mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
 					  PT64_ROOT_MAX_LEVEL);
 }
 
@@ -683,7 +682,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->mmu_page_table_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	kvm_mmu_free_memory_cache(&vcpu->mmu_page_header_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -2217,7 +2216,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 						    union kvm_mmu_page_role role)
 {
 	struct shadow_page_caches caches = {
-		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
+		.page_header_cache = &vcpu->mmu_page_header_cache,
 		.shadow_page_cache = &vcpu->mmu_page_table_cache,
 		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
 	};
@@ -5917,8 +5916,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
 	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
-	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
+	vcpu->mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
+	vcpu->mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->mmu_page_table_cache.gfp_zero = __GFP_ZERO;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d3c1d08002af..4aa60d5d87b0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -44,8 +44,6 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
-extern struct kmem_cache *mmu_page_header_cache;
-
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 922815407b7e..891877a6fb78 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -263,7 +263,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->mmu_page_table_cache);
 
 	return sp;
diff --git a/include/kvm/mmu.h b/include/kvm/mmu.h
index 425db8e4f8e9..f1416828f8fe 100644
--- a/include/kvm/mmu.h
+++ b/include/kvm/mmu.h
@@ -4,6 +4,8 @@
 
 #include <kvm/mmu_types.h>
 
+extern struct kmem_cache *mmu_page_header_cache;
+
 static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0a9baa493760..ec3a6de6d54e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -391,6 +391,9 @@ struct kvm_vcpu {
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 	/* Cache used to allocate pages for use as page tables. */
 	struct kvm_mmu_memory_cache mmu_page_table_cache;
+
+	/* Cache used to allocate kvm_mmu_page structs. */
+	struct kvm_mmu_memory_cache mmu_page_header_cache;
 #endif
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 954ab969f55e..0f1d48ed7d57 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -108,6 +108,7 @@ static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
+struct kmem_cache *mmu_page_header_cache;
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
