Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB14394497
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774324639; cv=none; b=rPoSL/rkdQMthwQCCP/4A2FyQ0rcm4NfIwOUYx0aTf1AXMSGti0bTnf00URShI6gyqyXEyWflrseiUafZyBjiHtHMO8uOxXP8IwFH7oSqr+M5yufdzLOg69aDZRz6Yt2ZtHiBQ9zmYBtl8R5gj1O8DNH73bVn4FEjlGR74NkqPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774324639; c=relaxed/simple;
	bh=lOsTYNA/eHH8OrNyChTYMxCahwPbNQflEP7N+uBKFWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FMlG9ACzA9vIxCesKF2UxVqTBnk8aiR6ZSEKtVd9HZSoIkG4+W5f86R4Tc4QGw1LVMQT61L2Ny7RIcCq4KC+oR+RW6QeCBZW/aDmvT69fzywSwdeqewg17JCzdJkqDdCJRdwXtaeqN16/izc9crIAf7cvhhbK4Upi1yF9xjS+pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVSlB8hJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVSlB8hJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774324637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vj+l02fs/8pSOJGRhQFKItCXssbRz0B4Wg+/KENQ0kM=;
	b=IVSlB8hJlesTNGoM3O0GrUdIks+XpEsb9SCRRReS/o1NeRpf6jsfgJVyPhHDlYNNDYF27Z
	8Id1JQnoTiUqbbtx8vXYwOleIYWqYPUj5BsWOP2qS8aQ3UALh1OH17+43ak+sTRm+JRGDZ
	QM/NQ5ksUI3BWVYmyEABS6N5BQUq5MQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-QHQnC3r1MOeqzq4BMPiq-A-1; Mon, 23 Mar 2026 23:57:14 -0400
X-MC-Unique: QHQnC3r1MOeqzq4BMPiq-A-1
X-Mimecast-MFC-AGG-ID: QHQnC3r1MOeqzq4BMPiq-A_1774324633
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aeb90532f6so20305395ad.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774324633; x=1774929433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vj+l02fs/8pSOJGRhQFKItCXssbRz0B4Wg+/KENQ0kM=;
        b=G1bgPw2+KzM0xNOeUhu49agKMZvrd1HwYzPVoS+DC19zeMf91p/khUqnCldEAzLKN2
         8E7TB7M9HXLW2vrj04EuHXHQcSkxYhlkPs3M5p7aHSMLbvgATlfGV0u/LGNtyJ59T2kU
         XMlfsEH9DiO5RwPZ8WVPAKUPJIchH0dlf/NnXEMwfoktLAv39UMwLe21A9uLcSjPR5Pf
         uWrPcRLyL8zXQJhmmbRAnbBER3AHRb4UPFUg/dQ5P7jQ/vMFViYD5Tkxq6PR76L1HP0I
         sbwmQV/8XyqBboKGTfGog5yApptwz4iwrImuPPB/O8lZ+AGqGZX7bCwd6saVYyGctAPV
         KAyw==
X-Forwarded-Encrypted: i=1; AJvYcCW611ScxIlag9rWmMTccPw6vpQ9IRfSay2MEHPhsD0sJinjMH8BzB4gB/hD6LLBAJAKKuUcYc4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwDlaQFy3r/gRQIYO/cWd4F9fq3zksmyyEUPXWmaQa92Uoo9YF
	q9J7U8VlWQ3Am4UYDh88EDJyHVrN9R6c4tkRuE6V7eKWplMa0fgfgy516OejrIgIq2tzRniBpUq
	FcCLMmwt5s8PiIaa+vPtd4ErUW/kzUsPFJ5wkwpGfiMoZaIqSiNNeanSf3g==
X-Gm-Gg: ATEYQzwKtEikhV1wlXqh+p6ICobJhbJQz3sIDwp24WMzP9djfXzAcsBAlG0nkDZLgQ6
	dhBYW7ZlWcLvcxGRxXmyGmhtIdMbjTaW7Kf4X6RcKdrrkLwnXbZEPq/qTdZBwd2Noy7QsnrUng0
	G9OWT2Fto7sJGqFcon6RzAAl30U2/zPYe5dsrqG5880ZhybRXRAFazi0KnHHYkmqr+bPx5MNh36
	NoPwgTHel5N5MeaGcF0ZYIpzvkG4OevbSvacASlOZDnsK51f3JWU5JbxJbgIXAMFBK2hnL6cJCz
	EZoVZxZwfPyldcs6EjVaSziOUrsGRCpi+Wg5H+2w+SwU6QCMYD6IH0LeWKjvD0B9k8cmSubBrEc
	+gR+en1mEirW05Y6yylgmvrMudqSZkNQTTAHFPAfXiPg2+M3pwc/TSMMYSxZzQkVz
