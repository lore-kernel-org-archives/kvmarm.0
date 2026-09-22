Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C391354B1CC;
	Tue, 22 Sep 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790088569; cv=none; b=m9yQio+150qFiTCOdNW10Y44Zfe8aybNnFlhiQxolj73pi/Wi4V7CxtgqSHXNHmLheisLIF+gATHoaLTNuyTjvm2xhvySQ572KysLL1HG/QFjvnft08asrfuT6MgkRtE5b0Vo2sNx4Ojef4+V0NbgsVwLVzdtBFIjmnTCEksB6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790088569; c=relaxed/simple;
	bh=3ADT03e+3kuTvq3FfT1tH4j9tCOVnK8BWBH0nxFQfxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETeml5e0o/cpqC0SGBl0/fhMmvE+ZHtp45I6gkEvr2OBfsSZrgtvmv/pvnWS34GqWAK7Y+aoNm4JZt5BhRnKizCk1j3b9tpey4Agtn7iS1YIGefVjVdxWqv7rw4d4uNFwP6Qmj23JCuR2HGcp3ca5fJ0szRVVDj4hpMZZzvd4PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XwZBF6rW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XwZBF6rW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A69931576;
	Tue, 22 Sep 2026 07:49:23 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95C323F632;
	Tue, 22 Sep 2026 07:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790088567; bh=3ADT03e+3kuTvq3FfT1tH4j9tCOVnK8BWBH0nxFQfxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XwZBF6rWwzr6nDBg1vFdoiS7Bi2BwNNA+cdlH8IlqYlWxR9hZHb9XOn4BDemjc51L
	 G+vRlUhQAygN5p69nlZMm8zPr+jmPxRQALLypxDglVnA7UpaVLAxuLjs/Gfv1kLiDB
	 R5NPr7Gb3xNo9tUx0vL0IHRZlFSpPisAWlx8zHRs=
Date: Tue, 22 Sep 2026 15:49:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <arKVcjCOJf8p9rWL@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <aqrGPK0lFBFXL2qY@arm.com>
 <985520fa-99b0-4620-bfee-8e6321b36104@arm.com>
 <aqvCwM_73qMpqzvV@arm.com>
 <749ab0c9-810d-4989-8fa5-1706124f05bc@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <749ab0c9-810d-4989-8fa5-1706124f05bc@arm.com>

On Tue, Sep 22, 2026 at 02:21:13PM +0100, Suzuki K Poulose wrote:
> I had another look and we could handle this via kvm_fault_is_gmem_abort()
> see in arch/arm64/kvm/mmu.c:
> 
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 87e49251e0447..af5a4bf961aae 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1731,6 +1731,9 @@ static int gmem_abort(const struct kvm_s2_fault_desc
> *s2fd)
>         gfn_t gfn;
>         int ret;
> 
> +       if (!kvm_slot_has_gmem(s2fd->memslot))
> +               return -EINVAL;

I wonder whether we should add a KVM_BUG_ON() here. With the rest of the
changes, we should never get in this situation. Well, to be revisited
for private devices.

Also maybe move it to the caller, kvm_vm_mem_abort(), and not change
kvm_fault_is_gmem_abort(). Something like:

	if (private_ipa_fault(kvm, s2fd->fault_ipa) &&
	    KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
		return -EIO;

To me it makes more sense for gmem_abort() to be called only *if* it's a
gmem slot. So any inconsistency, avoiding user_mem_abort() for private
memory, should be done in the caller. I assume the caller will also have
to route the private device path as well rather than rely on
gmem_abort().

> +
>         if (!perm_fault) {
>                 memcache = get_mmu_memcache(vcpu);
>                 ret = topup_mmu_memcache(vcpu, memcache);
> @@ -2277,10 +2280,12 @@ static bool private_ipa_fault(struct kvm *kvm,
> phys_addr_t fault_ipa);
>  static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>                                     const struct kvm_s2_fault_desc *s2fd)
>  {
> -       if (!kvm_slot_has_gmem(s2fd->memslot))
> -               return false;
>         if (kvm_memslot_is_gmem_only(s2fd->memslot))
>                 return true;
> +       /*
> +        * For Realms, all private faults must be backed by GMEM.
> +        * TODO: Handle Trusted device private memory mappings.
> +        */
>         if (private_ipa_fault(kvm, s2fd->fault_ipa))
>                 return true;
>         return false;
> 
> 
> Also, I have the following hunk for preventing memslot modifications.
> I will add this to v20 integration branch, which is almost ready ;-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 582b48e34486b..87e49251e0447 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2783,6 +2783,18 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>         }
>  }
> 
> +static bool kvm_prevents_memslot_change(struct kvm *kvm, enum kvm_mr_change change)
> +{
> +       /* Cannot modify memslots once a pVM has run or Realm created */
> +       if (change != KVM_MR_DELETE && change != KVM_MR_MOVE)
> +               return false;
> +
> +       if ((kvm_vm_is_protected_pkvm(kvm) && pkvm_hyp_vm_is_created(kvm)) ||
> +            kvm_realm_is_created(kvm))
> +               return true;
> +       return false;
> +}
> +
>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                                    const struct kvm_memory_slot *old,
>                                    struct kvm_memory_slot *new,
> @@ -2791,12 +2803,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>         hva_t hva, reg_end;
>         int ret = 0;
> 
> -       if (kvm_vm_is_protected_pkvm(kvm)) {
> -               /* Cannot modify memslots once a pVM has run. */
> -               if (pkvm_hyp_vm_is_created(kvm) &&
> -                   (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
> +       if (kvm_vm_is_protected(kvm)) {
> +               if (kvm_prevents_memslot_change(kvm, change))
>                         return -EPERM;
> -               }
> 
>                 if (new &&
>                     new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {

I think this should work.

Thanks.

-- 
Catalin
