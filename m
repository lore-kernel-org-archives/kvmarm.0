Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374BB224DD
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 10:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714647471; cv=none; b=riJnFmSVufsGPM4BkgZXUgsXPBRSIT/Ip5Af+/PXahF7xbI9szstr3oNYIx2clIa+RsxF6lt/v8b/HpVQ+adt6Yg+a3uyTXgyt1V0ZymISOBlHCv2BLrzROflV4zhVFWuzqFmTczAgVTy+qDRYFYuXhrgjlqC0tThyinROwGBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714647471; c=relaxed/simple;
	bh=h0gh7RLMymDQFA4PDkg64fG62ODuIc7jbuya+UKXons=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIXGZgi5dkek0hR2SJoKgOUskQuX406Wr4MuOkBoE0RxEP4F56U0qr+D1W6tLVs1nqjXCFDaIngp3eVqyI8kK90+krqiTLWozP2AdfR/RunXXgpXrROuHtalfaRI8Z0XgZiRC6ptsOLU/aBNxej/MDiV+Ptq3MeEkOle628mSsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=pYjBeGS+; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="pYjBeGS+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=z6rERo+AyDCjavqLTFckp1YpHTpXK30bl2flTzGgKh4=; b=pYjBeGS+MErfdrH8W54b0VWDuS
	euZFo5BSf9VgccTYxIYh5goUeiSoaU/Jypg/VkzlNSzehUwYoyv0vG7v5SnYVYDN3nnrAbvJXToZh
	8gjFMQls6RAGq0nL3fLDjOenVUIFse3BmA18xw11obJumJ0x+LSeymZvS/VfM6wJlYUTPuCeFn+h5
	1u0caWVzhl0ss/OsNb5Lmmgxrt2VpKwPL4hEwHXB8/luJxzHUOTumcqZNFeNoztmjQJQ+PJCMEnPD
	iOI3lB6PH8sToZfRJ1fbaxEi11/Gbsu+kU8/87HKEZdG97S5Ps9oLonSPfqdAmhOhnSusrwqRzfxP
	hevoYwpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36402)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1s2U0y-0007B3-0g;
	Thu, 02 May 2024 11:50:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1s2U0x-0003az-0v; Thu, 02 May 2024 11:50:11 +0100
Date: Thu, 2 May 2024 11:50:10 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZjNv4l8aGVY3ZupA@shell.armlinux.org.uk>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev>
 <ZjKdM935rsvd+S9/@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjKdM935rsvd+S9/@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, May 01, 2024 at 08:51:15PM +0100, Russell King (Oracle) wrote:
> On Wed, May 01, 2024 at 06:59:17PM +0000, Oliver Upton wrote:
> > On Wed, May 01, 2024 at 07:08:05PM +0100, Russell King (Oracle) wrote:
> > > On Wed, May 01, 2024 at 05:57:20PM +0000, Oliver Upton wrote:
> > > > Hi Russell,
> > > > 
> > > > On Wed, May 01, 2024 at 06:06:51PM +0100, Russell King (Oracle) wrote:
> > > > > Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
> > > > > changed their value on the same Neoverse N1 r3p1 hardware which makes
> > > > > migrating between these kernels on the host problematical.
> > > > 
> > > > It'd be helpful to expand a bit more on how these fields changed, better
> > > > yet if we can blame it back to a commit. I'm guessing the only direction
> > > > of migration you care about is old -> new then?
> > > 
> > > Yes. For MMFR4_EL1, we see 0 with our 5.4 based kernel, and 0x21110
> > > with our 5.15 kernel. I've been looking at tracking down which commit
> > > is responsible but I've come up with nothing that fits.
> > > 
> > > The only change I can see is the FTR definition for MMFR4, but this
> > > always included 4:7 (AC2) which changed 0 -> 1. So... no idea what
> > > commit caused the change.
> > > 
> > > There are a load of other registers that we need sorting, but this
> > > is just a test forray into attempting to solve this.
> > 
> > Got it, let me see if I can find it then. Do share that list of
> > problematic registers when you have it, hopefully this isn't the tip of
> > the iceberg...
> 
> There unfortunately is an iceberg, but hopefully it isn't big enough to
> sink a ship!
> 
> Besides ID_MMFR4_EL1, here are the other differences we've identified.
> Note that these are Oracle's UEK kernels, so based on stable kernel
> branches.
> 
> Register		Field		5.4.x	5.15.x
> ID_PFR0_EL1		CSV2		0	1
> ID_ISAR6_EL1		DP		0	1
> ID_PFR2_EL1		SSBS		0	1
> 			CSV3		0	1
> ID_AA64DFR0_EL1		PMSVer		1	0
> 			DebugVer	8	6
> ID_AA64MMFR1_EL1	XNX		0	1
> ID_AA64MMFR2_EL1	EVT		0	1
> KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2
> 					0x12	0

I'm finding sys_regs.c very unintuitive for working out what we allow
to be written, because it's all coded in negative-logic. By that I mean
the mask values are all ~(what-we-don't-allow) rather than a positive
this-is-what-we-allow. So I've ended up creating a table, looking up
the registers and working out what's read-only and what's read-write.

From that, I can see (for example) that from the ISAR6_EL1 register,
the field names appear in the AA64ISAR0_EL1 and AA64ISAR1_EL1
registers, and all non-res0 fields are writable. It is therefore my
intention to submit a patch doing this:

-       AA32_ID_SANITISED(ID_ISAR6_EL1),
+       AA32_ID_WRITABLE(ID_ISAR6_EL1, ID_ISAR6_EL1_I8MM |
+                                      ID_ISAR6_EL1_BF16 |
+                                      ID_ISAR6_EL1_SPECRES |
+                                      ID_ISAR6_EL1_SB |
+                                      ID_ISAR6_EL1_FHM |
+                                      ID_ISAR6_EL1_DP |
+                                      ID_ISAR6_EL1_JSCVT),

which, like the MMFR4 patch, uses positive logic for what we allow
to be changed, even though this is equivalent to ~ID_ISAR6_EL1_RES0
which tells us nothing without either looking up in the spec, or
looking at the generated sysreg-defs.h to figure it out.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
