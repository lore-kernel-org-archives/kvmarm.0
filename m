Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9561A262D
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 22:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787265337; cv=pass; b=D39k13s0XJLNhHxHx1Qu4COFaZi1Fi/OOl6cg57QqOBruzOZmjTf7RdljntLxwm+DZnOAEffmAxEX9hX3nvtfy4ewJcqLVMYCjs2HQwBMK3YB5PvwfQAKdpjtm1krvZXahF4CRVNducQGUjHj1uSDN9tvbfJpQmySP32F3rnBHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787265337; c=relaxed/simple;
	bh=88UtQ2NJEocC70tkZ7mM0N57DjBU7D9YDSEXq/qc3yg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=icoU4Q0pOpfJTl0VIIZqbgclnjXcb3X07xNJBypYH3Yf1n4p9EXQ5xP4QTByYSpj6M3POKr4auB5QNZ9MGS622nRToQqqDbLuzui9iz+r4jO2MuG/C7my7cshHUDctO8Po9UXU1+f2dy8TwMcQ/M/jarTMrH1LMfVhRxNj3J/Zs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gZRcDLXd; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gZRcDLXd"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c16ac21acso2568211cf.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 15:35:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787265334; cv=none;
        d=google.com; s=arc-20260327;
        b=HY6adv96vT65L7vaeA/VzLtpgoqscGvTJBS4X+AzBpQeLAHW+3vSzpkmPoTVcv/AMx
         jAMbxloVafM9nbBp+acExQhBNTI7jmshQPu89SN3Xs4gRRtRoYSYhyPjF5E2TQKO5eLi
         /kuca5YMk79xgknDqpG6ngA0rXUz6JpW1F4XkWM38JmVgKVQp5JHh0GneFAvbFTJuDai
         QTgr4aDDsM889HVf3yo1E6Pfy2V0dHVMCYRYsyYt6U8D7jI7BRY790tEGZxA/ojhCArg
         nDL1A0CJYpq2wXFgczuKCLHYqPL4Gaz+BsBkNiFifI6Tqg71N9xSXGjCiBjaBa7jEkv2
         deyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=keAmPabRaMdcX1QNc/BNoLOz/4Bjfzbm/F1rysZ+lHU=;
        fh=Mh0R0mvZz0lVFAxHMNOko8oV1gvBVJ7j9x+rdKFmbMU=;
        b=VsnGp1RrZwAfcpEqTi0Ll7KoyQkC+Tu19pxQt6QgwbuK0qfumDU3yb1z8R/H1rQVYP
         FXkTH9hUoxymRPhwGQhmzn58x3nD/LZuwM7YMoRCCzY0K8e8VL2fxtgCevRPfBXv8v8Q
         i9nG+VG4kOmThiW18G4HcD9kGtVVg3p7kNyHBz/HicgSjL9FX7oszsTDgM5uTgRVbzyg
         RQjP2dAF1jpDCDJ5M5lRLRTvjEnf9H1W4ZyVBDVEvBT7xaHuG3xT/gctZqUSCTfFmi6U
         3n3jCeDOTvD8qWxvMRsb5MMbzobuY/IRkpznM4nPW8Qo7FqiuXOiPhYDQja/6koOvmCd
         5N9A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787265334; x=1787870134; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=keAmPabRaMdcX1QNc/BNoLOz/4Bjfzbm/F1rysZ+lHU=;
        b=gZRcDLXdDs0nOeOOefQTipJh4oA+r8bKsU4VnwDij/yCHywk0nOnclxJ4wZoWOlAh7
         s0itvaV6HT32Pw5cAduITOgtkQpnjr+svD6REZOXVNIokKilW43UXMFL4X5MP8hwdgW7
         zuGEF69b9thw9Dk5Gz8gCesYD1amH46Cx6u43JkBU+PQ1rvlMTRORJpVOJrAInX5xhim
         6NfrJQ6xqhSgT/5hD5fSWYWyBLTqz9+QBCeQDBSylSbBmLG90lDac28Fva07qGWYlQAF
         Nn7FYrrq3AKNPcXp2aEhFWEZgyv2hwXzClorIGI83oWyGvshyijgyf5qxkxdoNQopYsr
         cbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787265334; x=1787870134;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=keAmPabRaMdcX1QNc/BNoLOz/4Bjfzbm/F1rysZ+lHU=;
        b=pJzTb/nVPpQtBYtxvJD4gkoVfUegIfc0KHSIHwnn8ODn0dCf6xJSlk5aLyYrtSApyi
         4GVikvwKJzmTD4IdBIKY5FgXqr1MVcc/P8wYUQBtT5hbrDCdl8ncJL8CLaU/KqC9U91N
         wk/1qngIOKLSb3PjBkB1NrNvOwbtBpAplpnzJ/U3LadWWEoD/3yj7hJmAYmgxmijcoI3
         QNfmzBBc3pzSTy1Q5ndoLcMeTwJruR3qXM1Jq4sUngG7Qv+SgEy4EniazAkrvOZmxPPT
         YFPGk2gC42HfHYPLjX7CyZx/7P4yUdZG6Fscs0X4WXRNqYRGmSUSaeqPyNwVl6lZa7jT
         rZjg==
