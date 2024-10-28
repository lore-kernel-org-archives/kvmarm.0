Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9E91DF246
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730135578; cv=none; b=kfGCkcNrf9e5njJx+yFgkzJNV8Dv8NV8l7TSWC8tVVh0zXCNQybfQMrbN1SWoi0+DZSP7zU+0FUUVkJtzZ075vt1yXgoJPKY55U0BwdP/oPw+/hRhJhfi4hB1SNJXLqD4cBeZjz/ExHVFYcVyAJhh9x7it3J4A0NHg/UCdQ3NQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730135578; c=relaxed/simple;
	bh=9bYoCIsnrgKl6DpNAORtUU0H6P5iGPO4aZKZIFs2FaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFf6ZF+m1Ur6SeL2btnwjMiIFeYRGSjXKBu6grBuPXUKEPRKidmPbBmcjUp/EIjJTDY+XKKfTFYroiBA3/6aveQ5c0JcLitW8d0NpcV1IC364lSGwdnu8eo4KTlNit7MUqtvxSFPW4pOMMYbBHuhncUFj2SKCfWk+sYB6UXkqJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ISoeuTHA; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ISoeuTHA"
Date: Mon, 28 Oct 2024 10:12:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730135573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJZPIUyASHKIZLcZxFmHyTQ9c7DQ9IIhScA6QACGQKE=;
	b=ISoeuTHAKwgwBa2kBiuaCcAGs7PdxTWGaWY/mOQZ9bZkhdCOVcSRoidFFrOLPrTdVkuGrV
	dzVigfMa+dOk0U+4Wokxm7lP7150WrsL30abwP2Oe6nC8YZw/zchsSxzefQykjeM7+Q5B6
	JaC3dxU+91EV66rlqx4xWmYmItFxONM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, stable@vger.kernel.org,
	syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] KVM: arm64: Mark the VM as dead for failed
 initializations
Message-ID: <Zx_GDqLO4lBQHnxL@linux.dev>
References: <20241025221220.2985227-1-rananta@google.com>
 <Zxx_X9-MdmAFzHUO@linux.dev>
 <87ttcztili.wl-maz@kernel.org>
 <Zx0CT1gdSWVyKLuD@linux.dev>
 <CAJHc60wn=vA9j421FhVkMqYc0w8u2ZYuc-9TJ+rvriSXjseKHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60wn=vA9j421FhVkMqYc0w8u2ZYuc-9TJ+rvriSXjseKHw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 28, 2024 at 09:43:45AM -0700, Raghavendra Rao Ananta wrote:
> On Sat, Oct 26, 2024 at 7:53 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > On Sat, Oct 26, 2024 at 08:43:21AM +0100, Marc Zyngier wrote:
> > > I think this would fix the problem you're seeing without changing the
> > > userspace view of an erroneous configuration. It would also pave the
> > > way for the complete removal of the interrupt notification to
> > > userspace, which I claim has no user and is just a shit idea.
> >
> > Yeah, looks like this ought to get it done.
> >
> > Even with a fix for this particular issue I do wonder if we should
> > categorically harden against late initialization failures and un-init
> > the vCPU (or bug VM, where necessary) to avoid dealing with half-baked
> > vCPUs/VMs across our UAPI surfaces.
> >
> > A sane userspace will probably crash when KVM_RUN returns EINVAL anyway.
> 
> Thanks for the suggestion. Sure, I'll take another look at the
> possible things that we can uninitialize and try to re-spin the patch.
> 
> Marc,
> 
> If you feel userspace_irqchip_in_use is not necessary anymore, and as
> a quick fix to this issue, we can get rid of that independent of the
> un-init effort.

It's a good cleanup to begin with, even better that it fixes a genuine
bug.

Raghu, could you please test Marc's diff and send it as a patch (w/
correct attribution) if it works? I'm willing to bet that we have more
init/uninit bugs lurking, so we can still follow up w/ robustness
improvements once we're happy w/ the shape of them.

-- 
Thanks,
Oliver
