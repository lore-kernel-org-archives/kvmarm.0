Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6B61FF3;
	Wed,  5 Jun 2024 12:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717592185; cv=none; b=rHuwZBvBPZ4edAmQYfnF1qjskHCM+GlyZQrf27lW4Lg/PyDTEvN4CHDysW0REirbvmQO++0E3ZVLcYzQvWP8TSmva2yxHEsBTDlc/JDoWqL/TIlCu2wTiAhuWlSRlddxpSu3I2Xb93iz65W2x1+vwnwR1D5LAeoCUzT6iSZpxng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717592185; c=relaxed/simple;
	bh=H+8uVs/sBG+UVmSbTeEnbYMN4hk29tYYk86tahZARVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DDwzdvOjiL/MnL3QP//IDNx370LyN1XcayJWSAShnOH3DOIq5ZASA0JPNpmuoFhs2lxmsO9C2juvFF+Rsoy8Lg2SFbyvmoGb1/wIAuZ0/uddU3Gc9lA4lDt4ufOX4+U2gA2CU4vJ3hJUm/SIIxKbxBcL1ekr3prj8oRob96A2+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1It8SbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1It8SbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92CCC32781;
	Wed,  5 Jun 2024 12:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717592185;
	bh=H+8uVs/sBG+UVmSbTeEnbYMN4hk29tYYk86tahZARVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F1It8SbAYOnsn0akrvLt4mzzum/kCqexR9/RQex523qWDKJEdRV/508vt+8bUWgzE
	 4CdTC5M8018GEddmTMv4mCpWNGcmrYOL3fPgnhR9gNTHIVgQ9lbkuJdjDzBpUB/POj
	 oyIreHIssJTz+H1QXKPFyIvW8MLhcXVF0LsfEDujvODza+xPldL2pJL3UtShEHEK9S
	 565ezLs3EMlvAKMfsZezmUS4ZbKEL0qE3M82De5nkWd3u9mLj0YkoQD8LqyEYkSK3g
	 zvYD0irgrUzZc9A/bzHUdhAO/ydlqu5sucMSiIWnnJlyJxHqcA83S5cgiie1cErfLr
	 sVC0nCAIzQzmA==
Date: Wed, 5 Jun 2024 13:56:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Message-ID: <50d3d9d3-50f2-4c95-a481-6e744ae17099@sirena.org.uk>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
 <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-2-680d6b43b4c1@kernel.org>
 <CA+EHjTyGWu-5JQjhit310VY8fOeVZ1Ht7cbfYoF-AUi0yEDJYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dPsNrGbRL7TTHtEY"
Content-Disposition: inline
In-Reply-To: <CA+EHjTyGWu-5JQjhit310VY8fOeVZ1Ht7cbfYoF-AUi0yEDJYA@mail.gmail.com>
X-Cookie: Simulated picture.


--dPsNrGbRL7TTHtEY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2024 at 01:03:16PM +0100, Fuad Tabba wrote:

> Actually, I was working on fixing it and was about to send this, which
> I think might be a bit simpler than what you have. Let me know what
> you think and I'll send it as a proper patch if you agree:

> +
> +               if (!max_vl)
> +                       max_vl = vl;
>         }
> +
> +       info->max_system_vl = max((int) max_vl, info->max_system_vl);

Yeah, I originally had written something like this (just doing the max
in the original assignment rather than staging in a local variable) but
it didn't feel great and like it was more vulnerable to getting missed
if we do more parallel bringup so I switched to keeping the split
between enumeration and integration.

I do also prefer the _cpu_ naming since _system_ could be read as the
maximum that we're actually using in the system, as with any naming
thing it's all a bit bikesheddy.

>         if (system_supports_sve()) {
>                 kvm_sve_max_vl = sve_max_virtualisable_vl();
> -               kvm_host_sve_max_vl = sve_max_vl();
> +               kvm_host_sve_max_vl = vl_info[ARM64_VEC_SVE].max_system_vl;

We should keep the accessor functions, it's more consistent and supports
refactoring.

--dPsNrGbRL7TTHtEY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZgYHIACgkQJNaLcl1U
h9DZ/wf/ZIogM3NDLMaCTxNsRikMzWiooLVUWAOHEoDUbhu91kG6fWBYVHUwDuHX
v2ZWGDKptRlwPrxx7ixSn4UgZlqHOcnqbTuVi/JzX+VtB1aYX/KWKKlkVfptZ6yl
mohaQOBVS5VoXAUVEexOgIJ5lNCPgRMFNvXfzbBQTaAfeHGp+sPgzUzivAaFuvSy
oVG/CI8bptsyhD7/0ZgEhizhOe329ITuVZ4i9/JD+d346w9IisFSzyMa+f5qPYYg
2WcwhRNIB1OaaMcIgXekGPiJzi5SCL6TRwWpGhVOwKFJ5e3cR7jgvzuwR2kEQyx6
1w5ao6U4U7topnm7IzHzvpp/AagL9Q==
=LbHy
-----END PGP SIGNATURE-----

--dPsNrGbRL7TTHtEY--
