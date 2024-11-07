Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509581D88DD
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 10:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973701; cv=none; b=FmF8GLXk97wEeB/ug/s6Q2Ec2qS0Xd2o4B8PlZJ1a4hQ/QIA3HrpcOEaEhRwSXpVD3U3ZACnWaAYIgVmmUGQjiJ7+gyf2TsjIECgNa/Oh/eUD59G6TjB/xHypqBwWo6Isg/EKEF8Uj53NSQ7M77aP2IK5TAhlpnOhjA5Pb5CUsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973701; c=relaxed/simple;
	bh=9+NhR9Xx1+f3gRATsntD+gpT35PbVTys1g6H1FzxVgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XtdjlXvsEPaA3nvbAYvAL+9EqeDkvmYh3X7DrMgdtsjwssC4tqLLaq9dyci28chypoP0aVxaOKJUlB+/gnEvFdtz7jEEEbQ7diYOstDlifeAR1SJqQmZ61WHkS0kdk1JGT+fQgDUvQns7P+dEYk5qvXAXg4Qu+0jz3CV2kyajBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L66QiljQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L66QiljQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730973697;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mCpCB9JiGuUJDI4bEMY+hAs6rw+MftrWNvH37HOo7LU=;
	b=L66QiljQbT9jaqr1AtTdAhfZLtE440vkoI+4nDQBEoYhkF1Ropoxc/kX5Y4mBmgd8awCui
	e9TiU4RZp4gX+tWQny5OnIo/+cVaSanu3MwqJ+aP+m7TLdpX8B477jCqlpn3H2pxtRTkuj
	VygRPrp3mTmzfa+27W0FV4Lriwb9YPQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-KyGrJgxgNai6vR4CjLHL0Q-1; Thu, 07 Nov 2024 05:01:36 -0500
X-MC-Unique: KyGrJgxgNai6vR4CjLHL0Q-1
X-Mimecast-MFC-AGG-ID: KyGrJgxgNai6vR4CjLHL0Q
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-431604a3b47so4937375e9.3
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 02:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730973694; x=1731578494;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mCpCB9JiGuUJDI4bEMY+hAs6rw+MftrWNvH37HOo7LU=;
        b=mL3UVcTUb+vxBu6bBuJAH6D4XXEwE+zan7i1FqMccQDt0+x6a5FFHemQEKTaR81pCW
         dKKu7biADEbBNFHhpECm2d8aFp7dQAW6ZHYzfhMQgihFKqlSutgg4MBBYiynHplaIvJT
         wPTRBFaLqXDfQn50BPjrzlnGnt19RoimJSr0P8xC+44aO1epZEiOG9ZA6Ed4gjZHoCbC
         8xLte+q5236suVu3JiNhJFmj9NwjnEMjp8HqU9ba434re5lFSldx2l2rU+J6ivvD34+Q
         cbFKe3UMo24LdeIlM1qJk1r7t7K9l44dAQY0jrqTkwE6FuGu0LOKiQOX0uAQdHiNuqKr
         25UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVttdCKC7PFHiftM5gU+b6+m4RDVxgtt987HpUCp5u7hvEioerwYmU/W1u+NfLtpWzVYoScjIw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy9t3qF5zQ4toDqx2dkL1UB9R8qR8o/RyAC//BILno6sytSlyM
	W6AXPr6tkcGJ7EfP/IovUHrBPeMkgRDl5S299GymcjzlNtRRNbsCHapjRZ2883llZd4h/aT6eNh
	9y/gNrhAXIAJykkz4suQWnP7kko/zWSOCyuiOM84PLy9gjdDWlEMUrw==
X-Received: by 2002:a05:600c:500a:b0:431:561b:b32a with SMTP id 5b1f17b1804b1-4319acb8ce7mr389491745e9.19.1730973694502;
        Thu, 07 Nov 2024 02:01:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDbVGMXVLzPtnR/VZFbxL0VkGeLxamN/60E1uP2cgI2kd398S80zrlJSY+AcWQumz9NsWQYw==
