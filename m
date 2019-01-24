From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 06/14] KVM: arm/arm64: Factor out VMID into struct kvm_vmid
Date: Thu, 24 Jan 2019 19:01:57 +0000
Message-ID: <9ec36462-5a93-8246-85d3-a3c528959341@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-7-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEFC54A3E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 14:02:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eCk+j-a1n4Ud for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 14:02:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F45C4A3B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 14:02:02 -0500 (EST)
In-Reply-To: <20190124140032.8588-7-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi guys,

(CC: +Suzuki)

On 24/01/2019 14:00, Christoffer Dall wrote:
> In preparation for nested virtualization where we are going to have more
> than a single VMID per VM, let's factor out the VMID data into a
> separate VMID data structure and change the VMID allocator to operate on
> this new structure instead of using a struct kvm.
> 
> This also means that udate_vttbr now becomes update_vmid, and that the
> vttbr itself is generated on the fly based on the stage 2 page table
> base address and the vmid.
> 
> We cache the physical address of the pgd when allocating the pgd to
> avoid doing the calculation on every entry to the guest and to avoid
> calling into potentially non-hyp-mapped code from hyp/EL2.
> 
> If we wanted to merge the VMID allocator with the arm64 ASID allocator
> at some point in the future, it should actually become easier to do that
> after this patch.

> Note that to avoid mapping the kvm_vmid_bits variable into hyp, we
> simply forego the masking of the vmid value in kvm_get_vttbr and rely on
> update_vmid to always assign a valid vmid value (within the supported
> range).


> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 8af4b1befa42..189d93461d33 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -596,5 +596,16 @@ static inline bool kvm_cpu_has_cnp(void)
>  	return system_supports_cnp();
>  }
>  
> +static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
> +{
> +	struct kvm_vmid *vmid = &kvm->arch.vmid;
> +	u64 vmid_field, baddr;
> +	u64 cnp = kvm_cpu_has_cnp() ? VTTBR_CNP_BIT : 0;
> +
> +	baddr = kvm->arch.pgd_phys;
> +	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
> +	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
> +}

(32bits version is the same ... but I guess there is nowhere to put it!)


> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 3dd240ea9e76..b77db673bb03 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -536,18 +529,12 @@ static void update_vttbr(struct kvm *kvm)
>  		kvm_call_hyp(__kvm_flush_vm_context);
>  	}
>  
> -	kvm->arch.vmid = kvm_next_vmid;
> +	vmid->vmid = kvm_next_vmid;
>  	kvm_next_vmid++;
> -	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
> -
> -	/* update vttbr to be used with the new vmid */
> -	pgd_phys = virt_to_phys(kvm->arch.pgd);

> -	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));

Where did this go? (escaped during a turbulent rebase?)

This removes the only caller of kvm_vttbr_baddr_mask()... It looks like this is
a safety check that the stage2-pgd is correctly aligned when the IPA size, and
thus size of the top level entry can by set by user-space.

... or is it unnecessary if alloc_pages_exact() can only return naturally
aligned groups of pages? (which I haven't checked)

Keeping it sounds like a good thing to have in case we accidentally merge
stage2/host-stage1 pgd's somewhere down the line.

(Suzuki suggested it would make more sense in kvm_alloc_stage2_pgd(), where we
could fail vm creation, instead of BUG()ing).

(this was added by e55cac5bf2a9c ("kvm: arm/arm64: Prepare for VM specific
stage2 translations"), the bulk of the logic is in 595583306434c ("kvm: arm64:
Dynamic configuration of VTTBR mask"))


> -	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
> -	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid | cnp;
> +	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
>  
>  	smp_wmb();
> -	WRITE_ONCE(kvm->arch.vmid_gen, atomic64_read(&kvm_vmid_gen));
> +	WRITE_ONCE(vmid->vmid_gen, atomic64_read(&kvm_vmid_gen));
>  
>  	spin_unlock(&kvm_vmid_lock);
>  }


Thanks,

James
