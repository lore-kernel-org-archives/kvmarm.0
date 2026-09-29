Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B1650B436;
	Tue, 29 Sep 2026 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790679703; cv=none; b=sTKKt2tqRd6FCHaoIFf4RpMlhFY65eazKN3Ts9jL6WHSSLtUd6WJHEuPX4U/aMF8XOzK9+B2pByDSWoTR6JD7QGj2HYx6KVN88jgHNHGjTEsKBYnRTN4t/m6o599xsQv+oI47ia/HA0B9ZPlZDtMDG4n7RjpFMoKKltrGXeMhpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790679703; c=relaxed/simple;
	bh=Rpzw0ZWBwUreMmYoy4UjzmcXitYDynavT/IpC3eZEb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3YvTh6UvKc/zFku2KpD9f4cKf0DiAOCpQnHJ20Nf2ZGlvBvYiohRE7VfUoQ4PcLxUppg5XiPnqxkZUXNY5zFhoZkeFITth8t4XdBTXEuaMtUbY7ZKgkyOHRA7uRS6cXjPeAeYS22BLPKUQnpw9+hEO7DX4+5V2tCOWFseot7qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BPltN72V; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BPltN72V"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC2AA1476;
	Tue, 29 Sep 2026 04:01:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99FBA3F86F;
	Tue, 29 Sep 2026 04:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790679695; bh=Rpzw0ZWBwUreMmYoy4UjzmcXitYDynavT/IpC3eZEb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BPltN72Vlfh8ep8ZYrPiJ25xeFhxXn1AjH+dSMLOj2OQWnFkXSQkcKPPsdCdatRu9
	 fvtPj88NOaLO3mxAkQBwC+LFg1+eZzWuHx4/KB8SNtSLgyjB8pniVvIKJaQeZiDZME
	 A62mmIRSEfeBwwvYrzqWTYIVPGYqnm40zrR8w1dE=
Date: Tue, 29 Sep 2026 12:01:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Message-ID: <aruaeLI76_kcvIhp@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-7-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924135201.850038-7-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 02:52:00PM +0100, Suzuki K Poulose wrote:
> +/*
> + * Make sure the area is tracked by RMM at FINE granularity.
> + * We do not support changing the tracking yet.
> + */
> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> +{
> +	while (start < end) {
> +		unsigned long ret, category, state, next;
> +
> +		ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
> +		if (ret != RMI_SUCCESS)
> +			return -ENOMEM;
> +
> +		if (WARN_ON(next <= start))
> +			return -ENXIO;
> +
> +		if (state != RMI_TRACKING_FINE ||
> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> +			/* TODO: Set granule tracking in this case */
> +			pr_err("Granule tracking for region isn't fine/conventional: %llx-%lx\n",
> +			       start, next);
> +			return -ENODEV;
> +		}
> +		start = next;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * rmi_gpt_info - Query the GPT info for the given PAR.
> + * @start: Base of the physical address region
> + * @end: Top of the physical address region
> + * @out_top: Top of the physical address region for which
> + *		the GPT @out_gpt_par_state is valid
> + * @out_gpt_par_state: State of the GPT covered by [start, out_top)
> + */
> +static long rmi_gpt_info(unsigned long start, unsigned long end,
> +			 unsigned long *out_top,
> +			 unsigned long *out_gpt_par_state)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_GPT_INFO, start, end,
> +	};
> +
> +	rmi_smccc_invoke(&regs);
> +	if (regs.a0 != RMI_SUCCESS)
> +		return regs.a0;
> +
> +	if (out_top)
> +		*out_top = regs.a1;
> +	if (out_gpt_par_state)
> +		*out_gpt_par_state = regs.a2;
> +
> +	return RMI_SUCCESS;
> +}
> +
> +/*
> + * We do not support creating L1 GPTs yet. So, make sure that
> + * all the regions are managed by the firmware.
> + */
> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
> +{
> +	unsigned long l0gpt_sz;
> +	unsigned long next, par_state;
> +
> +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +					  rmi_feat_reg(1)));
> +	start = ALIGN_DOWN(start, l0gpt_sz);
> +	end = ALIGN(end, l0gpt_sz);
> +
> +	while (start < end) {
> +		long ret = rmi_gpt_info(start, end, &next, &par_state);
> +
> +		if (ret != RMI_SUCCESS)
> +			return -ENOMEM;

Nit: what does -ENOMEM actually mean here? Was there any allocation?
Maybe -ENXIO is better suited, as the one below. Also, is it useful to
print something like we do further down?

Same comment for rmi_verify_memory_tracking().

> +		if (WARN_ON(next <= start))
> +			return -ENXIO;
> +
> +		if (par_state != RMI_GPT_PAR_PLAT) {
> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
> +				start, next);
> +			return -ENOMEM;

Nit: in v18, Gavin suggested returning -ENODEV here (the hunk he
proposed). I think it makes more sense and it matches the -ENODEV in
rmi_verify_memory_tracking().

-- 
Catalin
