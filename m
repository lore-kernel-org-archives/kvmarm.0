Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEE32E0D8
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 17:42:59 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b3cab3a48dso39188055ad.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 10:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686850979; x=1689442979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3VaVpYnKKIXM0ZMJBv2BahWS6rKgSDR5ikxQlp7Qm5M=;
        b=CRqM4fJoSy0TOwQEM+dwNf4YLmN8ZNvadtNeqmejsTpkrhB3fUKCS5gVORcT3YAFGF
         i/3D4htNDkxjLmMQr6ex9h88D9Mn3b3BcimZjQyHYDLLHrnhvGGLYYK4DnkhEsQ6CVaZ
         cXJTMz7MEXsf3MpnUFcr6Mx0t4RSwdzHZHJMQ/Gw529RF41s9TMoKGTDzFQ40JREZYAz
         j/q5bFPXA1TGS/pjeQnxzb2ibh5u61Yat52z5h2i3whlu/NZWmrHHKlNBlQzVnj3NGqb
         fUd5ZYUT6Xx5VG3C07mjHJV5Ti0lFZylCk6cioTWTVk9aptHHtPLM7okEk048bn6RBzX
         EGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686850979; x=1689442979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3VaVpYnKKIXM0ZMJBv2BahWS6rKgSDR5ikxQlp7Qm5M=;
        b=k5llaXCVU+IT67HupxtKafgedUGd4HiHY9++QumVyEJJT1QrwA0z93Zms4zWPk/L2E
         7tZOJgPbXBcr4RVG7rvhbCJ+6ucm4WqJieeNCMksGRZmlAGgFf2dH3Dp5SYGWTSpgDts
         JlPHq+GM6IGDzm/Nsc0wstGbXH6VpS0x2Kg2wNdXh/nnfyznJFfGfA61plVCfP5386ag
         kJgPdy3gRzRqpjXWYHHOHcyWWOdX4y2biwbk3KM2ZLyGhZyv1RonWFiYVtfXuhvxLvRw
         JgNufGPl1WFezevluFNEL7hRBco+zyw9EkGB8ffoUdPzDz4cRsuLGD5P2YwemDfrkIiG
         rEcA==
X-Gm-Message-State: AC+VfDzZ0sXDNrvemi5DeCYqV8lWScZQk+CfVPcYFzV6znhTsVIa9nqO
	AO6oerqlK7SMvzMyPei8WgiUkJWSmeU=
X-Google-Smtp-Source: ACHHUZ4cQlpzVe0KczazAvYqGjGYoNkXv8UVqui26XxKS9kOBWmazT/WNj+BhRRRMGskVfw0J/AilzSk6Q0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7d3:b0:1b5:147f:d8d1 with SMTP id
 h19-20020a170902f7d300b001b5147fd8d1mr547182plw.3.1686850979254; Thu, 15 Jun
 2023 10:42:59 -0700 (PDT)