X-Forwarded-Encrypted: i=1; AHgh+RpT+5cMrfZ5x2zZexGUk/rrbwPVVF+2c+c7h2+ciVlwyFv8Jb/9fv5vftFAtmqTVIvIkWA5izI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMu0h06mvotxYmRFlbbTYffeyyMURjqNmntT+SyfhbW1ViscNn
	v3mhCgYyKI/eqDWY07r4jQ0wvKBSZyXYoAinLPRhM9wXdN+LQAq1rMvmAm9KVjynForMVZcdjFs
	SOfRc0lyLJiRb2dua1kJoK37HkcEnaUAqVWiO3i5s
X-Gm-Gg: AR+sD10My2r7RUS1LhuHDyqetjaRcyKzGGfFwvJsuTkc93qw6zKm84Mljl6eXQi+Cck
	Dl0djY7OdENw82ztGpkuRlh2Szntkchw3FmuZ1Es18cprnn/OApOs2EixE2f/FEtWgaEW+UUXFf
	My18F1hsrFhfNwUTiX1D/zNh7XWj5vZPFguyBnOaMF9YKYZZIxOtFuib37jh0rBEtbRph/NLA+6
	wAsnfGYwM8J0UGQGgoS3FzmP3GWsosUGhHGn6+O/OKVfmNO+3UCYb/UHCIEgSYWmSqr5Pekl+SG
	t8BheLPQTeOd0a5yuCRzFGW/l/PXpMdCEuuqwaWUCJKjP3TJJUUcZgs86FabXOV14eO3mBmK0Dm
	II4k=
X-Received: by 2002:a05:622a:1ccc:b0:51c:44c:6ad with SMTP id
 d75a77b69052e-52df5a07b4cmr19910241cf.21.1787265332903; Thu, 20 Aug 2026
 15:35:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 15:35:31 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 15:35:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <zb5krzhrg3soslplynegqo52brd53wk3meas45udqpjms6oluk@zecqwzn7zziy>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
 <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
 <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com> <zb5krzhrg3soslplynegqo52brd53wk3meas45udqpjms6oluk@zecqwzn7zziy>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 15:35:31 -0700
X-Gm-Features: AcwNN1VgRdjzQciaY8CryBJfmg5HGuqOzIWFzcFZzObegOXkA-aa77jVpFBsdqg
Message-ID: <CAEvNRgEHEE67+vjQqJjYD3M4yuwuR+4-36Hw4-sp5caYzmxbkQ@mail.gmail.com>
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

> On Thu, Aug 20, 2026 at 07:58:19AM -0700, Ackerley Tng wrote:
>> Michael Roth <michael.roth@amd.com> writes:
>>
>> > On Tue, Aug 18, 2026 at 09:15:53AM +0000, Ackerley Tng wrote:
>> >> From: Sean Christopherson <seanjc@google.com>
>> >>
>> >> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
>> >> guest_memfd.
>> >>
>> >> Drop the page reference immediately after retrieving the PFN instead of
>> >> holding it across the entire handler so that the later patch can follow up
>> >> with completely not returning refcounted pages from kvm_gmem_get_pfn().
>> >
>> > Regarding this point:
>> >
>> >>
>> >> On a first look, existing RMP table handling (psmash and checking for
>> >> errors) might seem like it works fine, since truncation of the page from
>> >> guest_memfd would have called rmp_make_shared() and removed the PFN from
>> >> the RMP table. However, that is insufficient since a freed page may already
>> >> be used in a different SNP VM.
>> >
>> > In the code this patch is applied on top of, I think the kvm_gmem_get_pfn()
>> > ref is enough to avoid the reused-by-another-SNP-VM scenario until after
>> > caller releases the ref, so I think the above explanation should be adjusted
>> > to also be preparatory for "the later patch".
>> >
>>
>> I think this sequence of events is possible:
>>
>> CPU 0: sev_handle_rmp_fault()
>> CPU 0:   kvm_gmem_get_pfn()
>> CPU 0:     filemap_invalidate_lock()
>> CPU 0:     refcount++
>> CPU 0:     filemap_invalidate_unlock()
>> CPU 0:     refcount-- <<== because kvm_release_page_unused(page);
>
> Prior to this patch, the kvm_release_page_unused() isn't done until
> after the snp_lookup_rmpentry()/snp_rmptable_psmash().
>
> It's possible CPU 1 truncate sequence below can run concurrently
> after filemap_invalidate_unlock() above, but even though it calls
> free_folio(), which might zap the RMP entry, the filemap code will
> only put the refs that it has on the folio so it wouldn't actually
> get freed back to the buggy allocator, so it doesn't seem like the
> psmash-another-guest scenario is reachable. I could certainly be
> misreading things though.
>

