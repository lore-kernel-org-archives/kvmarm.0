Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792496122;
	b=H39QUREGdAXsXHewBX/YeZzoybzpna4nNBT35kYl7BP+q2nPgAwSdrqHsqnVjjO/C0hN
	 WGXOEOkEZ4Hby2SerxyH6fKzkeUTNKUcVPOP4l+W8DCsEY9bLp3AqIa7DDkcaSg7rqnYv
	 d80lBLlFHZwM0yKWdIq7Z9CYGFh4dgVguLJPdJxkCntVol0cMHJJaQ60CjXY4vxy0UIVj
	 OPY9mFWFnLOf3CirjlZcll/Wm62kaSHM+aRXxB//WXEov7jwjvvKsda5EbcPqczolUJ+m
	 uXueC4uGZizLS439KdgbPvwuAkbfn1aRLRvQNCPZOw5GCS8InAZsbSHIchQQru3dA4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792496122;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RJBmlqeNqq7wQsjNbLDrnXpBLrn4LxYdCnqqMvjM4is=;
	b=sv/c8XB6tH+UODd9UsHEr+BBoa5BPJ0mG1YOU9PTdQiRhmZzLyBpljMObBrAQKjIDWnt
	 /EBWrA94Vv5eaaBOJfslzbjwxc8aiM3xXO3w5R5kXY0caEUi/Fq9nn9EiPTbEYW9vXW2/
	 PmjZzNJovpa1F7O9tZgPy5tPaatePPSfixX+EcMBokYDHRewyYmx9GICph9/JnbpLLnUR
	 Ar2PTzDRImLySSLbb3SwHneEzV0qsxw8LJmDY/+p56mzdHGDPmDJ1T0voqx60OW+I0jr9
	 sk/wZ9fAwyt4XXGro/EecE0w1Fw0/JU2PK6WPjUMwNLHsX+X5+zX0ThN/gU1JL921IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UXaRy9TN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68E6606A327;
	Tue, 20 Oct 2026 11:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UXaRy9TN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9741F000C4;
	Tue, 20 Oct 2026 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792496121;
	bh=RJBmlqeNqq7wQsjNbLDrnXpBLrn4LxYdCnqqMvjM4is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UXaRy9TNyzpNTCByKCeVaN1yz6qLxHh04Wvomjojknwv63Il6Z/G4ZAW0FHLMjHic
	 yUcGD8qErXet0nTQlnF6znGsoehqVWpWPvAAws2RKxQCy5gZAvlL+YV6MXCjAcLFeM
	 gO5AeQ4TXI+faBt59mNgQgSlgQsCbYZPNjmkELJ3VXVr2ZYYRms6ngsnP8z1fLEHaY
	 I7aoTr8xg89IEkgMOiPFuCaxnvgtkze+g//H1kdjfZlOtiQAYV+qogHzTlcZg50cpl
	 hwXS439EoDV5x6WrWDgt6fbcsbjfGc5R0yYAdzcagGg9oRrOBRuHtCzt11Oi3arwnN
	 036XGQj17Tw5w==
Date: Tue, 20 Oct 2026 12:35:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, Fuad Tabba <tabba@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Message-ID: <atc2Y4gHwtGlffns@gremlin>
References: <20261020064306.1542865-1-fuad.tabba@linux.dev>
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
In-Reply-To: <20261020064306.1542865-1-fuad.tabba@linux.dev>

On Tue, Oct 20, 2026 at 07:43:06AM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
>
> KVM uses the VM's ID registers as the source of truth for what the
> guest has, but userspace can expose S1PIE or S1POE without the features
> they imply. As per the architecture, both imply TCR2 and ATS1A, and
> S1POE also implies HPDS. With TCR2 hidden, the world switch skips
> PIR_EL1, PIRE0_EL1 and POR_EL1 while KVM doesn't trap them, so the guest
> accesses registers that are neither trapped nor switched. Under VHE,
> that leaks values between guests. On nVHE and hVHE, pKVM included, the
> host kernel resumes with the guest's PIR_EL1 and PIRE0_EL1.
>
> On first run, clear S1PIE and S1POE from the VM's ID registers when the
> features they imply are missing, before anything derives state from
> them. The guest and userspace then see neither feature, and the guest's
> accesses to their registers UNDEF.
>
> Fixes: 70ed7238297fb ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
> Fixes: d4a89e5aee23e ("KVM: arm64: Expose S1PIE to guests")

I guess kernels that are missing 19868b67e3e7 and 2ce80f624032 will need
that stuff ported too?