X-Received: by 2002:a05:600c:500a:b0:431:561b:b32a with SMTP id 5b1f17b1804b1-4319acb8ce7mr389491485e9.19.1730973694135;
        Thu, 07 Nov 2024 02:01:34 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6b3069sm53583895e9.14.2024.11.07.02.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 02:01:31 -0800 (PST)
Message-ID: <fb52d778-79bc-41ca-845c-4d7044c7f0ee@redhat.com>
Date: Thu, 7 Nov 2024 11:01:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib/on-cpus: Correct and simplify
 synchronization
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241031123948.320652-6-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20241031123948.320652-6-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A0SlEZrKt6vnOTW9I2tjkSwki8jUgKDPNn7eIracppU_1730973695
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/31/24 13:39, Andrew Jones wrote:
> get/put_on_cpu_info() were providing per-cpu locking for the per-cpu
> on_cpu info, but it's difficult to reason that they're correct since
> they use test_and_set/clear rather than a typical lock. Just revert
> to a typical spinlock to simplify it. Also simplify the break case
> for on_cpu_async() - we don't care if func is NULL, we only care
> that the cpu is idle. And, finally, add a missing barrier to
> on_cpu_async(). Before commit 018550041b38 ("arm/arm64: Remove
> spinlocks from on_cpu_async") the spin_unlock() provided an implicit
> barrier at the correct location, but moving the release to the more
> logical location, below the setting of idle, lost it.
>
> Fixes: 018550041b38 ("arm/arm64: Remove spinlocks from on_cpu_async")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/on-cpus.c | 36 +++++++++++-------------------------
>  1 file changed, 11 insertions(+), 25 deletions(-)
>
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> index 892149338419..f6072117fa1b 100644
> --- a/lib/on-cpus.c
> +++ b/lib/on-cpus.c
> @@ -9,6 +9,7 @@
>  #include <on-cpus.h>
>  #include <asm/barrier.h>
>  #include <asm/smp.h>
> +#include <asm/spinlock.h>
>  
>  bool cpu0_calls_idle;
>  
> @@ -18,18 +19,7 @@ struct on_cpu_info {
>  	cpumask_t waiters;
>  };
>  static struct on_cpu_info on_cpu_info[NR_CPUS];
> -static cpumask_t on_cpu_info_lock;
> -
> -static bool get_on_cpu_info(int cpu)
> -{
> -	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> -}
> -
> -static void put_on_cpu_info(int cpu)
> -{
> -	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> -	assert(ret);
> -}
> +static struct spinlock lock;
>  
>  static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
>  {
> @@ -81,18 +71,14 @@ void do_idle(void)
>  	if (cpu == 0)
>  		cpu0_calls_idle = true;
>  
> -	set_cpu_idle(cpu, true);
> -	smp_send_event();
> -
>  	for (;;) {
> +		set_cpu_idle(cpu, true);
> +		smp_send_event();
> +
>  		while (cpu_idle(cpu))
>  			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> -		on_cpu_info[cpu].func = NULL;
> -		smp_wmb();
> -		set_cpu_idle(cpu, true);
> -		smp_send_event();
>  	}
>  }
>  
> @@ -110,17 +96,17 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
>  
>  	for (;;) {
>  		cpu_wait(cpu);
> -		if (get_on_cpu_info(cpu)) {
> -			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> -				break;
> -			put_on_cpu_info(cpu);
> -		}
> +		spin_lock(&lock);
> +		if (cpu_idle(cpu))
> +			break;
> +		spin_unlock(&lock);
>  	}
>  
>  	on_cpu_info[cpu].func = func;
>  	on_cpu_info[cpu].data = data;
> +	smp_wmb();
>  	set_cpu_idle(cpu, false);
> -	put_on_cpu_info(cpu);
> +	spin_unlock(&lock);
>  	smp_send_event();
>  }
>  

