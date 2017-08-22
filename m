From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 09/27] arm64/sve: Signal frame and context structure
 definition
Date: Tue, 22 Aug 2017 15:21:36 +0100
Message-ID: <20170822142135.GU6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-10-git-send-email-Dave.Martin@arm.com>
 <87y3qb52ez.fsf@linaro.org>
 <20170822111705.GT6321@e103592.cambridge.arm.com>
 <87tw0z4sk2.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F13449C2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 10:19:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TJnXysofyD5Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Aug 2017 10:19:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2087949C19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 10:19:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87tw0z4sk2.fsf@linaro.org>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, gdb@sourceware.org, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 22, 2017 at 02:53:49PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > On Tue, Aug 22, 2017 at 11:22:44AM +0100, Alex Benn=E9e wrote:
> >>
> >> Dave Martin <Dave.Martin@arm.com> writes:

[...]

> >> > +/*
> >> > + * The SVE architecture leaves space for future expansion of the
> >> > + * vector length beyond its initial architectural limit of 2048 bits
> >> > + * (16 quadwords).
> >> > + */
> >> > +#define SVE_VQ_MIN		1
> >> > +#define SVE_VQ_MAX		0x200
> >> > +
> >> > +#define SVE_VL_MIN		(SVE_VQ_MIN * 0x10)
> >> > +#define SVE_VL_MAX		(SVE_VQ_MAX * 0x10)
> >> > +
> >> > +#define SVE_NUM_ZREGS		32
> >> > +#define SVE_NUM_PREGS		16
> >> > +
> >> > +#define sve_vl_valid(vl) \
> >> > +	((vl) % 0x10 =3D=3D 0 && (vl) >=3D SVE_VL_MIN && (vl) <=3D SVE_VL_=
MAX)
> >> > +#define sve_vq_from_vl(vl)	((vl) / 0x10)
> >> > +#define sve_vl_from_vq(vq)	((vq) * 0x10)
> >>
> >> I got a little confused first time through over what VQ and VL where.
> >> Maybe it would make sense to expand a little more from first principle=
s?
> >>
> >>   /*
> >>    * The SVE architecture defines vector registers as a multiple of 128
> >>    * bit quadwords. The current architectural limit is 2048 bits (16
> >>    * quadwords) but there is room for future expansion beyond that.
> >>     */
> >
> > This comes up in several places and so I didn't want to comment it
> > repeatedly everywhere.
> >
> > Instead, I wrote up something in section 2 (Vector length terminology)
> > of Documentation/arm64/sve.txt -- see patch 25.  Can you take a look and
> > see whether that's adequate?
> =

> Ahh, I hadn't got to that yet. I'm unsure to the order the kernel likes
> to put things but I like to put design documents at the front of the

I don't have a strong opinion on that -- I had preferred not to add a
document describing stuff that doesn't exist at the time of commit.
I could commit a stub document at the start of the series, and then
commit the real document later.

Either way, it seemed overkill.

Perhaps I should have drawn more attention to the documentation in the
cover letter, and encouraged reviewers to look at it first.  My
experience is that people don't often read cover letters...

Now the series is posted, I'm minded to keep the order as-is, unless you
think it's a big issue.

Adding a reference to the document seems a reasonable thing to do,
so I could add that.

> patch queue as they are useful primers and saves you having to patch a:
> =

> modified   arch/arm64/include/uapi/asm/sigcontext.h
> @@ -132,19 +132,24 @@ struct sve_context {
>  /*
>   * The SVE architecture leaves space for future expansion of the
>   * vector length beyond its initial architectural limit of 2048 bits
> - * (16 quadwords).
> + * (16 quadwords). See Documentation/arm64/sve.txt for a summary of
> + * the terminology of Vector Quads (VQ) and Vector Lengths (VL).
>   */
> +
> +#define SVE_VQ_BITS             128      /* 128 bits in one quadword */
> +#define SVE_VQ_BYTES            (SVE_VQ_BITS / 8)
> +

I was trying to keep extraneous #defines to a minimum, since this is a
uapi header, and people may depend on anything defined here.

I think SVE_VQ_BYTES is reasonable to have, and this allows us to
rewrite a few hard-coded 0x10s and 16s symbolically which is probably a
good idea -- I'll add this.

SVE_VQ_BITS looks redundant to me though.  It wouldn't be used for any
purpose other than defining SVE_VQ_BYTES.

>  #define SVE_VQ_MIN		1
>  #define SVE_VQ_MAX		0x200
> =

> -#define SVE_VL_MIN		(SVE_VQ_MIN * 0x10)
> -#define SVE_VL_MAX		(SVE_VQ_MAX * 0x10)
> +#define SVE_VL_MIN		(SVE_VQ_MIN * SVE_VQ_BYTES)
> +#define SVE_VL_MAX		(SVE_VQ_MAX * SVE_VQ_BYTES)
> =

>  #define SVE_NUM_ZREGS		32
>  #define SVE_NUM_PREGS		16
> =

>  #define sve_vl_valid(vl) \
> -	((vl) % 0x10 =3D=3D 0 && (vl) >=3D SVE_VL_MIN && (vl) <=3D SVE_VL_MAX)
> +	((vl) % SVE_VQ_BYTES =3D=3D 0 && (vl) >=3D SVE_VL_MIN && (vl) <=3D SVE_=
VL_MAX)
>  #define sve_vq_from_vl(vl)	((vl) / 0x10)
>  #define sve_vl_from_vq(vq)	((vq) * 0x10)

[...]

Cheers
---Dave
