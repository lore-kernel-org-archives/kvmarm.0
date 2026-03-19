Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED9F35CB89;
	Thu, 19 Mar 2026 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773943869; cv=none; b=N0FZEY+cF2SsQ6MgukQGdWHc86OqV/i6KEMZV2PifwCmcDOZMJDfD4zcLWBD1fD/Wwvd/LYWhSffDnKWq1L8LhkJhnSt6yTVaySzMPQkLom22j7lAXrkps9H74JUMlc+ATDjL1vK2vKkmdGNrapsFZ6+kAON1Ui7ADvd1DlkD2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773943869; c=relaxed/simple;
	bh=1WBgg5cwD8mRI6J+gn8DkGhSeWFkbzx3WaKDElsXMGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJE8WNuItWpA/cDHZ4ts+D2qwKQRotYfDuoGHf32Xx75G8gDM68BQUzAThfvjHrCG9k1xFtXDsI/thQxJbONXcYOeUFmAp0GY94cyZ2BJfGzKjsZ+PkS/MTJ14HDJ1HRt8E+k8PzKu46sJfJe1AozvuiXdl+qW6enH/Fc8mT1Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94AB32247;
	Thu, 19 Mar 2026 11:11:01 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87BDE3F7BD;
	Thu, 19 Mar 2026 11:11:02 -0700 (PDT)
Date: Thu, 19 Mar 2026 18:10:41 +0000
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
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v13 17/48] arm64: RMI: Allocate/free RECs to match vCPUs
Message-ID: <c4u3bivkm2a4w6jtjt6uuas2nfyeisgpir4ati3irbs5oboo2u@belozcancqh5>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-18-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318155413.793430-18-steven.price@arm.com>

On Wed, Mar 18, 2026 at 03:53:41PM +0000, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 
> RECs must also be supplied with addition pages - auxiliary (or AUX)
> granules - for storing the larger registers state (e.g. for SVE). The
> number of AUX granules for a REC depends on the parameters with which
> the Realm was created - the RMM makes this information available via the
> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
> 
> Note that only some of register state for the REC can be set by KVM, the
> rest is defined by the RMM (zeroed). The register state then cannot be
> changed by KVM after the REC is created (except when the guest
> explicitly requests this e.g. by performing a PSCI call).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>  * Use the new range-based delegation RMI.
> Changes since v11:
>  * Remove the KVM_ARM_VCPU_REC feature. User space no longer needs to
>    configure each VCPU separately, RECs are created on the first VCPU
>    run of the guest.
> Changes since v9:
>  * Size the aux_pages array according to the PAGE_SIZE of the host.
> Changes since v7:
>  * Add comment explaining the aux_pages array.
>  * Rename "undeleted_failed" variable to "should_free" to avoid a
>    confusing double negative.
> Changes since v6:
>  * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
>    realm guest.
>  * Support host page size being larger than RMM's granule size when
>    allocating/freeing aux granules.
> Changes since v5:
>  * Separate the concept of vcpu_is_rec() and
>    kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>    the indication that the VCPU is a REC.
> Changes since v2:
>  * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
> ---
>  arch/arm64/include/asm/kvm_emulate.h |   2 +-
>  arch/arm64/include/asm/kvm_host.h    |   3 +
>  arch/arm64/include/asm/kvm_rmi.h     |  21 +++
>  arch/arm64/kvm/arm.c                 |  10 +-
>  arch/arm64/kvm/reset.c               |   1 +
>  arch/arm64/kvm/rmi.c                 | 196 +++++++++++++++++++++++++++
>  6 files changed, 230 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 39310d9b4e16..d194d91fbc2a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -708,7 +708,7 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>  
>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>  {
> -	return false;
> +	return kvm_is_realm(vcpu->kvm);
>  }
>  
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9267a2f2d65b..64304848aad4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -924,6 +924,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>  	struct vncr_tlb	*vncr_tlb;
> +
> +	/* Realm meta data */
> +	struct realm_rec rec;
>  };
>  
>  /*
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 6c13847480f7..4e2c61e71a38 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -63,6 +63,26 @@ struct realm {
>  	unsigned int ia_bits;
>  };
>  
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	/*
> +	 * REC_PARAMS_AUX_GRANULES is the maximum number of 4K granules that
> +	 * the RMM can require. The array is sized to be large enough for the
> +	 * maximum number of host sized pages that could be required.
> +	 */
> +	struct page *aux_pages[(REC_PARAMS_AUX_GRANULES * SZ_4K) >> PAGE_SHIFT];
> +	struct rec_run *run;
> +};
> +
>  void kvm_init_rmi(void);
>  u32 kvm_realm_ipa_limit(void);
>  
> @@ -70,6 +90,7 @@ int kvm_init_realm_vm(struct kvm *kvm);
>  int kvm_activate_realm(struct kvm *kvm);
>  void kvm_destroy_realm(struct kvm *kvm);
>  void kvm_realm_destroy_rtts(struct kvm *kvm);
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>  
>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>  						unsigned long addr)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c8e51ed009c0..8c50ebd9fba0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -575,6 +575,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	/* Force users to call KVM_ARM_VCPU_INIT */
>  	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>  
> +	vcpu->arch.rec.mpidr = INVALID_HWID;
> +
>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  
>  	/* Set up the timer */
> @@ -1549,7 +1551,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  	return -EINVAL;
>  }
>  
> -static unsigned long system_supported_vcpu_features(void)
> +static unsigned long system_supported_vcpu_features(struct kvm *kvm)
>  {
>  	unsigned long features = KVM_VCPU_VALID_FEATURES;
>  
> @@ -1587,7 +1589,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>  			return -ENOENT;
>  	}
>  
> -	if (features & ~system_supported_vcpu_features())
> +	if (features & ~system_supported_vcpu_features(vcpu->kvm))

