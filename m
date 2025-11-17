Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A4023C512
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763403199; cv=none; b=UIMifQITq0bzoJKLD0XKnN940GW/5xwjrXFI/X9G99IMikly2qFz1C5RnWm6hdS8YKtTLqR6FQxFdDn+a7Uo3oWWxwVpr2xKkaC+2VX85A4M0cxvoDRW17+bGjyw7XK1g3Q1GRncJvslWNaiA3c6r4SK5MpQ7avP95JnYdAY+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763403199; c=relaxed/simple;
	bh=L+r8tMHNl4AZkUtOJbtkVeGRmYSN+YUhDRJuFJK1a3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0V3qRuAvLS0qm82LdjDctetFXO3SXdZlYmqzbngarAzPeoR18MFpy6r5WJZCipPMhN2FD4cifGdZJfv3GV1ZT1VHmA5A2n1C4xd/YaNetehkAM03zltr8kYyknQqPsHYYThSwWzS0CG1nMRz6xXT/JO8621pzsLaFjbkIbKGxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JipRzz+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JipRzz+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93690C19422;
	Mon, 17 Nov 2025 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763403198;
	bh=L+r8tMHNl4AZkUtOJbtkVeGRmYSN+YUhDRJuFJK1a3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JipRzz+juWRZKQZtrtsq3lvLrD+MBnmFUjuSSptmnaXO80OsHFuCidz7Qy4h+Ejb6
	 jOtXLlinEDg5/WBjlcp3OsChAO2+HAt2VvpiC2kUQoP8wXChHdE2bWSIg7q44ylLY7
	 MwQDY9DpnI2gew38Ds/aZtLpR5Lo3pd86xOOyWrDqUATdDZhnEvf9HePLqk+6HylX9
	 Elj6i1+BBREhtLw/TtOFjTxtbJxhbwRl8V3aIfsyobpURkQoZ39vf1ClsfdWVRmYUb
	 eUGwVVCBeopfrL3k4ktCHrXahUMEo/VDoQ+8VGK2RWZvajEQlAtPEh0rjYHf8tATPo
	 jk3ncJFi6eqxg==
Date: Mon, 17 Nov 2025 10:13:16 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 09/12] KVM: arm64: Add helper for swapping guest
 descriptor
Message-ID: <aRtlvNj9yMZoVb9g@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
 <20251112183406.2118981-10-oupton@kernel.org>
 <86zf8ksq53.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zf8ksq53.wl-maz@kernel.org>

On Mon, Nov 17, 2025 at 02:14:00PM +0000, Marc Zyngier wrote:
> On Wed, 12 Nov 2025 18:34:03 +0000,
> Oliver Upton <oupton@kernel.org> wrote:
> > +static int __llsc_swap_desc(u64 __user *ptep, u64 old, u64 new)
> > +{
> > +	unsigned int loops = 128;
> > +	u64 tmp;
> > +	int ret;
> > +
> > +	uaccess_enable_privileged();
> > +
> > +	asm volatile("prfm	pstl1strm, %[addr]\n"
> > +		     "1: ldxr	%[tmp], %[addr]\n"
> > +		     "sub	%[tmp], %[tmp], %[old]\n"
> > +		     "cbnz	%[tmp], 3f\n"
> > +		     "2: stlxr	%w[ret], %[new], %[addr]\n"
> > +		     "cbz	%w[ret], 4f\n"
> > +		     "sub	%w[loops], %w[loops], #1\n"
> > +		     "cbnz	%w[loops], 1b\n"
> > +		     "3: mov	%w[ret], %w[eagain]\n"
> > +		     "4:\n"
> > +		     : [ret] "=r" (ret), [addr] "+Q" (*ptep), [tmp] "=&r" (tmp),
> > +		       [loops] "+r" (loops)
> > +		     : [old] "r" (old), [new] "r" (new), [eagain] "Ir" (-EAGAIN)
> > +		     : "memory");
> 
> Why doesn't this need an exception table as well? I'd expect it to
> fault just as much as the LSE version (and ret cannot report -EFAULT,
> for example).

I just threw in ${something} to satisfy the LL/SC case, so yes, this
needs exception fixup as well.

> I'm also on the fence about the bounded loop. Yes, forward progress is
> a problem, but it should only affect large systems which can readily
> use the atomic instructions. I'd rather we get rid of it until proven
> that we really need something like it.

From a letter of the architecture POV I'm not sure we even need the
LL/SC implementation. As of now the only non-nested use case is the SEA
TTW walker which doesn't set the access flag (nor should it) and any
implementation that has FEAT_NV must also have FEAT_LSE.

I guess that just leaves the recursive NV case where a VMM explicitly
de-features FEAT_LSE. So I guess having a trivial, non-looping
implementation would be enough to cover this pointless issue.

Thanks,
Oliver
