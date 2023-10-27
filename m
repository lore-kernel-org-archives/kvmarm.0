Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667FC358AE
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SFK8naUc"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1c9d140fcddso23364015ad.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430947; x=1699035747; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ySJgJVuGTMb9d8TKULAih8JyrrSd4YVeUb9Jc+6kES0=;
        b=SFK8naUcUFpBr9J4Zy+gtrZmTtoBZJU1oeGcDln757P79raysGfcNwps4CxBdcR4O5
         HKgvZlgLyT37IDUzl751WJieXJ15cre7lOpSLgRZrW7T62x9zO9CwYqDfz6cqgy7geUY
         evUy8KBDlEBcMjc+m6cxjNx/YfI0irwf0TfDU0JIHSIGMKrHW+brTYHXh4Lf9oOxa1a6
         4brOH41vQX/1HIal2hg0Zi/PtRVG1DY8/AhfjF4UhS0gObU8jKkIMkCzJQIXiknu1rG/
         LCduMGAhfqHCviQey8H9pTReSEgwkvXZJKAcrpLdenXaEMjMWtqiUFsKh6CHMrtYAP8N
         HUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430947; x=1699035747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ySJgJVuGTMb9d8TKULAih8JyrrSd4YVeUb9Jc+6kES0=;
        b=gwXcHGDscAHRc6kHbYRQhmLlKdybSMYSpfHuPuGbhFstaTnIR48+pxkaSe5Psf2v+c
         /qiEYscgHxWAbBOdZu1inA89V/RVmIyn0I5ue4lQ8dGPPKOiqJhg2ObnvA4gxuX4k18Z
         YuOtnX971hf6vEn5TrfxEkMcCUWW4v/GATpC49dwxFQ/VjXSaI8o3CTNAiVOmD+QF7Ow
         /kXIIsHDnclnrBhNSTiPe6EQgU1Y0CKQ0hRopQYIM5yVKYJca5hBOVFOeyQ8ykji4Lf5
         bGgL+wV6hvxr6L651lG8g0MK5tCeV8rUK9Cygbb2NZ09oR4HsheVZPrdWBtettGG0WNj
         RG/w==
X-Gm-Message-State: AOJu0YzUW7bP/0+gjVIN3kHR8nhTwonfqsfC9QHdOXx3vmyTeqhw/SrO
	EK80fbzAXKFFRvmCxUb8gB2qiybJNz4=
X-Google-Smtp-Source: AGHT+IEjsuFrlNkUUm601K8PUP+r8R6hCJNbQUJrGpc/pHCXTUzh4iBnaMaTICwCQxjFnojaM1raJDMMRNs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ac8e:b0:1cc:30cf:eae6 with SMTP id
 h14-20020a170902ac8e00b001cc30cfeae6mr955plr.10.1698430947671; Fri, 27 Oct
 2023 11:22:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:21:43 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-2-seanjc@google.com>
Subject: [PATCH v13 01/35] KVM: Tweak kvm_hva_range and hva_handler_t to allow
 reusing for gfn ranges
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Rework and rename "struct kvm_hva_range" into "kvm_mmu_notifier_range" so
that the structure can be used to handle notifications that operate on gfn
context, i.e. that aren't tied to a host virtual address.  Rename the
handler typedef too (arguably it should always have been gfn_handler_t).

Practically speaking, this is a nop for 64-bit kernels as the only
meaningful change is to store start+end as u64s instead of unsigned longs.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..0524933856d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -541,18 +541,22 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
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
 	union kvm_mmu_notifier_arg arg;
-	hva_handler_t handler;
+	gfn_handler_t handler;
 	on_lock_fn_t on_lock;
 	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
@@ -581,7 +585,7 @@ static const union kvm_mmu_notifier_arg KVM_MMU_NOTIFIER_NO_ARG;
 	     node = interval_tree_iter_next(node, start, last))	     \
 
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
-						  const struct kvm_hva_range *range)
+						  const struct kvm_mmu_notifier_range *range)
 {
 	bool ret = false, locked = false;
 	struct kvm_gfn_range gfn_range;
@@ -608,9 +612,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
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
@@ -660,10 +664,10 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
 						union kvm_mmu_notifier_arg arg,
-						hva_handler_t handler)
+						gfn_handler_t handler)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range range = {
+	const struct kvm_mmu_notifier_range range = {
 		.start		= start,
 		.end		= end,
 		.arg		= arg,
@@ -680,10 +684,10 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
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
@@ -771,7 +775,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range hva_range = {
+	const struct kvm_mmu_notifier_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
 		.handler	= kvm_unmap_gfn_range,
@@ -835,7 +839,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range hva_range = {
+	const struct kvm_mmu_notifier_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
 		.handler	= (void *)kvm_null_fn,
-- 
2.42.0.820.g83a721a137-goog

