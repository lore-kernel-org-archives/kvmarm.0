From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 09:53:30 +0100
Message-ID: <54E05E8A.5020109@web.de>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>
 <87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5721542282673059997=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7455C45AE5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Feb 2015 03:48:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6hpHe2L8itIM for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Feb 2015 03:48:24 -0500 (EST)
Received: from mout.web.de (mout.web.de [212.227.17.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42CE745AD5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Feb 2015 03:48:23 -0500 (EST)
In-Reply-To: <87iof6s3o7.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============5721542282673059997==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HpD1xnkVMNipUmi6jNmCMHisJSDiecA83"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HpD1xnkVMNipUmi6jNmCMHisJSDiecA83
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-02-13 07:53, Alex Benn=C3=A9e wrote:
>=20
> Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:
>=20
>> Christoffer Dall <christoffer.dall@linaro.org> writes:
> <snip>
>>> On Sun, Feb 08, 2015 at 08:48:09AM +0100, Jan Kiszka wrote:
> <snip>
>>>> BTW, KVM tracing support on ARM seems like it requires some care. E.=
g.:
>>>> kvm_exit does not report an exit reason. The in-kernel vgic also see=
ms
>>>> to lack instrumentation. Unfortunate. Tracing is usually the first s=
top
>>>> when KVM is stuck on a guest.
>>>
>>> I know, the exit reason is on my todo list, and Alex B is sitting on
>>> trace patches for the gic.  Coming soon to a git repo near your.
>>
>> For the impatient the raw patches are in:
>>
>> git.linaro.org/people/alex.bennee/linux.git
>> migration/v3.19-rc7-improve-tracing
>=20
> OK try tracing/kvm-exit-entry for something cleaner.

Doesn't build for ARM (vcpu_sys_reg is ARM64-only so far).

But the values traced seem useful. Wei Huang's patch in kvm.git queue
traces the exception class, but unfortunately nothing else. When would
we need that class? Do we need it at all?

In any case, please add symbolic printing of the magic values whenever
possible, just like on x86.

I'm now throwing trace_printk at my broken KVM. Already found out that I
get ARM_EXCEPTION_IRQ every few 10 =C2=B5s. Not seeing any irq_* traces,
though. Weird.

Thanks,
Jan


--HpD1xnkVMNipUmi6jNmCMHisJSDiecA83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTgXooACgkQitSsb3rl5xRW1QCgspVogBxO1kGyJOr2A2p/IqCD
0yoAoO2Z0zbVpq6E1P+hkrzbOd3ifZwq
=lE5d
-----END PGP SIGNATURE-----

--HpD1xnkVMNipUmi6jNmCMHisJSDiecA83--

--===============5721542282673059997==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5721542282673059997==--
