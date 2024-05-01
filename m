Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB5E42A96
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 18:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714589967; cv=none; b=kdXp7fRhv4Qj2Jy4UOLKn5HGBfq8MU1Ts8TZgHrLKUQIM7631k9yrX7v7S3WbKlPg9hq3G/I5F3w2OGUp+rlERrSstN9GHXcFapUScDHrsEyeqzJXXIdxJmp6Jgw/CZPGhkwNxaoGrmQCXIvdju4Erq/Cufv+xNbMSQNoBcEQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714589967; c=relaxed/simple;
	bh=2AckizYgFfJcXL9wCxuEfbHA7kqRgQQds0FkX8AvZLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPq6LHIY9qlf/tGBb+VB4dHnp4ymubwRnNFHHr7j7a98ntRpXy2eedH0RZIqXWq4RRg2YddVtT0Hd8whOtx5sd7UsgJzjOelNK2twGNPvy8apSOwH0SnaTujO7hztnjhs8w/qYuo83hLTgsxaW0iyCjzS7Khfx+iNzhSxYVOsBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OANV3CI5; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OANV3CI5"
Date: Wed, 1 May 2024 18:59:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714589963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrQ2AopEGZ3r2B+LP+ekVnW1mZ1EGD++PLfCAyg3y6E=;
	b=OANV3CI59WqzNyGVfYeuPrmtDuPWes9D9fUsAuYKQ4gjK/XbfUMYUjkTcmeRu4Zybdin2h
	K5O7IiK+8ucCgq0o+IuNyke6c1qDmP/mfAwQaIuCjNbh8BlqSeJEgLyNxJ07K+rHCp1nYr
	brsxV29kTD/dacGUSLKNj/CH+7hbKdc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZjKRBcAML5T6cm4q@linux.dev>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
X-Migadu-Flow: FLOW_OUT

On Wed, May 01, 2024 at 07:08:05PM +0100, Russell King (Oracle) wrote:
> On Wed, May 01, 2024 at 05:57:20PM +0000, Oliver Upton wrote:
> > Hi Russell,
> > 
> > On Wed, May 01, 2024 at 06:06:51PM +0100, Russell King (Oracle) wrote:
> > > Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
> > > changed their value on the same Neoverse N1 r3p1 hardware which makes
> > > migrating between these kernels on the host problematical.
> > 
> > It'd be helpful to expand a bit more on how these fields changed, better
> > yet if we can blame it back to a commit. I'm guessing the only direction
> > of migration you care about is old -> new then?
> 
> Yes. For MMFR4_EL1, we see 0 with our 5.4 based kernel, and 0x21110
> with our 5.15 kernel. I've been looking at tracking down which commit
> is responsible but I've come up with nothing that fits.
> 
> The only change I can see is the FTR definition for MMFR4, but this
> always included 4:7 (AC2) which changed 0 -> 1. So... no idea what
> commit caused the change.
> 
> There are a load of other registers that we need sorting, but this
> is just a test forray into attempting to solve this.

Got it, let me see if I can find it then. Do share that list of
problematic registers when you have it, hopefully this isn't the tip of
the iceberg...

> > 
> > > We already permit changing HPDS in AA64MMFR1_EL1 and CnP in
> > > AA64MMFR2_EL1. We also allow LSM as we allow that in AA64MMFR2_EL1,
> > > so this patch includes support for that even though it isn't required.
> > > 
> > > Discussing with Marc Zygnier, AC2 should also be fine to be writable,
> > 
> > typo: Zyngier
> > 
> > > even though we don't inject an UNDEF if the guest accesses those
> > > registers.
> > > 
> > > The only questionable one is XNX, execute-never control distinction,
> > > which is also in AA64MMFR1_EL1 but we don't allow to be changed there.
> > 
> > It is quite odd for us to expose this field to non-nested VMs in the
> > first place, though I suppose we will apply an additional set of
> > restrictions for nested VMs when they come along.
> 
> Yes, it did strike me as odd, since the description seems to imply that
> XNX affects EL2, which the VM wouldn't have access to. So I'm not sure
> why we don't just force it to zero.

Probably because we failed to catch it in the first place and setting to
0 now would be even more UAPI breakage. Meh :-/ I don't see any immediate
issues with the patch, especially since it is fixing a genuine UAPI
breakage in KVM.

-- 
Thanks,
Oliver
