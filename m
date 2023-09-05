Received: from out-216.mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DCBDDA8
	for <kvmarm@lists.linux.dev>; Tue,  5 Sep 2023 18:06:39 +0000 (UTC)
Date: Tue, 5 Sep 2023 11:06:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1693937197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWf0V7LgHDPNADTCt39gF6q3V8XNc51DCpIR5HUJ2EQ=;
	b=ODIOaaUBR3t/W03PG+9H+gBeI+TrdOywWQpdhaKwCOOxad7Ag2kSxA4N2VdiGsqu9exO9r
	lU91KCwMDpqgqfAx12ewwtc7maZB0BSg49J5U1mN5gPq8bcdwlrmZ+y1CFtusZ1uk9hL1p
	qdMtVvcEa9c+Uhdw3Pes+im1iBJkjeM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, maz@kernel.org,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
	ricarkol@google.com, tabba@google.com, bgardon@google.com,
	zhenyzha@redhat.com, yihyu@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH] KVM: arm64: Fix soft-lockup on relaxing PTE permission
Message-ID: <ZPduJ08GKaKXwIhM@linux.dev>
References: <20230904072826.1468907-1-gshan@redhat.com>
 <ZPWPoEgBETeI1um1@linux.dev>
 <0f93a015-4f10-b53e-f67f-a84db43ca533@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f93a015-4f10-b53e-f67f-a84db43ca533@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 05, 2023 at 10:06:14AM +1000, Gavin Shan wrote:

[...]

> >   static inline void __invalidate_icache_guest_page(void *va, size_t size)
> >   {
> > +	size_t nr_lines = size / __icache_line_size();
> > +
> >   	if (icache_is_aliasing()) {
> >   		/* any kind of VIPT cache */
> >   		icache_inval_all_pou();
> >   	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
> >   		   !icache_is_vpipt()) {
> >   		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> > -		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
> > +		if (nr_lines > MAX_TLBI_OPS)
> > +			icache_inval_all_pou();
> > +		else
> > +			icache_inval_pou((unsigned long)va,
> > +					 (unsigned long)va + size);
> >   	}
> >   }
> 
> I'm not sure if it's worthy to pull the @iminline from CTR_EL0 since it's almost
> fixed to 64-bytes. 

I firmly disagree. The architecture allows implementers to select a
different minimum line size, and non-64b systems _do_ exist in the wild.
Furthermore, some implementers have decided to glue together cores with
mismatched line sizes too...

Though we could avoid some headache by normalizing on 64b, the cold
reality of the ecosystem requires that we go out of our way to
accomodate ~any design choice allowed by the architecture.

> @size is guranteed to be PAGE_SIZE or PMD_SIZE aligned. Maybe
> we can just aggressively do something like below, disregarding the icache thrashing.
> In this way, the code is further simplified.
> 
>     if (size > PAGE_SIZE) {
>         icache_inval_all_pou();
>     } else {
>         icache_inval_pou((unsigned long)va,
>                          (unsigned long)va + size);
>     }                                                          // parantheses is still needed

This could work too but we already have a kernel heuristic for limiting
the amount of broadcast invalidations, which is MAX_TLBI_OPS. I don't
want to introduce a second, KVM-specific hack to address the exact same
thing.

> I'm leveraging the chance to ask one question, which isn't related to the issue.
> It seems we're doing the icache/dcache coherence differently for stage1 and stage-2
> page table entries. The question is why we needn't to clean the dcache for stage-2,
> as we're doing for the stage-1 case?

KVM always does its required dcache maintenance (if any) on the first
translation abort to a given IPA. On systems w/o FEAT_DIC, we lazily
grant execute permissions as an optimization to avoid unnecessary icache
invalidations, which as you've seen tends to be a bit of a sore spot.

Between the two faults, we've effectively guaranteed that any
host-initiated writes to the PA are visible to the guest on both the I
and D side. Any CMOs for making guest-initiated writes coherent after
the translation fault are the sole responsibility of the guest.

-- 
Thanks,
Oliver
