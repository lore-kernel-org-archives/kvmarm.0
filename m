Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898635;
	b=b2Mezh/ECXT/f2TQMg5hIxgZfn/Ig75q0p174BaFLWkoWcYHGKS/tuEZYDteqdr95CSJ
	 CSlTsVFgK/DY+ooDKk1XEPzIlACrkRsjPv/pWqPr9z441J93ZaW09guf8s/tqUDiqvxlY
	 XGPtvOQCAFyUyTp84R+kINc/EfL6mc5Rg4I5cE4PpcwA7sdll0bBdTFgRgSCjNw2yAAkW
	 7ma6+qWThOrYy/e3g8JhdVJdyvlvJbXXCsRwWEYQa9XCxWmA18N300+q8pzNMWPCqeqXF
	 1c1EbIC6qgpbBhrHXmOjks0/B9tGXih14aCuoc5IMBrQGgsbO/4+lF7FyOPvn4x3oYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898635;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Cvj1Ly35bd8jNKayZSTxEw57d+KYJA1oVr5ZW/o+JhQ=;
	b=qKkHfH6rwIYwfmdEfWlqYhAG24LQKYQ6OuGGGbX4tcSq2qUjh/mS5Hm7Tbj8T2YoOmwp
	 PyZCL1w6DiH8BeJOah+Pi5NSSt2IHBZwI/6R/xxrlZ7IqIAa/hizVYcoqGc0j6Hg/5ka5
	 M5JMuK3Tx+ZTBp3aZfHy494S6T6Ubroaw6uibMW/gD2i9FHelcQEIZbAx6nMLJiq4C3aJ
	 ufWq/9IM74jbeaiOwrtLKLrcHcoPRa4WlWqwGKfJvzArnONZow8QddrZIHS3J5gf98RkY
	 VTkOZ+GYVkGqwwls/tgGejvPgsm9Cd/jlUCadit3CAv4YnT0zqLkDZAkRsSJ/mXpB7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BeDwWjXx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47C9606A326;
	Thu,  5 Nov 2026 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BeDwWjXx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2221F000C1;
	Thu,  5 Nov 2026 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793898634;
	bh=Cvj1Ly35bd8jNKayZSTxEw57d+KYJA1oVr5ZW/o+JhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BeDwWjXxUivMpSOrVj4bw2z+U5fdxCjlB13yF+hlqERwVyJiI6aQe89+M46HHlWHZ
	 evOmRbwr4l9RDkNAm4OFIU+yA7610OiSi4DzRZe1vQgEOcadOjeAgnGCdo3iFQW7IJ
	 rkzdUs2qDQUm1V4EDp9DH7DGBAtPPhriWZbFJqFSkuRTi+pqMkY8gyMZZtWCju7bEB
	 4Jb6KEQUqM4yKq+G+cXMV+eoarjymWjNoKJ7lhlL3bgRRA2IYuYXu7Viep8jvtD/F5
	 93xJbY/KEmshz2ED75i/xFeO0aJVOKBKX7PAgLZ6piWzR0maFXRyRT8gvRx1Hcz0gp
	 We0i5kJcCbsZQ==
Date: Thu, 5 Nov 2026 17:10:29 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 26/28] KVM: arm64: Map memory on a SPE stage 2
 fault
Message-ID: <auy0PDOUEIAVfBlC@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-27-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-27-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:21PM +0100, Alexandru Elisei wrote:
> Make sure SPE in a guest can make progress even if something goes terribly
> wrong in KVM by mapping the memory on stage 2 fault SPE buffer management
> event.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I think I will hold off on this one until respin, as obviously things have
drifted from the current state of things with my prefault series, which changes
the fault paths.

It should allow you to drop the save/fake/restore of vcpu->arch.fault dance in
kvm_map_gpa(), since the abort path uses the ESR value stored in s2fd.

Also - on the commit message - worth mentioning what the fallback does in some
detail here :)

Thanks!

> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +
>  arch/arm64/kvm/arm.c              |  4 +-
>  arch/arm64/kvm/mmu.c              | 53 ++++++++++++++++++
>  arch/arm64/kvm/spe.c              | 93 ++++++++++++++++++++++++++++++-
>  4 files changed, 148 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 81abfb705aeb..31be131c8486 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1464,6 +1464,8 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val);
>  #define kvm_guest_owns_debug_regs(vcpu)		\
>  	((vcpu)->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED)
>
> +int kvm_map_gpa(struct kvm_vcpu *vcpu, u64 gpa, u8 fsc, bool s1ptw);
> +
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 689fa175f5f4..7c7d0616db53 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1421,8 +1421,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		if (kvm_vcpu_has_pmu(vcpu))
>  			kvm_pmu_sync_hwstate(vcpu);
>
> -		kvm_spe_sync_hwstate(vcpu);
> -
>  		/*
>  		 * Sync the vgic state before syncing the timer state because
>  		 * the timer code needs to know if the virtual timer
> @@ -1472,6 +1470,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>
>  		preempt_enable();
>
> +		kvm_spe_sync_hwstate(vcpu);
> +
>  		/*
>  		 * The ARMv8 architecture doesn't give the hypervisor
>  		 * a mechanism to prevent a guest from dropping to AArch32 EL0
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..d7e7365c5c5a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2796,3 +2796,56 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>
>  	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>  }
> +
> +int kvm_map_gpa(struct kvm_vcpu *vcpu, u64 gpa, u8 fsc, bool s1ptw)
> +{
> +	struct kvm_vcpu_fault_info *fault_info = &vcpu->arch.fault;
> +	struct kvm_vcpu_fault_info fault_backup = *fault_info;
> +	struct kvm_s2_fault_desc s2fd = {
> +		.vcpu		= vcpu,
> +		.fault_ipa	= gpa,
> +	};
> +	struct kvm_memory_slot *memslot;
> +	struct kvm *kvm = vcpu->kvm;
> +	gfn_t gfn;
> +	hva_t hva;
> +	int ret;
> +
> +	lockdep_assert(srcu_read_lock_held(&kvm->srcu));
> +
> +	if (WARN_ON_ONCE(is_protected_kvm_enabled() || vcpu_has_nv(vcpu)))
> +		return -EOPNOTSUPP;
> +
> +	if (esr_fsc_is_access_flag_fault(fsc)) {
> +		handle_access_fault(vcpu, gpa);
> +		return 0;
> +	}
> +
> +	gfn = gpa_to_gfn(gpa);
> +	memslot = gfn_to_memslot(kvm, gfn);
> +	if (!memslot)
> +		return -ENOENT;
> +	hva = gfn_to_hva_memslot(memslot, gfn);
> +	if (kvm_is_error_hva(hva))
> +		return -EFAULT;
> +
> +	s2fd.memslot = memslot;
> +	s2fd.hva = hva;
> +
> +	fault_info->esr_el2 = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_DABT_LOW) |
> +			      ESR_ELx_IL | FIELD_PREP(ESR_ELx_FSC, fsc);
> +	if (s1ptw)
> +		fault_info->esr_el2 |= ESR_ELx_S1PTW;
> +	else
> +		fault_info->esr_el2 |= ESR_ELx_WNR;
> +	fault_info->hpfar_el2 = FIELD_PREP(HPFAR_EL2_FIPA, gpa >> 12);
> +
> +	if (kvm_slot_has_gmem(memslot))
> +		ret = gmem_abort(&s2fd);
> +	else
> +		ret = user_mem_abort(&s2fd);
> +
> +	*fault_info = fault_backup;
> +
> +	return ret;
> +}
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index ef138562f939..e5f3d0dea7c5 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -10,6 +10,7 @@
>  #include <linux/perf_event.h>
>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/kvm_spe.h>
>  #include <asm/sysreg.h>
>
> @@ -242,17 +243,105 @@ static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level)
>  		vcpu_spe->irq_level = level;
>  }
>
> +static bool kvm_spe_should_handle_fault(struct kvm_vcpu *vcpu)
> +{
> +	u64 pmbsr = vcpu->arch.vcpu_spe.hw_pmbsr_el1;
> +	u64 pmbsr_ec = FIELD_GET(PMBSR_EL1_EC, pmbsr);
> +
> +	if (pmbsr_ec != PMBSR_EL1_EC_FAULT_S2)
> +		return false;
> +
> +	if (FIELD_GET(PMBSR_EL1_EA, pmbsr))
> +		return false;
> +
> +	if (esr_fsc_is_translation_fault(pmbsr) ||
> +	    esr_fsc_is_permission_fault(pmbsr) ||
> +	    esr_fsc_is_access_flag_fault(pmbsr))
> +		return true;
> +
> +	return false;
> +}
> +
> +static int kvm_spe_read_s1_desc(struct kvm_vcpu *vcpu, u64 gpa, u64 *desc,
> +				struct s1_walk_info *wi)
> +{
> +	u64 pmbsr = vcpu->arch.vcpu_spe.hw_pmbsr_el1;
> +	int ret;
> +
> +	ret = kvm_vcpu_read_s1_desc(vcpu, gpa, desc, wi);
> +	if (ret)
> +		return ret;
> +
> +	/* TODO: this should be a hardware capability check */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR2_EL1, SPE_EXC, IMP) &&
> +	    !(FIELD_GET(ESR_ELx_S1PTW, pmbsr)))
> +		return 0;
> +
> +	/*
> +	 * No choice but to assume that the s2 fault happened on a s1 table
> +	 * walk.
> +	 */
> +	return kvm_map_gpa(vcpu, gpa, FIELD_GET(ESR_ELx_FSC, pmbsr), true);
> +}
> +
> +static int kvm_handle_spe_fault(struct kvm_vcpu *vcpu)
> +{
> +	struct s1_walk_info wi = {
> +		.read_s1_desc	= kvm_spe_read_s1_desc,
> +		.regime		= TR_EL10,
> +		.as_el0		= false,
> +		.pan		= false,
> +	};
> +	struct s1_walk_result wr = {};
> +	u64 pmbptr = __vcpu_sys_reg(vcpu, PMBPTR_EL1);
> +	u64 pmbsr = vcpu->arch.vcpu_spe.hw_pmbsr_el1;
> +	int ret;
> +
> +	guard(srcu)(&vcpu->kvm->srcu);
> +
> +	ret = __kvm_translate_va(vcpu, &wi, &wr, pmbptr);
> +	if (ret == -EAGAIN)
> +		return 0;
> +	if (ret)
> +		return ret;
> +
> +	/* Stage 2 fault on a table walk was handled during the translation. */
> +	/* TODO: this should be a hardware capability check */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR2_EL1, SPE_EXC, IMP) &&
> +	    FIELD_GET(ESR_ELx_S1PTW, pmbsr))
> +		return 0;
> +
> +	return kvm_map_gpa(vcpu, wr.pa, FIELD_GET(ESR_ELx_FSC, pmbsr), false);
> +}
> +
>  void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +	u64 hw_pmbsr_el1;
> +	int ret;
>
>  	if (!vcpu_has_spe(vcpu))
>  		return;
>
> -	if (!FIELD_GET(PMBSR_EL1_S, vcpu_spe->hw_pmbsr_el1))
> +	hw_pmbsr_el1 = vcpu_spe->hw_pmbsr_el1;
> +	if (!FIELD_GET(PMBSR_EL1_S, hw_pmbsr_el1))
>  		return;
>
> -	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, vcpu_spe->hw_pmbsr_el1);
> +	if (kvm_spe_should_handle_fault(vcpu)) {
> +		pr_debug("SPE stage 2 fault PMBSR_EL1=0x%llx PMBPTR_EL1=0x%llx",
> +			 hw_pmbsr_el1, __vcpu_sys_reg(vcpu, PMBPTR_EL1));
> +		ret = kvm_handle_spe_fault(vcpu);
> +		if (ret)
> +			goto reinject;
> +		/* Let the guest know about the partial record. */
> +		if (FIELD_GET(PMBSR_EL1_DL, hw_pmbsr_el1))
> +			goto reinject;
> +		vcpu_spe->hw_pmbsr_el1 = 0;
> +		return;
> +	}
> +
> +reinject:
> +	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, hw_pmbsr_el1);
>  	vcpu_spe->hw_pmbsr_el1 = 0;
>  	kvm_spe_update_irq_level(vcpu, true);
>  }
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