> Reported-by: Mark Brown <broonie@kernel.org>
> Link: https://lore.kernel.org/r/20260930-arm64-gcs-v21-2-3556644cd927@kernel.org
> Link: https://lore.kernel.org/r/8633u229lq.wl-maz@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks for helping this along Fuad, nice to see all of this come together
:)

So it seems like this is a much nicer solution to the problem overall -
rather than having e.g. kvm_has_s1pie() -> feat_s1pie(), enforce the
dependency by applying res0/1 to the id reg in
kvm_idregs_enforce_dependencies().

And I see that it uses the guaranteed correct ordering from commit 19868b67e3e7
("KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs") also.

Nits below but the logic looks sound to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

For the GCS series, when Mark respins, I'm guessing it'll be something like:

+static bool feat_gcs(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, FEAT_GCS) && feat_s1pie(kvm);
+}

...

+static const struct reg_bits_to_feat_map id_aa64pfr1_el1_feat_map[] = {
+	NEEDS_FEAT(ID_AA64PFR1_EL1_GCS, feat_gcs),
+};

...

+static const DECLARE_IDREG_FEAT_MAP(id_aa64pfr1_el1_desc, ID_AA64PFR1_EL1,
+                                    id_aa64pfr1_el1_feat_map, FEAT_AA64EL1);

(or with my suggestion below, DECLARE_FEAT_MAP())

...

static const struct reg_feat_map_desc *idreg_feat_maps[] = {
	&id_aa64mmfr3_el1_desc,
+	&id_aa64pfr1_el1_desc,
};

Right?

