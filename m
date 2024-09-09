Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A502210EC
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725926225; cv=none; b=c2wIVCVf+7B0rDWuzgF/jKwiAH+yX5zQJUBLcTn33yMbQGWOA6bt9F4mDetFqq/y/jlDK0veYuPw1rvQEnHnlzW3teRaRttkNeP34BoJIygQm/SZAxmzEiv4qGIpD3znx0izk6GbBqGg1if85gTJ6G2/AbAko3HjdaqVQ6DZkMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725926225; c=relaxed/simple;
	bh=3XI5IVZuxU96tWCq021MKnBptmnTHpNo8/GtC8SKI6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIQ2X4c4xm0hO8uifkGxa9uwXk+CUmprhFm6ywLxG0dL8H/CWx52CoqhN11maOsRr219S+HLdsoJamiilXqu99WNYeAb1ww8YaXAH8mrO/KyzrDTw+pefqcru1AsZ+bDb5NaTE7XFhSOlznK7IHcFj/0SH3/5YFphmhU+AdNqoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itQsml/5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itQsml/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725926223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5KDrfnw4h4KPFm9gkKjM5Pcm4Qn58KLQZ4qPPhdTka4=;
	b=itQsml/54rxNNuresKAHUjR7n8sAgJLZs/FHDCmB3EXZKq5eURJhMugnMi6O9AbvkJWSGL
	uBo4TiDnbcYWhTlykOVt3OWuVslVVXx4x5kjV3rGJIZ1+7CxYEYwhggcrwxH+UjTb3Kg3z
	t8lwOwPqGB9zHEBu7ytn9FeSt/An7j8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-cGmLxx31N3mSiZrlmiNRCA-1; Mon, 09 Sep 2024 19:57:01 -0400
X-MC-Unique: cGmLxx31N3mSiZrlmiNRCA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-718dedf3615so209246b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 16:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725926221; x=1726531021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5KDrfnw4h4KPFm9gkKjM5Pcm4Qn58KLQZ4qPPhdTka4=;
        b=EDhtLOITUQD/UncSIztac8o89f58b/pAGsJN0sxVNH+k0D5M7C3FL6ub1ohWCHdlIc
         jkbMhYdx4x8iVf+P4m11a2Ov8I2ZjHAZ5iNplrl2gdjDBWABV8VnKGGQAvuI9C36zvaF
         1YXDf0bRm0jKwx6bzgN01aRqIlSblH9vX9kHxbwcsF9DfZXSZiH4VpmyClJd4NPG33RV
         myBxUbHLVaIgqU6uXxMTjJwi6nu40Ukc1bura9BoBiqrnnK6BptbbYGC7I/wsj2HfCSG
         AUFIGlaePgOy6UW7JNp5WY6Gv0cMZtRMrEkNbAQGOWYhjitUl9bEepMYGIPJ868UWX5w
         ywPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe8Q02dd51heVNVeyZmGaqgCnaaib7/2BGmXYzIpuZ6kg5/+uepHNudPNe7LhSf0ify5dutmU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSAipjBE4mnAgF001GSU1tdfs058Y03MbsM8f5KuYeBdqobc3D
	vd6H9rD6PNRra9cvJweOtrubH/x95Pf+tJAKPkysYfUOdwVdCYxqOe4DO1KIaz/gX1Jd0dIWEMP
	55ZLi/uWDPn3x69weeHRixjEQT6CnWe8oOW/Og1aKSlgOZnpHHYYqDw==
X-Received: by 2002:a05:6a00:3c85:b0:718:d740:b870 with SMTP id d2e1a72fcca58-718e3352956mr12735779b3a.2.1725926220682;
        Mon, 09 Sep 2024 16:57:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsgj8V1pojC58pqDKayl2QgqKFvt9FHbNtmUL06MwiNOepfTXdxL0EwUPYChJ+RhkrUXN3AQ==
X-Received: by 2002:a05:6a00:3c85:b0:718:d740:b870 with SMTP id d2e1a72fcca58-718e3352956mr12735733b3a.2.1725926220087;
        Mon, 09 Sep 2024 16:57:00 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909092258sm269939b3a.127.2024.09.09.16.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 16:56:59 -0700 (PDT)
Message-ID: <41d7c549-072c-4e55-beab-cf339f441ec5@redhat.com>
Date: Tue, 10 Sep 2024 09:56:49 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
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
 <alpergun@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-5-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-5-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Add a function to test early if PSCI is present and what conduit it
> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
> let the kernel know whether it can use SMC instructions to discuss with
> the Realm Management Monitor (RMM), early enough to enable RAM and
> serial access when running in a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v4: New patch
> ---
>   drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
>   include/linux/psci.h         |  5 +++++
>   2 files changed, 30 insertions(+)
> 

Question: Do we need same check for ACPI based system?

> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 2328ca58bba6..2b308f97ef2c 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -13,6 +13,7 @@
>   #include <linux/errno.h>
>   #include <linux/linkage.h>
>   #include <linux/of.h>
> +#include <linux/of_fdt.h>
>   #include <linux/pm.h>
>   #include <linux/printk.h>
>   #include <linux/psci.h>
> @@ -769,6 +770,30 @@ int __init psci_dt_init(void)
>   	return ret;
>   }
>   
> +/*
> + * Test early if PSCI is supported, and if its conduit matches @conduit
> + */

Nit: The comments needn't span into multiple lines.

> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
> +{
> +	int len;
> +	int psci_node;
> +	const char *method;
> +	unsigned long dt_root;
> +
> +	/* DT hasn't been unflattened yet, we have to work with the flat blob */
> +	dt_root = of_get_flat_dt_root();
> +	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
> +	if (psci_node <= 0)
> +		return false;
> +

Nit: Strictly speaking, "psci_node == 0" isn't an error. So the check would be
"if (psci_node < 0)" if I'm correct.

> +	method = of_get_flat_dt_prop(psci_node, "method", &len);
> +	if (!method)
> +		return false;
> +
> +	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
> +		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
> +}
> +
>   #ifdef CONFIG_ACPI
>   /*
>    * We use PSCI 0.2+ when ACPI is deployed on ARM64 and it's
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index 4ca0060a3fc4..a1fc1703ba20 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -45,8 +45,13 @@ struct psci_0_1_function_ids get_psci_0_1_function_ids(void);
>   
>   #if defined(CONFIG_ARM_PSCI_FW)
>   int __init psci_dt_init(void);
> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit);
>   #else
>   static inline int psci_dt_init(void) { return 0; }
> +static inline bool psci_early_test_conduit(enum arm_smccc_conduit conduit)
> +{
> +	return false;
> +}
>   #endif
>   
>   #if defined(CONFIG_ARM_PSCI_FW) && defined(CONFIG_ACPI)

Thanks,
Gavin

