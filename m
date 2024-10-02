Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237E71CF5FB;
	Wed,  2 Oct 2024 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884367; cv=none; b=sMa4qhGYpkvTem8MIUPBjBDNxfG2mZUMUChznvs263y0M9bvy3UQVjZx6UAB8/tUjICVFymUeZgEY8n8DKA2AKU9gcggMGTYEuFJx6t3Kbv2wVFQfmwYLqirck5Rc7rUaOM3uFRaRbBKlOAK1LNVla4/0k2oxUg6rc4UE9nsEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884367; c=relaxed/simple;
	bh=wW+32vAtoYvZ0AoUlvBodvZP1M7UKtdKGA11jroyVBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVb+m59CQgvHev0IyaC73Fu8nYqK/UAMGvbtYqbQ1Z4s8i9TxfqG0pwoFEqPTxg9wYokDTDhlIztcB6Z2YkKAB/LHzygxCLTUffk7dsBKmVdZqinamoKeJ1gad9aB1myKbKk6S4XL6iviINudC8sjzqX71Tw/44QTLDqUnO9Yq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJ66jO/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJ66jO/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD2EC4CEC2;
	Wed,  2 Oct 2024 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727884366;
	bh=wW+32vAtoYvZ0AoUlvBodvZP1M7UKtdKGA11jroyVBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uJ66jO/LkxZ7pxV59Jv9RrF9w+vuQV0F/8mX7AaT9MNGUx+zjbQZO66iowdjzO8vx
	 UtJU1rh1mJZNndE8/nRK8cizmS69EfkVPxKnAF9c+ZPESZj1hJx2UICXIrOFAjBzHf
	 COXDVwPcXyQwrHV1pDc4Ngn/7V6htJvUh4Opw3sJahGftgY/OOTb79ojZ6HQK+BX38
	 SO4ZgRz/nN3IeQyn73VRTjqVfbdtye/5jDkeHygwDZEJ0oiCgTvcR1DcSGrltinyI2
	 ueCk1ULhSJGdIwcp8o3kErg1sAB+swCIMleOJlUrjkP3SUoY4utgr3qcL6edU+WBSP
	 rwQOK2/VQ77aA==
Date: Wed, 2 Oct 2024 16:52:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 00/47] KVM: arm64: Enable FGU (Fine Grained Undefined)
 for FEAT_FGT2 registers
Message-ID: <88783a82-6bfe-4b9e-abd6-a39169c2e223@sirena.org.uk>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hpkt639cGf9JbXKr"
Content-Disposition: inline
In-Reply-To: <20241001024356.1096072-1-anshuman.khandual@arm.com>
X-Cookie: Know Thy User.


--hpkt639cGf9JbXKr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2024 at 08:13:09AM +0530, Anshuman Khandual wrote:
> This series enables fine grained undefined for FEAT_FGT2 managed registers
> via adding their respective FGT and CGT trap configuration. But first this
> adds many system register definitions in tools/sysreg, which are required
> there after.

One top level comment: these are updates for DDI0601 2024-06 but we've
now got 2024-09 available.

--hpkt639cGf9JbXKr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmb9bEgACgkQJNaLcl1U
h9B8kQf9Gc52nSQ6cJh5LkDe3WliRNM2nMJLabZYXkyNN6oD770DBOF8rEzUQfNm
3pKj5YY4FSXUj7QojfehqwMdKHk8fdNceyKVSTAmy1HEG9M6O6j0JyY7NZd5us7I
ST6FI45ky5GrD7BiY9CrZTK3VzqryMOijATj0UWnnb9bMyzfVdkrpaY58yUherky
zEHfswRfXLA8ulvH/LPO1KqYSTUxU9xvQLQEQOUcowsetlcDNZl7NOZrn0xXN2Fu
s1JRS7QyXQTlkfQAUkpqAq3sikdLJyY59puvShgGOfo9TYWPKWlzrZzdg76pf5YF
0zY5kqzYXqMT4yaQp196lgCrEgcUVQ==
=Fhgb
-----END PGP SIGNATURE-----

--hpkt639cGf9JbXKr--
