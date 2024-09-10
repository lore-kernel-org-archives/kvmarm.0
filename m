Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBAF182AE
	for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725927528; cv=none; b=fdUfvyNjX+BeszgLH4wxecY+6vpGDzse0kkD1a7YVDmKnqbiMSdwISkJdgJX5KEpwEAYbC/TLMBzFGpFNLf9zyXBpKw41qs5ZYwBvFWZPNkTMG3kc1p3A+ddWfwtpy6hB7L7IY75Dl+5r3kFVizbEA2Jlcv29k/ks+w7TZWHkG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725927528; c=relaxed/simple;
	bh=L3a2g1E/6DmPzoCid4NmrExadsFZujU2lIAaLeWmoB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X66abtR9qyjwyjlxC5NXW6lOsDAy6i0yKBt1C8IIVgpdFRLGgo5x4vkXj2MaCgh9tBSpWJx174FajPscytyL4rgSZ/ztT6dNBj6wnFz+SU1icCpx2/Z/Qom3YNJBZhrcyXXRO8bU5H/RG8dmdlsh1DlZWg6shYT+VtKAKgQg+7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F2eut/Jv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2eut/Jv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725927526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qDUKZkW1qm/U7nIsNHl6u/vxYb3LmdiiRvhpMXyqBg=;
	b=F2eut/JvZD+gEEtBVx8ANfa8sBe7GAaNJa1PVxtjBLKac9RjBDYt19LxTO4bIppg5v3C7J
	WCjipJqq1R4b7mcX+kdJaqP8hSnYZu3SxB7gSq+6DlLhFD1htJiJ6D9PEPAbf7vaCgi8QI
	OsY7kNCxvkCv1t6mHIKpuwcsEM2gp2c=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-C3NAVRQXOyedRBQMVPFTHg-1; Mon, 09 Sep 2024 20:18:43 -0400
X-MC-Unique: C3NAVRQXOyedRBQMVPFTHg-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-718dedf3615so230817b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 17:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725927522; x=1726532322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3qDUKZkW1qm/U7nIsNHl6u/vxYb3LmdiiRvhpMXyqBg=;
        b=xJYQvL3EmeaZBAnJjEDeRzDokGFf4BX5ZuFUTEs69JhrVZHVWbSVtH9agSKbXQ2H7g
         WC5IJ+eogDP1strcFGAiBn3m5s3aYZQA3bOBARKUWVn2dN4JCqU/0ZGP+CXn5BoKUIRJ
         exP7SxUdGry9kexOzaK2M+kw59EUsHNDaY8US6jfe5Gr1BZKef/4x3iQ0iu4uHohHxuw
         FTSvg9kOZI5wm25CCWdOKuDeHuI40UetzGe8PbFaCwRSlTYXumb229uSRDQ3ms+VGEUH
         TssPoVHSirmNGdkmNtHiODqCqm+uinbJ53bZ192NSZlnF89qPYtVfHQ9spPqeasvQD/v
         UyzA==
X-Forwarded-Encrypted: i=1; AJvYcCW9lCK+1GVIk6HNAAS/B7q6Hxh9iC1R+2M6wo8ZYTeBrxK7xCo3ZmVdg2e4vFlYb23SkW3vft4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywa2tmO9Z+0VapJX5p/tRodx0eG5QwfNA8GQuHebtY44d/5/iwe
	1biXy85Wiz0bs18SFDfCWzQm2H4AMFAY5J/q5CZIfaJ/4EMLAHoYFC3/6u7LbHK+kDJ9tN+NE1T
	RgbNeNyUD+DVNGj3Pae1QR/1AtRec9LM7KNmT713aVpZBVmcJlkEQEg==
X-Received: by 2002:a05:6a00:3cc4:b0:718:d7de:3be2 with SMTP id d2e1a72fcca58-718e33a0050mr14892315b3a.14.1725927521925;
        Mon, 09 Sep 2024 17:18:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyd0cypr7QA7LSQQ0FAqADYQZb+J27E549rmhRMytoKbFbGfFE8ni5SsRVpLPAZanhv86dsg==
X-Received: by 2002:a05:6a00:3cc4:b0:718:d7de:3be2 with SMTP id d2e1a72fcca58-718e33a0050mr14892272b3a.14.1725927521353;
        Mon, 09 Sep 2024 17:18:41 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7190909222bsm284268b3a.115.2024.09.09.17.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 17:18:40 -0700 (PDT)
Message-ID: <b5eab951-c2bd-4d4f-84c7-9617cc8d29cd@redhat.com>
Date: Tue, 10 Sep 2024 10:18:31 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/19] arm64: realm: Query IPA size from the RMM
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-7-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-7-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> The top bit of the configured IPA size is used as an attribute to
> control whether the address is protected or shared. Query the
> configuration from the RMM to assertain which bit this is.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Make PROT_NS_SHARED check is_realm_world() to reduce impact on
>     non-CCA systems.
> Changes since v2:
>   * Drop unneeded extra brackets from PROT_NS_SHARED.
>   * Drop the explicit alignment from 'config' as struct realm_config now
>     specifies the alignment.
> ---
>   arch/arm64/include/asm/pgtable-prot.h | 4 ++++
>   arch/arm64/kernel/rsi.c               | 8 ++++++++
>   2 files changed, 12 insertions(+)
> 

One nit below.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index b11cfb9fdd37..5e578274a3b7 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -68,8 +68,12 @@
>   
>   #include <asm/cpufeature.h>
>   #include <asm/pgtable-types.h>
> +#include <asm/rsi.h>
>   
>   extern bool arm64_use_ng_mappings;
> +extern unsigned long prot_ns_shared;
> +
> +#define PROT_NS_SHARED		(is_realm_world() ? prot_ns_shared : 0)
>   
>   #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
>   #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 128a9a05a96b..e968a5c9929e 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -8,6 +8,11 @@
>   #include <linux/psci.h>
>   #include <asm/rsi.h>
>   
> +struct realm_config config;
> +
> +unsigned long prot_ns_shared;
> +EXPORT_SYMBOL(prot_ns_shared);
> +
>   DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>   EXPORT_SYMBOL(rsi_present);
>   
> @@ -72,6 +77,9 @@ void __init arm64_rsi_init(void)
>   		return;
>   	if (!rsi_version_matches())
>   		return;
> +	if (rsi_get_realm_config(&config))
> +		return;
> +	prot_ns_shared = BIT(config.ipa_bits - 1);
>   
>   	static_branch_enable(&rsi_present);
>   }

Nit: It's probably worthy to warn on errors returned from rsi_get_realm_config(),
It's hard to debug and follow if it fails silently.

Thanks,
Gavin

