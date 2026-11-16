Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794851794;
	b=BZ+yC2GBddWsa0WfaV186M+Hzg5X4zylNQ3hftjQa9nThkhc4GAJPUJ1/1GGTWjmtkKg
	 PFmNhkGipSwUl7fgxmq1dLdzqDrMl69JW/ekTn3Q4TbiJWLBE4YecSTJXXTRz6IaxFQ7I
	 Gy8QU9ov5Fu65t+m2YId9nlnPRK2hjv1s7jBGoWY5A4ocfeIHL0D9PGwMmspjJnlAiwaZ
	 8TXdLpPJjkCenvuGAneSSuzJYa0CzupeMrxNI8gpCU8XKX5uDcoxugF1simnPoGwXiee6
	 Qe8q7zYPUO0antp3J+y7t4C0UWlkPXSgkvvCLu+VIpbHubIevNztMig5tM/BR226/1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794851794;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fwWQDlnnSTNyph3hgjd/jHBsSgprm3l/XThcAnorVzc=;
	b=1C/i1uxm0hV2HJTqwX7xAhQPG1Yz21+TK8BQkbWSNpE/Qh++F0FiFY/j028ti4qTgQHt
	 t+8MB+XL6VULS+18O0/BArcJBinHMjUP5itHv/+WQVAKUFrKr1d8TjZlngU1jKF6OSVHl
	 XG7FGrSw+DRiweGwcBsGUFE2Y1hb9GhYCn6J6depg9WKoq8Aommz2s9/zrKDUXCoYEdNt
	 M/D4GHbXXrk5/dSqc9tH5E5Vla+WZWmwB3mkmhh2TWrUbvtInbuDivj7ufCfdFcogPhV3
	 tgT3lL0mkWjX0oAayenJzfPjLbayALqVxvsGqIXZq7MBvMKD6pKvhQu8+U8MkD7ek/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZPmjOCmj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6C606A89D;
	Mon, 16 Nov 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZPmjOCmj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090D91F000C4;
	Mon, 16 Nov 2026 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794851794;
	bh=fwWQDlnnSTNyph3hgjd/jHBsSgprm3l/XThcAnorVzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZPmjOCmjno9nExForLkbzUF13rzZndhUhxLFyhcs6ndrKiOfrHZB3452l8ISZGQ7a
	 iYsimyIzyefhY/oc0K0Vfemi/N6TEn8rXGyOpQ0gU73R0/NFoYDoxdzp0d4aDmcgYx
	 PbYsURnlZMIsvqEfHzK8OzalcWBjck31xbND7wq53aERpH9jocyLE9toVILdqk7A8S
	 PhulloZRXZGRVjWl41g3MI9mo4O1mXL6sKIAi3Tnw6BpI+V+iQmyzXVQ3AObWBs6Gj
	 t5ib62RErvLafzsMEoDgEXi6TaWuiDqATzZpnK6iI8setbIO4LkG3gE84ueLqrLBDP
	 sY89CO5r1y05g==
Date: Mon, 16 Nov 2026 17:56:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 05/28] perf: arm_spe_pmu: Add PMBIDR_EL1 and
 PMSIDR_EL1 to struct arm_spe_pmu
Message-ID: <avtDK5rtD38jnhqR@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-6-alexandru.elisei@arm.com>
 <atDmDRSNDllpJtmL@gremlin>
 <avSjyLhFsYjI7tG_@raptor>
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
In-Reply-To: <avSjyLhFsYjI7tG_@raptor>

