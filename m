Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C0419B5B1
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 10:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973783; cv=none; b=Ov18jXVDm3OM+xR1FJJ2kZdbt20irFykDJAQDBNDPJdpvmeSkuIxnTxFl4qlWH3YYWQ5czLvHPKp/iqnDkNT5dBcU0LjUZ5Gpn5oGGVfA/Pw76cpw1jzGiY2PAPY2V33RNtghd+Y27V003ewTcjnK9UbQl8uwNHFPXzD8HNW/gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973783; c=relaxed/simple;
	bh=cSxBkM/VvswSeAOwadsuJ4JSlJplKr5PUBsSc0t2I6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NiBqoBi+fuwAUbCcouDExqb1698EhZgNIEtB+eZNr93Xw/PcyZg/UJAsNTjrnavTUVBLjZ3CZh6IhWY8k8cV6UwxaFsZwcJd7+eJrBJVLqOgC1iA1Q9w+F8tqUNSqjVBgogRDI0IP7WJloY5wv3zy1cX40ImAr0OZbGuBh4jS1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dyc7lI/E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dyc7lI/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730973781;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RURwccUCrNdi9KBps0wRmpb2Gas3Fr3k2vFNwM24X7o=;
	b=Dyc7lI/EoAIAXRKIS2bhT/73x8EFONXwaX0gvRulmeVj5vyRdKy4Tzz/rl51VU6b9oeWkY
	YVFk2rq8t85RgWPS7yPUqg/JgNHcHyBivECiz5WRlhCoiC1+bZ55W/MeoFR4JQfupOUWuj
	SKiMO6VeusA1S9w2QnhaVDCXEunjxHo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-R3MTyYUwMZK6s9PMwNsIQw-1; Thu, 07 Nov 2024 05:02:59 -0500
X-MC-Unique: R3MTyYUwMZK6s9PMwNsIQw-1
X-Mimecast-MFC-AGG-ID: R3MTyYUwMZK6s9PMwNsIQw
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ff13df3759so7609411fa.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 02:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730973778; x=1731578578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RURwccUCrNdi9KBps0wRmpb2Gas3Fr3k2vFNwM24X7o=;
        b=WUv8sX01QlMttbZYTFIH27vyR7zJAbRokTeS8JvcwVsuZU2reWLjYpfsuXR3pi2Y47
         34rFU1Hzgre9/BDH1N7mNTn9nzG1sAYIfxs1nbPRCMXVe/wX3D7Nl8RVqYbsjtQn8JNN
         YlDCmtrnXGG8b4EARgsnc+Ub5Sf4qGyGsSG9g0aUZIny6BaKOkedE24AotnqP/148sek
         HEcbbuIY7nB9etvCz8RF6o+DaHX0cRDqAYlTvQBkbyjHQp6QzYUjCgrcUCT6vasOIdJ7
         jZNqzv7dxdCm+Rxn5qxYeSQzaF6oYwtbY4BZEb2y999LHYqc3owFINqM/gZdlEwuDt+l
         WWEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbEnMhFLz4nGjUp2yEk6Q3eKDDXglzkWSsXVaoGSC8XHIQYj0z4I/v+DAz6xLHYAKXaz7x6mw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr6jEHYQMB+7XO4xfYs/133IDWvDMeB9g1su1xUH06ySLxhhsQ
	FihelMpDJj20JJr8Lh3BORd2Db5MyobVGb0jDMZLNf28ourvfuoXnxHnzj5XJa1LuRzZyNL667C
	I0q85AwLoncWMeN6d2+0FtsBAsMATR3+wsnmJ+bHswnuIiJCUi/kSQQ==
X-Received: by 2002:a05:651c:b2b:b0:2fb:3960:9667 with SMTP id 38308e7fff4ca-2fedb7a2aa3mr164722361fa.14.1730973778260;
        Thu, 07 Nov 2024 02:02:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0Ut1MJXLUB/mEk4xEIuR+xgwHSESlbS4qEeQM6UCMiizmJPXbkINe4oE0BVm87ZHXWpCwEg==
X-Received: by 2002:a05:651c:b2b:b0:2fb:3960:9667 with SMTP id 38308e7fff4ca-2fedb7a2aa3mr164722081fa.14.1730973777872;
        Thu, 07 Nov 2024 02:02:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6b3069sm53583895e9.14.2024.11.07.02.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 02:02:56 -0800 (PST)
Message-ID: <185b1a15-7e94-466d-a870-d7a2cc3bb890@redhat.com>
Date: Thu, 7 Nov 2024 11:02:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib/on-cpus: Add barrier after func
 call
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241031123948.320652-7-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20241031123948.320652-7-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mK4hqnlwKUf7dyoQyI99ZGeTO1pett1MWsuz8d3l0Rg_1730973778
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/31/24 13:39, Andrew Jones wrote:
> It's reasonable for users of on_cpu() and on_cpumask() to assume
> they can read data that 'func' has written when the call completes.
> Ensure the caller doesn't observe a completion (target cpus are again
> idle) without also being able to observe any writes which were made
> by func(). Do so by adding barriers to implement the following
>
>  target-cpu                                   calling-cpu
>  ----------                                   -----------
>  func() /* store something */                 /* wait for target to be idle */
>  smp_wmb();                                   smp_rmb();
>  set_cpu_idle(smp_processor_id(), true);      /* load what func() stored */
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/on-cpus.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> index f6072117fa1b..356f284be61b 100644
> --- a/lib/on-cpus.c
> +++ b/lib/on-cpus.c
> @@ -79,6 +79,7 @@ void do_idle(void)
>  			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> +		smp_wmb(); /* pairs with the smp_rmb() in on_cpu() and on_cpumask() */
>  	}
>  }
>  
> @@ -145,12 +146,14 @@ void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
>  		smp_wait_for_event();
>  	for_each_cpu(cpu, mask)
>  		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
> +	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }
>  
>  void on_cpu(int cpu, void (*func)(void *data), void *data)
>  {
>  	on_cpu_async(cpu, func, data);
>  	cpu_wait(cpu);
> +	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }
>  
>  void on_cpus(void (*func)(void *data), void *data)

