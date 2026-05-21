Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAC91FBC8E
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779324736; cv=none; b=uRu/PWbG7y1BmS7kyrtA7kEMCF541WmpQjtldZjfy7J+0Nmnpw5KPRmnWEWzVrNvs6MMnxbjS/QKYQFZNrmhLG7g18c+YLjZVgiPlvHJuurQM6J/D3zDe7hrapy7Thue7XO/vNfef7+J/j60Z4dBWjcixUK6IfuAZeZQDVdGuXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779324736; c=relaxed/simple;
	bh=SyMNQf23KSDzhFiY5Zt1P+qqyGBKOoYaZaxAPGeN1e4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcjYoJ628BgWh1U70U39zM98TTgWQMXCjxuSZMUzscdxdz90zOZ+BQUQVP1vn+TudaPKNfyklsQ3fwZlB/+BKvc/Y37HEIi85eP1AnZk1RxCRyG/9Jy86PDxVt+OCbpXkbZCcYWuUGyqTpmTqN11+lGl/BB/GrG2+AqiR804jec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NyFoGa5j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NyFoGa5j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779324732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G7+8kbrxw3k6r1pEahfY8Z1QQWebSWYvywBVfeppeoA=;
	b=NyFoGa5jHfFzRVZbo0N6PCY1ind+lCX6an+A66ftzkRB2yrmX4ynrmyFqWlji1T91AIJ0r
	iIHhQRB4guuuZGVC/2UrrX4N56RH987QYFalPnCVkcsAYe7mg0Ht9QFJkikW9dAK1Oadc1
	PXmqME2uBX3SlJ7PQcZngEuxAle3mEQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-WTDrKmh1NWCGNZsogl2kYg-1; Wed, 20 May 2026 20:52:11 -0400
X-MC-Unique: WTDrKmh1NWCGNZsogl2kYg-1
X-Mimecast-MFC-AGG-ID: WTDrKmh1NWCGNZsogl2kYg_1779324730
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b99eb06178so137235875ad.2
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 17:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779324730; x=1779929530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G7+8kbrxw3k6r1pEahfY8Z1QQWebSWYvywBVfeppeoA=;
        b=II0nftJ/OSg+mf7bpIiWoPcdz5Zf67IUCceP9fnhVBiZm5SGttHLbv/Fw8dSYX/56q
         gEJG2TMlNoRlwwiWQ6Hia/CEWeLm1awxorSySw861Oywm7r+9JNjfnAuUQVp4NJx60CU
         LNXlkkluzZ9qCxssMMjOCgbIWdLP7aWiQwQj0Sr4A1tg6onUJzgJO6XMDI9UPdEqnzrf
         jCK6ocSEVi4LV8csUDu/miIalGivfzKt1sFI5luPmnzPqSZ02VMa0v+pfZOPxcUkW+yE
         EyCSMs7hLWL4VZ7Of3L/HRqaMmIIpYi85hblDUlu6TzHievTJm7iKdU07uq9CtrdQMt3
         94Ow==
X-Forwarded-Encrypted: i=1; AFNElJ8EzI0gbcIr/cSPnYz4NL8Ocif28JCHJAc6lKUwtaN3ZWcSUhCpvIsnqxKEkNSSWwYAc3BCTVM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDp88VsVYNTTE8M4ee2/yc0YjQ+osVTnISopBvlVaQP0o7chuH
	nHpAJrp8Li3aWqDJxFJXxr2fOgZeuLvwUTodj+/So6Kf3xVG06o+8gWaC+P2GCkmumgweNjOhBV
	/qb7VHOukVDbPjMAQNHiLoOdeefX/NkhzDcbwu6npxIiuaOD1LfXK+0ytxA==
