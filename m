Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA0A15AC4
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:48:35 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57745160c1dso58219197b3.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724115; x=1692316115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/Q2YqUewU0QJU59tCBKplqkoUGv4ucil0ZC6wcpHcqQ=;
        b=tLDg009LSV9Tr1yXeY8d4SfO26PrwJIaLtLynftl5yKXvNFsST0X3aD0RRd4GHX/wv
         vtU1d3HuUEp4/WvsYO14a7YtyRpqHdAIKX5GRwFujpPChgWaWrOtfOGhpxiDxfb2FIcp
         Ae9zBTxW6KL3hmvrpUDBJiNqXIyNkauGtse5upwrlxh/E50i4d2vGBX75qEPajnBgZGc
         62JFVrZFAM+EhDxD7kWVSnkyBrTTVuPq5qxvIJYKXmn+OcNdrNUgMZjrQKHRGqfkHsON
         U3BqIvW3OKP/jQkfPxwptTqtHQZYGlpqMzy7K9mx0E1p+mdrooSa+nj413aqHz+roVeF
         gxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724115; x=1692316115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Q2YqUewU0QJU59tCBKplqkoUGv4ucil0ZC6wcpHcqQ=;
        b=Ba4sE5lLoY+mmY2Jonpkqa81YKyafn/jL6ONT5jfx44wuEHY4YMobZZv0SvTvr3cnr
         3mc3Ja6SPeeFldpEjUXVaWFq275rIwk1dycxPFxAPSf489uKhH9uerP0lunttvSone1U
         FJtDMCM6m/qk4LCokxkal7JFl/4EmzbZlFGSpdvJiIvBLBr2LqUEcZ/V4kPeEzV8Mg0q
         MLi1zgE+H+lSW+2Q+XqsTkUvflnkS8AU3XqmXzn9aam9O1J1ZY8LUjiOcYM/1ogIFiQv
         yR28BDh8uZELD/lPX3bm1PKOQGTNjMaxGvekwomAjCiv2IDao10ztd1CO2A0BUClBU9Q
         7D+A==
X-Gm-Message-State: ABy/qLaCXwgo1LmeC3Fb+Yhz4jFUEibmvBxwB0eeQJIwosb+vE5BEY4Q
	0R4N5ZX/N0Au0uH2Uc4084AXLCrW/to=
X-Google-Smtp-Source: APBJJlHjosfFmr47fAQ4FwoHYiy0rQprOrE8ng/AJ+BqBK9Dg+T53fJUISRxGIkaIZYnyupUcGSciTRGnxE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b61d:0:b0:57a:141f:b4f7 with SMTP id
 u29-20020a81b61d000000b0057a141fb4f7mr40058ywh.6.1689724115002; Tue, 18 Jul
 2023 16:48:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:44:45 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-3-seanjc@google.com>
Subject: [RFC PATCH v11 02/29] KVM: Tweak kvm_hva_range and hva_handler_t to
 allow reusing for gfn ranges
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d58b7a506d27..50aea855eeae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -516,21 +516,25 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
-typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 			     unsigned long end);
 
 typedef void (*on_unlock_fn_t)(struct kvm *kvm);
 
-struct kvm_hva_range {
-	unsigned long start;
-	unsigned long end;
+struct kvm_mmu_notifier_range {
+	/*
+	 * 64-bit addresses, as KVM notifiers can operate on host virtual
+	 * addresses (unsigned long) and guest physical addresses (64-bit).
+	 */
+	u64 start;
+	u64 end;
 	union {
 		pte_t pte;
 		u64 raw;
 	} arg;
-	hva_handler_t handler;
+	gfn_handler_t handler;
 	on_lock_fn_t on_lock;
 	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
@@ -557,7 +561,7 @@ static void kvm_null_fn(void)
 	     node = interval_tree_iter_next(node, start, last))	     \
 
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
-						  const struct kvm_hva_range *range)
+						  const struct kvm_mmu_notifier_range *range)
 {
 	bool ret = false, locked = false;
 	struct kvm_gfn_range gfn_range;
@@ -588,9 +592,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			unsigned long hva_start, hva_end;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
-			hva_start = max(range->start, slot->userspace_addr);
-			hva_end = min(range->end, slot->userspace_addr +
-						  (slot->npages << PAGE_SHIFT));
+			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
+			hva_end = min_t(unsigned long, range->end,
+					slot->userspace_addr + (slot->npages << PAGE_SHIFT));
 
 			/*
 			 * To optimize for the likely case where the address
@@ -640,10 +644,10 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
 						pte_t pte,
-						hva_handler_t handler)
+						gfn_handler_t handler)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range range = {
+	const struct kvm_mmu_notifier_range range = {
 		.start		= start,
 		.end		= end,
 		.arg.pte	= pte,
@@ -660,10 +664,10 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
 							 unsigned long start,
 							 unsigned long end,
-							 hva_handler_t handler)
+							 gfn_handler_t handler)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range range = {
+	const struct kvm_mmu_notifier_range range = {
 		.start		= start,
 		.end		= end,
 		.handler	= handler,
@@ -750,7 +754,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range hva_range = {
+	const struct kvm_mmu_notifier_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
 		.handler	= kvm_unmap_gfn_range,
@@ -814,7 +818,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range hva_range = {
+	const struct kvm_mmu_notifier_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
 		.handler	= (void *)kvm_null_fn,
-- 
2.41.0.255.g8b1d071c50-goog

