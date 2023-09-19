Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E261163
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695085780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xhYDTylANariynyECyDawRfZxSRk3P2GMXADURjfrY=;
	b=g5gvk9Cbldzwgf1whkpv1bhkeCidpWMGTQkiHzikYV0NVbdBS1aIs/VRwtCX6tEFH/wuRz
	iTN6ISnycsk01kDlCaUiLKxQFNmOzupCQcDAjbHQgG/yE0nQkLF2hUGNYJMh9rLl9Fp2Yq
	XHRv1G6U4v1beJPrgRuM+xpXGkSDI/k=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-nKx6wSCAOAmwnwQ1yJTkVA-1; Mon, 18 Sep 2023 21:09:39 -0400
X-MC-Unique: nKx6wSCAOAmwnwQ1yJTkVA-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-577c25cda99so3063090a12.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 18:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695085778; x=1695690578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5xhYDTylANariynyECyDawRfZxSRk3P2GMXADURjfrY=;
        b=xEB+nvoU90Tt2DeqtcysX3yb/1miPDnX1VTesy3ebJqnLDEfapW4b3g0nbXc9TrMuy
         /PLDCBwOwEwT0p8C0Xi2EuF4lyMKZjmzbeKVu37iil47AxvhVr5tOebFSIuCeKbKdVPH
         Zdo7STEAuOWUnX1EF/e/y2xXsSnSiu0Fpd22d2U/SQ6tNlP5QQswICW/jWEGBVXeghoK
         4b5WLVrIe9HpgyBqsQSN3er9ULSWEIeGbuBZLO+IDYZcoHvwVFwjHhz4DktZfcK161Jr
         gZntA4KRk0p+B/WWZqG53iaU1UWLTymeHlRHjOW863NxSAtRF91xRsC0iXCV5EEMugmB
         eWhA==
X-Gm-Message-State: AOJu0YyVscwNcFCtuCpU14de41NvTC6UEdazZb0T2h44XSjLKGKav8mY
	6pwZdFzO3smyp5pAKaMO14CX5VLqxdZWZ4IHY/KRl1RvCpI4qNLJCzEMJqN6ID528zaKDGCWgm9
	mH6wrshqnfxmy5bZ2
X-Received: by 2002:a05:6a20:7faa:b0:140:324c:124c with SMTP id d42-20020a056a207faa00b00140324c124cmr10255879pzj.62.1695085778231;
        Mon, 18 Sep 2023 18:09:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdG9bCpdvmZ3ZQXnGhuch/qDkbh0mPQBnni4kkBKZ4ohjirIgnh97Jnx/y/Pt40AJLReKTog==
X-Received: by 2002:a05:6a20:7faa:b0:140:324c:124c with SMTP id d42-20020a056a207faa00b00140324c124cmr10255863pzj.62.1695085777865;
        Mon, 18 Sep 2023 18:09:37 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id bh3-20020a170902a98300b001c55d591f07sm3082096plb.260.2023.09.18.18.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 18:09:37 -0700 (PDT)
Message-ID: <23ed10ee-b88f-8681-35a4-cefc2e3a7800@redhat.com>
Date: Tue, 19 Sep 2023 11:09:30 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 25/35] LoongArch: Use the __weak version of
 arch_unregister_cpu()
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
 <20230913163823.7880-26-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-26-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/23 02:38, James Morse wrote:
> LoongArch provides its own arch_unregister_cpu(). This clears the
> hotpluggable flag, then unregisters the CPU.
> 
> It isn't necessary to clear the hotpluggable flag when unregistering
> a cpu. unregister_cpu() writes NULL to the percpu cpu_sys_devices
> pointer, meaning cpu_is_hotpluggable() will return false, as
> get_cpu_device() has returned NULL.
> 
> Remove arch_unregister_cpu() and use the __weak version.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   arch/loongarch/kernel/topology.c | 9 ---------
>   1 file changed, 9 deletions(-)
> 
I think arch/x86/kernel/topology.c::arch_unregister_cpu() can be dropped either.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/loongarch/kernel/topology.c b/arch/loongarch/kernel/topology.c
> index 8e4441c1ff39..5a75e2cc0848 100644
> --- a/arch/loongarch/kernel/topology.c
> +++ b/arch/loongarch/kernel/topology.c
> @@ -16,13 +16,4 @@ int arch_register_cpu(int cpu)
>   	return register_cpu(c, cpu);
>   }
>   EXPORT_SYMBOL(arch_register_cpu);
> -
> -void arch_unregister_cpu(int cpu)
> -{
> -	struct cpu *c = &per_cpu(cpu_devices, cpu);
> -
> -	c->hotpluggable = 0;
> -	unregister_cpu(c);
> -}
> -EXPORT_SYMBOL(arch_unregister_cpu);
>   #endif

Thanks,
Gavin

