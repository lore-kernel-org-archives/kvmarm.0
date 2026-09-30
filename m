Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE174D1781;
	Wed, 30 Sep 2026 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774123; cv=none; b=KxYEwPbxqYQ1/9safyKch60ZQV7hZbestxiZWNQ7sBSchSzp9ksOgINRFfvYcuMBm4vNsX+nj9HpW0zHyDF8elyhZ+FXOnQA/1t5tKLcoqyGHs6QmeZSIrTz3c4gs5m+ciFlR/LGA8y/BcS/f5R4rjFVWVY3fbY9TuQRsDLFKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774123; c=relaxed/simple;
	bh=vg7MW/V4HY5tvB5/b+Uq7fMjQ87Rz4OVY8HhQKNXqJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/LIQl1HuYGaeRf0qOMQJgIPwpj1htvaC5Q0AeaRO8/DvkiT+Gbq1CTcZSFp+BjpGpCALL0XK6j6zpLiJSZc6Wh29mHO7vKMWim1I9H58lDCUi0niWo8HJPVOqvK3xZwcRQQeSce2PKLnzekPoW9HXF6sfb2+5N/7g7G38smRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ThFLakqf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ThFLakqf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A8E6497;
	Wed, 30 Sep 2026 06:15:03 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F2B93F86F;
	Wed, 30 Sep 2026 06:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790774106; bh=vg7MW/V4HY5tvB5/b+Uq7fMjQ87Rz4OVY8HhQKNXqJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ThFLakqffTbj2ib6KicQbQjOxFz0FcE+uenjE6tXtxwTLir2gJkQ3ZxVGvINz9XPh
	 q77qEmlchGDHM/wHgBDSj+BGHPdwqQ8nnI9QJAn6j1dN9SDukMKrqBqAfptRvilZ70
	 t7fSmkiZ/TG/i7p/g/aTn6KqJ5ghcgUk0rgWNdvE=
Date: Wed, 30 Sep 2026 14:15:00 +0100
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
Subject: Re: [PATCH v20 4/9] firmware: arm_rmm: Add support for SRO
Message-ID: <ar0LQwXM5MEvFUWa@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-5-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929221623.1342076-5-suzuki.poulose@arm.com>

On Tue, Sep 29, 2026 at 11:16:18PM +0100, Suzuki K Poulose wrote:
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long size = block_size * count;
> +	unsigned long addr_range;
> +	unsigned long donated_size;
> +	int ret;
> +	void *virt;
> +	phys_addr_t phys;
> +
> +	/*
> +	 * The RMM specification requires contiguous allocations are always a
> +	 * power of 2
> +	 */
> +	if (WARN_ON_ONCE(!is_power_of_2(size)))
> +		return -EINVAL;
> +	/*
> +	 * RMM clamps the Maximum value of RmiOpMemDonateReq:count to prevent
> +	 * overflow in the RMI_ADDR_RANGE_COUNT field.
> +	 */
> +	if (WARN_ON_ONCE(count > (BIT(PAGE_SHIFT - 2) - 1)))
> +		return -EINVAL;

Nit: it might be easier to read as FIELD_MAX(RMI_ADDR_RANGE_COUNT_MASK)
as that's what we want to limit it to.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

(Sashiko seems to have more findings but the rest looks alright to me)
