Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8EC2512E6
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768825149; cv=none; b=tQJPZwyVrDZjeotuKPboZqPz+J7l/K1qWS+w8y+6NpkziBo4X369wj5HVm7Icdm1hDYJUbeWlv39Y19zuc+vSviH38xAhEEXsKfll/MVAv5jbqS/ThcCsDi7LjHs2iXyjgNLItX9p0Ia/W9U9GqogFonMdvOLUhN87FYX9Le4mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768825149; c=relaxed/simple;
	bh=teXFtXXGk/xNdzpHOe8ZicaUkQF5AxEGCtxNPGNKlv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ICI2Pc3Qo5a0PsjMGS4gYUSMdOdEph0QcudOvUeSk75x+s4gtGQO7xkOaCsKTt4H8s6VDFdaSiR0QKU+ZaU3XsE3gXuf2+uLiKduEBJmNRDGGHNbEBc8wLPT8+PxDWZ6zb0uGJPnYgoFgws2yVguPFMH12LjZJbF8QnUnTLPU+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PuUUAox0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PuUUAox0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768825146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTsb/OUNxM0Yl8TxO7CLRPGc7+/qemhXAp5qIFHps8o=;
	b=PuUUAox0hXqQLy4S1oxQ4mIhDAnDzCVGB4voowfL0KMG1iuvSap/e4v/3TC6i+N8ODj6o7
	Dzo6TLimJ89eHZ30EvnzIUX3Pl3iOZvVeypnilCg+tUBuWqjXn3cC/HIz9rWLkve9T55QT
	hQGK7r9zRcJSLVMYbSoq36jWcblpMvg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-jqyjtS3jOZCvxvGdOroOlQ-1; Mon, 19 Jan 2026 07:19:04 -0500
X-MC-Unique: jqyjtS3jOZCvxvGdOroOlQ-1
X-Mimecast-MFC-AGG-ID: jqyjtS3jOZCvxvGdOroOlQ_1768825144
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34ac814f308so6488564a91.3
        for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 04:19:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768825144; x=1769429944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FTsb/OUNxM0Yl8TxO7CLRPGc7+/qemhXAp5qIFHps8o=;
        b=i3HgF6YpFNnuVtq9PwYgfaXOAGmVe4gwzZ/zSbf/ACFwp1BLSygD5joKTWWcaMqDQ1
         uJO2GeJv4nrID59Rm0GQ8NcmyILOUS86wK8krWqq3SHKqq4UuWVHZKoMwjvNNiaDryEi
         ZyGhmX1hfo8TmQAkCnc7CHHt41ULRAxX/SD1BwvQc794+SGkuqEn3nl0iIE5N+F2SpIA
         Zd9HX78NxkKt8cfEVaM67SwmXcWjx90dcZImd9F/sKMkBpyacyZJGNvS8Xst4e+o2R6q
         B94IxPrb5weJH5yKMmeqiCj5bsA2PjYeit5CIxMV4gRv27rAAwLcB0aqsM1ZKrr4olbY
         gcag==
X-Forwarded-Encrypted: i=1; AJvYcCVhL4vz6j9edsVQwN7wxOJ16I5b+PFSh++wr4wVbABL9TqfXEhbuKNtbEs0Zh4NGZMGBwkDPIU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNR/Uff2mg8dZbv7p0yJBy3hoXqrpILOWImXc3OHpULC6HCJ+I
	sEG+MwaCDQv75VixjJoju/4Ly1oyAlC+BiYtXz60/b0Eg/KV+jUOcFIUfPbIvsDAs2UUzL872gN
	W3Hsg56t4b8gHHcihAfvz/mK2EQJu/YCPX80AsIjs/3/uoeiojrJSJ+HjjQ==
X-Gm-Gg: AY/fxX5Rxcyy0b7lUfZJcQt+mVKr1YJ4G3Xs+76TUaEj0lY9INwAjYBLcgZjc0M7i+t
	ODJH4ewKWWAT1swDAEncnLN+O1M5bBFm6NZvdIxHmzOYbFJ7D/x/RefjNDdKVZHR0QRidZe6Fs7
	7W+ZSL++Zp1tUHrYt0mXw+N0k2dVdyVc+za5p3LXSGcNzSvadmL47aST7XypRH0yloAyr9OLreb
	65vhpIJkQof5cMO92COF5hAH76ZNcky4ak+4J3UQpGLDTyRYy/wBwh8FDisfCDd0AoYUFBndqOo
	fxP9TqW+XGOLLAPsQNT5fcGY+EIYug96P3dgPBKGwBUTr5cz4X+cwjOzL4up6eVtDN+BCD2ay46
	nObxSi4jC4Ag=
X-Received: by 2002:a05:6a21:4ccb:b0:366:14b0:1a2f with SMTP id adf61e73a8af0-38dfe7c6bc4mr11049687637.61.1768825143686;
        Mon, 19 Jan 2026 04:19:03 -0800 (PST)
