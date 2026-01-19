Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CDC3596F7
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768824902; cv=none; b=e0DtoKLgfjiboK+G0XZDYlZVwcmORgSJyPOocX7Ci+TEhTw8iJ7qDNneU2roRrCQoI2cR8hUZQ9/EfgRhhGt7irEvzfasNVXm3ssHEMJddAeHgLo8Uk3Vi8E4eV2fv6pxkfy8Cdi7VwiySh/+pMUbOf+15GE/gNqBUVlECxprYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768824902; c=relaxed/simple;
	bh=aYzWysRObZXcPMkUCwkQlxIO3xNpAXEBUBG0PSuvULY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqx2BuahcCmlV1zZWqWgDuj+hdI3NSVrIF4qGqbeJHSsiwNLYuR63xOln5htHWSG33MOrJrKjkqPfqkSb90NR1AdKcSnXEZP5JF4pC/vVRh3rs+wj4u4DScsVN4ZHc/Cqp4Y1HUIzLndUTM/+CgsLyapt7GcXRPb7LGsRlPsi4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FR4971Pf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FR4971Pf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768824899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TjSYZsSgMwBmlEAmPa1fBK+S76tlcRHZgOz8xyiW4eA=;
	b=FR4971Pf/13CgRZZQ8BWNCWQ+xbZGRuLjqyerZ00hzzHknSpsC95bCyGbV7j/QoAeEmKcP
	SGdF2A+aQ/9wKYMWKmipnmGNzi2co6rKQoUOZ+WnQ7cmjNc7XvrYRRlhYmXe2HJtdi5EK+
	VJQke4Y9kDZyqXe+Ox5OY2WVFEp1PfU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-6By2Nt2FMvyydoAUbBzN_Q-1; Mon, 19 Jan 2026 07:14:58 -0500
X-MC-Unique: 6By2Nt2FMvyydoAUbBzN_Q-1
X-Mimecast-MFC-AGG-ID: 6By2Nt2FMvyydoAUbBzN_Q_1768824898
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a09845b7faso32316205ad.3
        for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 04:14:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768824897; x=1769429697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TjSYZsSgMwBmlEAmPa1fBK+S76tlcRHZgOz8xyiW4eA=;
        b=taH6HCiJ4W1LtBNI9C3Hx2ma0bE1A2+Ag0Sq6ehRPIBlkJmGJ8gAF5YvcjFPPYvp+a
         waP89kJaKs0EoYLBTw3yQZm4pdURvvcXh+4aS34aHBTA3u8Ib4t1K22CLHhdjWtyXCNC
         QSIKVv7dTUGfv7f+fLOjYtAy1XT5hQdj1xeAaYZ2g2xWuOiSaMItedDeE2cl9qrQPK+e
         j+fLOkdkA1BJlWNNgGFqkY3yxOLo+vj8I/e6xUz9ruQSnjOcxSaK1yVipbywd7OhEX5r
         ZHI9XXSq72VlymqAlw3T+ojAKDLCBlT8qyQwcbBt5YouQcmH0R98aMfBbA7JxvTzwqHr
         xC8A==
X-Forwarded-Encrypted: i=1; AJvYcCXZrjnYALFromzRrv5w3L2OlhybnWT2vGZ8JKv/Lm7QvVe+Nbt5ZQiVq5PWSV0B+oDMM4VV2iM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7W2rikphVN9LQmHkFHtTPpyusQYTUQmGFIRJfgSDHFRX6rLJW
	4UwkfFyeLCQ8aACSvS8frtL41QQBxHFYTCYSrjPx45JH7YkvRQKxFj73eGl/brOPjoPsnqGFDXQ
	LPUYT7PXmlwJMStUxQ/vP/5HukkWiyyKfGzJV0x4e0BEXP5WfCWPyjeAvAQ==
