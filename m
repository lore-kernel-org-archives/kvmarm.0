Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88CE42A83
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724361647; cv=none; b=o8Indcci01G0PouuPtikydnFBULACH0ALgyUV8tJ+THFxseTwg/uokOVga5t/+ESy3qpqDeGdwUwQmZydFeRJvHUUKxeiieG4nnfZk/saq0zOtfpE4GJCr65W+Rm9eVe1yAUWY3IbaWGYaD1+wAmgIBgLgMFJDYX3+dY0MoQ/TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724361647; c=relaxed/simple;
	bh=HaEB8v/H9ikE0TRbvsmyjUpGf4xWtUKBbZoRa1XX5C4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ATfb3a9YhgXIFxwsOoiVpBDT24xtfVsKQVIcHUmX8XeORu26hq030KTtgLjwfThh4ZsOSxbt8/wYrOGE+SQfc97YoRXiYBNNz3rifLaGqbv2q9rMyksWqXNufmDDorUlx+3Ti6Q2cYDLIMet8hTUSR9zbVUreFbH2iyO2Sk32yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NttPQIj4; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=q/V1sD4C; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NttPQIj4";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="q/V1sD4C"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724361644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w8w5KFvwMEkPaR1nlkraOvagGUvNuN8aW94+98RSA6Q=;
	b=NttPQIj49COj8Q3doWN4BqlRwYJ6oFot5UkRfolWKXvNI6c8gfH7qAUVNUofNftT4uKwTt
	KrKksbzvD5cs80lhYYo5GPMKh7znPTCAt8bMxth3B+l28SQAV7/LgPHx8PMc7TysDVr3Gv
	zbk4nWr/FfO2EGpgZ75d5BD4ZEarWeDiUBDvMC59Nm+QWaISu2JCUqLmdG7UIKJ9R9m1s3
	K+ZuGwEweuhpoKjwX0AoKvsgS7MmCVl2EqyagvWxk9zRU8gEW+jjWIDqKtEm8hdU8Evrs7
	Sc/M429m2F9exiyq/bnLwxlA4GklODeVQDs3vt8AfQB9UNZ4Kh3emVxhJTm4Fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724361644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w8w5KFvwMEkPaR1nlkraOvagGUvNuN8aW94+98RSA6Q=;
	b=q/V1sD4C5mziHs7on644hl9X0kv7fJs3fKc/kI2dn1PA5qwVHviMg3KmFCTOoy3XN1f+/n
	lB+lMODTwRy834Aw==
To: Marc Zyngier <maz@kernel.org>, Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, "open list:IRQ
 SUBSYSTEM" <linux-kernel@vger.kernel.org>, "moderated list:ARM SMMU
 DRIVERS" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.linux.dev,
 "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
 nizhiqiang1@huawei.com, "tangnianyao@huawei.com" <tangnianyao@huawei.com>,
 wangzhou1@hisilicon.com
Subject: Re: [bug report] GICv4.1: multiple vpus execute vgic_v4_load at the
 same time will greatly increase the time consumption
In-Reply-To: <864j7cybay.wl-maz@kernel.org>
References: <a7fc58e4-64c2-77fc-c1dc-f5eb78dbbb01@huawei.com>
 <86msl6xhu2.wl-maz@kernel.org>
 <f1574274-efd8-eb56-436b-5a1dd7620f2c@huawei.com>
 <867cc9x8si.wl-maz@kernel.org>
 <bd3c3103-a6d7-a91b-911d-5bc5f2382dae@huawei.com>
 <864j7cybay.wl-maz@kernel.org>
Date: Thu, 22 Aug 2024 23:20:43 +0200
Message-ID: <87o75kgspg.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Aug 22 2024 at 13:47, Marc Zyngier wrote:
> On Thu, 22 Aug 2024 11:59:50 +0100,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> > but that will eat a significant portion of your stack if your kernel is
>> > configured for a large number of CPUs.
>> > 
>> 
>> Currently CONFIG_NR_CPUS=4096,each `struct cpumask` occupies 512 bytes.
>
> This seems crazy. Why would you build a kernel with something *that*
> big, specially considering that you have a lot less than 1k CPUs?

That's why CONFIG_CPUMASK_OFFSTACK exists, but that does not help in
that context. :)

>> > The removal of this global lock is the only option in my opinion.
>> > Either the cpumask becomes a stack variable, or it becomes a static
>> > per-CPU variable. Both have drawbacks, but they are not a bottleneck
>> > anymore.
>> 
>> I also prefer to remove the global lock. Which variable do you think is
>> better?
>
> Given the number of CPUs your system is configured for, there is no
> good answer. An on-stack variable is dangerously large, and a per-CPU
> cpumask results in 2MB being allocated, which I find insane.

Only if there are actually 4096 CPUs enumerated. The per CPU magic is
smart enough to limit the damage to the actual number of possible CPUs
which are enumerated at boot time. It still will over-allocate due to
NR_CPUS being insanely large but on a 4 CPU machine this boils down to
2k of memory waste unless Aaarg64 is stupid enough to allocate for
NR_CPUS instead of num_possible_cpus()...

That said, on a real 4k CPU system 2M of memory should be the least of
your worries.

> You'll have to pick your own poison and convince Thomas of the
> validity of your approach.

As this is an operation which is really not suitable for on demand
or large stack allocations the per CPU approach makes sense.

Thanks,

        tglx