X-Received: by 2002:a05:6a21:4ccb:b0:366:14b0:1a2f with SMTP id adf61e73a8af0-38dfe7c6bc4mr11049665637.61.1768825143365;
        Mon, 19 Jan 2026 04:19:03 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf32d1f1sm8972189a12.22.2026.01.19.04.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 04:19:02 -0800 (PST)
Message-ID: <30b7483d-abaa-4668-95bd-93765c72a1f2@redhat.com>
Date: Mon, 19 Jan 2026 20:18:50 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 47/47] arm_mpam: Quirk CMN-650's CSU NRDY behaviour
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
 <20260112165914.4086692-48-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-48-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xmiYOPOm7DR6_wZHAyGD7duncj8Au2DxbaJEtcfZ1AQ_1768825144
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:59 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> CMN-650 is afflicted with an erratum where the CSU NRDY bit never clears.
> This tells us the monitor never finishes scanning the cache. The erratum
> document says to wait the maximum time, then ignore the field.
> 
> Add a flag to indicate whether this is the final attempt to read the
> counter, and when this quirk is applied, ignore the NRDY field.
> 
> This means accesses to this counter will always retry, even if the counter
> was previously programmed to the same values.
> 
> The counter value is not expected to be stable, it drifts up and down with
> each allocation and eviction. The CSU register provides the value for a
> point in time.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  3 +++
>   drivers/resctrl/mpam_devices.c              | 12 ++++++++++++
>   drivers/resctrl/mpam_internal.h             |  6 ++++++
>   3 files changed, 21 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index e810b2a8f40e..3667650036fb 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -213,6 +213,9 @@ stable kernels.
>   | ARM            | GIC-700         | #2941627        | ARM64_ERRATUM_2941627       |
>   +----------------+-----------------+-----------------+-----------------------------+
>   +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | CMN-650         | #3642720        | N/A                         |
> ++----------------+-----------------+-----------------+-----------------------------+
> ++----------------+-----------------+-----------------+-----------------------------+
>   | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_845719        |
>   +----------------+-----------------+-----------------+-----------------------------+
>   | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_843419        |
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 7409cb7edab4..e6c9ddaa60e2 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -691,6 +691,12 @@ static const struct mpam_quirk mpam_quirks[] = {
>   	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
>   	.workaround = T241_MBW_COUNTER_SCALE_64,
>   	},
> +	{
> +	/* ARM CMN-650 CSU erratum 3642720 */
> +	.iidr       = MPAM_IIDR_ARM_CMN_650,
> +	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
> +	.workaround = IGNORE_CSU_NRDY,
> +	},
>   	{ NULL } /* Sentinel */
>   };
>   
> @@ -1003,6 +1009,7 @@ struct mon_read {
>   	enum mpam_device_features	type;
>   	u64				*val;
>   	int				err;
> +	bool				waited_timeout;
>   };
>   
>   static bool mpam_ris_has_mbwu_long_counter(struct mpam_msc_ris *ris)
> @@ -1249,6 +1256,10 @@ static void __ris_msmon_read(void *arg)
>   		if (mpam_has_feature(mpam_feat_msmon_csu_hw_nrdy, rprops))
>   			nrdy = now & MSMON___NRDY;
>   		now = FIELD_GET(MSMON___VALUE, now);
> +
> +		if (mpam_has_quirk(IGNORE_CSU_NRDY, msc) && m->waited_timeout)
> +			nrdy = false;
> +
>   		break;
>   	case mpam_feat_msmon_mbwu_31counter:
>   	case mpam_feat_msmon_mbwu_44counter:
> @@ -1386,6 +1397,7 @@ int mpam_msmon_read(struct mpam_component *comp, struct mon_cfg *ctx,
>   			.ctx = ctx,
>   			.type = type,
>   			.val = val,
> +			.waited_timeout = true,
>   		};
>   		*val = 0;
>   
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 1680d1036472..0bd323728b53 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -226,6 +226,7 @@ enum mpam_device_quirks {
>   	T241_SCRUB_SHADOW_REGS,
>   	T241_FORCE_MBW_MIN_TO_ONE,
>   	T241_MBW_COUNTER_SCALE_64,
> +	IGNORE_CSU_NRDY,
>   	MPAM_QUIRK_LAST
>   };
>   
> @@ -251,6 +252,11 @@ struct mpam_quirk {
>   				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
>   				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b)
>   
> +#define MPAM_IIDR_ARM_CMN_650	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
> +				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x43b)
> +

An error reported by checkpatch.pl as below.

ERROR: Macros with complex values should be enclosed in parentheses
#105: FILE: drivers/resctrl/mpam_internal.h:255:
+#define MPAM_IIDR_ARM_CMN_650	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x43b)


>   /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>   enum mon_filter_options {
>   	COUNT_BOTH	= 0,

Thanks,
Gavin

