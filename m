Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227329CF4
	for <kvmarm@lists.linux.dev>; Sat,  9 Nov 2024 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731172111; cv=none; b=ndshRRrHR2arTpwtLXbZxpqLWrzmAHZ+ttzljXfWN1m0UMWay7YcJR0BwRDo6FkEccJpyD5VzcOCzW4Us5hi67ehbbGwULSi4/kQcgCafaHzu7udiD452V1D+FDm8yweg2nbq993s83Mmx0yJAC9p4Op7B0+yKV3w5O8pCkOnCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731172111; c=relaxed/simple;
	bh=VFcncVr6m9WORTh/2XCweEC7Cx30pprMlvIkjoGWmbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGft5kKOUamQaXBncT8S0i8K7O1OaNHEjxcNHzC2H6IHBETukyYXellWIC8Gf6bqHwKljzZVw5zNKzqjpREWcdA1t65OUjZ4LGoEWojm1YshAHgr2OZzG4ncP62ghVJYnCUaMoSTTQO2+F1Aa97yIBqb+hwew4xRR/TMjo5w3rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xIxgNxqG; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xIxgNxqG"
Date: Sat, 9 Nov 2024 09:08:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731172106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uBErlaZH4eLbiT21NRCIM95KdknptBKYu6n86nNj/ow=;
	b=xIxgNxqGMHOz0Z7bDWpRKwF639Qqt+UaxfWh8U9c7tejHtPUReqfX6dPTLMesZE22d1b48
	ZKwP+upy1qlQm5pEQ8zvZlWcfHTYTr/+69KZTgaOLjffqVljKh9/inonCMyfoajtr1TwHF
	iwodFVaiRpwHXSjmv5nPFoJTSTCCdlo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 00/15] KVM: arm64: Debug cleanups
Message-ID: <Zy-W_Wpj_ZnFK4C7@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <86ttcgzh25.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ttcgzh25.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 09, 2024 at 01:13:06PM +0000, Marc Zyngier wrote:
> On Fri, 08 Nov 2024 22:24:04 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > The debug code has become a bit difficult to reason about, especially
> > all the hacks and bandaids for state tracking + trap configuration.
> > 
> > This series reworks the entire mess around using a single enumeration to
> > track the state of the debug registers (free, guest-owned, host-owned),
> > using that to drive trap configuration and save/restore.
> > 
> > On top of that, this series wires most of the implementation into vCPU
> > load/put rather than the main KVM_RUN loop. This has been a long time
> > coming for VHE, as a lot of the trap configuration and EL1 state gets
> > loaded into hardware at that point anyway.
> > 
> > The save/restore of the debug registers is simplified quite a bit as
> > well. KVM will now restore the registers for *any* access rather than
> > just writes, and keep doing so until the next vcpu_put() instead of
> > dropping it on the floor after the next exception.
> 
> Overall, I really like the shape of this. It is a great bit a
> refactoring, and while I left a few comments on the bits that I think
> can be improved, it is already a good candidate for 6.14.
> 
> My only gripe is that it drops a fair bit of "documentation" without
> replacing it with something more current. Given the more "distributed"
> nature of the new code, having some sort of high-level description of
> the handling flow in debug.c would very much help (even it the outcome
> is a less impressive diffstat ;-).

Thanks for reviewing it. I should've made mention about it in the cover
letter, but I dumped a lot of the existing documentation because I found
it to be rambly and actually make things _less_ clear.

But I agree, a centralized description of what's going on would be
useful.

-- 
Thanks,
Oliver
