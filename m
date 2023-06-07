Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBB5626
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 12:37:34 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-94ea38c90ccso155267066b.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 05:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686141453; x=1688733453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnQ/nlpXFdeDPVk23AiI85QWmxk4si1+qvDGQ2nGaVk=;
        b=WdCmcmi6gOeqxet6yu45NdHenR/U+n90arFfFlbF92f1bGKkUxUJcZbgN70kep5JoH
         a28BTB/g1yUqMFuaG0oRtd+goDlcr5IWteNAtcdGtDczLW8T1oEfO1zTMkyTMRaZJtQB
         ir+U2yW2RefYHyPwHgNGGRPwn6aj18N5pbozR/bcopObOpzeXEEOp07mvxZqVBNwEVIe
         yWIxPf8xE1ekX5iNx4B6NJLu89rJegQoaHG0VgWHmVeUJMK8n5fB53uUYnBE4gm8PGlp
         SKTO0QDN5jtwxOicVMnJC1LrNlR3ChPRu1/lnsVAY0E2cXz/zvyddhTzMSmMi6PuMb1P
         T2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686141453; x=1688733453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnQ/nlpXFdeDPVk23AiI85QWmxk4si1+qvDGQ2nGaVk=;
        b=TOX1fwMPfpKNLhY6KtaBzFO7qJZB74vP5VMyblvEW0dLDiZcwIg5L2c8sX+hPtesK3
         iDF1ScN/tkqr5FMK7El80z0AWPo+98R2TC14E6us+1v766BYzH2CnfVKBVpw+S0fHLJo
         4+ZgaQMkozadj7HJ/e7D/b6XpzTG4yrl2qA+2jDA361ZMQ1JL4ci776HcsiMmkAY9N1f
         9RwOumTP3ZEfuc5nHlha4q6UjiZSFdHAz3losZbtnXVgc5GZ8JimcbhI52DTWmd7Yote
         Th4rsbLIM3NN6ynvbgXMXUCUGFIfzCuf2OnTo8qtc16ZxymTWArCpT5bhp7DPLQ5F7nD
         mY0A==
X-Gm-Message-State: AC+VfDzvbqIIXzm+h3aZl7mOWUV3WPjxrMa3NEQwF/OE2dEpOJ0uXkfP
	ihbLtiO4uaWPXQS8kVJriZU=
X-Google-Smtp-Source: ACHHUZ5Os8gHz/sUk05VCKCffL41JXPyEnL05xlbL7bdzUPi2lubA4aZLrQ2dJfHDa3HHg5XmuWhRQ==
X-Received: by 2002:a17:906:9d:b0:977:c446:3a24 with SMTP id 29-20020a170906009d00b00977c4463a24mr1734728ejc.7.1686141452404;
        Wed, 07 Jun 2023 05:37:32 -0700 (PDT)
Received: from localhost ([134.191.220.83])
        by smtp.gmail.com with ESMTPSA id pw12-20020a17090720ac00b00973fac6065esm6777913ejb.223.2023.06.07.05.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:37:32 -0700 (PDT)
Date: Wed, 7 Jun 2023 20:37:11 +0800
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
 tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
 ricarkol@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/16] KVM: arm64: Document the page table walker
 actions based on the callback's return value
Message-ID: <20230607203711.000054ae.zhi.wang.linux@gmail.com>
In-Reply-To: <ZH9tQjQk7QLyhUQR@google.com>
References: <20230602160914.4011728-1-vipinsh@google.com>
	<20230602160914.4011728-10-vipinsh@google.com>
	<20230605223520.00007fbd.zhi.wang.linux@gmail.com>
	<ZH9tQjQk7QLyhUQR@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 10:30:42 -0700
Vipin Sharma <vipinsh@google.com> wrote:

> On Mon, Jun 05, 2023 at 10:35:20PM +0800, Zhi Wang wrote:
> > On Fri,  2 Jun 2023 09:09:07 -0700
> > Vipin Sharma <vipinsh@google.com> wrote:
> > 
> > > Document what the page table walker do when walker callback function returns
> > > a value.
> > > 
> > > Current documentation is not correct as negative error of -EAGAIN on a
> > > non-shared page table walker doesn't terminate the walker and continues
> > > to the next step.
> > > 
> > > There might be a better place to keep this information, for now this
> > > documentation will work as a reference guide until a better way is
> > > found.
> > >
> > 
> > After reading the whole patch series, I was thinking it might be a good
> > time to improve the way how the visitor function and page table walker
> > talk to each other. The error code is good enough before, but its meaning
> > seems limited and vague when the visitor function wants to express more about
> > what exactly happens inside. I am not sure if it is a good idea to continue
> > that way: 1. found a new situation. 2. choosing a error code for visitor
> > function. 3. walker translates the error code into the situation to
> > handle. 4. document the error code and its actual meaning.
> > 
> > Eventually I am afraid that we are going to abuse the error code.
> 
> I agree that error numbers are not sufficient and this will become more
> difficult and cumbersome for more cases in future if we need different
> behavior based on different error codes for different visitor functions.
>
> > 
> > What about introducing a set of flags for the visitor function to express
> > what happened and simplify the existing error code?
> > 
> 
> If I understood correctly what you meant, I think this will also end up
> having the same issue down the line, we are just switching errors with
> flags as they might not be able to express everything.
> 
> "Flags for visitor function to express what happened"  - This is what
> ret val and errors do.
> 

