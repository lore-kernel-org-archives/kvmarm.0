Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF6A18FDCE
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 08:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730880945; cv=none; b=EHmgHx2KCNrYt6dsd6TF/twFnSvU5rW27CUL4oGnZuplN6ZP7fhWCbkqflWVkLZmEQbYdJBBebGLlzUr+3Pv+KS/XjgEOBLy+Y37oQaOzky5qxcEcZeNfuu82WJkX06s8oceqwv/ijlivXZJHzPgb1VQCOlOCP63VWiA5qdh7N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730880945; c=relaxed/simple;
	bh=8fw7y0ufn8alOZsJQrnBs1sftljzanf/bcsDxnTbGwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUlhvAOlRrCJ+a1cPcBQnRQ8ly0jRqsn7HSOssHWEnav/XQiQHTnoVrxXbld3HwW05y7DIn+LjGXVI4V/ejxOhoCd0r65V2Ev0JKWlo9qeOI/p88kuXxnz4nSc3Q40YWymVNjvLkzqxZ2LzvDJ9Fp5COgdyTI8C0mGL2emKDM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ELvIzerC; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ELvIzerC"
Date: Wed, 6 Nov 2024 09:15:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730880939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsMaYv3m940tgneEsZ4pQ4oYPa/rPcIiKpYEeNTsRWM=;
	b=ELvIzerC2NVng7M43243GE/8DSEqmW2a+EAbWgbzN2PQ0HfGxLoY2/IcrqQ7Ra3ps1PH1B
	vAO6IG/COlXOp9cBqPh/vK61M0FhZAobVaN4Xmnpmpm+La+p56buTAFZb4W86aeOQ7fhoW
	Suk8jgQTCmqxDYlqKcrQlWi/NemGTE8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib/on-cpus: Add barrier after
 func call
Message-ID: <20241106-9611aa66dfd52197b3b00e96@orel>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
 <20241031123948.320652-7-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031123948.320652-7-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 31, 2024 at 01:39:51PM +0100, Andrew Jones wrote:
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

I added a

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>

to this patch.

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
> -- 
> 2.47.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
