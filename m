Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA27F353A80
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005247; cv=none; b=eCip5a8Df4KIEnLl4zE9JZIeFk0vHAOrOT4hlUYM4O07KbBzehVczSgQaM8kNJ/sgu08nBTGSnHuPfbajurgIT40cHjtDwQP3YQfWqEi0AlvHjo1B0buunwBy9xs49qDqSq+OQwPAGKGclmMaVWhpOdRnpcTlsrwgvLAKrqJLvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005247; c=relaxed/simple;
	bh=xQ2qEnl6si4rsCe66zkhZjVBokz+b5DsvyYlJkvqmSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=pTdNnfZvwbt+ywZm/hY8MRl5+xzhi1wezsbh5lmcB08IeOqCDtgG9+hJy5Fkk9yOF8zDYdIB89ZsBZv7Ay2UOE8bzsQMpX/aJKh/YjurMwEMZGYBEpBk3KD7Y9DuiPoQKHvXdOcVkSg/xBzPEF5w6fClD6ke0FX3N33D9RC68bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VHXqM6Y9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VHXqM6Y9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04D43359D;
	Thu,  2 Jul 2026 08:13:59 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 746ED3F85F;
	Thu,  2 Jul 2026 08:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783005243; bh=xQ2qEnl6si4rsCe66zkhZjVBokz+b5DsvyYlJkvqmSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHXqM6Y9G1bp5VXld+d6xzRdUpytLRIrTpIBD/386Dfref8lSq6Mll4PfJV+LDEwx
	 //wrDRgu5CG5oahAgqoy8G6ESZCG8CWsxcCB1TLKu9xlq130n/VibreHCXWBPM/O1u
	 L9F460YHC5y+aXR16SGndqk6epXtlvUPm/WghuOw=
From: Leonardo Bras <leo.bras@arm.com>
To: Bradley Morgan <include@grrlz.net>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: arm64: Record whether pKVM stage 2 mapping is cacheable
Date: Thu,  2 Jul 2026 16:13:56 +0100
Message-ID: <akaANBMra5WaJSup@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6495D546-8FC7-4A31-B18C-88F34E1B64BB@grrlz.net>
References: <20260701192428.17430-1-include@grrlz.net> <86qzllpy1g.wl-maz@kernel.org> <akZJIm6mTza7qAuu@LeoBrasDK> <6495D546-8FC7-4A31-B18C-88F34E1B64BB@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 02, 2026 at 03:52:14PM +0100, Bradley Morgan wrote:
> On July 2, 2026 12:18:58 PM GMT+01:00, Leonardo Bras <leo.bras@arm.com>
> wrote:
> >On Thu, Jul 02, 2026 at 09:59:23AM +0100, Marc Zyngier wrote:
> >> + Vincent, Leo
> >> 
> >> On Wed, 01 Jul 2026 20:24:28 +0100,
> >> Bradley Morgan <include@grrlz.net> wrote:
> >> > 
> >> > pKVM keeps its own mapping list for stage 2 operations. Its flush path
> >> > uses that list directly, so it lost the PTE attribute check done by
> >the
> >> > generic stage 2 walker.
> >> > 
> >> > Record whether a mapping is cacheable and skip cache maintenance for
> >> > mappings that are not cacheable.
> >> > 
> >> > Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
> >> > Signed-off-by: Bradley Morgan <include@grrlz.net>
> >> > ---
> >> > Changes since V3:
> >> > - addressed some review :)
> >> 
> >> This isn't a change log. If you want to be taken seriously, I'd
> >> suggest you start by following the process. You are otherwise wasting
> >> people's time. Again.
> >
> >Agree... the process has a reason: the changelog here helps the reviewer 
> >having an overview of what actually changed between versions, and that 
> >makes reviewing much easier, and costs very little to the contributor.
> >
> >Also, the 1 week waiting time is really important, as mentioned before, as
> >it allows more reviewers and maintainers to give feedback: different 
> >people, from different companies and lifestyles have different schedules 
> >for dev/rev, but in general it happens weekly. So waiting for a week is 
> >really recommended, as it tends to avoid people re-reading 2+ versions of 
> >the same patchset, and allows revs time to discuss the suggestions in the 
> >same thread.
> >
> >(I know the waiting can be really frustating, and that sending a vN+1 fast
> >seems to show that you are interested in it, but it really does not help)
> 
> Well, it's fair, let me give you reasoning on why I do quick Rerolls.
> 
> So, if I do something wrong, e.g: checkpatch, I don't want to wait a week,
> because I would get grilled for a said checkpatch failure.
> 

Fair, but people would not avoid reviewing your new version due to a 
checkpath/etc issue. It's common to just report/ignore that and go on with 
the code that matters. 

Also, checkpath is a good example of what you can run in your code before 
sending, so it does not become a respin.

> 
> In this case, I was just excited /shrug.

It's okay. Been there as well :)

