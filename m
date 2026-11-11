Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794417664;
	b=TmvCBDvsdrg/QnFQRIR+7/4Tpou36NYxIbtrxbTklvvJN/wnAAEMb3HUKbtHoMkY3QRf
	 ZpTsem1hQnrlL0dJaJykfyx36+bKcUjJJzSxElMHA4nRC5/e42rbSXdIhM88fXJegEfWG
	 tg+UFe8CzVAODe2s3t3YopvqS63lu6iBG7uZsaMY+Q8GXqrhXFtcHfSy5flG38NWRHUSm
	 fpQ4xsIgM50GtrAR/ZAiplJ/6QZVF1XHv6FEVGqsIKFArxQCrWPwdytbC77hFqUlbBQN+
	 eHpkCwD7qkfNPCxkYyqUx3EnoBzIl5DAbOfYV3DoX7PbokiuyYsMYqNXNYuREf7KXwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794417664;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=oHVW7jNgTo/7nIb4CmqK42I4MtbBzqJmNU5KyxcTUvE=;
	b=uH+/z7eAB8TKjIt3tocg4upV+3n/lmh5areirkoD/vdVDWE/Wfd05vvzvrrjXj5QhM9R
	 tnxn+1xw/KqoBMkmnGMM/Un7kHdUrMih10FqxzbWj4we+08qyas+9h/sA+H5zYx+mmz+1
	 mD8VzcSb+CMgck3dXYr2d76wliiUWASWqqJjywLNHoYeIa1RhgP2wR5JZ7IVrk5LhNZVU
	 qaSbz0bbsBF5oO2crOr5vyKKe/3nig5sQzX8bF5IaunYSJr+m056DjZa6xLXDjhqeU/iV
	 iW6SSxQo4VJjMNSrp7kdBN9+mVwXhpklPI+hwYCHfpmlBDgVd0sMFz/b9y8DrHUsyng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z3NEcnpz;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F58606A324
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 17:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68F58606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z3NEcnpz
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDC441576;
	Wed, 11 Nov 2026 09:21:00 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87BAC3F632;
	Wed, 11 Nov 2026 09:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794417663; bh=Rf4ebtvltCctbkDc/Gv4WhpuRQ5MW6jqs73z5jo5cb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3NEcnpzN+rb8IhiTNoLslEyKdoUWksMEpnQHcWQAB7rr/bq5YHO2aUh9LZBJb9kZ
	 NVJ4FctJSnEOQvL9bv8EUE5im5n3NvHjBD2tLY/0pcjk8MmodxdQ9Z4LUMN0lfvE87
	 XlML061p/+aCR23TsCURNUlK6CPGFo+EFvOdFTcc=
Date: Wed, 11 Nov 2026 17:20:08 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 05/28] perf: arm_spe_pmu: Add PMBIDR_EL1 and
 PMSIDR_EL1 to struct arm_spe_pmu
Message-ID: <avSjyLhFsYjI7tG_@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-6-alexandru.elisei@arm.com>
 <atDmDRSNDllpJtmL@gremlin>
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
In-Reply-To: <atDmDRSNDllpJtmL@gremlin>

Hi,

On Thu, Oct 15, 2026 at 04:12:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> I think probably some kind of commit message would be good even for a
> trivial change :)

Of course, I'll add something here.

> 
> On Thu, Sep 03, 2026 at 05:06:00PM +0100, Alexandru Elisei wrote:
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  drivers/perf/arm_spe_pmu.c       | 3 +++
> >  include/linux/perf/arm_spe_pmu.h | 2 ++
> >  2 files changed, 5 insertions(+)
> >
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index 79c571a649d5..42ba0924bd02 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -1095,6 +1095,7 @@ static void __arm_spe_pmu_dev_probe(void *info)
> >  			"profiling buffer owned by higher exception level\n");
> >  		return;
> >  	}
> > +	spe_pmu->pmbidr_el1 = reg;
> 
> This doesn't seem to be used anywhere in the series?

Indeed, that's a leftover from the previous iterations, will remove.

> 
> >
> >  	/* Minimum alignment. If it's out-of-range, then fail the probe */
> >  	fld = FIELD_GET(PMBIDR_EL1_ALIGN, reg);
> > @@ -1107,6 +1108,8 @@ static void __arm_spe_pmu_dev_probe(void *info)
> >
> >  	/* It's now safe to read PMSIDR and figure out what we've got */
> >  	reg = read_sysreg_s(SYS_PMSIDR_EL1);
> > +	spe_pmu->pmsidr_el1 = reg;
> > +
> >  	if (FIELD_GET(PMSIDR_EL1_FE, reg))
> >  		spe_pmu->features |= SPE_PMU_FEAT_FILT_EVT;
> >
> > diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> > index af86fd184050..97b14e236fcd 100644
> > --- a/include/linux/perf/arm_spe_pmu.h
> > +++ b/include/linux/perf/arm_spe_pmu.h
> > @@ -21,6 +21,8 @@ struct arm_spe_pmu {
> >  	cpumask_t				supported_cpus;
> >  	struct hlist_node			hotplug_node;
> >
> > +	u64					pmbidr_el1;
> 
> Equally, this doesn't seem to be used anywhere in the series, maybe drop?

Fixed.

> 
> > +	u64					pmsidr_el1;
> 
> This field is used in kvm_spe_has_feat_spe_fds() and
> kvm_spe_has_feat_spe_fne():
> 
> bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> {
> 	...
> 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
> 	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
> }
> 
> bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> {
> 	...
> 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
> 	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
> }
> 
> So checking for FDS and FnE, but these are available as feature flags as
> __arm_spe_pmu_dev_probe() gets these:
> 
> static void __arm_spe_pmu_dev_probe(void *info)
> {
> 	...
> 	if (FIELD_GET(PMSIDR_EL1_FnE, reg))
> 		spe_pmu->features |= SPE_PMU_FEAT_INV_FILT_EVT;
> 	...
> 	if (FIELD_GET(PMSIDR_EL1_FDS, reg))
> 		spe_pmu->features |= SPE_PMU_FEAT_FDS;
> 	...
> }
> 
> And then kvm_spe_has_feat_spe_fds() and kvm_spe_has_feat_spe_fne() can be:
> 
> bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> {
> 	...
> 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
> 	       (spe_pmu->features & SPE_PMU_FEAT_FDS);
> }
> 
> bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> {
> 	...
> 	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
> 	       (spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT);
> }
> 
> Right?

In this use case they are functionally the same, yes, but conceptually, they are
not the same thing. spe_pmu->features advertises the features that the SPE
*driver* supports, PMSIDR_EL1 advertises the features that the *hardware*
implements. The two are not always equal.  For example, KVM added handling for
the PMSNEVFR_EL1 register (added by FEAT_SPE_FnE), a few years before the SPE
driver supported FEAT_SPE_FnE.

I can see KVM, in the future, having to virtualize hardware features not
supported by the host driver yet, so unless you have a strong objection, I would
rather keep the use of the architectural register instead of relying on the
driver.

> 
> So it seems you could drop this patch from the series in general? Is there
> another reason to get these fields?
> 
> Also - there seems to be a divergence in the naming there between FnE and
> INV_FILT_EVT, is that intentional?

I think that's a question for the person who added FEAT_PMU_FEAT_INV_FILT_EVT?

Thanks,
Alex
