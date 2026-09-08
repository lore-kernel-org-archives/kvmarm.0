Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CEE51A733
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788865205; cv=none; b=krrGcg150XVR4DwcJRTvhctxwe4XQ5GVeUXjr5NvSbzMi36tnt2kN/4WZiH6EImCAeky2qJaJn3cTVB9at3itaHIXRSoqzuslE9vIJxTC+6TanjdxTJ6MLjYzp5KvgWJqeMqmPVGjjcSi5FggnutNz891busKYhpg7boKqtXg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788865205; c=relaxed/simple;
	bh=PASoVvJRW52udlXwVPLEvyOYeF6gdA9Vi//Tr1ZPV98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KJEzOBYkBPM8tCozpHCQ9juCkAo52dPKA/gfpazKiFEfBwVb3TnEVjsusMTZvL6+GUWoIlLGxHN0vkwvpnNAy14jDGzSfPHI1rk8ghoFXkdnmmqkae9MvnfZMEx5ldcYnueUKO0pcMTD+9UPgg54REkqSl72rmsnNpYImhFVSFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvUGzp21; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvUGzp21"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788865202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c02abhHVFEdqDQiBq5z2yqG6TQE5ipoCqgc71cPZ6jg=;
	b=dvUGzp21AhrTtJW2YHiBhhtWGGYAfk5NvTlgIx/rXKZhkEos71iWylbonTmEUChkrrtqxK
	X2R7t2h0QfxXy6BA4JjKC+imp01b8w1YuSIpq82QI1jji3tIB5bArbc9nRCBWbI7Di0d2y
	WggGS/djEu98zKCmlPOE9qjQQCI62cw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-a3u96bq2OR-maA-27n7AYg-1; Tue, 08 Sep 2026 06:59:59 -0400
X-MC-Unique: a3u96bq2OR-maA-27n7AYg-1
X-Mimecast-MFC-AGG-ID: a3u96bq2OR-maA-27n7AYg_1788865198
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ce7dff6253so23249635ad.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 03:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788865198; x=1789469998;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c02abhHVFEdqDQiBq5z2yqG6TQE5ipoCqgc71cPZ6jg=;
        b=hRW7daYwNSrNHQhXN43M0ID1KHfVXLZpZMw6nci46yntNg97vl0n4gZt3Wvxlxa6j+
         i3fg3uWS2Ga6YJswxntlJzRP+rQ0D2lkLvVZFKMjFGvaqd9QFoiM1wYRZ7Dtx2WM2NAo
         sIKLD388qBWy/GFTgyCOW0gIlDcbSFGMQcvL+rkGOSGYBI5vdCEyReNW2naXuMJtsON8
         3WeAZWls2sSZwfYIToI97J434HcumAxpBKklB3EkBLdeNbRpvi6Awfb1vR/W6F+zdcpk
         yI/6oJj13K7wcLDMkiyfzAijVodeq6a1CZrOb3p7PpxhHiNyZa8odf/2/dn2ZB7IrG7g
         wI1A==
X-Forwarded-Encrypted: i=1; AKwUvBxrrauywLIBBWi/rrHQ3+7z2c/uy7jyGY+cyfw7LxIaQ2wcgCjxdvifumQQlrXCcXqyozzb7cU=@lists.linux.dev
X-Gm-Message-State: AFuF++lGX2k13A9ubxwhZNsv3Fc9RZbYMy3HTaQ68MRdjdEvpOeH+6RZ
	R9SAQZ02dJ9hLrv8suZ3qR4iolZMA+oemO8y+egCGi93OapQrc6qeLc6Xw4Efl+NJ4LpTn1LTKt
	/Ko6eyidtMStSABNfwgbXjoaeDDI7224bREuUs7PGLzc2yWYMpjuU4MoksQ==
