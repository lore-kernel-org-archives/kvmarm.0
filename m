Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA39379C24
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268857; cv=pass; b=rJCl0gIQbJaDpMgwJuLGN+f492T4j+AOmIjLmL78YYga2koeAC5cFv/A1O8jhLVx8X+Iplv/DJXviCvgAs3lGdddEzUEuyunZoTmIlXc+VB8XHOW3ArRqF4o5IHN6JdtRWDLzpF6JGfkxEYlWRgLdj5T2nZyoleex9yRBDcPL0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268857; c=relaxed/simple;
	bh=j2vJ3RtatjAElJDd5YoRQerg6SFrDWzJGAfiVSg6HHk=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRCbTQVjaV1Fg8jkPOi5OEDjOyDBq1POsEBZZp9GNj/B340GBVeLfk5aKQM41UNyb4NQAWOd53dWrYYB4EHv03AeqDdWKDsjyF7uuqHrG/MTBhhGNUfCZETVkm4hlA4KF1FGvXFNwstW0/nwKZCImXP0g4lq6ADRgn1GbiFWBDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=etxaKXUm; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="etxaKXUm"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ff20870ac7so4149346d6.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787268855; cv=none;
        d=google.com; s=arc-20260327;
        b=Nb56qcqy6Kdht1x6U2+hf2kcuD+2qUj7gCILeHhchXiJ+EdJuaG3DDkH1bK6+snIOH
         ACebcD9AJfiGM7GUhhnOuNaLsDRewqgt8bXscW7nOGi87s5YNqrD6wUVz8wfMxHgkD15
         XNgWP8CxgB/a8B25juZpKIcH0adQQ9nRurVepwgxQx1G1SWQpHAJD4wdPpC3QozqhaIA
         CSqrOBqIJCbarfy++hCXip2eW5zXVjwNLhumXxJncu6vgvqXfl3VHgKYdi3aLYQl3iE0
         AwbX/M9b4wEqD4HHpAEK9atN7tP288aSSwVKe6sOThHiQme9iqh24hPnIHP66ESB0aUf
         Zsfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dqgdGAes/vZjiy7MuCsDmVoVgUg9hSFwRvHXcvcjdsw=;
        fh=7bP1VodmidTz9KQ5N/zo3Nr503TARwcAswopbrVApnE=;
        b=lJZuyqJ7lsn/C/uCS2hiOk+JFAbtSc+XrpsjNUavoRm0E3rW/g5KDC4NDt9zokfaeZ
         IRaP1wZlIotbIwn2CnQlDLOURAolfNzGDlxKZ9R0yz5LrNKa+uYSVnJnwjvF1aTV7aTc
         H8cR92pl3X1VclowAEHhrcCtnmTmICO6b2RVKsPFAqrNp446yeq0qdYN9qvEsH8aFIcA
         x5K4aBK9onM+pJ9I4VmjF09FHeff9agNTy9sthEiGvKH0rkdNsQihjtT8e8uzALEmA/e
         S5HHeI/iisNK/7HHSPyCIh9ehjKgzJOs/M3BwR6vHAV/mlfvbsSJq2Zp8IUPUXSIAbEc
         EdTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787268855; x=1787873655; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dqgdGAes/vZjiy7MuCsDmVoVgUg9hSFwRvHXcvcjdsw=;
        b=etxaKXUmtf1fgMLrrgIzoK1tWn7Y9HwUtmSryEbFmJtCRNpTeNP+QCDWCjig4xoqs/
         p94tUpso+bpJ9JbczFz+g1v2PP/FmeZhDfr8oe+F1WzEp7YDiAEECV2GCpmKDrEyb+FG
         IwvOyocWsTlRL7xL2PTBkqB2milpdvPeH9kJ9x/SniMijLYoumz/3G/cZkepRxFeSV2X
         uCwDtMXzdFT/fEH4j5dMKyuMMvtWl6+S5j1cZBpAH661UenyujH+psZVaW8hbXRTON6L
         vgfUsr0oftU0Wl+h0EMSazHC3yyTErzExXcCzTT8TDxneRvS3P4QiyUvVtr4EvaHx+cL
         owvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268855; x=1787873655;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dqgdGAes/vZjiy7MuCsDmVoVgUg9hSFwRvHXcvcjdsw=;
        b=RkfasZV2ibb9Z4jfeXifcEVSDfQI06KE3GaDNMMWOoXZc+3/OmephKBDGMurgM4Z/p
         x6YgBjhDI21UfgmJtYBemZ8rV04rZOD4R8ktUdQj7kbNHntoc5IhUtF7x+XRC+SfwMe0
         bVSVvHr7VAiWcitpkmHd8vfshhfnkqlYGS5JJ5J3Tq0Qp7o7lz+ZaLCH3UWR562qaWWh
         uUUe3+Waub4b0F4qBenZoehrlIIzl/fO+9ivEPTWL9f54EWNUXfi09biqNIoECuqy/kJ
         KQiSyNfGo3qw/FkItP4bYppDaH2zLFbAveoZzBJM04ooglNl4EMY+SRIZ7RS73yKJG+1
         ag1A==
