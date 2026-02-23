Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0392E7635
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863414; cv=none; b=QQkWKpFT3z2pPC6kOZ2nUNxVkYAUrB71cCbwSmnYopQ/7MsvI9glyZIyU85DQ/q3nk+pLeY9hYG/0nHemJmIu4nhVNhR2YYoYPp7MZiYuHRimAZx9AbZayQNqgKLcspwDfP/gk0ebTQhRhPCd/gKlupNrFjhBkiXO/60rq7ewU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863414; c=relaxed/simple;
	bh=7l8IDFSCWyfS//I/EqVL2cM0GU8dXHWPbZ/2dcCjoWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCBpJ+z4LZwXUg9iNvsknIGThFcWs6wQ+JzdMcuMLz/lY+L4xh+R05j8MjVAPcXIcv46GlUFLZPxV+GfV8eEVpzi3KV/HkuhcGt+WoC3h6zaJG0EXj7H9wFXAehV0ZfnwU2+GSz4NlFnJTTtrHBR/fYhpLb79ZNivAGnU4LzlUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjLz40p8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjLz40p8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84929C116C6;
	Mon, 23 Feb 2026 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863413;
	bh=7l8IDFSCWyfS//I/EqVL2cM0GU8dXHWPbZ/2dcCjoWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjLz40p8Gf962Rh2LhaPyP5AmV7b0qGzlHRFEZp5mW/aWkZAGR8lfkRAN8MkWoRUC
	 p8YCvEPP9QJF/e6tlkeavKmhvRf3vgpzRuXd7uyw0fVq/+/47Cl82+AVm4ym/FE7WS
	 c/Rchqsm8dLiWhSb9TS7uWxyZsIkaGjIqtSG9clmrMxDC6ys7B1CJEimQXVEF+dQ87
	 pVtVKzV9GGQLLSTb2C7VD+o02HzMGinY9ZZNUhb5jrJqIwDhXUmZE1k18X+BpSHeqv
	 gA5X5FaIuliAxXEmvR+PPdPZYfrfqLxGrACugMFjo0j7bpaVclRzQwfbi20XzE4sLL
	 tLZFhforBEvlA==
Date: Mon, 23 Feb 2026 16:16:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com
Subject: Re: [PATCH v1] KVM: arm64: Revert accidental drop of
 kvm_uninit_stage2_mmu() for non-NV VMs
Message-ID: <42d7a570-2ea7-4b5e-a046-83e001cc8e29@sirena.org.uk>
References: <20260222083352.89503-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jW848/BYAAPN1MDS"
Content-Disposition: inline
In-Reply-To: <20260222083352.89503-1-tabba@google.com>
X-Cookie: My LESLIE GORE record is BROKEN ...


--jW848/BYAAPN1MDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 22, 2026 at 08:33:52AM +0000, Fuad Tabba wrote:
> Commit 0c4762e26879 ("KVM: arm64: nv: Avoid NV stage-2 code when NV is
> not supported") added an early return to several functions in
> arch/arm64/kvm/nested.c to prevent a UBSAN shift-out-of-bounds error
> when accessing the pgt union for non-nested VMs.

Thanks Fuad, that seems to have been it:

Tested-by: Mark Brown <broonie@kernel.org>

The patch also seems to address some spurious OOMs that I was able to
reproduce with qemu when running the kselftests on pKVM:

   https://lava.sirena.org.uk/scheduler/job/2482739#L2375

--jW848/BYAAPN1MDS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmcfXAACgkQJNaLcl1U
h9CQ3ggAhwgQEGozf8ZBcAMfdUnYfnOQ6XoGZ88XarxGHlxNW5LCrR1KGbrNs076
d19LrTrdzEVIgNfWYl23L0m2N4FBeQ9HUqtLKA4bVOi/FAAhnSDefv4iucQKs3Mi
AUDkf8exbWpM9jNHk9y3VL9MrQ+MR0oExnmT+XkNsMkj0K9YIcfZAvuPuKU80Lpm
0lh0Vcm0wyufkv+nt/aycxfBNicfgU8e4YfF1WObAkW6bAg1zxIW9GHbFz4CRpdF
cde015TcnoYCDcWJq0IRBt6emF8qmZPaJo/sTkuAeJRMcgeCit8oB7WYEGvAjjWE
wdViggdtflRbRJKJmdxfwCDREzyFrw==
=Kua5
-----END PGP SIGNATURE-----

--jW848/BYAAPN1MDS--
