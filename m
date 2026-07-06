Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C858F3A7584
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335430; cv=none; b=m4PdIrbRUpQ4N0LG6J1Mq5pjXPt7OsS9tJkzhVM9hR9ALNf2pokRRavA/z6AYoeEX8j0LmI31zX3r5AtLzdZ6fCLVpqDHh7iYNEGWhvmTP6Wft3BVOUz4fLqAIgm5kZJfo3nOGDKEtJWfYui4ECddhFAcrafN2lOddTWa4XhxcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335430; c=relaxed/simple;
	bh=Cmk/FfTcQJw2/eDIqbR3U6irRZEwpjmV67DcVX51wQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwgfGhJ+rssg9ux13ypX4mDjBqG83YyRRb4TOQk8OjrL1GI2BYySmPV+BSXUSH/5SKpo99EHkGXpUQUbeV7NseDlZYbP0RBxP3oU1zABwEWlA5mMucnwIynH8Fg546J/Oprcm1+1iHlQQSYi7MLG65kO/tGH2XV01VPwlXoYBn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NiQTKGKQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NiQTKGKQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D559732AF;
	Mon,  6 Jul 2026 03:57:00 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDDE73F85F;
	Mon,  6 Jul 2026 03:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783335425; bh=Cmk/FfTcQJw2/eDIqbR3U6irRZEwpjmV67DcVX51wQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NiQTKGKQnEWjyAfP1WkLOJJ/6V9/Sz/YNAArkz22EyjF47y27b4NjRCQqX+HeS0Ov
	 XQHKoPp+dVDz8oCynJ2l655i1k5oBxL9Ac0Hcgdvg1dmvfktWu8s2iDP1naRvq0MrG
	 bT+fqCTQKOn/C1LLZlxI8dxKHIZzuysfI7Pimkvc=
Date: Mon, 6 Jul 2026 11:57:01 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all
 memory registration
Message-ID: <akuJ_eFvDHLpiU-Y@raptor>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-4-fuad.tabba@linux.dev>
 <556ab72c-f440-434b-a24d-84200bd25842@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556ab72c-f440-434b-a24d-84200bd25842@arm.com>

Hi Fuad, Suzuki,

On Mon, Jul 06, 2026 at 11:23:47AM +0100, Suzuki K Poulose wrote:
> Hi Fuad
> 
> On 06/07/2026 09:35, Fuad Tabba wrote:
> > Switch kvm__register_mem() and kvm__destroy_mem() from
> > kvm_userspace_memory_region to kvm_userspace_memory_region2 and
> > KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
> > superset; when the extra fields are zero, the ioctl behaves
> > identically to v1.
> 
> Doesn't this break using this on older KVM implementations ? Not that I
> care, but do others care ?

I haven't had the time to review the series, but I do care about this
change, I find myself from time to time testing old kernels.

I think the two ioctls can coexist without much maintenance burden. For
example, the usage of KVM_SET_USER_MEMORY_REGION can be kept as-is and
KVM_SET_USER_MEMORY_REGION2 can be used only for guest_memfd in
kvm__register_mem().

Thoughts?

Thanks,
Alex

> 
> Cheers
> Suzuki
> 
> 	
> > 
> > This prepares for adding guest_memfd support.
> > 
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >   kvm.c | 11 +++++------
> >   1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kvm.c b/kvm.c
> > index 95ccfcb..8a7fd09 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -189,7 +189,7 @@ core_exit(kvm__exit);
> >   int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >   		     void *userspace_addr)
> >   {
> > -	struct kvm_userspace_memory_region mem;
> > +	struct kvm_userspace_memory_region2 mem;
> >   	struct kvm_mem_bank *bank;
> >   	int ret;
> > @@ -213,14 +213,14 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >   		goto out;
> >   	}
> > -	mem = (struct kvm_userspace_memory_region) {
> > +	mem = (struct kvm_userspace_memory_region2) {
> >   		.slot			= bank->slot,
> >   		.guest_phys_addr	= guest_phys,
> >   		.memory_size		= 0,
> >   		.userspace_addr		= (unsigned long)userspace_addr,
> >   	};
> > -	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> > +	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
> >   	if (ret < 0) {
> >   		ret = -errno;
> >   		goto out;
> > @@ -239,7 +239,6 @@ out:
> >   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >   		      void *userspace_addr, enum kvm_mem_type type)
> >   {
> > -	struct kvm_userspace_memory_region mem;
> >   	struct kvm_mem_bank *merged = NULL;
> >   	struct kvm_mem_bank *bank;
> >   	struct list_head *prev_entry;
> > @@ -320,7 +319,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >   		flags |= KVM_MEM_READONLY;
> >   	if (type != KVM_MEM_TYPE_RESERVED) {
> > -		mem = (struct kvm_userspace_memory_region) {
> > +		struct kvm_userspace_memory_region2 mem = {
> >   			.slot			= slot,
> >   			.flags			= flags,
> >   			.guest_phys_addr	= guest_phys,
> > @@ -328,7 +327,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >   			.userspace_addr		= (unsigned long)userspace_addr,
> >   		};
> > -		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> > +		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
> >   		if (ret < 0) {
> >   			ret = -errno;
> >   			goto out;
> 
