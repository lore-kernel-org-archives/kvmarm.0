From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 13/27] KVM: arm64/sve: Context switch the SVE registers
Date: Thu, 25 Apr 2019 14:35:06 +0100
Message-ID: <20190425133505.GD3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-14-git-send-email-Dave.Martin@arm.com>
 <20190403200145.c2oep2hbugl7db5t@kamzik.brq.redhat.com>
 <20190404081008.GY3567@e103592.cambridge.arm.com>
 <20190404083502.b7a345l2gx3df2zk@kamzik.brq.redhat.com>
 <20190404083624.GA3567@e103592.cambridge.arm.com>
 <87d0lbwj63.fsf@zen.linaroharston>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA9B34A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:35:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4LHMK2G9cS+P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:35:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D3224A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:35:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87d0lbwj63.fsf@zen.linaroharston>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 03:51:32PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > On Thu, Apr 04, 2019 at 10:35:02AM +0200, Andrew Jones wrote:
> >> On Thu, Apr 04, 2019 at 09:10:08AM +0100, Dave Martin wrote:
> >> > On Wed, Apr 03, 2019 at 10:01:45PM +0200, Andrew Jones wrote:
> >> > > On Fri, Mar 29, 2019 at 01:00:38PM +0000, Dave Martin wrote:
> >> > > > In order to give each vcpu its own view of the SVE registers, th=
is
> >> > > > patch adds context storage via a new sve_state pointer in struct
> >> > > > vcpu_arch.  An additional member sve_max_vl is also added for ea=
ch
> >> > > > vcpu, to determine the maximum vector length visible to the guest
> >> > > > and thus the value to be configured in ZCR_EL2.LEN while the vcpu
> >> > > > is active.  This also determines the layout and size of the stor=
age
> >> > > > in sve_state, which is read and written by the same backend
> >> > > > functions that are used for context-switching the SVE state for
> >> > > > host tasks.
> >> > > >
> >> > > > On SVE-enabled vcpus, SVE access traps are now handled by switch=
ing
> >> > > > in the vcpu's SVE context and disabling the trap before returning
> >> > > > to the guest.  On other vcpus, the trap is not handled and an ex=
it
> >> > > > back to the host occurs, where the handle_sve() fallback path
> >> > > > reflects an undefined instruction exception back to the guest,
> >> > > > consistently with the behaviour of non-SVE-capable hardware (as =
was
> >> > > > done unconditionally prior to this patch).
> >> > > >
> >> > > > No SVE handling is added on non-VHE-only paths, since VHE is an
> >> > > > architectural and Kconfig prerequisite of SVE.
> >> > > >
> >> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> >> > > > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> >> > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> >> > > >
> >> > > > ---
> >> > > >
> >> > > > Changes since v5:
> >> > > >
> >> > > >  * [Julien Thierry, Julien Grall] Commit message typo fixes
> >> > > >
> >> > > >  * [Mark Rutland] Rename trap_class to hsr_ec, for consistency w=
ith
> >> > > >    existing code.
> >> > > >
> >> > > >  * [Mark Rutland] Simplify condition for refusing to handle an
> >> > > >    FPSIMD/SVE trap, using multiple if () statements for clarity.=
  The
> >> > > >    previous condition was a bit tortuous, and how that the stati=
c_key
> >> > > >    checks have been hoisted out, it makes little difference to t=
he
> >> > > >    compiler how we express the condition here.
> >> > > > ---
> >> > > >  arch/arm64/include/asm/kvm_host.h |  6 ++++
> >> > > >  arch/arm64/kvm/fpsimd.c           |  5 +--
> >> > > >  arch/arm64/kvm/hyp/switch.c       | 75 ++++++++++++++++++++++++=
+++++----------
> >> > > >  3 files changed, 66 insertions(+), 20 deletions(-)
> >> > > >
> >> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/incl=
ude/asm/kvm_host.h
> >> > > > index 22cf484..4fabfd2 100644
> >> > > > --- a/arch/arm64/include/asm/kvm_host.h
> >> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> >> > > > @@ -228,6 +228,8 @@ struct vcpu_reset_state {
> >> > > >
> >> > > >  struct kvm_vcpu_arch {
> >> > > >  	struct kvm_cpu_context ctxt;
> >> > > > +	void *sve_state;
> >> > > > +	unsigned int sve_max_vl;
> >> > > >
> >> > > >  	/* HYP configuration */
> >> > > >  	u64 hcr_el2;
> >> > > > @@ -323,6 +325,10 @@ struct kvm_vcpu_arch {
> >> > > >  	bool sysregs_loaded_on_cpu;
> >> > > >  };
> >> > > >
> >> > > > +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> >> > > > +#define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve=
_state) + \
> >> > > > +				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> >> > >
> >> > > Maybe an inline function instead?
> >> >
> >> > I tried, but that requires the definition of struct kvm_vcpu to be
> >> > visible.  I failed to get that here without circular #include proble=
ms,
> >> > and it looked tricky to fix.
> >>
> >> Ah, OK
> >>
> >> >
> >> > Since this is a small bit of code which is unlikely to get used by
> >> > accident, I decided it was OK to keep it as a macro.
> >> >
> >> > Can you see another way around this?
> >>
> >> Nope
> >
> > OK.  If someone eventually solves this, I'd be happy to change to an
> > inline function.
> =

> Is the function intended to be used by more call sites? Currently in the
> tree with this plus the v2 fixups I can only see:
> =

>   arch/arm64/include/asm/kvm_host.h:333:#define vcpu_sve_pffr(vcpu) ((voi=
d *)((char *)((vcpu)->arch.sve_state) + \
>   arch/arm64/kvm/hyp/switch.c:388:		sve_load_state(vcpu_sve_pffr(vcpu),

Probably not, although it was probably used to save the state back
before things were refactored so that fpsimd_save() in
arch/arm64/kernel/fpsimd.c is used instead of separate code to save the
vcpu state.

The expression is ugly so it's nice to abstract it.  This also keeps
the sve_load_state() call feeling consistent to the equivalent call in
task_fpsimd_load() in arm64/kernel/fpsimd.c

Other than that, there's no underlying reason for having a macro.

Cheers
---Dave
