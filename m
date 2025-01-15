Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9982419F4;
	Wed, 15 Jan 2025 13:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946918; cv=none; b=OLPGChDTQYEuCg6qivZXIGQ9vjVplHUH13jLoQk2AMTJpPM6rspbKtKuC+nQ9lSE5UtrZxnJ2RtOjFOi+HansPW4uQtVdvBDXz/0DklMatt59PjLjSEl/aLur1kJXx2i0M6FVb37WJ71Pc0krBARN+TMoo0sCiTjWfFUVq3OilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946918; c=relaxed/simple;
	bh=u1mUI33kuxL9vq8o1c8EWqH+sAF5rcsL4E091haG1WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHEdbyHYHoo2y6PoV8el5rNVum7Cmg9fGDeEi0HadHh9fJCY4/2HE0MprWzynayj3RmFYF5stLhyEgv9Kjr0JaJfK9o4tdwUkTrEZBEwndf9rXpln9DKcMYKwSyP5EwidM/xeTEE/BYMwIf4TLY6qxrp3O965n4Yd/CvHDf6A/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BF0C4CEDF;
	Wed, 15 Jan 2025 13:15:16 +0000 (UTC)
Date: Wed, 15 Jan 2025 13:15:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
Message-ID: <Z4e04P1bQlFBDHo7@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org>
 <Z4Fk58k8YptDkVgm@arm.com>
 <yq5amsfxtrlw.fsf@kernel.org>
 <Z4Vk5gTnd8o7VKWL@arm.com>
 <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>

On Mon, Jan 13, 2025 at 12:47:54PM -0800, Peter Collingbourne wrote:
> On Mon, Jan 13, 2025 at 11:09 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Sat, Jan 11, 2025 at 06:49:55PM +0530, Aneesh Kumar K.V wrote:
> > > Catalin Marinas <catalin.marinas@arm.com> writes:
> > > > On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > > >> Currently, the kernel won't start a guest if the MTE feature is enabled
> > >
> > > ...
> > >
> > > >> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> > > >>            if (!vma)
> > > >>                    break;
> > > >>
> > > >> -          if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> > > >> +          if (kvm_has_mte(kvm) &&
> > > >> +              !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
> > > >>                    ret = -EINVAL;
> > > >>                    break;
> > > >>            }
> > > >
> > > > I don't think we should change this, or at least not how it's done above
> > > > (Suzuki raised a related issue internally relaxing this for VM_PFNMAP).
> > > >
> > > > For standard memory slots, we want to reject them upfront rather than
> > > > deferring to the fault handler. An example here is file mmap() passed as
> > > > standard RAM to the VM. It's an unnecessary change in behaviour IMHO.
> > > > I'd only relax this for VM_PFNMAP mappings further down in this
> > > > function (and move the VM_PFNMAP check above; see Suzuki's internal
> > > > patch, unless he posted it publicly already).
> > >
> > > But we want to handle memslots backed by pagecache pages for virtio-shm
> > > here (virtiofs dax use case).
> >
> > Ah, I forgot about this use case. So with virtiofs DAX, does a host page
> > cache page (host VMM mmap()) get mapped directly into the guest as a
> > separate memory slot? In this case, the host vma would not have
> > VM_MTE_ALLOWED set.
> >
> > > With MTE_PERM, we can essentially skip the
> > > kvm_vma_mte_allowed(vma) check because we handle all types in the fault
> > > handler.
> >
> > This was pretty much the early behaviour when we added KVM support for
> > MTE, allow !VM_MTE_ALLOWED and trap them later. However, we disallowed
> > VM_SHARED because of some non-trivial race. Commit d89585fbb308 ("KVM:
> > arm64: unify the tests for VMAs in memslots when MTE is enabled")
> > changed this behaviour and the VM_MTE_ALLOWED check happens upfront. A
> > subsequent commit removed the VM_SHARED check.
> >
> > It's a minor ABI change but I'm trying to figure out why we needed this
> > upfront check rather than simply dropping the VM_SHARED check. Adding
> > Peter in case he remembers. I can't see any race if we simply skipped
> > this check altogether, irrespective of FEAT_MTE_PERM.
> 
> I don't see a problem with removing the upfront check. The reason I
> kept the check was IIRC just that there was already a check there and
> its logic needed to be adjusted for my VM_SHARED changes.

Prior to commit d89585fbb308, kvm_arch_prepare_memory_region() only
rejected a memory slot if VM_SHARED was set. This commit unified the
checking with user_mem_abort(), with slots being rejected if
(!VM_MTE_ALLOWED || VM_SHARED). A subsequent commit dropped the
VM_SHARED check, so we ended up with memory slots being rejected only if
!VM_MTE_ALLOWED (of course, if kvm_has_mte()). This wasn't the case
before the VM_SHARED relaxation.

So if you don't remember any strong reason for this change, I think we
should go back to the original behaviour of deferring the VM_MTE_ALLOWED
check to user_mem_abort() (and still permitting VM_SHARED).

-- 
Catalin
