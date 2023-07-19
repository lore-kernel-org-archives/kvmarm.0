Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B4221D30
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 13:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60714C433BA;
	Wed, 19 Jul 2023 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689773147;
	bh=EyVLtL0y3pMG2CuYY0w75B4btgW07dMcezlAZDsSdHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gb9Diglh/i64PDngyNdt/GKb2Nk1ffhlx2iCYRVwYwJFFaIWeqdykk3XHsdIjxi+U
	 ySo7EE75m9kyEmpGqZr+PUnM1neiLXdgMRuMhDCLMjYIpKB5stI7SDZFdeCnV7pSuT
	 3rxlgGugHsMh6Yu2Y2ZMz7uzUyqXc5OaAdIZuONNkooR8IAwPmhrzZzWDT1N1DwHYx
	 RlTVeZoCs4CL7meIUWNo6SyAJaBckf8cXgHWQ1TpJoo/sQRvPGvbROxf9n80ltzbXE
	 5eGxexNIybAnY53SN4bcht+Z5iuvu040wYt+t4TGE0tkG8rPpOs8sUKiihTlsC+cQY
	 ajt3gtR/VCWvQ==
Date: Wed, 19 Jul 2023 14:25:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 04/35] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <01dd7853-953d-4715-8cf0-c2f500065b55@sirena.org.uk>
References: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
 <20230716-arm64-gcs-v1-4-bf567f93bba6@kernel.org>
 <20230719114437.GJ1901145@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I9qodeRa311/Bc25"
Content-Disposition: inline
In-Reply-To: <20230719114437.GJ1901145@kernel.org>
X-Cookie: They just buzzed and buzzed...buzzed.


--I9qodeRa311/Bc25
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 19, 2023 at 02:44:37PM +0300, Mike Rapoport wrote:
> On Sun, Jul 16, 2023 at 10:51:00PM +0100, Mark Brown wrote:

> > +* When set PR_SHADOW_STACK_ENABLE flag allocates a Guarded Control Sta=
ck for
>=20
>                                                  'for' here looks excessi=
ve ^

> > +  and enables GCS for the thread, enabling the functionality controlle=
d by
> > +  GCSPRE0_EL1.{nTR, RVCHKEN, PCRSEL}.

It does scan fine to me as a native speaker.

> > +7.  ptrace extensions
> > +---------------------
> > +
> > +* A new regset NT_ARM_GCS is defined for use with PTRACE_GETREGSET and
> > +  PTRACE_SETREGSET.
> > +
> > +* Due to the complexity surrounding allocation and deallocation of sta=
kcs and
> > +  lack of practical application changes to the GCS configuration via p=
trace
> > +  are not supported.

> On x86 CRIU needed to be able to temporarily unlock shadow stack features
> to recreate the shadow stack of the thread being restored. I presume CRIU
> will need something like that on arm64 as well.

It would be good to understand why and what exactly is needed here.
I'm guessing the main thing would be stores?  It's relatively easy to
add features later, I think I'll just add support for everything except
enable just now.

--I9qodeRa311/Bc25
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmS35FEACgkQJNaLcl1U
h9ATlQf9HMvGT285Dxb1K98/IQO88I6xjkJKw25NyYtFdnj3sDQr/5mkdc17dstk
89MZPCDWgwC0akok+8SB6yCnT8x6dYbpiCgo7RkJXlfEhqR+xhvrJ7N+VRcoW4Uz
ZZuPeiCqQs9GwvjBL9y0oD00oCZeIh/tfYI0cti4uHuUDaIiOjy6E9x96TGWTxBu
l85odWvjI7U0wOUXQQL9qoDQCBU3bO52EN0k30ch7ILF9YAwR/NgAISqgoHreQ7d
LrmfFdQSTWQiqh9/zau9U7ZESH/kw3vLVBo/TZd+pzuMnc1g+rxyKEHVZoJi1DBh
3Tt8WxOzSOFTarknQTMyOSKwRH7q9w==
=EN0T
-----END PGP SIGNATURE-----

--I9qodeRa311/Bc25--