X-Gm-Gg: AYBFou2S4XmdTLbtZSnC24Frp/4l1LeChPRXjYlpC2LFrfGkZNQjyXfzhqx/Tf2b3w3
	5mymzXFBnM7hNW9W/KwjT6vaPg0vsGaYsuTVg/bcZqF5nic0i3StSYVi9cfhATxpmU1n1Clu+R0
	Y4nK+tdxOo4sScHwSuZSn4w6LZhUJy6DwiZWu2WoYhqWNnyZvRNIi5gepcXfW5OIjTpsgwYmQEY
	ZNCOaujI/8sVXorDulzRic16lAR5c858bfxEhYP5ouSGlE8FDVLL1aCzpgmvs7xVJQb4fyu14Lj
	H2BoujmcJAeYuRajZnF9XN157D7BENo/mefnekL1pZDyWOWRgd+44lw+8fb6GKM53kqNgrlvU3D
	GfoM+pkfiXhfObsmXci4aS/+FLzJ/pziDLUn8KMCb8g==
X-Received: by 2002:a17:902:e944:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2db6fe6d0f8mr58961545ad.3.1788865198143;
        Tue, 08 Sep 2026 03:59:58 -0700 (PDT)
X-Received: by 2002:a17:902:e944:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2db6fe6d0f8mr58961265ad.3.1788865197629;
        Tue, 08 Sep 2026 03:59:57 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1495acf7sm57511075ad.25.2026.09.08.03.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 03:59:56 -0700 (PDT)
Message-ID: <9706a0b9-b686-4502-bfae-08aabe05fb84@redhat.com>
Date: Tue, 8 Sep 2026 20:59:45 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 tabba@google.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-4-suzuki.poulose@arm.com>
 <10893135-4757-44de-91b5-180a9774d868@redhat.com>
 <ap--9pJdD_Y_j1aY@FCCLS0092175.localdomain>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ap--9pJdD_Y_j1aY@FCCLS0092175.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8nZnuvDlsmluRSqaC7TRO0RLRbsv7CqlezMHiXQBKZ4_1788865198
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kohei,