> >> 
> >> You also failed to Cc people who have provided feedback on previous
> >> versions. That's not right.
> >
> >(Bradley: usually you want as many people as possible to review your
> >stuff, 
> >so CC'ing previous reviewers is actually good for you)
> 
> Vincent not being CCed was dumb of me, no idea how I didn't get him on get
> maintainers.
> 
> For you, I didn't want to annoy you with another patch, since maintainers
> tend to be stressed and annoyed. And I didn't wanna add on to the pain.
> 

Don't worry on this. Previous reviewers can just ignore the e-mail if 
they don't find it interesting anymore.

> >> 
> >> > 
> >> >  arch/arm64/kvm/pkvm.c | 51
> >++++++++++++++++++++++++++++++++++---------
> >> >  1 file changed, 41 insertions(+), 10 deletions(-)
> >> > 
> >> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> >> > index 053e4f733e4b..6d1cad890c7e 100644
> >> > --- a/arch/arm64/kvm/pkvm.c
> >> > +++ b/arch/arm64/kvm/pkvm.c
> >> > @@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct
> >pkvm_mapping *m)
> >> >  	return m->gfn * PAGE_SIZE;
> >> >  }
> >> >  
> >> > +#define PKVM_MAPPING_NR_PAGES_MASK     GENMASK_ULL(47, 0)
> >> > +#define PKVM_MAPPING_NC                        BIT_ULL(48)
> >> > +
> >> > +static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
> >> > +{
> >> > +	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> >> > +}
> >> 
> >> No. You've been pointed to the correct data structure (an anonymous
> >> structure containing bit fields). Please consider taking the review
> >> comments into account.
> >
> >(and if you do not agree with the suggestion, discuss it in the same 
> >thread. Although as Marc shows below, it becames much simpler like that)
> >
> >Thanks! 
> >Leo
> >
> 
> I'll test it. If it's good. I'll do 
> 
> Suggested-by? Or co-developed by?

I would say none. It's just a change suggestion to your patch, made by a 
reviewer. 

IIRC 'Suggested-by' is used if someone suggested the idea for the patch, 
such as "ah, you should do this thing before", etc. It's both for giving 
credit and showing people the idea for that was not yours, for multiple 
reasons.

> 
> I'll hold the patch on for a week.
> 

Good! 
If you get too excited, I suggest reading other people's patches. Everybody 
makes mistakes, and the solutions / suggestions are really interesting :)

> 
> Thanks you lot for taking my bull crap.
> 

It's not bad, the process just goes like that for everybody.
It's just slower than people expect :)

We get slightly better over time, but still make mistakes.
(And try our best not to make the same mistakes again :)

Thanks for contributing!
Leo


> >> 
> >> This would avoid most of the churn in this patch, and make it easy to
> >> backport. Something like the untested hack below.
> >> 
> >> 	M.
> >> 
> >> diff --git a/arch/arm64/include/asm/kvm_pkvm.h
> >b/arch/arm64/include/asm/kvm_pkvm.h
> >> index 74fedd9c5ff02..cdddc9e3a11f5 100644
> >> --- a/arch/arm64/include/asm/kvm_pkvm.h
> >> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> >> @@ -195,7 +195,10 @@ struct pkvm_mapping {
> >>  	struct rb_node node;
> >>  	u64 gfn;
> >>  	u64 pfn;
> >> -	u64 nr_pages;
> >> +	struct {
> >> +		unsigned long nr_pages:48;
> >> +		unsigned int  nc:1;
> >> +	};
> >>  	u64 __subtree_last;	/* Internal member for interval tree */
> >>  };
> >>  
> >> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> >> index 428723b1b0f5c..5932b93bded58 100644
> >> --- a/arch/arm64/kvm/pkvm.c
> >> +++ b/arch/arm64/kvm/pkvm.c
> >> @@ -369,7 +369,7 @@ static int __pkvm_pgtable_stage2_unshare(struct
> >kvm_pgtable *pgt, u64 start, u64
> >>  
> >>  	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
> >>  		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
> >> -					mapping->nr_pages);
> >> +					(u64)mapping->nr_pages);
> >>  		if (WARN_ON(ret))
> >>  			return ret;
> >>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> >> @@ -473,6 +473,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt,
> >u64 addr, u64 size,
> >>  	mapping->gfn = gfn;
> >>  	mapping->pfn = pfn;
> >>  	mapping->nr_pages = size / PAGE_SIZE;
> >> +	mapping->nc = !!(prot & (KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC));
> >>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
> >>  
> >>  	return ret;
> >> @@ -503,7 +504,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable
> >*pgt, u64 addr, u64 size)
> >>  	lockdep_assert_held(&kvm->mmu_lock);
> >>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> >>  		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
> >> -					mapping->nr_pages);
> >> +					(u64)mapping->nr_pages);
> >>  		if (WARN_ON(ret))
> >>  			break;
> >>  	}
> >> @@ -517,10 +518,11 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable
> >*pgt, u64 addr, u64 size)
> >>  	struct pkvm_mapping *mapping;
> >>  
> >>  	lockdep_assert_held(&kvm->mmu_lock);
> >> -	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> >> -		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> >> -					  PAGE_SIZE * mapping->nr_pages);
> >> -
> >> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> >> +		if (!mapping->nc)
> >> +			__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> >> +						  PAGE_SIZE * mapping->nr_pages);
> >> +	}
> >>  	return 0;
> >>  }
> >>  
> >> @@ -537,7 +539,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct
> >kvm_pgtable *pgt, u64 addr, u64
> >>  	lockdep_assert_held(&kvm->mmu_lock);
> >>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> >>  		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> >> -					   mapping->nr_pages, mkold);
> >> +					   (u64)mapping->nr_pages, mkold);
> >>  
> >>  	return young;
> >>  }
> >> 
> >> -- 
> >> Without deviation from the norm, progress is not possible.
> >
> 
> Thanks!
