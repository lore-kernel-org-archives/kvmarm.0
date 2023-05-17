Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15B28ED
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 08:50:01 +0000 (UTC)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-510d8b0163fso732a12.1
        for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 01:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684313400; x=1686905400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FV3cgaXrRim03Zv5RsIztXE6qsQTmKvePMx6UdbcnHo=;
        b=u4+zZhJVd27DKctMsWsPOgOn1m9CFVQEw7gE9RPjW8DqJrnmKYJVldPqnEjDaEyNyC
         3IbX7M/Iw+pdXmnG0dIPBnaSbVFe6yEcLwe9enb5VKTH/NZoj4lawv9Oi1ov8gXxg8UR
         GRSC3itpJIDIfEgKM/vO1wgsvxuxQkvLSAgiMNeL87FsAGjJtPz0Lf2YukL8hq4Y/X1B
         ZRI+9gpRrGgoec7HSGsnSUxUB85c/jCcUCeygMBvMNjqToZ991zTs/TtRu8EgowqtMUM
         C0bUNN9TbO3J+IH58OegwuWnhEaQNfYB/EkJNsVeMtKTyNDRCgxCdu5Ojd/uOiTFAkg6
         D6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684313400; x=1686905400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FV3cgaXrRim03Zv5RsIztXE6qsQTmKvePMx6UdbcnHo=;
        b=ZxmXNtht9RjH/ok/fu222vQP7Clo0JwXtG0G3Q+mMA45ypzMIrDY9a2kOon91z4UaX
         dc1xixdEr844szVTmPUBAhEQ7KjaWJfwx6zMOiuovIrHyrostGfoWJZIXwOyVDqr6Ndm
         paOMwooOcUvFhrdAxwlk49RBc8UJOB7YxhZ2+HQkiTdhYu2Av5TktwfLOys46u1tw7WY
         5bMhyFg7b6FUh9T5+RZDmqXAVqzRXQyAsnSjCkWf5QaUBL6QynfS7NOi5BhiU1+tidcy
         i3dkexvvFEbx3r9MJNqc7SHYvwLLP3sifJYEDLP934hQoP/Ws5IWDQjIcXqkrgY9o+td
         RYig==
X-Gm-Message-State: AC+VfDzIspOaSHhfZgxqdsgy+YM6A7xUvFi/v180lA0CGNtLfZIxZ3fJ
	Xo/pwpljISBgg4kFdTcD2hAR3lHE0/ivZ3tSnmBQqg==
X-Google-Smtp-Source: ACHHUZ7iZT4/9Vl8NYIv57z1XhtnLw/lJOemGSIwTmff1YZitCRxWMZh6O31qgrB5k4+XuqNLgLtIA==
X-Received: by 2002:a50:d59d:0:b0:502:2af:7b1d with SMTP id v29-20020a50d59d000000b0050202af7b1dmr59200edi.3.1684313399910;
        Wed, 17 May 2023 01:49:59 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id u15-20020adfed4f000000b00307c46f4f08sm2001145wro.79.2023.05.17.01.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 01:49:59 -0700 (PDT)
Date: Wed, 17 May 2023 08:49:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	tabba@google.com, qperret@google.com, will@kernel.org,
	catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com
Subject: Re: [PATCH] KVM: arm64: Use BTI for pKVM
Message-ID: <ZGSVLl90+YHNKWc9@google.com>
References: <20230516141846.792193-1-smostafa@google.com>
 <864jocmg75.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jocmg75.wl-maz@kernel.org>

Hi Marc,

On Tue, May 16, 2023 at 04:47:10PM +0100, Marc Zyngier wrote:
> On Tue, 16 May 2023 15:18:46 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
> > However, the nvhe code doesn't make use of it as it doesn't map any
> > pages with Guarded Page(GP) bit.
> > 
> > This patch maps pKVM .text section with GP bit which matches the
> > kernel handling for BTI.
> 
> Why pKVM only? Surely we can benefit from it all over the nvhe code,
> right?
Yes, I will add it also for nvhe in v2.

