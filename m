Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183F1391E55;
	Tue, 24 Mar 2026 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774373977; cv=none; b=GocLAR4s4m1YMMj/FLQpgtq1G9Gysora5lGpq3WIU0e8NFOjKfIP3R+Dr0t/IQdBN65bRnrp+AwdHz6a8bI9SUyt/wrhRXUyyiRM6iYqKuU+gpKDAhLFdF2U90Y/8y2ivP7ScmKGGIKlOXpGeJB8nfxDJNTUK/mrThPfKgoBHnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774373977; c=relaxed/simple;
	bh=ZaI9P4HdmB3KMrbR4xZJNOkfWyry+qYtmIIIXLbqdhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVAN+c8iFjNvTX5PplC0NVGGTklWVBQqtLce2wMwD5wPBG6fZhwe5x8r2jhg7vsB+sjH+tuJFqLXdNbUXn8Ymd3iZSglxXOv51KHlqy7Yb/bqyOHffQWjSaG0Gb5B2DIW28ii51Nf7rflzhr4ZvuYIdfBXT5KRgUnHD1ZL5unVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vdxmtj4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vdxmtj4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DD3C2BC87;
	Tue, 24 Mar 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774373976;
	bh=ZaI9P4HdmB3KMrbR4xZJNOkfWyry+qYtmIIIXLbqdhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vdxmtj4Fccv1fMIcMIq7MCmAm1ig+TX/gx3la5VFAMBYZLsELxlJqtDnhi8s0B4fZ
	 FLtzNrkiYwLvR/VlBNRdm2g4ZrtmG0X0TZr2TyVuxc8x6k76h5ZsOIUyEILG7t+znD
	 HsssQ29vRLe6cli6lWTOv6jdQ1HJqAj1DZnBHNcQkAKIKL+LKRwHPk0VvTdxe3r1dy
	 LEVtjW6e7jllH/rriv3XSz9sPLVUaGTznEFwLuTrrX2lRLBtxHH9g9PTDJ/Yi9h+jS
	 q0bGnG85JuFtt7z9RHDVdsl+TNuDQqI503+4QYEqi63536yH4BA3zYFqgfTGF5gQ57
	 BJwrDkjNYBm8w==
Date: Tue, 24 Mar 2026 17:39:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/5] KVM: selftests: arm64: Skip all 32 bit IDs when
 set_id_regs is aarch64 only
Message-ID: <d5759443-ffc2-43b3-93f5-99ec55492a81@sirena.org.uk>
References: <20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org>
 <20260317-kvm-arm64-set-id-regs-aarch64-v5-4-a60f2b956e22@kernel.org>
 <86pl4t41kc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H1nc6A8dHTsws8fc"
Content-Disposition: inline
In-Reply-To: <86pl4t41kc.wl-maz@kernel.org>
X-Cookie: Forest fires cause Smokey Bears.


--H1nc6A8dHTsws8fc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2026 at 04:47:15PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > On an aarch64 only system the 32 bit ID registers have UNDEFINED values.
> > As a result set_id_regs skips tests for setting fields in these registers
> > when testing an aarch64 only guest. This has the side effect of meaning
> > that we don't record an expected value for these registers, meaning that
> > when the subsequent tests for values being visible in guests and preserved
> > over reset check the value they can spuriously fail. This can be seen by
> > running on an emulated system with both NV and 32 bit enabled, NV will
> > result in the guests created by the test program being 64 bit only but
> > the 32 bit ID registers will have values.

> I don't think papering over this problem is the right thing to do.

> If the issue is that you have HW that has both NV and AArch32, then
> KVM needs to be fixed to make the 32bit IDregs RAZ when NV is present
> because that's not a configuration we support.

Yes, I'm seeing this in practice - it hits by default with qemu which is
rather more readily accessible than actual hardware with NV at this
point and I was concerned that since these registers are explicitly
UNKNOWN (sorry, a mistake in the commit log above there) rather than RAZ
if FEAT_AA32 is not implemented there might be gotchas.  I do see that
there's some forcing for the case where the host doesn't support
FEAT_AA32, I figured there must be some reason why it wasn't done based
on the guest configuration.

I'll add something to kvm_finalize_sys_regs(), it'll still need updates
in set_id_regs since that'd make the 32 bit ID registers change value
when the guest is run.

--H1nc6A8dHTsws8fc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCzFIACgkQJNaLcl1U
h9DDYwf9Em0WcSM2aylb1zHYADTr7YnIzBQqP/o86zuktEp0HrunQTiCzDnl3NMQ
14RDXaHemX5VrVrYw29JutWLjEl1YI96rmMC8p6qBGSbo3V4DuV6pgoNwDta713e
EJot0soFFT+bQk/N89VCWySOmyeWQKOBG93JVNiVBQ95+dcEFst5EmnfCGrpIan4
yolB+GbbZ3SO3T6e3qg/ySgwrREbwCHLb+WAdKfV7NsT3AhXVrbaomdmlxIN056L
foTiPS0xYSRj34dNUUnAamoZkgH/W+8+1J+sfufT4xjezwviTr4WlkHTxIsL0UPx
2UJZqwfH8yGafVp75qoAFoGBj/kXZQ==
=krAn
-----END PGP SIGNATURE-----

--H1nc6A8dHTsws8fc--
