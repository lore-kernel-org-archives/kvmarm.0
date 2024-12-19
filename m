Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D97B1AAA1E
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630067; cv=none; b=Y3Jbfjx83Ive7Jy07J2ZAxkpyO1347v5gdQQlbYxFLdYm+KsbUv30n3rGnL5CjU/Zwl/rdv4QbR74GyQox6pkF+poqTUAJpsOqtSMGZiLnUXJz0U1It60m47S2b36r6FcTLA3Y1D7et3XyQsKVc4FIXvfTiWKzLerUF+F+YXasE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630067; c=relaxed/simple;
	bh=z4Q8LqFQ9o1skB19rS85cq1o0gK6Wcg1aH/EgjVunnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEK7e8h/QfTF39Gs9a6P/OCcP2gVbFW4yYK69ptJuF6Z0fedGhsMiT785y4jRkYuLN8n7NUqw4a0ZceMYC3vdbtekfyMsrWBLYG6yQsqkq9Kb9DVQ2T1wmPBw9tsM44VaD04E2JWFqG/GkhwlEUPEvBBcmZ8sgYwbWPH1TjWzQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CBC5IMOS; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CBC5IMOS"
Date: Thu, 19 Dec 2024 09:40:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734630061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4aUMHeWdz3qOQc6NRpiZJgtPcwp/msy8ymDOze/Kr4=;
	b=CBC5IMOSOP6jyWg7+IaJE4Bo3tcuuiYebKBs3pYyUfTLGulDNGTttMQEoWqDTsXpOfca5H
	TKxuRo9Czc20Jni0GFNeYHE9kQeCtpGh65SYKVXsaaVv9/Y+Kr+AHNOpNMj8jutdjG7YrS
	axurksZFAM3wv7Kh6qWKDI0t7NF/0sg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
	sebott@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	jiangkunkun@huawei.com, jonathan.cameron@huawei.com,
	anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com
Subject: Re: [PATCH v4 3/3] arm64: paravirt: Enable errata based on
 implementation CPUs
Message-ID: <Z2RapzikZQGgeE_6@linux.dev>
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
 <20241218105345.73472-4-shameerali.kolothum.thodi@huawei.com>
 <86bjx8q995.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjx8q995.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 19, 2024 at 10:04:22AM +0000, Marc Zyngier wrote:
> > +void  __init pv_target_impl_cpu_init(void)
> > +{
> > +	struct arm_smccc_res res;
> > +	int index = 0, max_idx = -1;
> > +
> > +	/* Check we have already set targets */
> > +	if (target_impl_cpu_num)
> > +		return;
> > +
> > +	do {
> > +		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID,
> > +				     index, &res);
> > +		if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> > +			return;
> 
> Can't you probe for this as part of the KVM guest services?

+1, this needs to be predicated on actually detecting the hypervisor as
KVM.

> > +
> > +		if (max_idx < 0) {
> > +			/* res.a0 should have a valid maximum CPU implementation index */
> > +			if (res.a0 >= MAX_TARGET_IMPL_CPUS)
> > +				return;
> > +			max_idx = res.a0;
> > +		}
> > +
> > +		target_impl_cpus[index].midr = res.a1;
> > +		target_impl_cpus[index].revidr = res.a2;
> > +		index++;
> > +	} while (index <= max_idx);
> > +
> > +	target_impl_cpu_num = index;
> > +	pr_info("Number of target implementation CPUs is %d\n", target_impl_cpu_num);
> > +}
> > +
> >  int __init pv_time_init(void)
> >  {
> >  	int ret;
> 
> Independent of this, I wonder what we should output in sysfs
> (/sys/devices/system/cpu/cpu*/regs/identification/*).

It's a bit crap, but maybe implementation index 0 gets reported through
the 'main' midr/revidr files, otherwise have a directory per
implementation index of midr/revidr.

-- 
Thanks,
Oliver
