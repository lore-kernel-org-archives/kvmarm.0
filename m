From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 06/23] arm64/sve: Check SVE virtualisability
Date: Thu, 15 Nov 2018 17:09:04 +0000
Message-ID: <20181115170904.GO3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-7-git-send-email-Dave.Martin@arm.com>
 <87in0ycpuy.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1DE4A342
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 12:09:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SGapsmJM9oKJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 12:09:10 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8C6F4A338
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 12:09:09 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87in0ycpuy.fsf@linaro.org>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 15, 2018 at 03:39:01PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > Due to the way the effective SVE vector length is controlled and
> > trapped at different exception levels, certain mismatches in the
> > sets of vector lengths supported by different physical CPUs in the
> > system may prevent straightforward virtualisation of SVE at parity
> > with the host.
> >
> > This patch analyses the extent to which SVE can be virtualised
> > safely without interfering with migration of vcpus between physical
> > CPUs, and rejects late secondary CPUs that would erode the
> > situation further.
> >
> > It is left up to KVM to decide what to do with this information.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >
> > Changes since RFCv1:
> >
> >  * The analysis done by this patch is the same as in the previous
> >    version, but the commit message the printks etc. have been reworded
> >    to avoid the suggestion that KVM is expected to work on a system with
> >    mismatched SVE implementations.
> > ---
> >  arch/arm64/include/asm/fpsimd.h |  1 +
> >  arch/arm64/kernel/cpufeature.c  |  2 +-
> >  arch/arm64/kernel/fpsimd.c      | 87 +++++++++++++++++++++++++++++++++=
++------
> >  3 files changed, 76 insertions(+), 14 deletions(-)
> >

[...]

> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c

[...]

> > @@ -623,11 +629,8 @@ int sve_get_current_vl(void)

[...]

> > +/* Bitmaps for temporary storage during manipulation of vector length =
sets */
> > +static DECLARE_BITMAP(sve_tmp_vq_map, SVE_VQ_MAX);
> =

> This seems odd as a local global, why not declared locally when used?

Could do.

My original concern was that this is "big" and therefore it's impolite
to allocate it on the stack.

But on reflection, 64 bytes of stack is no big deal for a 64-bit
architecture.  The affected functions probably spill more than than
already, and these functions are called on well-defined paths which
shouldn't have super-deep stacks already.

[...]

> > @@ -658,24 +662,60 @@ void __init sve_init_vq_map(void)
> >   */
> >  void sve_update_vq_map(void)
> >  {
> > -	sve_probe_vqs(sve_secondary_vq_map);
> > -	bitmap_and(sve_vq_map, sve_vq_map, sve_secondary_vq_map, SVE_VQ_MAX);
> > +	sve_probe_vqs(sve_tmp_vq_map);
> > +	bitmap_and(sve_vq_map, sve_vq_map, sve_tmp_vq_map,
> > +		   SVE_VQ_MAX);
> > +	bitmap_or(sve_vq_partial_map, sve_vq_partial_map, sve_tmp_vq_map,
> > +		  SVE_VQ_MAX);
> >  }
> =

> I'm not quite following what's going on here. This is tracking both the
> vector lengths available on all CPUs and the ones available on at least
> one CPU? This raises a some questions:
> =

>   - do such franken-machines exist or are expected to exit?

no, and yes respectively (Linux does not endorse the latter for now,
since it results in a non-SMP system: we hide the asymmetries where
possible by clamping the set of available vector lengths, but for
KVM it's too hard and we don't aim to support it at all).

Even if we don't recommend deploying a general-purpose OS on such a
system, people will eventually try it.  So it's better to fail safe
rather than silently doing the wrong thing.

>   - how do we ensure this is always upto date?

This gets updated for each early secondary CPU that comes up.  (Early
secondaries' boot is serialised, so we shouldn't have to worry about
races here.)

The configuration is frozen by the time we enter userspace (hence
__ro_after_init).

Once all the early secondaries have come up, we commit to the best
possible set of vector lengths for the CPUs that we know about, and we
don't call this path any more: instead, each late secondary goes into
sve_verify_vq_map() instead to check that those CPUs are compatible
with the configuration we committed to.

For context, take a look at
arch/arm64/kernel/cpufeature.c:check_local_cpu_capabilities(), which is
the common entry point for all secondary CPUs: that splits into
update_cpu_capabilities() and verify_local_cpu_capabilities() paths for
the two cases described above, calling down into sve_update_vq_map()
and sve_verify_vq_map() as appropriate.

>   - what happens when we hotplug a new CPU with less available VQ?

We reject the CPU and throw it back to the firmware (see
cpufeature.c:verify_sve_features()).

This follows the precedent already set in verify_local_cpu_capabilities()
etc.

> =

> >
> >  /* Check whether the current CPU supports all VQs in the committed set=
 */
> >  int sve_verify_vq_map(void)
> >  {
> > -	int ret =3D 0;
> > +	int ret =3D -EINVAL;
> > +	unsigned long b;
> >
> > -	sve_probe_vqs(sve_secondary_vq_map);
> > -	bitmap_andnot(sve_secondary_vq_map, sve_vq_map, sve_secondary_vq_map,
> > -		      SVE_VQ_MAX);
> > -	if (!bitmap_empty(sve_secondary_vq_map, SVE_VQ_MAX)) {
> > +	sve_probe_vqs(sve_tmp_vq_map);
> > +
> > +	bitmap_complement(sve_tmp_vq_map, sve_tmp_vq_map, SVE_VQ_MAX);
> > +	if (bitmap_intersects(sve_tmp_vq_map, sve_vq_map, SVE_VQ_MAX)) {
> >  		pr_warn("SVE: cpu%d: Required vector length(s) missing\n",
> >  			smp_processor_id());
> > -		ret =3D -EINVAL;
> > +		goto error;
> =

> The use of goto seems a little premature considering we don't have any
> clean-up to do.

Hmm, this does look a little overengineered.  I think it may have been
more complex during development (making the gotos less redundant), but
to be honest I don't remember now.

I'm happy to get rid of the rather pointless ret variable and replace
all the gotos with returns if that works for you.

What do you think?

[...]

Cheers
---Dave
