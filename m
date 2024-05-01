Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41A714A8B
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714593091; cv=none; b=hrxCFjnBTuTXAntqIEvhpyfWiaQaskLtAhzI4j9TPLg6I6q4sMauD2fuu64PTeKEMMhB63yD+ZwQABcTZ67un0SI5lYYOAA7+ymy7gcxPqrmsXZ3PW4hqfkyebd6FcbP1k0yf5dKBW7ZMa2n16a4a8dYHrr9VmEPy1wl/KwHLmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714593091; c=relaxed/simple;
	bh=Cev3u4UkNuuRljc4rn0EQ0sgAO9hWmZV4il1yBMnE+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyuQZjiXahClQbvLgigMMtCIRqpjTWU9uK4V43brvxiN35O9TNnhOM5tzfvQLmLDs8nTzq6vnIawyj2yPvfgbj/7Q1gFL+VVclUBzoPSwZ5D/QOx0cYENyHh93gPkQKVIeEqghqz0kLJjYJYRe7XbeIttmoQBl+8GO4McPDv02s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=ceA7Pnxk; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="ceA7Pnxk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0A31sCIBZJeiwuMP4GxlbOVkmUB2QfLVfijRKGWXcFU=; b=ceA7PnxkXiACKUL8mtep4lA+y5
	S2bEbuXDW4kNrbNUgRcyDoamwX22ZQrjZ+M6xmzTd5bEl21SJvFN6I8JkVCRIzDyQKecj5dFi2vuy
	woWHCO98NxgJfbuMkl6CkcpTQSngVCHQ2AEjLsbNSb3LKj3VahBPiZ1myDl+FE9/R9KGHUbgHRbCA
	9XlxqtFgh+EAXTiab0w8dZ6VRLXimhlpkPhFA8uJ4I63agFziQ8QgBzrR+rtN/eraI0P9OZXZMt36
	oEtaEn0aE8HCkplduneOK49QxfIv+tFgQO919I6+Z++xN9fWQAYLzSvAwSS8bqU3lfrBhynzpOnn6
	kjeDnwTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38288)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1s2Fz3-0006Zk-0G;
	Wed, 01 May 2024 20:51:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1s2Fz1-0002yu-OR; Wed, 01 May 2024 20:51:15 +0100
Date: Wed, 1 May 2024 20:51:15 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZjKdM935rsvd+S9/@shell.armlinux.org.uk>
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
> > On Wed, May 01, 2024 at 05:57:20PM +0000, Oliver Upton wrote:
> > > Hi Russell,
> > > 
> > > On Wed, May 01, 2024 at 06:06:51PM +0100, Russell King (Oracle) wrote:
> > > > Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
> > > > changed their value on the same Neoverse N1 r3p1 hardware which makes
> > > > migrating between these kernels on the host problematical.
> > > 
> > > It'd be helpful to expand a bit more on how these fields changed, better
> > > yet if we can blame it back to a commit. I'm guessing the only direction
> > > of migration you care about is old -> new then?
> > 
> > Yes. For MMFR4_EL1, we see 0 with our 5.4 based kernel, and 0x21110
> > with our 5.15 kernel. I've been looking at tracking down which commit
> > is responsible but I've come up with nothing that fits.
> > 
> > The only change I can see is the FTR definition for MMFR4, but this
> > always included 4:7 (AC2) which changed 0 -> 1. So... no idea what
> > commit caused the change.
> > 
> > There are a load of other registers that we need sorting, but this
> > is just a test forray into attempting to solve this.
> 
> Got it, let me see if I can find it then. Do share that list of
> problematic registers when you have it, hopefully this isn't the tip of
> the iceberg...

There unfortunately is an iceberg, but hopefully it isn't big enough to
sink a ship!

Besides ID_MMFR4_EL1, here are the other differences we've identified.
Note that these are Oracle's UEK kernels, so based on stable kernel
branches.

Register		Field		5.4.x	5.15.x
ID_PFR0_EL1		CSV2		0	1
ID_ISAR6_EL1		DP		0	1
ID_PFR2_EL1		SSBS		0	1
			CSV3		0	1
ID_AA64DFR0_EL1		PMSVer		1	0
			DebugVer	8	6
ID_AA64MMFR1_EL1	XNX		0	1
ID_AA64MMFR2_EL1	EVT		0	1
KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2
					0x12	0

I think some of these differences are due to Marc's removal of the
WA2 code in commit 29e8910a566a ("KVM: arm64: Simplify handling of
ARCH_WORKAROUND_2"). The WA2 register for example has changed from
avail/enabled to not_avail.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
