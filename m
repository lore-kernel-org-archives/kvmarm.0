Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5873A42640C
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 12:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660965; cv=none; b=QDz53dKy2VyU63vFjgP/1fGQrJyYW2DNUCWsa3bnr63cmWaCfvuWYzJxh4HCPIgLCwFAbLk8WjpxfOnrzUbEDQ4E7DOpyXpUZDBruT2/jRO9uC0ZycPzJ0LURVLhYCDF7LpVpDL8I5sxuIOcCczcQzSX05it93RNbN4hKYQEN8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660965; c=relaxed/simple;
	bh=3zSUF/gW/Zcaed81GwU3l76v2U3K0J3de2dxbI0c5CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epYVb+sHfOcJQzdhU9IH9rCicmlufXDkuK0lLHH9E8dsyDRQooWUMpMVUWJJN4RbHUPKq2SFiGI5GzCvmCTsRz2ngjAImy/jJmx2TT2tP7BLIEU9SlwlRJLkPydaTee0wZygc3vr99IFQ1wbq5AqsKOj+YKiSc6xsdgpo553UoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kB+u9BRn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kB+u9BRn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48CFC176A;
	Tue, 25 Aug 2026 05:29:16 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11AED3F7D8;
	Tue, 25 Aug 2026 05:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787660960; bh=3zSUF/gW/Zcaed81GwU3l76v2U3K0J3de2dxbI0c5CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kB+u9BRnN8KsWTpqT13jVQynNtsWyseMe8JNZ6YsmTsxaxvtw+rE53ZDlu+LfvLNn
	 dOfgarmQ0ieJd8oQx8drFWvTVuyKbWAKrYi61e0P/9mauCXK/LnK0dN5zg8rNDiIRA
	 eGNhtBVKJkJVAENWbmpu3fy0O2xJg+UcmFno6tig=
Date: Tue, 25 Aug 2026 13:29:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Thomson, Jack" <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	shuah@kernel.org, corbet@lwn.net, vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
Message-ID: <ao2KmmUd1lVFUUkp@raptor>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
 <20260612162354.73378-3-jackabt.amazon@gmail.com>
 <alEXtW7w-rqlNG09@raptor>
 <0365d77d-616b-47f7-a5f2-3388bad692a1@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0365d77d-616b-47f7-a5f2-3388bad692a1@gmail.com>

Hi Jack,

On Fri, Aug 21, 2026 at 02:52:17PM +0100, Thomson, Jack wrote:
> Hi Alex,
> 
> On 10/07/2026 5:03 pm, Alexandru Elisei wrote:
> > > +	unsigned long		*page_size;
> > 
> > As far as I know, fault handling was reworked to use struct
> > kvm_s2_fault_desc to store the fault information that user_mem_abort()
> > needs to handle the fault.  Adding a 'page_size' field, that represents the
> > result of the gpa mapping process, might not be desirable.
> > 
> 
> Yeah agreed, Vincent suggested a separate output struct that
> kvm_s2_fault_map() fills with what was actually mapped. I'll do that in
> v6 thanks!
> 
> > > +	struct kvm_vcpu_fault_info *fault_info = &vcpu->arch.fault;
> > > +	struct kvm_vcpu_fault_info fault_backup = *fault_info;
> > 
> > I'm not sure you need to make a backup here. vcpu->arch.fault is populated
> > each time the CPU takes a fault.
> > 
> 
> So this was actually flagged up by sashiko when I ran it before
> submission, it suggested handling this for the case in which the vCPU
> exited for MMIO, the next KVM_RUN calls kvm_handle_mmio_return which
> uses the vcu->arch.fault.esr_el2. I'll add some comments to this maybe
> to explain why this would be needed.

Ok, I see, VCPU exits to userspace due to MMIO, userspace calls
KVM_PRE_FAULT_MEMORY, userspace resumes VCPU and uses fault_info from
KVM_PRE_FAULT_MEMORY. Nicely spotted.

> 
> > > +	if (memslot->flags & KVM_MEMSLOT_INVALID) {
> > 
> > I don't think that's something we should care about, the flag can be set
> > immediately after the check as the function doesn't take kvm->slots_lock.
> > kvm_vcpu_prefault_memory() takes the srcu lock in read mode, so the
> > function is safe to run even if userspace does something silly like
> > deleting a memslot at the same time that it's prefaulting the guest memory
> > it represents.
> 
> I was there not as much for safety, but rather to pick up that error.
> This way rather than userspace getting an -EFAULT it can just retry.
> This is the same way it is handled in x86 as well.

My point was that since there's no serialization between memslot changes and
KVM_PRE_FAULT_MEMORY, the condition can become true immediately after the if
statement. Doesn't really matter though anyway.

> 
> > 
> > It might not be obvious, but taking kvm->mmu_lock in read mode does not
> > guarantee that gpa will be mapped when kvm_pgtable_get_leaf() returns.
> > That's because a concurrent kvm_pgtable_stage2_map() for a different gpa
> > can destroy the mapping of the current gpa.
> [ ... ]
> > The kvm->mmu_lock is dropped here, which means that it is possible for a
> > MMU notifier callback to have just unmapped the entire stage 2 for the VM.
> > 
> 
> Yeah as we mentioned in the other thread, this is best effort and we
> can't guarantee that is survives the return. We do this for forward
> progression, reporting the correct advance size for ranges which are
> already mapped, instead of repeating the full dance for every page of them.
> 
> > 
> > handle_access_fault() will fail if the mapping is gone. But I guess that's
> > fine if the ioctl does not guarantee that memory is still mapped after it
> > completes.
> 
> 
> Yeah I think it's fine and will degrade to a no-op in this case.
> 
> > 
> > Also, the documentation that this patch adds says: 'On arm64, newly created
> > stage-2 PTEs are marked Accessed'. Does not say anything about marking
> > **existing** ptes as accessed. Would be useful to explain the code does it.
> > 
> 
> Ack, will do thanks!

I think there's a word missing there, I meant to say that it would be useful to
explain *why* the x86 implementation does not mark new PTEs as accessed, while
arm64 marks them as accessed, and arm64 also does that for existing PTEs.

> 
> > > +		hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
> > 
> > There's gfn_to_hva_memslot(memslot, gfn), is that what you are looking for?
> > 
> 
> I think gfn_to_hva_memslot() resolves the hva for write, so would fail
> on KVM_MEM_READONLY slots, and prefualting is a read. Also this mirrors
> the guest abort path so matches the way the run path resolves the HVA.

Ah, I missed that, thanks for explaining!

I was wondering if you have any plans about posting an updated series.

Thanks,
Alex
