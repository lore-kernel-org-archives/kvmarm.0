From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 09 Jul 2015 12:40:39 +0200
Message-ID: <559E4FA7.2060307@web.de>
References: <558BC2F5.9010303@huawei.com>
 <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
 <558BC90B.4060806@huawei.com> <558CD9DE.3010609@web.de>
 <55917E5B.3030401@huawei.com>
 <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
 <559D483A.40507@arm.com>
 <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
 <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
 <20150709102201.GH13530@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3608922020970071924=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF73F58317
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 06:30:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eT87sg3KlvzN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 06:30:53 -0400 (EDT)
Received: from mout.web.de (mout.web.de [212.227.17.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60C075830D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 06:30:53 -0400 (EDT)
In-Reply-To: <20150709102201.GH13530@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============3608922020970071924==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AvASsLauLRO4I1d4ccMmM8aSrVO0pJBV6"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AvASsLauLRO4I1d4ccMmM8aSrVO0pJBV6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2015-07-09 12:22, Christoffer Dall wrote:
> Hi Peter and Marc,
>=20
> [cc'ing Paolo for his input on x86 timekeeping]
>=20
> On Wed, Jul 08, 2015 at 08:13:59PM +0100, Peter Maydell wrote:
>> On 8 July 2015 at 17:37, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On 08/07/15 17:06, Peter Maydell wrote:
>>>> I'd prefer it if somebody could investigate to see why QEMU
>>>> is actually doing this -- so far we just have speculation.
>>>
>>> I'd prefer that too, but so far people seem to be more comfortable
>>> waiting for the issue to fix itself. In the meantime, VMs are broken =
in
>>> weird and wonderful ways, and I don't think the current status-quo he=
lps
>>> anyone.
>>
>> Putting in a patch which might not be the right fix isn't
>> necessarily a good plan either...
>>
>> Does has_run_once get cleared if we do a re-VCPU_INIT
>> of a CPU that's run before? (We need to allow rewriting
>> of guest state at that point so that "reset VM and
>> load migration state" behaves correctly.)
>=20
> no, it does not, has_run_once is set the first time a VCPU is run and i=
s
> currently *never* cleared.
>=20
>>
>> I suspect Jan is right and we really need to distinguish
>> the KVM_PUT_*_STATE levels in ARM QEMU. This probably
>> implies some kind of whitelist/override mechanism, since
>> by and large we neither know nor want to know the
>> semantics for system registers, we leave that up to the
>> kernel.
>>
>> Q: if you have a running VM, and you pause it for
>> an hour, what should the CNTVCT register do? Presumably
>> it should not advance, but how do we arrange for that
>> to happen?
>>
>=20
> I think the CNTVCT should not advance when the VM is not scheduled, so
> if we pause the VM or starve all the VCPUs for enough time, the guest
> should not see time progressing, since otherwise the guest scheduler
> cannot maintain fairness and you're bound to see spurious RCU stalls
> etc.
>=20
> That's exactly why a guest can read both a virtual and physical counter=

> and it is an area where you simply want some level of
> paravirtualization.  I haven't studied how/if Linux deals with this at
> all.
>=20
> So I think adjusting CNTVOFF should be managed by the kernel for the
> pause/starvation scenario (which I think Avi once told me x86 does too =
-
> does anyone know the current state of the art?).
>=20
> So the only situation where I think userspace should adjust the CNTVOFF=

> value is for migration where we are talking about a brand new VM with
> has_run_once clear.
>=20
> Thus, if we were designing this from scratch now, the API should
> be to return an error when trying to set KVM_REG_ARM_TIMER_CNT after th=
e
> VM has run once, but it's too late for that as we would break userspace=
=2E
> The best alternative IMHO would be to merge Marc's patch and fix CNTVOF=
F
> in the kernel side as well, and finally also fix QEMU so that it doesn'=
t
> try to do the thing that future kernels will ignore.

Fixing QEMU to only write on KVM_PUT_FULL_STATE - yes, that should be
done, but I don't think the approach for the kernel is generally right.
The kernel should not do any policing on user space requests to change
the VCPU or VM state unless

 - security is affected
 - userspace lacks information, thus cannot decide correctly
 - legacy userspace has a bug, we can detect it and want to fix that up
   without affecting future userspace that has a reason to do it
   differently

Regarding CNTVOFF, the first two criteria do not apply for sure. Maybe
the last one, don't know. Just think of the hypothetical scenario that a
userspace VM debugger wants to inject certain register manipulations. If
you block this by some hidden VM state like proposed, that feature would
no longer be implementable easily.

Jan



--AvASsLauLRO4I1d4ccMmM8aSrVO0pJBV6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlWeT6cACgkQitSsb3rl5xScGQCeN/w7iD4Cg4HZ7piUimHcu9Ko
vEsAnR4enQggSuqXpzF+Mt5CPuppYekK
=wnda
-----END PGP SIGNATURE-----

--AvASsLauLRO4I1d4ccMmM8aSrVO0pJBV6--

--===============3608922020970071924==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3608922020970071924==--
