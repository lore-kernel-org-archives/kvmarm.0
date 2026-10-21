Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588055;
	b=m7U5gsEgu4R2gpGOBb5ZU9KyHzk0Z6a36X0G4hCdr/cbsU+GF9TMn368rrd2XW3AK2uY
	 PS8GB0IcTN7Oszh72XW2QBmUbf/mlHipWLxHnrpwRJhX2FguHsQtDyG6UBSbQ3SHMUnGW
	 HZ8kSdpz7HcqU1vM4kd0WfzbuXNb+/oyUEMmLZVw5Vwt2YQKmHZAiQXzCg3v/kAOQFTPc
	 FQW25Wp9SMb25R5vzD3lOJwjvryDQyIC1wis83pDVBinBwFZnDZJgt9e9o3vkY0ScCydl
	 xhLBd9ipiNPsFWIAbEVxKqlO9LZapUluybK4TP7iAuKsthl5U/EAXlrW7VUC8V3UgNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588055;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=eptm0nTE5XWF6wwWhwC1vVdEa1trOJQC7h6Lca2PiP4=;
	b=jY2a4zOdXWLKJz2IMcCAzIdS2uCOxEPj4pu1SUGWnVJxgJYQv7xwYqqduhDibDTSDya3
	 S7T6Y0wTq/slNBzjfREDtaUvGNBgr/QxckyxrxTOWOglMPlW3h8ZMLJx8i3glMYfIuwQN
	 vSHXSzGYV/mItkAPbEOCCQ5+Vv4acZ7EkylFxV/oSnHxu4qPxX8OF/1hi3WbZ737jSZ+s
	 n1qCDoAchvOkZRNthwNQe8P25HuKSsNh21B3dw+NfzMzrWJX1fbbH1wCqPnN1wjRai/7w
	 jMWFyZDbjEOeXp/8RgoLsuxJPFCyCVEOi4BI9uwYHCRmGueBNPLUmzIm1MziKcndvJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=CHxHAxec;
	arc=none smtp.remote-ip=68.232.139.130
Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6320606A319;
	Wed, 21 Oct 2026 13:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6320606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=CHxHAxec
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792588061; x=1824124061;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4XdfwgpkFvzFS14XCzmyfcy7TRjNNYg4aRwWFx3svRg=;
  b=CHxHAxec5PzKnUkzqYvpbL0x9p6SJvRg7ZZMBUi+p5aJQnhnrGb4cZI3
   QXoEmQL5zvsFTTF4jBYIQ+azKRemKWwuSTrHATA1c6QzpcIG86B/xE+qo
   YB4dcg6CFgd4nOYFCY4pFDbAQQLXn9a64bv0YnqGGXJf7yhWgqOOg2rRo
   4tJFY4CNTa53lFMOy+6x31IBhqfTdqPKGi7MUVqzGkSD2Pdpc3MUBkBOy
   fJWfZICQtJ/fuOz2cd/9zVAH3NGU4f5HHVAU8219uro22JtY49N+TBp25
   tFCe/fUUKTli8LZ3w/bP+p/ttzv1b6u0dKb3tX4SpGp56sCGpPHvscp4/
   w==;
X-CSE-ConnectionGUID: rl2LlXjTQ++KV4tuo9oFfw==
X-CSE-MsgGUID: qF8cjxgxRAyj/Mtq88yVlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="257182662"
X-IronPort-AV: E=Sophos;i="6.27,170,1786978800"; 
   d="scan'208";a="257182662"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 22:07:33 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id C7F501002808;
	Wed, 21 Oct 2026 13:07:26 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 768458D6D9A;
	Wed, 21 Oct 2026 13:07:26 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.62.79])
	by az2uksmom2.o.css.fujitsu.com (Postfix) with SMTP id 2F17214000EC;
	Wed, 21 Oct 2026 13:07:17 +0000 (UTC)
Date: Wed, 21 Oct 2026 22:07:16 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org, 
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v22 06/10] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Message-ID: <atiyZ7_S7aBxowIQ@FCCLS0092175.localdomain>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-7-suzuki.poulose@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261002061507.1600269-7-suzuki.poulose@arm.com>

Hi Suzuki,

I've tested this series and found a possible TF-RMM issue.
Please  below.

On 10/02 07:15, Suzuki K Poulose wrote:
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
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
[...]
> +/*
> + * We do not support creating L1 GPTs yet. So, make sure that all the regions
> + * are managed by the firmware.
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

When system RAM starts at a non-L0GPTSZ-aligned address, the alignment
in rmi_verify_gpt_firmware_managed() may cause the queried L0GPT range
to include a memory hole.

On out platform, the relevant memory layout is:

    800c0000000-800dc3fffff : memory hole
    800dc400000-82fffffffff : System RAM

Consequently, Linux queries the following L0GPT range:

    800c0000000-80100000000

The query fails with RMI_GPT_PAR_RESERVED:

    [    8.551855] GPT for the region is not managed by firmware 800c0000000-80100000000

and arm64_init_rmi() subsequently fails.

As I understand it, smc_gpt_info() in TF-RMM checks only the beginning
of the aligned L0GPT range. Since that address is in the hole, the whole
range is reported as RMI_GPT_PAR_RESERVED, even though it contains
platform-managed System RAM.

I believe this should be addressed in TF-RMM. Do you have any thoughts
on the expected RMI_GPT_INFO behavior in this case?

As a side note, we tested this series and the v23 integration branch
with a Linux-side workaround to avoid the problem above, and we have not
observed any other major issues. Sorry for the delay in testing this
series.

Thanks,
Kohei

> +		}
> +		start = next;
> +	}
> +
> +	return 0;
> +}
