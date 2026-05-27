Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA993F20ED;
	Wed, 27 May 2026 10:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879135; cv=none; b=pBaE6jnAnMmaNK2J4DR61LEMJ9oNQym7WaJH/h7DBzZe0ewoEQdKasPIijR+PAoEeeAPojwOqU54MsUo1mm2AhwvVIh4EgdeInWHb3P+R+s2Nr1qKEyRDkbIq2jY9pIYklJTe2E/H441DoKb1HuUPocUc+GnkwOTvn/JRNqjgL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879135; c=relaxed/simple;
	bh=bZ3q7NUxPu/Uy9EvozZtelgm2WWc+8VfFSdGGhRHG8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7JFxEMPegqk4okBSvV/SsS0KKJjAckQyrFP9UlsbYPfZZzZ+0GvV2S/QpHspMAi8XM19oqdvfdefp6Y+KyApA8pNMZxkfm7NnadENxTg8tSPhuBKvDXTYN4U2gDH0vjQjRQIwUJsFPbzSUfbp28Glw+znT7bGDsPaq+OmWjpRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YhTLnJvm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YhTLnJvm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AC482880;
	Wed, 27 May 2026 03:52:08 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2048A3F7D8;
	Wed, 27 May 2026 03:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779879133; bh=bZ3q7NUxPu/Uy9EvozZtelgm2WWc+8VfFSdGGhRHG8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YhTLnJvmmF65boUW+vmDho7GBx7AJLdCghw5GsyJl5KirHzsbS5ATMbP+WfAvvEuj
	 b50xqYAeLis1xbDrNkn922M2Bgb4QPCrF2DhBY578LYskLJGNKO/3Sr0xUWdRWtWJb
	 vVnOCfUDpygkhnVvzHXwnazTXPjHCweaHXIU38jU=
Date: Wed, 27 May 2026 11:52:02 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 23/44] arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
Message-ID: <aly6g5gd27ceezehporuika5rvqu6kqnm5c5cbs36gh2gdrjws@y7gpy2lhtaaz>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-24-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513131757.116630-24-steven.price@arm.com>

Hi,

On Wed, May 13, 2026 at 02:17:31PM +0100, Steven Price wrote:
> The guest can request that a region of it's protected address space is
> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> RSI_IPA_STATE_SET. This causes a guest exit with the
> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> protected region to unprotected (or back), exiting to the VMM to make
> the necessary changes to the guest_memfd and memslot mappings. On the
> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> calls.
> 
> The VMM may wish to reject the RIPAS change requested by the guest. For
> now it can only do this by no longer scheduling the VCPU as we don't
> currently have a usecase for returning that rejection to the guest, but
> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> open for adding a new ioctl in the future for this purpose.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>  * Switch to the new RMI_RTT_UNPROT_UNMAP range-based API.
>  * Drop ugly hack for RMM bug which errored when the RIPAS was already
>    set to the desired value.
> Changes since v12:
>  * Switch to the new RMM v2.0 RMI_RTT_DATA_UNMAP which can unmap an
>    address range.
> Changes since v11:
>  * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
>    adding functions before they are used.
>  * Drop the CAP for setting RIPAS and adapt to changes from previous
>    patches.
> Changes since v10:
>  * Add comment explaining the assignment of rec->run->exit.ripas_base in
>    kvm_complete_ripas_change().
> Changes since v8:
>  * Make use of ripas_change() from a previous patch to implement
>    realm_set_ipa_state().
>  * Update exit.ripas_base after a RIPAS change so that, if instead of
>    entering the guest we exit to user space, we don't attempt to repeat
>    the RIPAS change (triggering an error from the RMM).
> Changes since v7:
>  * Rework the loop in realm_set_ipa_state() to make it clear when the
>    'next' output value of rmi_rtt_set_ripas() is used.
> New patch for v7: The code was previously split awkwardly between two
> other patches.
> ---
>  arch/arm64/include/asm/kvm_rmi.h |   6 +
>  arch/arm64/kvm/mmu.c             |   8 +-
>  arch/arm64/kvm/rmi.c             | 439 +++++++++++++++++++++++++++++++
>  3 files changed, 450 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index feb534a6678e..007249a13dbc 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -88,6 +88,12 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>  int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>  int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>  
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   unsigned long size,
> +			   bool unmap_private,
> +			   bool may_block);
> +
>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>  						unsigned long addr)
>  {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index eb56d4e7f21a..10ca9dbe40a0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>   * @start: The intermediate physical base address of the range to unmap
>   * @size:  The size of the area to unmap
>   * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped

Do you think it's better if we use enum kvm_gfn_range_filter for this?
Pass KVM_FILTER_{PRIVATE, SHARED} to indicate what to unmap. This way we
don't have the think about booleans. kvm_realm_unmap_range() in patch 23
will have to change too though.

>   *
>   * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>   * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>   * with things behind our backs.
>   */
>  static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>  	phys_addr_t end = start + size;
> @@ -343,7 +344,7 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>  	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
>  		return;
>  
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	__unmap_stage2_range(mmu, start, size, may_block, false);
>  }
>  
>  void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -2418,7 +2419,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  
>  	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>  			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     !(range->attr_filter & KVM_FILTER_PRIVATE));
>  
>  	kvm_nested_s2_unmap(kvm, range->may_block);
>  	return false;

[...]

Thanks,
Wei-Lin Chang
