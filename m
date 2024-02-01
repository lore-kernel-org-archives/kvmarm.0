Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B24115DBC9
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 09:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706780076; cv=none; b=bD/o/QS7BHGby3Z6fA3wXJyq/iKiuKl7dstG9NaRJ96D9XX6a8RLdKRWq9iY3GAk0MlyRvD/oBz220oGFUxX510dq2/Pl8DAwrD6QdqN/UsrCG2WgWNmjwCW2ToZCSYqxQbXZTzIBQLraVb6l2m6uRO4tqA6erx1MSvfHbXYw2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706780076; c=relaxed/simple;
	bh=jbCMGhadY8+aTcrS8iELZ3H62oZgYB3Aqj3D9xUwvsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZJZfXK1gJPJkqlNE/YShmFuDtysBCav4/fFf1de5fQn4BszfPaR9EzGbrx6EsKxs9dwhrbwihU6wCGEyIlD6NnWESSwwdw/9Mxiv0pvvnQWPdKeYRQXsF4j+UlvFMGwtdZf4ZcTAjkX5At3jaBMJ+LTODdVkvseCYXH/34Lqfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CmwgR67y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmwgR67y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706780073;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QbKXlj2qJmYcwwoAL264/SJMr9ivxzGCitMWNoXprno=;
	b=CmwgR67yoLNlqb3fphyyWycrDPFPFK1OFv/60w1InRbtOzVQ8gWyDgFUYU8KRFvl3drDt6
	HrNWntu0v4893z07S5lirwrykxD+fq5MUvltsFYGFzC0hcdXloZr8C0khDypMnAhqQX+v/
	OmYpqZJX7wz07jIdct15/Z6yc6ss6Uc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-OXGGWDsoMXSF54EIuNb5Lw-1; Thu, 01 Feb 2024 04:34:32 -0500
X-MC-Unique: OXGGWDsoMXSF54EIuNb5Lw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5111abb53aeso576323e87.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 01:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706780071; x=1707384871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QbKXlj2qJmYcwwoAL264/SJMr9ivxzGCitMWNoXprno=;
        b=ZL84o9zabg/14g4+P7KY7noOspWNsZf0v55aDor27j3xJ9raBEgJ8f9YwCWbxhDsAF
         Tm1YYRdK0z1I5eVEb081ZWRfbFvUVMxi/zDNq7ZqAV6xcaEyCk0Ghwq5RHARbQ9uhbkZ
         BPWgoqVAxNagZIMZFTWlsVadcXnph028CC3QHgpLU5wrmrqPa4W5FTEbYSnOpYD6kuMd
         UxqR21/wE8Mo18TeFep6VMDOPXAjyXZUVhBzVEKt3747foWOFLriaqss7KOCPJ4bhlQw
         ZLabmJgycbaY8DRGJfyn5tMnXe65S4P4RnHtFpBaGSMqx0rWVbuSR72VItIYRAFCK55T
         /qsw==
X-Gm-Message-State: AOJu0YzpMDAj33SeYf2F4YGESSC4cW8Sz5Y0wBlDFY8dh2pBPDwBVF1j
	T9O9mueHgWqksYvK1/Q8TIHOQNZkWTfCR9gbIKGqktJr5HyvZ8hCngQ56GwPKNoNoQW7YJR0rik
	O+gK427vUyvix3pfwHo+NDk8ZCna/zie9FjvEpcLqWvy/8rxRNPCSpg==
X-Received: by 2002:ac2:42c2:0:b0:511:2da1:d34f with SMTP id n2-20020ac242c2000000b005112da1d34fmr946810lfl.68.1706780071184;
        Thu, 01 Feb 2024 01:34:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvccMcskijAMysxvD7yYFYGNPus6UL4rYmCZTFAmOefTGXD1uzbrcKE/pB3OC9GGXxacmo0A==
