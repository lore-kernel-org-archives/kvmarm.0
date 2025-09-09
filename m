Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B541F0E2E;
	Tue,  9 Sep 2025 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427937; cv=none; b=XwFNR9lYKuh7LuyH45YaVR/vk6sdsAOLqN6EdusxDnVtyxYsVZGJZkeaMAFZ5AdVZ7pre4zHXC6C51GTg/Zg2ChUAm9KpZ6Z1w+39cScX2wZG2Pb8D/0y5P1b7Kc/aJz9bNVBOGQwh1i6R5NESvUfQGpykokxNENueKgt1yd/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427937; c=relaxed/simple;
	bh=KOCPAbXyhBmrq4G3esSPg3HAVWaUxAD+l+/Z/GxwYro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRQWfhgXbuVp8BwZoDjqTB3MBU2g/1S4KMKmwyI0OojcNCrfx4f//c80OpZ49szTv1APpsKQX6cRFuoO9s5XzAOcxqWUlYIZeSi6UnNwXSijmLBmKEVVVgXqUFFWhTlew65xMyB57EIHoGtPt3V6iyIYhobvfbuCAAaNWkVBAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oykfebDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oykfebDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF22C4CEF4;
	Tue,  9 Sep 2025 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757427937;
	bh=KOCPAbXyhBmrq4G3esSPg3HAVWaUxAD+l+/Z/GxwYro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oykfebDOD3Pse+tzCSjCAz2s+XpsZGxDPQ/oNpP6TdYxUuVH2F8km/Wy8s6O8bmN3
	 xVhTAeGeGcjUnd9Dk9zwOF4xjV+dkYAcHqxAipqz6Gr/TC7mVeLo6zCsEuvaaDlaug
	 BE5n5vqVrmcC0evZDAnBfDwy6j0BOBqoS6vnK2tS5aitlBmddzJ5UIEkIa7ZFSJ463
	 FoxbJh9p05npZAl3B+5sm+DFXCf65W6IW4mesh0TBMgrqeEVtdviNoW67oexfgaAft
	 3SvD9ZCZCJJv3L1K4gtEYswSHx2F3Mi3Cfk4JIszfdjMFy3E0sHNOJIXvN4IpH1sEf
	 UqUyLae88PdeA==
Date: Tue, 9 Sep 2025 15:25:30 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 07/28] iommu/arm-smmu-v3: Move TLB range invalidation
 into a macro
Message-ID: <aMA42g-QWYzOwg7r@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-8-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-8-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:35PM +0000, Mostafa Saleh wrote:
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 2698438cd35c..a222fb7ef2ec 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -1042,6 +1042,70 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
>  	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
>  }
>  
> +/**
> + * arm_smmu_tlb_inv_build - Create a range invalidation command
> + * @cmd: Base command initialized with OPCODE (S1, S2..), vmid and asid.
> + * @iova: Start IOVA to invalidate
> + * @size: Size of range
> + * @granule: Granule of invalidation
> + * @pgsize_bitmap: Page size bit map of the page table.
> + * @smmu: Struct for the smmu, must have ::features
> + * @add_cmd: Function to send/batch the invalidation command
> + * @cmds: Incase of batching, it includes the pointer to the batch
> + */
> +#define arm_smmu_tlb_inv_build(cmd, iova, size, granule, pgsize_bitmap, smmu, add_cmd, cmds) \
> +{ \
> +	unsigned long _iova = (iova);						\
> +	size_t _size = (size);							\
> +	size_t _granule = (granule);						\
> +	unsigned long end = _iova + _size, num_pages = 0, tg = 0;		\
> +	size_t inv_range = _granule;						\

This is pretty gross and I've been (very sporadically) trying to replace
the similar macro we have on the CPU side with static inline functions
instead.

Can you use an inline function here too?

Will
