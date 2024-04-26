Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8F413D621
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 09:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123244; cv=none; b=QVLWulSPMW6DOGkdve4xEWTuTDAIQ4c+wtKR23yUsnqj6FpNE87tkzgPxj58tCosk+66h6OoSe1UD9a/DXAgGQUENnlIu0TncISJvJ8bequxJqjzEVjD75f5KUm9Qc8b3zxrO8nfIQBG44asqLWKO/1A14lDlpHuPS3S91IHspc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123244; c=relaxed/simple;
	bh=C3rHTvF9PHfzdrgv16HQit9eIpwFV1aeMPWDWLSjEDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vwien9WrZr+uqP3OiDzdegsoouTImRA1lKhGr/ED6pSdQKIlSie1Dd+QF5m06E920Jnl37MtJu6+kkvY51FJ5IL3/svvCPPKy+J6OZS0Qru7kQx9L1N1M/BEo2EcRWTEOM5hEdm1lpWlSJJSd3WKTR6+HrLrmATL0QBMujT6iq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RoZwsoQD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RoZwsoQD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714123242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Dmcns0FZ9CNJhWQ+HJ61vRnl0WhR0+EUECBc2kBET0=;
	b=RoZwsoQDjkBe/Wt/TY1lLYa34TMdhU9v3nrlwKpwR9WCXo61/5nI5jCuzyQzJsFplo6f7P
	BslR8V3oR/N6gqBCfnON4AzH90Py3mFMDHQi2msooTXimtlNSQenAv68lcDbnnsRzD1IRr
	y3xQpjRnb4pQPUmrqNpKVNNf/Sp9ODU=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-4-ykInJ_MySeWZyrsAwv2g-1; Fri, 26 Apr 2024 05:20:41 -0400
X-MC-Unique: 4-ykInJ_MySeWZyrsAwv2g-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c82c701f5dso1891144b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 02:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714123240; x=1714728040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Dmcns0FZ9CNJhWQ+HJ61vRnl0WhR0+EUECBc2kBET0=;
        b=t7WQMSR+MrbHQEZOeZb5RYoM30aT+nENZRrwa8oqNL+tgY+zehC8c/z8aIGPGALNDz
         +gbXQQfJLZSa8vTFMhFlfTLcPO7gpNxryiGs7z66LlGK0sflCip6oobEgvVLv0qojyK2
         k14Nsd2La7eyZvsHuO7FLfNT9CnnWQKzKNecdpyySCZIeL/qlTXuhJHCfEP+aUXTdfam
         zW2PHkoIiihOVekFJVwoT3VS89rdMgWKKCKp83cBlrDMdXpwZ2zV61SQ5CjuRhA65aOc
         Bj1mRYaOI/IQ58Hy97yMVq5IlSYgyIR17RLcljH3W/zIdQO7lAXgeZghQBbYN+HHjLgZ
         W6Xw==
X-Forwarded-Encrypted: i=1; AJvYcCUoR7MgpzbwB3IwXG9OFMDlIf7Pl8rsw56Y11lNbK+ot/P/qXci+n79QYHHxL1p8rVscg9h5+AhJne5fEuzDnfFWMenj4Ok
X-Gm-Message-State: AOJu0YxKZ/ArS8ZT8IzKH8GyJ8JAjIsGl2A8whNJUjbcMx3pBPBAGaqo
	FKQWF5EaCB5XqjOyIl25zwz61DJzmRtdXXzz5/lEXBfyKuQJJHIIKUUvXrHiyaTwZYwMDH9PA17
	g2HmGJ/7fncxSsK+jGVC/qEvDVAdGMw6tksDKZ6xQdRF8SRCNrvFUeQ==
X-Received: by 2002:a05:6808:1528:b0:3c7:dfb:a295 with SMTP id u40-20020a056808152800b003c70dfba295mr2563885oiw.55.1714123240415;
        Fri, 26 Apr 2024 02:20:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkmQHR4xd5DGzRLvfFnAFgkLJtQPF1g3QWZiwSfctnEJmyqeJV0jASxLHf/gm5VeDDfBboyg==
X-Received: by 2002:a05:6808:1528:b0:3c7:dfb:a295 with SMTP id u40-20020a056808152800b003c70dfba295mr2563855oiw.55.1714123239985;
        Fri, 26 Apr 2024 02:20:39 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.88])
        by smtp.gmail.com with ESMTPSA id u9-20020a637909000000b006047eb9c7fcsm5263952pgc.34.2024.04.26.02.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Apr 2024 02:20:39 -0700 (PDT)
Message-ID: <0cf50b2f-999f-4aab-bc32-15549d48af2c@redhat.com>
Date: Fri, 26 Apr 2024 19:20:29 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/16] cpu: Do not warn on arch_register_cpu()
 returning -EPROBE_DEFER
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, x86@kernel.org, Russell King
 <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com,
 justin.he@arm.com, jianyong.wu@arm.com
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com>
 <20240418135412.14730-3-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240418135412.14730-3-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/24 23:53, Jonathan Cameron wrote:
> For arm64 the CPU registration cannot complete until the ACPI
> interpreter us up and running so in those cases the arch specific
               ^^
I guess it's a typo? s/us/is

> arch_register_cpu() will return -EPROBE_DEFER at this stage and the
> registration will be attempted later.
> 
> Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
> Acked-by: Rafael J. Wysocki <rafael@kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> v7: Fix condition to not print the error message of success (thanks Russell!)
> ---
>   drivers/base/cpu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 56fba44ba391..7b83e9c87d7c 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -558,7 +558,7 @@ static void __init cpu_dev_register_generic(void)
>   
>   	for_each_present_cpu(i) {
>   		ret = arch_register_cpu(i);
> -		if (ret)
> +		if (ret && ret != -EPROBE_DEFER)
>   			pr_warn("register_cpu %d failed (%d)\n", i, ret);
>   	}
>   }