On 9/8/26 6:00 PM, Kohei Enju wrote:
> Hi Gavin,
> 
> On 09/08 17:04, Gavin Shan wrote:
>> Hi Suzuki,
>>
>> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
>>> From: Steven Price <steven.price@arm.com>
>>>
>>> RMM v2.0 brings the ability to set the RMM's granule size. Check the
>>> feature registers and configure the RMM so that it matches the host's
>>> page size. This means that operations can be done with a granularity
>>> equal to PAGE_SIZE.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>>    Changes since v15:
>>>     * Actually check the feature register for the host's page-size support.
>>>    Changes since v14:
>>>     * Move the implementation into drivers/firmware/arm_rmm.
>>>    Changes since v13:
>>>     * Moved out of KVM.
>>> ---
>>>    drivers/firmware/arm_rmm/rmi.c | 58 ++++++++++++++++++++++++++++++++++
>>>    include/linux/arm-rmi-cmds.h   | 17 ++++++++++
>>>    2 files changed, 75 insertions(+)
>>>
>>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>>> index 008a783407b4e..76f91c145e1fd 100644
>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>> +++ b/drivers/firmware/arm_rmm/rmi.c
>>> @@ -77,6 +77,60 @@ static int rmi_read_features(void)
>>>    	return 0;
>>>    }
>>> +static int rmi_configure(void)
>>> +{
>>> +	unsigned long granule_feature;
>>> +	unsigned long granule_size;
>>> +	int ret = 0;
>>> +	struct rmm_config *config;
>>> +
>>> +	switch (PAGE_SIZE) {
>>> +	case SZ_4K:
>>> +		granule_size = RMI_GRANULE_SIZE_4KB;
>>> +		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB;
>>> +		break;
>>> +	case SZ_16K:
>>> +		granule_size = RMI_GRANULE_SIZE_16KB;
>>> +		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB;
>>> +		break;
>>> +	case SZ_64K:
>>> +		granule_size = RMI_GRANULE_SIZE_64KB;
>>> +		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB;
>>> +		break;
>>> +	default:
>>> +		BUILD_BUG();
>>> +	}
>>> +
>>> +	if (!(rmi_feat_reg(1) & granule_feature)) {
>>> +		pr_err("RMM does not support %luKB granules\n",
>>> +		       PAGE_SIZE >> 10);
>>> +		return -ENXIO;
>>> +	}
>>> +
>>> +	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>>> +	if (!config)
>>> +		return -ENOMEM;
>>
>> An error message is needed here.
>>
>> 	if (!config) {
>> 		pr_err("Unable to alloc RMM config memory\n");
>> 		return -ENOMEM;
>> 	}
> 
> I largely agree with your suggestions, and they look reasonable to me.
> 
> However, wouldn't this be redundant? Since __GFP_NOWARN is not set, the
> page allocator would normally emit an allocation failure warning with a
> stack trace anyway.
> 
> I don't have a strong preference, but as per "14) Allocating memory" in
> the coding style, I believe it would be considered unnecessary.
> 

You're correct that the error message is most likely redundant here and we
needn't it. However, it's notable the allocation failure warning and stack
trace isn't 100% raised when looking at mm/page_alloc.c::warn_alloc(). At least,
it depends on !__ratelimit(&nopage_rs) even it's less likely to happen. Similarly,
there are conditions to raise a warning and stack track in case of the injected
allocation error in lib/fault-inject.c::fail_dump().

Thanks,
Gavin

> Thanks,
> Kohei
> 
>>
>>> +
>>> +	config->rmi_granule_size = granule_size;
>>> +
>>> +	/*
>>> +	 * For now we set the tracking_region_size to 0 which is the only option
>>> +	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
>>> +	 * TODO: Support other tracking sizes via Kconfig option for other
>>> +	 * PAGE_SIZES
>>> +	 */
>>> +	config->tracking_region_size = 0;
>>> +
>>> +	ret = rmi_rmm_config_set(virt_to_phys(config));
>>> +	if (ret) {
>>> +		pr_err("RMM config set failed\n");
>>> +		ret = -EINVAL;
>>> +	}
>>
>> The error code from rmi_rmm_config_set() is indicative sometimes. Also, -ENXIO
>> would be more appropriate than -EINVAL?
>>
>> 	if (ret) {
>> 		pr_err("RMM config set failed (%d)\n", ret);
>> 		ret = -ENXIO;
>> 	}
>>
>>> +
>>> +	free_page((unsigned long)config);
>>> +	return ret;
>>> +}
>>> +
>>>    static int __init arm64_init_rmi(void)
>>>    {
>>>    	int ret;
>>> @@ -90,6 +144,10 @@ static int __init arm64_init_rmi(void)
>>>    	if (ret)
>>>    		return ret;
>>> +	ret = rmi_configure();
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>    	return 0;
>>>    }
>>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>>> index 2fb1f7f86d71e..9aa27697e2377 100644
>>> --- a/include/linux/arm-rmi-cmds.h
>>> +++ b/include/linux/arm-rmi-cmds.h
>>> @@ -12,6 +12,23 @@
>>>    unsigned long rmi_feat_reg(unsigned long id);
>>> +/**
>>> + * rmi_rmm_config_set() - Configure the RMM
>>> + * @cfg_ptr: PA of a struct rmm_config
>>> + *
>>> + * Sets configuration options on the RMM.
>>> + *
>>> + * Return: RMI return code
>>> + */
>>> +static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
>>> +{
>>> +	struct arm_smccc_res res;
>>> +
>>> +	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
>>> +
>>> +	return res.a0;
>>> +}
>>> +
>>
>> rmi_rmm_config_set() is used for once by rmi.c::rmi_configure(), I would not expose
>> rmi_rmm_config_set() by combining the logic to rmi.c::rmi_configure().
>>
>>>    /**
>>>     * rmi_features() - Read feature register
>>>     * @index: Feature register index
>>
>> Thanks,
>> Gavin
>>
> 

