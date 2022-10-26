Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70497B
	for <kvmarm@lists.linux.dev>; Wed, 26 Oct 2022 15:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2970EC433D7;
	Wed, 26 Oct 2022 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666796846;
	bh=BuD4/Vjf/xVADCL4bUbwfuVXmSZBG129I4i6e5yQyYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DHEXd79Bxp5sDXgLWQQhW2j8khi4BHF2fVClyCHB3Xedvnpyyi9iziv8LPBSMNhrY
	 oARupgdJ40FihvO6+Uthy/7MqhNiRxYuz/pO7fbU5JIP5sddwKLbTl4LgNxaKyB59C
	 OvqGsT3R+Bp3RLs6O7xsEtebNxFCAa0/nBtuk2QO+m+8Q5BAieWVkhhbnlGLYJdo3Q
	 hW3D5lQXmNCrZ83mqLzejY/JOGOmR0xTr+WasRrNNO/SU1y7eiu7Cwyni8HTzXmmtA
	 VC5uiMq63wvuWesoVeRgrpM0BQigpTb535kN5oCGafe3bRjvSb1VC13A5cvVYE3EOM
	 7eNOimH+2RqqQ==
Date: Wed, 26 Oct 2022 16:07:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org
Subject: Re: Hang with nVHE mode and SME
Message-ID: <Y1lNKcXfy/nHzTQ9@sirena.org.uk>
References: <Y1lEWJ7rO4m1CKWL@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5efKBJnPK6QRij7q"
Content-Disposition: inline
In-Reply-To: <Y1lEWJ7rO4m1CKWL@google.com>
X-Cookie: Prunes give you a run for your money.


--5efKBJnPK6QRij7q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 26, 2022 at 03:29:44PM +0100, Vincent Donnefort wrote:

>   static void __activate_traps(struct kvm_vcpu *vcpu)
>   {
>       ...
>       if (cpus_have_final_cap(ARM64_SME)) {
>            // HANG !

You're not entirely specific on where the hang is - I assume you mean
the second SME block and that it's hanging on the first sysreg read in
there:

	if (cpus_have_final_cap(ARM64_SME)) {
		u64 val;

		val = read_sysreg_s(SYS_HFGRTR_EL2);

rather than on the if statement?  A brief grep around the qemu source
suggests that this register and fine grained traps in general are not
implemented which is invalid with SME since this is required for SME in
nVHE.  SME is a v9.2 feature, and v9.2 includes all the requirements of
v8.7.  FEAT_FGT has been mandatory since v8.6 (where it was added).

I did originally have a check in there for either/both this or FEAT_HCX
but it got taken out during review due to the architecturual
requirement.

> No problem though with either VHE or if the host boots with arm64.nosme.

> The host (and the guest) are 6.1-rc1. My Qemu is 7.1.

I've only ever tested KVM with the fast model, never with qemu FWIW.
FEAT_FGT is only used with SME when in nVHE mode.

> Is it a known issue?

It wasn't.

--5efKBJnPK6QRij7q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNZTSkACgkQJNaLcl1U
h9C13Af+NU7hM29HOl40428jfkQK9qlIjawTzJEKSx1fVFK3iJN2tp4W+8wZpxj2
+6w3nM0XgoKYLnY+NvsR4WPj70o+SPeL1jAKagxDQ6J9O/fc0hM+ph7NFh6LM5bb
fJdf7XORTvPB/3h13uEwc7AxbUeviZ9K/g+TE7CRqXlCSr308Rqn6nO/e5ftZGAc
y9zhW7BE58RmJV3w3ptPGG1NKoycpFgVD+IeuS+83C/9zWbSZQNwMlB9u5pGJlAp
9n3ZN2wf8RIh96sk7n1uaGSBNUwI27Xct+Sfl5dQyI2RUVSNhUWaLoQDwKH+/SJq
9M6IKS3f6FHIBvJW8eSnJ96WIK1ZyA==
=VPVg
-----END PGP SIGNATURE-----

--5efKBJnPK6QRij7q--
