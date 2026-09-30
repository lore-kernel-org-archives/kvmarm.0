Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD474DD3A2;
	Wed, 30 Sep 2026 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790779517; cv=none; b=LVYqLSqB+v2L91vWoSaCTy9y76QJ7UX7PRbG2BiXopYh89RfdMuEfFnUZKgIuLNLlPzTePexc+l0PbMF8rjiJTgm2rIIEqtdSAlx8jtoyFjICwbdpKCJfvsKFZs/VyIkbHxUBSeksT3e3DPJKr936M6xIET3rKsrX+hzqhFiX08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790779517; c=relaxed/simple;
	bh=HLlUQWER5GPL4c57fjFMJARLSJZqROvDyga3Zux6cPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5qNvLu31oX4RkOqXJsEQF+THtvWIJNc9kmXWdI2YEx0Zy+9jFhvmqQIMS4TqLhKP31tJx05VURYVrPs+Hn59Efi9dIVXnKQrP9bnpoWEGT3dhYWQxeGyg/cZKYUadgCs6X+xglCCrd+n4pIgoLnoKkNPFiQP+lrixYR0+r1/Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsUrGiZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsUrGiZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7A61F00893;
	Wed, 30 Sep 2026 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790779495;
	bh=k6UVIhzsdZx5yMbBC0Hj1Zqo66sKEDFFBwKg4yISoQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GsUrGiZNeVEfDds38/qWXHLJJrm/I2CKdi8vnv1FAypbuJjpvIwfMxaiNI8ab7Hz3
	 4rXJ2AudUts1c0RlsO3FEGCBqRwJ6b8i5Xq0QwNJJio7Xyz6MaLNeazj6xtZBg/6X5
	 Hl9/Dv8QDXQbWIXNCXVwI7/ZzcL3C/s35dnMMLl1YzUkBdb1M4SKaZ4H70QAu31irJ
	 mm1nD4kKqLuHwMDOMShiL8OEf/d5hd12bk/e/VRcsqqamB0wfZ0+q5M1r39N4N5R1p
	 PgjA66UB1FlQ+OjL1OYn+aPt+sKVZg9wzdqqCWa5FOfnPGOnKYoWBi9IZEPQh7PZbv
	 4GjgvggLJT6CA==
Date: Wed, 30 Sep 2026 15:44:49 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, will@kernel.org,
	catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v20 6/9] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Message-ID: <20260930-judicious-loris-of-will-dea0a3@sudeepholla>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-7-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929221623.1342076-7-suzuki.poulose@arm.com>

On Tue, Sep 29, 2026 at 11:16:20PM +0100, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> The RMM maintains the state of all the granules in the system to make
> sure that the host is abiding by the rules. This state can be maintained
> at different granularity, per page (TRACKING_FINE) or per region
> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
> all pages in the region must be of the same state, this implies we need to
> have "fine" tracking for DRAM, so that we can delegate individual pages.
> 
> For now we only support a statically carved out memory for tracking
> granules for the "fine" regions. This can be extended in the future to
> allow modifying the tracking granularity and remove the need for a
> static allocation by the firmware.
> 
> Similarly, the firmware may create L0 GPT entries describing the total
> address space. But if we change the "PAS" (Physical Address Space) of a
> granule, then the firmware may need to create L1 tables to track the PAS
> at a finer granularity. Linux therefore checks if the platform firmware
> manages the PAR region. i.e., the firmware is in charge of managing the
> L1 GPTs (creation and the required memory for the GPT tables - via static
> carveouts) without host intervention. Support for dynamic GPT creation by
> the host will be added later.
> 
> If the firmware requires us to manage the tracking or GPT memory,
> deactivate the RMM and reclaim any memory donated at RMM activation.
> 
> Apply the same checks when hotplugged memory is brought online.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  Changes since v19:
>    * Wrap comments to 80spaces.
>    * Add a comment on ALIGN_DOWN the end of memory range.
>    * Add is_rmm_active() to indicate if the RMM is active
>    * Switch errors to -ENODEV from -ENOMEM when RMM doesn't manage the region
>    * Print error messages when RMI_GPT_INFO/RMI_GRANULE_TRACKIN_GET fails
>  Changes since v18:
>    * Avoid mixing gotos with __free cleanups for arm64_init_rmi()
>    * Handle buggy RMM to make forward progress for RMI_GPT_INFO and
>      RMI_GRANULE_TRACKING_GET
>    * Make sure the memory ranges are not inverted and reject such ranges.
>    * Move granule_tracking_get/gpt_info wrappers closer to the callers
>      Drop "inline", let the compiler do its job
>  Changes since v17:
>    * Move wrappers that may not be used elsewhere, out of arm-rmi-cmds.h
>  Changes since v16:
>    * Check fine tracking and create L1 GPTs for hotplug-added memory.
>    * Clarify the L1 GPT setup and move the explanatory comment.
>    * Switch to using RMI_GPT_INFO command for checking the GPTs.
>    * Deactivate the RMM and reclaim the memory if we can't proceed.
>  Changes since v15:
>    * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>    * Handle negative error codes from wrappers.
>  Changes since v14:
>    * Move the implementation into drivers/firmware/arm_rmm.
>  Changes since v13:
>    * Moved out of KVM
> ---
>  drivers/firmware/arm_rmm/rmi.c | 247 ++++++++++++++++++++++++++++++++-
>  include/linux/arm-rmi-cmds.h   |  18 +++
>  2 files changed, 264 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index d982cf158f8da..d4d098448e46e 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c

[...]

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

Is it guaranteed that end with not be = PASZ ? The spec says RMI_GPT_INFO
will return RMI_GPT_INFO when top >= pasz. Unlike start, end for good
reason is aligned up(ceil) instead of aligned down, but that also means
end will become PASZ when we reach end of memory, no ?

Sorry if I am missing something, trying to understand bits and piece of
RME still, just getting started.

> +	while (start < end) {
> +		long ret = rmi_gpt_info(start, end, &next, &par_state);
> +
> +		if (ret != RMI_SUCCESS) {
> +			pr_err("RMI_GPT_INFO failed for %llx-%llx: (%ld)\n",
> +				start, end, ret);
> +			return -ENXIO;
> +		}
> +
> +		if (WARN_ON(next <= start))
> +			return -ENXIO;
> +
> +		if (par_state != RMI_GPT_PAR_PLAT) {
> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
> +				start, next);
> +			return -ENODEV;
> +		}
> +		start = next;
> +	}
> +
> +	return 0;
> +}
> +

-- 
Regards,
Sudeep
