Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C6523E
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:23:25 +0000 (UTC)
Date: Mon, 12 Jun 2023 21:23:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686597803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VoFEAuVwOY3XqcTpIIfzF8I2Id06bx2MaKaLwxXY24=;
	b=s7hNrebUk4IUMZ42L93mLuIvclILWgQUOmZt9Um7p44y3XOk+GR0wewDdrEotdQXB+Qmn5
	Izt1tMfGFrsV0rJNPPN4WLGTv2IJQEqFRSz9v6QVCHbrYcostEQaog8Jm091h9K9AnIpaM
	VOHDNEk+Brt/3aHqa7P5j2WgQTXR5D8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: timers: Fix resource leaks in
 kvm_timer_hyp_init()
Message-ID: <ZIdwqWKxgntYthoB@linux.dev>
References: <e0dd820f-52d2-4c54-97f3-5aa02e0bd6e0@kili.mountain>
 <ZIbKJPx2RR0Le7Zl@linux.dev>
 <0fc3126f-efb2-4d8c-9896-2c1b281919df@kadam.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc3126f-efb2-4d8c-9896-2c1b281919df@kadam.mountain>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 12, 2023 at 11:00:20AM +0300, Dan Carpenter wrote:
> On Mon, Jun 12, 2023 at 07:32:52AM +0000, Oliver Upton wrote:
> > > +
> > > +out_free_ptimer_irq:
> > > +	if (info->physical_irq > 0)
> > > +		free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
> > 
> > nit: we shouldn't even jump to this label in the first place if
> > there was no ptimer irq to set up... Maybe just drop the condition?
> > 
> 
> The condition is not necessary but I added it deliberately for
> readability and in case we ever add more allocations to this function.
> I want to keep it.

Fair enough. And if your fix is any indicator, we're liable to screw up
error handling again in the future :)

> > >  out_free_irq:
> > 
> > I'd prefer this label be renamed 'out_free_vtimer_irq' to make it
> > unambiguous.
> 
> I would prefer this too, but I left it out because I don't like to
> rename things unnecessarily.  However, since we both prefer this, then
> I will rename it.

Thanks! Please do send out a v2 when you have a moment, as I'd like to
pick this up for 6.5.

--
Thanks,
Oliver
