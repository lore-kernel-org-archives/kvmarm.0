Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099BD3C080
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1g2wIkQ"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1cc1ddb34ccso9088485ad.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430967; x=1699035767; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fLrd3AGy66HdihfPmI58EyyG3FCGELBv0TZMEZAIG4Y=;
        b=z1g2wIkQNkXqI96iKlb/9aewGhg/T0i3qraOOSnN19tC84+SUl1yMLUwydr6dRzgUf
         qJAGL9TJPvYxQlzlY1Y7UgkWjE/XDkJPZv5HKwb9X7HBIr4B1mETy1rCC9XIDiReMsKK
         nPxCtGROrIaDfRXhxbB7za5JpNfqjR+U47n8MVy9SQa/R4SSxmnsMsuTALfeD6Aql/AO
         ab2MN82d5I6xY9LcoaadEZ1YfC0h3jOg+vztcR6f9r0NrJLHRXeQpuU44R+xgQFKVeT6
         bnWdioO2lKbRDzw4oLd0vuLQDrvpFiYtlYoV5a7YtTn1h+2aUpUhE/mO3lYLGeGHLpOK
         vLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430967; x=1699035767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fLrd3AGy66HdihfPmI58EyyG3FCGELBv0TZMEZAIG4Y=;
        b=pexUEV263h5YwsNyKx/69v56TJ3Vd8qHRdXXhcdrRhy4kA+2SEbUMQ8lS8ZLsr0Mz6
         Nf/lIL4Bbyj2eyFI1303CB8wbfO2qKiKxZMorAqxntA0mtblR17alXqdXV+pIxOmwzWu
         QfCNpX5PzOc2tVrNSA1tnzdpKhqWPH3ykI/FoTMeE0MWM4gRZ4e0oMj1f/MmKnTZv9O/
         SJBB/aGVLMQNyVD4o1YlBb7isapYvqd/gqyIcNdkiofzftWmz6T/42oxu91xCHeuttG2
         mHAuFct7WcpTM7fXjJW7lpoCYzykWlImskbTNiJWxeMGvRU8s0MSwlF7fz+6UX9zLopK
         Igfw==
X-Gm-Message-State: AOJu0YzVfRwCpxVxIBwXP4ZPvr45fl5bm4KqV4KoWuerlDUIXUdSZkCs
	46mz4Bsi40HDRElgxqoJuealvGiREI0=
X-Google-Smtp-Source: AGHT+IFw7CMiVxkdfLmPKgztX5f1RnQlL4BTlZlVKLxMz6aRVtHUrQY578kvMdkjnRTl6BBw2VS25sQYIRo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ee14:b0:1ca:b952:f5fa with SMTP id
 z20-20020a170902ee1400b001cab952f5famr63161plb.5.1698430967325; Fri, 27 Oct
 2023 11:22:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:21:53 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-12-seanjc@google.com>
Subject: [PATCH v13 11/35] KVM: Drop .on_unlock() mmu_notifier hook
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

Drop the .on_unlock() mmu_notifer hook now that it's no longer used for
notifying arch code that memory has been reclaimed.  Adding .on_unlock()
and invoking it *after* dropping mmu_lock was a terrible idea, as doing so
resulted in .on_lock() and .on_unlock() having divergent and asymmetric
behavior, and set future developers up for failure, i.e. all but asked for
bugs where KVM relied on using .on_unlock() to try to run a callback while
holding mmu_lock.

Opportunistically add a lockdep assertion in kvm_mmu_invalidate_end() to
guard against future bugs of this nature.

Reported-by: Isaku Yamahata <isaku.yamahata@intel.com>
Link: https://lore.kernel.org/all/20230802203119.GB2021422@ls.amr.corp.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2bc04c8ae1f4..cb9376833c18 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -544,7 +544,6 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
-typedef void (*on_unlock_fn_t)(struct kvm *kvm);
 
 struct kvm_mmu_notifier_range {
 	/*
@@ -556,7 +555,6 @@ struct kvm_mmu_notifier_range {
 	union kvm_mmu_notifier_arg arg;
 	gfn_handler_t handler;
 	on_lock_fn_t on_lock;
-	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
 };
@@ -663,11 +661,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && r.ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (r.found_memslot) {
+	if (r.found_memslot)
 		KVM_MMU_UNLOCK(kvm);
-		if (!IS_KVM_NULL_FN(range->on_unlock))
-			range->on_unlock(kvm);
-	}
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
@@ -687,7 +682,6 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.arg		= arg,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
-		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
@@ -706,7 +700,6 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.end		= end,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
-		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
@@ -813,7 +806,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= kvm_mmu_unmap_gfn_range,
 		.on_lock	= kvm_mmu_invalidate_begin,
-		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -858,6 +850,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 
 void kvm_mmu_invalidate_end(struct kvm *kvm)
 {
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -889,7 +883,6 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= (void *)kvm_null_fn,
 		.on_lock	= kvm_mmu_invalidate_end,
-		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
-- 
2.42.0.820.g83a721a137-goog