Thanks so much for the efforts of the sample code.

But when the "ret val" is an error code for pgtable matters, It turns vague.
We have -EAGAIN to represent "retry" and "-ENONET" to represent PTE not there,
and they seems end up with different behaviors in different types of pgtable
walk. That is what I feels off.

visitor_cb has two different requirements of returning the status: 1)
something wrong happens *not* related to the pgtable, e.g. failing to
allocate memory. 2) something happens related to the pgtable. e.g PTE doesn't
exists.

For 1) It is natural to return an error code and the caller might just bail out
via its error handling path.

I think the core problem is: the two different usages are mixed and they don't
actually fit with each other. 2) is requiring more details in the future other
than a simple error code. 


For 2) I think it is better have a set of flags. the name of the flags can
carry more explicit meanings than error code. E.g.:

------------------

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..b3f24b321cd7 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -204,6 +204,15 @@ enum kvm_pgtable_walk_flags {
        KVM_PGTABLE_WALK_HANDLE_FAULT           = BIT(4),
 };

+struct kvm_pgtable_walk_status {
+       union {
+               u8 raw;
+               struct {
+                       unsigned retry:1;
+                       unsigned stop:1;
+                       unsigned ignore:1;
+               	/* more to come */
+               };
+       };
+};
+
 struct kvm_pgtable_visit_ctx {
        kvm_pte_t                               *ptep;
        kvm_pte_t                               old;
@@ -213,8 +222,10 @@ struct kvm_pgtable_visit_ctx {
        u64                                     end;
        u32                                     level;
        enum kvm_pgtable_walk_flags             flags;
+       struct kvm_pgtable_walk_status          *status;
 };

 typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
                                        enum kvm_pgtable_walk_flags visit);

----------------

Visitor functions sets the flags via ctx->status and kvm_pgtable_walk_xxx can
check the bits in the ctx to decide what to do for the next.

I can cook a patch for re-factoring this part if we think it is a good idea. 

