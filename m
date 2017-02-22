From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 47/55] KVM: arm/arm64: Forward the guest hypervisor's stage
 2 permission faults
Date: Wed, 22 Feb 2017 19:15:46 +0100
Message-ID: <20170222181546.GX26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-48-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1670F40C8E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 13:15:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTn6upa4T4DP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 13:15:01 -0500 (EST)
Received: from mail-wr0-f181.google.com (mail-wr0-f181.google.com
 [209.85.128.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7486240C74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 13:15:01 -0500 (EST)
Received: by mail-wr0-f181.google.com with SMTP id s27so7828113wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 10:16:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1483943091-1364-48-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:43AM -0500, Jintack Lim wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> When faulting on a shadow stage 2 page table we have to check if the
> fault was a permission fault and if so, if that fault needs to be
> handled by the guest hypervisor before us, in case the guest hypervisor
> has created a less permissive S2 entry than the operation required.

So I was a bit brief here.

We can have discrepancies between the nested stage 2 page table and the
shadow one in a couple of cases.  For example, the guest hypervisor can
mark a page writable but the host hypervisor maps the page read-only in
the shadow page table, if using something like KSM on the host level.
In this case, a write fault is handled directly by the host hypervisor.
But we could also simply have a read-only page mapped read-only in both
tables, in which case the host hypervisor cannot do anything else than
telling the guest hypervisor about the fault.

Can you incorporate that into the commit message?

Thanks,
-Christoffer

> 
> Check if this is the case, and inject a fault if it is.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm/include/asm/kvm_mmu.h   |  7 +++++++
>  arch/arm/kvm/mmu.c               |  5 +++++
>  arch/arm64/include/asm/kvm_mmu.h |  9 +++++++++
>  arch/arm64/kvm/mmu-nested.c      | 33 +++++++++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index ab41a10..0d106ae 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -241,6 +241,13 @@ static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  	return 0;
>  }
>  
> +static inline int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> +					   phys_addr_t fault_ipa,
> +					   struct kvm_s2_trans *trans)
> +{
> +	return 0;
> +}
> +
>  static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
>  static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
>  static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index abdf345..68fc8e8 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1542,6 +1542,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
>  		if (ret)
>  			goto out_unlock;
> +
> +		ret = kvm_s2_handle_perm_fault(vcpu, fault_ipa, &nested_trans);
> +		if (ret)
> +			goto out_unlock;
> +
>  		ipa = nested_trans.output;
>  	}
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 2ac603d..2086296 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -338,6 +338,8 @@ struct kvm_s2_trans {
>  bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr);
>  int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  		       struct kvm_s2_trans *result);
> +int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +			     struct kvm_s2_trans *trans);
>  void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
>  int kvm_nested_s2_init(struct kvm_vcpu *vcpu);
>  void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu);
> @@ -366,6 +368,13 @@ static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  	return 0;
>  }
>  
> +static inline int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> +					   phys_addr_t fault_ipa,
> +					   struct kvm_s2_trans *trans)
> +{
> +	return 0;
> +}
> +
>  static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
>  static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
>  static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
> diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
> index b579d23..65ad0da 100644
> --- a/arch/arm64/kvm/mmu-nested.c
> +++ b/arch/arm64/kvm/mmu-nested.c
> @@ -52,6 +52,19 @@ static unsigned int pa_max(void)
>  	return ps_to_output_size(parange);
>  }
>  
> +static int vcpu_inject_s2_perm_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
> +				     int level)
> +{
> +	u32 esr;
> +
> +	vcpu->arch.ctxt.el2_regs[FAR_EL2] = vcpu->arch.fault.far_el2;
> +	vcpu->arch.ctxt.el2_regs[HPFAR_EL2] = vcpu->arch.fault.hpfar_el2;
> +	esr = kvm_vcpu_get_hsr(vcpu) & ~ESR_ELx_FSC;
> +	esr |= ESR_ELx_FSC_PERM;
> +	esr |= level & 0x3;
> +	return kvm_inject_nested_sync(vcpu, esr);
> +}
> +
>  static int vcpu_inject_s2_trans_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
>  				      int level)
>  {
> @@ -268,6 +281,26 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  	return walk_nested_s2_pgd(vcpu, gipa, &wi, result);
>  }
>  
> +/*
> + * Returns non-zero if permission fault is handled by injecting it to the next
> + * level hypervisor.
> + */
> +int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +			     struct kvm_s2_trans *trans)
> +{
> +	unsigned long fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> +	bool write_fault = kvm_is_write_fault(vcpu);
> +
> +	if (fault_status != FSC_PERM)
> +		return 0;
> +
> +	if ((write_fault && !trans->writable) ||
> +	    (!write_fault && !trans->readable))
> +		return vcpu_inject_s2_perm_fault(vcpu, fault_ipa, trans->level);
> +
> +	return 0;
> +}
> +
>  /* expects kvm->mmu_lock to be held */
>  void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm)
>  {
> -- 
> 1.9.1
> 
> 
