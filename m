Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C431B80B
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 11:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768823876; cv=none; b=qzO/PC80LPFASsElLAQDuU69NUQ0vEIoIq8Hm3D1AmJOQD1JYHOaDwJ4ng/4F85VvTIokHlqmCmlHSK9rWXZuMygn+5RmfUpM9XEgDENo9HiYY5sk+lTpTNc0TBIzU5cd7gURJ5M3zn7IGOr7fTAq7in1wcRZC+QOXlj392dsP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768823876; c=relaxed/simple;
	bh=ulblgWSOXF2tXA6mcL0yllRppHmqyzbHPQK0iYUeQZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkIuYCK7gNEo+qNI0ZjbHaP5jUZawfU3qgDiUyESDIHeRf2VTevFPqgoJwv01wjGPfNwXOCPg9WPBfhHqudVoqYL6+N9CJkk1VxO+B9897srm6ufl1pEBd/ItACuozz+VXYg1VJQOaphoUkIgtmiJIvVUgvjJXJ8/zrM4LM7Mqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ayWhPy4W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayWhPy4W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768823874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+9IZpZgGUVeogte82A4ejnIOQXjpIY+s125+5iF6akQ=;
	b=ayWhPy4WM7r8VzqQ3Xy6/KK70Mu+2aOXSNaLEsYGb34noY+0kMdRvUVsu6xDsIsW7g8YPy
	rSZ8Q+iWMSAOWCpco6YHMsO383ANcw6f2/H0k6OyfnM12arBqsag9kuess4Rm9RRaK4Dwr
	9+3ysv5gScsgFK4ZT/xc3Fzjc44MzOY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-woNwPy4rN3uOmEODzH-dKw-1; Mon, 19 Jan 2026 06:57:52 -0500
X-MC-Unique: woNwPy4rN3uOmEODzH-dKw-1
X-Mimecast-MFC-AGG-ID: woNwPy4rN3uOmEODzH-dKw_1768823872
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-81f53295ac2so7887676b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 03:57:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768823871; x=1769428671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+9IZpZgGUVeogte82A4ejnIOQXjpIY+s125+5iF6akQ=;
        b=tKO8c+dXHRv8R7QKGuj9NnNCshNANRIWNQvkA5izndJhPTE/SWBgFnPW643BaBl9Ux
         eAmmlVBRg2jrZPQH+zRxUx+9XGaD6y8GwVNYY75eWXTQrgNS7k66ff4unVDxluA2NVvZ
         zItU/f0dIo5AE8NYsH49SyA0j2bm/mvzYtDJ4A+zo/Oe8whDkn0eNx0YKVHOoBN5e1Ur
         NKvJD8ZwWBaoCe8CM/EP1XysbXgs8/rRA0wzedFTFTq3KeuJbtdP9BHZhCJXoApp3VJC
         E6Qf9yB9zPgEXtYQnWvXNZflFJX3nl5TV+tAhCD1Bacnw92D9f9ED8IqyldtCRPEm80Y
         2YGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXk5h+D8rDccjtK7HcZjmNqywYJq986lGBHK1JludgY6omtfQqpl1/+TjXp+sWPIecq9BuUekk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZmZz+q12v8vmeI/ChLtMsJy/SXy9WglhaISnQpDNLcMCqTAmJ
	etR8QoIZldLhl9aBhGlbM8yJlbiYwhIsg92t0CvFO1anjsx/p6XdQc/Zm3uWQ2YpJTU5ErrA4WI
	jTf7kRAPyOAQWXPLUYOcRpE8UJ2LELvlc/WYC0jgL4DigjobtctiF2oLGlA==
X-Gm-Gg: AY/fxX7vVTRFWaSeW3dYM+pFX7VJRE2HHrayaSBUUE58HiW/3JPi6oMHybbA786JKSq
	xwWEQAzA3CDHonuVJ2BpSdLcZzC/Z+hRaeSZl8HdMkXk/NL62rBvUKpYVckH7h3Qv0+BIZDBVad
	A4+cZmal97VbsRocatqgkVee2fKldzoQXOmq4DWHK278HiTmzuy+cB4SQZslQ6Wrv1WNtic2VLG
	4VbYfECB3MqAGy6V1ePHW7MG+/zU9BKAdPKShRwI8wX539YosXNm6OcTRmDQzinT8+ODGixYiEt
	/gEeuVydUPGK7YU4cNyz7Tugs+8axayNndEHUDQFhPvhlqUtlpw9zr20DGTIX6x2O/ez4lKPI0j
	fSGTpY89lbF8=
X-Received: by 2002:a05:6a00:6b92:10b0:81f:a860:d665 with SMTP id d2e1a72fcca58-81fa860d831mr6529796b3a.66.1768823871539;
        Mon, 19 Jan 2026 03:57:51 -0800 (PST)
X-Received: by 2002:a05:6a00:6b92:10b0:81f:a860:d665 with SMTP id d2e1a72fcca58-81fa860d831mr6529784b3a.66.1768823871172;
        Mon, 19 Jan 2026 03:57:51 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa12b51d9sm9100204b3a.65.2026.01.19.03.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 03:57:50 -0800 (PST)
