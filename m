From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: vexpress: Framebuffer broken with KVM enabled
Date: Mon, 16 Feb 2015 10:26:07 +0100
Message-ID: <54E1B7AF.5020905@web.de>
References: <54E1B4BA.3030705@web.de> <CAAhSdy3mNAm6Jt=s3Nt_fy_z=mMf3kG3DqYW3jROTo-ztUGzkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="F50hHlIvTWl1kr8t0gE6o5sljwPkAiA2s"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAAhSdy3mNAm6Jt=s3Nt_fy_z=mMf3kG3DqYW3jROTo-ztUGzkw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Anup Patel <anup@brainfault.org>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F50hHlIvTWl1kr8t0gE6o5sljwPkAiA2s
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-02-16 10:20, Anup Patel wrote:
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
> The QEMU accesses Guest Video RAM (or any portion of Guest RAM) as
> cacheable user space memory. The Guest Kernel might access Guest Video
> RAM as non-cacheable to maintain coherency with video device. If this i=
s
> the case then all updates by Guest kernel to Guest Video RAM will not
> be visible to QEMU.

On x86, we manage such RAM as coalesced MMIO region, sync'ing it
periodically or on specific register accesses into the video card model.
I suppose there is nothing like this for the pl111 yet, right?

Jan



--F50hHlIvTWl1kr8t0gE6o5sljwPkAiA2s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTht7AACgkQitSsb3rl5xRngACeJ895k5eZaZma6NrJ4eJWMF7d
akcAoIrcmsvFR0kvVz2cq8dw4V4V6/m8
=MZ/1
-----END PGP SIGNATURE-----

--F50hHlIvTWl1kr8t0gE6o5sljwPkAiA2s--
