Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D685B28C857
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750350529; cv=none; b=f7YsKSbx74PZnX6/4Vb+U019M14aOrSI1an0TJgpuCL/r85DgMezuLPOGqgM/EtoIk+091/xNSpAxXvXe7FHQQT2IbA5WcT+1/jGrRA4QuGTD1pQ/sJMgwrEoVYKlBUusqrANjD0vp0qWlxSsB0LUztH6ccUKE7dUZsfahI08nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750350529; c=relaxed/simple;
	bh=+bboCj6byfFka+J1B532yhcdurVvKneEGh/Cbxe0HFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/FetliJbuW46/7in/Dachu3x041UvIgA9kiIJ5be5In4sBDB3rmHqNfK+46uQyjQT3kIpzTJZxTc48ic+hJSpPevzbqPM892amonoi64Wwkq7KvPvoaj/D797E9xmdwkDhj+iRCvxjS2Tu8Sf+Dx1tucEAiq+R4zBzQr02V9vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhZNHa0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhZNHa0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA411C4CEEF;
	Thu, 19 Jun 2025 16:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750350529;
	bh=+bboCj6byfFka+J1B532yhcdurVvKneEGh/Cbxe0HFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhZNHa0DyKOEFIbJ8Mnj1k68s7J3KPIkIpub7CkNO/bZViEA+o86VXBXpFkihnwmP
	 SdVEpQl8pKJRhYoqljV+DurVUeD/mW8l2n35mqZFRbgW8SBW/EXoO32eCTVa3Ugu4x
	 u38iSnEtrrsD3QC5gvvIcH+T/fANa7pC8laWcayHEyQXdQpDtjErkDE+8prmn8uJ/0
	 xTFiFHJ+8uLxi3T3QYiEDOzD+P8S0SWT7r9Ox0WeHadwniboNE6y6Wfzf4nB5/7y/Y
	 ZJqjofwj3iuM+SCZZXdCexPvioXB2NfkIGGjEmjRykSBhaFlA9breE2EhHeE/gOcr5
	 o6Qo/ueOupEIg==
Date: Thu, 19 Jun 2025 17:28:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	tabba@google.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()
Message-ID: <2e43f235-e77d-4d05-a10d-d2e108c28d06@sirena.org.uk>
References: <20250619134817.4075340-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U0gCi0rRf9BiJoIk"
Content-Disposition: inline
In-Reply-To: <20250619134817.4075340-1-mark.rutland@arm.com>
X-Cookie: Reapply as necessary.


--U0gCi0rRf9BiJoIk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 02:48:17PM +0100, Mark Rutland wrote:
> Historically KVM hyp code saved the host's FPSIMD state into the hosts's
> fpsimd_state memory, and so it was necessary to map this into the hyp
> Stage-1 mappings before running a vCPU.
>=20
> This is no longer necessary as of commits:
>=20
> * fbc7e61195e2 ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/S=
ME state")
> * 8eca7f6d5100 ("KVM: arm64: Remove host FPSIMD saving for non-protected =
KVM")

Reviewed-by: Mark Brown <broonie@kernel.org>

--U0gCi0rRf9BiJoIk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhUOrwACgkQJNaLcl1U
h9BfXAf8CEVlQAbx2zRr6BRtddp2YrUbZsbCkQ+RlV52H3ERQHfezJ9TNRTOJmOj
0JTV9ggA4ey8zLuo02EBn5I+85WBPZGumueIDOFTGYxxqK0ccEJ3G1PGsovmR5KM
pk6do3W46nmYtQO1DWVwWg/DEND3Z2YZB7IWspbU4+PRwRJTyFcPr7q034KgxvQS
gpxQT9h2vHK7a6t2mJJOWuwgtS0DgL+UcMdYDw7W4DIMTPPvtGyIZ34VEfMs5cxN
zvzYL3NfyKa7ajoV5rJ0hUL1weC+CqGZ0QMlUGmcluwaTo3pIMBRWyGBfUItLoeK
1XZ2S4UBSLlTpG4GdbXhXxL0hZ1pgA==
=p2k5
-----END PGP SIGNATURE-----

--U0gCi0rRf9BiJoIk--
