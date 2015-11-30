From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 04/21] arm64: KVM: Implement vgic-v3 save/restore
Date: Mon, 30 Nov 2015 10:43:40 +0000
Message-ID: <20151130104340.4157d11e@why.wild-wind.fr.eu.org>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
	<1448650215-15218-5-git-send-email-marc.zyngier@arm.com>
	<87egf7byez.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87egf7byez.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 30 Nov 2015 09:59:32 +0000
Alex Benn=C3=A9e <alex.bennee@linaro.org> wrote:

>=20
> Marc Zyngier <marc.zyngier@arm.com> writes:
>=20
> > Implement the vgic-v3 save restore as a direct translation of
> > the assembly code version.
> >
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/Makefile     |   1 +
> >  arch/arm64/kvm/hyp/hyp.h        |   3 +
> >  arch/arm64/kvm/hyp/vgic-v3-sr.c | 222 ++++++++++++++++++++++++++++=
++++++++++++
> >  3 files changed, 226 insertions(+)
> >  create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
> >
> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makef=
ile
> > index d8d5968..d1e38ce 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -3,3 +3,4 @@
> >  #
> >
> >  obj-$(CONFIG_KVM_ARM_HOST) +=3D vgic-v2-sr.o
> > +obj-$(CONFIG_KVM_ARM_HOST) +=3D vgic-v3-sr.o
> > diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> > index 78f25c4..a31cb6e 100644
> > --- a/arch/arm64/kvm/hyp/hyp.h
> > +++ b/arch/arm64/kvm/hyp/hyp.h
> > @@ -30,5 +30,8 @@
> >  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
> >  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
> >
> > +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
> > +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> > +
> >  #endif /* __ARM64_KVM_HYP_H__ */
> >
> > diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/v=
gic-v3-sr.c
> > new file mode 100644
> > index 0000000..b490db5
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > @@ -0,0 +1,222 @@
> > +/*
> > + * Copyright (C) 2012-2015 - ARM Ltd
> > + * Author: Marc Zyngier <marc.zyngier@arm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or m=
odify
> > + * it under the terms of the GNU General Public License version 2 =
as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public Licen=
se
> > + * along with this program.  If not, see <http://www.gnu.org/licen=
ses/>.
> > + */
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/irqchip/arm-gic-v3.h>
>=20
> This include starts spitting out compiler warnings due to use of
> undefined barrier primitives. I'm not sure where the best place to:
>=20
>  #include <asm/barrier.h>
>=20
> is. I added it to:
>=20
>   arch/arm64/include/asm/arch_gicv3.h

I already have a couple of fixes queued to that effect in my tree,
hopefully heading for 4.4-rc4. If you pull the branch I have on korg,
you'll get the whole thing that should compile without warning.

Thanks,

	M.
--=20
Without deviation from the norm, progress is not possible.
