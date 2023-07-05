Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B4879EA
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688566653; x=1720102653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dxaLcFyIX6B15hyemUTtg4E+16m6duFMnhi44AUxrxk=;
  b=aa7cDsX5UbUuummWdbY055EtQEHtGMh65yQUfcuRSzhSlPt1rxts1wP2
   bNlhjxDv7hd8o8VzzteflO1ezzrG3QnOWIiIejRhXqL4CPM5dD7ax6lY3
   e/e1fqb0vC3eUTE5BzI5V9z25fvlZXRFcWjFIuQdGRcBy8DuaI/LbJgYf
   rJQwAbGlI1c83nlp3fdDma+qPEcRygi93zBJyjIlVMfae1NQZPwMKhVcp
   vHrGbXz51LGIZsOZwAr++lqucHt07iGdm+MSDdjleNCowe+mSWIfekDru
   E8wXbecyjVHWdbOAonID90mXoFLeVJUt6Cze6l7VcXcUytA8HcVMAMYnb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362218767"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="362218767"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 07:17:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="965848045"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="965848045"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 07:17:27 -0700
Date: Wed, 5 Jul 2023 22:17:42 +0800
From: Yu Zhang <yu.c.zhang@linux.intel.com>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230705141741.xqvjddsoo5qgax63@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
User-Agent: NeoMutt/20171215

> > @@ -883,7 +884,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >   */
> >  static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
> >  {
> > -	bool host_writable;
> > +	bool host_writable, is_refcounted;
> >  	gpa_t first_pte_gpa;
> >  	u64 *sptep, spte;
> >  	struct kvm_memory_slot *slot;
> > @@ -940,10 +941,12 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
> >  	sptep = &sp->spt[i];
> >  	spte = *sptep;
> >  	host_writable = spte & shadow_host_writable_mask;
> > +	// TODO: is this correct?
> > +	is_refcounted = spte & SPTE_MMU_PAGE_REFCOUNTED;
> >  	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >  	make_spte(vcpu, sp, slot, pte_access, gfn,
> >  		  spte_to_pfn(spte), spte, true, false,
> > -		  host_writable, &spte);
> > +		  host_writable, is_refcounted, &spte);
> 
> Could we restrict that a non-refcounted page shall not be used as shadow page?

Oh, sorry. It's not about shadow page. It's about guest page being
mapped as not refcounted. Silly me...

B.R.
Yu