X-Received: by 2002:ac2:42c2:0:b0:511:2da1:d34f with SMTP id n2-20020ac242c2000000b005112da1d34fmr946637lfl.68.1706780066004;
        Thu, 01 Feb 2024 01:34:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW3PpPY/C3y3Z+XF8gr1uRDBGy7Qg283nXZee1wNMd3gy39QCZOZf10LIBFH6YXs0b+50OaE8RjhdGD8VFB2FnUdNmL8b5NBXWBnJS1OK7z3QxnABKWgjyouvVzC5OaL6OYnz5vZvOXEOi86j5RF8bCpryXqotjRcZTMKvg7G9PARh+rqSOtT3XHqrhlYMJHAVYvMil7gFnUeMVO2y0dQzplbsqppc/UWjyNjj16Ni9izNUJJq98HhfTo+1dwN0Kka34iMyySTdVulFR/XmNnoEYkGJf1jUa3qt2qM2hRqG+s/wnowbWFE=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s15-20020a05600c45cf00b0040e3635ca65sm3890448wmo.2.2024.02.01.01.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:34:25 -0800 (PST)
Message-ID: <f2c558f7-4ba6-4ea5-966a-7b820ee3a2b8@redhat.com>
Date: Thu, 1 Feb 2024 10:34:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 12/24] arm/arm64: Remove spinlocks from
 on_cpu_async
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-38-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-38-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> Remove spinlocks from on_cpu_async() by pulling some of their
> use into a new function and also by narrowing the locking to a
> single on_cpu_info structure by introducing yet another cpumask.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/arm/asm/smp.h |  4 +++-
>  lib/arm/smp.c     | 37 ++++++++++++++++++++++++++++---------
>  2 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index 9f6d839ab568..f0c0f97a19f8 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -27,9 +27,11 @@ extern bool cpu0_calls_idle;
>  extern void halt(void);
>  extern void do_idle(void);
>  
> -extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
>  extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpu(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpus(void (*func)(void *data), void *data);
>  
> +extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
> +extern void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry);
> +
>  #endif /* _ASMARM_SMP_H_ */
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index c00fda2efb03..e0872a1a72c2 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -76,12 +76,32 @@ void smp_boot_secondary(int cpu, secondary_entry_fn entry)
>  	spin_unlock(&lock);
>  }
>  
> +void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry)
> +{
> +	spin_lock(&lock);
> +	if (!cpu_online(cpu))
> +		__smp_boot_secondary(cpu, entry);
> +	spin_unlock(&lock);
> +}
> +
>  struct on_cpu_info {
>  	void (*func)(void *data);
>  	void *data;
>  	cpumask_t waiters;
>  };
>  static struct on_cpu_info on_cpu_info[NR_CPUS];
> +static cpumask_t on_cpu_info_lock;
> +
> +static bool get_on_cpu_info(int cpu)
> +{
> +	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> +}
> +
> +static void put_on_cpu_info(int cpu)
> +{
> +	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> +	assert(ret);
> +}
>  
>  static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
>  {
> @@ -158,22 +178,21 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
>  	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
>  						"If this is intended set cpu0_calls_idle=1");
>  
> -	spin_lock(&lock);
> -	if (!cpu_online(cpu))
> -		__smp_boot_secondary(cpu, do_idle);
> -	spin_unlock(&lock);
> +	smp_boot_secondary_nofail(cpu, do_idle);
>  
>  	for (;;) {
>  		cpu_wait(cpu);
> -		spin_lock(&lock);
> -		if ((volatile void *)on_cpu_info[cpu].func == NULL)
> -			break;
> -		spin_unlock(&lock);
> +		if (get_on_cpu_info(cpu)) {
> +			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> +				break;
> +			put_on_cpu_info(cpu);
> +		}
>  	}
> +
>  	on_cpu_info[cpu].func = func;
>  	on_cpu_info[cpu].data = data;
> -	spin_unlock(&lock);
>  	set_cpu_idle(cpu, false);
> +	put_on_cpu_info(cpu);
>  	smp_send_event();
>  }
>  