> ---
> Changes in v3:
> - Sanitise the ID registers instead of changing the trap tables, using
>   Marc's patch (Marc, Sashiko)
> - Rebased on kvmarm-7.4
> - Link to v2: https://lore.kernel.org/r/20261018080921.3942517-1-fuad.tabba@linux.dev
>
> Changes in v2:
> - Also require FEAT_HPDS for S1POE (Marc)
> - Link to v1: https://lore.kernel.org/r/20261015153041.3770032-1-fuad.tabba@linux.dev
>
> Based on kvmarm-7.4 (dd0bc00e3e920; also applies to kvmarm/fixes
> 2ea3a929fe01e).
>
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/config.c           | 78 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c         |  2 +
>  3 files changed, 81 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1c6632216e327..695c389047c91 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1741,6 +1741,7 @@ static inline bool kvm_arch_has_irq_bypass(void)
>  	return true;
>  }
>
> +void kvm_idregs_enforce_dependencies(struct kvm *kvm);
>  void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>  struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg);
>  void check_feature_map(void);
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 1053676551aff..d856c0b5c3907 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -59,6 +59,7 @@ struct reg_feat_map_desc {
>  	const struct reg_bits_to_feat_map feat_map;
>  	const struct reg_bits_to_feat_map *bit_feat_map;
>  	const unsigned int		  bit_feat_map_sz;
> +	const unsigned int		  idreg_idx;

This field feels a bit hazardous - 0 is a valid index and now things that
don't declare it are setting a valid value.

That feels like establishing a bit of a footgun for later.

It'd be nice to have something that, when 0, means not present.

Maybe just store the register directly like:

	const u32			reg;

And...

>  };
>
>  #define __NEEDS_FEAT_3(m, f, w, id, fld, lim)		\
> @@ -130,6 +131,21 @@ struct reg_feat_map_desc {
>  		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
>  	}
>
> +/*
> + * Declare the dependency between the features advertised in an id
> + * register, and the set of other features they depend on. This
> + * generates a struct reg_feat_map_desc.
> + */
> +#define DECLARE_IDREG_FEAT_MAP(n, r, m, f)				\
> +	struct reg_feat_map_desc n = {					\
> +		.name			= #r,				\
> +		.feat_map		= NEEDS_FEAT(~(r##_RES0 |	\
> +						       r##_RES1), f),	\
> +		.bit_feat_map		= m,				\
> +		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
> +		.idreg_idx		= IDREG_IDX(SYS_##r),		\
> +	}
> +

...Here you could avoid the duplication and just update DECLARE_FEAT_MAP()
to do:

+		.reg			= SYS_##r,		\

And when you need to check for the feature you can use
is_feature_id_reg(r->reg) [that's static in sys_regs.c and would need to be
exported].


>  #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
>  #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
>  #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
> @@ -205,6 +221,7 @@ struct reg_feat_map_desc {
>  #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
>  #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
>  #define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
> +#define FEAT_HPDS		ID_AA64MMFR1_EL1, HPDS, IMP
>  #define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
>  #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
>  #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
> @@ -280,6 +297,25 @@ static bool feat_anerr(struct kvm *kvm)
>  		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
>  }
>
> +/*
> + * S1PIE and S1POE imply TCR2 and ATS1A, and S1POE also implies HPDS, but
> + * userspace can set them independently.
> + */
> +static bool feat_s1pie(struct kvm *kvm)
> +{
> +	return (kvm_has_feat(kvm, FEAT_S1PIE) &&
> +		kvm_has_feat(kvm, FEAT_TCR2) &&
> +		kvm_has_feat(kvm, FEAT_ATS1A));
> +}
> +
> +static bool feat_s1poe(struct kvm *kvm)
> +{
> +	return (kvm_has_feat(kvm, FEAT_S1POE) &&
> +		kvm_has_feat(kvm, FEAT_TCR2) &&
> +		kvm_has_feat(kvm, FEAT_ATS1A) &&
> +		kvm_has_feat(kvm, FEAT_HPDS));
> +}
> +

Kinda neat to have a super-readable, clear definition of the dependencies
here like this :)

>  static bool feat_sme_smps(struct kvm *kvm)
>  {
>  	/*
> @@ -1299,6 +1335,14 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
>  static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
>  			      vtcr_el2_feat_map, FEAT_AA64EL2);
>
> +static const struct reg_bits_to_feat_map id_aa64mmfr3_el1_feat_map[] = {
> +	NEEDS_FEAT(ID_AA64MMFR3_EL1_S1PIE, feat_s1pie),
> +	NEEDS_FEAT(ID_AA64MMFR3_EL1_S1POE, feat_s1poe),
> +};
> +
> +static const DECLARE_IDREG_FEAT_MAP(id_aa64mmfr3_el1_desc, ID_AA64MMFR3_EL1,
> +				    id_aa64mmfr3_el1_feat_map, FEAT_AA64EL1);
> +
>  static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] = {
>  	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
>  		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
> @@ -1408,6 +1452,40 @@ void __init check_feature_map(void)
>  	check_reg_desc(&ich_hfgitr_desc);
>  }
>
> +static const struct reg_feat_map_desc *idreg_feat_maps[] = {
> +	&id_aa64mmfr3_el1_desc,
> +};
> +
> +static bool idreg_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)

To me this reads confusingly - idreg_apply_deps() would be clearer I think.

> +{
> +	struct resx resx = {};
> +	u64 val;
> +
> +	for (int i = 0; i < r->bit_feat_map_sz; i++) {
> +		if ((r->bit_feat_map[i].flags & CALL_FUNC) &&

What if it isn't a CALL_FUNC feature?

Could this loop just be replaced with compute_resx_bits()?

> +		    !r->bit_feat_map[i].match(kvm))
> +			resx.res0 |= reg_feat_map_bits(&r->bit_feat_map[i]);

OK, neat, this e.g. invokes feat_s1pie, feat_s1poe for aa64mmfr3_el1.


> +	}
> +
> +	val = kvm->arch.id_regs[r->idreg_idx];
> +	kvm->arch.id_regs[r->idreg_idx] &= ~resx.res0;
> +	kvm->arch.id_regs[r->idreg_idx] |= resx.res1;

I see from the previous review that res1 is for future proofing, but
redundant (but harmless) atm.

> +
> +	return val != kvm->arch.id_regs[r->idreg_idx];
> +}
> +
> +void kvm_idregs_enforce_dependencies(struct kvm *kvm)
> +{
> +	bool again;
> +
> +	do {
> +		again = false;
> +
> +		for (int i = 0; i < ARRAY_SIZE(idreg_feat_maps); i++)
> +			again |= idreg_deps(kvm, idreg_feat_maps[i]);
> +	} while (again);

This is pretty confusing at first glance, so - iterate through all
idreg_feat_maps, if any changes happened, then loop again.

Could it be e.g.:

static bool idreg_apply_all_deps(struct kvm *kvm)
{
	bool changed = false;

	for (int i = 0; i < ARRAY_SIZE(idreg_feat_maps); i++)
		changed |= idreg_apply_deps(kvm, idreg_feat_maps[i]);
	return changed;
}

void kvm_idregs_enforce_dependencies(struct kvm *kvm)
{
	/* Propagate chained dependencies. */
	while (idreg_apply_all_deps(kvm))
		;
}

> +}
> +
>  static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
>  {
>  	u64 regval = kvm->arch.id_regs[map->regidx];
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e9cf6cc340349..f10905347f3a1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5872,6 +5872,8 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
>  	if (kvm_id_regs_final(kvm))
>  		return 0;
>
> +	kvm_idregs_enforce_dependencies(kvm);
> +
>  	/*
>  	 * This hacks into the ID registers, so only perform it when the
>  	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
>
> base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
> --
> 2.47.3
>

--
Cheers, Lorenzo
