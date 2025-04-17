Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB35B2550AD;
	Thu, 17 Apr 2025 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744910567; cv=none; b=aQsxWYvYoKJL1+mJ3zItUbJAyRZ9Wj/av9UxQP7asv/M3OIMVTMv1ZiPTHkx4BTwrwjIFD3ZWjQ28BKDoFxa9knOFVDnpQNfY70tBBcXivZ8hS6//UdpCuLKZ/USaH+HkUX7YMo+N9Ytmd61skN4LRXSvgFcsRcB+qtiOvXqJrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744910567; c=relaxed/simple;
	bh=vnur/dTUJk0z+wfU8VALjgtrhmiqJntTUjprsU2e5dI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EILde/wDamanZiWj3uhR/UGNA70gMDdyRvipnSNNqX9N8s1nzPYpaKog5OABwFwUMWRMNheQVIo2uskCML/AqhT2piOReM+AYSbXt/4J5XCyBTkZs7JSJgSQNFOEQXYZvlz9aGuXHQvUNGN+5eGn6FCe35Vfjjfi6ypDKDwof84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=nNhyFVrH; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="nNhyFVrH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=rUgcReSeERaYjdCHY/S65QNcDRKyKTJVSUifM/SqTHw=; b=nNhyFVrHTOlSrXjfJ7WcbfgeDz
	yngeaH3pmyxCVI63fr1I6g9oKwTQbDRIG2W/USafgFWZx+MTv1JOFQGgsDQZP3SUGj4KZ2a0RVDwK
	YTzliV8jwsvbqwGaC7f0x8l7qjpImJw2o4nQTjzI/dzvQwJe6EvZ23voS+PYm4uqjBQk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1u5SwX-009oI0-Lw; Thu, 17 Apr 2025 19:22:29 +0200
Date: Thu, 17 Apr 2025 19:22:29 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Marc Zyngier <maz@kernel.org>
Cc: Luo Jie <quic_luoj@quicinc.com>, Yury Norov <yury.norov@gmail.com>,
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
Message-ID: <0c97c659-bd28-45e0-8537-d9be2637cb22@lunn.ch>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <86sem7jb5t.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sem7jb5t.wl-maz@kernel.org>

On Thu, Apr 17, 2025 at 12:10:54PM +0100, Marc Zyngier wrote:
> On Thu, 17 Apr 2025 11:47:07 +0100,
> Luo Jie <quic_luoj@quicinc.com> wrote:
> > 
> > Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
> > macros. It is functionally similar as xxx_replace_bits(), but adds
> > the compile time checking to catch incorrect parameter type errors.
> > 
> > This series also converts the four instances of opencoded FIELD_MODIFY()
> > that are found in the core kernel files, to instead use the new
> > FIELD_MODIFY() macro. This is achieved with Coccinelle, by adding
> > the script field_modify.cocci.
> > 
> > The changes are validated on IPQ9574 SoC which uses ARM64 architecture.
> 
> We already have the *_replace_bits() functions (see
> include/linux/bitfield.h).
> 
> Why do we need extra helpers?

If you look at bitfield.h, the *_replace_bits() seem to be
undocumented internal macro magic, not something you are expected to
use. What you are expected to use in that file is however well
documented. The macro magic also means that cross referencing tools
don't find them.

I think this is a useful additional to bitfield.h.

	Andrew
