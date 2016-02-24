From: Mark Brown <broonie@kernel.org>
Subject: Re: next-20160222 build: 5 failures 9 warnings (next-20160222)
Date: Wed, 24 Feb 2016 12:28:42 +0900
Message-ID: <20160224032842.GK18327@sirena.org.uk>
References: <E1aXlz4-000486-Pb@optimist>
 <20160222100832.GX18327@sirena.org.uk>
 <56CAE5E6.7030707@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kT6E5F7CIExsifM+"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56CAE5E6.7030707@arm.com>
Sender: linux-next-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


--kT6E5F7CIExsifM+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 22, 2016 at 10:41:42AM +0000, Marc Zyngier wrote:
> On 22/02/16 10:08, Mark Brown wrote:
> > On Mon, Feb 22, 2016 at 08:36:46AM +0000, Build bot for Mark Brown wrote:

> > Today's -next fails to build on arm64 due to:

> >> 	arm64-allnoconfig
> >> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration of function 'kvm_call_hyp' [-Werror=implicit-function-declaration]

> I'm about to push the following patch on top of the KVM tree:

> This will create a new conflict, but will make the resolution 100% clear.

That didn't work out unfortunately, the error is still there today.

--kT6E5F7CIExsifM+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWzSNpAAoJECTWi3JdVIfQIeEH+gMMySI7G6JjUMlmRCeDz8NE
fI8CHfINC+pHhqW2NqiTLMZQ1Lu4Rtpti5IYzSnGvydMxVaFdVjS+YzmJzXc8cPj
vsOQ96o+CzI5RLyWgHOodscPkJMN3Iegt/PI/J6vRcmwrtcUgzSlmy0Zf1bE5/gU
e13WIhGyqvtj/csN7PwA1DbeWCY7+i9WRbBYhzb17BIQvQe2WfRC6CSnz0Bmbf/z
zxqok++n0/nDx94qUjB+/ISB80R4njiy720Li0zUXVI7xNMpMsn2vc57ADPcCkhO
sduEMvirqMx5/SgohsqE7ix3BSfUFWsI2Jsc1kgrqMiFMmzus5CgNGm6T7PDd7c=
=7dY0
-----END PGP SIGNATURE-----

--kT6E5F7CIExsifM+--
