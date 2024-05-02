Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE9152E12
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714660860; cv=none; b=H6V9rf+jN/7R8YrLTeblqgMhqiinj/iRhwKZPiBbsF7M0h4Qd6qVPF0fET24ILoMr6sm8aL2Tbra0n3qb6/v4K2yI2EE7/Z3dI+N0+erjaLYYzIT5WEEwPP+DEZW99vuxIZ5Sxh9nu+f7QphtBL05iSsxZBysZy3WKn6NdEhrtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714660860; c=relaxed/simple;
	bh=W7cYrxz5C/2O+2De37Gc0G200thQE/MIJBh0CXKi4ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTtD7MFPwJ+3F8rdEd7FMv7NcOPoTN00O2csuj7vBv991DRbAPW4N0AWsevvoeka4ib8UBUQNwa1Thy8pu/jRPdXtwqGPZHKC2Fe+wSUZPx6w6yfFKan9TxtRwVZEB5Gjvbfk2+Zm7XJxcnnani3tEvE8mVhdvTKYYjgvRffV4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=R/PA3Wk5; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="R/PA3Wk5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PNPomXF+88NXnOR05FF/hWkfp3ALBA3dcNLoX3C+ZiI=; b=R/PA3Wk5tRgnvnb8thgVz8xSI7
	L3uurutXSsAt74hyChUoXy9eKjPOf2pzSAILff4hRBQw1enUY3id4OScWEj3aYGcyEvGHMPOXOLqh
	rZJrvHFVjHtRPcRo3sSo0DxBJjqTuauj0TM7VshnRSnFKju+iKiBoly7MV4nnJJAEx4GZrT12n60J
	h9aOC5SNEcciXJwVkE38uCOqImYUXNIhGV4U+5jAKDXds6yXbXRUPwQ78HR9T89CAN2GJBLL2/HUu
	N+peIhRNnet8Y6DOXySaT8V5cfgPaa6H7vdsNzO+D6mdPdL3clEg/oU03JbczVcbqanxcDyduOJqJ
	frVcZTHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48122)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1s2Xc0-0007O8-1D;
	Thu, 02 May 2024 15:40:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1s2Xby-0003j5-BY; Thu, 02 May 2024 15:40:38 +0100
Date: Thu, 2 May 2024 15:40:38 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjKRBcAML5T6cm4q@linux.dev>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, May 01, 2024 at 06:59:17PM +0000, Oliver Upton wrote:
> On Wed, May 01, 2024 at 07:08:05PM +0100, Russell King (Oracle) wrote:
> > Yes, it did strike me as odd, since the description seems to imply that
> > XNX affects EL2, which the VM wouldn't have access to. So I'm not sure
> > why we don't just force it to zero.
> 
> Probably because we failed to catch it in the first place and setting to
> 0 now would be even more UAPI breakage. Meh :-/ I don't see any immediate
> issues with the patch, especially since it is fixing a genuine UAPI
> breakage in KVM.

I think the only two ways around this would be to:

1) teach QEMU about the contents of these registers, with which fields
   in these registers can be ignored when reloading a VMs context.

2) allow userspace to write to the XNX field such that it can be set
   to values seen with previous kernels (thus allowing at least one-
   way migration.)

(1) has the advantage that reloading a VM state on older vs newer
kernels can work in either direction, whereas (2) would only work
for state saved on an older kernel loaded onto a newer kernel.

I've been bitten before with KVM differences between kernel versions
in the past - where the number of registers that userspace sees has
changed despite being on the same hardware. I'm now wondering what
testing goes on to validate this part of the UAPI across different
kernel versions on the same hardware.

Surely, given the impact of these changing value (a failure of VMs),
we should be aware whenever any of these registers are different from
one kernel to another on the same hardware?

It's fine if all one cares about is starting fresh VMs on each host
kernel reboot, but any use case beyond that seems to be fragile.

I did knock up a test program that dumped the list of registers so
that one could trivially diff the output between various kernels.
Maybe I need to extend that to dump the register values themselves,
and then maybe we need to find a way to get some kind of automated
testing setup to highlight differences. (something maybe kernelci
could add?)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
