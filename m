Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D4B3D6484
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813872; cv=none; b=A11ALs6YqGrzE+hjPYb/yYfpGtA0cC82TzZR7Akvl+2DXEAtCjDQpdMFNGjqWGhuk2cMKnxLNDJvfMo/KAqvqNyPh5EhRD+tkOc5/LN+kKyX5nibqoTrOvcNr/CgyW4YfW6cuOiisQVGNfi4EzymxKeWro3/gT9ydFm8pFRmoAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813872; c=relaxed/simple;
	bh=Ff79CYFg0eRQfzuXLzavf5ZNqESp7hBB+EH8XORU0YY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJAVOB7GQBE4xvHaEqn6QOIG4pLSgNZad5GY/AnDajzQwr4OcWOocV4mnLxc/9qfmWWgRFtSwofQErN4Jn7vevsKJcrJmljboon6r8pFUhSTX9zyWbU5MaLeK/MUqyZOUtHQWHqtvtKvEIZiXWc9yyT3U/mm/GhkbHO4i9bS9aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRNH7TLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRNH7TLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31F91F00A3A;
	Tue, 26 May 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779813870;
	bh=tGKU8E+SUvJHoFiynwbHI2BeXeAL0j7cya1Wau7I4vQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BRNH7TLlYQBShbQSHMOmVM58UlZR617G8hnceQvbPzM8LgjFt+ZtxH06U5GRlDccv
	 a6u+j5PeABhEeZrqvERhD9pApZJdpfB+U67MfjD5bliB13lhizEtAcWEsQZnMxad41
	 pLPM1tIuVXvbCU/xub2EPnu19ZdK1eGEC3xTkAbxJgJXlEfOiLrUK1HourKgrlFPk1
	 oilQzIyhebvuEiBULoQAY9+wx1INCK9Bf0QHRTjDYPk/RHo7Sg/iE6ebMYwhdqCZ45
	 GObU37/JLZkfF/3GMsilDE/oKrwheYXps/eyzH9uVhiIxIhLhn0Di8ni2mU9u4+9sD
	 TgYgKpCI687UA==
Date: Tue, 26 May 2026 17:44:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 12/18] arm64: fpsimd: Move fpsimd save/restore inline
Message-ID: <0f666889-fabe-4cdd-9fd2-d87808329dbd@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-13-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7dYZlBhPFm19SJYP"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-13-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--7dYZlBhPFm19SJYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:50PM +0100, Mark Rutland wrote:

> Note that I've used the SVE sequence for restoring FPCR, which uses an
> unconditional write to FPCR. The plain FPSIMD assembly sequence used a
> conditional write to FPCR since 2014 in commit:

>   5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")

> ... but this was not followed for the SVE assembly implemented in 2017
> in commit:

>   1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")

> ... so I've assumed that this doesn't actually matter in practice, and
> I've erred in favour of the simpler sequence.

As I said on the earlier patch I'm a bit nervous about assuming this
doesn't matter for anyone without verifying (though I wouldn't be
surprised if that turned out to be the case) but that's internal to that
patch and this is obviously a great improvement so:

Reviewed-by: Mark Brown <broonie@kernel.org>

--7dYZlBhPFm19SJYP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVzekACgkQJNaLcl1U
h9Cwrgf8DnZ9/uZEoEiYdQkF4oioTz4ZcjgBjg8SV66A43aX0D5mulOMtJOq6uK4
t+GxjGuwQhsDrMbrpMpaUgPILKHZAqaGgSuGePev8+vjWF032sOUxinxbRsVtsLm
IEm8MSeyDiqENEINUgF2m1FZbf/HMkIq1HXUrFQEka0zq1/FzvSuesuHLvqemSTo
0xDKqeFqqkitUNOZrMMW3MVzlWCbu06bE8VrUJ/CjA3WfED4YbPLEuCpjrutr7A/
LgRb3q99zzoq2ZQcnSxhwMRTO97AtJGNWSJdwBmNJWTsF55NVCq/mwKlnLcZw0Tm
6u4Z5hAcYaffWWMGyGs6N/QvU5N1jw==
=TR2n
-----END PGP SIGNATURE-----

--7dYZlBhPFm19SJYP--
