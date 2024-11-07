Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251CF215F7A
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731002167; cv=none; b=kX5EuhHURjpbNqrR7+oFu9fMBcMf3+R1/ceORU5pjIYJCtCJt+O9A+xfmw2AQZ9fyJZQgb0wyxncfeBsB1OF9Akl3DPNBjtumR5BVva31ng+BVQpezvbIiQmaJNPcf/Hl+tJ4jurFRsiEw0x4KaJzUwLgM9Igx8e92y/0EMEYWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731002167; c=relaxed/simple;
	bh=Ve+RSaEYMJhnNDsXjuDtqnqP0abDltYBaZlYOWL4ptI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5aps/3NcJ8LbhqqF1Xdyt0ctzv4hdfoJXznLimHX09Jecnp8li7yxDa92RfEi4MGp3phOqkG9Q4KQVcI7nO+aw344XJN20OPN+W/eFPjNj8fgJbBEoyMmn+Zb/4NdssD3DJZ/0RwoA8i/j5ji5OizwX5LgA5+DP5Xm4kfGvfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKG0vwgm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKG0vwgm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731002165;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nIvkqFWOBnpaxs9X2j4yQ/cA3cQgdm32nOtnZY57FZA=;
	b=YKG0vwgm7s4rd6/OHIhimy8f9OBI13zZrTp88t0oTPqsPLdSbE1mWlIzGhI5/2dsXFx8Ys
	6eHz5c6A/bfsdVuZqKDNyf+e8JmuNko/fXD/bV9cEDBnpgDGPbSfpP7+sR8crrMDi6MhHF
	kXNDOeXflV7OXe/GmLvp1goA+FYBk6g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-A_EwRIQrNi2gFoL2COHMOg-1; Thu, 07 Nov 2024 12:56:03 -0500
X-MC-Unique: A_EwRIQrNi2gFoL2COHMOg-1
X-Mimecast-MFC-AGG-ID: A_EwRIQrNi2gFoL2COHMOg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4316e2dde9eso11358855e9.2
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 09:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731002163; x=1731606963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nIvkqFWOBnpaxs9X2j4yQ/cA3cQgdm32nOtnZY57FZA=;
        b=IXJhiuYHGF2IGa8AfC4QLQNulS2Xv/b5jHf3GUQ+Yh2dOCZtgEg0YEWbxVC9gVu7s/
         15WcE/4jjLF3J8l0RVYTkJRPVcw+WdCR4SCb6YwLkE8oHsO2IdSiZUlGeqVs/zu6rOQy
         KswH8rxXfQqY7ZxzlJ5QA/CYRI7BqXnFXDNrGUMLrB5Xrm7DaU/bpkegJMboprUA8ujW
         HnJ6mp52uwGEZkyKEYlL2HsHhq9UvH7PlDYNr5fl6gOMVlJwvOMzZ0dJHJE10Lm90fUH
         8tq4Te7vABKSHaX9HUruRuGuZAgL0KbKgYlMaRx2zrk66Y+XqUm5Ji9LXYKqKuEe2nc9
         G0lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZB834xFDAy8ODC1+0DHeV+H7mL/WTrHvdTojrNhD1QxewJCkYI0H/mf/3SARnaX0WGxjNSzc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWOebQ25eO2ZiBQLJz9ZJaUIe7Lsp8VxBN+1xpmnOLU8fWYiXq
	Z8R6HnLb/ENzJ2yAYH3v1/KXq+7Dfs9GO8G6E0kIq5LlzcRxtODXFx8fxRfGPZh7tyRSv1CFyko
	ltBCTaM2cHOMYwYLyU8OdkUvC5AVcvcOCBVcqAdCuvIZIZVl3FYYn2w==
X-Received: by 2002:a7b:c459:0:b0:431:5f8c:ccb9 with SMTP id 5b1f17b1804b1-43283255a2cmr293641395e9.17.1731002162827;
        Thu, 07 Nov 2024 09:56:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNl1hiiW0EzosaMDaaHsyEroTn91oZ8mTZl1tDs9onS6Y3lW4fxtG4nWFez6Jkv/e2k7ohsg==
X-Received: by 2002:a7b:c459:0:b0:431:5f8c:ccb9 with SMTP id 5b1f17b1804b1-43283255a2cmr293641045e9.17.1731002162446;
        Thu, 07 Nov 2024 09:56:02 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed97cab2sm2295737f8f.23.2024.11.07.09.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 09:56:01 -0800 (PST)
Message-ID: <69196410-be02-4957-a871-a599dafe32d6@redhat.com>
Date: Thu, 7 Nov 2024 18:55:59 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib/on-cpus: Fix on_cpumask
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241031123948.320652-8-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20241031123948.320652-8-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y4h9LbWavIFpxJ6M9iIr79WfotYXC0FcbgXColRLHrg_1731002163
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 10/31/24 13:39, Andrew Jones wrote:
> on_cpumask should wait until the cpus in the mask, not including
> the calling cpu, are idle. Checking the weight against nr_cpus
> minus 1 only works when the mask is the same as the present mask.
>
> Fixes: d012cfd5d309 ("lib/on-cpus: Introduce on_cpumask and on_cpumask_async")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

looks good to me as well

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/cpumask.h | 14 ++++++++++++++
>  lib/on-cpus.c | 17 ++++++++---------
>  2 files changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/lib/cpumask.h b/lib/cpumask.h
> index e1e92aacd1f1..37d360786573 100644
> --- a/lib/cpumask.h
> +++ b/lib/cpumask.h
> @@ -58,6 +58,20 @@ static inline void cpumask_clear(cpumask_t *mask)
>  	memset(mask, 0, sizeof(*mask));
>  }
>  
> +/* true if src1 is a subset of src2 */
> +static inline bool cpumask_subset(const struct cpumask *src1, const struct cpumask *src2)
> +{
> +	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
> +	int i;
> +
> +	for (i = 0; i < BIT_WORD(nr_cpus); ++i) {
> +		if (cpumask_bits(src1)[i] & ~cpumask_bits(src2)[i])
> +			return false;
> +	}
> +
> +	return !lastmask || !((cpumask_bits(src1)[i] & ~cpumask_bits(src2)[i]) & lastmask);
> +}
> +
>  static inline bool cpumask_empty(const cpumask_t *mask)
>  {
>  	unsigned long lastmask = BIT_MASK(nr_cpus) - 1;
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> index 356f284be61b..889b6bc8a186 100644
> --- a/lib/on-cpus.c
> +++ b/lib/on-cpus.c
> @@ -127,24 +127,23 @@ void on_cpumask_async(const cpumask_t *mask, void (*func)(void *data), void *dat
>  void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
>  {
>  	int cpu, me = smp_processor_id();
> +	cpumask_t tmp;
>  
> -	for_each_cpu(cpu, mask) {
> -		if (cpu == me)
> -			continue;
> +	cpumask_copy(&tmp, mask);
> +	cpumask_clear_cpu(me, &tmp);
> +
> +	for_each_cpu(cpu, &tmp)
>  		on_cpu_async(cpu, func, data);
> -	}
>  	if (cpumask_test_cpu(me, mask))
>  		func(data);
>  
> -	for_each_cpu(cpu, mask) {
> -		if (cpu == me)
> -			continue;
> +	for_each_cpu(cpu, &tmp) {
>  		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
>  		deadlock_check(me, cpu);
>  	}
> -	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
> +	while (!cpumask_subset(&tmp, &cpu_idle_mask))
>  		smp_wait_for_event();
> -	for_each_cpu(cpu, mask)
> +	for_each_cpu(cpu, &tmp)
>  		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
>  	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
>  }

