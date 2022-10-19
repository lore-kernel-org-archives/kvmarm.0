Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04D853BD
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 23:17:48 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so1637804pji.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 16:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Me73D3UIfDoCysc1MWGMK8EUvSaCv+Air3k0VL/BRN8=;
        b=RmCtH8neEhRNB9EOWZTVkrahvAUVFTRCLPGLyV9Nb3VYKC99nZ2WwGhFzKu2zd6HVj
         0uiDQ0fsRP8/n8QzU7kIqDtbhRIkGoQL/i2SdXmhp8SDWC6ergvgFiSb+W1w4zuFcH2a
         SZWduHd7knWotjL0Mm+L4nTpW9p7iR7JwE0yMzWN95zSotrbo9VjGX9yuDLmvdWRphjX
         +H/H0qojfkImnsy0HIgOG6NIde3/7kIqOsCbLwiptGca8qtknEBtRNZfKvvivPq7IDt2
         3TNIVxbQksE24xTQ6z60h2Xdhr09RmEmeKnumzKlYfhKoC5eBLWNh5BT2+XEE/q2I0Cj
         6aTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Me73D3UIfDoCysc1MWGMK8EUvSaCv+Air3k0VL/BRN8=;
        b=ZBWlGehflHSUnoJpkrrAhF4ve+7wOjLlkZLSsVVS7dzpFQJ4GKJCIFUAZWrcF2G+UO
         G1z9Z2Yu7+iqUVppQuUCnsN5cIYMLV63wMaSi8KjEWK7mgNzv/9nu8lhRraJALj/EScO
         0pAp+ie+OPhOt+GhXUwUkufVMuHF0YFADbAu2cT5u0PDE0ROfA+Jx+zKbe7yxTUre+0v
         OuSa+wMmn+LVyLt86jyKPM7IsZ0DXOugfBeVNVP3Qx0lgcFCgmG0PYNAEdCPRa85pwP5
         I/N8Bys/fTb7j1I0M3Tx2yNNAtZYeXKJBg8C9DgEpC70g+ARMLqP+gY/KtSBXQUddHqF
         BgeQ==
X-Gm-Message-State: ACrzQf0yu+PKww4084JsY2MlMINjqkIuqF6XNCMw17o+S1pIrxoewOxs
	OE7MZt2sN2pz1lv+fmMIS7xOtg==
X-Google-Smtp-Source: AMsMyM7BE+rbsUH5R/9cYMnwScFvrtkWbyHC05khyxy3u7jhhyoNaEpU284lTQQEk+0awE2RbPVfvw==
X-Received: by 2002:a17:90a:b28d:b0:20d:6790:19fa with SMTP id c13-20020a17090ab28d00b0020d679019famr47693623pjr.68.1666221468020;
        Wed, 19 Oct 2022 16:17:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902ea0800b00176a579fae8sm6310265plg.210.2022.10.19.16.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:17:47 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:17:43 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 07/15] KVM: arm64: Use an opaque type for pteps
Message-ID: <Y1CFl8sLllXm4seK@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-8-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007232818.459650-8-oliver.upton@linux.dev>
Message-ID: <20221019231743.28qXyqLrXmOEiZ3VrhqI6ML041oswUmmIaFfgWRrz1w@z>

On Fri, Oct 07, 2022, Oliver Upton wrote:
> Use an opaque type for pteps and require visitors explicitly dereference
> the pointer before using. Protecting page table memory with RCU requires
> that KVM dereferences RCU-annotated pointers before using. However, RCU
> is not available for use in the nVHE hypervisor and the opaque type can
> be conditionally annotated with RCU for the stage-2 MMU.
> 
> Call the type a 'pteref' to avoid a naming collision with raw pteps. No
> functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  9 ++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++-----------
>  2 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c33edcf36b5b..beb89eac155c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -25,6 +25,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>  
>  typedef u64 kvm_pte_t;
>  
> +typedef kvm_pte_t *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +	return pteref;

Returning the pointer is unsafe (when it becomes RCU-protected).  The full
dereference of the data needs to occur under RCU protection, not just the retrieval
of the pointer.  E.g. this (straw man) would be broken

	bool table = kvm_pte_table(ctx.old, level);

	rcu_read_lock();
	ptep = kvm_dereference_pteref(pteref, flags & KVM_PGTABLE_WALK_SHARED);
	rcu_read_unlock();

	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);

	if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
		ctx.old = READ_ONCE(*ptep);
		table = kvm_pte_table(ctx.old, level);
	}

as the read of the entry pointed at by ptep could be to a page table that is freed
in an RCU callback.

The naming collision you are trying to avoid is a symptom of this bad pattern,
as there should never be "raw" pteps floating around, at least not in non-pKVM
contexts that utilize RCU.

> +}
> +
>  #define KVM_PTE_VALID			BIT(0)
>  
>  #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
> @@ -170,7 +177,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>  struct kvm_pgtable {
>  	u32					ia_bits;
>  	u32					start_level;
> -	kvm_pte_t				*pgd;
> +	kvm_pteref_t				pgd;
>  	struct kvm_pgtable_mm_ops		*mm_ops;
>  
>  	/* Stage-2 only */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 02c33fccb178..6b6e1ed7ee2f 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>  }
>  
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
> +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
>  
>  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  				      struct kvm_pgtable_mm_ops *mm_ops,
> -				      kvm_pte_t *ptep, u32 level)
> +				      kvm_pteref_t pteref, u32 level)
>  {
>  	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> +	kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
>  	struct kvm_pgtable_visit_ctx ctx = {
>  		.ptep	= ptep,
>  		.old	= READ_ONCE(*ptep),

This is where you want the protection to kick in, e.g. 

  typedef kvm_pte_t __rcu *kvm_ptep_t;

  static inline kvm_pte_t kvm_read_pte(kvm_ptep_t ptep)
  {
	return READ_ONCE(*rcu_dereference(ptep));
  }

		.old	= kvm_read_pte(ptep),

In other words, the pointer itself isn't that's protected, it's PTE that the
pointer points at that's protected.

rcu_dereference() has no overhead when CONFIG_PROVE_RCU=n, i.e. there's no reason
to "optimize" dereferences.
