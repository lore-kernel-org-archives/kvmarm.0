Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0027B32C85
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714586907; cv=none; b=mqEDlE34AJ2EAealWJblOMfj+saGappIc9Pa5nd5C2lrc6LQnp2OuqOHZECPoqWskHKwJSuoC7ldi2ZOiU05Banxv3Y8ylmNYvq2Fhofv8My+iJt7W03LynFK1Bc0SGwi46qEO4HX824MbiJw+H0hM9CuHQActX71HZl7Pi44es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714586907; c=relaxed/simple;
	bh=hJAggVbfKqsuZcSULPNN9vSs2IuEiBeAZz8x1YN/sAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNQiP5gDFy8Z+r20WFfJWTQjH46PBSVtq+t/lzS0ocwUPCHDTDGOxW5fsvZaWAPf9dP7ECr3iJxr1xj2QB+/FqevFaxZEq0zHaJ5vHJD42u1FZT7QOBZH6Gf/JlguFDS2+OYGIohu4QustAYGfRonw+cpVjtI0ugNS2ksi9y4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=t6nxeb3t; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="t6nxeb3t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZrwBw1tI4F6hKdGuJaKvvlFF5LmCndfyD3LBBkqMo5I=; b=t6nxeb3tcsOEO+0fYpzhBYv1Sq
	K+WIqgcoGEQjlhCF6E7LDDpmtXcEAx8GI49f+Ha+BsoVtadg8znuFpu5+RiVMw8BMjbEYhXCLBcY3
	TR1uOd5HEDf6Mf9hEopMzko0ndXUfvBU091Q6FTC0MX0AH74Rla2AKJgyBoaKqJpmmFJAoCzQwMDE
	ALryfcbs2DTzzmgcPZ8dBLjDAC+HAA8ztNrIJbfnccDnnhDGRUnzrPd/lz4b6N1WQprRcyVVGzkyk
	NzCK13H4imrG/S4t4Lo8+d3gYRBo8aqlCb4xWjFvhZtmC1eQgE9YGGwBXhb2GIfYn28XkqWgCs4Xt
	ahs9Cuvw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34974)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1s2ENF-0006Vz-1G;
	Wed, 01 May 2024 19:08:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1s2ENB-0002u5-Bg; Wed, 01 May 2024 19:08:05 +0100
Date: Wed, 1 May 2024 19:08:05 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjKCgIyWqNKC6TUu@linux.dev>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, May 01, 2024 at 05:57:20PM +0000, Oliver Upton wrote:
> Hi Russell,
> 
> On Wed, May 01, 2024 at 06:06:51PM +0100, Russell King (Oracle) wrote:
> > Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
> > changed their value on the same Neoverse N1 r3p1 hardware which makes
> > migrating between these kernels on the host problematical.
> 
> It'd be helpful to expand a bit more on how these fields changed, better
> yet if we can blame it back to a commit. I'm guessing the only direction
> of migration you care about is old -> new then?

Yes. For MMFR4_EL1, we see 0 with our 5.4 based kernel, and 0x21110
with our 5.15 kernel. I've been looking at tracking down which commit
is responsible but I've come up with nothing that fits.

The only change I can see is the FTR definition for MMFR4, but this
always included 4:7 (AC2) which changed 0 -> 1. So... no idea what
commit caused the change.

There are a load of other registers that we need sorting, but this
is just a test forray into attempting to solve this.

> 
> > We already permit changing HPDS in AA64MMFR1_EL1 and CnP in
> > AA64MMFR2_EL1. We also allow LSM as we allow that in AA64MMFR2_EL1,
> > so this patch includes support for that even though it isn't required.
> > 
> > Discussing with Marc Zygnier, AC2 should also be fine to be writable,
> 
> typo: Zyngier
> 
> > even though we don't inject an UNDEF if the guest accesses those
> > registers.
> > 
> > The only questionable one is XNX, execute-never control distinction,
> > which is also in AA64MMFR1_EL1 but we don't allow to be changed there.
> 
> It is quite odd for us to expose this field to non-nested VMs in the
> first place, though I suppose we will apply an additional set of
> restrictions for nested VMs when they come along.

Yes, it did strike me as odd, since the description seems to imply that
XNX affects EL2, which the VM wouldn't have access to. So I'm not sure
why we don't just force it to zero.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
