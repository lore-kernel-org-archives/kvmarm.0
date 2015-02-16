From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: vexpress: Framebuffer broken with KVM enabled
Date: Mon, 16 Feb 2015 11:04:10 +0100
Message-ID: <54E1C09A.7030002@web.de>
References: <54E1B4BA.3030705@web.de>	<CAAhSdy3mNAm6Jt=s3Nt_fy_z=mMf3kG3DqYW3jROTo-ztUGzkw@mail.gmail.com> <CAJRNFKLG2k6+4v2p-A22v36TLFX=djkx9cH1wK_qAcQ0M_vCoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="R6wsppsMwOQlAhSdLDTLmTHmvOosfeo2e"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAJRNFKLG2k6+4v2p-A22v36TLFX=djkx9cH1wK_qAcQ0M_vCoQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Anup Patel <anup@brainfault.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R6wsppsMwOQlAhSdLDTLmTHmvOosfeo2e
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-02-16 10:34, Alexander Spyridakis wrote:
> On Mon, Feb 16, 2015 at 2:43 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
>> Hi,
>>
>> next issue related to KVM/QEMU on the TK1: The guest image I'm running=

>> gives proper framebuffer output when in emulation mode. Once KVM is
>> enabled, the screen is - at best - only initially updated. Sometimes I=

>> see the famous tux images and a bit of the console texts, but usually =
it
>> stays black. Explanations?
>=20
> Hello Jan,
>=20
> If you want to force rendering, you can do something similar with the
> following hack:
> https://github.com/virtualopensystems/qemu/commit/64dd1b3e3a2353433edb9=
c63d00271f515bd06fb
>=20
> Of course expect performance to not be up to par.

Yep, confirmed - both that it works and that it's slow (better not try
this with SDL, exported via X...).

Thanks,
Jan



--R6wsppsMwOQlAhSdLDTLmTHmvOosfeo2e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlThwJoACgkQitSsb3rl5xRPLACfQhQDPJzMo5C6hKqIbwyg3l3r
j7MAnjOMwGc0UvT7WL11KKk4Z8+Gnu5x
=46J8
-----END PGP SIGNATURE-----

--R6wsppsMwOQlAhSdLDTLmTHmvOosfeo2e--
