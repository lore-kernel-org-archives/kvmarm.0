Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE0B1C9ECF;
	Fri,  6 Sep 2024 16:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639057; cv=none; b=K6Hl50GAiyLJMK2Xlg4lzTVf6CpACtKATbB0SOoOrQ0yE2W0WZtWtIPISKBrDg1TCMaoVOjrOQ+5gKmrvwuPJP/tOsAD9RV8K2srEtc7QP5vJSPVszFcrW4Bypis8vPkkgSF8fBk1jdOz7FPpftmEGekPx+0uyTJzKiRgbeA72s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639057; c=relaxed/simple;
	bh=2szDTPeQE7le5G9ilmnouurXIYzTK7CXHCnNfdIVsQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBrgJd0DbC7R9v/fx2qV2pW3wPZ0WgLp8hH+5w4vKJ0j46Tn/w0zXkr/annm+/q1daI87s3up0HsSxaEKh1TXoxkS+2UF3mQXdiwnm9AnqQoBkxjNGX5a0zgAqb95+NCs6vsEdpGa8F3DOEorkaGJlGSfNHnVgLul5ftp95ggGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZyqXJOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZyqXJOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8C0C4CEC6;
	Fri,  6 Sep 2024 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725639057;
	bh=2szDTPeQE7le5G9ilmnouurXIYzTK7CXHCnNfdIVsQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZyqXJOifV5k0oTBTDB2yoDl/Jp+NeMmUDL0CHJ3AhNww7M1HITI+Y5XHk9frVKsB
	 2R1j8StE0O0jZC7a8RxunqpbR9Kh3lErU0pebX7X2CaK68ffgDUyNrMLqLqi3vTlq9
	 HeDdfR2tCK+vi9xbWNvrf/f3ghNQoS0Q/BnXTKslqtixZ72PNp+fBUwHzm8nlpmcM1
	 YPjHIZPzqnvN7LOCiie6PVxo3H8mAFHVvkTJc0sA8K3iuFpBiOPz83ZtSica3DdB6v
	 Sy+u6TX/c7r19XVNp3N65IAj0sPWpXltT1bewwSmpkUEWFauBlEoAXV564VgVRB/5o
	 e31C0TWJm7h5g==
Date: Fri, 6 Sep 2024 17:10:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <Ztspjf0SHx7nz2lV@finisterre.sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
 <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com>
 <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
 <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MMSauOvZEte8nL2T"
Content-Disposition: inline
In-Reply-To: <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com>
X-Cookie: Your love life will be... interesting.


--MMSauOvZEte8nL2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 06, 2024 at 04:35:29PM +0100, Fuad Tabba wrote:

> > > Can't pKVM just hide the non symmetrically supported VLs using ZCR_EL2,
> > > just as regular KVM does for the guest?

> > > (I may be making bad assumptions about pKVM's relationship with the host
> > > kernel.)

> > That's one for the pKVM people.

> Yes, but that's not really the issue here, unless I'm missing
> something else. The issue is that pKVM needs to store the host's SVE
> state too, to be able to restore it. So hiding non-symmetrically
> supported VLs for the guests shouldn't be relevant.

If the host kernel is also running at EL1 and it's only the hypervisor
running at EL2 then the hypervisor can control the VLs that the host
kernel is able to access?

--MMSauOvZEte8nL2T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbbKYkACgkQJNaLcl1U
h9CzRwf/fIMZef/R/ou7dSTKrAQHeot3FJE1EEtxuOEoG3pr6rooJk8+BinYXc4Q
/xxNcHXFXwL3NGpGG05Wpu9cil3JsT7KwPZQ4n1faYfqGxAPG8oKc7EdIPW9nvEI
Bs4tptCPnl0TrPpJu/PRsOLU+KgF59mbpuZd6bVC5V74UajgioUS9WBeUmCdXLSL
OGlJ1xMOlMLmrKwKtjo0neJxct7z3nNCwbosbKmkmZ1HDOwyTR5/Xjy6v5tv9NOZ
1lJN48XSTsi02ndqcuc4RHRnz+r5ea0HLJCATG6T3Yj1fB07V1UI11t1q9v1DbYu
kQybQGfzLZyrOF5inQDb6s1aB99tMA==
=78AY
-----END PGP SIGNATURE-----

--MMSauOvZEte8nL2T--
