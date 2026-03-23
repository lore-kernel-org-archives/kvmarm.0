Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0F737649D
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 22:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774306191; cv=none; b=Bw1/3iUNhMjJSrvPtmzpch3JilgH+JgQuLoua4YAhuWNb7ZJbRTxkzE1TU4Gu/+4GM5ib+Y4BCJ6LuAW+dQJryEvxzlGH6qhLmxP7X+LnxryHtDgAkVJipUk3QrUBz+MUg2r0NrfZxao2RlNawJz7U9qhcJTg/2ThYMbCfL2wws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774306191; c=relaxed/simple;
	bh=CWwK4Tm6E69NVJb7lwc4kj65ZUlUbfZH69SjivY7RiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CClce5PCRwsF3oOxzoHINF4TrCARTTyfmSwb+iQD80B0BhXaUsSI4uvfv7OnxaOZwBq3uuH06AFW1COPyPYs8ILA99DNaGjMK91I5a9KtSDWL6PL2nKM7c8lNJa2Z/AaZwsndCb5M5QJsWm8O5bvbWJjsqqSWtCFbbDR9/CtwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixpDs1u6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixpDs1u6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774306188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TOwEUV/+/IiwRIdM5bNrsbwxqPiiVpPpeKsMREHuJ0s=;
	b=ixpDs1u6chAoZKLYc/ziv2JfcaQfCmwhYBn+tNnOmSd8AH0WfqlCHOkJSlobL6iFTwiA82
	txri1v3sOH0ZcBHn/HCEa/hoiyrp9tD+ttMu/1CmCNnY5aJshUj9bM7h5pkZgimwoxZBvo
	On+18hZbCv/n0fFtOLbVvyVUU+24j5Y=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-9gJ7U3GSP96KdFVEzMLgqg-1; Mon, 23 Mar 2026 18:49:47 -0400
X-MC-Unique: 9gJ7U3GSP96KdFVEzMLgqg-1
X-Mimecast-MFC-AGG-ID: 9gJ7U3GSP96KdFVEzMLgqg_1774306186
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2adef9d486bso30206415ad.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774306186; x=1774910986;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOwEUV/+/IiwRIdM5bNrsbwxqPiiVpPpeKsMREHuJ0s=;
        b=DoA8EzelDzuCwDsJ95qEMLRHbmVFB1lyHCo2EoyA+nW8grQjNguKLwUtbn11pF997K
         9QM+IZqq6fIz8X0ZxoNAMcrL+TcU0/Qu0sso8hekZaRc0mOpm2cDQOMJMgVTDtQ369ip
         lUEKV9+5mb/q82V5swLtEItHEN/mIf9nYhR19v7GvJilXhwe+O2FZLYSvVDfGHd332Up
         hJtIdnd6KXQmxBTwTMht4Ag+UHk++VS0j3vqmYuTymw+ZlEFhgQYDmKnr6IZKpA1KKZH
         bClZkafpUzm92Lsn8927TBFOj45VOcfaydhJxpPaPBJONppQt8vsklGIPpTFoqobf9sc
         t0sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVqj4Apy+8L1Tt+/FL27EUxI3FU4Tkx1WCJJLAV5hLj1WFbjExZjvVF2W8Zqox8GuBEMwIDhI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwouD7K6vl8elFqpvdjLnnYjIFI+8C0p/FocL4WPH09DLr0pfCu
	afhqjwxHqpVDFduP10vOfvKlov5wvwAvpYijlMEoNdNZmCvGwDRxCW8U7ewbhMAibK7OPyUDJ4I
	XY6oJK6S2Reh+a5XS++/Jc7tx1OgJXyppUW3hblZZ/k0rBgNBGN4EpsPx+w==
X-Gm-Gg: ATEYQzzwQvDO112+IZppoYayUO+01FRMW33bczFy+/wUDsvyeoOWXMP4ob90/X/D8xt
	QMUDjdDBwBYaChQZYqLPvNkRH14W5bf/xtgwTW2kCI1mngIGAG39aiZKqoxfi7s0HYpqEYcNJjR
	4s/EfmmyfkEbveXBWrm+UemU2z3gpbb0k5qQjJQ4DH6vzJULlpaZfOirGVacq62KVD3IYP5GGtC
	QUBEeRJT0wzWdPkQZaYpWRzW6h/LipGgy8fv4EWFA4YH1LUByqgIycJ2eh/Xr4mdH/qdN/YZeRp
	aEvEcVKlE/rUcB3P9cZDtoFWq3uNUmdvIzcfQ1Ugcimcn0VDdJhddEgyfqe9WGpAFx37ZzbBBYv
	nbb8HfxW1xkuM5BsHknEbX1J6245E9LbCEJcYO7Bk3cS70PJX8hgRjI3tK7xrqT6M
X-Received: by 2002:a17:902:ce82:b0:2b0:6f20:8044 with SMTP id d9443c01a7336-2b0827e94edmr130458465ad.43.1774306186320;
        Mon, 23 Mar 2026 15:49:46 -0700 (PDT)