> "simplify existing error code" - is very dependent on visitor function
> and caller of page table walker. This might not be able to cover all
> cases for the future also.
> 
> But I do agree that just error code is not sufficient and it will make
> it harder to handle shared vs non-shared walkers combinations with error
> code from visitor functions and walk action (exit, next, retry).
> 
> One approach I can think of is:
> Based on the visitor function return value, a page table walker will do
> 3 things:
> 
> 1. Move to next SPTE
> 2. Retry the current SPTE
> 3. Exit the walk and return the exit code.
> 
> struct kvm_pgtable_walker{}  will have two more callbacks
> 1. kvm_pgtable_walk_ignore(int ret, enum kvm_pgtable_walk_flags):
>    This will be set for each walker and walker will check with this
>    function intead of kvm_pgtable_walk_continue().
> 
> 2. kvm_pgtable_walk_retry(int ret, enum kvm_pgtable_walk_flags):
>    This will be set for each walker and walker will use it in
>    __kvm_pgtable_walk()  on the return value of __kvm_pgtable_visit() to
>    retry again.
> 
> This will allow to have walker be more configurable and each type of
> walker can be customized based on vistor function return and
> shared/non-shared walker combo. It will avoid having visitor function
> error code handling same in all walkers.
> 
> Below is a sample code (compile tested only):
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 850d65f705fa..9a96f61208af 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -243,6 +243,10 @@ struct kvm_pgtable_visit_ctx {
>  
>  typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
>  					enum kvm_pgtable_walk_flags visit);
> +struct kvm_pgtable_walker;
> +typedef bool (*kvm_pgtable_walker_action_fn_t)(const struct kvm_pgtable_walker *walker,
> +					      int ret);
> +
>  
>  static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *ctx)
>  {
> @@ -258,6 +262,8 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
>   */
>  struct kvm_pgtable_walker {
>  	const kvm_pgtable_visitor_fn_t		cb;
> +	const kvm_pgtable_walker_action_fn_t	ignore;
> +	const kvm_pgtable_walker_action_fn_t	retry;
>  	void * const				arg;
>  	const enum kvm_pgtable_walk_flags	flags;
>  };
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 364b68013038..28891a9c463a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -180,6 +180,12 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>  	return walker->cb(ctx, visit);
>  }
>  
> +static bool kvm_pgtable_walk_retry(const struct kvm_pgtable_walker *walker,
> +				      int r)
> +{
> +	return false;
> +}
> +
>  static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
>  				      int r)
>  {
> @@ -231,7 +237,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  		table = kvm_pte_table(ctx.old, level);
>  	}
>  
> -	if (!kvm_pgtable_walk_continue(data->walker, ret))
> +	if (!data->walker->ignore(data->walker, ret))
>  		goto out;
>  
>  	if (!table) {
> @@ -242,14 +248,14 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  
>  	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
>  	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> -	if (!kvm_pgtable_walk_continue(data->walker, ret))
> +	if (!data->walker->ignore(data->walker, ret))
>  		goto out;
>  
>  	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
>  		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
>  
>  out:
> -	if (kvm_pgtable_walk_continue(data->walker, ret))
> +	if (!data->walker->ignore(data->walker, ret))
>  		return 0;
>  
>  	return ret;
> @@ -260,19 +266,25 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>  {
>  	u32 idx;
>  	int ret = 0;
> +	kvm_pteref_t pteref;
>  
>  	if (WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS))
>  		return -EINVAL;
>  
>  	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
> -		kvm_pteref_t pteref = &pgtable[idx];
> +retry:
> +		pteref = &pgtable[idx];
>  
>  		if (data->addr >= data->end)
>  			break;
>  
>  		ret = __kvm_pgtable_visit(data, mm_ops, pteref, level);
> -		if (ret)
> +		if (ret) {
> +			if (data->walker->retry(data->walker, ret)) {
> +				goto retry;
> +			}
>  			break;
> +		}
>  	}
>  
>  	return ret;
> @@ -343,6 +355,8 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>  	struct leaf_walk_data data;
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= leaf_walker,
> +		.ignore = kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF,
>  		.arg	= &data,
>  	};
> @@ -474,6 +488,8 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>  	};
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= hyp_map_walker,
> +		.ignore = kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF,
>  		.arg	= &map_data,
>  	};
> @@ -533,6 +549,8 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	u64 unmapped = 0;
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= hyp_unmap_walker,
> +		.ignore = kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.arg	= &unmapped,
>  		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>  	};
> @@ -582,6 +600,8 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>  {
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= hyp_free_walker,
> +		.ignore = kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>  	};
>  
> @@ -958,6 +978,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	};
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_map_walker,
> +		.ignore		= kvm_pgtable_walk_continue,
> +		.retry		= kvm_pgtable_walk_retry,
>  		.flags		= flags |
>  				  KVM_PGTABLE_WALK_TABLE_PRE |
>  				  KVM_PGTABLE_WALK_LEAF,
> @@ -989,6 +1011,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	};
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_map_walker,
> +		.ignore		= kvm_pgtable_walk_continue,
> +		.retry		= kvm_pgtable_walk_retry,
>  		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
>  				  KVM_PGTABLE_WALK_LEAF,
>  		.arg		= &map_data,
> @@ -1048,6 +1072,8 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_unmap_walker,
> +		.ignore	= kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.arg	= pgt,
>  		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>  	};
> @@ -1070,7 +1096,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>  
>  	if (!kvm_pte_valid(ctx->old))
> -		return -EAGAIN;
> +		return -ENOENT;
>  
>  	data->level = ctx->level;
>  	data->pte = pte;
> @@ -1099,6 +1125,23 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	return 0;
>  }
>  
> +static bool stage2_attr_walker_retry(const struct kvm_pgtable_walker *walker, int ret)
> +{
> +	if (ret == -EAGAIN)
> +		return walker->flags & KVM_PGTABLE_WALK_SHARED
> +				&& !(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
> +	return false;
> +}
> +
> +static bool stage2_attr_walker_ignore(const struct kvm_pgtable_walker * walker, int ret)
> +{
> +	if (ret == -EAGAIN)
> +		return !(walker->flags & KVM_PGTABLE_WALK_SHARED);
> +	if (ret == -ENOENT)
> +		return !(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
> +	return false;
> +}
> +
>  static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>  				    u64 size, kvm_pte_t attr_set,
>  				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
> @@ -1112,6 +1155,8 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>  	};
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_attr_walker,
> +		.ignore		= stage2_attr_walker_ignore,
> +		.retry		= stage2_attr_walker_retry,
>  		.arg		= &data,
>  		.flags		= flags | KVM_PGTABLE_WALK_LEAF,
>  	};
> @@ -1217,6 +1262,8 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_flush_walker,
> +		.ignore	= kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF,
>  		.arg	= pgt,
>  	};
> @@ -1240,6 +1287,8 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>  	};
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_map_walker,
> +		.ignore		= kvm_pgtable_walk_continue,
> +		.retry		= kvm_pgtable_walk_retry,
>  		.flags		= KVM_PGTABLE_WALK_LEAF |
>  				  KVM_PGTABLE_WALK_SKIP_BBM_TLBI |
>  				  KVM_PGTABLE_WALK_SKIP_CMO,
> @@ -1377,6 +1426,8 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  {
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_split_walker,
> +		.ignore	= kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF,
>  		.arg	= mc,
>  	};
> @@ -1442,6 +1493,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>  	size_t pgd_sz;
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_free_walker,
> +		.ignore	= kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF |
>  			  KVM_PGTABLE_WALK_TABLE_POST,
>  	};
> @@ -1457,6 +1510,8 @@ void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *p
>  	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_free_walker,
> +		.ignore	= kvm_pgtable_walk_continue,
> +		.retry	= kvm_pgtable_walk_retry,
>  		.flags	= KVM_PGTABLE_WALK_LEAF |
>  			  KVM_PGTABLE_WALK_TABLE_POST,
>  	};

