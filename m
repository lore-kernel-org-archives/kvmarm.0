Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC3F12D744
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421236; cv=none; b=Z1Zj5irP5yGhgv1bewZHn9zPgs7an4rzgaL9hOKhLw9yQH12kqmq0yQPK/wntHb2CyaaG7abR/Gh7DuJZlXoLkcEplyjABcyvKqn1Hms1lBwKIHrWWfj7+a/TbQLfJJXMMBpxLjgsQBBnd+AJ6f0RLP+Vm/JrCS7HrB5TTaPrNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421236; c=relaxed/simple;
	bh=9GFP/meejOAhLaKQMR6/OBCb9mcsyl9MsMZ0bidLCaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfzJDQ5KHzgZFMCAKdrTKkkOpH6KIa3d3mzseur5xByvh89Ksc23cihkqkD6ldBtqnkSbITtBnEAscaXcxf2mnv6TzMHzlLEH4BLpP+nS2i2OzLkdadNGmWb9KOhPMCvIVDRrxwVLIXAM32ge4m+42ab20w8YegQoTLcRAvVydA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTR2zAj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTR2zAj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AABC2BD10;
	Mon,  3 Jun 2024 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717421236;
	bh=9GFP/meejOAhLaKQMR6/OBCb9mcsyl9MsMZ0bidLCaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTR2zAj2MYu2twCXYrZt2E/zKLM3CIhRw2XQXaULlmHzSTskVsig8reS2UzhsF1LF
	 GfptLCpPF85CScug6fLNX10lfg3dVwTwLRmTe6pEazJYWOXtMxWVU0yF81izYnKnpo
	 qPbCkAvMnNNOa7pfx7ano+FVSlt/Hk3/c6FfCiGxnOFw7Pd0aNRrQsMpYmOwWi4vPx
	 L/pCB/UG9rB6uDl1Vf4e1kG/Pd/YK4QB7ryz9Jzlgo1LTMBqQgMGVUQJeLy0JF1z0R
	 iyO212XUSqVdFCp5+QI+lr+aq99pbCXuEUqlAyt6depNzVyNnX8dh1SenSmdKdCnCI
	 deZkrrIerJXfw==
Date: Mon, 3 Jun 2024 14:27:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 05/11] KVM: arm64: Eagerly restore host fpsimd/sve
 state in pKVM
Message-ID: <6e473418-dbce-4008-94fe-f60174d3f8fe@sirena.org.uk>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-6-tabba@google.com>
 <f205aea1-bc52-41ff-9545-704cda9e23ff@sirena.org.uk>
 <CA+EHjTz_u2M-wsNnD_f=_R+dJoYwL9gUrBz=YwdqGZbtTT-aaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tbeRCat3KzPJxjZi"
Content-Disposition: inline
In-Reply-To: <CA+EHjTz_u2M-wsNnD_f=_R+dJoYwL9gUrBz=YwdqGZbtTT-aaA@mail.gmail.com>
X-Cookie: Don't let your status become too quo!


--tbeRCat3KzPJxjZi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2024 at 09:37:16AM +0100, Fuad Tabba wrote:
> On Fri, May 31, 2024 at 3:09=E2=80=AFPM Mark Brown <broonie@kernel.org> w=
rote:
> > On Tue, May 28, 2024 at 01:59:08PM +0100, Fuad Tabba wrote:

> > > +     write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);

> > As well as the sync issue Oliver mentioned on the removal of
> > _cond_update() just doing these updates as a blind write creates a
> > surprise if we ever get more control bits in ZCR_EL2.

> I'm not sure it does. The other bits are RES0, and this is always
> setting the length. So even if new control bits are added, this
> shouldn't matter.

The surprise would be that if new control bits were added this would
result in clearing them on restore.

> Also, one of the concerns in terms of performance is now with
> nested-virt support being added, and the overhead of doing the
> conditional update when we know that it's unlikely that anyone is
> implementing vectors as big as the max.

I guess there's the option of doing a restore of a value fixed during
initialisation instead?

> > > +     /*
> > > +      * On saving/restoring host sve state, always use the maximum V=
L for
> > > +      * the host. The layout of the data when saving the sve state d=
epends
> > > +      * on the VL, so use a consistent (i.e., the maximum) host VL.
> > > +      *
> > > +      * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
> > > +      * supported by the system (or limited at EL3).
> > > +      */
> > > +     write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);

> > Setting ZCR_ELx_LEN_MASK sets the VL to the maximum supported/configured
> > for the current PE, not the system.  This will hopefully be the same
> > since we really hope implementors continue to build symmetric systems
> > but there is handling for that case in the kernel just in case.  Given
> > that we record the host's maximum VL should we use it?

> You're right, but even if the current PE had a different vector
> length, ZCR_ELx_LEN_MASK is the default value for ZCR_EL2 when the
> host is running (this is the existing behavior before this patch
> series). It is also the value this patch series uses when saving the
> host SVE state. So since we are consistent I think this is correct.

The reason we just set all bits in ZCR_EL2.LEN is that we don't
currently use SVE at EL2 so we're just passing everything through to EL1
and letting it worry about things.  As we start adding more SVE code at
EL2 we need to care more and I think we should start explicitly
programming what we think we're using to use to avoid surprises.  For
example in this series we allocate the buffer used to store the host SVE
state based on the probed maximum usable VL for the system but here we
use whatever the PE has as the maximum VL.  This means that in the
(hopefully unlikely) case where the probed value is lower than the PE
value we'll overflow the buffer.

--tbeRCat3KzPJxjZi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZdxKsACgkQJNaLcl1U
h9B7iQf+Pr6UV4bragkW3xS/r6vXhNfaVgxWpFb/m6D4DPOnuBh5Ez1RUgJAnbs6
OjszNElx1jTzdgOtzpB0WqxxaIOWRtCkSa3Ds5DakeMgCUxJF362eyw7tZWleopa
8LzcagQZ3N2sViCbis8/dRjS5GbFj9nM/tEy+mf0m8VeLcwquQ95HCiYPGARFS5V
7ydC7c9HN/GQietpE7N4+iw3ius6oJFUBYWNFwYW0gpMEg1QODgW9qt+dYwE3IC3
LlhlI0ZrsME5eeonE7m03KAjraC2Dq1EDAFF/OOHyUzxhZ8KHh+5xZnISydhgS0O
UleiUG76vPhF0SFN71ur9YslLX1D+Q==
=T1Gc
-----END PGP SIGNATURE-----

--tbeRCat3KzPJxjZi--
