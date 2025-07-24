Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BD6F9E8
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339932; cv=none; b=JGUuYiUIRwORdb5PfNYikY6AVVAw1oCFa3OhityQ1b2iVean0rkFnTMPMAvIWkRsZPCLK6mk7vU2+vHRCGILMyXV35j5tFpJMwqAh+A37pkj1ctdnPfo6SvElo3Vtremc7/NQCfE8KYr8it4NnzKeByEjcHG7L4CzaG6f1I50jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339932; c=relaxed/simple;
	bh=GJIY4do+3UjlHPPQ/cO8rPzsqeO1bw4XGTv50v5QE2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qiKanMt1fUbi6P6FW5F2q1QFtwkPNWf67rJ/4/yAVlGP4POvFXVUJeF187Fnhu8bkD4VZfGDoyyGgJTy1DTpUM3ZQE9j6iCfauqLAxNBImh8bCe9eBreGjHcmsNlA6I2KD92ELZsWvkwB8bnQihXpaejpmvEGTm8Op+oDf2Sx0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vy35sepI; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vy35sepI"
Date: Wed, 23 Jul 2025 23:51:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753339928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rwMlEka4cJNY6w6I3TpYez2izlEFdQeUh6PWXpxUFGI=;
	b=vy35sepI5H0lMN6QsQEkxtboil6uVq6YnQn17xMIc8eo9SlFtOiCmmhUf2hsYJ9vCeVWaa
	7qRfgfdeD0P6J+2KUfWFaT8Wid5wV4/DmPorgt15Fr3xzKH8KjUcZ81D3PXdQDaI541r2u
	P0xxs9D9Skx6O6c5fUHtw0wnOwVP5Kc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/5] KVM: arm64: Config driven dependencies for
 TCR2/SCTLR/MDCR
Message-ID: <aIHYAeMb11eh2wih@linux.dev>
References: <20250714115503.3334242-1-maz@kernel.org>
 <175268446558.2457435.12236491763380805714.b4-ty@linux.dev>
 <276a28fa-c0a2-4ab7-8391-2c20831469e1@suse.cz>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276a28fa-c0a2-4ab7-8391-2c20831469e1@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 23, 2025 at 05:53:20PM +0200, Vlastimil Babka wrote:
> On 7/16/25 18:47, Oliver Upton wrote:
> > On Mon, 14 Jul 2025 12:54:58 +0100, Marc Zyngier wrote:
> >> Here's a very short (and hopefully not too controversial) series
> >> converting a few more registers to the config-driven sanitisation
> >> framework (this is mostly a leftover from the corresponding 6.16
> >> monster series).
> >> 
> >> Patches on top of -rc3.
> >> 
> >> [...]
> > 
> > Applied to next, thanks!
> 
> The following merge commit creates a ./diff file. Found out because I had
> some local leftover one which prevented git checkout of current next.
> 
> commit 811ec70dcf9cc411e4fdf36db608dc9bcffb7a06
> Merge: 5ba04149822c 3096d238ec49
> Author: Oliver Upton <oliver.upton@linux.dev>
> Date:   Tue Jul 15 20:40:59 2025 -0700
> 
>     Merge branch 'kvm-arm64/config-masks' into kvmarm/next
> 
>     Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 

Thanks for reporting this, I've added a fix on top of next and will
correct the merge when I rebuild the merge history to send the pull
request.

Thanks,
Oliver