Hi,

Are these two hunks superfluous?

Thanks,
Wei-Lin Chang

>  		return -EINVAL;
>  
>  	/*
> @@ -1609,6 +1611,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>  	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
>  		return -EINVAL;
>  
> +	/* Realms are incompatible with AArch32 */
> +	if (vcpu_is_rec(vcpu))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a..4bbf58892928 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -161,6 +161,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>  	kfree(vcpu->arch.vncr_tlb);
>  	kfree(vcpu->arch.ccsidr);
> +	kvm_destroy_rec(vcpu);
>  }
>  
>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 937fababf960..6daf14c4b413 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -207,6 +207,28 @@ static int get_start_level(struct realm *realm)
>  	return 4 - stage2_pgtable_levels(realm->ia_bits);
>  }
>  
> +static int delegate_range(phys_addr_t phys, unsigned long size)
> +{
> +	unsigned long ret;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
> +		if (ret == RMI_SUCCESS)
> +			phys = out_top;
> +		else if (ret != RMI_BUSY && ret != RMI_BLOCKED)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int delegate_page(phys_addr_t phys)
> +{
> +	return delegate_range(phys, PAGE_SIZE);
> +}
> +
>  static int undelegate_range(phys_addr_t phys, unsigned long size)
>  {
>  	unsigned long ret;
> @@ -372,9 +394,177 @@ static int realm_ensure_created(struct kvm *kvm)
>  	return -ENXIO;
>  }
>  
> +static void free_rec_aux(struct page **aux_pages,
> +			 unsigned int num_aux)
> +{
> +	unsigned int i;
> +	unsigned int page_count = 0;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		struct page *aux_page = aux_pages[page_count++];
> +		phys_addr_t aux_page_phys = page_to_phys(aux_page);
> +
> +		if (!WARN_ON(undelegate_page(aux_page_phys)))
> +			__free_page(aux_page);
> +		aux_page_phys += PAGE_SIZE;
> +	}
> +}
> +
> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	struct page *aux_page;
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +
> +		aux_page_phys = page_to_phys(aux_page);
> +		if (delegate_page(aux_page_phys)) {
> +			ret = -ENXIO;
> +			goto err_undelegate;
> +		}
> +		aux_phys_pages[i] = aux_page_phys;
> +		aux_pages[i] = aux_page;
> +	}
> +
> +	return 0;
> +err_undelegate:
> +	while (i > 0) {
> +		i--;
> +		if (WARN_ON(undelegate_page(aux_phys_pages[i]))) {
> +			/* Leak the page if the undelegate fails */
> +			goto out_err;
> +		}
> +	}
> +	__free_page(aux_page);
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
> +
> +static int kvm_create_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +	struct rec_params *params;
> +	int r, i;
> +
> +	if (rec->run)
> +		return -EBUSY;
> +
> +	/*
> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
> +	 * flag covers v0.2 and onwards.
> +	 */
> +	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
> +		return -EINVAL;
> +
> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
> +
> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
> +	if (!params || !rec->rec_page || !rec->run) {
> +		r = -ENOMEM;
> +		goto out_free_pages;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
> +		params->gprs[i] = vcpu_regs->regs[i];
> +
> +	params->pc = vcpu_regs->pc;
> +
> +	if (vcpu->vcpu_id == 0)
> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	if (delegate_page(rec_page_phys)) {
> +		r = -ENXIO;
> +		goto out_free_pages;
> +	}
> +
> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
> +	if (r)
> +		goto out_undelegate_rmm_rec;
> +
> +	params->num_rec_aux = realm->num_aux;
> +	params->mpidr = mpidr;
> +
> +	if (rmi_rec_create(virt_to_phys(realm->rd),
> +			   rec_page_phys,
> +			   virt_to_phys(params))) {
> +		r = -ENXIO;
> +		goto out_free_rec_aux;
> +	}
> +
> +	rec->mpidr = mpidr;
> +
> +	free_page((unsigned long)params);
> +	return 0;
> +
> +out_free_rec_aux:
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +out_undelegate_rmm_rec:
> +	if (WARN_ON(undelegate_page(rec_page_phys)))
> +		rec->rec_page = NULL;
> +out_free_pages:
> +	free_page((unsigned long)rec->run);
> +	free_page((unsigned long)rec->rec_page);
> +	free_page((unsigned long)params);
> +	rec->run = NULL;
> +	return r;
> +}
> +
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +
> +	if (!vcpu_is_rec(vcpu))
> +		return;
> +
> +	if (!rec->run) {
> +		/* Nothing to do if the VCPU hasn't been finalized */
> +		return;
> +	}
> +
> +	free_page((unsigned long)rec->run);
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	/*
> +	 * The REC and any AUX pages cannot be reclaimed until the REC is
> +	 * destroyed. So if the REC destroy fails then the REC page and any AUX
> +	 * pages will be leaked.
> +	 */
> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
> +		return;
> +
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +
> +	free_delegated_page(rec_page_phys);
> +}
> +
>  int kvm_activate_realm(struct kvm *kvm)
>  {
>  	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
>  	int ret;
>  
>  	if (kvm_realm_state(kvm) >= REALM_STATE_ACTIVE)
> @@ -397,6 +587,12 @@ int kvm_activate_realm(struct kvm *kvm)
>  	/* Mark state as dead in case we fail */
>  	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
>  
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		ret = kvm_create_rec(vcpu);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	ret = rmi_realm_activate(virt_to_phys(realm->rd));
>  	if (ret)
>  		return -ENXIO;
> -- 
> 2.43.0
> 
