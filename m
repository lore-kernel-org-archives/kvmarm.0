Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCBF2E7394;
	Fri, 25 Sep 2026 11:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790337047; cv=none; b=jPFrxL281MaKtcQgiFdjPN+MeltaF/RcKW7Uh7/XyrvU1fxkQJ/nCqC3MxWYIfgCI3DAdVwq4oTXd7BTUAwiPPEdvdXjXIRKd8HW9leVWprK5X2rosjQc8Pm2Hc6T1TtfCabHQEMX0BlSO/gywphs5MJtgWmxfZoUMF3xBAG7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790337047; c=relaxed/simple;
	bh=QVCeiKaLLsWqFAAQeL9n0+h8tt+vp+tZtOpFNlQ3uRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hh/VJN4CvXkfy+LpbBGajNnm1Rhz8Z8LI/bgkTvCx4JZE5jbkpVyw9M4OGssFvW4l1nH6ITOcVZEY0ml5gV6M82m0bZuG+IuiNkNxT5EDOc9yYfyKB7ygv6CAMQwjlnDMJhjMUiv+Isup2egQXQXi7S8TZqOrsWqlzcT/svCuZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SvrqnLBu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SvrqnLBu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF234169C;
	Fri, 25 Sep 2026 04:50:40 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1F353F86F;
	Fri, 25 Sep 2026 04:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790337044; bh=QVCeiKaLLsWqFAAQeL9n0+h8tt+vp+tZtOpFNlQ3uRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SvrqnLBui3M+PrATNF/BP/rA6CJ5DGdYxCAJft3/xiR14cPQcEvRfcJIPsSQxAGoz
	 xIKuAjGm0HQCK6kPgoni6UCZ1QNEdGsGP+fTEzNiH6+GqVN89AsMVcJTvbkoe2PWbl
	 r0s5D58XQ2hSGXwtCFtmPqkU+U66vuwoEOVWS70Q=
Date: Fri, 25 Sep 2026 12:50:38 +0100
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
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Message-ID: <arZgDmHV8uK1kv8R@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924135201.850038-5-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 02:51:58PM +0100, Suzuki K Poulose wrote:
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
> +	unsigned long donated_granules;
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
> +
> +	/* Reuse the cached address range if we have one */
> +	for (int i = 0; i < sro->addr_count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
> +			sro->addr_count--;
> +			swap(sro->addr_list[sro->addr_count],
> +			     sro->addr_list[i]);
> +
> +			goto mem_donate;
> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, 1);
> +	if (ret)
> +		return ret;
> +
> +	virt = alloc_pages_exact(size, gfp);
> +	if (!virt)
> +		return -ENOMEM;
> +	phys = virt_to_phys(virt);
> +
> +	if (state == RMI_OP_MEM_DELEGATED) {
> +		phys_addr_t delegated_phys;
> +
> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +				free_pages_exact(virt, size);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +	FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);

Courtesy of an LLM - if we get a contiguous/4K pages request for 4MB
(1024 pages), the above 10-bit field becomes 0. Should we reject the
request or the updated spec will guarantee this won't happen?

Somewhat related, with RMI_BLOCK_L2 or higher and appropriate count we
can easily go over the MAX_PAGE_ORDER allocation and fail alloc_pages()
(the contig case). IIUC, the kernel can reject the donation but current
TF-RMM does not report RMI_OP_CAN_CANCEL (R_SZVNK says it can be
cancelled). It gets complicated if we want to support large contiguous
allocations here (e.g. alloc_contig_pages() can sleep). I'd rather just
cancel the request, not support such large sizes.

[...]

> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{
> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long found = 0;
> +	unsigned long donated_granules;
> +	unsigned long granules_per_block = block_size >> PAGE_SHIFT;
> +	unsigned long consumed_blocks;
> +	int addr_list_start = sro->addr_count;
> +	int ret, i;

[...]

> +	for (int i = 0, src = addr_list_start + consumed_blocks;

Nit: we have 'int ret, i' earlier already, so you can drop the 'int'
here.

[...]

> +/*
> + * rmi_sro_execute: Execute an RMI command that is Stateful but not memory
> + * tranfserring. Takes regs, filled with the FIDs and the arguments in place.
> + *
> + * Returns :
> + *  -ECANCELLED - If the operation had to be aborted and SRO was cancellable.

Nit: -ECANCELED.

> + *  Otherwise, returns the result of the RMI command.
> + */
> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	bool cancelled = false;
> +	unsigned long sro_handle = regs->a1;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;

Nit: drop the first initialisation maybe?

-- 
Catalin
