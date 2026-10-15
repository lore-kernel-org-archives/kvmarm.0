Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CCC3D3334;
	Thu, 15 Oct 2026 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077155; cv=none; b=g6ifBimThlOIw0SVlv9Jg1mb+haH24x11EfeHTA4zi6V1i196+6bIcbIKoOnOx9e6bwb7fC8g9EVp9CLDEXHwLyQc0sLN/E8jvJuLXDBTPZUtCbuOYAxMGTlEV4hCgV6za5Ck8rrhuU5AxGAMuH+gGZV8iRt5VmsvN3bHyMCusE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077155; c=relaxed/simple;
	bh=iRqFUSfucGkRKagxk4DNzWp4TjCjOWGnYfw0KuL7EVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6Wsf8huVlJt/W4Wg4AugUwPGStQZ2+lHl6NQTmXYYXnbh6I935AwCUWgWxEpF0fKyqgJJwI3pMOA0LnQTcxn7abZQUMg/7CH+vZz10/4lENA/YcGs8VdobqEj7sAwCLqIKKjkjV/ArRYGTYrVKQv4nFNQgAxjO13ZK/wc06pns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdfkOMDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdfkOMDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BEE1F000C4;
	Thu, 15 Oct 2026 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077154;
	bh=pDysuJEmkn56+CM/E4w11SG7z498s3kgZNwLNIegyhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mdfkOMDJ373ZTRSsel6xAqKp56bgKqPc74+HCWaRsr/BXshNIg0+BI0N5ct5cSy4f
	 EYfiY1qumnhTtQrTKSyZ0UBEzfv7OPUy9cdZlhoioRbvqh3UUdomLdb3Jr//K5EMAP
	 4BKZW4/rrP0Je1eeMmflj4iCl0P0LsmnrbLU/1URiXeEgStp6tXlfOSANV3Qd9LhAY
	 nTP7Vq7SFkn3okOzi4t1+PAJnMD8DhJCgHXXm8SoMzKpoHJrQK2cbay9/z4vLlbUZM
	 3wjeqTan05GLzTkPEYGDSdhg3gHFzhFXvu3Q+hStVmineVko+EbmVyvoUpc3YoVwKp
	 ZopVDUvC6lKLw==
Date: Thu, 15 Oct 2026 16:12:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 05/28] perf: arm_spe_pmu: Add PMBIDR_EL1 and
 PMSIDR_EL1 to struct arm_spe_pmu
Message-ID: <atDmDRSNDllpJtmL@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-6-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-6-alexandru.elisei@arm.com>

I think probably some kind of commit message would be good even for a
trivial change :)

On Thu, Sep 03, 2026 at 05:06:00PM +0100, Alexandru Elisei wrote:
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  drivers/perf/arm_spe_pmu.c       | 3 +++
>  include/linux/perf/arm_spe_pmu.h | 2 ++
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index 79c571a649d5..42ba0924bd02 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -1095,6 +1095,7 @@ static void __arm_spe_pmu_dev_probe(void *info)
>  			"profiling buffer owned by higher exception level\n");
>  		return;
>  	}
> +	spe_pmu->pmbidr_el1 = reg;

This doesn't seem to be used anywhere in the series?

>
>  	/* Minimum alignment. If it's out-of-range, then fail the probe */
>  	fld = FIELD_GET(PMBIDR_EL1_ALIGN, reg);
> @@ -1107,6 +1108,8 @@ static void __arm_spe_pmu_dev_probe(void *info)
>
>  	/* It's now safe to read PMSIDR and figure out what we've got */
>  	reg = read_sysreg_s(SYS_PMSIDR_EL1);
> +	spe_pmu->pmsidr_el1 = reg;
> +
>  	if (FIELD_GET(PMSIDR_EL1_FE, reg))
>  		spe_pmu->features |= SPE_PMU_FEAT_FILT_EVT;
>
> diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> index af86fd184050..97b14e236fcd 100644
> --- a/include/linux/perf/arm_spe_pmu.h
> +++ b/include/linux/perf/arm_spe_pmu.h
> @@ -21,6 +21,8 @@ struct arm_spe_pmu {
>  	cpumask_t				supported_cpus;
>  	struct hlist_node			hotplug_node;
>
> +	u64					pmbidr_el1;

Equally, this doesn't seem to be used anywhere in the series, maybe drop?

> +	u64					pmsidr_el1;

This field is used in kvm_spe_has_feat_spe_fds() and
kvm_spe_has_feat_spe_fne():

bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
{
	...
	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
}

bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
{
	...
	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
}

So checking for FDS and FnE, but these are available as feature flags as
__arm_spe_pmu_dev_probe() gets these:

static void __arm_spe_pmu_dev_probe(void *info)
{
	...
	if (FIELD_GET(PMSIDR_EL1_FnE, reg))
		spe_pmu->features |= SPE_PMU_FEAT_INV_FILT_EVT;
	...
	if (FIELD_GET(PMSIDR_EL1_FDS, reg))
		spe_pmu->features |= SPE_PMU_FEAT_FDS;
	...
}

And then kvm_spe_has_feat_spe_fds() and kvm_spe_has_feat_spe_fne() can be:

bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
{
	...
	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
	       (spe_pmu->features & SPE_PMU_FEAT_FDS);
}

bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
{
	...
	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
	       (spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT);
}

Right?

So it seems you could drop this patch from the series in general? Is there
another reason to get these fields?

Also - there seems to be a divergence in the naming there between FnE and
INV_FILT_EVT, is that intentional?

--
Cheers, Lorenzo
