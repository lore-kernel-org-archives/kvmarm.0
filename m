From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 6/9] KVM: arm/arm64: Limit icache invalidation to
 prefetch aborts
Date: Wed, 1 Nov 2017 11:17:27 +0100
Message-ID: <20171101101727.ysc65qlxwsqe5sfq@kamzik.brq.redhat.com>
References: <20171023161122.15291-1-marc.zyngier@arm.com>
 <20171023161122.15291-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171023161122.15291-7-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23, 2017 at 05:11:19PM +0100, Marc Zyngier wrote:
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 2174244f6317..0417c8e2a81c 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1292,7 +1292,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  unsigned long fault_status)
>  {
>  	int ret;
> -	bool write_fault, writable, hugetlb = false, force_pte = false;
> +	bool write_fault, exec_fault, writable, hugetlb = false, force_pte = false;
>  	unsigned long mmu_seq;
>  	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -1304,7 +1304,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	unsigned long flags = 0;
>  
>  	write_fault = kvm_is_write_fault(vcpu);
> -	if (fault_status == FSC_PERM && !write_fault) {
> +	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
> +	VM_BUG_ON(write_fault && exec_fault);

This VM_BUG_ON can never fire as long as kvm_is_write_fault() is
defined as

 {
   if (kvm_vcpu_trap_is_iabt(vcpu))
       return false;
   return kvm_vcpu_dabt_iswrite(vcpu);
 }

Thanks,
drew
