Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA8F18C01E
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727717645; cv=none; b=GjsblIpt0d9DqlevN1KAwAARCUTUpxl/siZIhKsI4+iifsTrk74tnuECSx2/61KBJaLUwjQbPRrU1pIY6rmYJW3x3nQBOktduVsz6J15yM6ldwqE5mkoCdnq/9MxWRZkJ9L/1ZoDV9fKTgx5jiMoaWvflcMDdqTO6/8wpjUTnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727717645; c=relaxed/simple;
	bh=WBFgmih4XDphQtQvpQVn0y9UX7p+bwx3yLTouWZLfo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiOtyeJwzShl6+XaIray8WJKuBeRfNhuTG99FiqBqEp0/bbmz0Wt3wJjxiSLaZ4NxGhsz07MJcOKUCsnrGz5Uwjj5DLLBNcPMCTB15ei3vOj1ZZKYOSi0NSmueHr3j3dk4l3wJOHNIWLNIpNkCbRqb92lB9bookE8VlKAsfXtkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vpIrdrLy; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vpIrdrLy"
Date: Mon, 30 Sep 2024 10:33:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727717637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogJbp6u/vFspt7UJMT890uGNRUquUQecrB2wvxTdQpg=;
	b=vpIrdrLybXMFg5ErJc8BKY0FmhG5mLCpONBaqJeuqHuw7jZUz5IRvqSJ/apTMwZV0uXwdW
	01S8HF2tA7WYgbAt75YjLLWQgzY+lnRQXNhgGzQVrDlkc8tkJfvsW25te4cNWZC+IuFAIf
	dveL98A3ryc3x2tEb7vN8GCNag2hcrU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Lilit Janpoladyan <lilitj@amazon.com>, kvm@vger.kernel.org,
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, nh-open-source@amazon.com,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/8] *** RFC: ARM KVM dirty tracking device ***
Message-ID: <Zvrg_r3lWtL-TZf_@linux.dev>
References: <20240918152807.25135-1-lilitj@amazon.com>
 <Zuvq18Nrgy6j_pZW@linux.dev>
 <c309adcc88d7fb55d1ca7fdb9c32a6cd9c827c74.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c309adcc88d7fb55d1ca7fdb9c32a6cd9c827c74.camel@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 26, 2024 at 11:00:39AM +0100, David Woodhouse wrote:
> > Beyond that, I have some reservations about maintaining support for
> > features that cannot actually be tested outside of your own environment.
> 
> That's more about the hardware driver itself which will follow, than
> the core API posted here.
> 
> I understand the reservation, but I think it's fine. In general, Linux
> does support esoteric hardware that not everyone can test every
> time. We do sweeping changes across all Ethernet drivers, for example,
> and some of those barely even exist any more.

Of course, but I think it is also reasonable to say that ethernet
support in the kernel is rather mature with a good variety of hardware.
By comparison, what we have here is a brand new driver interface with
architecture / KVM code, which is pretty rare, with a single
implementation.

I'm perfectly happy to tinker on page tracking interface(s) in the
future w/o testing everything, but I must insist that we have *some*
way of testing the initial infrastructure before even considering taking
it.

> This particular device should be available on bare metal EC2 instances,
> of course, but perhaps we should also implement it in QEMU. That would
> actually be beneficial for our internal testing anyway, as it would
> allow us to catch regressions much earlier in our own development
> process.

QEMU would be interesting, but hardware is always welcome too ;-)

> > > When ARM architectural solution (FEAT_HDBSS feature) is available, we intend to
> > > use it via the same interface most likely with adaptations.
> > 
> > Will the PTA stuff eventually get retired once you get support for FEAT_HDBSS
> > in hardware?
> 
> I don't think there is a definitive answer to that which is ready to
> tape out, but it certainly seems possible that future generations will
> eventually move to FEAT_HDBSS, maybe even reaching production by the
> end of the decade, at the earliest? And then a decade or two later, the
> existing hardware generations might even get retired, yes¹.
> 
> ¹ #include <forward-looking statement.disclaimer>

Well, hopefully that means you folks will look after it then :)

> > I think the best way forward here is to implement the architecture, and
> > hopefully after that your legacy driver can be made to fit the
> > interface. The FVP implements FEAT_HDBSS, so there's some (slow)
> > reference hardware to test against.
> 
> Is there actually any documentation available about FEAT_HDBSS? We've
> been asking, but haven't received it. I can find one or two mentions
> e.g. https://arm.jonpalmisc.com/2023_09_sysreg/AArch64-hdbssbr_el2 but
> nothing particularly useful.

Annoyingly no, the Arm ARM tends to lag the architecture by quite a bit.
The sysreg XML (from which I think this website is derived) gets updated
much more frequently.

> The main reason for posting this series early is to make sure we do all
> we can to accommodate FEAT_HDBSS. It's not the *end* of the world if
> the kernel-internal API has to be tweaked slightly when FEAT_HDBSS
> actually becomes reality in future, but obviously we'd prefer to
> support it right from the start.

Jury is still out on how FEAT_HDBSS is gonna fit with this PTA stuff.
I'm guessing your hardware has some way of disambiguating dirtied
addresses by VMID.

The architected solution, OTOH, is tied to a particular stage-2 MMU
configuration. KVM proper might need to manage the dirty tracking
hardware in that case as it'll need to be context switched on the
vcpu_load() / vcpu_put() boundary.

-- 
Thanks,
Oliver