Ah I see what you mean. I think we mean the same thing, let me add to
the commit message that I meant after dropping the refcount early. Does
this help?

  The filemap_invalidate_lock() is already dropped in kvm_gmem_get_pfn()
  before returning to sev_handle_rmp_fault(). After dropping the
  refcount earlier with kvm_release_page_unused(), these scenarios are
  possible:

  1. Since the filemap_invalidate_lock() is dropped, the page can be
     truncated (or in future, converted), and the RMP entry is now
     shared.

     In this case, existing RMP table handling (psmash and checking for
     errors) would be sufficient. On finding a shared entry, psmashing
     would fail gracefully and no warning would be emitted.

  2. The page is truncated and freed, and then re-allocated to another
     SNP VM. The RMP entry is now assigned, but to another SNP VM.

     To address this, adopt the MMU invalidation protocol to guard
     psmashing.

> The psmash-a-now-shared-entry scenario because of a race with the
> VMM/truncate path seems possible prior to this patch, but that's
> pretty similar to the psmash-a-now-shared-entry because of a race
> with the guest scenario and which would generate spurious warning
> messages to console, and that would be similarly addressed via
> patch 1 I think. I'm not sure
>

Yup. I like your psmash-another-guest vs psmash-a-now-shared-entry
classification.

> -Mike
>
>>
>> CPU 1: truncate()
>> CPU 1:   filemap_invalidate_lock()
>> CPU 1:   refcount--
>> CPU 1:     kvm_gmem_free_folio()
>> CPU 1:       sev_gmem_make_shared()
>> CPU 1:     folio is freed
>> CPU 1:   filemap_invalidate_unlock()
>>
>> CPU 2: in some other SNP VM,
>> CPU 2: kvm_gmem_get_pfn() gets the freed folio
>> CPU 2:   sev_gmem_make_private()
>>
>> CPU 0:   snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>>            <<== it's assigned but to some other SNP VM
>> CPU 0:   snp_rmptable_psmash(pfn);
>>            <<== this psmash would be smashing in some other SNP VM
>>
>> And hence I think we do need to check for invalidations using the MMU
>> invalidation protocol.
>>
>> > Other than that:
>> >
>> > Reviewed-by: Michael Roth <michael.roth@amd.com>
>> >
>> >>
>> >> Hence, adopt the MMU invalidation protocol to guard committing anything
>> >> based on the PFN.
>> >>
>> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> >> ---
>> >>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
>> >>  1 file changed, 24 insertions(+), 15 deletions(-)
>> >>
>> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> >> index b2738362a928b..b34b11d7f8fad 100644
>> >> --- a/arch/x86/kvm/svm/sev.c
>> >> +++ b/arch/x86/kvm/svm/sev.c
>> >> @@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> >>  	struct kvm_memory_slot *slot;
>> >>  	struct kvm *kvm = vcpu->kvm;
>> >>  	int order, rmp_level, ret;
>> >> +	unsigned long mmu_seq;
>> >>  	struct page *page;
>> >>  	bool assigned;
>> >>  	kvm_pfn_t pfn;
>> >> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> >>  		return;
>> >>  	}
>> >>
>> >> +	mmu_seq = kvm->mmu_invalidate_seq;
>> >> +	smp_rmb();
>> >> +
>> >>  	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
>> >>  	if (ret) {
>> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
>> >>  				    gpa);
>> >>  		return;
>> >>  	}
>> >> +	kvm_release_page_unused(page);
>> >>
>> >>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>> >>  	if (ret || !assigned) {
>> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
>> >>  				    gpa, pfn, ret);
>> >> -		goto out_no_trace;
>> >> +		return;
>> >>  	}
>> >>
>> >>  	/*
>> >> @@ -5069,27 +5074,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>> >>  	if (rmp_level == PG_LEVEL_4K)
>> >>  		goto out;
>> >>
>> >> -	ret = snp_rmptable_psmash(pfn);
>> >> -	if (ret) {
>> >> -		/*
>> >> -		 * Look it up again. If it's 4K now then the PSMASH may have
>> >> -		 * raced with another process and the issue has already resolved
>> >> -		 * itself. If it's not assigned, then this must have raced with
>> >> -		 * another process that made this page shared.
>> >> -		 */
>> >> -		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
>> >> -		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>> >> +	scoped_guard(read_lock, &kvm->mmu_lock) {
>> >> +		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
>> >>  			goto out;
>> >>
>> >> -		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
>> >> -				    gpa, pfn, ret);
>> >> +		ret = snp_rmptable_psmash(pfn);
>> >> +		if (ret) {
>> >> +			/*
>> >> +			 * Look it up again. If it's 4K now then the PSMASH may
>> >> +			 * have raced with another process and the issue has
>> >> +			 * already resolved itself. If it's not assigned, then
>> >> +			 * this must have raced with another process that made
>> >> +			 * this page shared.
>> >> +			 */
>> >> +			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
>> >> +			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>> >> +				goto out;
>> >> +
>> >> +			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
>> >> +					    gpa, pfn, ret);
>> >> +		}
>> >>  	}
>> >>
>> >>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
>> >>  out:
>> >>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
>> >> -out_no_trace:
>> >> -	kvm_release_page_unused(page);
>> >>  }
>> >>
>> >>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
>> >>
>> >> --
>> >> 2.55.0.699.gb54405d56f-goog
>> >>
