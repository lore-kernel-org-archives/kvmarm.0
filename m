Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C82B23D7E6
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768825007; cv=none; b=jjU/9F+idlRYe8cAMXJx6SSQv3fyDZ45lJqAcjZDK0pJcXYvOi7CUkkSwNKeZO4D+nOF/xvRvLwVbQCcH4MTkG37AZMftPjCR2Q6GprWXXW5GwZNtJtAIVkOuhBPij5fE9vyxXBJBJg3rDFLckofmSA1oYDiPlDZ1TesAIB4Gtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768825007; c=relaxed/simple;
	bh=tepXI1Jx7LlZi5GOHsGJ0gOL06+xDUFNskVxlS0030A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmjjgaIemfwoaWxeowErcicAh8oH1TsBaxkJVFxP0HHWPnI7MVLxnv57C+x76Rm0kmaXtVmvmbbCkmtq0khr3f+9y1rXLdQk9PORK+v1Tc0MkHPchpAlrnGLSQiEwrbZJonIPYrIND3v626Ojmg/sY3elE212b9ITlEAuJ7aXh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgMIPgoJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgMIPgoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768825005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVsI5wIO3RTclQFH0kwtM74XqsXsdkreqmLb8EV1sdk=;
	b=HgMIPgoJRm3AaliZ6+ZujJ2/71V69lvXoJyGWv+/PNf05ZDW6F9/Da6b+LcvV6lVRM84S2
	3ynOas3j7EzhzDWOO+9CkwEnjcFFKofoI/88Y/QjVavGe+Zf9WudyaZLxrYz+AkchlyItk
	Ht+zKbvywKNowNN/Dt3NOf/qzMrekb4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-iul2BDXdP5SR3snjFSdBug-1; Mon, 19 Jan 2026 07:16:44 -0500
X-MC-Unique: iul2BDXdP5SR3snjFSdBug-1
X-Mimecast-MFC-AGG-ID: iul2BDXdP5SR3snjFSdBug_1768825003
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c5539b9adbcso6274275a12.3
        for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 04:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768825003; x=1769429803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yVsI5wIO3RTclQFH0kwtM74XqsXsdkreqmLb8EV1sdk=;
        b=encM4Efa4GqzckF+DXIl2X/T5WxUY7DYje/uZSovKKEp7DQ6uTMxkRWEgSEx2F1RP7
         qUQjcBS7CvrdwCRlRFcJJzg8VNHOJG3NFo28QXadu9xhBTkjA5M0u7hk7nqQj/Crkyx8
         5hOoTR+8MZNCwnyr1zvstK33Ekg4OE4Ka2n4AA59W7bKmY9jFC5HwF+i4gc2eR89x7gv
         tmmrVwNbiUifnMdLgO9/VtVTBQDo1tGK7DUaVoFihoCAorFK+UjygFtkQPX9+omidG0W
         ktyF1mNkhu2kWwqq9o6NmC1BOfjBKLjgztmTbgUQKzKh4WdCyjpbbeW1pXb1uAd7Upmo
         AJ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwLWBsQzELfoYG0Aaix/Zc35uJo5U1QjlKneuZWxJuvmGkl9a13YepQ/d5YaH5j9ggDtRJj/A=@lists.linux.dev
X-Gm-Message-State: AOJu0YydCeslnFj7lixXp1vLKbU9gWdQG7CityaW/WNB5x9Z7qGljzYG
	qrObzSh9JKAhGo41Kd1yQ5TDynNaYg0CJr16jVdi2vq/eOrFjomFYmaK3dcyL/AAzqvn9a9pe0r
	grTpCIamqd3qXk5SBK5VffFhDKg+rwPQny4Uw8SA4U6GFrEk6Sg2ibN4MVQ==
