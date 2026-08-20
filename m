Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527E22BE65B
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787237904; cv=pass; b=NqLPgDaMcUtvCh35emYSWyXCSZAfAwlemv5N7J7sOnNLZZYLavmfSLVlk+F7phBN2aW2PknNQdOPHXmoTyHLe3oeKAaHk5EiTQec3b2zPVt/Ex8ryMRXOvNXuSkz3afYsu13m2p3BHPz0ZhClsjizF12X+XEqQ0lYMn/49XFlfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787237904; c=relaxed/simple;
	bh=tCuDm+03TvAYZnkVdCG20cBZ4+3US/iSB8Os9agykE4=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NKswYKricgykiMtUx5qhJSv9ngyXq1zUU0x09MPl4TPlxemWuJ9AiW38NXS7p4+AB5aa8wCFXrnpvWR0gLbJxLe+qNTysBEXvajKcQR1v69LLPCbFHxw326qdO62Q1cptgx0oumj9oHoFr5H4JXHsz81bYQ2L0aMusuVaNetUxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OwnivOpO; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OwnivOpO"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8eeb4508f29so16583826d6.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 07:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787237901; cv=none;
        d=google.com; s=arc-20260327;
        b=Zz3c/e8z5gfxYWsagHETpKVoXZ3EtJ6lKG3hl++/oS7mtXvULXAiBHCz/DFDY4sDRo
         7DhvCD8wF7P2rPoTD4NZQmiPR3z1/Tc4+lyvXxaLvZIzkIt46OIn/gAXy6nEChmCYgF9
         MdfdeiOCQTjvKCh/iAmAeUt/9p4jy3WW8JEOb0T79IBpOFhzQh/30CdaB/nGDtyA+7O4
         dKXDXPncbakktG8POHaYI3oWJf3oTfaU9mgNiHfvIc14shoAiPmE8z6lwtvVz/nxT39B
         ayQWkXKks3+n+aLlwe1z+3uq0PO2Y1kbhH/u15o4E6UbtIrAg3uIobRSwtTQRNzhZR2O
         LNrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DUkDVcYI4HfaofmyfTGhbY62rHBJbTNNeZrIZ8FEwOY=;
        fh=CvcAiB3eSLwH1hZ+OTYwiYeAvK4sTpQZI056w1FOgcE=;
        b=J441/3BH96bfd1Ny5wWLPLXYz7qQ/1g4LzpupD5FREB5k4CwdyoLiPR4puGZ5pLvH9
         7vEVsY780dCV5N94FxuF7uEu6M09i5umVfj2K8VGLXHBWC+QOlsUCAv4OUiAGzLsr2Q3
         7chs4yElJxmCL8Q1Grh+vUi5XIDsO5a+LJsqQXVoUWfqpX+6yJCY71h1B2D9N965HQrS
         dxv7Rl8BS9zz0WOPo8eS7WIi8VValXZoABW/nRrMXV5iV1Psb/UFnl0FdaDkfS+XgCwp
         oD0wWM7mydbJOPgnOI+Ntll38tPCoNE40Z2N7RLBLP0ukuDBti9/sJiLac6Dz6Ba5I/h
         E1HQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787237901; x=1787842701; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DUkDVcYI4HfaofmyfTGhbY62rHBJbTNNeZrIZ8FEwOY=;
        b=OwnivOpOQ78/VWuk6kMOtrBumWxFeXOLJ0YyhuD57oqrh6mL+HHMaci8n6kNEeP6PR
         VEIaDmvK6wgRvXvpxPlhYzaJug7SnLRu8+rFXo9IEKDB57VRq2mQCvNFSPoLkA+XR32F
         DEp21/DnNuyeX31DIGamUG3RDJnReGyV1fvIUl2qV+1NEW8YpDxI9VsmIchMc4CWTMOW
         e0Z7IGyUXemi3kX1xH5shHxABycZQlN2uAmg/3DT1ZFwFHJvDeEj/rE1ppOMnXdRTA4z
         Jcwg2ZYYgk27rlA0zD9FZtkghJbK6AVke7K+gGFhqXq2jCP0NBNleRYs9NAp5yjdx2hQ
         uLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787237901; x=1787842701;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DUkDVcYI4HfaofmyfTGhbY62rHBJbTNNeZrIZ8FEwOY=;
        b=q8kAbnm3SrE3reFW3u2WezVin7y23GW3+c7ohlIzLJaGJAlFAdYt7WnQ2y4ixdqE4D
         bZvXGtfhAw1sVeVblkOHuv5u8BTZRLsT6vHBoNBZTy9ujEfQdgZsaClvxeObFZsU4M/u
         ePzukmz1JQKHIsLTQeO8/KwK4h9bakXgJ8496keYp1TwVf1Q4UMysxWsK51rO3kHnRAR
         DGpnNPE07Wuq3rqDBbhNhkOpyuY2MEZtg24LGkABaimDQnq804YifJd2WcpKhbh2qK9B
         wawK0Zw33z798lVdR5Ebc8Gv7ECAX0evyCpMg5vbOCC5YVTx1yAQI517uaOp73mmhXKX
         ROHA==
