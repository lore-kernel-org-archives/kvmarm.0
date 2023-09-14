Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7D1186E
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:55:52 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d7e79ec07b4so573845276.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656552; x=1695261352; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c0gbqnW9KUovCg+coU7ldlYhYVFXBRbmaH2jYlXJSe8=;
        b=C7VA0hG99oJxbbRxc65ocpCADG1tQ+e7jBLZokV2xVq8mGMXJNaY9mNSmFHIoAy7/+
         wEQvXBbOVJS7esrjNh4fFWVuH34KN4pYh/M6drhSa4UGB2xJ9lci4OuSIJvZ1oJOzFSx
         LohylsR2UOyqbj0/vEI4L3AqbnL8pHK8VME5NtsYWrSBBoaRUzmH1Z8gMYS63IuEzqvX
         t0UnVTjEx09dCsRE6sdhje5IMlr1lTjRTmDdckXOrGJHRQkn3mgncGIn179U8Yqu/QUY
         OSASEInbpPFhP7KvS9/9/DyslksWDQBZsU6JfzkcbNtLa+4qY4KGZ/3X28DDuokNMyy4
         OrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656552; x=1695261352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c0gbqnW9KUovCg+coU7ldlYhYVFXBRbmaH2jYlXJSe8=;
        b=fp1s2dGDC6vOiAHqZWUsLTEid0uEIvG2PL24n3K+79FK9Al3k1nKNMqS1acKSl2IhR
         8dsZMZo2P2wanKSjK/Ywh9RE606+HAnaekGqsaFYAs5g2XDLRYT2h3tO3pFPJXWM7FNk
         hPUgnOdV32UvV1VyBkDoRK1PkfgcSwlF83jub9HJ6ZpWvHIomdLFUEqATY8zWEjyYPfo
         29iNlncJ3GKJ6TAsrGADFFwsegLevx5F4L1aNRq4SZyTPuDEziRoxA8YCYnV5bYSpgsY
         89NB5RX0ejDHIMRcT2slPXYITN2N7p3Zw6VzAKRpZSesGrC/9PoQa5znhyrCs6K+6WKU
         WBrg==
X-Gm-Message-State: AOJu0YxmqAgEZnWKaOGS7wofVHn37qiqsqjW06VJe6U4DNRBVc2aHwfh
	rFEPHnZ3GCFZyPXuubrcXTCn33Snbdk=
X-Google-Smtp-Source: AGHT+IG9pkaa+NfBfBN3tv0PMD61sScfAedWpdRl9BNgXYxxGW/3XiB249I/ScBV6f/2zKuHHJhj18tIK2Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:83d0:0:b0:d78:3c2e:b186 with SMTP id
 v16-20020a2583d0000000b00d783c2eb186mr79839ybm.5.1694656552108; Wed, 13 Sep
 2023 18:55:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:06 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-9-seanjc@google.com>
Subject: [RFC PATCH v12 08/33] KVM: Add a dedicated mmu_notifier flag for
 reclaiming freed memory
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
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Handle AMD SEV's kvm_arch_guest_memory_reclaimed() hook by having
__kvm_handle_hva_range() return whether or not an overlapping memslot
was found, i.e. mmu_lock was acquired.  Using the .on_unlock() hook
works, but kvm_arch_guest_memory_reclaimed() needs to run after dropping
mmu_lock, which makes .on_lock() and .on_unlock() asymmetrical.

Use a small struct to return the tuple of the notifier-specific return,
plus whether or not overlap was found.  Because the iteration helpers are
__always_inlined, practically speaking, the struct will never actually be
returned from a function call (not to mention the size of the struct will
be two bytes in practice).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 53 +++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c0e38752526..76d01de7838f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -561,6 +561,19 @@ struct kvm_mmu_notifier_range {
 	bool may_block;
 };
 
+/*
+ * The inner-most helper returns a tuple containing the return value from the
+ * arch- and action-specific handler, plus a flag indicating whether or not at
+ * least one memslot was found, i.e. if the handler found guest memory.
+ *
+ * Note, most notifiers are averse to booleans, so even though KVM tracks the
+ * return from arch code as a bool, outer helpers will cast it to an int. :-(
+ */
+typedef struct kvm_mmu_notifier_return {
+	bool ret;
+	bool found_memslot;
+} kvm_mn_ret_t;
+
 /*
  * Use a dedicated stub instead of NULL to indicate that there is no callback
  * function/handler.  The compiler technically can't guarantee that a real
@@ -582,22 +595,25 @@ static const union kvm_mmu_notifier_arg KVM_MMU_NOTIFIER_NO_ARG;
 	     node;							     \
 	     node = interval_tree_iter_next(node, start, last))	     \
 
-static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
-						  const struct kvm_mmu_notifier_range *range)
+static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
+							   const struct kvm_mmu_notifier_range *range)
 {
-	bool ret = false, locked = false;
+	struct kvm_mmu_notifier_return r = {
+		.ret = false,
+		.found_memslot = false,
+	};
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
 	struct kvm_memslots *slots;
 	int i, idx;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
-		return 0;
+		return r;
 
 	/* A null handler is allowed if and only if on_lock() is provided. */
 	if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
 			 IS_KVM_NULL_FN(range->handler)))
-		return 0;
+		return r;
 
 	idx = srcu_read_lock(&kvm->srcu);
 
@@ -631,8 +647,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
 
-			if (!locked) {
-				locked = true;
+			if (!r.found_memslot) {
+				r.found_memslot = true;
 				KVM_MMU_LOCK(kvm);
 				if (!IS_KVM_NULL_FN(range->on_lock))
 					range->on_lock(kvm);
@@ -640,14 +656,14 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 				if (IS_KVM_NULL_FN(range->handler))
 					break;
 			}
-			ret |= range->handler(kvm, &gfn_range);
+			r.ret |= range->handler(kvm, &gfn_range);
 		}
 	}
 
-	if (range->flush_on_ret && ret)
+	if (range->flush_on_ret && r.ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (locked) {
+	if (r.found_memslot) {
 		KVM_MMU_UNLOCK(kvm);
 		if (!IS_KVM_NULL_FN(range->on_unlock))
 			range->on_unlock(kvm);
@@ -655,8 +671,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
-	/* The notifiers are averse to booleans. :-( */
-	return (int)ret;
+	return r;
 }
 
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
@@ -677,7 +692,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.may_block	= false,
 	};
 
-	return __kvm_handle_hva_range(kvm, &range);
+	return __kvm_handle_hva_range(kvm, &range).ret;
 }
 
 static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
@@ -696,7 +711,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.may_block	= false,
 	};
 
-	return __kvm_handle_hva_range(kvm, &range);
+	return __kvm_handle_hva_range(kvm, &range).ret;
 }
 
 static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -796,7 +811,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= kvm_mmu_unmap_gfn_range,
 		.on_lock	= kvm_mmu_invalidate_begin,
-		.on_unlock	= kvm_arch_guest_memory_reclaimed,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -828,7 +843,13 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
 					  hva_range.may_block);
 
-	__kvm_handle_hva_range(kvm, &hva_range);
+	/*
+	 * If one or more memslots were found and thus zapped, notify arch code
+	 * that guest memory has been reclaimed.  This needs to be done *after*
+	 * dropping mmu_lock, as x86's reclaim path is slooooow.
+	 */
+	if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
+		kvm_arch_guest_memory_reclaimed(kvm);
 
 	return 0;
 }
-- 
2.42.0.283.g2d96d420d3-goog