X-Gm-Gg: AY/fxX5+JLBH+449X89sKw93TNNwUgRwf26mQ0oEhW7Qhbtz614YKR1Zc6AFfcRBAWW
	r/gXkl8lQgzo8eHi/yc+eVTZ0vhnK1h+aqolCwMj5YJKUc/TPceiyons26mU6ZY3kzDx59Z0x/G
	0JZ/zezf/Hy2jP5F8qPXy3SntHX8pSYetpNXedC6SNz1bO73SE8ppUHhOBGApyLyM+vFcZnMzLV
	xG9anaqdcszmKaW0zmQs2dZiUl/O507JSXvqXdHNnl2BYwJ3CMDNQsCoyKeGDx/wsRRp6evOQyJ
	3M+2abj5+5mh93qpmilXkJT+hxssuAY3qab7rtp2t0AlYf8U/6rey+kIbgX4qajYHlC/qsRSeu2
	cmvdOq8aqEm0=
X-Received: by 2002:a05:6a21:70cb:b0:38d:f439:519c with SMTP id adf61e73a8af0-38dfe605a4cmr10498116637.25.1768825002820;
        Mon, 19 Jan 2026 04:16:42 -0800 (PST)
X-Received: by 2002:a05:6a21:70cb:b0:38d:f439:519c with SMTP id adf61e73a8af0-38dfe605a4cmr10498080637.25.1768825002421;
        Mon, 19 Jan 2026 04:16:42 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf130f1csm9179328a12.0.2026.01.19.04.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 04:16:41 -0800 (PST)
Message-ID: <598750f9-5df5-4f29-8912-2c20d929b82c@redhat.com>
Date: Mon, 19 Jan 2026 20:16:30 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 44/47] arm_mpam: Add workaround for T241-MPAM-1
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
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-45-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-45-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mFvBgEV3zAl3dG0GMItLeSRMWdQXxAz7PAstZvv1-SA_1768825003
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:59 AM, Ben Horgan wrote:
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
> [ morse: Merged the min/max update into a single
>    mpam_quirk_post_config_change() helper. Stashed the t241_id in the msc
>    instead of carrying the physical address around. Test the msc quirk bit
>    instead of a static key. ]
> 
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
> return err from init
> Be specific about the errata in the init name,
>    mpam_enable_quirk_nvidia_t241 -> mpam_enable_quirk_nvidia_t241_1
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  2 +
>   drivers/resctrl/mpam_devices.c              | 88 +++++++++++++++++++++
>   drivers/resctrl/mpam_internal.h             |  9 +++
>   3 files changed, 99 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index a7ec57060f64..4e86b85fe3d6 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -246,6 +246,8 @@ stable kernels.
>   +----------------+-----------------+-----------------+-----------------------------+
>   | NVIDIA         | T241 GICv3/4.x  | T241-FABRIC-4   | N/A                         |
>   +----------------+-----------------+-----------------+-----------------------------+
> +| NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/A                         |
> ++----------------+-----------------+-----------------+-----------------------------+
>   +----------------+-----------------+-----------------+-----------------------------+
>   | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
>   +----------------+-----------------+-----------------+-----------------------------+
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 5f741df9abcc..bdf13a22d98f 100644
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
> @@ -1465,6 +1551,8 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>   		mpam_write_partsel_reg(msc, PRI, pri_val);
>   	}
>   
> +	mpam_quirk_post_config_change(ris, partid, cfg);
> +
>   	mutex_unlock(&msc->part_sel_lock);
>   }
>   
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index d60a3caf6f6e..9d15d37d4b5a 100644
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
>   				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	| \
>   				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff)
>   
> +#define MPAM_IIDR_NVIDIA_T241	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0x241)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b)
> +

An error reported by checkpatch.pl as below.

ERROR: Macros with complex values should be enclosed in parentheses
#205: FILE: drivers/resctrl/mpam_internal.h:247:
+#define MPAM_IIDR_NVIDIA_T241	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0x241)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b)


>   /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>   enum mon_filter_options {
>   	COUNT_BOTH	= 0,

Thanks,
Gavin

