From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: VHE: Context switch MDSCR_EL1
Date: Thu, 21 Jul 2016 14:24:51 +0100
Message-ID: <20160721142451.2ee990ce@arm.com>
References: <1468933014-26966-1-git-send-email-marc.zyngier@arm.com>
	<20160721131720.GA32739@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160721131720.GA32739@potion>
Sender: kvm-owner@vger.kernel.org
To: Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 21 Jul 2016 15:17:20 +0200
Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com> wrote:

Hi Radim,

> 2016-07-19 13:56+0100, Marc Zyngier:
> > The kprobe enablement work has uncovered that changes made by
> > a guest to MDSCR_EL1 were propagated to the host when VHE was
> > enabled, leading to unexpected exception being delivered.
> >=20
> > Moving this register to the list of registers that are always
> > context-switched fixes the issue.
> >=20
> > Fixes: 9c6c35683286 ("arm64: KVM: VHE: Split save/restore of regist=
ers shared between guest and host")
> > Cc: stable@vger.kernel.org #4.6
> > Reported-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.co=
m>
> > Tested-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > --- =20
>=20
> I would take this patch to 4.7 directly through the main tree.
> Are your plans different?

If you're happy to take it now, that works for me. I can either send a
PR right away, or you can apply it directly, whichever works best for
you.

Thanks,

	M.
--=20
Jazz is not dead. It just smells funny.
