Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606E128BA93
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745430290; cv=none; b=ay2OEI3VAWeQgi2qZvo80TXRPDSJVhk8LjpxCltg527oo1jBln+F+sW49PvELm4DB1q31zPlB9j7cAl4TIdD46oeAOlNSmXY7pFIw96YBBvpO6ZLtvyem4tHt0Swy0UmY7wpQhmFVdMGIpSePPCOIntYrHjv7982XJlYol/LLFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745430290; c=relaxed/simple;
	bh=BCHCHTOXyJMmtJ+KLeDMf9yKqjTgX/D00D6l5oiWD8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVzRM1pSwqeuGvThvMSLKx2XVzGot6nQM3KjF2sNqoQ6STuOaWtGN0aynunBGhk57pQVcPJ94ziZl0wW5FYYdhdUq2qA1eW/eRZv4hESS2xydAw3OZowrv8mMtaMUkKYNGg02c4FTaiHX9FLvqQuB7pfloISU7Z0VQ0dYvllveQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=sqBaQ1ux; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="sqBaQ1ux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nNi428VMmxCpWKvb50p/bX9DgxfivgEs4/Ad9gqYDsM=; b=sqBaQ1uxVV1Pn/zOz3VaBK6aKx
	/I4dFGbXcARGryXfnbvPWLGUtk1kZlUt0TMwuBBUgGzsc3TawnlO4KVddk2aiB7QCiDSrPFPX0UhH
	fAnQPyqWRWhA73bcXJ2cxstme/cqQdzOdeNSmykzWRsh7LguLYXdC5mKFviArEbe7kE7StwD/luU3
	KaDv+C24wS1f2nrM7EGI4Qu+rjOFF0owG01q4uyOVWtiu6Lq6cJ+r2oe6qSLvesrvkieXTZFlEpCY
	oJqVHW/y/NnxmVaJAjV/Hdz8qBaF/6CgmBwCcTXNn4Q2H5Uve2R+1UJLcaWz6BwQT9kp9UqPXceRD
	DY3fZ9pw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54318)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1u7e93-0006K9-0Z;
	Wed, 23 Apr 2025 18:44:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1u7e8t-0000Dc-15;
	Wed, 23 Apr 2025 18:44:15 +0100
Date: Wed, 23 Apr 2025 18:44:15 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Yury Norov <yury.norov@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 0/6] Add FIELD_MODIFY() helper
Message-ID: <aAkm79R8f5Vf6TLh@shell.armlinux.org.uk>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <86sem7jb5t.wl-maz@kernel.org>
 <0c97c659-bd28-45e0-8537-d9be2637cb22@lunn.ch>
 <86mscek7h3.wl-maz@kernel.org>
 <aAJq9mGswYsnAOS8@yury>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAJq9mGswYsnAOS8@yury>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Fri, Apr 18, 2025 at 11:08:38AM -0400, Yury Norov wrote:
> The _replace_bits() functions return fixed-width values, and intended
> for: "manipulating bitfields both in host- and fixed-endian", as the
> very first line in the commit message says.
> 
> Those using _replace_bits() for something else abuse the API, and
> should switch to FIELD_MODIFY().

Sorry, but please explain this statement, because it means nothing to
me.

FIELD_MODIFY() replaces bits in host endian. _replace_bits() also
replaces bits, but has a wider range of which encompass FIELD_MODIFY().

I see nothing that precludes using using _replace_bits() with
bitfields.

I see nothing that would differentiate the behaviour, other than maybe
religous ideals about C functions vs macros or upper vs lower case.

Please explain why you think there's a difference between the two
because I really can't see any reason not to use one over the other
apart from asthetics.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
