Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944A915E5AF
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 16:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668364; cv=none; b=AHloO3InOkUCImkVCyYj/v80kOBnA/IE1+zYaMD3nQZiccgYUtUHhCwaznBHpprlFpP0OHlrzIkElNJ0UdOapA1OAhMcoU0j9dw1seTvag8shLiy10mYhN8ufG5Z0ffs2c+Kyikk6eISAovm5RQxyCvvEXUMmah5I5Izn3CV+6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668364; c=relaxed/simple;
	bh=okzcYL2aE3ru5mG3gSZl21sfT20txDqMp2/q6Dz6uGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKcYsYUHb8r5do9eLlD3pwE0HpnkfwDbvPENTkSfDlA5twdC5oyJH/EUKuRIo8Tl5lrn1tA59jChoA2AHxtHYQf6UP7CUbev48hVzyR1xn8L2GhIRESfQYRkkGguxZXkzmkbDb6NhVXI7audb8sg/1BDUzNt0Yqtu7K8XWhAPXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mvBZtoMa; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mvBZtoMa"
Date: Thu, 2 May 2024 09:45:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714668360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PdV8LdHHGzyQZPGhLVN9kiXMb7hiNdhFo8cDZA2g52w=;
	b=mvBZtoMaK0qwqPeJOurDbR6tNZ4CqO/IZWdDCnh8WvLr6P8X37vHy0zfPhLa1MOSM0O7nM
	SVYiQHoLG/QU/7vsGKqYhcfcq844rTXTefHMbq4FNz4JwNK+qHGMHVepDzXyhJK6/wJCyK
	8uZZJ6UTTeCdFRsVG/3HTo3EsDwXC/s=
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
Message-ID: <ZjPDQSeQPE2wgVup@linux.dev>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev>
 <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 03:40:38PM +0100, Russell King (Oracle) wrote:
> On Wed, May 01, 2024 at 06:59:17PM +0000, Oliver Upton wrote:
> > On Wed, May 01, 2024 at 07:08:05PM +0100, Russell King (Oracle) wrote:
> > > Yes, it did strike me as odd, since the description seems to imply that
> > > XNX affects EL2, which the VM wouldn't have access to. So I'm not sure
> > > why we don't just force it to zero.
> > 
> > Probably because we failed to catch it in the first place and setting to
> > 0 now would be even more UAPI breakage. Meh :-/ I don't see any immediate
> > issues with the patch, especially since it is fixing a genuine UAPI
> > breakage in KVM.
> 
> I think the only two ways around this would be to:
> 
> 1) teach QEMU about the contents of these registers, with which fields
>    in these registers can be ignored when reloading a VMs context.
> 
> 2) allow userspace to write to the XNX field such that it can be set
>    to values seen with previous kernels (thus allowing at least one-
>    way migration.)
> 
> (1) has the advantage that reloading a VM state on older vs newer
> kernels can work in either direction, whereas (2) would only work
> for state saved on an older kernel loaded onto a newer kernel.

Yeah, so this is something that has affected my employer as well.

I think (1) should only be expected of VMMs that want rollback safety,
i.e. the ability to migrate state back to an older kernel. Our userspace
initializes vCPUs from a fixed set of feature ID register values that
prevents VMs on new kernels from picking up new CPU features.

It is quite tedious, but necessary as rollback safety is very much a
non-goal of the KVM UAPI.

OTOH, in cases where KVM screws up and breaks UAPI, the kernel needs to
do something special to accept the previously-advertised state even if
it were nonsensical.

For example, there was a bug where KVM advertised an IMP DEF PMU to VMs
even though the only thing KVM virtualizes is PMUv3. We fixed it in
commit f90f9360c3d7 ("KVM: arm64: Rewrite IMPDEF PMU version as NI") by
accepting the old value in the ioctl and changing the field to NI
internally.

I dislike these sort of hacks, but when we're caught between upholding
UAPI and the architecture it seems to be the best option. I wonder if an
approach similar to this would be sufficient to address the SPE change
that you noticed.

> I've been bitten before with KVM differences between kernel versions
> in the past - where the number of registers that userspace sees has
> changed despite being on the same hardware.

This is intended behavior, as VMs are initialized to the maximum feature
set KVM is able to support. Forward-compatibility for the set of exposed
registers is tested, see the get-reg-list selftest.

> I'm now wondering what
> testing goes on to validate this part of the UAPI across different
> kernel versions on the same hardware.

We may've been a bit more relaxed in the past with this, but in recent
history we've been careful about preserving UAPI. On top of that, we now
have some generalized infrastructure for dealing with these things by
way of the 'writable' / mutable ID register work.

Although it isn't precisely what you're looking for, the set_id_regs
selftest ensures we at least accept features that are valid for the
underlying HW platform and explicitly tests downgrades.

> I did knock up a test program that dumped the list of registers so
> that one could trivially diff the output between various kernels.
> Maybe I need to extend that to dump the register values themselves,
> and then maybe we need to find a way to get some kind of automated
> testing setup to highlight differences. (something maybe kernelci
> could add?)

Given the absolutely massive test matrix of implementations and kernel
versions I question our ability to support this. Additionally the only
thing we'd care about upstream is the unsafe removal of a feature.

Nevertheless, a starting point could be to drop some pr_info() into
set_id_regs.c to print the starting value of the ID registers which
could be diffed.

-- 
Thanks,
Oliver