X-Forwarded-Encrypted: i=1; AHgh+RqPY+SHkKrRWEKaBkU5Ivm5EWQWuEKGI7nf0mHFANAWQZUktNl30w426UXgo96X+C8jBFxj1WY=@lists.linux.dev
X-Gm-Message-State: AFuF++nfKJ1l0ZkiefACWTI0JZMqiyX89doPDwA4Cy/yxV7tY1a8f4C4
	9hOSleknKOnGU9IcUBXGmmzXSLF+SXkqgHsuBT01BAc4gAZVABhpopDb/BXV7bNMhXvdnTzpwH+
	8fQQTmL5WsmT6GxEG0x/fB/IeK+KsTc+wuSnFhFyH
X-Gm-Gg: AR+sD11YTzNMlQmZ4MfdwUmuslXiB1bdomr950cq6gYDovE6vI0b00N7tWMFcT4f4tZ
	ctwXy9UkcbZWQakrGnoRXPKS5ciS7SocQKlo4ZQUMQiLwKlhtS3oXBdnLgjbqjK4ZBr9KFgGDv/
	k5i6c+BtMwQGT7wXAoAp01w54Qp/ROFBok7Tk8lR9TmESXsvA2Rz/i9PeS3D1bzN4uy3V3+C+jS
	bM0TYb+49HWDeP7UXyBpXHW0/A3BZuugOIwZBAEbjll3IPFmMqBxtQyk+9YLmyMmRe5EOWVsso/
	YjpClCc7Y3iS241oBw5UZ8dhKYjlrHjD8u9zYlbjnfb5/Csb/cb+x4LfG/weArtV5trhf/ioBtr
	y+iU=
X-Received: by 2002:a05:6214:2581:b0:90c:5613:6207 with SMTP id
 6a1803df08f44-90c5e98f815mr117797396d6.24.1787237900361; Thu, 20 Aug 2026
 07:58:20 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 07:58:19 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 07:58:19 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com> <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 07:58:19 -0700
X-Gm-Features: AcwNN1XCQ9iGI8G_VElrXcpcztiRZm0WAx2RfffvtaTy6EWJh0KRIqLKvmaMqec
Message-ID: <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com>
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

> On Tue, Aug 18, 2026 at 09:15:53AM +0000, Ackerley Tng wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
>> guest_memfd.
>>
>> Drop the page reference immediately after retrieving the PFN instead of
>> holding it across the entire handler so that the later patch can follow up
>> with completely not returning refcounted pages from kvm_gmem_get_pfn().
>
> Regarding this point:
>
>>
>> On a first look, existing RMP table handling (psmash and checking for
>> errors) might seem like it works fine, since truncation of the page from
>> guest_memfd would have called rmp_make_shared() and removed the PFN from
>> the RMP table. However, that is insufficient since a freed page may already
>> be used in a different SNP VM.
>
> In the code this patch is applied on top of, I think the kvm_gmem_get_pfn()
> ref is enough to avoid the reused-by-another-SNP-VM scenario until after
> caller releases the ref, so I think the above explanation should be adjusted
> to also be preparatory for "the later patch".
>

