Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF4B3148A8
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770807939; cv=none; b=l0nVocELITxCk+7x4+K1GjyGj1TGTt+IF+x4UG7in1LTRhd7vx/zh2LCYmRz6XOFc+xEdCaarZ2EkN/gPP/Aq7tO4ZzdZDI4VDnoTxQWHZF2grP+Kh0DfNfbGS4xSR36IfDrI3rx1cEremrZNnKh6/nhQJCaGA0PdJFG15zbW2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770807939; c=relaxed/simple;
	bh=UiqOSzEdC2LWX2Wl2Prc5W84aWbEMjHQQ3ulcmBk0e8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=os3wdjIRLSkklcG6AmQPzCM8Z5u003S1t15mZrefWgTBc3SJDyJitDcxr6qAqY4T5wNmEDynPP6Ru3EPR3GmooXtAll2jVCrhwHmOXYgCfQV9KGRNxIUZ6xRTc02ekbGnWh9q9bejATEOVw1uv6azNC1xFhJ9LNTLC+WZZ5YaZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EF62339;
	Wed, 11 Feb 2026 03:05:31 -0800 (PST)
Received: from e134344.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D7573F740;
	Wed, 11 Feb 2026 03:05:32 -0800 (PST)
Date: Wed, 11 Feb 2026 11:05:29 +0000
From: Ben Horgan <ben.horgan@arm.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, rohit.mathew@arm.com,
	scott@os.amperecomputing.com, sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com,
	catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	zengheng4@huawei.com, linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: Re: [PATCH v4 15/41] arm_mpam: resctrl: Pick the caches we will use
 as resctrl resources
Message-ID: <aYxieS3Pycm5UthH@e134344.arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-16-ben.horgan@arm.com>
 <c8d53e59-5661-4ac2-bc8f-0661cde59967@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8d53e59-5661-4ac2-bc8f-0661cde59967@intel.com>

Hi Reinette,

On Tue, Feb 10, 2026 at 03:39:51PM -0800, Reinette Chatre wrote:
> Hi Ben,
> 
> On 2/3/26 1:43 PM, Ben Horgan wrote:
> ...
> > +
> >  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
> >  {
> > -	/* TODO: initialise the resctrl resources */
> > +	struct mpam_class *class = res->class;
> > +	struct rdt_resource *r = &res->resctrl_res;
> > +
> > +	switch (r->rid) {
> > +	case RDT_RESOURCE_L2:
> > +	case RDT_RESOURCE_L3:
> > +		r->alloc_capable = true;
> > +		r->schema_fmt = RESCTRL_SCHEMA_BITMAP;
> > +		r->cache.arch_has_sparse_bitmasks = true;
> > +
> > +		r->cache.cbm_len = class->props.cpbm_wd;
> > +		/* mpam_devices will reject empty bitmaps */
> > +		r->cache.min_cbm_bits = 1;
> > +
> > +		if (r->rid == RDT_RESOURCE_L2) {
> > +			r->name = "L2";
> 
> This code is fine but highlights that resctrl fs should not let the
> arch need to do this since this name is used as part of user interface.

Yes, not ideal but I don't think it's urgent to tidy this up.

> 
> > +			r->ctrl_scope = RESCTRL_L2_CACHE;
> > +		} else {
> > +			r->name = "L3";
> > +			r->ctrl_scope = RESCTRL_L3_CACHE;
> > +		}
> > +
> > +		/*
> > +		 * Which bits are shared with other ...things...
> > +		 * Unknown devices use partid-0 which uses all the bitmap
> > +		 * fields. Until we configured the SMMU and GIC not to do this
> > +		 * 'all the bits' is the correct answer here.
> > +		 */
> > +		r->cache.shareable_bits = resctrl_get_default_ctrl(r);
> 
> I would like to recommend one style change to set r->alloc_capable as the final
> setting. This is the setting that informs resctrl fs that this resource needs
> attention. The reason I recommend this to be done last is if/when a future
> change adds some configuration here that may fail then it should not fail with
> r->alloc_capable as true while partially initialized.

Makes sense. This will make the code more robust.

> 
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> >  
> >  	return 0;
> >  }
> > @@ -324,7 +409,8 @@ int mpam_resctrl_setup(void)
> >  		res->resctrl_res.rid = rid;
> >  	}
> >  
> > -	/* TODO: pick MPAM classes to map to resctrl resources */
> > +	/* Find some classes to use for controls */
> > +	mpam_resctrl_pick_caches();
> >  
> >  	/* Initialise the resctrl structures from the classes */
> >  	for_each_mpam_resctrl_control(res, rid) {
> 
> Reinette

Thanks,

Ben
