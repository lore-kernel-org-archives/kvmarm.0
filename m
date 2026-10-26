Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016312;
	b=hE2rlYYqaxbcHn4CY0NnFlbQDjSppriCgYQF6WcAr/nqTuglZ+1WDqrdB/KZSS53sjKy
	 VJz8T42BuqTz4X+wUXtHpgQIZzt/l9qTHiF9phgYK7pMnDXNAWb8n1dysaxSb15K1OcP2
	 XhqPI/10VLQSgRLF2y8eHV4pEP5O0tWkU7EjFRG/JBwxU2Q6oHLRiJAIQ00TStUXB09V5
	 qLEpnntQaoKXGnn3P0ByK4RSu1bydPTQQVBn1v5+1XK4J/aLcflLL06HkJmDEvOq4L9C8
	 PSAeHDUB6QIL7E7KHZiuIQ5SbQXQ1YbtK7/IANilB+ZtywEP+jJjSPseIxNV/keSYFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016312;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=XrszyOJWwJTV90LIZM95zHwP5tXDmJojQtjJsIJz+qU=;
	b=JDozdlGV91pq6S6c63PhpSTQ5r6T9XT0KHuW3LQLjNjY56y2fw+k4hzLs9jp6ytoQfAj
	 U8pk983tNoAk8s2YuFFTBJ56wlWXlt0JHmOLee8I5lMjDtLlKqWfCrcfKRNcladNAoA2m
	 cNLHhWM8aXi3RY/2sBda0ubfUE6bU3UkTzrWOKKD+vH9uRzY4Wut15UOQo9ZqA+EFOX3l
	 IHiFwgSiRfBG78NsZw1OfH5EM9EZFjDc2zQHa6894P3bvW6XgA/4voNDnC7lZ2Dg6qoqY
	 wYD5D+DAahlgqoJN+hhU5yhFf3leuk7T+2GPekWUfC7oqn01rDMySsSDgNMuIErS1aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oj6JZE/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165EF606A31F;
	Mon, 26 Oct 2026 12:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oj6JZE/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6741F01825;
	Mon, 26 Oct 2026 12:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016311;
	bh=XrszyOJWwJTV90LIZM95zHwP5tXDmJojQtjJsIJz+qU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oj6JZE/kG+hhqZxoQ+yODE7mTOSfVM9r0neDNfQu+XgJYnH9BMCJLbAczYPub7N+L
	 smVfNhxDG3ihVKIfBKNdKfYMtETvU9dG6NVfyExtT9Y4M8mDJrLb8CkdXz51LPA2GR
	 L4ibCVaR977YPgdL9njvzFJO6gLBo9LVJUjOhbpcOgCy062lZv5b0nKTnvlwS5zGI2
	 dFe/RbFRsinmNpkiYdkIi8BYqNUu93ZeaFCMNDrvU8xOzoGtToulgIdCczYKBX5qwa
	 +hnLr9BA9QYs/0c+oLEu88TJgQk2n0Xg7juHz4wT83M1laZqakSTxkWxbVahW+8fRB
	 +r6GQhzwBMiVQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 3CA051AC5994; Mon, 26 Oct 2026 12:05:08 +0000 (GMT)
Date: Mon, 26 Oct 2026 12:05:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: selftests: Skip unwritable ID fields in
 the failed-run test
Message-ID: <at9B9N-90QwLPv5i@sirena.co.uk>
References: <20261026012128.2270251-1-sashal@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lOlYcF5yfFB7kmfM"
Content-Disposition: inline
In-Reply-To: <20261026012128.2270251-1-sashal@kernel.org>
X-Cookie: Victory or defeat!


--lOlYcF5yfFB7kmfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 25, 2026 at 09:21:28PM -0400, Sasha Levin wrote:

> Only a field that userspace can change can be frozen, and KVM reports
> these registers as not writable in KVM_ARM_GET_REG_WRITABLE_MASKS. Skip
> the fields that the writable mask does not cover. test_vm_ftr_id_regs()
> already requires the mask to cover every other field in test_regs, so
> this only drops the fields KVM never lets userspace change. Whether KVM
> accepts writes to fields it reports as not writable is a separate
> question from finalization.

It would be nice to apply the same thing to the NV instances as well but
in any case:

Reviewed-by: Mark Brown <broonie@kernel.org>

I didn't redo the testing that Fuad already did since it'd just be the
same thing.

--lOlYcF5yfFB7kmfM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCat9B9AAKCRAv73Ows9A4
iUn/AP977I6nqPZmrTudLmqcb4MROLcy9GYgz1jVFIocLXDrrwEAnUi0j81aTjSo
ef9JvnGQ0OBh4UI9WY6xdmk4v/IezgY=
=G2In
-----END PGP SIGNATURE-----

--lOlYcF5yfFB7kmfM--
