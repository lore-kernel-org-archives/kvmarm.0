Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D903F315D5B;
	Sat, 21 Mar 2026 16:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774110042; cv=none; b=pzzjyBloD10LGCpIoC3K0bu0aTiW2KBUEf6ZgIJYVUcrb7wQzD2kMBOszcJ0qU1dj23p937ZRHaTM61jKCAQseciyxQsDoUlAVfAB6whAVxeMR6xYtP0Yh8cMcC7e/7QFWbJjFSaGuo02f0WbUMKqYAi1JyYoxAmlRxPCeRcqxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774110042; c=relaxed/simple;
	bh=cLZQ5GbOxC5VbxosB5KmRGqiGqtfIxol76TYpOveYrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAxExxryaD+TEZpJO7I86Vb0VbiyXMjOaFCDqcQX9WTVvkqvi5K/E8eRJQyVceg5yltcKDoiq4rUHcpwekjVYOzlTJKb4P8MsfQrI7aT+ywrVYCg1NVpYDmgT7XTGToa8CEezD3bRSagHBP47VlPLXUI1CnSuaGC1CPrZXP8eRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FAF61595;
	Sat, 21 Mar 2026 09:20:34 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43A9D3F73B;
	Sat, 21 Mar 2026 09:20:35 -0700 (PDT)
Date: Sat, 21 Mar 2026 16:20:27 +0000
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
Subject: Re: [PATCH v13 26/48] arm64: RMI: Create the realm descriptor
Message-ID: <6lw7hpf7ctgvm56js2zwsbu2k73bsyrany6pp7g4qjruhu6m5v@2gs2rvaxizvj>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-27-steven.price@arm.com>
 <oukw53xfroe32rb26jy365nqsuttlakkjgpmh6sszdprx6nqfc@qfmwsob2ewa4>
 <a8ae70c5-b225-4c35-bf37-c5b1c91c473e@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8ae70c5-b225-4c35-bf37-c5b1c91c473e@arm.com>

On Fri, Mar 20, 2026 at 04:41:12PM +0000, Steven Price wrote:
> On 19/03/2026 18:25, Wei-Lin Chang wrote:
> > On Wed, Mar 18, 2026 at 03:53:50PM +0000, Steven Price wrote:
> >> Creating a realm involves first creating a realm descriptor (RD). This
> >> involves passing the configuration information to the RMM. Do this as
> >> part of realm_ensure_created() so that the realm is created when it is
> >> first needed.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >> Changes since v12:
> >>  * Since RMM page size is now equal to the host's page size various
> >>    calculations are simplified.
> >>  * Switch to using range based APIs to delegate/undelegate.
> >>  * VMID handling is now handled entirely by the RMM.
> >> ---
> >>  arch/arm64/kvm/rmi.c | 94 +++++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 92 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> >> index 38349c7b34f4..d5fee203824b 100644
> >> --- a/arch/arm64/kvm/rmi.c
> >> +++ b/arch/arm64/kvm/rmi.c
> >> @@ -649,6 +649,83 @@ static void realm_unmap_shared_range(struct kvm *kvm,
> >>  			     start, end);
> >>  }
> >>  
> >> +static int realm_create_rd(struct kvm *kvm)
> >> +{
> >> +	struct realm *realm = &kvm->arch.realm;
> >> +	struct realm_params *params = realm->params;
> >> +	void *rd = NULL;
> >> +	phys_addr_t rd_phys, params_phys;
> >> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> >> +	int i, r;
> >> +
> >> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> >> +
> >> +	if (WARN_ON(realm->rd || !realm->params))
> >> +		return -EEXIST;
> >> +
> >> +	rd = (void *)__get_free_page(GFP_KERNEL);
> > 
> > Hi,
> > 
> > Should this be GFP_KERNEL_ACCOUNT?
> 
> Yes that would be better.
> 
> >> +	if (!rd)
> >> +		return -ENOMEM;
> >> +
> >> +	rd_phys = virt_to_phys(rd);
> >> +	if (delegate_page(rd_phys)) {
> >> +		r = -ENXIO;
> >> +		goto free_rd;
> >> +	}
> >> +
> >> +	if (delegate_range(kvm->arch.mmu.pgd_phys, pgd_size)) {
> >> +		r = -ENXIO;
> >> +		goto out_undelegate_tables;
> >> +	}
> >> +
> >> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> >> +	params->rtt_level_start = get_start_level(realm);
> >> +	params->rtt_num_start = pgd_size / PAGE_SIZE;
> >> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> >> +
> >> +	if (kvm->arch.arm_pmu) {
> >> +		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
> >> +		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
> >> +	}
> >> +
> >> +	if (kvm_lpa2_is_enabled())
> >> +		params->flags |= RMI_REALM_PARAM_FLAG_LPA2;
> >> +
> >> +	params_phys = virt_to_phys(params);
> >> +
> >> +	if (rmi_realm_create(rd_phys, params_phys)) {
> >> +		r = -ENXIO;
> >> +		goto out_undelegate_tables;
> >> +	}
> >> +
> >> +	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> >> +		WARN_ON(rmi_realm_destroy(rd_phys));
> >> +		r = -ENXIO;
> >> +		goto out_undelegate_tables;
> >> +	}
> >> +
> >> +	realm->rd = rd;
> >> +	WRITE_ONCE(realm->state, REALM_STATE_NEW);
> >> +	/* The realm is up, free the parameters.  */
> >> +	free_page((unsigned long)realm->params);
> >> +	realm->params = NULL;
> >> +
> >> +	return 0;
> >> +
> >> +out_undelegate_tables:
> >> +	if (WARN_ON(undelegate_range(kvm->arch.mmu.pgd_phys, i))) {
> >> +		/* Leak the pages if they cannot be returned */
> >> +		kvm->arch.mmu.pgt = NULL;
> > 
> > Did you mean kvm->arch.mmu.pgd_phys = NULL; ?
> 
> No, although I agree this isn't exactly ideal. kvm_free_stage2_pgd()
> uses mmu->pgt to decide whether to free the memory - pgd_phys isn't used
> in that path. Technically here we end up leaking more than just the PGD
> pages in this case, but as it's a "should never happen" case I didn't
> see the need to worry about the leak being a bit larger than necessary.

Thank you for the clarification.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Steve
> 
> > Thanks,
> > Wei-Lin Chang
> > 
> >> +	}
> >> +	if (WARN_ON(undelegate_page(rd_phys))) {
> >> +		/* Leak the page if it isn't returned */
> >> +		return r;
> >> +	}
> >> +free_rd:
> >> +	free_page((unsigned long)rd);
> >> +	return r;
> >> +}
> >> +
> >>  static void realm_unmap_private_range(struct kvm *kvm,
> >>  				      unsigned long start,
> >>  				      unsigned long end,
> >> @@ -893,8 +970,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
> >>  
> >>  static int realm_ensure_created(struct kvm *kvm)
> >>  {
> >> -	/* Provided in later patch */
> >> -	return -ENXIO;
> >> +	int ret;
> >> +
> >> +	switch (kvm_realm_state(kvm)) {
> >> +	case REALM_STATE_NONE:
> >> +		break;
> >> +	case REALM_STATE_NEW:
> >> +		return 0;
> >> +	case REALM_STATE_DEAD:
> >> +		return -ENXIO;
> >> +	default:
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	ret = realm_create_rd(kvm);
> >> +	return ret;
> >>  }
> >>  
> >>  static int set_ripas_of_protected_regions(struct kvm *kvm)
> >> -- 
> >> 2.43.0
> >>
> 
