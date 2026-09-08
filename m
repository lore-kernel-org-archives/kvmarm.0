Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C884390613
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 07:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851066; cv=none; b=d9jtaASURU2ctOfz8JkaQU76V6f3D9kwCWqYiwQkPucjDwZrUNVKdmlY8FL/zbjfZvNV1+E99bLN11lr3k6e7X/Ycts/nRMn1PBeWX8gQl49sFRvx6yZrTtQ45SyvJKwhtUtXbbSYrT2YhpkIqkxijsQgz85JsGbNIH+5mjbuko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851066; c=relaxed/simple;
	bh=qrkomyrl64HLPxtqsg1h0AiBeTvAcyfrPyl9zzD9wqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=josjsnnlFx79ItkepEBpwKnC+YzDB+wwlio0dx876IHopF6A/Fi7qy4LkkaLDmXtJcKYMhJTZbwk54O81FRuSUAtfIvQd/NyGWYTYm5YjliGXZiR9cSslRR3nSymUyPZrodgv9DGyMkY43nZ7Klf/HyG9GpGNtk0F05rHttbV/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PVAPFNs7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PVAPFNs7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788851064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ol8taRaXNtmTj+LU+cXQwn5fB81XYMucQnFv/vJC8fU=;
	b=PVAPFNs7m/Fc7hRZVn+eU0UkpINPLiE/gejR7Pw3FFyiOvUlgamk67HvsTe0OBhwczfqNT
	qSwKfKLhcbCHg7Vlcg1TAIDRU064F54TWeWJhPoRx4RK93cr6HAvCsWp3yY2eyI7wMKrbo
	k+YNZG81qXbT/wQau2CKyEk5ZzgAfy0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-WqXIdM4iMQWh_El01bRsdw-1; Tue, 08 Sep 2026 03:04:23 -0400
X-MC-Unique: WqXIdM4iMQWh_El01bRsdw-1
X-Mimecast-MFC-AGG-ID: WqXIdM4iMQWh_El01bRsdw_1788851062
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dbf293831so9007343a91.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 00:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788851062; x=1789455862;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ol8taRaXNtmTj+LU+cXQwn5fB81XYMucQnFv/vJC8fU=;
        b=gZPW1bfSbfWyJwqfNhi5VDvmbsFhZYQlgKHm587DSIjT9y7DpKL8Wmokqr9mlMciIV
         s8QZC7lrn3mo1dAcEcP56vA2mva9nYMl8ADp2xfj+x23NvqPx952NrGBedggsxSAGkvJ
         dv+N/h/MmYg1nL5NX6vjsurWBzIR+t0A3gyDnK5DRllnfKis68UcRz5B85AupojUl6ZJ
         79i9kZsWcPLAbf5QchcykKxSiVWjtwwxxEw3+sj0Y4FQCCaot195y1bq4ixETT6i/iWQ
         RJVdcp6fyLY82pbgxoCPzWFgrLs5WvVNrA6pOi04w0CZm7bk+bca2FCwHbEhuRX6XLBH
         Ot1Q==
X-Forwarded-Encrypted: i=1; AKwUvBx6jV4ZHwY0u7lLAMkLrroUJabNrIVK7n5BQK/Ka/xBslpyGVqp1Q3HZNz8CTDttbEBbtmPY7o=@lists.linux.dev
X-Gm-Message-State: AFuF++kHvrpyxfCxbLHA393r6AhYpCthan2ONM3noGk97lILQnNB70v2
	ZXe6oXMPBnY+49k7TxPLg/XNhZDzyaWizNVfZomQPndFDxlPAutWQszRYoGOTV0CxVBGWrtYYBx
	rKm4r1G4NraQBadQCQX3KEZygGLmDptoPXBvQlP7WEwtelF+iQQ8n5xOn2vPE4zrmMg==
X-Gm-Gg: AYBFou0FVkf/jyflQ+TKeSYSB2f/pP0JP+i3zIPmHgRK4U2wQQbwSCNlmwQLmmseDbS
	Bg/BQJ5gpshhcLKh7sgtWoAmk7NaWQlNOuiFUR75wJ4rMrOlZj0rD+GMUcAu5uqShBWJs4Hit9h
	PYi0TmjJ/J9jSfyVn9uYZOrKZ/xpaTWrng16qC2555TEUcBzAqQ4uX6M0GNkNmLeWcgJFzzGPXW
	3azvs74EqhN2G20CQ6AHZQDximO3ljDNgmTKfSZIpbkVzM8ZR3oMBua8+73b1a2U327zV7Qq7yJ
	jIqbsWRFckOHvJYaXvi9Dgxn4IwkK42iN/ZM+hRygBhoiYfnA/yOvrYV+5MFvTMyBMMRoCWJyuA
	qv6dEs1MQnQlvo3O7zYP7PISo47LwtyBpZwl2jYoYfQ==
