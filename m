Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CBD1C3F02;
	Mon, 13 Jan 2025 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736795371; cv=none; b=WAQQrzrS7bsN/crd+9Ob3xQEDqDfrTuOIFULoxbdIVZiCuIeim9eTkEjZFuh+OniqHMIgE7wNq6s74SGqYoT1hn9LBlt5j727NXT+1ecH9dhqw5G1G8E5VkOZ1SDCxYs5iwC+gX6C09YCH/G0x8A7EjYJYtnnpkT1CPQh7C00OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736795371; c=relaxed/simple;
	bh=40tPngi4zfm8S5S8Z7yrIRFnHtEEQr0YVkQSBaEG2nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCzPFRPW+j0WFEs8oJG1RxYvqMGe7Jg1mEAYp50GXlW5D2LtQrEOjIQH4qvfYg5SnYHEPDkQKXyKp9nQiDv/88i1E/98RYbIC0yf7q/IMVCZDC1Lhu704GnKoDkMo9G7kS+WnpzK5NMv78jpDkrqF30OOeV3fzvYhztBgZoVmOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB76EC4CED6;
	Mon, 13 Jan 2025 19:09:28 +0000 (UTC)
Date: Mon, 13 Jan 2025 19:09:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
Message-ID: <Z4Vk5gTnd8o7VKWL@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org>
 <Z4Fk58k8YptDkVgm@arm.com>
 <yq5amsfxtrlw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5amsfxtrlw.fsf@kernel.org>

On Sat, Jan 11, 2025 at 06:49:55PM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> Currently, the kernel won't start a guest if the MTE feature is enabled
> 
> ...
> 
> >> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >>  		if (!vma)
> >>  			break;
> >>  
> >> -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> >> +		if (kvm_has_mte(kvm) &&
> >> +		    !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
> >>  			ret = -EINVAL;
> >>  			break;
> >>  		}
> >
> > I don't think we should change this, or at least not how it's done above
> > (Suzuki raised a related issue internally relaxing this for VM_PFNMAP).
> >
> > For standard memory slots, we want to reject them upfront rather than
> > deferring to the fault handler. An example here is file mmap() passed as
> > standard RAM to the VM. It's an unnecessary change in behaviour IMHO.
> > I'd only relax this for VM_PFNMAP mappings further down in this
> > function (and move the VM_PFNMAP check above; see Suzuki's internal
> > patch, unless he posted it publicly already).
> 
> But we want to handle memslots backed by pagecache pages for virtio-shm
> here (virtiofs dax use case).

Ah, I forgot about this use case. So with virtiofs DAX, does a host page
cache page (host VMM mmap()) get mapped directly into the guest as a
separate memory slot? In this case, the host vma would not have
VM_MTE_ALLOWED set.

> With MTE_PERM, we can essentially skip the
> kvm_vma_mte_allowed(vma) check because we handle all types in the fault
> handler.

This was pretty much the early behaviour when we added KVM support for
MTE, allow !VM_MTE_ALLOWED and trap them later. However, we disallowed
VM_SHARED because of some non-trivial race. Commit d89585fbb308 ("KVM:
arm64: unify the tests for VMAs in memslots when MTE is enabled")
changed this behaviour and the VM_MTE_ALLOWED check happens upfront. A
subsequent commit removed the VM_SHARED check.

It's a minor ABI change but I'm trying to figure out why we needed this
upfront check rather than simply dropping the VM_SHARED check. Adding
Peter in case he remembers. I can't see any race if we simply skipped
this check altogether, irrespective of FEAT_MTE_PERM.

-- 
Catalin
