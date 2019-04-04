From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 09/27] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Thu, 4 Apr 2019 08:53:19 +0100
Message-ID: <20190404075317.GW3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-10-git-send-email-Dave.Martin@arm.com>
 <20190403191413.5s6o4jruuijrdtgg@kamzik.brq.redhat.com>
 <86k1ga4fy3.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D054A409
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 03:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J63D56ucG4-X for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 03:53:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3174A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 03:53:24 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <86k1ga4fy3.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 04:17:24AM +0100, Marc Zyngier wrote:
> On Wed, 03 Apr 2019 20:14:13 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > =

> > On Fri, Mar 29, 2019 at 01:00:34PM +0000, Dave Martin wrote:
> > > Since SVE will be enabled or disabled on a per-vcpu basis, a flag
> > > is needed in order to track which vcpus have it enabled.
> > > =

> > > This patch adds a suitable flag and a helper for checking it.
> > > =

> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > =

> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> > > index 6d10100..ad4f7f0 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -328,6 +328,10 @@ struct kvm_vcpu_arch {
> > >  #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
> > >  #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SV=
E */
> > >  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> > > +#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> > > +
> > > +#define vcpu_has_sve(vcpu) (system_supports_sve() && \
> > > +			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> > =

> > We shouldn't need the system_supports_sve() here. vcpu->arch.flags can
> > only have the KVM_ARM64_GUEST_HAS_SVE flag set when system_supports_sve=
()
> > is true, and it can't change later.
> =

> This is a performance optimisation. system_supports_sve() results in a
> static key being emitted, and that avoids a number of loads on the
> fast path for non-SVE systems (which is likely to be the absolute
> majority for the foreseeable future).

Exactly so.  The same applies to many of the other call sites for
system_supports_sve().

Cheers
---Dave
