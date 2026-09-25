Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E363B408602
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358386; cv=none; b=TifE9mRmmRpcF6KEUbu14lNQiTcTIvsGSa4kTiEqyrdZVJhMiGdPXUU2Nuvdt+C9rDsC4f6jh01fFBxncQ0niyaXvS3LpH0V2BKwE3HkyaBJzwtKtx+SNDm7PogBft7RfUyTP6QJ/Rgl2Jb7xALyb+PSHD1adP7AzeZH2xZ+Kmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358386; c=relaxed/simple;
	bh=0jxUlmNryhyvEAXEcaOH2ALNdunF3D/3mrhhk27k/8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ud4oLgw2BkC4SGEaqhuDc4XnHuH46CzoOTrgQHYi+b8V9gbEjucoySveZFhZ4C29n4efN+bFLl5+/BBjBTnH2JhbtS8QLxiKaaI8BElgP6xWBTgOa84PT65KPrzgeM699kQ3diFvm+2I7/N5do9PnT0zOS4XGuurxRFrPkaKR4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KooR/I77; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KooR/I77"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3BFB169C;
	Fri, 25 Sep 2026 10:46:20 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0138D3F632;
	Fri, 25 Sep 2026 10:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790358384; bh=0jxUlmNryhyvEAXEcaOH2ALNdunF3D/3mrhhk27k/8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KooR/I77tXtD7yf9rtkd4zjjU9Yy3Rk6vRiBaHfEyL7GDPf+GJ5aQ+YInV3PdXr10
	 FC/4hCzoo056Rz1UGOxcEGZFiWgzXunzMdyFIGw7nKYPE4LdWF4rGZbN4XRTSL7uKk
	 s5KKlYv7JW46l1RvVpkajYEFHRmFpL0PsaITv65E=
Date: Fri, 25 Sep 2026 18:46:13 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com
Subject: Re: [PATCH v1 2/6] KVM: arm64: Pass kvm_s2_fault_desc to
 fault_supports_stage2_huge_mapping()
Message-ID: <g4zngh2pzvbesjwnus5kjgpmmot42qdjgef4n3ivf437xkfsdb@752uath6hkeu>
References: <20260922130821.1666713-1-vdonnefort@google.com>
 <20260922130821.1666713-3-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922130821.1666713-3-vdonnefort@google.com>

On Tue, Sep 22, 2026 at 02:08:17PM +0100, Vincent Donnefort wrote:
> Pass the fault descriptor to fault_supports_stage2_huge_mapping() instead
> of passing memslot and hva separately so it can access other s2fd
> members such as vcpu.
> 
> No functional change intended.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Nit: Maybe also mention the transparent_hugepage_adjust() change in the
commit message?

Either way:

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..9dfaf4f277b5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1353,12 +1353,21 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
>  
> -static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
> -					       unsigned long hva,
> +struct kvm_s2_fault_desc {
> +	struct kvm_vcpu		*vcpu;
> +	phys_addr_t		fault_ipa;
> +	struct kvm_s2_trans	*nested;
> +	struct kvm_memory_slot	*memslot;
> +	unsigned long		hva;
> +};
> +
> +static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s2fd,
>  					       unsigned long map_size)
>  {
> -	gpa_t gpa_start;
> +	struct kvm_memory_slot *memslot = s2fd->memslot;
> +	unsigned long hva = s2fd->hva;
>  	hva_t uaddr_start, uaddr_end;
> +	gpa_t gpa_start;
>  	size_t size;
>  
>  	/* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
> @@ -1427,9 +1436,9 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   * Returns the size of the mapping.
>   */
>  static long
> -transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> -			    unsigned long hva, kvm_pfn_t *pfnp, gfn_t *gfnp)
> +transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd, kvm_pfn_t *pfnp, gfn_t *gfnp)
>  {
> +	struct kvm *kvm = s2fd->vcpu->kvm;
>  	kvm_pfn_t pfn = *pfnp;
>  	gfn_t gfn = *gfnp;
>  
> @@ -1438,8 +1447,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  	 * sure that the HVA and IPA are sufficiently aligned and that the
>  	 * block map is contained within the memslot.
>  	 */
> -	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> -		int sz = get_user_mapping_size(kvm, hva);
> +	if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE)) {
> +		int sz = get_user_mapping_size(kvm, s2fd->hva);
>  
>  		if (sz < 0)
>  			return sz;
> @@ -1597,14 +1606,6 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
>  	return prot;
>  }
>  
> -struct kvm_s2_fault_desc {
> -	struct kvm_vcpu		*vcpu;
> -	phys_addr_t		fault_ipa;
> -	struct kvm_s2_trans	*nested;
> -	struct kvm_memory_slot	*memslot;
> -	unsigned long		hva;
> -};
> -
>  static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>  	bool write_fault, exec_fault;
> @@ -1791,7 +1792,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  	switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
>  	case PUD_SHIFT:
> -		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
> +		if (fault_supports_stage2_huge_mapping(s2fd, PUD_SIZE))
>  			break;
>  		fallthrough;
>  #endif
> @@ -1799,7 +1800,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  		vma_shift = PMD_SHIFT;
>  		fallthrough;
>  	case PMD_SHIFT:
> -		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
> +		if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE))
>  			break;
>  		fallthrough;
>  	case CONT_PTE_SHIFT:
> @@ -2049,9 +2050,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  		if (perm_fault_granule > PAGE_SIZE) {
>  			mapping_size = perm_fault_granule;
>  		} else {
> -			mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
> -								   s2fd->hva, &pfn,
> -								   &gfn);
> +			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
>  			if (mapping_size < 0) {
>  				ret = mapping_size;
>  				goto out_unlock;
> -- 
> 2.55.0.1082.g2b9226bbc0-goog
> 
> 