X-Forwarded-Encrypted: i=1; AHgh+Ro1dlD2/OEnIji/vay9J1+rsA8gJEe78tHMVElazpL+jA6ZCZg3PprOJIz2okkhWvXhwB86rXs=@lists.linux.dev
X-Gm-Message-State: AFuF++kojJ0pGiWVxX44sLwsgQqrqxp53bn86Pz7w+nQ/nilAxYXdhJj
	4/nsDGiBZwA5VjemQp0R7xOyYYXYAm+mbTZfPFRBk3XBWboMqrqgorKc/CFYM6gtKV7OHQ7590f
	+dJrKgmdnfHpiiBHdPMNMuFGL/naP8HBVRKo8/EZb
X-Gm-Gg: AR+sD12WsySvZY3GFKXYJVVKrtff/uduzddKdapjZ9SMRWYqjuX3qhVxrBwazeCqbpI
	Zr9VD5ke6SDSfJcuS0edCZq2X9bLkr2FGudKe/zbh3E7AtsGbjui0fvJCyHg5UrwrWWSNiTiYFq
	jYFhP9pchvZvdSCYBe25LHpwCMlPegjIbKkMjh2z3TzXS//Is1fTCK/VuUerjq4kPjI6GYNDrwL
	WzfnJpTlxjD7kBe2pvgbKLMNQUZ3ZYoNXQESG1meLTe6e0RFgpln65aah1ETI/1hJOYRZGgszOf
	kLSHS3q6Jq2TC19jONdoZIAeK2/ZaV5uBtlvwBrsknNJ2siefnuk/VupExde7Q1T4GxAti3YbEx
	RWJs=
X-Received: by 2002:a05:6214:124a:b0:908:23fd:813f with SMTP id
 6a1803df08f44-90c80c5c0d2mr19422596d6.15.1787268853735; Thu, 20 Aug 2026
 16:34:13 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 16:34:12 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 16:34:12 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <7kapvdum7qk7l4epbeqvrybqxapuhvwltz7axfprxldw2utozh@t4url3mqbpom>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
 <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
 <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com>
 <zb5krzhrg3soslplynegqo52brd53wk3meas45udqpjms6oluk@zecqwzn7zziy>
 <CAEvNRgEHEE67+vjQqJjYD3M4yuwuR+4-36Hw4-sp5caYzmxbkQ@mail.gmail.com> <7kapvdum7qk7l4epbeqvrybqxapuhvwltz7axfprxldw2utozh@t4url3mqbpom>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 16:34:12 -0700
X-Gm-Features: AcwNN1UxC1y3hgXaqd_BMNMsuIls7jzT9HkqjaxXUN2vJgZZQJ3KLiKDnMBj6Ms
Message-ID: <CAEvNRgHCJ9KFW1LFG3HBWBM-5DP+qUZb653802NY3x1fAYwNaQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: SEV: Drop page refcount early during RMP
 fault handling
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Michael Roth <michael.roth@amd.com> writes:

