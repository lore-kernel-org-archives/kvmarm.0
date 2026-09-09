Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A9D339394
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 04:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788928166; cv=none; b=QCHzeNQBitbyL6kVKcM/5Geyv5HPu2nCCT3kaEEl1dVsG7HmsldteYw5FRRhnEeHR97Sgo7F1DodUfZ+Cpb32PwtJgnt4irdXkOYtoX4BNmxdAbqU6sgSjLUushi3CKggk0ipqP27WYoDlx0ZQwhiZJ3dB4ETdWQP8EvG50+j2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788928166; c=relaxed/simple;
	bh=WTn05/4QycXhxqRWks5EqAjlR8e86BCzz+vfMc6TDRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odjKCBvWg52/2bR6Zv8JoADfunF3epcrAYgA2+3n3YC2zMrS0b2eCxApeX/5WfMbhuURtfxa2h/aNp1kxbiy42Ic9BUyxN0pclmJtl/FEB7D40F/rQAF1tOUB6OMcytAuC+ApEGBnC8W/DINELFEOpJF9mG4Cxt7JV72Zc/xDno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LGUi96nV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGUi96nV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788928163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nh6M4VZCYgC4q2LdczwdgMA5ELYVwccRqILicmGF2f4=;
	b=LGUi96nVVP5ewTjOaQk1h7clWnXbVLTE6Wnzm1CS76i3AATFVCPI9brEI3jny+hL4fwGNs
	KMuAnmHtQXEcG4zxcSMKPWSaUYM8VXPq4Cm/LZ45eRK5eD+o2goVDYpon3QlivOoUYiain
	fz/fL1+RztXS+a9SVnLI5LQIyd26Z8g=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-FkRvuHvvOOuvNntj-D-hLQ-1; Wed, 09 Sep 2026 00:29:22 -0400
X-MC-Unique: FkRvuHvvOOuvNntj-D-hLQ-1
X-Mimecast-MFC-AGG-ID: FkRvuHvvOOuvNntj-D-hLQ_1788928161
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398ba5404d2so1057068a91.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 21:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788928161; x=1789532961;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nh6M4VZCYgC4q2LdczwdgMA5ELYVwccRqILicmGF2f4=;
        b=KrNnzR6BbbN9MUPIS9pc6jhqyV1T1HEO/Wl77umtbKDvu05xXrP6o7HFKRpebyxuqE
         sChYGZIQkaaSgzRfwAIWIgGIAVQsycAdRHJ3XoidKj9gygkjYcc+OA7u3/N5tmMp9fW2
         SrqZuvFIk2od3OIi7d3UiGrTew4Zn2CUDumB4WwhOJEl5pI1Pn9h5DhZR0iwvix3v143
         j8SADhvarkixe3i/JNe/yFz2CiDRptQwAjhyyRNGRKkWD8XWblEJpVtjXoqUMtxpDCDS
         o9fAJ6p8Tw0NKATNqHYzIqKFonCo+JF8bw4VIcGcOhS+knlkACtAPoAB/RhYXmvZYkOM
         JOdA==
X-Forwarded-Encrypted: i=1; AKwUvBygQBDQ547GuDiD0rHx3DipdbQCbNoCsfnJN9/miTCILkITKuevvomulbIRy28zgwnOC9gSDqM=@lists.linux.dev
X-Gm-Message-State: AFuF++nLK2rcQBvi2w4NgsvvpJCOVty2fGWPYtA6HFxnEHF+B625E1em
	AboTt8ByFP47WJ2F81+oTgZj4RkV7rjid7Y+9r2miyAhXoWOBH78SaVb05nfRS8//sFPcJW2yjf
	x2HHjKn47PCMMJ+iSRvsSaZgZb7ICtYEercNt9haKkVJhBmACcX0IRpStNg==
