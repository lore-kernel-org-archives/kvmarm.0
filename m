Received: from out-129.mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068A43220
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 18:31:24 +0000 (UTC)
Date: Wed, 15 Feb 2023 18:24:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676485493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TuerVw8H+lvd5C5aDhOZnh6mY1rE1c8GuVXscwWRNfA=;
	b=euTSnP6NAC5Gk3GepcKoHDyUgDpziIxealLy4hUFuEHKwFfoTzUegmgqTN0r+UwVroDxFS
	ms9SZBmU6xRhbTNTSgmhipH5I1B+shFp6+OgGdARcomxYzf7QYzxUd1kmvR8k1rpCGdU7D
	h6ETxk/L/lhPapEHcYNfr8kjE+wBuzo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Ben Gardon <bgardon@google.com>,
	David Matlack <dmatlack@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 7/8] kvm/arm64: Implement KVM_CAP_MEM_FAULT_NOWAIT for
 arm64
Message-ID: <Y+0jcC/Em/cnYe9t@linux.dev>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-8-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215011614.725983-8-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 15, 2023 at 01:16:13AM +0000, Anish Moorthy wrote:
> Just do atomic gfn_to_pfn_memslot when the cap is enabled. Since we
> don't have to deal with async page faults, the implementation is even
> simpler than on x86

All of Sean's suggestions about writing a change description apply here
too.

> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>  arch/arm64/kvm/arm.c |  1 +
>  arch/arm64/kvm/mmu.c | 14 ++++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 698787ed87e92..31bec7866c346 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  	case KVM_CAP_PTP_KVM:
>  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> +	case KVM_CAP_MEM_FAULT_NOWAIT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 01352f5838a00..964af7cd5f1c8 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1206,6 +1206,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	unsigned long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> +	bool mem_fault_nowait;
>  
>  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
>  	write_fault = kvm_is_write_fault(vcpu);
> @@ -1301,8 +1302,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 */
>  	smp_rmb();
>  
> -	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
> -				   write_fault, &writable, NULL);
> +	mem_fault_nowait = memory_faults_enabled(vcpu->kvm);
> +	pfn = __gfn_to_pfn_memslot(
> +		memslot, gfn, mem_fault_nowait, false, NULL,
> +		write_fault, &writable, NULL);
> +
> +	if (mem_fault_nowait && pfn == KVM_PFN_ERR_FAULT) {
> +		vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +		vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
> +		vcpu->run->memory_fault.size = vma_pagesize;
> +		return -EFAULT;

We really don't want to get out to userspace with EFAULT. Instead, we
should get out to userspace with 0 as the return code to indicate a
'normal' / expected exit.

That will require a bit of redefinition on user_mem_abort()'s return
values:

 - < 0, return to userspace with an error
 - 0, return to userspace for a 'normal' exit
 - 1, resume the guest

-- 
Thanks,
Oliver
