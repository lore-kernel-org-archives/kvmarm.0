Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7884535836E;
	Sun,  9 Aug 2026 06:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786257773; cv=none; b=CdLWbYPZdUF+HXyIg+Y5SP4dJKrVspwoEMBb3QHes3Cid5ujQ1FTI4NUiPu7WX/df7Ij0mdGH9g9NJwPG6DaK2yiLkyWAfP1Uh5Hcbk6NI5ZvKgpatjRJ9PmNojzMs2t1uucqvOscjEwhrMcnpt3cehBBb+nDQF/FHINHvYfK2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786257773; c=relaxed/simple;
	bh=R6yBmyxuR+V780x3naz0o++V38Ykhmc588fXz/oxl8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIhG0Nyj+QFO6nw5hTsxJ7PSaDrrU8ptVP9l/zQbtafebNBnJ7KcbuPyBT36Hw2CBH5Dp+o9d/o704AEJot/CXgqt6Y8pLPvCggAVI5JLH/zlbACkxCFm7n+QT9+9a0cpd/yr+aFif+m3qTI/U4rdn7i5rrhTt+goH1ZTxCmoGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IXjLH+zF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IXjLH+zF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEFD6152B;
	Sat,  8 Aug 2026 23:42:47 -0700 (PDT)
Received: from [10.57.41.8] (unknown [10.57.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 909D83F9A2;
	Sat,  8 Aug 2026 23:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786257771; bh=R6yBmyxuR+V780x3naz0o++V38Ykhmc588fXz/oxl8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IXjLH+zFuDRuSANWFWGuHCpS6ALdYgLhbhvVMnuCqMwBhwBPmXa/0cD4MrUh3IKIC
	 7Mjsp2FKa01EHb/WVQMyqw3gA19/c3hvrFrgMoljCyJ4nYIVr6cfs8GKinuHdvc2Cr
	 v+3hmtoka+4W+HdTJiae9BKJJ1W4iarPT0cc7iV0=
Message-ID: <c6c7debd-42e3-41ac-87ca-96ba543f6c84@arm.com>
Date: Sun, 9 Aug 2026 07:42:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 06/45] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-7-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260803134403.80630-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/08/2026 14:43, Steven Price wrote:
> The RMM maintains the state of all the granules in the system to make
> sure that the host is abiding by the rules. This state can be maintained
> at different granularity, per page (TRACKING_FINE) or per region
> (TRACKING_COARSE). The region size depends on the underlying
> "RMI_GRANULE_SIZE". For a "coarse" region all pages in the region must
> be of the same state, this implies we need to have "fine" tracking for
> DRAM, so that we can delegate individual pages.
> 
> For now we only support a statically carved out memory for tracking
> granules for the "fine" regions. This can be extended in the future to
> allow modifying the tracking granularity and remove the need for a
> static allocation.
> 
> Similarly, the firmware may create L0 GPT entries describing the total
> address space. But if we change the "PAS" (Physical Address Space) of a
> granule then the firmware may need to create L1 tables to track the PAS
> at a finer granularity.

This sounds a bit incomplete to me. We could add:

"Again, this series do not support creation of L1 GPT tables yet. Thus 
make sure that the firmware has L1 GPTs covering the DRAM region."


> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v15:
>   * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>   * Handle negative error codes from wrappers.
> Changes since v14:
>   * Move the implementation into drivers/firmware/arm_rmm.
> Changes since v13:
>   * Moved out of KVM
> ---
>   drivers/firmware/arm_rmm/rmi.c | 101 +++++++++++++++++++++++++++++++++
>   include/linux/arm-rmi-cmds.h   |   2 +
>   2 files changed, 103 insertions(+)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 51ea661cecf9..bce3304bbc1a 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -12,6 +12,8 @@
>   #include <asm/memory.h>
>   #include <asm/pgtable-hwdef.h>
>   
> +static bool arm64_rmi_is_available;
> +
>   /* Currently only the first 2 registers are used by Linux */
>   #define RMI_FEAT_REG_COUNT	2
>   static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
> @@ -647,6 +649,98 @@ static int rmi_configure(void)
>   	return ret;
>   }
>   
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
> +		if (ret != RMI_SUCCESS ||
> +		    state != RMI_TRACKING_FINE ||
> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> +			/* TODO: Set granule tracking in this case */
> +			pr_err("Granule tracking for region isn't fine/conventional: %llx\n",
> +			       start);
> +			return -ENODEV;
> +		}
> +		start = next;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
> +{
> +	struct rmi_sro_state *sro;
> +	unsigned long l0gpt_sz;
> +
> +	sro = kmalloc_obj(*sro, GFP_KERNEL);
> +	if (!sro)
> +		return -ENOMEM;
> +
> +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +					  rmi_feat_reg(1)));
> +	start = ALIGN_DOWN(start, l0gpt_sz);
> +	end = ALIGN(end, l0gpt_sz);
> +
> +	while (start < end) {
> +		long ret = rmi_gpt_l1_create(start, sro, GFP_KERNEL);
> +
> +		/*
> +		 * Make sure the L1 GPT tables are created for the region.
> +		 * RMI_ERROR_GPT indicates the L1 table already exists.
> +		 */

minor nit: The comment could be moved down closer to the check.

> +		if (ret < 0) {
> +			kfree(sro);
> +			return ret;
> +		}
> +
> +		if (ret != RMI_SUCCESS && RMI_RETURN_STATUS(ret) != RMI_ERROR_GPT) {
> +			pr_err("GPT Level1 table missing for %llx\n", start);
> +			kfree(sro);
> +			return -ENOMEM;
> +		}
> +		start += l0gpt_sz;
> +	}
> +

Rest looks good to me

Suzuki
