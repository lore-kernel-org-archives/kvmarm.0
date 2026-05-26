Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F31D13D539;
	Tue, 26 May 2026 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779800644; cv=none; b=XGBFBnkoCCOlZHm+OUip3rUHLrAeJuyJhnOAV91INKUyJ2MYT5FPPjrrf7w8BZ01bVjnd6LY7dvtdNdi0sX7TyVuKt88pF0aOHcTacpCtPrvxhgbAud+nidylNzKXUuGGKprAebqMSD1z0fcAMbKJsNZBQ6glD7B1T4+L5mFYBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779800644; c=relaxed/simple;
	bh=+EctUVsR3cSCuF6khBNyFe6TOiOfccX59w6GA13uMgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvkAhwGYVHA7Ofk0vX99eG4fbDfIHksEM/AuUkGXFRR1X6V3uJ0Z692DtYZp1Agd33PNn+70Ge6rESLzRU1pR2xMEo5laQSlE0Q8U6kAXpaYJW9swvLxLEups7fAxgSci/xENHOsliqskQ1Wn53Yn5shRFrJxCeDwKLaeQHEPQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPF55JO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPF55JO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D81F00A3A;
	Tue, 26 May 2026 13:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779800642;
	bh=HEvxlqsyTmNECKRwe/uPR8xoMybyjnrRSPs3JRmvUAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nPF55JO6w5h5C/TaRDm2keGPMbJvxrLdMeKQPE93PvJYutBDzg48JgTG3CZs99G1e
	 +onWqeo0r8VxwJHwWEuu+VGE5r9bs2XbIr5i84So1UMiQarW+H3fPeuHmmuu3mTDDv
	 h1WvzZi/PP+uGaHi4nAf9ce/EFYzUVzi1GehqQZRI0ut0SxamFXW5Ez3tZ5gseOtKs
	 2WVuGFTBkPtIKNKbkFIDoBSkkJm8NIyEX+/e1/o2ftGfjVyosHtYRJ2sWCYVtvfSqq
	 dBfKHyaFyj7DJVYNttgx3He7RhlHE1Ojr2ez3KVOy8vZtcO9ZQ/GA6J1oaoctvHe2T
	 K1cTQW9UjI+HQ==
Date: Tue, 26 May 2026 14:03:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Message-ID: <f19c8c47-049c-411a-8857-23f9d4b9644f@sirena.org.uk>
References: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>
 <ahSWwl-uCv4ZW-nE@J2N7QTR9R3>
 <b4fdceb6-5fa7-4829-a60e-6f80f47f032a@sirena.org.uk>
 <ahWMByoIme6_oECX@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UWNnr8DIiQaPll64"
Content-Disposition: inline
In-Reply-To: <ahWMByoIme6_oECX@J2N7QTR9R3>
X-Cookie: You are fairminded, just and loving.


--UWNnr8DIiQaPll64
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2026 at 01:03:19PM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 11:19:38AM +0100, Mark Brown wrote:

> The part I asked for clarification on was:

>   AFAICT, none of the values for the SMCR_ELx.LEN and ZCR_ELx.LEN fields
>   are reserved or unallocated. Thus all the bits of those fields should
>   be stateful, and a read should observe the last value written,
>   regardless of the effective value of the field.

>   [...]

>   Either what we're doing is wrong, or the architcture requires a
>   clarification to say that values corresponding to unimplmented vector
>   lengths are reserved.

...

> While one simple reading is that all values must be preserved exactly, I
> don't think this watertight, and I think while some people will take
> reading (a), others will take (b) or (c). I should have spelled that out
> more clearly in my initial mail, sorry.

I see.  Given the general tendency to brevity it didn't occur to me that
options b or c might be a thing.

FWIW the restriction to powers of 2 was a revision in the architecture,
originally all values were allowed, though it's there now so the history
doesn't make a huge difference.

--UWNnr8DIiQaPll64
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVmj0ACgkQJNaLcl1U
h9DbOAf/Z34B15RCo4mOt5gqqkgQ1qJbo9UyQ1alSgvytcUDqofmlWtrLBnMpVQB
+mZim/avIladmn5lMvay6phlVVvae4D/urnilCXE2UqXGpxoLsv/Q9FGsnroSSP4
C66VxFfO7fmHovLvznxiUoxmQAYl+AHI07GP1n597Na4px3PBMZDdcwL/c/W2akV
MUnTdL3Zf/wrInO0SUe7LuOsM1JPDV2rFZ8kfiFm6d4Kyi52BxgofELk5yltbli4
MFby8fngVmIRQJj9ByRrQI4Ma9SKohLYmpbv5Joxv/3ppCfRKHXrYlY9B2Wfp/+2
VvhK1oomwNO6jgCvzodrsiCHMIkZtQ==
=eYvr
-----END PGP SIGNATURE-----

--UWNnr8DIiQaPll64--
