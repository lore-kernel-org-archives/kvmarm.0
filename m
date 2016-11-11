From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3:
 add an IPI test
Date: Fri, 11 Nov 2016 14:54:21 +0100
Message-ID: <20161111135421.5oxdkfqynkgipgom@hawk.localdomain>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-11-git-send-email-drjones@redhat.com>
 <874m3f8621.fsf@linaro.org>
 <20161110203713.4idzgs5u2xm7ms4o@hawk.localdomain>
 <871syi8hbg.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12ED8404BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 08:54:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQ5oJJuDINIJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2016 08:54:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 092E04042C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 08:54:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <871syi8hbg.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 11, 2016 at 10:02:59AM +0000, Alex Benn=E9e wrote:
> =

> Andrew Jones <drjones@redhat.com> writes:
> =

> > On Thu, Nov 10, 2016 at 07:53:58PM +0000, Alex Benn=E9e wrote:
> > [...]
> >> > +struct gic gicv2 =3D {
> >> > +	.ipi =3D {
> >> > +		.enable =3D gicv2_enable_defaults,
> >> > +		.send_self =3D gicv2_ipi_send_self,
> >> > +		.send_tlist =3D gicv2_ipi_send_tlist,
> >> > +		.send_broadcast =3D gicv2_ipi_send_broadcast,
> >> > +	},
> >> > +	.read_iar =3D gicv2_read_iar,
> >> > +	.irqnr =3D gicv2_irqnr,
> >> > +	.write_eoi =3D gicv2_write_eoi,
> >> > +};
> >> > +
> >> > +struct gic gicv3 =3D {
> >> > +	.ipi =3D {
> >> > +		.enable =3D gicv3_enable_defaults,
> >> > +		.send_self =3D gicv3_ipi_send_self,
> >> > +		.send_tlist =3D gicv3_ipi_send_tlist,
> >> > +		.send_broadcast =3D gicv3_ipi_send_broadcast,
> >> > +	},
> >> > +	.read_iar =3D gicv3_read_iar,
> >> > +	.irqnr =3D gicv3_irqnr,
> >> > +	.write_eoi =3D gicv3_write_eoir,
> >> > +};
> >> > +
> >>
> >> So I was re-basing my kvm-unit-tests against your GIC rework and found
> >> myself copy and pasting a bunch of this into my tests that fire IRQs.
> >> That makes me think the abstraction should be in the library code so
> >> other tests can fiddle with sending IRQs.
> >>
> >> What do you think?
> >>
> >
> > I guess you mean moving the above two structs and their corresponding
> > functions (all which aren't already common) to lib/arm/ ? Or do you
> > just mean the one non-trivial function gicv3_ipi_send_tlist? I think
> > agree with gicv3_ipi_send_tlist getting shared, but the others are
> > mostly one-liners, so I'm not sure. I guess I'd have to see how you're
> > using them first.
> =

> So it looked like there were some functions in the common code for one
> GIC which had local test defined functions for the other. They should at
> least be consistent.

gicv3_read_iar and gicv3_write_eoir being common already is a product of
being sysreg wrappers, allowing for both arm32 and arm64 to use functions
of the same names, not because I wanted gicv3 to be inconsistent with
gicv2 (which uses MMIO and thus doesn't need wrappers)

> =

> For my use case I could do with a common:
> =

>   gic_enable

OK, I can extend gic_init() to initialize a 'struct gic_common_ops' that
includes an enable -> *_enable_defaults(void), ipi_send(int cpu),
read_iar(void), iar_irqnr(u32 iar), and write_eoi(u32 irqstat). And also
provide the wrappers gic_enable, gic_ipi_send(cpu), ...

>   gic_send_spi(cpu, irq)

I'll let you add this one to the new common ops struct :-)

>   gic_irq_ack() which returns the iar.

This one will be called read_iar.

Would that work for you, Alex?

Andre,

Would this also satisfy your needs for more common code?

Thanks,
drew

> =

> See:
> =

>   https://github.com/stsquad/kvm-unit-tests/blob/mttcg/current-tests-v6/a=
rm/tcg-test.c#L113
> =

> >
> > Thanks,
> > drew
> =

> =

> --
> Alex Benn=E9e
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