X-Received: by 2002:a17:902:ce82:b0:2b0:6f20:8044 with SMTP id d9443c01a7336-2b0827e94edmr130458205ad.43.1774306185890;
        Mon, 23 Mar 2026 15:49:45 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08369617dsm155881845ad.71.2026.03.23.15.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:49:45 -0700 (PDT)
Message-ID: <bd450f1f-05a3-44d6-9bbc-1c48d967baa4@redhat.com>
Date: Tue, 24 Mar 2026 08:49:29 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/40] arm_mpam: resctrl: Convert to/from MPAMs
 fixed-point formats
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
 <20260313144617.3420416-23-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-23-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0AWUI1YRascQFnli_hzGfpXAta9Ot5mhzlt9H9s1114_1774306186
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: Dave Martin <Dave.Martin@arm.com>
> 
> MPAM uses a fixed-point formats for some hardware controls.  Resctrl
> provides the bandwidth controls as a percentage. Add helpers to convert
> between these.
> 
> Ensure bwa_wd is at most 16 to make it clear higher values have no meaning.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Ensure bwa_wd is at most 16 (moved from patch 40: arm_mpam: Generate a
> configuration for min controls)
> Expand comments
> ---
>   drivers/resctrl/mpam_devices.c |  7 +++++
>   drivers/resctrl/mpam_resctrl.c | 51 ++++++++++++++++++++++++++++++++++
>   2 files changed, 58 insertions(+)
> 

One nitpick below, but this looks good to me in either way.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 0e5e24ef60fe..0c97f7708722 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -713,6 +713,13 @@ static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
>   			mpam_set_feature(mpam_feat_mbw_part, props);
>   
>   		props->bwa_wd = FIELD_GET(MPAMF_MBW_IDR_BWA_WD, mbw_features);
> +
> +		/*
> +		 * The BWA_WD field can represent 0-63, but the control fields it
> +		 * describes have a maximum of 16 bits.
> +		 */
> +		props->bwa_wd = min(props->bwa_wd, 16);
> +

16 may deserve a definition for it since it's a constant value and referred
for multiple times in this patch, if we need to give this series another
respin :-)

>   		if (props->bwa_wd && FIELD_GET(MPAMF_MBW_IDR_HAS_MAX, mbw_features))
>   			mpam_set_feature(mpam_feat_mbw_max, props);
>   
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index cab3e9ccb5c7..adaec522c1a1 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -10,6 +10,7 @@
>   #include <linux/errno.h>
>   #include <linux/limits.h>
>   #include <linux/list.h>
> +#include <linux/math.h>
>   #include <linux/printk.h>
>   #include <linux/rculist.h>
>   #include <linux/resctrl.h>
> @@ -242,6 +243,56 @@ static bool cache_has_usable_cpor(struct mpam_class *class)
>   	return class->props.cpbm_wd <= 32;
>   }
>   
> +/*
> + * Each fixed-point hardware value architecturally represents a range
> + * of values: the full range 0% - 100% is split contiguously into
> + * (1 << cprops->bwa_wd) equal bands.
> + *
> + * Although the bwa_bwd fields have 6 bits the maximum valid value is 16
> + * as it reports the width of fields that are at most 16 bits. When
> + * fewer than 16 bits are valid the least significant bits are
> + * ignored. The implied binary point is kept between bits 15 and 16 and
> + * so the valid bits are leftmost.
> + *
> + * See ARM IHI0099B.a "MPAM system component specification", Section 9.3,
> + * "The fixed-point fractional format" for more information.
> + *
> + * Find the nearest percentage value to the upper bound of the selected band:
> + */
> +static u32 mbw_max_to_percent(u16 mbw_max, struct mpam_props *cprops)
> +{
> +	u32 val = mbw_max;
> +
> +	val >>= 16 - cprops->bwa_wd;
> +	val += 1;
> +	val *= MAX_MBA_BW;
> +	val = DIV_ROUND_CLOSEST(val, 1 << cprops->bwa_wd);
> +
> +	return val;
> +}
> +
> +/*
> + * Find the band whose upper bound is closest to the specified percentage.
> + *
> + * A round-to-nearest policy is followed here as a balanced compromise
> + * between unexpected under-commit of the resource (where the total of
> + * a set of resource allocations after conversion is less than the
> + * expected total, due to rounding of the individual converted
> + * percentages) and over-commit (where the total of the converted
> + * allocations is greater than expected).
> + */
> +static u16 percent_to_mbw_max(u8 pc, struct mpam_props *cprops)
> +{
> +	u32 val = pc;
> +
> +	val <<= cprops->bwa_wd;
> +	val = DIV_ROUND_CLOSEST(val, MAX_MBA_BW);
> +	val = max(val, 1) - 1;
> +	val <<= 16 - cprops->bwa_wd;
> +
> +	return val;
> +}
> +
>   /* Test whether we can export MPAM_CLASS_CACHE:{2,3}? */
>   static void mpam_resctrl_pick_caches(void)
>   {

Thanks,
Gavin

