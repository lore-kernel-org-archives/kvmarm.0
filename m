Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3958678F2E;
	Fri, 12 Sep 2025 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757686695; cv=none; b=cAA21S+6Vq5kci33cIIHPSlljkaB8Z3u/i5/s4fC5uqRqyIlAdt1K0eN50h6EEbudBzIth9JiGAQRNUZgmGoU6qu096kp794a9TsnIe8lcBxxEYqRCxEbfKVWbqsWNuwFbWnLKd9pI496ujxGWIKgA2kEDaojU7ToWMv4xjdZ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757686695; c=relaxed/simple;
	bh=1hy35R43ASil/Xah8GOzXEPYbvd1rzbSp8b9RvMG6Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcJIS4rMbRMRncQ2d9zZCWE1BJI7tXd98orRgA4sNpWWt3HcCZhHoS6SBMcG/5erNYPsoT73uhGPTIFWP3dH2QW1RYc9TyC35HhlHJzKTWq0hs4FP3Pvr1g2Qtbztwl0pdeREcnR5EGQx//EBaqO48ZRsPoGBkrr9HveCNUV2HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlbPoZYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlbPoZYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3C9C4CEF1;
	Fri, 12 Sep 2025 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757686694;
	bh=1hy35R43ASil/Xah8GOzXEPYbvd1rzbSp8b9RvMG6Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TlbPoZYJ6ueISXmeEesGaARcP6z4YBrYkH2IC/638nX32M8kbtDTP0p1jSKvVELs7
	 RlUkOMEPDIN3fC/vITW5mZ95dHxXGlma/5nu/1tIQRyj3Q22jbl4dOBZ8m/vEAb/zr
	 8ZbxNUMHritPukMqfvA971a40Z9vmj1g11YY01hg4i+ijIH8yxXn26YvMJ0DKYc2lw
	 TIbEPYPpPacojnhRmU6Et4QWk7+dqgfiwTWboOYaBsJGPN5aoEp2kQodjq76T+lo55
	 kAv3nLm3CaMsRDH4xN8NXlKabR6Z76SyN9hfVJfCs9mSfGktNJh//pIKQ6yylRajdi
	 8mS984t4j9I0Q==
Date: Fri, 12 Sep 2025 15:18:08 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <aMQroI4NDu74PDGT@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250819215156.2494305-23-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:50PM +0000, Mostafa Saleh wrote:
> Don’t allow access to the command queue from the host:
> - ARM_SMMU_CMDQ_BASE: Only allowed to be written when CMDQ is disabled, we
>   use it to keep track of the host command queue base.
>   Reads return the saved value.
> - ARM_SMMU_CMDQ_PROD: Writes trigger command queue emulation which sanitises
>   and filters the whole range. Reads returns the host copy.
> - ARM_SMMU_CMDQ_CONS: Writes move the sw copy of the cons, but the host can’t
>   skip commands once submitted. Reads return the emulated value and the error
>   bits in the actual cons.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 108 +++++++++++++++++-
>  1 file changed, 105 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 554229e466f3..10c6461bbf12 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> @@ -325,6 +325,88 @@ static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
>  	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
>  }
>  
> +static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *command)
> +{
> +	u64 type = FIELD_GET(CMDQ_0_OP, command[0]);
> +
> +	switch (type) {
> +	case CMDQ_OP_CFGI_STE:
> +		/* TBD: SHADOW_STE*/
> +		break;
> +	case CMDQ_OP_CFGI_ALL:
> +	{
> +		/*
> +		 * Linux doesn't use range STE invalidation, and only use this
> +		 * for CFGI_ALL, which is done on reset and not on an new STE
> +		 * being used.
> +		 * Although, this is not architectural we rely on the current Linux
> +		 * implementation.
> +		 */
> +		WARN_ON((FIELD_GET(CMDQ_CFGI_1_RANGE, command[1]) != 31));
> +		break;
> +	}
> +	case CMDQ_OP_TLBI_NH_ASID:
> +	case CMDQ_OP_TLBI_NH_VA:
> +	case 0x13: /* CMD_TLBI_NH_VAA: Not used by Linux */
> +	{
> +		/* Only allow VMID = 0*/
> +		if (FIELD_GET(CMDQ_TLBI_0_VMID, command[0]) == 0)
> +			break;
> +		break;
> +	}
> +	case 0x10: /* CMD_TLBI_NH_ALL: Not used by Linux */
> +	case CMDQ_OP_TLBI_EL2_ALL:
> +	case CMDQ_OP_TLBI_EL2_VA:
> +	case CMDQ_OP_TLBI_EL2_ASID:
> +	case CMDQ_OP_TLBI_S12_VMALL:
> +	case 0x23: /* CMD_TLBI_EL2_VAA: Not used by Linux */
> +		/* Malicous host */
> +		return WARN_ON(true);
> +	case CMDQ_OP_CMD_SYNC:
> +		if (FIELD_GET(CMDQ_SYNC_0_CS, command[0]) == CMDQ_SYNC_0_CS_IRQ) {
> +			/* Allow it, but let the host timeout, as this should never happen. */
> +			command[0] &= ~CMDQ_SYNC_0_CS;
> +			command[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> +			command[1] &= ~CMDQ_SYNC_1_MSIADDR_MASK;
> +		}
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +static void smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u64 *host_cmdq = hyp_phys_to_virt(smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK);
> +	int idx;
> +	u64 cmd[CMDQ_ENT_DWORDS];
> +	bool skip;
> +
> +	if (!is_cmdq_enabled(smmu))
> +		return;
> +
> +	while (!queue_empty(&smmu->cmdq_host.llq)) {
> +		/* Wait for the command queue to have some space. */
> +		WARN_ON(smmu_wait_event(smmu, !smmu_cmdq_full(&smmu->cmdq)));
> +
> +		idx = Q_IDX(&smmu->cmdq_host.llq, smmu->cmdq_host.llq.cons);
> +		/* Avoid TOCTOU */
> +		memcpy(cmd, &host_cmdq[idx * CMDQ_ENT_DWORDS], CMDQ_ENT_DWORDS << 3);
> +		skip = smmu_filter_command(smmu, cmd);
> +		if (!skip)
> +			smmu_add_cmd_raw(smmu, cmd);
> +		queue_inc_cons(&smmu->cmdq_host.llq);
> +	}

Hmmm. There's something I'd not considered before here.

Ideally, the data structures that are shadowed by the hypervisor would
be mapped as normal-WB cacheable in both the host and the hypervisor so
we don't have to worry about coherency and we get the performance
benefits from the caches. Indeed, I think that's how you've mapped
'host_cmdq' above _however_ I sadly don't think we can do that if the
actual SMMU hardware isn't coherent.

We don't have a way to say things like "The STEs and CMDQ are coherent
but the CDs and Stage-1 page-tables aren't" so that means we have to
treat the shadowed structures populated by the host in the same way as
the host-owned structures that are consumed directly by the hardware.
Consequently, we should either be using non-cacheable mappings at EL2
for these structures or doing CMOs around the accesses.

Will
