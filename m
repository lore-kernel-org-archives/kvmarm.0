Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2AC13FE7
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVSlTJmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A691C433C8;
	Fri,  8 Dec 2023 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702043490;
	bh=X3wV6060HkCopjQkdwGSDivAsN5pHM0S5YhuwzozIpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XVSlTJmKrqMxKPJbn/Hpyv1D1rW+jlgf6+i5luVdz+3be7W5HOIyJxXrGaNROLbxb
	 0qH9NlCi2DCJiKaR0OaYip5Inc2KTCV0T/AlWKl6wCb52gMh/Wrj8YD5LoQoRJjkO+
	 WIHj00TJ1J+ixqGmK7OZyvJqqixRSCs6LGa+fpacDcyf/1tXcvJI9iA63H9PSYcJHB
	 pfiXjt2mwkgyN9kBOZQhbSJ2xxVOMDCJugy3BPmsdV6440ahS338H6rLqHH0TLkLDk
	 gYEt9F1O4w8P0O9JuAWnxK0+c4J9PyznS2vjmO+q7lyKi89wTuYlFFcZooh9Ppu2tJ
	 NGhXZF1NQrPvA==
Date: Fri, 8 Dec 2023 13:51:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 05/12] KVM: arm64: Handle HAFGRTR_EL2 trapping in
 nested virt
Message-ID: <ZXMfXb44R5mZHm5m@finisterre.sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-6-tabba@google.com>
 <006ec2b0-6263-4e86-8641-d81c01a91c8e@sirena.org.uk>
 <CA+EHjTx42qgepOaFMt1wLSQ6uPUv8wQTa2z-Z_PEiVPUwYAL8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QR+3V445SIN8OWSa"
Content-Disposition: inline
In-Reply-To: <CA+EHjTx42qgepOaFMt1wLSQ6uPUv8wQTa2z-Z_PEiVPUwYAL8A@mail.gmail.com>
X-Cookie: Slow day.  Practice crawling.


--QR+3V445SIN8OWSa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 08, 2023 at 08:19:43AM +0000, Fuad Tabba wrote:
> On Thu, Dec 7, 2023 at 5:28=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:

> > > +Sysreg HAFGRTR_EL2   3       4       3       1       6
> > > +Res0 63:50

> > Oh, we actually have the register fully encoded since we needed the
> > fields.  Given this why did we need the manual encoding in the previous
> > patch?  In any case this looks good according to DDI0601 2023-09:

> We need both because we need to know the polarity. RES0 and the valid
> bits are generated. In later patches in this series I move completely
> to using the generated RES0, and to calculating nMASK based on the
> other fields. But we still need the definitions in kvm_arm.h for the
> polarity.

Ah, I see - that makes sense.  We could consider extending the language
to capture this information in the sysreg definition rather than typing
it in separately, though it's not going to get that much usage.

--QR+3V445SIN8OWSa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVzH1wACgkQJNaLcl1U
h9DNeQf/YD+iX4T2bndWQgQ87eFaMIv6FFL7iIOcMcfAk4SqoyWAwAcf/DJYK+Gy
04rFA2KpCgBT4LKKzn9BC+G8N1gHW8i0WyqYjMIAoKzm1fsoayvD9FH0H+N+pJBy
sX9M50nP0Kuv9ehBSLZxIGOCP8+KGx+oz/MqjTFStL7Tk56NNjp0LHEFjHFLdsg6
I/L3gMdkln2rrI2N3dIOVhTnxyW3DUiffOHOhS+9aDHJC20agILZ2L4qcSrx1OZv
n2EelnfJnUv+AnpOfBBS7KmibrJPBoD1ccyg9V/bDlFeExKfLHJ2AKSWMhE//EKk
jOcruUTMF7xzZDFUWsy6mw8Q2N3BFA==
=Z9kl
-----END PGP SIGNATURE-----

--QR+3V445SIN8OWSa--
