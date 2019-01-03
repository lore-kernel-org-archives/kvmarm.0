From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 07/13] arm64: add basic pointer authentication support
Date: Thu, 3 Jan 2019 21:29:01 +0100
Message-ID: <20190103202901.GA21564@amd>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-8-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181207183931.4285-8-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Richard Henderson <richard.henderson@linaro.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2018-12-07 18:39:25, Kristina Martsenko wrote:
> From: Mark Rutland <mark.rutland@arm.com>
>=20
> This patch adds basic support for pointer authentication, allowing
> userspace to make use of APIAKey, APIBKey, APDAKey, APDBKey, and
> APGAKey. The kernel maintains key values for each process (shared by all
> threads within), which are initialised to random values at exec()
time.

=2E..

> +/*
> + * We give each process its own keys, which are shared by all threads. T=
he keys
> + * are inherited upon fork(), and reinitialised upon exec*().
> + */
> +struct ptrauth_keys {
> +	struct ptrauth_key apia;
> +	struct ptrauth_key apib;
> +	struct ptrauth_key apda;
> +	struct ptrauth_key apdb;
> +	struct ptrauth_key apga;
> +};

intstruction_a, data_a, generic_a? Should be easier to understand than
"apdb" ...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwucI0ACgkQMOfwapXb+vKOAwCgkLvdESb50TdMC9uVVTRAt2oy
JY0An30sVTzX4gQ5fTxKf5nu3+EScPPb
=MRNf
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