I think this sequence of events is possible:

CPU 0: sev_handle_rmp_fault()
CPU 0:   kvm_gmem_get_pfn()
CPU 0:     filemap_invalidate_lock()
CPU 0:     refcount++
CPU 0:     filemap_invalidate_unlock()
CPU 0:     refcount-- <<== because kvm_release_page_unused(page);

CPU 1: truncate()
CPU 1:   filemap_invalidate_lock()
CPU 1:   refcount--
CPU 1:     kvm_gmem_free_folio()
CPU 1:       sev_gmem_make_shared()
CPU 1:     folio is freed
CPU 1:   filemap_invalidate_unlock()

CPU 2: in some other SNP VM,
CPU 2: kvm_gmem_get_pfn() gets the freed folio
CPU 2:   sev_gmem_make_private()

CPU 0:   snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
           <<== it's assigned but to some other SNP VM
CPU 0:   snp_rmptable_psmash(pfn);
           <<== this psmash would be smashing in some other SNP VM

And hence I think we do need to check for invalidations using the MMU
invalidation protocol.

> Other than that:
>
> Reviewed-by: Michael Roth <michael.roth@amd.com>
>
>>
>> Hence, adopt the MMU invalidation protocol to guard committing anything
>> based on the PFN.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
>>  1 file changed, 24 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index b2738362a928b..b34b11d7f8fad 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>>  	struct kvm_memory_slot *slot;
>>  	struct kvm *kvm = vcpu->kvm;
>>  	int order, rmp_level, ret;
>> +	unsigned long mmu_seq;
>>  	struct page *page;
>>  	bool assigned;
>>  	kvm_pfn_t pfn;
>> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>>  		return;
>>  	}
>>
>> +	mmu_seq = kvm->mmu_invalidate_seq;
>> +	smp_rmb();
>> +
>>  	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
>>  	if (ret) {
>>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
>>  				    gpa);
>>  		return;
>>  	}
>> +	kvm_release_page_unused(page);
>>
>>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>>  	if (ret || !assigned) {
>>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
>>  				    gpa, pfn, ret);
>> -		goto out_no_trace;
>> +		return;
>>  	}
>>
>>  	/*
>> @@ -5069,27 +5074,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>>  	if (rmp_level == PG_LEVEL_4K)
>>  		goto out;
>>
>> -	ret = snp_rmptable_psmash(pfn);
>> -	if (ret) {
>> -		/*
>> -		 * Look it up again. If it's 4K now then the PSMASH may have
>> -		 * raced with another process and the issue has already resolved
>> -		 * itself. If it's not assigned, then this must have raced with
>> -		 * another process that made this page shared.
>> -		 */
>> -		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
>> -		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>> +	scoped_guard(read_lock, &kvm->mmu_lock) {
>> +		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
>>  			goto out;
>>
>> -		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
>> -				    gpa, pfn, ret);
>> +		ret = snp_rmptable_psmash(pfn);
>> +		if (ret) {
>> +			/*
>> +			 * Look it up again. If it's 4K now then the PSMASH may
>> +			 * have raced with another process and the issue has
>> +			 * already resolved itself. If it's not assigned, then
>> +			 * this must have raced with another process that made
>> +			 * this page shared.
>> +			 */
>> +			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
>> +			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>> +				goto out;
>> +
>> +			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
>> +					    gpa, pfn, ret);
>> +		}
>>  	}
>>
>>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
>>  out:
>>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
>> -out_no_trace:
>> -	kvm_release_page_unused(page);
>>  }
>>
>>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
>>
>> --
>> 2.55.0.699.gb54405d56f-goog
>>