Message-ID: <5e20890a-f1f0-4a54-894b-a0e170a8a5f8@redhat.com>
Date: Mon, 19 Jan 2026 19:57:38 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/47] arm_mpam: resctrl: Pre-allocate free running
 monitors
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
 <20260112165914.4086692-31-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-31-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oEKjZzjxEGz9d7sO2wWMCeCSqGGElKyMyLDV7-lTaqU_1768823872
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> When there are enough monitors, the resctrl mbm local and total files can
> be exposed. These need all the monitors that resctrl may use to be
> allocated up front.
> 
> Add helpers to do this.
> 
> If a different candidate class is discovered, the old array should be
> free'd and the allocated monitors returned to the driver.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Code flow tidying (Jonathan)
> ---
>   drivers/resctrl/mpam_internal.h |  8 +++-
>   drivers/resctrl/mpam_resctrl.c  | 81 ++++++++++++++++++++++++++++++++-
>   2 files changed, 86 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 1c5492008fe8..89f9d374ded0 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -360,7 +360,13 @@ struct mpam_resctrl_res {
>   struct mpam_resctrl_mon {
>   	struct mpam_class	*class;
>   
> -	/* per-class data that resctrl needs will live here */
> +	/*
> +	 * Array of allocated MBWU monitors, indexed by (closid, rmid).
> +	 * When ABMC is not in use, this array directly maps (closid, rmid)
> +	 * to the allocated monitor. Otherwise this array is sparse, and
> +	 * un-assigned (closid, rmid) are -1.
> +	 */
> +	int			*mbwu_idx_to_mon;
>   };
>   
>   static inline int mpam_alloc_csu_mon(struct mpam_class *class)
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 14a8dcaf1366..3af12ad77fba 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -572,10 +572,58 @@ static void mpam_resctrl_pick_mba(void)
>   	}
>   }
>   
> +static void __free_mbwu_mon(struct mpam_class *class, int *array,
> +			    u16 num_mbwu_mon)
> +{
> +	for (int i = 0; i < num_mbwu_mon; i++) {
> +		if (array[i] < 0)
> +			continue;
> +
> +		mpam_free_mbwu_mon(class, array[i]);
> +		array[i] = ~0;
> +	}
> +}
> +
> +static int __alloc_mbwu_mon(struct mpam_class *class, int *array,
> +			    u16 num_mbwu_mon)
> +{
> +	for (int i = 0; i < num_mbwu_mon; i++) {
> +		int mbwu_mon = mpam_alloc_mbwu_mon(class);
> +
> +		if (mbwu_mon < 0) {
> +			__free_mbwu_mon(class, array, num_mbwu_mon);
> +			return mbwu_mon;
> +		}
> +		array[i] = mbwu_mon;
> +	}
> +
> +	return 0;
> +}
> +
> +static int *__alloc_mbwu_array(struct mpam_class *class, u16 num_mbwu_mon)
> +{
> +	int err;
> +	size_t array_size = num_mbwu_mon * sizeof(int);
> +	int *array __free(kfree) = kmalloc(array_size, GFP_KERNEL);
> +

A warning reported by checkpatch.pl as below.

WARNING: Missing a blank line after declarations
#84: FILE: drivers/resctrl/mpam_resctrl.c:607:
+	size_t array_size = num_mbwu_mon * sizeof(int);
+	int *array __free(kfree) = kmalloc(array_size, GFP_KERNEL);


> +	if (!array)
> +		return ERR_PTR(-ENOMEM);
> +
> +	memset(array, -1, array_size);
> +
> +	err = __alloc_mbwu_mon(class, array, num_mbwu_mon);
> +	if (err)
> +		return ERR_PTR(err);
> +	return_ptr(array);
> +}
> +
>   static void counter_update_class(enum resctrl_event_id evt_id,
>   				 struct mpam_class *class)
>   {
> -	struct mpam_class *existing_class = mpam_resctrl_counters[evt_id].class;
> +	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evt_id];
> +	struct mpam_class *existing_class = mon->class;
> +	u16 num_mbwu_mon = class->props.num_mbwu_mon;
> +	int *new_array, *existing_array = mon->mbwu_idx_to_mon;
>   
>   	if (existing_class) {
>   		if (class->level == 3) {
> @@ -590,8 +638,37 @@ static void counter_update_class(enum resctrl_event_id evt_id,
>   		}
>   	}
>   
> -	mpam_resctrl_counters[evt_id].class = class;
> +	pr_debug("Updating event %u to use class %u\n", evt_id, class->level);
> +
> +	/* Might not need all the monitors */
> +	num_mbwu_mon = __mpam_monitors_free_running(num_mbwu_mon);
> +
> +	if ((evt_id != QOS_L3_OCCUP_EVENT_ID) && num_mbwu_mon) {
> +		/*
> +		 * This is the pre-allocated free-running monitors path. It always
> +		 * allocates one monitor per PARTID * PMG.
> +		 */
> +		WARN_ON_ONCE(num_mbwu_mon != resctrl_arch_system_num_rmid_idx());
> +
> +		new_array = __alloc_mbwu_array(class, num_mbwu_mon);
> +		if (IS_ERR(new_array)) {
> +			pr_debug("Failed to allocate MBWU array\n");
> +			return;
> +		}
> +		mon->mbwu_idx_to_mon = new_array;
> +
> +		if (existing_array) {
> +			pr_debug("Releasing previous class %u's monitors\n",
> +				 existing_class->level);
> +			__free_mbwu_mon(existing_class, existing_array, num_mbwu_mon);
> +			kfree(existing_array);
> +		}
> +	} else if (evt_id != QOS_L3_OCCUP_EVENT_ID) {
> +		pr_debug("Not pre-allocating free-running counters\n");
> +	}
> +
>   	exposed_mon_capable = true;
> +	mon->class = class;
>   }
>   
>   static void mpam_resctrl_pick_counters(void)

Thanks,
Gavin