X-Gm-Gg: AZuq6aIvxD8id56BppLFw9P9U4rIMw7lacODdnD56wvsGd/HDuWqBKZ7cNUYruM56c9
	9S8uefp9qbqYSzOT2R/NrLlLtQXi4Ej+dYj20dL6DcjcAvLzaIHKyOTilO13IltntStyI8TWxoX
	gGlJYwNhSfA2NBX70ZX1LjWUNfd2Y6H+cfhBhHDqyQrT2MR5ophXDiqpuqCSQpAQAEgHrZWupFI
	t+U4TllqA3rAM5ZldBC2Ya4E3nKYJXDg6a1Ae3HZo+qFu2ELy1WX2p3Y3Jtbkib4upq7kBypvXx
	2M8fdg+62QGHGjoyNClnI36P2GHFmZFfTq62aS1XYohdlgwqoc8IHWBjIGu8sPozY8GjSmYLGke
	cixVribPlGbY=
X-Received: by 2002:a17:903:2410:b0:2a1:2ed4:ca1e with SMTP id d9443c01a7336-2a718928c6bmr95119645ad.34.1768824897313;
        Mon, 19 Jan 2026 04:14:57 -0800 (PST)
X-Received: by 2002:a17:903:2410:b0:2a1:2ed4:ca1e with SMTP id d9443c01a7336-2a718928c6bmr95119245ad.34.1768824896850;
        Mon, 19 Jan 2026 04:14:56 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193fb239sm94069725ad.70.2026.01.19.04.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 04:14:55 -0800 (PST)
