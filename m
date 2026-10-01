Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8655449B17
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869359; cv=none; b=QUguGsfzgpgsiaVrZCPumrQATRWSHvdLqd6CIR8bvo/8PSHk19283/A5fkXVEpVrL1zAuH8Zxl1Ixu+wve+BKu21ady+/NB062NeuGW5SsY/ysCMjjXNaxpTB8Na1pUIs/yGCXl/Dl3lCZ4rzKo1VypuBGeLhpk0TDISv/w18g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869359; c=relaxed/simple;
	bh=or0xINVQUdEf9F7jOCFnP/W+9+MUSfW80xcqFEkanis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1lHt/ADOm67QTi5IS+lgMQEbbMwX3IBmgOSpPidjKg+/ZefU8gK1Jk/z/A3gVPe/57uIoEb9paY8bMJVutnjm5T2odmfm9h6+eVFNzdqyxZHN42hiYsrgLKG4AESmCMUut9o8BZSak1KRsMzUfQE6uU7XBu8L3GFMCCTAP6k6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz7Yxqd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz7Yxqd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B081F000FF;
	Thu,  1 Oct 2026 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869357;
	bh=O45TC2Cml8iUX3fmN4UqSvYkdv5OL5k+Oy0K7Z9R2+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hz7Yxqd+ppJdmeP88EUEhNfi3Ahao1OF/S2P+4JipSaSwVx4Al/WLjaaOADx3PGTu
	 6RXzNbJ+n93oKFWYg5VCUqRczHA2Yq2qjYSymeljg4w3MuPh7Tu10G0r8g00kZ6xLX
	 1XQmvi5+azNJLj+9Go3KGkjrIq/GPX/M28tNLXqVGVqGCcZDNT+CUUF7Z9Ab4UELIO
	 KGgJlsobuL/Hyo3vMUWaDDjO7J8nEbPs7x+pW1G+QDLZUemGfe94Xn/DWlnihnDNg1
	 lnn8vz+CIt1Exa6YgJhURYJ8N3Jifcxeeb+PtfeGqvKIJrhh8VsRlEDLLGigtxxRCm
	 FULMPzOstjpSw==
Date: Thu, 1 Oct 2026 16:42:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>, andrew.jones@linux.dev
Subject: Re: [PATCH v3 1/8] lib/alloc_page: check for NULL ptr passed to
 free_pages()
Message-ID: <2d9acef5-7281-4e62-a6b2-0a025b9631c5@sirena.org.uk>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
 <20261001151645.2427065-2-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JD5EUxPJGTm5G5oq"
Content-Disposition: inline
In-Reply-To: <20261001151645.2427065-2-joey.gouly@arm.com>
X-Cookie: Do not stamp.


--JD5EUxPJGTm5G5oq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 01, 2026 at 04:16:38PM +0100, Joey Gouly wrote:
> Don't call virt_to_pfn() before checking for NULL.
> ---
>  lib/alloc_page.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

There's no signoff here.

--JD5EUxPJGTm5G5oq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq+f2gACgkQJNaLcl1U
h9ATjAf/ZAlFd7qgrZWbr3hItrkPGY7hnh1fBFZfpZ97iCvzcqEb6pw7TNA1Tx52
nhJATp99u5VL0n0Ile/bWtpCTsqgUyb+fxt3MFOQe5TQnZMCySg2uV1XZDSuInIM
IHK6Jn0IoUWpI4kJ9IrjdjTQgVACH4J7CttVgXBNIUKHv2UDKfOiy2xEIdG9baof
q8JLEPkbjrNHPQgmYql0fHlKG+51TO/01egImHyB/Kasp8zUPR5UAK7uYUUHgp7j
A59AbJ0loRCkPMtknNDiJNM7Hb+sS7T5GPcS1uGp5u6RSp5yEvYehiBnhrnf1qnm
KNgKlgXuiKeZmQigYy2LXaVzhuumzw==
=ZdhX
-----END PGP SIGNATURE-----

--JD5EUxPJGTm5G5oq--
