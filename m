Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744614A1B
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717426243; cv=none; b=ANhGFlthbWl4SYZByWuK9zmkl2WoVH2Wl4P7QZUwO5f5u2fo0LErvE49mf4tN/lIYeOawsaDZoM16aOyHwAvX5p/+8ruSNli+Am+7IZ2I0sKVucHbJOPlpy6P432LzlkpTHJqqFFX/6bShOKl38WrCJ1lN6sKe8VcoIeLTPOwsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717426243; c=relaxed/simple;
	bh=WIPuEc/s/07sHpO/fz8hH4Dcc6H9/p6XEJ7Jfu5gk2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EaoK7F+z2rH5rgIV1tE+IQHbepz01VJOwVNP4LMRmm/HYR1qc+w044ohmj4vk0UZbRKug3BI0oEGie47+yVNfZcMosNWwhXR/NeJI/GFcOPrdBQxruLEQ8jbHKkJJZorzYJGZFfdC7X9yNYia4qFF8s3np3nrr+HXPS/ph9o9xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnqTshmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnqTshmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F574C4AF07;
	Mon,  3 Jun 2024 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717426242;
	bh=WIPuEc/s/07sHpO/fz8hH4Dcc6H9/p6XEJ7Jfu5gk2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qnqTshmdQkPXbt0aQmbmSCL5ubDlgUArzk/TtI25GSy6nMACfLnt9Q2MkybBPHON+
	 pMEEnDZGPcHF24ijA1W/9dFzbC5p2Nz2/8ZzEeiZvmKUxq8snfocOcHP5oubhZrdlD
	 /nazJ0r7SZIC3wWrHV4W4oV1b2ze13GcU/3R2i+jIgD+ckvAUl6YKmi9lmxC76oezt
	 9fYtse4CB1Bo/J8dL4jT37s+1nhsdcu9UUquP55EXBjQnYpMTlmq90RjfPJGVcXe7L
	 WMe25/otppxCq3Lhl+thbRbUnanWnvDmTdXDNOleu8RtDLa0UyfKsHfYt/hfnbUpId
	 hliiYaCPZrV3Q==
Date: Mon, 3 Jun 2024 15:50:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 5/9] KVM: arm64: Allocate memory mapped at hyp for
 host sve state in pKVM
Message-ID: <54ceca2b-ca7b-4046-8155-46623f829bf9@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AJWUfdzA6mtlIomT"
Content-Disposition: inline
In-Reply-To: <20240603122852.3923848-6-tabba@google.com>
X-Cookie: Don't let your status become too quo!


--AJWUfdzA6mtlIomT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 01:28:47PM +0100, Fuad Tabba wrote:

>  {
>  	if (system_supports_sve()) {
>  		kvm_sve_max_vl = sve_max_virtualisable_vl();
> +		kvm_host_sve_max_vl = sve_max_vl();
> +		kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;

As discussed on the prior version this either needs to be the maximum
available physical VL on any individual PE or the hypervisor needs to
use this VL explicitly when saving/restoring host state.

--AJWUfdzA6mtlIomT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd2DsACgkQJNaLcl1U
h9AAHgf/aZ+uC/1OFp3jcmQglFpnodQwnj9tMoJD+4jTB72kZJJ+jWEVsbYGh7vR
ZsAca0RnVtu8iW7EhKupSJ9tkDAgPTknU0AbXFpWT42rhOuiU06Fj1UZdxzX6LWV
DaS/6kuZlIIcr+/sBPFBf1xQEEBmuQRTPG2ohyJE99oY8SCTmeueCY+3XEn+x9C2
vnIDaJBs/NPQr4duDt4N/nixA5+5qes+l1ct81ueRBuolVJ43nf4InFCqaXOq+tj
JBDNhdEPQ/4qoJSn4C53UUmRPPunxaewIjdPsoQ2XtVL1uNPC27D5r2AOlLcS6GZ
iedJ7e4k/tUYCMtYg/hnrOL+O7stJA==
=LLJk
-----END PGP SIGNATURE-----

--AJWUfdzA6mtlIomT--