Message-ID: <d8171bcf-1039-4487-879d-aa07487c9ff5@redhat.com>
Date: Mon, 19 Jan 2026 20:14:44 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 43/47] arm_mpam: Add quirk framework
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
 <20260112165914.4086692-44-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-44-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9a0NvLVKQTKSJQjqoA9MMSMgzmBKL5ukVNey4bZ-4lA_1768824898
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:59 AM, Ben Horgan wrote:
> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> The MPAM specification includes the MPAMF_IIDR, which serves to uniquely
> identify the MSC implementation through a combination of implementer
> details, product ID, variant, and revision. Certain hardware issues/errata
> can be resolved using software workarounds.
> 
> Introduce a quirk framework to allow workarounds to be enabled based on the
> MPAMF_IIDR value.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Co-developed-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Co-developed-by: James Morse <james.morse@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes by James:
> Stash the IIDR so this doesn't need an IPI, enable quirks only
> once, move the description to the callback so it can be pr_once()d, add an
> enum of workarounds for popular errata. Add macros for making lists of
> product/revision/vendor half readable
> 
> Changes since rfc:
> remove trailing commas in last element of enums
> Make mpam_enable_quirks() in charge of mpam_set_quirk() even if there
> is an enable.
> ---
>   drivers/resctrl/mpam_devices.c  | 32 ++++++++++++++++++++++++++++++++
>   drivers/resctrl/mpam_internal.h | 25 +++++++++++++++++++++++++
>   2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 37bd8efc6ecf..5f741df9abcc 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -630,6 +630,30 @@ static struct mpam_msc_ris *mpam_get_or_create_ris(struct mpam_msc *msc,
>   	return ERR_PTR(-ENOENT);
>   }
>   
> +static const struct mpam_quirk mpam_quirks[] = {
> +	{ NULL } /* Sentinel */
> +};
> +
> +static void mpam_enable_quirks(struct mpam_msc *msc)
> +{
> +	const struct mpam_quirk *quirk;
> +
> +	for (quirk = &mpam_quirks[0]; quirk->iidr_mask; quirk++) {
> +		int err = 0;
> +
> +		if (quirk->iidr != (msc->iidr & quirk->iidr_mask))
> +			continue;
> +
> +		if (quirk->init)
> +			err = quirk->init(msc, quirk);
> +
> +		if (err)
> +			continue;
> +
> +		mpam_set_quirk(quirk->workaround, msc);
> +	}
> +}
> +
>   /*
>    * IHI009A.a has this nugget: "If a monitor does not support automatic behaviour
>    * of NRDY, software can use this bit for any purpose" - so hardware might not
> @@ -864,8 +888,11 @@ static int mpam_msc_hw_probe(struct mpam_msc *msc)
>   	/* Grab an IDR value to find out how many RIS there are */
>   	mutex_lock(&msc->part_sel_lock);
>   	idr = mpam_msc_read_idr(msc);
> +	msc->iidr = mpam_read_partsel_reg(msc, IIDR);
>   	mutex_unlock(&msc->part_sel_lock);
>   
> +	mpam_enable_quirks(msc);
> +
>   	msc->ris_max = FIELD_GET(MPAMF_IDR_RIS_MAX, idr);
>   
>   	/* Use these values so partid/pmg always starts with a valid value */
> @@ -1993,6 +2020,7 @@ static bool mpam_has_cmax_wd_feature(struct mpam_props *props)
>    * resulting safe value must be compatible with both. When merging values in
>    * the tree, all the aliasing resources must be handled first.
>    * On mismatch, parent is modified.
> + * Quirks on an MSC will apply to all MSC in that class.
>    */
>   static void __props_mismatch(struct mpam_props *parent,
>   			     struct mpam_props *child, bool alias)
> @@ -2112,6 +2140,7 @@ static void __props_mismatch(struct mpam_props *parent,
>    * nobble the class feature, as we can't configure all the resources.
>    * e.g. The L3 cache is composed of two resources with 13 and 17 portion
>    * bitmaps respectively.
> + * Quirks on an MSC will apply to all MSC in that class.
>    */
>   static void
>   __class_props_mismatch(struct mpam_class *class, struct mpam_vmsc *vmsc)
> @@ -2125,6 +2154,9 @@ __class_props_mismatch(struct mpam_class *class, struct mpam_vmsc *vmsc)
>   	dev_dbg(dev, "Merging features for class:0x%lx &= vmsc:0x%lx\n",
>   		(long)cprops->features, (long)vprops->features);
>   
> +	/* Merge quirks */
> +	class->quirks |= vmsc->msc->quirks;
> +
>   	/* Take the safe value for any common features */
>   	__props_mismatch(cprops, vprops, false);
>   }
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 69cb75616561..d60a3caf6f6e 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -85,6 +85,8 @@ struct mpam_msc {
>   	u8			pmg_max;
>   	unsigned long		ris_idxs;
>   	u32			ris_max;
> +	u32			iidr;
> +	u16			quirks;
>   
>   	/*
>   	 * error_irq_lock is taken when registering/unregistering the error
> @@ -216,6 +218,28 @@ struct mpam_props {
>   #define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
>   #define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)
>   
> +/* Workaround bits for msc->quirks */
> +enum mpam_device_quirks {
> +	MPAM_QUIRK_LAST
> +};
> +
> +#define mpam_has_quirk(_quirk, x)	((1 << (_quirk) & (x)->quirks))
> +#define mpam_set_quirk(_quirk, x)	((x)->quirks |= (1 << (_quirk)))
> +
> +struct mpam_quirk {
> +	int (*init)(struct mpam_msc *msc, const struct mpam_quirk *quirk);
> +
> +	u32 iidr;
> +	u32 iidr_mask;
> +
> +	enum mpam_device_quirks workaround;
> +};
> +
> +#define MPAM_IIDR_MATCH_ONE	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0xfff)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0xf)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff)
> +

An error reported by checkpatch.pl as below.

ERROR: Macros with complex values should be enclosed in parentheses
#135: FILE: drivers/resctrl/mpam_internal.h:238:
+#define MPAM_IIDR_MATCH_ONE	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0xfff)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0xf)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff)



>   /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>   enum mon_filter_options {
>   	COUNT_BOTH	= 0,
> @@ -259,6 +283,7 @@ struct mpam_class {
>   
>   	struct mpam_props	props;
>   	u32			nrdy_usec;
> +	u16			quirks;
>   	u8			level;
>   	enum mpam_class_types	type;
>   

Thanks,
Gavin

