Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D06E61B
	for <kvmarm@lists.linux.dev>; Tue,  7 May 2024 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074064; cv=none; b=bfXgESWoeX6GsvAqcBOEf1Sh0K5sXoojPwmPvr1eYPOvQ9cD632X7tpwS50r6r9qQtqS6wbc40iY86axrXyZiLD14JDWhelqdsQfUWukYihTe8XHN26OQ8U7ACiXT02Z+LCQuN0sQoSGAoMu3iJJyIVoZ7KNJaTtnxMh+2No8iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074064; c=relaxed/simple;
	bh=06jQhEDKhwWQhxOK/R3Nk22Ce6h2uieLSgt0NrR3iC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qun2m1E0zVDg/vK/23J0uj3uEvQKcw9O00ID7GIkSGAc5oB4LvwcGvUQXhhBOONj+PD+i3eMkflqZL957apyHxnPCiP3ui98TT5Ues8WMJvvRLpNMt3/vsQLv9DLuck1KUtKGlXhEYjYcNoXMpvRGjy84fCvfcc+oQvdNEUrfB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=mIjWxvbz; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="mIjWxvbz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=M8GFNlHrtIdj8+wwRwPDwnxxLbzmyZzmH69Z+YzRhAI=; b=mIjWxvbz6UEUBETdW7FI/+o1pV
	N5KWIR/uR5NXkqEhuO+7JAKc5fUTC2TK28E5LKM0pkK1y9OKh+W9K1K2r3Mb9WJY2IiS69p2BZVrw
	7Z8X2c2t4W4QLowtPtbC7qpb2PQEYYLJ+3foG2zJx1htUgHAPLUgMwU7jg14QGeMmP3n9KLPCFCjv
	t1Pk3H1eap5KmkC/0NbAqIKuE74vyGbacMqpx3qiTg4L8UGYxdDfX5DtokcEuF8vcNO/vTjUW2Qot
	Me3A2f9Fpt9JGmzjnm7sS/J/faXDBbRa9mj7azMX+w3SZ2W63kUWyM5FYBKsUz6c/w5lgVeVNpLLm
	D1QdupNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58324)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1s4H6c-0003UQ-1b;
	Tue, 07 May 2024 10:27:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1s4H6Z-0000DR-Sf; Tue, 07 May 2024 10:27:23 +0100
Date: Tue, 7 May 2024 10:27:23 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <Zjnz+2Yr/7BLhoG4@shell.armlinux.org.uk>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev>
 <ZjKdM935rsvd+S9/@shell.armlinux.org.uk>
 <ZjNv4l8aGVY3ZupA@shell.armlinux.org.uk>
 <865xvwqlup.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xvwqlup.wl-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Thu, May 02, 2024 at 04:23:10PM +0100, Marc Zyngier wrote:
> On Thu, 02 May 2024 11:50:10 +0100,
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > 
> > On Wed, May 01, 2024 at 08:51:15PM +0100, Russell King (Oracle) wrote:
> > > On Wed, May 01, 2024 at 06:59:17PM +0000, Oliver Upton wrote:
> > > > On Wed, May 01, 2024 at 07:08:05PM +0100, Russell King (Oracle) wrote:
> > > > > On Wed, May 01, 2024 at 05:57:20PM +0000, Oliver Upton wrote:
> > > > > > Hi Russell,
> > > > > > 
> > > > > > On Wed, May 01, 2024 at 06:06:51PM +0100, Russell King (Oracle) wrote:
> > > > > > > Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
> > > > > > > changed their value on the same Neoverse N1 r3p1 hardware which makes
> > > > > > > migrating between these kernels on the host problematical.
> > > > > > 
> > > > > > It'd be helpful to expand a bit more on how these fields changed, better
> > > > > > yet if we can blame it back to a commit. I'm guessing the only direction
> > > > > > of migration you care about is old -> new then?
> > > > > 
> > > > > Yes. For MMFR4_EL1, we see 0 with our 5.4 based kernel, and 0x21110
> > > > > with our 5.15 kernel. I've been looking at tracking down which commit
> > > > > is responsible but I've come up with nothing that fits.
> > > > > 
> > > > > The only change I can see is the FTR definition for MMFR4, but this
> > > > > always included 4:7 (AC2) which changed 0 -> 1. So... no idea what
> > > > > commit caused the change.
> > > > > 
> > > > > There are a load of other registers that we need sorting, but this
> > > > > is just a test forray into attempting to solve this.
> > > > 
> > > > Got it, let me see if I can find it then. Do share that list of
> > > > problematic registers when you have it, hopefully this isn't the tip of
> > > > the iceberg...
> > > 
> > > There unfortunately is an iceberg, but hopefully it isn't big enough to
> > > sink a ship!
> > > 
> > > Besides ID_MMFR4_EL1, here are the other differences we've identified.
> > > Note that these are Oracle's UEK kernels, so based on stable kernel
> > > branches.
> > > 
> > > Register		Field		5.4.x	5.15.x
> > > ID_PFR0_EL1		CSV2		0	1
> > > ID_ISAR6_EL1		DP		0	1
> > > ID_PFR2_EL1		SSBS		0	1
> > > 			CSV3		0	1
> > > ID_AA64DFR0_EL1		PMSVer		1	0
> > > 			DebugVer	8	6
> > > ID_AA64MMFR1_EL1	XNX		0	1
> > > ID_AA64MMFR2_EL1	EVT		0	1
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2
> > > 					0x12	0
> > 
> > I'm finding sys_regs.c very unintuitive for working out what we allow
> > to be written, because it's all coded in negative-logic. By that I mean
> > the mask values are all ~(what-we-don't-allow) rather than a positive
> > this-is-what-we-allow. So I've ended up creating a table, looking up
> > the registers and working out what's read-only and what's read-write.
> 
> [...]
> 
> Using positive or negative logic doesn't really have any impact on the
> result. It often is a matter of concisely expressing what is allowed
> or not.
> 
> There is also the fact that a lot of the KVM code now checks for
> "feature downgrade" and enforces it. Construct such as:
> 
> 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> 		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
> 						HFGITR_EL2_TLBIRVALE1OS	|
> 						HFGITR_EL2_TLBIRVAAE1OS	|
> 						HFGITR_EL2_TLBIRVAE1OS	|
> 						HFGITR_EL2_TLBIVAALE1OS	|
> 						HFGITR_EL2_TLBIVALE1OS	|
> 						HFGITR_EL2_TLBIVAAE1OS	|
> 						HFGITR_EL2_TLBIASIDE1OS	|
> 						HFGITR_EL2_TLBIVAE1OS	|
> 						HFGITR_EL2_TLBIVMALLE1OS);
> 
> use negative logic by expressing what we don't want to enable.
> 
> In the end, consistency matters.

Is that a request to change my patch?

I'm unclear whether anyone wants changes to it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
