Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E9B29CE9
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 04:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774325838; cv=none; b=hIa9fEdzcqSIMZwcsHYknWiJLXHhFgeh0f5QJYdcjP543xpi85z0Cmyz5UXkvLwXytqWbfalzR3nsuPGcjm4aBbSZkcSpXtHY7fpwUSrG1fZvB0Zn4dEPaEoS/DWy3JFSGwtHEnfK7l9tmbl7anmCveeuOh3XLdgTlfccRbKS7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774325838; c=relaxed/simple;
	bh=Yzpa+sMTl++Z0Swu0jEbd6VbyKzLf18TZMMC6kHywt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VR8hKgzENPjFwC+452OJ3NXF2fCF8YXsjqHXbfIswHg2z5zf5QUzTaoouTDKoB8/B+K/NRTqnpw3pPG44rVzc6xvwEXPK2N6fDqz2u55fZQY0AnV4PViW8ESiePKcNqN0woFoEnH5gPYFGvffHcJ5R01qGiDrVas1JcH29AYJVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4K2ebkI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4K2ebkI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774325836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMM0PIHjaGNSwkTYUN4aTP3OrCjUF8tNj7svjVlstlQ=;
	b=X4K2ebkIrnkXYXEgBpsZ50TNuHEb5sJMw/P+lmq3ihZtn9hQWglO/iEwAZEpuLMWOQZ6a2
	bAVhKs13LAex7RcRGVkpAT4mMlbyX8j2fa0pB/07beslg4moQ5wwr+c22Hqs48kPXHagKM
	AcyIwZYKREE4DqhApLBC6oRCr7tiQRA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-ZttbnLjNMyq9Qlp7-PelYg-1; Tue, 24 Mar 2026 00:17:14 -0400
X-MC-Unique: ZttbnLjNMyq9Qlp7-PelYg-1
X-Mimecast-MFC-AGG-ID: ZttbnLjNMyq9Qlp7-PelYg_1774325834
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35b9246248dso5088425a91.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 21:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774325834; x=1774930634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMM0PIHjaGNSwkTYUN4aTP3OrCjUF8tNj7svjVlstlQ=;
        b=A4Cp7T4/pq3F/z1+nXE4HQhMJV4ehzOclXEwK/2p7G2NerSHN4fRIuCz0WbHoy4rtf
         7LpikgweGtgYgNBEPOQHJ92CwEv9tyBfwtWm8vyi1IwSHsKSR24PPWkgcDsJc/3svbHJ
         yeefxuToaXLRwx4ibdlAg/sG8lzbGYqCLDe+l61PfY5tyDI++qjLeLXca8ADwRdUwNk4
         KeQHvda02HM9wfnnDfwacMBPdQ6Z7tNWqG+2i4pgyLQD8I4ogaA//wD2U77RVwcMCZ8T
         YUVzWg8NtdFcBfL2RT94fWOEe/7NVmK+E4XR2oPzKOcjkV8J17xbd2EL7lyR5cfehhn1
         wPkA==
X-Forwarded-Encrypted: i=1; AJvYcCWsiZsFxEcAZP4qEd9zR9m6DdrmK8aiD0vcoQEnxxFoHt70/akP5LD/rAANo8s8g5M3WPt0H74=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKlzYl6lkgTsZp9z6WOOOAv6bByBa3f9iV5Bz/jTBSOsFID3uc
	ldGpnsi1ZHVPifoh50L6NsLnzSFrWwW32BYIm/dCyfSnTmKPcejuG4PwPZFhv3ythootlt8IVWy
	cWiTyo9I3Z5HZJGFP86J8iq3BgJkUNFG81WjZwYnjMZlSe97ahyI7Pzb5wg==
X-Gm-Gg: ATEYQzzXyWEycZK1MPuRcu6E4DHnbu/c3U9v/tSzghS3J/MegodvIx0oj8o3mFxxQ61
	Rj1683m8Gor3nZXZxnqrvsxeoIVhv52qH7fbKRMG3hv26ILbd6P1RacS4XYEZ+7H8T9QZNvXkGu
	UMg4LahAVjNHpnPJfKhbMsJFMWAD1gDhcvVtuU4+/9zBOHgoPBIx+0/96iqZGelE2NXxlBaU9y7
	QmDtMjSeNm1BFYGz4SHEHynm/NUEjKpjklPP5qV3zWNNfAjG0wNEAbJvlQnFb9Kk6ZVBe4fIbTj
	+RrQyIvr1I6lr01Pk2oyoc69TrSzzxCexi1gnfqotkj6IAnPYNlAD0/NFD/45vCfEyq5xkDx/yo
	cnSnt8Mnq0Qp6U5Nd+GhCY/jZ2glM8SZOAkroqWUt7gzf4pltILDiVyVT09s+7y4w
