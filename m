Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0615372F3
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180064; cv=none; b=Vm14bfwDmNKnCdFrcDSXzt95XQZCKRrT45IKsknHTzbrBuSNbJGJ93PMLjD7fEDQ9kdq/ZxYXf50iJtSQlBYVsjFkY0aJu0NlRlIs/kxmWBTjgjPjV4OgEDxhpJ96KuypTUYI1tymwYbywGXz6c7uIZdZGhH7XW89H1jxuQTaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180064; c=relaxed/simple;
	bh=9EBIGd9e2m8HBAqkNbb+EjJdoUI8yMILNRtqw6GVPOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNjMvgveh0RJIdYUStO1okw0GovvvFLukrenx32aDkR5PR5jdXy/cxBmAI5Hb7gg+YMp2Mqd0LZLaXKyLmHKuOpC3iD3yWhjwWLxXgHUgbYnLcVoQ0Z6GOxTMybPEzsNmLwn4V0qZK3YXILIlz/pi+P4fVG1kxNqpFrBopQWA6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=feFCPkW3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="feFCPkW3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECBAE1570;
	Wed, 23 Sep 2026 09:14:16 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5E003F86C;
	Wed, 23 Sep 2026 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790180060; bh=9EBIGd9e2m8HBAqkNbb+EjJdoUI8yMILNRtqw6GVPOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=feFCPkW3shidAGRi0gtGaIPg3jJgWeecq0pXz59fMYfi8toH2Aqe7aKu0CfWK44oP
	 rdyQJRrd761lAhO9YIBPaZxDGNYUb43W0pIcLL53BP5YZz8ZiFXjk9lM6W/bw5dIXS
	 U20QZqzwHUbjqAFoAi6n3VA4EwUl+Nb3TJo3eSs0=
Date: Wed, 23 Sep 2026 17:14:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Linus Walleij <linusw@kernel.org>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
Message-ID: <arP619hd9Rx8Vlrx@arm.com>
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
 <aqq1sxdQNZ93oV9A@LeoBrasDK>
 <aqq7oZzutLP82WYB@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqq7oZzutLP82WYB@LeoBrasDK>

On Wed, Sep 16, 2026 at 04:54:09PM +0100, Leonardo Bras wrote:
> On Wed, Sep 16, 2026 at 04:28:51PM +0100, Leonardo Bras wrote:
> > On Wed, Sep 16, 2026 at 12:03:56PM +0200, Linus Walleij wrote:
> > > There is no need to try to second-guess the compiler when
> > > clearing memory. Just call memset() like everyone else.
> > > 
> > > Since memset() already has an architecture-local MOPS
> > > optimization, we do not need to do anything else to preserve
> > > the MOPS optimization.
> > > 
> > > While at it, implement the shorthand for directly calling
> > > the new prototype clear_pages() for larger page chunks.
> > > 
> > > No performance regressions can be seen, the fastpath
> > > benchmarks differences are in the noise.
> > > 
> > > Usama Anjum tested next-20260821 with one warm-up and three repeats
> > > in four sessions, for a total of 12 measured runs. The commands were:
> > > 
> > >   perf bench mem memset -k 1GB -f default -s 16GB
> > >   perf bench mem mmap -p 1GB -f demand -s 32GB -l 5
> > >   perf bench mem mmap -p 4KB -f demand -s 32GB -l 5
> > > 
> > > The results were:
> > > 
> > > aws-m7g.metal:
> > >   Benchmark    Base bytes/sec   Change with patch
> > >   memset 1GB   63932542232.12                1.92%
> > >   mmap 1GB     63272579168.03               -0.57%
> > >   mmap 4KB     49692830849.48               -1.11%
> > > 
> > > cesw-aarch64-ampereone-1s-a192-32x:
> > >   Benchmark    Base bytes/sec   Change with patch
> > >   memset 1GB   33895562998.71                0.25%
> > >   mmap 1GB     34338454210.17                1.16%
> > >   mmap 4KB     25687107580.90               -0.85%
[...]
> > Looking on that, I see that the memset() implementation uses setp, setm, 
> > sete, while the clear_page()'s uses setpn, setmn, setn for the case with 
> > MOPS. But then, reading into the docs, the instructions seem pretty much 
> > the same thing. 
[...]
> Oh, I browsed a bit here, and IIUC none of the tested machines have 
> FEAT_MOPS, is that right?
> 
> If that's the case, the tests are exactly to what is different between 
> patched and current versions. There should be no impact on MOPS version as 
> the instructions are basically the same.

Logically, yes, they are the same. From a performance perspective, there
may be a difference between the temporal and non-temporal variants,
depending on the usage.

I think it would be good to run the benchmarks with the current
implementation without DC ZVA. I don't think we have an easy way to do
this on the command line, so we can simply hard-code the DZP=1 check and
fall back to the STP or STNP in both cases.

Otherwise I'm fine with the patch as well, good clean-up.

-- 
Catalin
