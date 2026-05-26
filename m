Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895AE3491E1;
	Tue, 26 May 2026 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779835659; cv=none; b=BIxgDHTxaIQT/1mfYdiujBx/R9Ahch9JJZyN5hu0fEDYPehnH6bVhGuMyomUsPKmuJuaVAbA+4zoOvy95yCvgO7QKd25tBTL9Xj+lTFwpsFcoVN9QZ/X+RiPzWHvEulpdEg2AdEgXBR1NYrBMKJh/MUvXChqK/QDIXiL1F1dVps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779835659; c=relaxed/simple;
	bh=v0TjbesxR+ewebueTeBsTzE4hgzEHetSxrCATk8rz8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkOpQqCtNTHK4XtWFsbxDIlUMiyeBg1JuquZcayFukGWQVLSz9EGtgDsxfWZQDWTju4kPJWNScQaSHQTP+Wpf67gZEKbuTfkXjwuwEEJvXAOo03NKjJcpvpCkCl3l8UnWGQePrTNtYjCabJJ6n3xY3+RNBojB4Mr9qEfHDBYCs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Kn24PYW0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Kn24PYW0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAFD92F;
	Tue, 26 May 2026 15:47:31 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7184F3F7B4;
	Tue, 26 May 2026 15:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779835656; bh=v0TjbesxR+ewebueTeBsTzE4hgzEHetSxrCATk8rz8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kn24PYW017ZV+xG4DGuE8eTax92R0+umH+xlnFse++Ka6RT2efOcQ1oseBxhV9OyK
	 /8EVat3FnQTAImeDMytTpUCMbNIxQn/q4cAL2TN4Z9Y4Pe3x5c8k928dsuX+qzw95y
	 1ZOvJaM3v8HdPYe4QsvGrVZu2aI/EXHBn9hDRw1c=
Date: Tue, 26 May 2026 23:47:23 +0100
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
Subject: Re: [PATCH v14 28/44] arm64: RMI: Create the realm descriptor
Message-ID: <wshgh4i6uqytq65rh3j2risam2y2evjnfyztoee46soemp5i4x@qhzj4lcs33yj>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-29-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513131757.116630-29-steven.price@arm.com>

Hi,

On Wed, May 13, 2026 at 02:17:36PM +0100, Steven Price wrote:
> Creating a realm involves first creating a realm descriptor (RD). This
> involves passing the configuration information to the RMM. Do this as
> part of realm_ensure_created() so that the realm is created when it is
> first needed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>  * The RMM no longer uses AUX granules, so no need to ask it how many it
>    needs.
>  * Adapted to other changes.
> Changes since v12:
>  * Since RMM page size is now equal to the host's page size various
>    calculations are simplified.
>  * Switch to using range based APIs to delegate/undelegate.
>  * VMID handling is now handled entirely by the RMM.
> ---
>  arch/arm64/kvm/rmi.c | 88 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index fb96bcaa73ed..cae29fd3353c 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -418,6 +418,77 @@ static void realm_unmap_shared_range(struct kvm *kvm,
>  			     start, end);
>  }
>  
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int r;
> +
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +
> +	if (WARN_ON(realm->rd || !realm->params))
> +		return -EEXIST;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_delegate_page(rd_phys)) {
> +		r = -ENXIO;
> +		goto free_rd;
> +	}
> +
> +	if (rmi_delegate_range(kvm->arch.mmu.pgd_phys, pgd_size)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	params->rtt_level_start = get_start_level(realm);
> +	params->rtt_num_start = pgd_size / PAGE_SIZE;
> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> +
> +	if (kvm->arch.arm_pmu) {
> +		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
> +		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
> +	}
> +
> +	if (kvm_lpa2_is_enabled())
> +		params->flags |= RMI_REALM_PARAM_FLAG_LPA2;
> +
> +	params_phys = virt_to_phys(params);
> +
> +	if (rmi_realm_create(rd_phys, params_phys)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	realm->rd = rd;
> +	kvm_set_realm_state(kvm, REALM_STATE_NEW);
> +	/* The realm is up, free the parameters.  */
> +	free_page((unsigned long)realm->params);
> +	realm->params = NULL;
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys, pgd_size))) {
> +		/* Leak the pages if they cannot be returned */
> +		kvm->arch.mmu.pgt = NULL;
> +	}
> +	if (WARN_ON(rmi_undelegate_page(rd_phys))) {
> +		/* Leak the page if it isn't returned */
> +		return r;
> +	}
> +free_rd:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +
>  static void realm_unmap_private_range(struct kvm *kvm,
>  				      unsigned long start,
>  				      unsigned long end,
> @@ -647,8 +718,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
>  
>  static int realm_ensure_created(struct kvm *kvm)
>  {
> -	/* Provided in later patch */
> -	return -ENXIO;
> +	int ret;
> +
> +	switch (kvm_realm_state(kvm)) {
> +	case REALM_STATE_NONE:
> +		break;
> +	case REALM_STATE_NEW:
> +		return 0;
> +	case REALM_STATE_DEAD:
> +		return -ENXIO;
> +	default:
> +		return -EBUSY;
> +	}
> +
> +	ret = realm_create_rd(kvm);
> +	return ret;
>  }

I think ret can be simplified out.

Thanks,
Wei-Lin Chang

>  
>  static int set_ripas_of_protected_regions(struct kvm *kvm)
> -- 
> 2.43.0
> 
