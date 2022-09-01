Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12658ECAAD1
	for <kvmarm@archiver.kernel.org>; Thu,  1 Sep 2022 18:28:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C5844B1BC;
	Thu,  1 Sep 2022 14:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zS-7gPRjtXS3; Thu,  1 Sep 2022 14:28:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A0DF4B139;
	Thu,  1 Sep 2022 14:28:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 484DF4B129
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 14:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ct5r1ZEfxnpd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2022 14:28:26 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 222344B106
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 14:28:26 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id q63so17142357pga.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2022 11:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=ndIldFWnVpsGGglHDvm5sbA1GFSZXj+Lb11rFvaAIxc=;
 b=O4paYpiLTVY0VgAIqU37vnsePtMIHdV8Tdht1kbOh9nj3tZOaxPN+eNKX2uD8EkrXS
 qRdtD+RFHo/m/EFVRGfobsca709lx9J+abTaGCSNgenTSXVIWGJjxXlsjZL0qfydqxfc
 NZAHhYe8cokYcGUZTUeuSv00yXUl8aUP6+FqzPYLkxBu++iQIEkl/1E303qGRnzVCHji
 sGtrPr4XZh0dNPdsXe2bmhBfTkyvF1Wla7lJ0cmhFTtmsjL+8Y2Q4vbgdI94tWpDihTm
 Vh174PI59JxYmvNgz0QiMXVS79uBrI1Kw4mCy9HHN2/doa1FZ8Ijf86Udrh8ZH4akeae
 8+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=ndIldFWnVpsGGglHDvm5sbA1GFSZXj+Lb11rFvaAIxc=;
 b=psKk7vp4XCKEsJtQG0znYNaqFFKu5/cVpOAIIeDjXuQ4c0bQkBIPO4D7lzr1UB7sJ4
 U3F6ZqdVs6HmJt5qnaG/oSJ5Q2pqnEcqhk9a4cEPPhRC/Wgrzsgeor1mMwOumqJAVITV
 9y2rwFLWdifwRBli6XcCWSvASdMBRc2+kCuOniBOQu+aB+YDmsXt7W58fbZVgVtBz9fK
 kGFPj/vyXzs0KTqUOHxRvx+m49ey/bi7rd5W4gxFTwVaB2ru1tsZ+b6l433HmGvJC38x
 XIjKHlFxeaA++drqlRtEcODQU1bnk3EF3SrgU5nCeHqnwMfT6gAI7lklmTPc5czMEmTb
 pcIg==
X-Gm-Message-State: ACgBeo13xoqLzKfIGbPceJNPUJDjZub+SUEI/I84UOEomdvFcDi7pQSO
 2steqhnIOnmtCxpVUJmhOdURCw==
X-Google-Smtp-Source: AA6agR6Iqqu2gbxjfzpo94RaERqt3s4eH3fhv4y8aOOlDwv+8rGWsd0X6aJxjFxvfeLoOIPEAPaYZg==
X-Received: by 2002:a05:6a00:170c:b0:537:27b4:ebfe with SMTP id
 h12-20020a056a00170c00b0053727b4ebfemr32335453pfc.19.1662056905019; 
 Thu, 01 Sep 2022 11:28:25 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 t11-20020a170902dccb00b001755f43bc22sm1825756pll.175.2022.09.01.11.28.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Sep 2022 11:28:24 -0700 (PDT)
Date: Thu, 1 Sep 2022 11:28:20 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <YxD5xIMaU8Qxw68O@google.com>
References: <20220823234727.621535-1-ricarkol@google.com>
 <20220823234727.621535-8-ricarkol@google.com>
 <20220829172508.oc3rr44q2irwudi5@kamzik>
 <Yw6JAiIfenYafJnZ@google.com> <Yw6T591G5hGTBx2t@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yw6T591G5hGTBx2t@google.com>
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

On Tue, Aug 30, 2022 at 10:49:11PM +0000, Sean Christopherson wrote:
> On Tue, Aug 30, 2022, Ricardo Koller wrote:
> > On Mon, Aug 29, 2022 at 07:25:08PM +0200, Andrew Jones wrote:
> > > On Tue, Aug 23, 2022 at 11:47:21PM +0000, Ricardo Koller wrote:
> > > I feel we'll be revisiting this frequently when more and more region types
> > > are desired. For example, Sean wants a read-only memory region for ucall
> > > exits. How about putting a mem slot array in struct kvm_vm, defining an
> > > enum to index it (which will expand), and then single helper function,
> > > something like
> > > 
> > >  inline struct userspace_mem_region *
> > >  vm_get_mem_region(struct kvm_vm *vm, enum memslot_type mst)
> > >  {
> > >     return memslot2region(vm, vm->memslots[mst]);
> > >  }
> 
> 
> > > 
> > > > +
> > > >  /* Minimum allocated guest virtual and physical addresses */
> > > >  #define KVM_UTIL_MIN_VADDR		0x2000
> > > >  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > > > @@ -637,19 +662,51 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> > > >  			      vm_paddr_t paddr_min, uint32_t memslot);
> > > >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> > > >  
> > > > +#define MEM_PARAMS_MAX_MEMSLOTS 3
> > > 
> > > And this becomes MEMSLOT_MAX of the enum proposed above
> > > 
> > >  enum memslot_type {
> > >      MEMSLOT_CODE,
> > >      MEMSLOT_PT,
> > >      MEMSLOT_DATA,
> 
> "memslot" is going to be confusing, e.g. MEMSLOT_MAX is some arbitrary selftests
> constant that has no relationship to maximum number of memslots.
> 
> > >      MEMSLOT_MAX,
> 
> I dislike "max" because it's ambiguous, e.g. is it the maximum number of regions,
> or is the max valid region?
> 
> Maybe something like this?
> 
> 	enum kvm_mem_region_type {
> 		MEM_REGION_CODE
> 		...
> 		NR_MEM_REGIONS,
> 	}
> 
> > > > +#else
> > > > +	.mode = VM_MODE_DEFAULT,
> > > > +#endif
> > > > +	.region[0] = {
> > > > +		.src_type = VM_MEM_SRC_ANONYMOUS,
> > > > +		.guest_paddr = 0,
> > > > +		.slot = 0,
> > > > +		/*
> > > > +		 * 4mb when page size is 4kb. Note that vm_nr_pages_required(),
> > > > +		 * the function used by most tests to calculate guest memory
> > > > +		 * requirements uses around ~520 pages for more tests.
> > > 
> > > ...requirements, currently returns ~520 pages for the majority of tests.
> > > 
> > > > +		 */
> > > > +		.npages = 1024,
> > > 
> > > And here we double it, but it's still fragile. I see we override this
> > > in __vm_create() below though, so now I wonder why we set it at all.
> > > 
> > 
> > I would prefer having a default that can be used by a test as-is. WDYT?
> > or should we make it explicit that the default needs some updates?
> 
> In that case, the default should be '0'.  There are two users of ____vm_create().
> __vm_create() takes the number of "extra" pages and calculates the "base" number
> of pages.  vm_create_barebones() passes '0', i.e. can use default.
> 
> If '0' as a default is too weird, make it an illegal value and force the caller
> to define the number of pages.

Sounds good, will try '0', and will make sure that not defining the
number of pages results in a clear error.

> 
> It's not a coincidence that those are the only two callers, ____vm_create() isn't
> intended to be used directly.  If a test wants to create a VM just to create a VM,
> then it shoulid use vm_create_barebones().  If a test wants to doing anything
> remotely useful with the VM, it should use __vm_create() or something higher up
> the food chain.

Thank you both for the reviews. I think this is ready for a v6, so
sending one soon.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
