Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87692ECAAD4
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 22:49:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E33B14B47F;
	Tue, 30 Aug 2022 18:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9CQfHs8SNVl; Tue, 30 Aug 2022 18:49:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9F44B4A5;
	Tue, 30 Aug 2022 18:49:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3CA04B2C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 18:49:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OxXM+y6+ewqX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 18:49:16 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AED994B47F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 18:49:16 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id c66so2488828pfc.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=5oVGlJD5RlpBf+9i4Q45ZK+hg97pjNTENblv1UXq3mI=;
 b=a2RBon5JNWe3lm0XYeQauPY76q6W2TLM+z8FitojgMaKdSmaQlb6yyVmHkhA/GD2m/
 cC5zmwa1XAV64X5H6e35KV4icyiHKe3Wi0+1fN2+WWwAxXfms+jqFCSyBKSmUV5xUmG/
 o4ps6SIQQE5nCz5X75SpO3DbIgbzM+HEcQq2S7a3uHaigKrFVd9Mj/1ygcm7tcvZva6F
 m2llpT20jV3TgGoMSebcQ06SbKyy3PB7grIz7ahMHa6kUdYPxpOaFcqaZGUUXbszMaqg
 fraBOme/Rsv25LSBMP2rKk58LZr0e4SmoXiQFQt2sj5L9o/BiEaqxuRlS7+lf7RL1hp0
 174g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=5oVGlJD5RlpBf+9i4Q45ZK+hg97pjNTENblv1UXq3mI=;
 b=GZNdt0QyDpkeizu2esr5LEp5NIJFeJbUFWHaAlygVNQpwOJev1denAxeXN0MgYM9+/
 Kn8uVNUaDqFL8LiSkwxe29PI9Q0ClRBmOTzxFNQUr2AKIIYaFw+yyVEgJRUDFKAmkVq6
 Uf28dud5Kgz8dwHsU3AJYcZTxUVaj05Z3/yNauIm7RotMLvw5vp17VXYplrfIioetdtP
 6UU8QkyVf+FejcQjDx56v2deIsyIHsME1L2RCz2u2bkOStl8ZSg+KyV+Ew00CFtkD0XM
 lk4vsQ/4nWeYzUSw24x/kifpow1UPgb1U8qOeFRJHKKd/Ojl0f8q/30Di7m5xn7pmnsj
 GKPA==
X-Gm-Message-State: ACgBeo0hFn8OgCBFmctbooJrqXUYcU+lMCOiIl/EHvnLMfAHUQetS/t6
 Kx8R+KyUWmdWvh5JdXjtrNwdMA==
X-Google-Smtp-Source: AA6agR5ucf7AY4Hf9zxzxqljlu4xWd8WTb4l/ihE6IyhFh+R+7yPhC7zESFtQu1dU8jXxRWFTZHAbg==
X-Received: by 2002:a05:6a00:230f:b0:52f:6734:90fe with SMTP id
 h15-20020a056a00230f00b0052f673490femr23777723pfh.67.1661899755594; 
 Tue, 30 Aug 2022 15:49:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 k18-20020aa79732000000b00539aa7f0b53sm2237687pfg.104.2022.08.30.15.49.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Aug 2022 15:49:15 -0700 (PDT)
Date: Tue, 30 Aug 2022 22:49:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v5 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <Yw6T591G5hGTBx2t@google.com>
References: <20220823234727.621535-1-ricarkol@google.com>
 <20220823234727.621535-8-ricarkol@google.com>
 <20220829172508.oc3rr44q2irwudi5@kamzik>
 <Yw6JAiIfenYafJnZ@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yw6JAiIfenYafJnZ@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 Andrew Jones <andrew.jones@linux.dev>, dmatclack@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Aug 30, 2022, Ricardo Koller wrote:
> On Mon, Aug 29, 2022 at 07:25:08PM +0200, Andrew Jones wrote:
> > On Tue, Aug 23, 2022 at 11:47:21PM +0000, Ricardo Koller wrote:
> > I feel we'll be revisiting this frequently when more and more region types
> > are desired. For example, Sean wants a read-only memory region for ucall
> > exits. How about putting a mem slot array in struct kvm_vm, defining an
> > enum to index it (which will expand), and then single helper function,
> > something like
> > 
> >  inline struct userspace_mem_region *
> >  vm_get_mem_region(struct kvm_vm *vm, enum memslot_type mst)
> >  {
> >     return memslot2region(vm, vm->memslots[mst]);
> >  }


> > 
> > > +
> > >  /* Minimum allocated guest virtual and physical addresses */
> > >  #define KVM_UTIL_MIN_VADDR		0x2000
> > >  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > > @@ -637,19 +662,51 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> > >  			      vm_paddr_t paddr_min, uint32_t memslot);
> > >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> > >  
> > > +#define MEM_PARAMS_MAX_MEMSLOTS 3
> > 
> > And this becomes MEMSLOT_MAX of the enum proposed above
> > 
> >  enum memslot_type {
> >      MEMSLOT_CODE,
> >      MEMSLOT_PT,
> >      MEMSLOT_DATA,

"memslot" is going to be confusing, e.g. MEMSLOT_MAX is some arbitrary selftests
constant that has no relationship to maximum number of memslots.

> >      MEMSLOT_MAX,

I dislike "max" because it's ambiguous, e.g. is it the maximum number of regions,
or is the max valid region?

Maybe something like this?

	enum kvm_mem_region_type {
		MEM_REGION_CODE
		...
		NR_MEM_REGIONS,
	}

> > > +#else
> > > +	.mode = VM_MODE_DEFAULT,
> > > +#endif
> > > +	.region[0] = {
> > > +		.src_type = VM_MEM_SRC_ANONYMOUS,
> > > +		.guest_paddr = 0,
> > > +		.slot = 0,
> > > +		/*
> > > +		 * 4mb when page size is 4kb. Note that vm_nr_pages_required(),
> > > +		 * the function used by most tests to calculate guest memory
> > > +		 * requirements uses around ~520 pages for more tests.
> > 
> > ...requirements, currently returns ~520 pages for the majority of tests.
> > 
> > > +		 */
> > > +		.npages = 1024,
> > 
> > And here we double it, but it's still fragile. I see we override this
> > in __vm_create() below though, so now I wonder why we set it at all.
> > 
> 
> I would prefer having a default that can be used by a test as-is. WDYT?
> or should we make it explicit that the default needs some updates?

In that case, the default should be '0'.  There are two users of ____vm_create().
__vm_create() takes the number of "extra" pages and calculates the "base" number
of pages.  vm_create_barebones() passes '0', i.e. can use default.

If '0' as a default is too weird, make it an illegal value and force the caller
to define the number of pages.

It's not a coincidence that those are the only two callers, ____vm_create() isn't
intended to be used directly.  If a test wants to create a VM just to create a VM,
then it shoulid use vm_create_barebones().  If a test wants to doing anything
remotely useful with the VM, it should use __vm_create() or something higher up
the food chain.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