X-Gm-Gg: AYBFou2/9wiC/hSygQBV3w2n83AJU5FEfpFogKSHD0ZxrKSE7LA4KL33Fvvhc65ZQiv
	nJt5PwAzMLibRPMokvc383uFRHO2B9LlJpCHVMIDB41r0posfMJliHYrTmSNii5UtZ06dyLhea9
	ApaBrd35xX9WxNOlHLb4WC/XbvwksYg+szjLDdDj4k48vKEI7qTxhWJ0PgpgGJL5v0pnJ2mQzcO
	rRFDb3xNtMKesnmzUb0bDDwTsYFq/CMIP4QyKITrnVcsoy6ccO0A4e/vhlHMMz9c9vWRqkFz5zK
	ZaOHbqYx4L9XIgZZq1vHm4fENXVQQ/AU9y5j34Sjad2BWNQYFwfh71nS1uKrVnLpdxBmw2SkE0g
	5l9IBM7olA0R7/DSEU8rlI9YcGsm9ukc854cvrY8spQ==
X-Received: by 2002:a17:90b:564c:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-39b2612338dmr54737951a91.4.1788928160884;
        Tue, 08 Sep 2026 21:29:20 -0700 (PDT)
X-Received: by 2002:a17:90b:564c:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-39b2612338dmr54737906a91.4.1788928160430;
        Tue, 08 Sep 2026 21:29:20 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ba0a7b2c3sm5544813a91.0.2026.09.08.21.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 21:29:19 -0700 (PDT)
Message-ID: <aac304fa-a371-4210-8703-74281c9748f8@redhat.com>
Date: Wed, 9 Sep 2026 14:29:08 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 5/7] firmware: arm_rmm: Activate the RMM
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-6-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260907095942.1140734-6-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -te6I8FS7jcqbIl75b4iQRchKbUX0TlNhoCXETMRW3g_1788928161
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki,

On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Activate the RMM after the basic configuration. This is a memory transferring,
> stateful operation.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v16:
>   * Split into a new patch
> ---
>   drivers/firmware/arm_rmm/rmi.c | 17 +++++++++++++++--
>   include/linux/arm-rmi-cmds.h   | 11 +++++++++++
>   2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 42c973c3a98bb..d969c8738efde 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -641,7 +641,8 @@ static int rmi_configure(void)
>   
>   static int __init arm64_init_rmi(void)
>   {
> -	int ret;
> +	int ret = 0;
> +	struct rmi_sro_state *sro = NULL;

Why we need to initialize those local variables ('ret' and 'sro')? :-)
Also, we can use the scope-based cleanup function supported by cleanup.h
for @sro.

	struct smi_sro_state *sro __free(kfree) = NULL;

With the scope-based cleanup in place, we needn't explict 'kfree(sro)' at
end of this function.

>   
>   	/* Continue without realm support if we can't agree on a version */
>   	ret = rmi_check_version();
> @@ -656,7 +657,19 @@ static int __init arm64_init_rmi(void)
>   	if (ret)
>   		return ret;
>   
> -	return 0;
> +	/* Activate the RMM */
> +	sro = kmalloc_obj(*sro);
> +	if (!sro)
> +		return -ENOMEM;

	if (!sro) {
		pr_err("Unable to alloc SRO object for RMM activation\n");
		return -ENOMEM;
	}

> +
> +	ret = rmi_rmm_activate(sro);
> +	if (ret) {
> +		pr_err("RMM activate failed\n");
> +		ret = ret < 0 ? ret : -ENXIO;
> +	}
> +
> +	kfree(sro);
> +	return ret;
>   }
>   
>   /*
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index fed0f3421895d..dea7c7004d35f 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -64,6 +64,17 @@ static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
>   	return res.a0;
>   }
>   
> +/**
> + * rmi_rmm_activate() - Activate the RMM
> + * @sro: Preallocated SRO context to be used
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux error code
> + */
> +static inline long rmi_rmm_activate(struct rmi_sro_state *sro)
> +{
> +	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
> +}
> +

rmi_rmm_acvivate() would be used for once by rmi.c::arm64_init_rmi(). Lets
not expose the function by combining the logic to rmi.c::arm64_init_rmi().

>   /**
>    * rmi_features() - Read feature register
>    * @index: Feature register index

Thanks,
Gavin

