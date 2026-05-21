Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30DA26F2BF
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779323997; cv=none; b=AwUz2CP/kzrTnphYZTZ7XG9d7uVG0RujxQGtMiLNFl/JcMBtIsd8emlSCp6EqvTV4YeEZLuWq8cnpeTugJxJsXvics0e6sD7hlS9o1IEbLoP3S50zwGqee7ZUfyXtqRgtChQSYOtjl/n/hDTHLvQtlzR482k84hv4vlRSpt7MNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779323997; c=relaxed/simple;
	bh=mdHecRRmI+XKM2TkJIkFi/wwIB6XFVf43GosBajpWxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CqRE/yw4wTJtBUzR2OuJy1KLQx4f4sMXi52x+k1anmb4GmLR2XJk66JnT0J5//K8w3YYyEmMvmhzmUwdt8AFRG47ev1FHll04LwqO2qVCEiHvM5/IheX/wSz9Wj1bV/LqGyifTRQRqTRa/NXS/Jk/AWrTxyhDwlze3583ngcVkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dooUUcBO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dooUUcBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779323993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tV7iZwvmmQQLSqky4R1D09YTKc/1j9bjaXabqWBMECY=;
	b=dooUUcBOWXml/QONGVJHt+XiYFRmRI6dfHoVGr+9FbesaoNM3YXK47A4ifCQ3AZBLNe49X
	lDXdNr2nook/aGdJtsSk0WN1dZiqJurmYC8JRanzudh+cc3V6m3rgXiJu1wIjN7XggH69a
	gyovKZcZQuLscT4DMNpmNoaN2wXNMkk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-N_nwINT3Mtu_x8Lf7KGbxA-1; Wed, 20 May 2026 20:39:52 -0400
X-MC-Unique: N_nwINT3Mtu_x8Lf7KGbxA-1
X-Mimecast-MFC-AGG-ID: N_nwINT3Mtu_x8Lf7KGbxA_1779323991
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c850fcc89d1so283968a12.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 17:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779323991; x=1779928791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tV7iZwvmmQQLSqky4R1D09YTKc/1j9bjaXabqWBMECY=;
        b=r9k+i9aQWv6XftehM+sLfNdPyjnh/rQjMMSAymN9PLncZOOZao5hu27yzrP20e25Ss
         rFX8S1Qtt91KhAtbd8N87WhA0r9M4tgF8Q+ROKFwZmVgVB3xoTW2NyzcmWsmer+kOwU0
         ACHZn0BxnjpkXThose7p9txdUDkfHfn5qxL5PGBQ6lztuM9wjXzMY7rw2Q1ZbXFHfAab
         cT55/NriBQ4tPDVE3PjAbWyOxAcNfxa51qyEN0yskDFN/7IIZQoXKpWJpxCnwdRotIhe
         rEqoTOuaN9sBct+JHtAnB5/4FSU1mgWgcv47HfhcLnKQR15ofrfr6i5uX446wGWeAmO5
         7bPQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vHvom0ZUszS5lwQBrfPaInV2e7jN58JqUkWMMNLbikgY1JeBayrPNXo7WNlFu1kM48N0xIJc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs3FdVzyisu99rNZ6VB7D+W7/vc7yfBlV/IvCZUh7c4wMESTyf
	y4jV4/JoSCddh7L2baocMgoKvdSQFFC1ptaYTsfn/T09dC8BhQtxKDjcU5xIXWVw7SIgsehRKfl
	EwFP+2yT+swTm2XMBTI5xpznWWQB9WEAmT5ERA947HKnpKWPG35vs5sljNg==
X-Gm-Gg: Acq92OH31va3xHZKcu8XvVHa+XL2+L4l1zRngnOk3NKOS8igtbQnxd/EWpoBPYN02Rv
	TgZLwv42JtiDbN9u5fYie6z1M2K1VrmxRjUjSZGLokkHTUpTcexqwVuyOzHITivRkFxB7r27G/g
	OuQ1qgbQS6yFWgVjOy3UlT2TIPxVMqJcn82J5OV0eRdXxBKn94umlxmZBDsbNJH67/YMpQTvHRr
	Ogkg469yld76OZEOjSwQSGN0FC7NUTnhQi4eI9bd8CBMXkaxb+KKkhCkTEzbVfVJpeQpHZlAS3B
	MM66hCbMUKo2DLuIXioX0Zq0/2TAu8NHo9NSN3zrh275255EluMq+LLYp1jXnXX9UafShB3kj/z
	c4/obgVoUVXtBFsZt5zW/VX0SBq/B+BSE11+2zrF7xLlI3OEbIpptq9tfjthcnShV
X-Received: by 2002:a05:6a00:1742:b0:83a:ebec:452f with SMTP id d2e1a72fcca58-8414ae6f985mr687553b3a.42.1779323990945;
        Wed, 20 May 2026 17:39:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:1742:b0:83a:ebec:452f with SMTP id d2e1a72fcca58-8414ae6f985mr687526b3a.42.1779323990418;
        Wed, 20 May 2026 17:39:50 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19663cfdsm27427984b3a.9.2026.05.20.17.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 17:39:49 -0700 (PDT)
Message-ID: <ee494ecd-8979-40f2-896e-82137abbf440@redhat.com>
Date: Thu, 21 May 2026 10:39:39 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/44] arm64: RMI: Check for RMI support at init
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
 <20260513131757.116630-7-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-7-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tkkjVxaO5aM5cgdlVfcgBhPk9AwUCRWq8W26Fb_9w2M_1779323991
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 5/13/26 11:17 PM, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v14:
>   * This moves the basic RMI setup into the 'kernel' directory. This is
>     because RMI will be used for some features outside of KVM so should
>     be available even if KVM isn't compiled in.
> ---
>   arch/arm64/include/asm/rmi_cmds.h |  3 ++
>   arch/arm64/kernel/Makefile        |  2 +-
>   arch/arm64/kernel/cpufeature.c    |  1 +
>   arch/arm64/kernel/rmi.c           | 65 +++++++++++++++++++++++++++++++
>   4 files changed, 70 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/kernel/rmi.c
> 

[...]

> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
> new file mode 100644
> index 000000000000..99c1ccc35c11
> --- /dev/null
> +++ b/arch/arm64/kernel/rmi.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023-2025 ARM Ltd.
> + */
> +
> +#include <linux/memblock.h>
> +
> +#include <asm/rmi_cmds.h>
> +
> +unsigned long rmm_feat_reg0;
> +unsigned long rmm_feat_reg1;
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	unsigned short version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +
> +	/* If RME isn't supported, then RMI can't be */
> +	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
> +		return -ENXIO;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +
> +	if (res.a0 != RMI_SUCCESS) {
> +		unsigned short high_version_major, high_version_minor;
> +
> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> +
> +		pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
> +		       version_major, version_minor,
> +		       high_version_major, high_version_minor,
> +		       RMI_ABI_MAJOR_VERSION,
> +		       RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +static int __init arm64_init_rmi(void)
> +{
> +	/* Continue without realm support if we can't agree on a version */
> +	if (rmi_check_version())
> +		return 0;

Is this still a valid point that we have to return zero on errors returned
from rmi_check_version() or other other function calls like rmi_features()?
arm64_init_rmi() is triggered by subsys_initcall() where the return value
needs to indicate success or failure. It's fine to return error code from
arm64_init_rmi() in the path.

> +
> +	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
> +		return 0;
> +	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
> +		return 0;
> +
> +	return 0;
> +}
> +subsys_initcall(arm64_init_rmi);

Thanks,
Gavin