Date: Thu, 15 Jun 2023 10:42:57 -0700
In-Reply-To: <20230526234435.662652-2-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-2-yuzhao@google.com>
Message-ID: <ZItNoeWriZgLUaon@google.com>
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add mmu_notifier_ops->test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michael Larabel <michael@michaellarabel.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, May 26, 2023, Yu Zhao wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0e571e973bc2..374262545f96 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -258,6 +258,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
>  struct kvm_gfn_range {
>  	struct kvm_memory_slot *slot;
> +	void *args;

There's no reason to make this "void *", just declare "struct test_clear_young_args"
in the header.  Arch code won't be able to use it regardless.  And I vote for
something more like "test_clear_young_metadata", as there's far more information
in there than just function arguments.

And to stave off the argument that "void *" would allow reuse, take this opportunity
to unionize the test_clear_young field with the change_pte field, e.g.

	/* comment about these fields being callback specific. */
	union {
		struct test_clear_young_metadata *metadata;
		pte_t pte;
		unsigned long callback_arg; /* needs a better name */
	};

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 51e4882d0873..31ee58754b19 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -541,6 +541,7 @@ typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
>  typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>  
>  struct kvm_hva_range {
> +	void *args;

Same feedback as kvm_gfn_range.

>  	unsigned long start;
>  	unsigned long end;
>  	pte_t pte;
> @@ -549,6 +550,7 @@ struct kvm_hva_range {
>  	on_unlock_fn_t on_unlock;
>  	bool flush_on_ret;
>  	bool may_block;
> +	bool lockless;
>  };
>  
>  /*
> @@ -602,6 +604,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			hva_end = min(range->end, slot->userspace_addr +
>  						  (slot->npages << PAGE_SHIFT));
>  
> +			gfn_range.args = range->args;

And this goes away because the generic callback_arg is what gets propagated.

> +
>  			/*
>  			 * To optimize for the likely case where the address
>  			 * range is covered by zero or one memslots, don't
> @@ -619,7 +623,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
>  			gfn_range.slot = slot;
>  
> -			if (!locked) {
> +			if (!range->lockless && !locked) {
>  				locked = true;
>  				KVM_MMU_LOCK(kvm);
>  				if (!IS_KVM_NULL_FN(range->on_lock))
> @@ -628,6 +632,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  					break;
>  			}
>  			ret |= range->handler(kvm, &gfn_range);
> +
> +			if (range->lockless && ret)

I don't like overloading "lockless" to also mean "stop on ret".  Just add another
flag, there's literally no cost for most callbacks as everything is constant at
compile time and gets optimized away.

> +		range.args = &args;
> +		range.lockless = true;

The lockless and stop_on_ret behavior needs comments.

> +		range.handler = kvm_arch_test_clear_young;
> +
> +		if (!__kvm_handle_hva_range(kvm, &range))
> +			return args.young ? MMU_NOTIFIER_RANGE_LOCKLESS : 0;
> +	}
> +
> +	if (bitmap)
> +		return 0;
> +
> +	range.args = NULL;
> +	range.lockless = false;

No need to manually clear these, they'll be zeroed by the initialization code.

E.g. all in all, something like so

---
 include/linux/kvm_host.h |  9 +++++++--
 virt/kvm/kvm_main.c      | 29 +++++++++++++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7a0922cbc36f..e04605061f5e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,12 +256,17 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
+struct test_clear_young_metadata;
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
-	void *args;
 	gfn_t start;
 	gfn_t end;
-	pte_t pte;
+	union {
+		struct test_clear_young_metadata *metadata;
+		pte_t pte;
+		unsigned long callback_arg;
+	};
 	bool may_block;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ac83cfb30771..8cf4fee9cd8b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -536,16 +536,20 @@ typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 typedef void (*on_unlock_fn_t)(struct kvm *kvm);
 
 struct kvm_hva_range {
-	void *args;
 	unsigned long start;
 	unsigned long end;
-	pte_t pte;
 	hva_handler_t handler;
+	union {
+		struct test_clear_young_metadata *metadata;
+		pte_t pte;
+		unsigned long callback_arg;
+	};
 	on_lock_fn_t on_lock;
 	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
 	bool lockless;
+	bool stop_on_ret;
 };
 
 /*
@@ -576,6 +580,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int i, idx;
 
+	BUILD_BUG_ON(sizeof(gfn_range.callback_arg) != sizeof(gfn_range.pte) ||
+		     sizeof(gfn_range.callback_arg) != sizeof(gfn_range.metadata));
+
 	if (WARN_ON_ONCE(range->end <= range->start))
 		return 0;
 
@@ -599,16 +606,14 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
 
-			gfn_range.args = range->args;
-
 			/*
 			 * To optimize for the likely case where the address
 			 * range is covered by zero or one memslots, don't
 			 * bother making these conditional (to avoid writes on
 			 * the second or later invocation of the handler).
 			 */
-			gfn_range.pte = range->pte;
 			gfn_range.may_block = range->may_block;
+			gfn_range.callback_arg = range->callback_arg;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -628,7 +633,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			}
 			ret |= range->handler(kvm, &gfn_range);
 
-			if (range->lockless && ret)
+			/* comment goes here. */
+			if (range->stop_on_ret && ret)
 				break;
 		}
 	}
@@ -830,7 +836,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
 }
 
-struct test_clear_young_args {
+struct test_clear_young_metadata {
 	unsigned long *bitmap;
 	unsigned long end;
 	bool clear;
@@ -839,7 +845,7 @@ struct test_clear_young_args {
 
 bool kvm_should_clear_young(struct kvm_gfn_range *range, gfn_t gfn)
 {
-	struct test_clear_young_args *args = range->args;
+	struct test_clear_young_metadata *args = range->metadata;
 
 	VM_WARN_ON_ONCE(gfn < range->start || gfn >= range->end);
 
@@ -880,14 +886,15 @@ static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_
 	trace_kvm_age_hva(start, end);
 
 	if (kvm_test_clear_young) {
-		struct test_clear_young_args args = {
+		struct test_clear_young_metadata args = {
 			.bitmap	= bitmap,
 			.end	= end,
 			.clear	= clear,
 		};
 
-		range.args = &args;
 		range.lockless = true;
+		range.stop_on_ret = true;
+		range.metadata = &args;
 		range.handler = kvm_test_clear_young;
 
 		if (!__kvm_handle_hva_range(kvm, &range))
@@ -897,8 +904,6 @@ static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_
 	if (bitmap)
 		return 0;
 
-	range.args = NULL;
-	range.lockless = false;
 	range.handler = clear ? kvm_age_gfn : kvm_test_age_gfn;
 
 	return __kvm_handle_hva_range(kvm, &range) ? MMU_NOTIFIER_RANGE_YOUNG : 0;

base-commit: 7a5d8be2c18415b73b9380741095f439d6983a40
-- 

