Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786DE15C0;
	Wed, 26 Feb 2025 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740592960; cv=none; b=NdF0XSmzxcIlY/D4hvBbFJlNMuSe0JDSevf2H0gRqXCtGmeaMdCG7E1/xEzteVQK8FkpkVE1VZ3uBJ04XAcuJGQZaSvbYGQ5auBs3iJRtgn+GP00RmDn0+PZVpakdkgjH6NmmiKFB/XAk7eaMqpd60DayS7M0ZjgR6sHdv5Uevk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740592960; c=relaxed/simple;
	bh=+RJYxKc0WbneuRstiscX8xX/ABP7qF0Tpk0DF+AQtQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqcbqv8aVCZ2LOpEEutofemyFaIfMAc2he6KoSMMoMOf6cUogs6/VNDhJNUZESM0Yc+r2dvm8E2G2M3RbM0NPvwi7mXW6pl55I0PFdEjdxAL6s3J2Fu7vZxEDAJjQetfekyQmNwHKLeudusDGM5/xsUhGmLPY4E/KhMFY8R9wdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D889FC4CEE7;
	Wed, 26 Feb 2025 18:02:37 +0000 (UTC)
Date: Wed, 26 Feb 2025 18:02:35 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop mte_allowed check during memslot
 creation
Message-ID: <Z79XOyjWOSvVGIfM@arm.com>
References: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
 <Z7xSfVME4z2ComUm@arm.com>
 <86ldtvr0nl.wl-maz@kernel.org>
 <Z7yElHKrJGn8XuPS@arm.com>
 <86jz9fqtbk.wl-maz@kernel.org>
 <yq5aseo3gund.fsf@kernel.org>
 <86ikozqmsl.wl-maz@kernel.org>
 <yq5a8qptauyl.fsf@kernel.org>
 <Z786ODqxlYNpj40l@arm.com>
 <yq5a1pvkbqju.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5a1pvkbqju.fsf@kernel.org>

On Wed, Feb 26, 2025 at 10:18:21PM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Wed, Feb 26, 2025 at 03:28:26PM +0530, Aneesh Kumar K.V wrote:
> >> Marc Zyngier <maz@kernel.org> writes:
> >> > On Mon, 24 Feb 2025 16:44:06 +0000,
> >> > Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
> >> >> >> On Mon, Feb 24, 2025 at 12:24:14PM +0000, Marc Zyngier wrote:
> >> >> >> > > On Mon, Feb 24, 2025 at 03:09:38PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> >> >> > > > This change is needed because, without it, users are not able to use MTE
> >> >> >> > > > with VFIO passthrough (currently the mapping is either Device or
> >> >> >> > > > NonCacheable for which tag access check is not applied.), as shown
> >> >> >> > > > below (kvmtool VMM).
> > [...]
> >> >> >> > My other concern is that this gives pretty poor consistency to the
> >> >> >> > guest, which cannot know what can be tagged and what cannot, and
> >> >> >> > breaks a guarantee that the guest should be able to rely on.
> > [...]
> >> >> What if we trigger a memory fault exit with the TAGACCESS flag, allowing
> >> >> the VMM to use the GPA to retrieve additional details and print extra
> >> >> information to aid in analysis? BTW, we will do this on the first fault
> >> >> in cacheable, non-tagged memory even if there is no tagaccess in that
> >> >> region. This can be further improved using the NoTagAccess series I
> >> >> posted earlier, which ensures the memory fault exit occurs only on
> >> >> actual tag access
> >> >> 
> >> >> Something like below?
> >> >
> >> > Something like that, only with:
> >> >
> >> > - a capability informing userspace of this behaviour
> >> >
> >> > - a per-VM (or per-VMA) flag as a buy-in for that behaviour
> >> 
> >> If we’re looking for a capability based control, could we tie that up to
> >> FEAT_MTE_PERM? That’s what I did here:
> >> 
> >> https://lore.kernel.org/all/20250110110023.2963795-1-aneesh.kumar@kernel.org
> >> 
> >> That patch set also addresses the issue mentioned here. Let me know if
> >> you think this is a better approach
> >
> > From the patch linked above:
> >
> > | @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> > |  		if (!vma)
> > |  			break;
> > | 
> > | -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> > | +		if (kvm_has_mte(kvm) &&
> > | +		    !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
> > |  			ret = -EINVAL;
> > |  			break;
> > |  		}
> >
> > we also have the same ABI change every time FEAT_MTE_PERM is present.
> > TBH, I'd rather have it from the start as per the patch in this thread,
> > irrespective of FEAT_MTE_PERM. I'm fine, however, with better exit to
> > VMM information though.
> 
> The patch also does:
> 
> #define kvm_has_mte_perm(kvm)					\
> 	(system_supports_notagaccess() &&				\
> 	 test_bit(KVM_ARCH_FLAG_MTE_PERM_ENABLED, &(kvm)->arch.flags))
> 
> That is it depends on userspace to drive the behavior and also relies on the
> FEAT_MTE_PERM hardware feature.

Ah, ok, so the VMM needs to explicitly opt in to FEAT_MTE_PERM and the
slight ABI change.

> I was considering whether, if we're
> introducing this capability, should we also include FEAT_MTE_PERM? since
> adding FEAT_MTE_PERM would also require a capability to handle VM
> migration

Fine by me to tie this to FEAT_MTE_PERM. However, ignoring VM migration,
we really only need FEAT_MTE_PERM if we have a cacheable device memory
assigned into the guest.

-- 
Catalin