X-Received: by 2002:a17:903:1b6b:b0:2ae:bf92:5acc with SMTP id d9443c01a7336-2b0826ff359mr136640675ad.3.1774324632873;
        Mon, 23 Mar 2026 20:57:12 -0700 (PDT)
X-Received: by 2002:a17:903:1b6b:b0:2ae:bf92:5acc with SMTP id d9443c01a7336-2b0826ff359mr136640345ad.3.1774324632369;
        Mon, 23 Mar 2026 20:57:12 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083690346sm126192525ad.70.2026.03.23.20.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:57:11 -0700 (PDT)
Message-ID: <b200eaf9-462e-4844-aaf6-2912b956af6c@redhat.com>
Date: Tue, 24 Mar 2026 13:56:57 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 35/40] arm_mpam: Add quirk framework
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
 <20260313144617.3420416-36-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-36-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D2T09t7kXfebu_9w_ChKEuwYGwa0zAGMB0kqOLQbeHw_1774324633
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 3/14/26 12:46 AM, Ben Horgan wrote:
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
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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
> 
> Changes since v3:
> Brackets in macro
> ---
>   drivers/resctrl/mpam_devices.c  | 32 ++++++++++++++++++++++++++++++++
>   drivers/resctrl/mpam_internal.h | 25 +++++++++++++++++++++++++
>   2 files changed, 57 insertions(+)
> 

With the following nitpicks addressed if another respin is needed. This
looks good to me in either way.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 37b31a1cf376..e66631f3f732 100644
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

The initialization on @err is unnecessary if it's checked only when it's
updated (see below). The variable can be avoided.

> +
> +		if (quirk->iidr != (msc->iidr & quirk->iidr_mask))
> +			continue;
> +
> +		if (quirk->init)
> +			err = quirk->init(msc, quirk);
> +
> +		if (err)
> +			continue;

Since @err is only updated by quirk->init(), the following check would be done
only when it's updated. Something like below, @err isn't needed.

		if (quirk->init && quirk->init(msc, quirk)
			continue;

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
> @@ -1972,6 +1999,7 @@ static bool mpam_has_cmax_wd_feature(struct mpam_props *props)
>    * resulting safe value must be compatible with both. When merging values in
>    * the tree, all the aliasing resources must be handled first.
>    * On mismatch, parent is modified.
> + * Quirks on an MSC will apply to all MSC in that class.
>    */
>   static void __props_mismatch(struct mpam_props *parent,
>   			     struct mpam_props *child, bool alias)
> @@ -2091,6 +2119,7 @@ static void __props_mismatch(struct mpam_props *parent,
>    * nobble the class feature, as we can't configure all the resources.
>    * e.g. The L3 cache is composed of two resources with 13 and 17 portion
>    * bitmaps respectively.
> + * Quirks on an MSC will apply to all MSC in that class.
>    */
>   static void
>   __class_props_mismatch(struct mpam_class *class, struct mpam_vmsc *vmsc)
> @@ -2104,6 +2133,9 @@ __class_props_mismatch(struct mpam_class *class, struct mpam_vmsc *vmsc)
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
> index ce9e0e0483fb..e28a168419d4 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -85,6 +85,8 @@ struct mpam_msc {
>   	u8			pmg_max;
>   	unsigned long		ris_idxs;
>   	u32			ris_max;
> +	u32			iidr;
> +	u16			quirks;
>  

It maybe reasonable to have 'u32 quirks' so that 32 instead of 16 quirks can be
supported to the maximal degree. It's known 16 quirks are enough at the moment,
but it's likely to be extended for more space.
  
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
> +#define MPAM_IIDR_MATCH_ONE	(FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0xfff) | \
> +				 FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0xf)	 | \
> +				 FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	 | \
> +				 FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff))
> +
>   /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>   enum mon_filter_options {
>   	COUNT_BOTH	= 0,
> @@ -259,6 +283,7 @@ struct mpam_class {
>   
>   	struct mpam_props	props;
>   	u32			nrdy_usec;
> +	u16			quirks;

As above, it would be "u32 quirks".

>   	u8			level;
>   	enum mpam_class_types	type;
>   

Thanks,
Gavin

