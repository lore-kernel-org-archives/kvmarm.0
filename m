From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 01/10] lib: xstr: allow multiple args
Date: Mon, 6 Jun 2016 14:12:39 +0200
Message-ID: <20160606121239.paubfta2c74epgfk@hawk.localdomain>
References: <1465064165-14885-2-git-send-email-drjones@redhat.com>
 <87d1nuiod6.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d1nuiod6.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 06, 2016 at 11:49:09AM +0100, Alex Benn=E9e wrote:
>=20
> Andrew Jones <drjones@redhat.com> writes:
>=20
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  lib/libcflat.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/libcflat.h b/lib/libcflat.h
> > index 582e3fc60e287..e5e588c742763 100644
> > --- a/lib/libcflat.h
> > +++ b/lib/libcflat.h
> > @@ -27,8 +27,8 @@
> >
> >  #define __unused __attribute__((__unused__))
> >
> > -#define xstr(s) xxstr(s)
> > -#define xxstr(s) #s
> > +#define xstr(s...) xxstr(s)
> > +#define xxstr(s...) #s
>=20
> OK my knowledge of stringinfication is still rusty despite having rea=
d
> the QEMU softmmu code. However:
>=20
>                 printf("Unknown subtest:" xstr(foo,ba) "\n");
>=20
> Yields:
>=20
>                 Unknown subtestfoo,ba
>=20
> Is that what you wanted? Or were you aiming for xstr(foo,ba) =3D> foo=
ba

The way I did it (which is like Linux) is what I wanted, see Linux's
version in include/linux/stringify.h. I can correct $SUBJECT to make
that more clear if you like.

Thanks,
drew



>=20
> As an aside I couldn't actually see xstr being called with multiple
> arguments in the source tree.
>=20
> >
> >  #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> >  #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
>=20
>=20
> --
> Alex Benn=E9e
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
