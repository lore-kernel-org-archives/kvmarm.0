Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C546187C
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 01:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695086211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omPau9d/hvAoI0gDrC/4LG/Ef7KpyIVKvwkkyw1GuWQ=;
	b=fwsvuiS5ayp+PO/4Y8J3q7X+Z9HvlUpCyWR1SccVVFgKLz3RaPtKFpVjrIsSTuoM+7IL/l
	8vD0yHDFLq6Z0ohqg+bPyJmknzZE1NhkjWJuNW5R3uq4CYpvFurtXvz83uP9pixjqKPt2G
	ucISVdJZOOHkqxOSyBUyIU5Cq/VIWCo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-D7iXk0i5Mn2CCk1URQVzaA-1; Mon, 18 Sep 2023 21:16:49 -0400
X-MC-Unique: D7iXk0i5Mn2CCk1URQVzaA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1c40ac5b6e7so42983195ad.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 18:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695086208; x=1695691008;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omPau9d/hvAoI0gDrC/4LG/Ef7KpyIVKvwkkyw1GuWQ=;
        b=Afxpqqvz+OVqUNAANaw7LFwDUvJGGq/7Nk5YNDXISkf1USsLe50Oh7asmXNkLXl5aZ
         dcRYqqjj/dI7Dzl+GTUAT3kPyauWcZmThY+qunNbryoF9zyQttCDU/OE4KUTbDExkgvv
         vPvdxXNqM+5LTj2SupCuqHN8Tw/On/h29eKFoWlRaPidi7MXHfIzgMc07rZbOUpqmjBB
         fShKmkRdTzEdePRlXgexoweVhicDfBVRtKp+FAt6TT6x0Gugn8vm4XtF+vG243yj1DTv
         sYu75vyaa/jDYWerKrUDbm79biDrHJZ3M4KzFih9nnBTz4lkIt5fYt3O0gfmZ9wZjoce
         FUiw==
X-Gm-Message-State: AOJu0Yw7jwdd+UWOPosIV83BpOS8FBi5CqepjaZIA8CPNjs42F6G7iBb
	2Xl8XpHnLxXQYmH27ApZ8rVQPOeseDiGNlIKPE30nOlNtdA+zDf5y63RGgiUUQFFlHzyV8YJSgb
	fbYN0MZV19Q5DIfUh
X-Received: by 2002:a17:903:32ce:b0:1c5:82bb:223b with SMTP id i14-20020a17090332ce00b001c582bb223bmr3093047plr.60.1695086208300;
        Mon, 18 Sep 2023 18:16:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE1i0NJ56OK1RSneouzoLKNH0vI25vR0RRcS/LvZ7zADw/YiBXjO0kBQXVFFJFy1l+rs/4UQ==
X-Received: by 2002:a17:903:32ce:b0:1c5:82bb:223b with SMTP id i14-20020a17090332ce00b001c582bb223bmr3093033plr.60.1695086207927;
        Mon, 18 Sep 2023 18:16:47 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id g1-20020a170902c38100b001bc2831e1a8sm6580180plg.80.2023.09.18.18.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 18:16:47 -0700 (PDT)
Message-ID: <9ef55959-66f3-0dc3-dec8-e2b673f965a4@redhat.com>
Date: Tue, 19 Sep 2023 11:16:40 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 26/35] arm64: acpi: Move get_cpu_for_acpi_id() to a
 header
To: James Morse <james.morse@arm.com>, linux-pm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: x86@kernel.org, Salil Mehta <salil.mehta@huawei.com>,
 Russell King <linux@armlinux.org.uk>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com
References: <20230913163823.7880-1-james.morse@arm.com>
 <20230913163823.7880-27-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-27-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/14/23 02:38, James Morse wrote:
> ACPI identifies CPUs by UID. get_cpu_for_acpi_id() maps the ACPI UID
> to the linux CPU number.
> 
> The helper to retrieve this mapping is only available in arm64's numa
> code.
> 
> Move it to live next to get_acpi_id_for_cpu().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   arch/arm64/include/asm/acpi.h | 11 +++++++++++
>   arch/arm64/kernel/acpi_numa.c | 11 -----------
>   2 files changed, 11 insertions(+), 11 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index 4d537d56eb84..ce5045038e87 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -100,6 +100,17 @@ static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
>   	return	acpi_cpu_get_madt_gicc(cpu)->uid;
>   }
>   
> +static inline int get_cpu_for_acpi_id(u32 uid)
> +{
> +	int cpu;
> +
> +	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
> +		if (uid == get_acpi_id_for_cpu(cpu))
> +			return cpu;
> +
> +	return -EINVAL;
> +}
> +
>   static inline void arch_fix_phys_package_id(int num, u32 slot) { }
>   void __init acpi_init_cpus(void);
>   int apei_claim_sea(struct pt_regs *regs);
> diff --git a/arch/arm64/kernel/acpi_numa.c b/arch/arm64/kernel/acpi_numa.c
> index e51535a5f939..0c036a9a3c33 100644
> --- a/arch/arm64/kernel/acpi_numa.c
> +++ b/arch/arm64/kernel/acpi_numa.c
> @@ -34,17 +34,6 @@ int __init acpi_numa_get_nid(unsigned int cpu)
>   	return acpi_early_node_map[cpu];
>   }
>   
> -static inline int get_cpu_for_acpi_id(u32 uid)
> -{
> -	int cpu;
> -
> -	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
> -		if (uid == get_acpi_id_for_cpu(cpu))
> -			return cpu;
> -
> -	return -EINVAL;
> -}
> -
>   static int __init acpi_parse_gicc_pxm(union acpi_subtable_headers *header,
>   				      const unsigned long end)
>   {

