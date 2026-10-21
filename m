Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590176;
	b=HkqL3XlZAjrk4MbLodEdSq9pe2hsEYWOAC6t7utpp80c8Pypr5hbPJnXrUSJlkCR0ODT
	 wf78G7cG5hF2ox/BI+Zo7WtU1BquZkIwhASejjJPBlikB9sTkoj3J4Y3SP+aOK5bfIBnO
	 8/gtIBROyOkfk/eGrYXBNPA0uWuvws153jdW86QE4Igo9ruGaF1fjv/1kNpeoQZnpOLaE
	 8Qf0lWIt6NpCfcPDU/cr0V9c7xrUiK6eTYbuE0c+fRWuJUyyb15XGLQ3OTB1co3qo7taU
	 FXAPOdQJ0ca9KOoh5qjN3iJApkszPA3kPhDa0bPstwv9XlcgPllhd0rtNJfThbuzCYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590176;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=xJ2Ovji3bjdRLPPGY30syDXCVJ0aHLykeRBouybwHX4=;
	b=M1Vuv0TSPzq7Cs5mgU0/sm5N8S1RPOK7SVZ81NqVsRS30bfzxHIgUSa8yeYSxGhdmncl
	 oteN4/Cy30J6p/9BnCUmxIYjS7SGzL+/Qe9t6YzYrS22WRBUg565tpPKaeTlxM7uDzBSr
	 mW7avgmr2ZwY3WAI3FvamTIQqXyPWmmQm72rxny2UhzGkzZ/nVTgICAjzUbyzOl+ciMtR
	 lops7NpW1BNeid++nDwInNJJArkX+deaBHL1dIqBQnt+saeBtQC/OlXRwD4lYCfIRRpJM
	 R2hHEH6h6sHzHvM975QD3/lv8hTmM+ZaDXP8SNtM0xVxrB2Sgxwkvs0CawOZGPfLAeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ERf+CpF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F227606A321;
	Wed, 21 Oct 2026 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ERf+CpF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17281F000CB;
	Wed, 21 Oct 2026 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792590176;
	bh=xJ2Ovji3bjdRLPPGY30syDXCVJ0aHLykeRBouybwHX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ERf+CpF8vlUO4sHeciogTzn1mupLzKhUYSHIvzu7mR+nIloGfSGZMxX9r/5uIZQ9l
	 2QVoH9Skg8YTGoBmDYW4Q2RVKJ9LJwFoXah0j+BTAAlnpSfaYYB/MAXPaIoFcA+gvL
	 nXtpQrtWbe+iFq8sW43CssvmH6cMVGgfIRTD8RroLBm0/g4sly8g476zytxWsmh9+i
	 UJzm31CTFnt8UmP545yxUBdOEJ/zTn8dkX0/JMInJd6T1/HHrCKzoYT16H3GEvlcHB
	 geSGNIJqCKYZqmqF0m1I+3bzLRt3rPe4ttrNdDw4nzumwRmjOS25zcb0Nrn5Nacrvr
	 rSW4KGhBTvuCA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 4D5A31AC5995; Wed, 21 Oct 2026 14:02:54 +0100 (BST)
Date: Wed, 21 Oct 2026 14:02:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Message-ID: <ati3_lymW0zaBsSU@sirena.co.uk>
References: <20261020064306.1542865-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sjt8+o4zUIdHkuuK"
Content-Disposition: inline
In-Reply-To: <20261020064306.1542865-1-fuad.tabba@linux.dev>
X-Cookie: You buttered your bread, now lie in it.


--sjt8+o4zUIdHkuuK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 20, 2026 at 07:43:06AM +0100, Fuad Tabba wrote:

> On first run, clear S1PIE and S1POE from the VM's ID registers when the
> features they imply are missing, before anything derives state from
> them. The guest and userspace then see neither feature, and the guest's
> accesses to their registers UNDEF.

Updating the ID registers should ensure we don't have any confusion in
the later KVM code due to the standard use of ID register based checks.
I didn't spot any further registers where we have nested checks that
would need similar updates.

> +static bool idreg_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)
> +{
> +	struct resx resx = {};
> +	u64 val;
> +
> +	for (int i = 0; i < r->bit_feat_map_sz; i++) {
> +		if ((r->bit_feat_map[i].flags & CALL_FUNC) &&
> +		    !r->bit_feat_map[i].match(kvm))
> +			resx.res0 |= reg_feat_map_bits(&r->bit_feat_map[i]);
> +	}

It would be nice to have it be more obvious to the VMM and/or it's users
that it messed up, as things stand features it thought it had set will
just silently vanish from the guest - they'd need to know that this is
something that might happen and check after finalization or similar.
That's probably more a documentation/education thing than anything for
the patch.

We might want to support limits other than 0 at some point, but we can
deal with that if it becomes an actual issue and it's likely we would
just decide that the VMM shouldn't be configuring invalid things in the
first place so we don't care about being helpful.

Lorenzo raised all the more detailed code things I had, but either way:

Reviewed-by: Mark Brown <broonie@kernel.org>

--sjt8+o4zUIdHkuuK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCati3/gAKCRAv73Ows9A4
ifL7AP9jC8Mppexxj5Jl+d6ocXhZ+hqVKb1yWxSLeKWRDJRgpAD/QLofN6NXuN+M
miPfgi6EV2eYKd2tJqsht9+/C/EuKw8=
=PXJD
-----END PGP SIGNATURE-----

--sjt8+o4zUIdHkuuK--
