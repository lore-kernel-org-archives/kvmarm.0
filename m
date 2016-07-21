From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2] arm64: KVM: VHE: Context switch MDSCR_EL1
Date: Thu, 21 Jul 2016 15:49:38 +0200
Message-ID: <20160721134937.GA4603@potion>
References: <1468933014-26966-1-git-send-email-marc.zyngier@arm.com>
 <20160721131720.GA32739@potion>
 <20160721142451.2ee990ce@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160721142451.2ee990ce@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-21 14:24+0100, Marc Zyngier:
> On Thu, 21 Jul 2016 15:17:20 +0200
> Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com> wrote:
>=20
> Hi Radim,
>=20
>> 2016-07-19 13:56+0100, Marc Zyngier:
>> > The kprobe enablement work has uncovered that changes made by
>> > a guest to MDSCR_EL1 were propagated to the host when VHE was
>> > enabled, leading to unexpected exception being delivered.
>> >=20
>> > Moving this register to the list of registers that are always
>> > context-switched fixes the issue.
>> >=20
>> > Fixes: 9c6c35683286 ("arm64: KVM: VHE: Split save/restore of regis=
ters shared between guest and host")
>> > Cc: stable@vger.kernel.org #4.6
>> > Reported-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.c=
om>
>> > Tested-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com=
>
>> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> > --- =20
>>=20
>> I would take this patch to 4.7 directly through the main tree.
>> Are your plans different?
>=20
> If you're happy to take it now, that works for me.

The fix is clear, tested, and would go to 4.7.stable.  Better to have i=
t
in 4.7, IMO.

>                                                    I can either send =
a
> PR right away, or you can apply it directly, whichever works best for
> you.

It is just one patch so I'll apply it and send a pull request to Linus
on Saturday;  less cummulative work that way. :)