> > 
> > A new flag is added to enum kvm_pgtable_prot: KVM_PGTABLE_PROT_GP_S1,
> > which represents BTI guarded page in hypervisor stage-1 page table.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 3 +++
> >  arch/arm64/kvm/hyp/nvhe/setup.c      | 8 ++++++--
> >  arch/arm64/kvm/hyp/pgtable.c         | 6 ++++--
> >  3 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 4cd6762bda80..5bcd06d664d3 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -151,6 +151,7 @@ enum kvm_pgtable_stage2_flags {
> >   * @KVM_PGTABLE_PROT_W:		Write permission.
> >   * @KVM_PGTABLE_PROT_R:		Read permission.
> >   * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
> > + * @KVM_PGTABLE_PROT_GP_S1:	GP(guarded page) used for BTI in stage-1 only
> >   * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
> >   * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
> >   * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
> > @@ -163,6 +164,8 @@ enum kvm_pgtable_prot {
> >  
> >  	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
> >  
> > +	KVM_PGTABLE_PROT_GP_S1			= BIT(50),
> > +
> >  	KVM_PGTABLE_PROT_SW0			= BIT(55),
> >  	KVM_PGTABLE_PROT_SW1			= BIT(56),
> >  	KVM_PGTABLE_PROT_SW2			= BIT(57),
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 110f04627785..95f80e2b2946 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -66,7 +66,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >  {
> >  	void *start, *end, *virt = hyp_phys_to_virt(phys);
> >  	unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
> > -	enum kvm_pgtable_prot prot;
> > +	enum kvm_pgtable_prot prot = PAGE_HYP_EXEC;
> >  	int ret, i;
> >  
> >  	/* Recreate the hyp page-table using the early page allocator */
> > @@ -88,7 +88,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >  	if (ret)
> >  		return ret;
> >  
> > -	ret = pkvm_create_mappings(__hyp_text_start, __hyp_text_end, PAGE_HYP_EXEC);
> > +	/* Hypervisor text is mapped as guarded pages(GP). */
> > +	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) && cpus_have_const_cap(ARM64_BTI))
> > +		prot |= KVM_PGTABLE_PROT_GP_S1;
> 
> Is there any reason why this isn't a final cap? I also dislike the
> IS_ENABLED(), but I can see that we don't have separate caps for
> in-kernel BTI and userspace visible BTI...
I was trying to make this close to EL1 code (system_supports_bti()),
I see in hypervisor cpus_have_const_cap is the same as cpus_have_final_cap.

Yes, I don't see a way to distinguish if BTI was enabled for the kernel
in EL2 without CONFIG_ARM64_BTI_KERNEL.

> > +
> > +	ret = pkvm_create_mappings(__hyp_text_start, __hyp_text_end, prot);
> >  	if (ret)
> >  		return ret;
> >  
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 3d61bd3e591d..028e198acd48 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -145,7 +145,8 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> >  	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
> >  							   KVM_PTE_TYPE_BLOCK;
> >  
> > -	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
> > +	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI |
> > +		       KVM_PGTABLE_PROT_GP_S1);
> >  	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
> >  	pte |= KVM_PTE_VALID;
> >  
> > @@ -378,7 +379,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> >  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
> >  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
> >  	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
> > -	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
> > +	attr |= prot & (KVM_PTE_LEAF_ATTR_HI_SW | KVM_PGTABLE_PROT_GP_S1);
> > +
> 
> You should probably check that the page is executable before blindly
> accepting to set the GP bit (don't accept it for non-exec pages).
Will do in v2.

> Another thing to check would be the state of SCTLR_EL2.BT, which I
> think we clear by construction, but it be worth having a look.
Yes, I see it is initialised by zero in ___kvm_hyp_init in hyp-init.S,
I believe this should be changed to 1 when BTI is enabled (as in
bti_enable() for EL1), I will update it.

Thanks,
Mostafa
