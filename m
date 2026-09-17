Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BCD34CDD
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 08:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635003; cv=none; b=TrfTC2jew63VXEqsEIOAq//s6TRWS8TKr6jw293x41AiQOAilwwwcbBTRq/3sS79tXHmCGw653ljAE1J4UgLd3owGjI/Oc+E4+5mBvu+0olyWEMqk3F2EKQaTC69fPAiFGUfGg1FEQ7LQ1Yd+xWqz8r1e7m+8tAA7TQYbKE8OHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635003; c=relaxed/simple;
	bh=BfoXGzTqvhboUtFeLjpBY72uKhV5dEYQ5tXJK2+7/0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bUmask3+P1j1py1f9x6oZFzuPyoUDnGUliZtqDlZepu2BDqBoEbySnWerYQP/gRek3g0mH3Dw0yoE8xcI44wdx1HF7iPaFsgkPbW1+e2auRnTcFRJqDck1Fmnxd87p6fhShP6MfU/oiUnVBsA9Yfg86jui2Nls2FgRGom8wn75g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wm9v5Giz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wm9v5Giz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D0F61476;
	Thu, 17 Sep 2026 01:49:45 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE8A63F882;
	Thu, 17 Sep 2026 01:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789634988; bh=BfoXGzTqvhboUtFeLjpBY72uKhV5dEYQ5tXJK2+7/0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wm9v5GizLFNig1dL0iJWSNmzO3outhEJ5yUD1FlqNaE3NL26CaMRTunFNYE0uksEs
	 15G2QEg10Rl5Ao8UebgnOj1S3j9PbPmfXI3Zz5THFhSJtU81bL8gxjiY4NMrJGJWgm
	 PGR8zk4rt5dlAEB28KCijAf0DWOMbtJ0Q4zY4yzM=
Message-ID: <f4ab0c30-2cca-40d4-8aac-6fc28d33fc05@arm.com>
Date: Thu, 17 Sep 2026 09:49:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
Content-Language: en-GB
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
 oupton@kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
 fuad.tabba@linux.dev, qperret@google.com
References: <20260915091606.2111217-1-vdonnefort@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260915091606.2111217-1-vdonnefort@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/09/2026 10:16, Vincent Donnefort wrote:
> Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
> of pages larger than 4kB") fixed the boot of non-protected VMs on system
> larger than 4K pages, align the fault IPA down to the page-size for
> protected VMs.
> 
> To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
> as a parameter is aligned to the size of the intended mapping, while
> HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
> system page size configuration.
> 
> Add a check at the start of pkvm_pgtable_stage2_map() as we do not
> support !PAGE_ALIGNED arguments and ensure callers pass a page-aligned
> IPA.
> 
> Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>   arch/arm64/kvm/mmu.c  | 12 +++++++-----
>   arch/arm64/kvm/pkvm.c |  3 +++
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> Changelog:
> 
> v3:
>    - Fix nested case in gmem_abort() (Sashiko)
> 
> v2: https://lore.kernel.org/all/20260914075839.4019904-1-vdonnefort@google.com/
> 
>    - Use gfn_to_gpa(gfn)
>    - Drop "phys" from the PAGE_ALIGNED check, it isn't a requirement.
>    - Fix gmem_abort() as well (Sashiko)
> 
> v1: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..e199dd339583 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1610,6 +1610,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>   	bool write_fault, exec_fault;
>   	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>   	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> +	phys_addr_t ipa = ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE);
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>   	unsigned long mmu_seq;
> @@ -1672,12 +1673,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>   		 * PTE, which will be preserved.
>   		 */
>   		prot &= ~KVM_NV_GUEST_MAP_SZ;
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, ipa,
>   								 prot, flags);
>   	} else {
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -							 __pfn_to_phys(pfn), prot,
> -							 memcache, flags);
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, ipa, PAGE_SIZE,
> +							 __pfn_to_phys(pfn),
> +							 prot, memcache, flags);
>   	}
>   
>   out_unlock:
> @@ -1710,6 +1711,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>   	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
>   	struct kvm_vcpu *vcpu = s2fd->vcpu;
>   	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	gfn_t gfn = gpa_to_gfn(s2fd->fault_ipa);

minor nit: Is there any reason why this is not consistent with the 
gmem_abort() ? i.e., using gfn instead of "ipa" ?

The patch as such looks correct to me. So, either way :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


>   	struct mm_struct *mm = current->mm;
>   	struct kvm *kvm = vcpu->kvm;
>   	void *hyp_memcache;
> @@ -1756,7 +1758,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>   	}
>   
>   	write_lock(&kvm->mmu_lock);
> -	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
> +	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
>   				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
>   				      hyp_memcache, 0);
>   	write_unlock(&kvm->mmu_lock);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8e4c6e4bec12..b7340c430ed6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   	u64 end = addr + size;
>   	int ret;
>   
> +	if (!PAGE_ALIGNED(addr | size))
> +		return -EINVAL;
> +
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
>   
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157

