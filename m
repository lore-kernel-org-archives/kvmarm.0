From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Fri, 26 Jun 2015 06:49:34 +0200
Message-ID: <558CD9DE.3010609@web.de>
References: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
 <20150625080457.GD28244@cbox> <558BC2F5.9010303@huawei.com>
 <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
 <558BC90B.4060806@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3165891192140073184=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC3257075
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 00:38:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pcMmlB02p-Bq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2015 00:38:51 -0400 (EDT)
Received: from mout.web.de (mout.web.de [212.227.17.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EB4757063
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 00:38:51 -0400 (EDT)
In-Reply-To: <558BC90B.4060806@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Claudio Fontana <claudio.fontana@huawei.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============3165891192140073184==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Da8MlNVDgHVbb9w4EDdPNlhxaBmlodcUa"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Da8MlNVDgHVbb9w4EDdPNlhxaBmlodcUa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-06-25 11:25, Claudio Fontana wrote:
> On 25.06.2015 11:10, Peter Maydell wrote:
>> On 25 June 2015 at 09:59, Claudio Fontana <claudio.fontana@huawei.com>=
 wrote:
>>> Once the VM is created, I think QEMU should not request kvm to
>>> change the virtual offset of the VM anymore: maybe an unexpected
>>> consequence of QEMU's target-arm/kvm64.c::kvm_arch_put_registers ?
>>
>> Hmm. In general we assume that we can:
>>  * stop the VM
>>  * read all the guest system registers
>>  * write those values back again
>>  * restart the VM
>>
>> if we need to. Is that what's happening here, or are we doing
>> something odder?
>>
>> -- PMM
>>
>=20
> What I guess could be happening by looking at the code in linux
>=20
> virt/kvm/arm/arch_timer.c::kvm_arm_timer_set_reg
>=20
> is that QEMU tries to set the KVM_REG_ARM_TIMER_CNT register from exact=
ly the previous value,
> but just because of the fact that the set function is called, cntvoff i=
s updated,
> since the value provided by the user is apparently assumed to be _relat=
ive_ to the physical timer.
>=20
> This is apparent to me in the code in that function which says:
>=20
> case KVM_REG_ARM_TIMER_CNT: {
> /* ... */
>     u64 cntvoff =3D kvm_phys_timer_read() - value;
> /* ... */
> }
>=20
> And this is matched by the corresponding get function kvm_arm_timer_get=
_reg where it says:
>=20
> case KVM_REG_ARM_TIMER_CNT:
>    return kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
>=20
> The time difference between when the GET is issued by QEMU and when the=
 PUT is issued then would account for the difference.

QEMU has the concept of write-back levels: KVM_PUT_RUNTIME_STATE,
KVM_PUT_RESET_STATE and KVM_PUT_FULL_STATE. I suspect this registers is
just sorted into the wrong category, thus written as part of the
RUNTIME_STATE. We had such bug patterns during the x86 maturing phase as
well.

Jan


--Da8MlNVDgHVbb9w4EDdPNlhxaBmlodcUa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlWM2d4ACgkQitSsb3rl5xSlJwCbBFoArdKM2lJM16nQdrvtqueL
ly4AoMMbn4JWrRuEgwqeeQYA527TgvK/
=LsYZ
-----END PGP SIGNATURE-----

--Da8MlNVDgHVbb9w4EDdPNlhxaBmlodcUa--

--===============3165891192140073184==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3165891192140073184==--