X-Received: by 2002:a17:90b:43:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-39b26141c79mr43891699a91.11.1788851061754;
        Tue, 08 Sep 2026 00:04:21 -0700 (PDT)
X-Received: by 2002:a17:90b:43:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-39b26141c79mr43891602a91.11.1788851061212;
        Tue, 08 Sep 2026 00:04:21 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08bcc081sm30955490a91.6.2026.09.08.00.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 00:04:19 -0700 (PDT)
Message-ID: <10893135-4757-44de-91b5-180a9774d868@redhat.com>
Date: Tue, 8 Sep 2026 17:04:08 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
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
 <20260907095942.1140734-4-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260907095942.1140734-4-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VoZsivAMB5DS-2N0TKQXYzF7MfwNBea0wC23lNIZpCA_1788851062
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki,

On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> RMM v2.0 brings the ability to set the RMM's granule size. Check the
> feature registers and configure the RMM so that it matches the host's
> page size. This means that operations can be done with a granularity
> equal to PAGE_SIZE.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Changes since v15:
>    * Actually check the feature register for the host's page-size support.
>   Changes since v14:
>    * Move the implementation into drivers/firmware/arm_rmm.
>   Changes since v13:
>    * Moved out of KVM.
> ---
>   drivers/firmware/arm_rmm/rmi.c | 58 ++++++++++++++++++++++++++++++++++
>   include/linux/arm-rmi-cmds.h   | 17 ++++++++++
>   2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 008a783407b4e..76f91c145e1fd 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -77,6 +77,60 @@ static int rmi_read_features(void)
>   	return 0;
>   }
>   
> +static int rmi_configure(void)
> +{
> +	unsigned long granule_feature;
> +	unsigned long granule_size;
> +	int ret = 0;
> +	struct rmm_config *config;
> +
> +	switch (PAGE_SIZE) {
> +	case SZ_4K:
> +		granule_size = RMI_GRANULE_SIZE_4KB;
> +		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB;
> +		break;
> +	case SZ_16K:
> +		granule_size = RMI_GRANULE_SIZE_16KB;
> +		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB;
> +		break;
> +	case SZ_64K:
> +		granule_size = RMI_GRANULE_SIZE_64KB;
> +		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB;
> +		break;
> +	default:
> +		BUILD_BUG();
> +	}
> +
> +	if (!(rmi_feat_reg(1) & granule_feature)) {
> +		pr_err("RMM does not support %luKB granules\n",
> +		       PAGE_SIZE >> 10);
> +		return -ENXIO;
> +	}
> +
> +	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
> +	if (!config)
> +		return -ENOMEM;

An error message is needed here.

	if (!config) {
		pr_err("Unable to alloc RMM config memory\n");
		return -ENOMEM;
	}

> +
> +	config->rmi_granule_size = granule_size;
> +
> +	/*
> +	 * For now we set the tracking_region_size to 0 which is the only option
> +	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
> +	 * TODO: Support other tracking sizes via Kconfig option for other
> +	 * PAGE_SIZES
> +	 */
> +	config->tracking_region_size = 0;
> +
> +	ret = rmi_rmm_config_set(virt_to_phys(config));
> +	if (ret) {
> +		pr_err("RMM config set failed\n");
> +		ret = -EINVAL;
> +	}

The error code from rmi_rmm_config_set() is indicative sometimes. Also, -ENXIO
would be more appropriate than -EINVAL?

	if (ret) {
		pr_err("RMM config set failed (%d)\n", ret);
		ret = -ENXIO;
	}

> +
> +	free_page((unsigned long)config);
> +	return ret;
> +}
> +
>   static int __init arm64_init_rmi(void)
>   {
>   	int ret;
> @@ -90,6 +144,10 @@ static int __init arm64_init_rmi(void)
>   	if (ret)
>   		return ret;
>   
> +	ret = rmi_configure();
> +	if (ret)
> +		return ret;
> +
>   	return 0;
>   }
>   
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 2fb1f7f86d71e..9aa27697e2377 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -12,6 +12,23 @@
>   
>   unsigned long rmi_feat_reg(unsigned long id);
>   
> +/**
> + * rmi_rmm_config_set() - Configure the RMM
> + * @cfg_ptr: PA of a struct rmm_config
> + *
> + * Sets configuration options on the RMM.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
> +
> +	return res.a0;
> +}
> +

rmi_rmm_config_set() is used for once by rmi.c::rmi_configure(), I would not expose
rmi_rmm_config_set() by combining the logic to rmi.c::rmi_configure().

>   /**
>    * rmi_features() - Read feature register
>    * @index: Feature register index

Thanks,
Gavin

