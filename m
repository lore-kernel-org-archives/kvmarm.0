Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E590D1581F5
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 12:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717158385; cv=none; b=YRqAM8KbjChbHF2qyTeZ38a5tbKZbkGVZAt39VKRAGPVcI4bd7EQ8syO9uua1YqyI/V6zf05nECj3shyPMgbnvY1ste1SULbwR2MUBcfej6841ACJfGg++YpXj/OJzh7ZmGusHqVklRo2P/oQNFvqHlGeVYPCaftcM/po9T5Zgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717158385; c=relaxed/simple;
	bh=xsITk3494Aa7aAKZNbplZMTTjB7yIumXUU2mA3NbW8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5shbgtdwTNSMttOca133lt54bzgcn3RE57GDKzxHPINHuk0xylAdtIIATfi8O4CpRIUVYID+XM8UuZu7KUv8trjRsCZOESH1QAK/SxdUNYAHKH3vFZKyD9h3lmeDDmTG12dMAg3XrgNPYd2NdZHW1zZV8DLnmYWkBIZwO3eD4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWAWFLNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWAWFLNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A70C116B1;
	Fri, 31 May 2024 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717158384;
	bh=xsITk3494Aa7aAKZNbplZMTTjB7yIumXUU2mA3NbW8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WWAWFLNoy1DW5Ly9xaXuWi7QVb/30qp4YZtbaP35Xmlf32i37/sOYEY5Hal2U9Fdl
	 5QurO4vsVlB7Jg4o7OGJnEKL2G+nQG9vAuCtd652yxKZbGo/hfMof9IkV7A++Oud8z
	 92mH4xr9vJhxG7ecTt5ZaFaMTtvZHTp0K5+T0hgdtqx8dqUvdqy4eIHQVxKy0iUc6R
	 ZthmSBseEh54O35qG/yMdZHKYcL6CKo6o32fOq8arX/8MMFqemFXHJ6XN3nbktBPgi
	 hBNsrkt4ijIFOcj0QyFxahp082Ihyx+jyE30ub2AVtphroLAk6WmdWLq/82AVgrU3Q
	 lGA8UqG14Mz3A==
Date: Fri, 31 May 2024 13:26:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 01/11] KVM: arm64: Reintroduce __sve_save_state
Message-ID: <ae1d98b5-d3d4-49f8-9478-2a20f89d8156@sirena.org.uk>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="33ozrVmFmZbLZExw"
Content-Disposition: inline
In-Reply-To: <20240528125914.277057-2-tabba@google.com>
X-Cookie: Serving suggestion.


--33ozrVmFmZbLZExw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2024 at 01:59:04PM +0100, Fuad Tabba wrote:

> This reverts commit e66425fc9ba3 ("KVM: arm64: Remove unused
> __sve_save_state").

> +void __sve_save_state(void *sve_pffr, u32 *fpsr);

The prototype says this takes 2 arguments...

> +SYM_FUNC_START(__sve_save_state)
> +	mov	x2, #1
> +	sve_save 0, x1, x2, 3

...but the macro takes and the function supplies 3 arguments.  This was
a bug in the code at the time you did the revert (the prototype had been
missed when adding save_ffr) but we should still fix it.

--33ozrVmFmZbLZExw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZZwekACgkQJNaLcl1U
h9DhKwf/VrJZpClWehasbVl1ahmDa9Ovoy/1wO8OF0uy375t/7xqYTS8o9mlqIqs
Y8Xr0tby10p7wvc+CBstjyeiLvq/r7vJJAdD2Q+h31JFdHHdTReCKgA3SGDj1dEj
uyhVJD85SmAHnqaVWCGJVH/LcWMHaSaGLKhEmQfvlYbGjB0WC04CEvWDYt84tU88
Sy9IlKq7Shc+wPxLwXXlmP27MxBpPdNq3KOEBTQvNV2QaVBM9Zm/iDmN55RGj21F
tuiI772bWX6xd4NIjoYAh4H06I8mH/ZG78Hw4GchcfrQBnC3AVDgRIW8I3x/mG7r
isO64axjj30XX7wAk+xZvr56Dkivxg==
=MwPN
-----END PGP SIGNATURE-----

--33ozrVmFmZbLZExw--