X-Received: by 2002:a17:90b:33cd:b0:35b:a30f:8bfa with SMTP id 98e67ed59e1d1-35bd2b9743dmr11784482a91.7.1774325833646;
        Mon, 23 Mar 2026 21:17:13 -0700 (PDT)
X-Received: by 2002:a17:90b:33cd:b0:35b:a30f:8bfa with SMTP id 98e67ed59e1d1-35bd2b9743dmr11784442a91.7.1774325833157;
        Mon, 23 Mar 2026 21:17:13 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03220321sm691413a91.17.2026.03.23.21.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 21:17:12 -0700 (PDT)
Message-ID: <7b73d10e-4bfd-434f-b05f-25c4859a7abd@redhat.com>
Date: Tue, 24 Mar 2026 14:16:58 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 36/40] arm_mpam: Add workaround for T241-MPAM-1
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-37-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-37-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wFi__8fhLK_9lbtz_BRFL_s_6hsdnKjeTzLt514xsaQ_1774325834
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> The MPAM bandwidth partitioning controls will not be correctly configured,
> and hardware will retain default configuration register values, meaning
> generally that bandwidth will remain unprovisioned.
> 
> To address the issue, follow the below steps after updating the MBW_MIN
> and/or MBW_MAX registers.
> 
>   - Perform 64b reads from all 12 bridge MPAM shadow registers at offsets
>     (0x360048 + slice*0x10000 + partid*8). These registers are read-only.
>   - Continue iterating until all 12 shadow register values match in a loop.
>     pr_warn_once if the values fail to match within the loop count 1000.
>   - Perform 64b writes with the value 0x0 to the two spare registers at
>     offsets 0x1b0000 and 0x1c0000.
> 
> In the hardware, writes to the MPAMCFG_MBW_MAX MPAMCFG_MBW_MIN registers
> are transformed into broadcast writes to the 12 shadow registers. The
> final two writes to the spare registers cause a final rank of downstream
> micro-architectural MPAM registers to be updated from the shadow copies.
> The intervening loop to read the 12 shadow registers helps avoid a race
> condition where writes to the spare registers occur before all shadow
> registers have been updated.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> 
> Changes from James:
>    Merged the min/max update into a single
>    mpam_quirk_post_config_change() helper. Stashed the t241_id in the msc
>    instead of carrying the physical address around. Test the msc quirk bit
>    instead of a static key.
> 
> Changes since rfc:
> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
> return err from init
> Be specific about the errata in the init name,
>    mpam_enable_quirk_nvidia_t241 -> mpam_enable_quirk_nvidia_t241_1
> 
> Changes since v3:
> parentheses
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  2 +
>   drivers/resctrl/mpam_devices.c              | 88 +++++++++++++++++++++
>   drivers/resctrl/mpam_internal.h             |  9 +++
>   3 files changed, 99 insertions(+)
> 

One question below.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index 4c300caad901..a65620f98e3a 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -247,6 +247,8 @@ stable kernels.
>   +----------------+-----------------+-----------------+-----------------------------+
>   | NVIDIA         | T241 GICv3/4.x  | T241-FABRIC-4   | N/A                         |
>   +----------------+-----------------+-----------------+-----------------------------+
> +| NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/A                         |
> ++----------------+-----------------+-----------------+-----------------------------+
>   +----------------+-----------------+-----------------+-----------------------------+
>   | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
>   +----------------+-----------------+-----------------+-----------------------------+
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index e66631f3f732..b1753498f07f 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -29,6 +29,16 @@
>   
>   #include "mpam_internal.h"
>   
> +/* Values for the T241 errata workaround */
> +#define T241_CHIPS_MAX			4
> +#define T241_CHIP_NSLICES		12
> +#define T241_SPARE_REG0_OFF		0x1b0000
> +#define T241_SPARE_REG1_OFF		0x1c0000
> +#define T241_CHIP_ID(phys)		FIELD_GET(GENMASK_ULL(44, 43), phys)
> +#define T241_SHADOW_REG_OFF(sidx, pid)	(0x360048 + (sidx) * 0x10000 + (pid) * 8)
> +#define SMCCC_SOC_ID_T241		0x036b0241
> +static void __iomem *t241_scratch_regs[T241_CHIPS_MAX];
> +
>   /*
>    * mpam_list_lock protects the SRCU lists when writing. Once the
>    * mpam_enabled key is enabled these lists are read-only,
> @@ -630,7 +640,45 @@ static struct mpam_msc_ris *mpam_get_or_create_ris(struct mpam_msc *msc,
>   	return ERR_PTR(-ENOENT);
>   }
>   
> +static int mpam_enable_quirk_nvidia_t241_1(struct mpam_msc *msc,
> +					   const struct mpam_quirk *quirk)
> +{
> +	s32 soc_id = arm_smccc_get_soc_id_version();
> +	struct resource *r;
> +	phys_addr_t phys;
> +
> +	/*
> +	 * A mapping to a device other than the MSC is needed, check
> +	 * SOC_ID is  NVIDIA T241 chip (036b:0241)
> +	 */
> +	if (soc_id < 0 || soc_id != SMCCC_SOC_ID_T241)
> +		return -EINVAL;
> +
> +	r = platform_get_resource(msc->pdev, IORESOURCE_MEM, 0);
> +	if (!r)
> +		return -EINVAL;
> +
> +	/* Find the internal registers base addr from the CHIP ID */
> +	msc->t241_id = T241_CHIP_ID(r->start);
> +	phys = FIELD_PREP(GENMASK_ULL(45, 44), msc->t241_id) | 0x19000000ULL;
> +
> +	t241_scratch_regs[msc->t241_id] = ioremap(phys, SZ_8M);
> +	if (WARN_ON_ONCE(!t241_scratch_regs[msc->t241_id]))
> +		return -EINVAL;

