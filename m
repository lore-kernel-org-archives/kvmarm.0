Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2CAD3A
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 17:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D69DC433D2;
	Fri,  3 Feb 2023 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675445258;
	bh=qdqKMVmXQtSnLdnllNZlXQSVBcFFRutZxBy0MxqaLbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eauXkYx93nDSIcnS9EMKqtGPCaZhXr6UmZLAzGmYBBR+HJbU+8G8cGZM8/lq0FVS6
	 jCCobH/+EK9jpRI469JJkZUahe8HTwSblm/8Qu1yhYAHp21QG4NN8/zz+cqDciq9f/
	 I9EV/upAfgDxXO0MjTww5QwVOqe20Za1oYKwb7PfLGgy+hsGkNLKuNLk+epMZMYU1i
	 HirbCvmz1FkSRyPXZbQqumC3yCCGeQrczYuXCiMeICLG8PGIFV2V136EQDdVW4kv/R
	 tHbViNX2I9fLnrxTqVGu2J6eJbWqxSz4gDQwIllmJ5SsBPYlnSCbqx13dUKskCCbBg
	 DhxHaMZqzP3Rg==
Date: Fri, 3 Feb 2023 17:27:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
	reijiw@google.com, rananta@google.com, bgardon@google.com,
	dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y91EAxIv7lwSMQ5g@sirena.org.uk>
References: <20221017195834.2295901-1-ricarkol@google.com>
 <Y90e4IluvCYSnShh@sirena.org.uk>
 <CAOHnOrwqJ+K4vcyzV7z=BcC-J=ZyFj8wZYSdJO7Kk=kJ=4kKOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/gTOaUC39ON2rc/4"
Content-Disposition: inline
In-Reply-To: <CAOHnOrwqJ+K4vcyzV7z=BcC-J=ZyFj8wZYSdJO7Kk=kJ=4kKOw@mail.gmail.com>
X-Cookie: No animals were injured.


--/gTOaUC39ON2rc/4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 03, 2023 at 07:36:37AM -0800, Ricardo Koller wrote:
> On Fri, Feb 3, 2023 at 6:49 AM Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Oct 17, 2022 at 07:58:20PM +0000, Ricardo Koller wrote:

> > # ==== Test Assertion Failure ====
> > #   aarch64/page_fault_test.c:316: __a == __b
> > #   pid=851 tid=860 errno=0 - Success

> > #   ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write) failed.
> > #       !!(flags & UFFD_PAGEFAULT_FLAG_WRITE) is 0
> > #       expect_write is 0x1

> That failure was fixed with this series:
> "KVM: selftests: aarch64: page_fault_test S1PTW related fixes"
> https://lore.kernel.org/kvmarm/20230127214353.245671-1-ricarkol@google.com/

> which made it into kvmarm/fixes and should get into 6.2:
> https://lore.kernel.org/kvmarm/20230129190142.2481354-1-maz@kernel.org/

> Note that the failing assert does not exist after the mentioned series:
> > #   ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write) failed.

Ah, good.  That's not made it into -next yet unfortunately so far as I
can see but hopefully it'll turn up shortly and everything will start
passing.  Thanks!

--/gTOaUC39ON2rc/4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPdRAMACgkQJNaLcl1U
h9DgmQf+Jt2Bqov2Wwmed1KWEf4KZU0PQ51xIYStHyM2AjsGZTFwCHUA8PAA8WV+
Ky4x+iKYjP1/WOIfKJocaBrD+uZaTSA7EsMlkaBkckxX+XS39ifnH0nsdtQWIQ7T
AJzwsB3F5B/RIGGaf4kbDPkTDKzXqlWhVw/r4kWkDWCwd741X6DVf2h51ClHIvYf
7VbN0tY1+Sh7zSRcOt45Tw6OlpJ41fpRrne6gV8yQXNMLJSp/Luk9a9PmJSCv5rz
t/Bx2yhBkKAAPQBEybFXUesEsJ7BAfs0NFr7Xhl0sfMetMJpPdAhwqZY35RgJai7
ZNzJGZ6Vgk2MPu5MeI6EJnCaJ5NO6g==
=yMQh
-----END PGP SIGNATURE-----

--/gTOaUC39ON2rc/4--