> On Thu, Aug 20, 2026 at 03:35:31PM -0700, Ackerley Tng wrote:
>> Michael Roth <michael.roth@amd.com> writes:
>>
>> > On Thu, Aug 20, 2026 at 07:58:19AM -0700, Ackerley Tng wrote:
>> >> Michael Roth <michael.roth@amd.com> writes:
>> >>
>> >> > On Tue, Aug 18, 2026 at 09:15:53AM +0000, Ackerley Tng wrote:
>> >> >> From: Sean Christopherson <seanjc@google.com>
>> >> >>
>> >> >> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
>> >> >> guest_memfd.
>> >> >>
>> >> >> Drop the page reference immediately after retrieving the PFN instead of
>> >> >> holding it across the entire handler so that the later patch can follow up
>> >> >> with completely not returning refcounted pages from kvm_gmem_get_pfn().
>> >> >
>> >> > Regarding this point:
>> >> >
>> >> >>
>> >> >> On a first look, existing RMP table handling (psmash and checking for
>> >> >> errors) might seem like it works fine, since truncation of the page from
>> >> >> guest_memfd would have called rmp_make_shared() and removed the PFN from
>> >> >> the RMP table. However, that is insufficient since a freed page may already
>> >> >> be used in a different SNP VM.
>> >> >
>> >> > In the code this patch is applied on top of, I think the kvm_gmem_get_pfn()
>> >> > ref is enough to avoid the reused-by-another-SNP-VM scenario until after
>> >> > caller releases the ref, so I think the above explanation should be adjusted
>> >> > to also be preparatory for "the later patch".
>> >> >
>> >>
>> >> I think this sequence of events is possible:
>> >>
>> >> CPU 0: sev_handle_rmp_fault()
>> >> CPU 0:   kvm_gmem_get_pfn()
>> >> CPU 0:     filemap_invalidate_lock()
>> >> CPU 0:     refcount++
>> >> CPU 0:     filemap_invalidate_unlock()
>> >> CPU 0:     refcount-- <<== because kvm_release_page_unused(page);
>> >
>> > Prior to this patch, the kvm_release_page_unused() isn't done until
>> > after the snp_lookup_rmpentry()/snp_rmptable_psmash().
>> >
>> > It's possible CPU 1 truncate sequence below can run concurrently
>> > after filemap_invalidate_unlock() above, but even though it calls
>> > free_folio(), which might zap the RMP entry, the filemap code will
>> > only put the refs that it has on the folio so it wouldn't actually
>> > get freed back to the buggy allocator, so it doesn't seem like the
>> > psmash-another-guest scenario is reachable. I could certainly be
>> > misreading things though.
>> >
>>
>> Ah I see what you mean. I think we mean the same thing, let me add to
>> the commit message that I meant after dropping the refcount early. Does
>> this help?
>>
>>   The filemap_invalidate_lock() is already dropped in kvm_gmem_get_pfn()
>>   before returning to sev_handle_rmp_fault(). After dropping the
>>   refcount earlier with kvm_release_page_unused(), these scenarios are
>>   possible:
>>
>>   1. Since the filemap_invalidate_lock() is dropped, the page can be
>>      truncated (or in future, converted), and the RMP entry is now
>>      shared.
>>
>>      In this case, existing RMP table handling (psmash and checking for
>>      errors) would be sufficient. On finding a shared entry, psmashing
>>      would fail gracefully and no warning would be emitted.
>>
>>   2. The page is truncated and freed, and then re-allocated to another
>>      SNP VM. The RMP entry is now assigned, but to another SNP VM.
>>
>>      To address this, adopt the MMU invalidation protocol to guard
>>      psmashing.
>
> This reads kinda weird to me, as if with #2 we're documenting a "bug" that
> this patch fixes, but the bug would only exist if we partially applied the
> bits of this patch the drops the ref counts earlier and left out the
> bits of the patch that introduce the mmu notifier logic that replaces it.
>

Thanks, I adjusted the commit message to focus on drop refcount + adopt
KVM MMU invalidation protocol in v3, please see v3! Thanks!

