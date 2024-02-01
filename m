Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F49215958A
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776169; cv=none; b=Yfhwymot1ZNl6U9frA8cyPf6n9y61GODAfCd9dZ+pBU4is+ePdV6kk90nT4u6x7uajXSGo8iJNZp+v8+qmYnwmg6RAYWWW3lix6Mr1zhfUZGQwYZqtKo74zPN6kGynBDgNmGs3giRcqh4iXjueXecm+/mSBqo7Fn0nQAyuYAUMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776169; c=relaxed/simple;
	bh=G2AM12amVMrP7GZrkut2e97ASmNSuJ6AUi0+jpz9Sno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLG2IKukpBOCKgMjKCgG5xVciDX3fqIvn4kWLiEYbNNCrPfl0N4Sekv6jUhIAALhTUqyv4gRhxwr/eB1o7/zkO64NNmo6heoxXf3puKxmblG7+VYp5mqjn3D656CGFnGs9uS3zGQxUc/UhqmLCfp/5JaLUSs5paT2EkZoxgOaDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ckWL54lQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckWL54lQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776167;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9MZIyh9FSa9PbK1/5CHC5q5vkvb+rf2FqdbmMNUUP0=;
	b=ckWL54lQkdRSrtwQ2s4FEapR0ODXITBqnOxF/Lv3TaRXdpEYf5F+ynh674XeE+117LOTLt
	/ZS6b0aRbCsVX2L1EdF+l+md3U0BzsiuP/8RBG7/Lez+BghhQ690mcRA8duxOfeFa22IAY
	sdYnJv+mVMxSuQeP20nGIuY29jW04Mo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-vdKwDM4xNjCI1geSTqkWSQ-1; Thu, 01 Feb 2024 03:29:25 -0500
X-MC-Unique: vdKwDM4xNjCI1geSTqkWSQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5101b9343easo492966e87.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 00:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776164; x=1707380964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X9MZIyh9FSa9PbK1/5CHC5q5vkvb+rf2FqdbmMNUUP0=;
        b=RyzrQThQX3dnOQqwvbNehOxfWlUdUXB71v5OE4Gh1gEGawWpkz1+H7svy5uM3QigsJ
         kOkpPJsvRdnyvlZ9l8LdroVpgk6svRI8kS07uu0Ymij5Y7a+8EBa/SaGZ2OyYMmkTKvw
         k//nF6qI5Qj/45+Ny996gr/ZPOHKrYUnUXlcrARsgLO9dwhEAaSS7H6P8w/G31NPKsJ2
         0ULBbSu6TtJinFJvKYgUZhVjIsH2+OLtlq9Lco2KmDIUqcEEVQY8ODHyqG9GtmGDlu1D
         FB2PaLQeGbxUezeLf43uF+d931cA6n+BuNULZf94J2gsy6KqEA9FK8m0a29p7ml6LatF
         QbsQ==
X-Gm-Message-State: AOJu0YwCXyrFpqnx/4RXcTzhbmNwaQOnAdvpz8ooCr+JJw0DUzmps6I3
	OSpt2/tLauuMgVbN9o2vhKutNrpH1vp9oA9Ydpx7R6/ssjOg7uT7UEyNkZM5Tq3o3VAfmBZrMCS
	KIDtEuvZyL6xH3uidmrebHBHJwYS97wjHd8Q21/8XnuldF9vr5PfxDA==
X-Received: by 2002:a05:6512:40c:b0:511:300c:d40 with SMTP id u12-20020a056512040c00b00511300c0d40mr494950lfk.22.1706776164263;
        Thu, 01 Feb 2024 00:29:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4Wtl9F00WmIcVZzUI9GgxMBA9Jw/EuFwtCT01zyHKVbWo1cfOrwDxkZlAB7zsztJlmflgxQ==
