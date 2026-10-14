Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0FB3955FE;
	Wed, 14 Oct 2026 10:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791973939; cv=none; b=uBSVJvTbzw8SAqQP9tp6wCCywd8KPQyoblK8MmPBmk54mjVTQ6nZm4MizH86pQjIZxRIz0a+YkLZNM+QXihLt06Qv7dk1RcgsO++K89hlzSit+YyBsn+iBRnX3NuslTeyZUPwPznOtZFf+ZmVasEo6uIpRlmyM/c2pgY+rwWi70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791973939; c=relaxed/simple;
	bh=DqLYzY4atgfX3uWZ/8Aq3s3d3o9UsbAJp9fr0fPezio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XiNlhxITsaKVt64rrKX9kUB5fK4MH1qtTI5sgvWDDDhBEBMTNYqosU68DgKpglpu3XI9Jo07E2Y7S0xEk7XTlZulWsv642z9siVzFUlO4U+UBhQvbEazPqqDD2MPvKnShHVesYSfar/uC5Fdy5zuSexJ9ZByBd7IPjOJSuTn404=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1lWXUzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1lWXUzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63A61F00893;
	Wed, 14 Oct 2026 10:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791973938;
	bh=DqLYzY4atgfX3uWZ/8Aq3s3d3o9UsbAJp9fr0fPezio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h1lWXUzNdpqN9TB0VXJKLjdtvJvwomuDCpDmn4NEI9eOnoga2JGdjGUhcMZGJq+8z
	 n/I1++2y6IJlCb7f0KTiCEKmPWSdUxwrv2XEKnqeDvMg5hYwT6CzWBOwLBBhhzUFZg
	 k3bNPnKfiWeKl042igEg6xIM7U5Hl2wgwZeEtbMp7RawTBTL7Gq0gE4QtjY1YQT3In
	 vPPz9VkB+fkp7oVcP5ZZ35JzlNUFMbUWJDlaQTXFMaEWb4aA827P3CtcZJHUGANzcO
	 x9HrcV+x1llSLY12Z1uJKcw+4WKeYP+XYnhXIx6KTpMza/wHi1w4fIRXr0STsZQMFD
	 pzxzYbfQ739SQ==
Date: Wed, 14 Oct 2026 11:32:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v8 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Message-ID: <eaf18ff1-2316-427f-87ef-c4ab164bff3a@sirena.org.uk>
References: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>
 <as8x38o9taXgKZym@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/+RMc89oHuCjE/gH"
Content-Disposition: inline
In-Reply-To: <as8x38o9taXgKZym@sm-arm-grace07>
X-Cookie: Live free or die.


--/+RMc89oHuCjE/gH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 04:40:15PM +0900, Itaru Kitayama wrote:

> I=E2=80=99ve reproduced the set_id_regs failure under QEMU with kvm-arm.m=
ode=3Dnested on=20
> a host that supports AArch32. KVM advertises the NV-capable L1 vCPU as AA=
rch64-only,=20
> but aa32_id_visibility() still permits the inner KVM to expose ID_DFR0_EL=
1.CopDbg =3D 0xa=20
> to the selftest vCPU. The test expects zero because it skips setting expe=
cted=20
> values for AArch32 ID registers.

> In v6 you mentioned preferring an in-kernel solution. What did you have i=
n mind,=20
> given that changing the value returned by GET_ONE_REG may affect the user=
space ABI?

I think the idea would be to force the 32 bit ID registers to 0 like we
already do for aarch64 only hosts.

--/+RMc89oHuCjE/gH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrPWiwACgkQJNaLcl1U
h9C5tAf/YwpI3krDb44ug+WWjgx6koa2aUTW4ZTyIaefJL+81P9TOKAmYy+ZInOO
LZuT8d63HxiL1XIgBUyJSrS2l0dCt6+Qiv/bsPayO1bWUeJwrq03njgtOqjqkimZ
jDVTEInZM8m7ZvETpxsGw2T99oJpQ4LgCvGN2UL0FfeXqouoGG/AKCOtM3P2nQYm
w4cFQxN+kkt3Ae6wf7MoZII9/CwFMj4mZ0lRy7+wZhx9MTmDzKlx3nvZRwDMeO1e
jwfkvZ/QMpE/BDJFaccM7dO3qMT8ZfHYMiZ+fGT7sZQQoq3J1MeDtUK8gtwHzvUr
B33dIuBDPDvj0U+80ceWlgMp+XUR5Q==
=joOW
-----END PGP SIGNATURE-----

--/+RMc89oHuCjE/gH--