> I think with patch 1 applied (which covers the
> psmash-a-now-shared-entry case while retaining the original refcount
> logic), the only thing this patch is doing is replacing the elevated
> refcount logic with the MMU invalidation logic as prep for dropping
> reliance of refcounts entirely.
>
> I think if the wording was simplified to just say something to that effect
> it would make it clearer that this and patch #3 are prep for #4, and that
> patch #1 is the only patch here that would make potentially make sense for
> a downstream to backport without the other bits.
>
> -Mike
>
>>
>> > The psmash-a-now-shared-entry scenario because of a race with the
>> > VMM/truncate path seems possible prior to this patch, but that's
>> > pretty similar to the psmash-a-now-shared-entry because of a race
>> > with the guest scenario and which would generate spurious warning
>> > messages to console, and that would be similarly addressed via
>> > patch 1 I think. I'm not sure
>> >
>>
>> Yup. I like your psmash-another-guest vs psmash-a-now-shared-entry
>> classification.
>>
>> > -Mike
>> >
>> >>
>> >> CPU 1: truncate()
>> >> CPU 1:   filemap_invalidate_lock()
>> >> CPU 1:   refcount--
>> >> CPU 1:     kvm_gmem_free_folio()
>> >> CPU 1:       sev_gmem_make_shared()
>> >> CPU 1:     folio is freed
>> >> CPU 1:   filemap_invalidate_unlock()
>> >>
>> >> CPU 2: in some other SNP VM,
>> >> CPU 2: kvm_gmem_get_pfn() gets the freed folio
>> >> CPU 2:   sev_gmem_make_private()
>> >>
>> >> CPU 0:   snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>> >>            <<== it's assigned but to some other SNP VM
>> >> CPU 0:   snp_rmptable_psmash(pfn);
>> >>            <<== this psmash would be smashing in some other SNP VM
>> >>
>> >> And hence I think we do need to check for invalidations using the MMU
>> >> invalidation protocol.
>> >>
>> >> > Other than that:
>> >> >
>> >> > Reviewed-by: Michael Roth <michael.roth@amd.com>
>> >> >
>> >> >>
>> >> >> Hence, adopt the MMU invalidation protocol to guard committing anything
>> >> >> based on the PFN.
>> >> >>
>> >> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> >> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> >> >> ---
>> >> >>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
>> >> >>  1 file changed, 24 insertions(+), 15 deletions(-)
>> >> >>
>> >> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> >> >> index b2738362a928b..b34b11d7f8fad 100644
>> >> >> --- a/arch/x86/kvm/svm/sev.c
>> >> >> +++ b/arch/x86/kvm/svm/sev.c
>> >> >> @@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> >> >>  	struct kvm_memory_slot *slot;
>> >> >>  	struct kvm *kvm = vcpu->kvm;
>> >> >>  	int order, rmp_level, ret;
>> >> >> +	unsigned long mmu_seq;
>> >> >>  	struct page *page;
>> >> >>  	bool assigned;
>> >> >>  	kvm_pfn_t pfn;
>> >> >> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> >> >>  		return;
>> >> >>  	}
>> >> >>
>> >> >> +	mmu_seq = kvm->mmu_invalidate_seq;
>> >> >> +	smp_rmb();
>> >> >> +
>> >> >>  	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
>> >> >>  	if (ret) {
>> >> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
>> >> >>  				    gpa);
>> >> >>  		return;
>> >> >>  	}
>> >> >> +	kvm_release_page_unused(page);
>> >> >>
>> >> >>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>> >> >>  	if (ret || !assigned) {
>> >> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
>> >> >>  				    gpa, pfn, ret);
>> >> >> -		goto out_no_trace;
>> >> >> +		return;
>> >> >>  	}
>> >> >>
>> >> >>  	/*
>> >> >> @@ -5069,27 +5074,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> >> >>  	if (rmp_level == PG_LEVEL_4K)
>> >> >>  		goto out;
>> >> >>
>> >> >> -	ret = snp_rmptable_psmash(pfn);
>> >> >> -	if (ret) {
>> >> >> -		/*
>> >> >> -		 * Look it up again. If it's 4K now then the PSMASH may have
>> >> >> -		 * raced with another process and the issue has already resolved
>> >> >> -		 * itself. If it's not assigned, then this must have raced with
>> >> >> -		 * another process that made this page shared.
>> >> >> -		 */
>> >> >> -		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
>> >> >> -		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>> >> >> +	scoped_guard(read_lock, &kvm->mmu_lock) {
>> >> >> +		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
>> >> >>  			goto out;
>> >> >>
>> >> >> -		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
>> >> >> -				    gpa, pfn, ret);
>> >> >> +		ret = snp_rmptable_psmash(pfn);
>> >> >> +		if (ret) {
>> >> >> +			/*
>> >> >> +			 * Look it up again. If it's 4K now then the PSMASH may
>> >> >> +			 * have raced with another process and the issue has
>> >> >> +			 * already resolved itself. If it's not assigned, then
>> >> >> +			 * this must have raced with another process that made
>> >> >> +			 * this page shared.
>> >> >> +			 */
>> >> >> +			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
>> >> >> +			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>> >> >> +				goto out;
>> >> >> +
>> >> >> +			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
>> >> >> +					    gpa, pfn, ret);
>> >> >> +		}
>> >> >>  	}
>> >> >>
>> >> >>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
>> >> >>  out:
>> >> >>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
>> >> >> -out_no_trace:
>> >> >> -	kvm_release_page_unused(page);
>> >> >>  }
>> >> >>
>> >> >>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
>> >> >>
>> >> >> --
>> >> >> 2.55.0.699.gb54405d56f-goog
>> >> >>
