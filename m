Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D9A17757
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HunmNJhy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699524817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3rYhpoB4lYmS4MLIzZUo4ZMf6R8bUZVPeYV6RdLZieo=;
	b=HunmNJhyBSZgXRMsiGCSrIQXWYOWvCbF1w+swLqHWKGWVCM6Byi7kzLoyCg5PFpXQ/IoNB
	iIIARSqJHL9hjJopTrTIb946pyBD/bkXDrPZeniymA+Ps0k0qM/jlBgFiqZRJzXLX1piY/
	J3gA5cjO/lFhAYJSFEDmVj4w3ZKb1ug=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-UHNj7kZBPtGCiR1BlrmL9w-1; Thu, 09 Nov 2023 05:13:36 -0500
X-MC-Unique: UHNj7kZBPtGCiR1BlrmL9w-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2800be2d781so188004a91.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 02:13:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699524814; x=1700129614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rYhpoB4lYmS4MLIzZUo4ZMf6R8bUZVPeYV6RdLZieo=;
        b=txAAZfrgBuP3slURNdFnYaufACEnd2eL0bNlqT/23oupPucyICQnqlEfLnf41EZEDD
         wNUhJXkgP0aDLRe7PI51OcycVgtHGa61haz0NMgK1neVFJbZJkV1ZJcE62MAGh5blDXL
         2ZYHdXbxpjElPDXUao9FvfJBwOyB26GUuu88B5osFj6ItEM9xcfHA4/Ozaol1UQ0ebvz
         ydZSLCuj2qQtJxl0PKbimPAMoUjWAcDfAm870pTJoZSQULxOkbifKezbeYKqnLqUNwZ7
         CpRIdXAwZzJSoSQ4OPAo9aj9a+3ZnywgRhg94n76vnegZNykODpn85htoOBfoW7IK3vJ
         r+ZQ==
X-Gm-Message-State: AOJu0YzTM8kb+wLu1YYVA7HfA1poeLImJBtx3Jjh0BwKdm2mmBktX475
	0VhAWdAheKI/YNo5R2AQFBnHLaqC6/Z9PkpYiyVeCbUieFjJoF3w1SfRmz1+GTjAzIpwd4idVrA
	sL3mIMKBsDFO2JbgS
X-Received: by 2002:a17:903:120e:b0:1cc:ebe:5547 with SMTP id l14-20020a170903120e00b001cc0ebe5547mr5043346plh.0.1699524813755;
        Thu, 09 Nov 2023 02:13:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMYccyPUYXdRLbiWAt/Rrr2lff8DkVfjHrlmnPr9rVOEThxcSXfzeRdAMTZ0+vEY8CCgW5xw==
X-Received: by 2002:a17:903:120e:b0:1cc:ebe:5547 with SMTP id l14-20020a170903120e00b001cc0ebe5547mr5043330plh.0.1699524813447;
        Thu, 09 Nov 2023 02:13:33 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902e74200b001c60a2b5c61sm3165370plf.134.2023.11.09.02.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 02:13:33 -0800 (PST)
Message-ID: <6341a77d-ba42-3f3a-4a2a-b598fb5c0e20@redhat.com>
Date: Thu, 9 Nov 2023 18:13:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 07/22] drivers: base: Allow parts of
 GENERIC_CPU_DEVICES to be overridden
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org,
 linux-csky@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org
Cc: Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com, James Morse <james.morse@arm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Gleixner
 <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>
References: <ZUoRY33AAHMc5ThW@shell.armlinux.org.uk>
 <E1r0JLG-00CTx8-CG@rmk-PC.armlinux.org.uk>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <E1r0JLG-00CTx8-CG@rmk-PC.armlinux.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/23 18:29, Russell King (Oracle) wrote:
> From: James Morse <james.morse@arm.com>
> 
> Architectures often have extra per-cpu work that needs doing
> before a CPU is registered, often to determine if a CPU is
> hotpluggable.
> 
> To allow the ACPI architectures to use GENERIC_CPU_DEVICES, move
> the cpu_register() call into arch_register_cpu(), which is made __weak
> so architectures with extra work can override it.
> This aligns with the way x86, ia64 and loongarch register hotplug CPUs
> when they become present.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> Changes since RFC:
>   * Dropped __init from x86/ia64 arch_register_cpu()
> Changes since RFC v2:
>   * Dropped unnecessary Loongarch asm/cpu.h changes
> ---
>   drivers/base/cpu.c  | 14 ++++++++++----
>   include/linux/cpu.h |  4 ++++
>   2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 34b48f660b6b..579064fda97b 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -525,19 +525,25 @@ bool cpu_is_hotpluggable(unsigned int cpu)
>   EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
>   
>   #ifdef CONFIG_GENERIC_CPU_DEVICES
> -static DEFINE_PER_CPU(struct cpu, cpu_devices);
> +DEFINE_PER_CPU(struct cpu, cpu_devices);
> +
> +int __weak arch_register_cpu(int cpu)
> +{
> +	return register_cpu(&per_cpu(cpu_devices, cpu), cpu);
> +}
>   #endif
>   
>   static void __init cpu_dev_register_generic(void)
>   {
> -#ifdef CONFIG_GENERIC_CPU_DEVICES
>   	int i;
>   
> +	if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES))
> +		return;
> +
>   	for_each_present_cpu(i) {
> -		if (register_cpu(&per_cpu(cpu_devices, i), i))
> +		if (arch_register_cpu(i))
>   			panic("Failed to register CPU device");
>   	}
> -#endif
>   }
>   
>   #ifdef CONFIG_GENERIC_CPU_VULNERABILITIES
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index fc8094419084..1e982d63eae8 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -88,6 +88,10 @@ extern ssize_t arch_cpu_probe(const char *, size_t);
>   extern ssize_t arch_cpu_release(const char *, size_t);
>   #endif
>   
> +#ifdef CONFIG_GENERIC_CPU_DEVICES
> +DECLARE_PER_CPU(struct cpu, cpu_devices);
> +#endif
> +
>   /*
>    * These states are not related to the core CPU hotplug mechanism. They are
>    * used by various (sub)architectures to track internal state

-- 
Shaoqin