On Wed, Nov 11, 2026 at 05:20:08PM +0000, Alexandru Elisei wrote:
> Hi,
>
> On Thu, Oct 15, 2026 at 04:12:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> > I think probably some kind of commit message would be good even for a
> > trivial change :)
>
> Of course, I'll add something here.
>
> >
> > On Thu, Sep 03, 2026 at 05:06:00PM +0100, Alexandru Elisei wrote:
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  drivers/perf/arm_spe_pmu.c       | 3 +++
> > >  include/linux/perf/arm_spe_pmu.h | 2 ++
> > >  2 files changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > > index 79c571a649d5..42ba0924bd02 100644
> > > --- a/drivers/perf/arm_spe_pmu.c
> > > +++ b/drivers/perf/arm_spe_pmu.c
> > > @@ -1095,6 +1095,7 @@ static void __arm_spe_pmu_dev_probe(void *info)
> > >  			"profiling buffer owned by higher exception level\n");
> > >  		return;
> > >  	}
> > > +	spe_pmu->pmbidr_el1 = reg;
> >
> > This doesn't seem to be used anywhere in the series?
>
> Indeed, that's a leftover from the previous iterations, will remove.
>
> >
> > >
> > >  	/* Minimum alignment. If it's out-of-range, then fail the probe */
> > >  	fld = FIELD_GET(PMBIDR_EL1_ALIGN, reg);
> > > @@ -1107,6 +1108,8 @@ static void __arm_spe_pmu_dev_probe(void *info)
> > >
> > >  	/* It's now safe to read PMSIDR and figure out what we've got */
> > >  	reg = read_sysreg_s(SYS_PMSIDR_EL1);
> > > +	spe_pmu->pmsidr_el1 = reg;
> > > +
> > >  	if (FIELD_GET(PMSIDR_EL1_FE, reg))
> > >  		spe_pmu->features |= SPE_PMU_FEAT_FILT_EVT;
> > >
> > > diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> > > index af86fd184050..97b14e236fcd 100644
> > > --- a/include/linux/perf/arm_spe_pmu.h
> > > +++ b/include/linux/perf/arm_spe_pmu.h
> > > @@ -21,6 +21,8 @@ struct arm_spe_pmu {
> > >  	cpumask_t				supported_cpus;
> > >  	struct hlist_node			hotplug_node;
> > >
> > > +	u64					pmbidr_el1;
> >
> > Equally, this doesn't seem to be used anywhere in the series, maybe drop?
>
> Fixed.
>
> >
> > > +	u64					pmsidr_el1;
> >
> > This field is used in kvm_spe_has_feat_spe_fds() and
> > kvm_spe_has_feat_spe_fne():
> >
> > bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> > {
> > 	...
> > 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
> > 	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
> > }
> >
> > bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> > {
> > 	...
> > 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
> > 	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
> > }
> >
> > So checking for FDS and FnE, but these are available as feature flags as
> > __arm_spe_pmu_dev_probe() gets these:
> >
> > static void __arm_spe_pmu_dev_probe(void *info)
> > {
> > 	...
> > 	if (FIELD_GET(PMSIDR_EL1_FnE, reg))
> > 		spe_pmu->features |= SPE_PMU_FEAT_INV_FILT_EVT;
> > 	...
> > 	if (FIELD_GET(PMSIDR_EL1_FDS, reg))
> > 		spe_pmu->features |= SPE_PMU_FEAT_FDS;
> > 	...
> > }
> >
> > And then kvm_spe_has_feat_spe_fds() and kvm_spe_has_feat_spe_fne() can be:
> >
> > bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> > {
> > 	...
> > 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
> > 	       (spe_pmu->features & SPE_PMU_FEAT_FDS);
> > }
> >
> > bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> > {
> > 	...
> > 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
> > 	       (spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT);
> > }
> >
> > Right?
>
> In this use case they are functionally the same, yes, but conceptually, they are
> not the same thing. spe_pmu->features advertises the features that the SPE
> *driver* supports, PMSIDR_EL1 advertises the features that the *hardware*
> implements. The two are not always equal.  For example, KVM added handling for
> the PMSNEVFR_EL1 register (added by FEAT_SPE_FnE), a few years before the SPE
> driver supported FEAT_SPE_FnE.
>
> I can see KVM, in the future, having to virtualize hardware features not
> supported by the host driver yet, so unless you have a strong objection, I would
> rather keep the use of the architectural register instead of relying on the
> driver.

Ack OK, sounds sensible, no strong objection but could you add a sentence to the
commit msg about that? Thanks! :)

>
> >
> > So it seems you could drop this patch from the series in general? Is there
> > another reason to get these fields?
> >
> > Also - there seems to be a divergence in the naming there between FnE and
> > INV_FILT_EVT, is that intentional?
>
> I think that's a question for the person who added FEAT_PMU_FEAT_INV_FILT_EVT?

Haha true I suppose so.

>
> Thanks,
> Alex

--
Cheers, Lorenzo