Those IO regions aren't unmapped when the MSCs are removed. I guess it would be
something to be improved? :-)


> +
> +	pr_info_once("Enabled workaround for NVIDIA T241 erratum T241-MPAM-1\n");
> +
> +	return 0;
> +}
> +
>   static const struct mpam_quirk mpam_quirks[] = {
> +	{
> +	/* NVIDIA t241 erratum T241-MPAM-1 */
> +	.init       = mpam_enable_quirk_nvidia_t241_1,
> +	.iidr       = MPAM_IIDR_NVIDIA_T241,
> +	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
> +	.workaround = T241_SCRUB_SHADOW_REGS,

Perhaps we need a more leading space for every line in the above block.

> +	},
>   	{ NULL } /* Sentinel */
>   };
>   
> @@ -1378,6 +1426,44 @@ static void mpam_reset_msc_bitmap(struct mpam_msc *msc, u16 reg, u16 wd)
>   	__mpam_write_reg(msc, reg, bm);
>   }
>   
> +static void mpam_apply_t241_erratum(struct mpam_msc_ris *ris, u16 partid)
> +{
> +	int sidx, i, lcount = 1000;
> +	void __iomem *regs;
> +	u64 val0, val;
> +
> +	regs = t241_scratch_regs[ris->vmsc->msc->t241_id];
> +
> +	for (i = 0; i < lcount; i++) {
> +		/* Read the shadow register at index 0 */
> +		val0 = readq_relaxed(regs + T241_SHADOW_REG_OFF(0, partid));
> +
> +		/* Check if all the shadow registers have the same value */
> +		for (sidx = 1; sidx < T241_CHIP_NSLICES; sidx++) {
> +			val = readq_relaxed(regs +
> +					    T241_SHADOW_REG_OFF(sidx, partid));
> +			if (val != val0)
> +				break;
> +		}
> +		if (sidx == T241_CHIP_NSLICES)
> +			break;
> +	}
> +
> +	if (i == lcount)
> +		pr_warn_once("t241: inconsistent values in shadow regs");
> +
> +	/* Write a value zero to spare registers to take effect of MBW conf */
> +	writeq_relaxed(0, regs + T241_SPARE_REG0_OFF);
> +	writeq_relaxed(0, regs + T241_SPARE_REG1_OFF);
> +}
> +
> +static void mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
> +					  struct mpam_config *cfg)
> +{
> +	if (mpam_has_quirk(T241_SCRUB_SHADOW_REGS, ris->vmsc->msc))
> +		mpam_apply_t241_erratum(ris, partid);
> +}
> +
>   /* Called via IPI. Call while holding an SRCU reference */
>   static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>   				      struct mpam_config *cfg)
> @@ -1457,6 +1543,8 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>   		mpam_write_partsel_reg(msc, PRI, pri_val);
>   	}
>   
> +	mpam_quirk_post_config_change(ris, partid, cfg);
> +
>   	mutex_unlock(&msc->part_sel_lock);
>   }
>   
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index e28a168419d4..e38954a735d8 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -130,6 +130,9 @@ struct mpam_msc {
>   	void __iomem		*mapped_hwpage;
>   	size_t			mapped_hwpage_sz;
>   
> +	/* Values only used on some platforms for quirks */
> +	u32			t241_id;
> +
>   	struct mpam_garbage	garbage;
>   };
>   
> @@ -220,6 +223,7 @@ struct mpam_props {
>   
>   /* Workaround bits for msc->quirks */
>   enum mpam_device_quirks {
> +	T241_SCRUB_SHADOW_REGS,
>   	MPAM_QUIRK_LAST
>   };
>   
> @@ -240,6 +244,11 @@ struct mpam_quirk {
>   				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	 | \
>   				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff))
>   
> +#define MPAM_IIDR_NVIDIA_T241	(FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0x241) | \
> +				 FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	 | \
> +				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	 | \
> +				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b))
> +
>   /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>   enum mon_filter_options {
>   	COUNT_BOTH	= 0,

Thanks,
Gavin