X-Received: by 2002:a05:6512:40c:b0:511:300c:d40 with SMTP id u12-20020a056512040c00b00511300c0d40mr494936lfk.22.1706776163954;
        Thu, 01 Feb 2024 00:29:23 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVG5oaiR8h3AJCow9zKczsXhGg/hyrZfHKcIOnsw8823xzKGU65rkho7WydIvsh2Kjbxk0OGiOothfvmzQdo2vdPyCiYgoYQ9joVE9VWarEODeKHYy9gWXcr0AHr1RuYwbv0rOyw0bSv8relNci25sj3lAKxZguTtEufVHUcdFvaXYPX8k7wozBtrx8OEHkwf3coLK8pSiM+GYsY36LsAHNRw70kTk0jvgoAXjBtw4/fVAUQyN6lVsFiTUsOxpxK4cfL0jtIIxaEtQoT6VtIqvQ1EAXWzl3H4c966OiWdMzDu0lsHMb9U8=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id jr7-20020a05600c560700b0040efa513540sm3643423wmb.22.2024.02.01.00.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:23 -0800 (PST)
Message-ID: <caa36aaf-e386-4217-8444-8b6f38be00ea@redhat.com>
Date: Thu, 1 Feb 2024 09:29:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 04/24] arm/arm64: Share cpu online,
 present and idle masks
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-30-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-30-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 1/26/24 15:23, Andrew Jones wrote:
> RISC-V will also use Arm's three cpumasks. These were in smp.h,
> but they can be in cpumask.h instead, so move them there, which
> is now shared.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric
> ---
>  lib/arm/asm/smp.h | 33 ---------------------------------
>  lib/cpumask.h     | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index bb3e71a55e8c..b89a68dd344f 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -23,39 +23,6 @@ extern bool cpu0_calls_idle;
>  extern void halt(void);
>  extern void do_idle(void);
>  
> -extern cpumask_t cpu_present_mask;
> -extern cpumask_t cpu_online_mask;
> -extern cpumask_t cpu_idle_mask;
> -#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
> -#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
> -#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
> -#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
> -#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
> -
> -static inline void set_cpu_present(int cpu, bool present)
> -{
> -	if (present)
> -		cpumask_set_cpu(cpu, &cpu_present_mask);
> -	else
> -		cpumask_clear_cpu(cpu, &cpu_present_mask);
> -}
> -
> -static inline void set_cpu_online(int cpu, bool online)
> -{
> -	if (online)
> -		cpumask_set_cpu(cpu, &cpu_online_mask);
> -	else
> -		cpumask_clear_cpu(cpu, &cpu_online_mask);
> -}
> -
> -static inline void set_cpu_idle(int cpu, bool idle)
> -{
> -	if (idle)
> -		cpumask_set_cpu(cpu, &cpu_idle_mask);
> -	else
> -		cpumask_clear_cpu(cpu, &cpu_idle_mask);
> -}
> -
>  extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
>  extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpu(int cpu, void (*func)(void *data), void *data);
> diff --git a/lib/cpumask.h b/lib/cpumask.h
> index d30e14cda09e..be1919234d8e 100644
> --- a/lib/cpumask.h
> +++ b/lib/cpumask.h
> @@ -119,4 +119,37 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
>  			(cpu) < nr_cpus; 			\
>  			(cpu) = cpumask_next(cpu, mask))
>  
> +extern cpumask_t cpu_present_mask;
> +extern cpumask_t cpu_online_mask;
> +extern cpumask_t cpu_idle_mask;
> +#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
> +#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
> +#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
> +#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
> +#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
> +
> +static inline void set_cpu_present(int cpu, bool present)
> +{
> +	if (present)
> +		cpumask_set_cpu(cpu, &cpu_present_mask);
> +	else
> +		cpumask_clear_cpu(cpu, &cpu_present_mask);
> +}
> +
> +static inline void set_cpu_online(int cpu, bool online)
> +{
> +	if (online)
> +		cpumask_set_cpu(cpu, &cpu_online_mask);
> +	else
> +		cpumask_clear_cpu(cpu, &cpu_online_mask);
> +}
> +
> +static inline void set_cpu_idle(int cpu, bool idle)
> +{
> +	if (idle)
> +		cpumask_set_cpu(cpu, &cpu_idle_mask);
> +	else
> +		cpumask_clear_cpu(cpu, &cpu_idle_mask);
> +}
> +
>  #endif /* _CPUMASK_H_ */

