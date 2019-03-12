From: Gong John <johngong0791@gmail.com>
Subject: Re: [PATCH] KVM: arm64: fix potential bug
Date: Tue, 12 Mar 2019 11:15:14 +0800
Message-ID: <CAEg8mkxRj2jQSqnuqY239yDH3a4mkvabg+_6Q8+9Nd=mk+U2pw@mail.gmail.com>
References: <20190312003243.6712-1-johngong0791@gmail.com> <2405014d-9370-c0d5-7a44-7ec336098c45@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2405014d-9370-c0d5-7a44-7ec336098c45@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc: christoffer.dall@arm.com, Shengmin Gong <shengmin.gong@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, Julien Thierry <julien.thierry@arm.com>, Jia He <hejianet@gmail.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On Tue, Mar 12, 2019 at 9:44 AM Andr=C3=A9 Przywara <andre.przywara@arm.com=
> wrote:
>
> On 12/03/2019 00:32, John Gong wrote:
> Hi,
>
> > Since intid always >=3D VGIC_NR_PRIVATE_IRQS,
>
> How so? The PMU and the arch timer emulation use PPIs, so intid is
> definitely < VGIC_NR_PRIVATE_IRQS there.
>
> > so then even vcpu =3D=3D NULL, it never return -EINVAL.
>
> I am not sure I follow.
> To uniquely identify an SPI interrupt, we just need the interrupt ID
> (which is always >=3D 32). For PPIs and SGIs, we additionally need the
> vCPU ID this private interrupt belongs to, as there are multiple
> interrupts with the same INTID (one per VCPU).
> The VCPU ID passed in for SPIs is just a dummy value (because we use the
> same function to inject private and shared interrupts), so we don't need
> to check for its validity.
>
> Cheers,
> Andre.
>
Thanks for your explanation. It's my fault to not consider the PPIs
and SGIs injection.
Sorry for polluting the mail list.

Cheers,
John Gong
> >
> > Signed-off-by: Shengmin Gong <shengmin.gong@gmail.com>
> > Signed-off-by: John Gong <johngong0791@gmail.com>
> > ---
> >  virt/kvm/arm/vgic/vgic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index abd9c7352677..d3cb1ce880e2 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -424,7 +424,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid,=
 unsigned int intid,
> >               return ret;
> >
> >       vcpu =3D kvm_get_vcpu(kvm, cpuid);
> > -     if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
> > +     if (!vcpu)
> >               return -EINVAL;
> >
> >       irq =3D vgic_get_irq(kvm, vcpu, intid);
> >
>
