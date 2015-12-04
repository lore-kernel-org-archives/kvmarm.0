From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] KVM: arm/arm64: Revert to old way of checking for
 device mapping in stage2_flush_ptes().
Date: Fri, 04 Dec 2015 01:58:57 +0000
Message-ID: <1449194337.30642.69.camel@decadent.org.uk>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
	 <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gp7lFH45qmyOeZGpOcHL"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


--=-gp7lFH45qmyOeZGpOcHL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-12-02 at 18:41 +0100, Ard Biesheuvel wrote:
> Hi Pavel,
>=20
> Thanks for getting to the bottom of this.
>=20
> On 1 December 2015 at 14:03, Pavel Fedin <p.fedin@samsung.com> wrote:
> > This function takes stage-II physical addresses (A.K.A. IPA), on input,=
 not
> > real physical addresses. This causes kvm_is_device_pfn() to return wron=
g
> > values, depending on how much guest and host memory maps match. This
> > results in completely broken KVM on some boards. The problem has been
> > caught on Samsung proprietary hardware.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncache=
dness")
> >=20
>=20
> That commit is not in a release yet, so no need for cc stable
[...]

But it is cc'd to stable, so unless it is going to be nacked at review
stage, any subsequent fixes should also be cc'd.

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison
--=-gp7lFH45qmyOeZGpOcHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVmDzYee/yOyVhhEJAQp3hg/5AZUnJl6BWUfFyugXIMDvw+pqB+A4WRh9
gw3YWZrciLxtUwRXMCOqhPU3X3XY1PTqrFCr+Krcki9F/gNsANDnK6GRY+f83dV3
bsuzyroOd289KCv01scQalLdvC1BgxQUSLxnzS2ub0Y9a8FtSBCH3FibO5Ihx5iC
PKdoYiCfTu1T3St1PFcpX2+eoIZx5wMkkd+UgbPJWDSCMZ7eNDmEbjQWroEyDCkv
l8DLc9RVYYULUhXhzlhPtuXg9N6AIYShagkM7XZ+IaCPNwkVXvkkrXVLVj6lkuHK
73pewJBdPObIY4AovcnZJEHUwDGCIgTql4X0RHo4seTGOqikGHpwpVenAI3FXHeY
c/JXXj+rimUXfW2+avwa0KjDhGx+qpSL9G+/ArSvWP9RypOvfu19zDXhdVNtJdMi
f8/28LrXSruVbmevUWzgnI08cs3qk/nOWz7RP4rfm51QTti13hLbJ/QeC8FE/xFD
8ej8MqEbAs5xnGnCXZcaRPqjm348mK8zSLjwhVTgChlabUyYpAv0vEfCTWXwyPv3
qZ9PMMSJvZjKnZP0BjbySitVGI/TvNhTDz4bR19ZwCBTtC4eHl/QtQFdf8FabvUn
WEmt85kAzaWHNR6yh/1eezpgIAMCrAy1XW8l2NtsohBnQEVsoc6ifZbHn4/1Tt6j
Td+OOQov1KM=
=nj6L
-----END PGP SIGNATURE-----

--=-gp7lFH45qmyOeZGpOcHL--
