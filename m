From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 20/27] arm64/sve: In-kernel vector length availability
 query interface
Date: Fri, 5 Apr 2019 12:13:42 +0100
Message-ID: <20190405111342.GY3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-21-git-send-email-Dave.Martin@arm.com>
 <20190404142034.ikkn7lkgbnntsziq@kamzik.brq.redhat.com>
 <20190405093555.GL3567@e103592.cambridge.arm.com>
 <20190405095407.nu22vu5ycbfnts3t@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190405095407.nu22vu5ycbfnts3t@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 11:54:07AM +0200, Andrew Jones wrote:
> On Fri, Apr 05, 2019 at 10:35:55AM +0100, Dave Martin wrote:
> > On Thu, Apr 04, 2019 at 04:20:34PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:45PM +0000, Dave Martin wrote:
> > > > KVM will need to interrogate the set of SVE vector lengths
> > > > available on the system.
> > > > =

> > > > This patch exposes the relevant bits to the kernel, along with a
> > > > sve_vq_available() helper to check whether a particular vector
> > > > length is supported.
> > > > =

> > > > __vq_to_bit() and __bit_to_vq() are not intended for use outside
> > > > these functions: now that these are exposed outside fpsimd.c, they
> > > > are prefixed with __ in order to provide an extra hint that they
> > > > are not intended for general-purpose use.
> > > > =

> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > > > ---
> > > >  arch/arm64/include/asm/fpsimd.h | 29 +++++++++++++++++++++++++++++
> > > >  arch/arm64/kernel/fpsimd.c      | 35 ++++++++---------------------=
------
> > > >  2 files changed, 37 insertions(+), 27 deletions(-)
> > > > =

> > > > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/a=
sm/fpsimd.h

[...]

> > > > +/* Set of available vector lengths, as vq_to_bit(vq): */
> > > =

> > > s/as/for use with/ ?
> > =

> > Not exactly.  Does the following work for you:
> > =

> > /*
> >  * Set of available vector lengths
> >  * Vector length vq is encoded as bit __vq_to_bit(vq):
> >  */
> =

> Yes. That reads much better.

OK

> > > s/vq_to_bit/__vq_to_bit/
> > =

> > Ack: that got renamed when I moved it to fpsimd.h, bit I clearly didn't
> > update the comment as I pasted it across.
> > =

> > > =

> > > > +extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
> > > > +
> > > > +/*
> > > > + * Helpers to translate bit indices in sve_vq_map to VQ values (and
> > > > + * vice versa).  This allows find_next_bit() to be used to find the
> > > > + * _maximum_ VQ not exceeding a certain value.
> > > > + */
> > > > +static inline unsigned int __vq_to_bit(unsigned int vq)
> > > > +{
> > > =

> > > Why not have the same WARN_ON and clamping here as we do
> > > in __bit_to_vq. Here a vq > SVE_VQ_MAX will wrap around
> > > to a super high bit.
> > > =

> > > > +	return SVE_VQ_MAX - vq;
> > > > +}
> > > > +
> > > > +static inline unsigned int __bit_to_vq(unsigned int bit)
> > > > +{
> > > > +	if (WARN_ON(bit >=3D SVE_VQ_MAX))
> > > > +		bit =3D SVE_VQ_MAX - 1;
> > > > +
> > > > +	return SVE_VQ_MAX - bit;
> > > > +}
> > > > +
> > > > +/* Ensure vq >=3D SVE_VQ_MIN && vq <=3D SVE_VQ_MAX before calling =
this function */
> > > =

> > > Are we avoiding putting these tests and WARN_ONs in this function to
> > > keep it fast?
> > =

> > These are intended as backend for use only by fpsimd.c and this header,
> > so peppering them with WARN_ON() felt excessive.  I don't expect a lot
> > of new calls to these (or any, probably).
> > =

> > I don't recall why I kept the WARN_ON() just in __bit_to_vq(), except
> > that the way that gets called is a bit more complex in some places.
> > =

> > Are you happy to replace these with comments?  e.g.:
> > =

> > /* Only valid when vq >=3D SVE_VQ_MIN && vq <=3D SVE_VQ_MAX */
> > __vq_to_bit()
> > =

> > /* Only valid when bit < SVE_VQ_MAX */
> > __bit_to_vq()
> > =

> > =

> > OTOH, these are not used on fast paths, so maybe having both as
> > WARN_ON() would be better.  Part of the problem is knowing what to clamp
> > to: these are generally used in conjunction with looping or bitmap find
> > operations, so the caller may be making assumptions about the return
> > value that may wrong when the value is clamped.
> > =

> > Alternatively, these could be BUG() -- but that seems heavy.
> > =

> > What do you think?
> =

> I like the idea of having WARN_ON's to enforce the constraints. I
> wouldn't be completely opposed to not having anything other than
> the comments, though, as there is a limit to how defensive we should
> be. I'll abstain from this vote.

I'll have a think about whether there's anything non-toxic that we can
return in the error cases.  If not, I may demote these to comments:
returning an actual error code for this sort of things feels like a
step too far.

Otherwise we can have WARNs.

Cheers
---Dave
