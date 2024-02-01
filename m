Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE5215B0FB
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706779377; cv=none; b=PpBQ09yIUDIVQ54OzvvJVBfwJnhz0fHiZdoG4EzjzvV7MQplmf8Rj2C9d32QdNxzUvuPuwUNTFFIOrYX5vTRDS7cXYZOqlBHEBsSTMJWmDmj09n6GQYpAEmiZDT7p4vmjcvjhv/Hzc9s+TOzCVtgGJruIvxqbfz0RnZIJTzTZ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706779377; c=relaxed/simple;
	bh=VioJxwMJIRkuwozVUM8QmfeNEn+A4QsocCdq3vb/loo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EunL9aV0I4C4gJmOOxNyMSIb0fRnXnwsgiux7iEA7CH1Faq0OWNZuRGBGAjB9XmrtdHa8mMhmSi8hYSxJhnbsLXktuaUCn+RbC3xFKkeh2fbgtUhxoDK80AY+E0W/hVWMoiXo93kPVswsjOoOLFl85RyercuqC0c/lU7XMyV4+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZ3FzPk4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZ3FzPk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706779374;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XWZ+yadK+kdwISy8VmBuG3S1iOvZd1GlxEVqXWoMVAY=;
	b=iZ3FzPk4nUIQiMpjGjXx1DubIZV76L1igJM11PMwPrZ9wFD0gSGIlqST7PoJwb2RJstXDI
	YHBcB4XGsEHnttxNJgB9zCnv3BpjMHyX+8SUB7IMtH/fB6EX/OtmQNGMMA3tkQP471zVqo
	uoQh5Rft8+6KWgVxh+p6LbMvgsZBWuE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-jn5JprP4PMG0E4taQNmtlQ-1; Thu, 01 Feb 2024 04:22:52 -0500
X-MC-Unique: jn5JprP4PMG0E4taQNmtlQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33b0c264abbso364446f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 01:22:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706779372; x=1707384172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWZ+yadK+kdwISy8VmBuG3S1iOvZd1GlxEVqXWoMVAY=;
        b=Oo5Qf9cxmjR/9ERIJU3AB7VAqUqpVga4Ffrju62zC0wg9rfETVzNobs37BaEWZpMUn
         RXkW9FiKxkaWhShgGq65K8Q9qXh+HV3s1mQHeKkEr8VUFLRMr7Tnk+WMoLcRwxunLNQI
         MGqW+0BGtL0kMnVZ/ecDLsrZpi3n/uGanAQ40ahsaJPAjYgNtTmpJmkvW4A/iCZL1xPH
         tPvtlfvK9g2wyr8eIquTOs6RJM48BBv09Ub5LQ4gXulmqMsTDRwNxxw5ouLjsmiseOWq
         eS5tYZDu+tk4/UsyDpKUV3Vcu1l2/a7c0KVU8t6lB5GNrUX5buR+U8acxwqrZ2/iS/8L
         MnTw==
X-Gm-Message-State: AOJu0YysWEDloofKpDMVogxSODrPCG3GPiT/PuOp5+1nLRGzjVx2u11C
	d7t7g85la8I+WFvXMqlN6AsBjKQF4eq/yB5uamM3NvhQubVyhuY8MQwx9sZPb/gvuXjW6zDYK6e
	bSReheUozrIh8EycTzRpV7S9DKQHWQMRNHDP5ZnEjqWI1OBnd3jnc2g==
X-Received: by 2002:a05:6000:1375:b0:33b:150c:2d50 with SMTP id q21-20020a056000137500b0033b150c2d50mr891728wrz.16.1706779371793;
        Thu, 01 Feb 2024 01:22:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpkpLYGKP7afPtGOqfWpm9X9NQOYeGH9SbDyXD1r4xrzxjbYAVTZK5n2JDppwz1ADZEIapbg==