X-Gm-Gg: Acq92OHiqjrN6LqODBPLiYVezkJPxFhry75NFCwqUNnTm8kHwnidsXdWJLIpk7m7LCM
	1aaizR3GJ7/L+KPCHhEmGGK0/NOLU0S4WZ+gdE1tdlJ4khVd8A9jRLRfaWyw4w4Wl8lx9AzMRit
	XPyMQ7nD1EYuxcTIWBDgLbAt7sGsEsghegpZHqmwGFRkGNctw6ByXZQriZV5mmAvDBFO/HJVCGB
	3sH9JdHwcEKnCBembDd286GfCqAw2do52+2pzK3+Qedzn4SA16B5boGtmuXwg58fIV2uD0ztYAM
	+43rVWq60e+KmsWwp0o9qV4Oj9O2HTag3yQ3UBICO2YpoGQQXTJ3jov/hcg35TgKBmsILzdZK/K
	L32Uln+Yz46uI4hyGs6Vc8PCInVVGlZC68fNPIyEHvsRZ6T7K2o846lZWkGRn7VFZ
X-Received: by 2002:a17:903:240c:b0:2bd:907:2cf0 with SMTP id d9443c01a7336-2bea33a548dmr3620975ad.32.1779324729803;
        Wed, 20 May 2026 17:52:09 -0700 (PDT)
X-Received: by 2002:a17:903:240c:b0:2bd:907:2cf0 with SMTP id d9443c01a7336-2bea33a548dmr3620505ad.32.1779324729097;
        Wed, 20 May 2026 17:52:09 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5ef1bsm293727375ad.4.2026.05.20.17.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 17:52:08 -0700 (PDT)
Message-ID: <45a953a8-6edc-45c3-b5bd-17f14397ab89@redhat.com>
Date: Thu, 21 May 2026 10:51:56 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/44] arm64: RMI: Configure the RMM with the host's
 page size
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-8-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-8-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rpAV_edplLMQoBmPeFJH5T7qmYWZEG4HNE6h04vHLUk_1779324730
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 5/13/26 11:17 PM, Steven Price wrote:
> RMM v2.0 brings the ability to set the RMM's granule size. Check the
> feature registers and configure the RMM so that it matches the host's
> page size. This means that operations can be done with a granulatity
> equal to PAGE_SIZE.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>   * Moved out of KVM.
> ---
>   arch/arm64/kernel/rmi.c | 42 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 42 insertions(+)
> 
> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
> index 99c1ccc35c11..a14ead5dedda 100644
> --- a/arch/arm64/kernel/rmi.c
> +++ b/arch/arm64/kernel/rmi.c
> @@ -49,6 +49,45 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +static int rmi_configure(void)
> +{
> +	struct rmm_config *config __free(free_page) = NULL;
> +	unsigned long ret;
> +
> +	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
> +	if (!config)
> +		return -ENOMEM;
> +
> +	switch (PAGE_SIZE) {
> +	case SZ_4K:
> +		config->rmi_granule_size = RMI_GRANULE_SIZE_4KB;
> +		break;
> +	case SZ_16K:
> +		config->rmi_granule_size = RMI_GRANULE_SIZE_16KB;
> +		break;
> +	case SZ_64K:
> +		config->rmi_granule_size = RMI_GRANULE_SIZE_64KB;
> +		break;
> +	default:
> +		pr_err("Unsupported PAGE_SIZE for RMM\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = rmi_rmm_config_set(virt_to_phys(config));
> +	if (ret) {
> +		pr_err("RMM config set failed\n");
> +		return -EINVAL;
> +	}
> +

Looking at branch 'topics/rmm-v2.0-poc_2' of RMM implementation, the granule size
is fixed to be 4KB at present. I'm not sure if I have looked into correct RMM
implementation, but 'topics/rmm-v2.0-poc_2' is recommended one in the cover
letter.

Besides, there has checks in the handler of the RMI command to make sure that
struct rmm_config::tracking_region_size to be 1GB, indicated by zero. It maybe
worthy to set it before call to rmi_rmm_config_set().

	config.tracking_region_size = 0; /* 1GB */
	ret = rmi_rmm_config_set(virt_to_phys(config));


> +	ret = rmi_rmm_activate();
> +	if (ret) {
> +		pr_err("RMM activate failed\n");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
>   static int __init arm64_init_rmi(void)
>   {
>   	/* Continue without realm support if we can't agree on a version */
> @@ -60,6 +99,9 @@ static int __init arm64_init_rmi(void)
>   	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>   		return 0;
>   
> +	if (rmi_configure())
> +		return 0;
> +
>   	return 0;
>   }
>   subsys_initcall(arm64_init_rmi);

Thanks,
Gavin

