From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3:
 add an IPI test
Date: Thu, 10 Nov 2016 21:37:13 +0100
Message-ID: <20161110203713.4idzgs5u2xm7ms4o@hawk.localdomain>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-11-git-send-email-drjones@redhat.com>
 <874m3f8621.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F57240419
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 15:36:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sD7Vs8YzJcY4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 15:36:57 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4E2740354
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 15:36:57 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <874m3f8621.fsf@linaro.org>
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

On Thu, Nov 10, 2016 at 07:53:58PM +0000, Alex Benn=E9e wrote:
[...]
> > +struct gic gicv2 =3D {
> > +	.ipi =3D {
> > +		.enable =3D gicv2_enable_defaults,
> > +		.send_self =3D gicv2_ipi_send_self,
> > +		.send_tlist =3D gicv2_ipi_send_tlist,
> > +		.send_broadcast =3D gicv2_ipi_send_broadcast,
> > +	},
> > +	.read_iar =3D gicv2_read_iar,
> > +	.irqnr =3D gicv2_irqnr,
> > +	.write_eoi =3D gicv2_write_eoi,
> > +};
> > +
> > +struct gic gicv3 =3D {
> > +	.ipi =3D {
> > +		.enable =3D gicv3_enable_defaults,
> > +		.send_self =3D gicv3_ipi_send_self,
> > +		.send_tlist =3D gicv3_ipi_send_tlist,
> > +		.send_broadcast =3D gicv3_ipi_send_broadcast,
> > +	},
> > +	.read_iar =3D gicv3_read_iar,
> > +	.irqnr =3D gicv3_irqnr,
> > +	.write_eoi =3D gicv3_write_eoir,
> > +};
> > +
> =

> So I was re-basing my kvm-unit-tests against your GIC rework and found
> myself copy and pasting a bunch of this into my tests that fire IRQs.
> That makes me think the abstraction should be in the library code so
> other tests can fiddle with sending IRQs.
> =

> What do you think?
>

I guess you mean moving the above two structs and their corresponding
functions (all which aren't already common) to lib/arm/ ? Or do you
just mean the one non-trivial function gicv3_ipi_send_tlist? I think
agree with gicv3_ipi_send_tlist getting shared, but the others are
mostly one-liners, so I'm not sure. I guess I'd have to see how you're
using them first.

Thanks,
drew