X-Received: by 2002:a05:6000:1375:b0:33b:150c:2d50 with SMTP id q21-20020a056000137500b0033b150c2d50mr891716wrz.16.1706779371467;
        Thu, 01 Feb 2024 01:22:51 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXSRMBamd/eEaRCAvxYsTirCe8TfxXURJCsXvNDf62Pyy5rKVTr5zBfOjuGSiOWl4T092+FnOZX/duyO54k+uBVnM1/b+Rny42ghANXI0z6JC2z1vqe4ELbTakot7EOkLqi/3pTxKv3jjUaKrl2s0PUw46UZITfJMQFcvvyFtAAMGm+czaQusmbIfBNMB/3wmBOZ/ENqi2MgQYJfNnAJ/Xfw/j3m9FBccXpCAKq15GYLnUiVwGQGx01s14mZBUJzb8SZ+yKvNQyut1Tx8ll574HG6FsxVjPJmUSo4jO9dnKu3MbWNn7dRs=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ce2-20020a5d5e02000000b0033af4848124sm8741803wrb.109.2024.02.01.01.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 01:22:51 -0800 (PST)
Message-ID: <3623c065-8842-4570-a591-5d0b11911dee@redhat.com>
Date: Thu, 1 Feb 2024 10:22:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 11/24] arm/arm64: Generalize wfe/sev
 names in smp.c
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-37-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-37-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> Most of Arm's on_cpus() implementation can be shared by any
> architecture which has the possible, present, and idle cpumasks,
> like riscv does. Rename the exceptions (wfe/sve) to something
> more generic in order to prepare to share the functions.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  lib/arm/asm/smp.h |  4 ++++
>  lib/arm/smp.c     | 16 ++++++++--------
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index b89a68dd344f..9f6d839ab568 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -6,6 +6,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <cpumask.h>
> +#include <asm/barrier.h>
>  #include <asm/thread_info.h>
>  
>  #define smp_processor_id()		(current_thread_info()->cpu)
> @@ -18,6 +19,9 @@ struct secondary_data {
>  };
>  extern struct secondary_data secondary_data;
>  
> +#define smp_wait_for_event()	wfe()
> +#define smp_send_event()	sev()
> +
>  extern bool cpu0_calls_idle;
>  
>  extern void halt(void);
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index 78fc1656cefa..c00fda2efb03 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -45,7 +45,7 @@ secondary_entry_fn secondary_cinit(void)
>  	 */
>  	entry = secondary_data.entry;
>  	set_cpu_online(ti->cpu, true);
> -	sev();
> +	smp_send_event();
>  
>  	/*
>  	 * Return to the assembly stub, allowing entry to be called
> @@ -65,7 +65,7 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
>  	assert(ret == 0);
>  
>  	while (!cpu_online(cpu))
> -		wfe();
> +		smp_wait_for_event();
>  }
>  
>  void smp_boot_secondary(int cpu, secondary_entry_fn entry)
> @@ -122,7 +122,7 @@ static void cpu_wait(int cpu)
>  	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
>  	deadlock_check(me, cpu);
>  	while (!cpu_idle(cpu))
> -		wfe();
> +		smp_wait_for_event();
>  	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
>  }
>  
> @@ -134,17 +134,17 @@ void do_idle(void)
>  		cpu0_calls_idle = true;
>  
>  	set_cpu_idle(cpu, true);
> -	sev();
> +	smp_send_event();
>  
>  	for (;;) {
>  		while (cpu_idle(cpu))
> -			wfe();
> +			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
>  		on_cpu_info[cpu].func = NULL;
>  		smp_wmb();
>  		set_cpu_idle(cpu, true);
> -		sev();
> +		smp_send_event();
>  	}
>  }
>  
> @@ -174,7 +174,7 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
>  	on_cpu_info[cpu].data = data;
>  	spin_unlock(&lock);
>  	set_cpu_idle(cpu, false);
> -	sev();
> +	smp_send_event();
>  }
>  
>  void on_cpu(int cpu, void (*func)(void *data), void *data)
> @@ -201,7 +201,7 @@ void on_cpus(void (*func)(void *data), void *data)
>  		deadlock_check(me, cpu);
>  	}
>  	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
> -		wfe();
> +		smp_wait_for_event();
>  	for_each_present_cpu(cpu)
>  		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
>  }

