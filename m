From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v1 2/2] kvm: arm64: handle single-step of userspace mmio
 instructions
Date: Fri, 13 Oct 2017 10:59:47 +0200
Message-ID: <20171013085947.GE8927@cbox>
References: <20171006113921.24880-1-alex.bennee@linaro.org>
 <20171006113921.24880-3-alex.bennee@linaro.org>
 <a9f8905e-18e9-267a-2479-f498c248e2f4@arm.com>
 <878tgoxudc.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC75349D24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 04:58:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id op4BYWaBGCLZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 04:58:55 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6257D40D25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 04:58:55 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id u138so19510747wmu.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 01:59:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <878tgoxudc.fsf@linaro.org>
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
Cc: kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 02:45:35PM +0100, Alex Benn=E9e wrote:
> =

> Julien Thierry <julien.thierry@arm.com> writes:
> =

> > On 06/10/17 12:39, Alex Benn=E9e wrote:
> >> The system state of KVM when using userspace emulation is not complete
> >> until we return into KVM_RUN. To handle mmio related updates we wait
> >> until they have been committed and then schedule our KVM_EXIT_DEBUG.
> >>
> >> I've introduced a new function kvm_arm_maybe_return_debug() to wrap up
> >> the differences between arm/arm64 which is currently null for arm.
> >>
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >> ---
> >>   arch/arm/include/asm/kvm_host.h   |  2 ++
> >>   arch/arm64/include/asm/kvm_host.h |  1 +
> >>   arch/arm64/kvm/debug.c            | 21 +++++++++++++++++++++
> >>   arch/arm64/kvm/handle_exit.c      |  9 +++------
> >>   virt/kvm/arm/arm.c                |  2 +-
> >>   virt/kvm/arm/mmio.c               |  3 ++-
> >>   6 files changed, 30 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kv=
m_host.h
> >> index 4a879f6ff13b..aec943f6d123 100644
> >> --- a/arch/arm/include/asm/kvm_host.h
> >> +++ b/arch/arm/include/asm/kvm_host.h
> >> @@ -285,6 +285,8 @@ static inline void kvm_arm_init_debug(void) {}
> >>   static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> >>   static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> >>   static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> >> +static inline int  kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu,
> >> +						struct kvm_run *run) {}
> >>
> >
> > This function should return 1.
> =

> So I did ponder making this a bool, returning true if we need to exit
> and testing in v/k/a/arm.c exit leg rather than in the mmio handler.
> =

> At the moment it mirrors the existing exit logic which follows -1 err, 0
> return, >0 handled. But as I mentioned in the cover letter this fell
> down a bit when dealing with the mmio case.
> =

> >
> >>   int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >>   			       struct kvm_device_attr *attr);
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/as=
m/kvm_host.h
> >> index e923b58606e2..fa67d21662f6 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -369,6 +369,7 @@ void kvm_arm_init_debug(void);
> >>   void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >>   void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >>   void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> >> +int  kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu, struct kvm_run=
 *run);
> >
> > I feel the name could be a little bit more explicit:
> >
> > kvm_arm_trap_need_step_debug, kvm_arm_trap_step_return_debug,
> > kvm_arm_trap_need_return_debug.
> =

> I wanted to keep the debug suffix so that's fine although I'm not so
> sure trap is correct because on the tail end of mmio emulation are we
> still trapping?
> =

> Maybe kvm_arm_step_emulated_debug?

I think you should name it:

kvm_arm_should_complete_emulated_instr_debug() - or something better -
and call it directly from kvm_arch_vcpu_ioctl_run, so that it becomes:

	ret =3D kvm_handle_mmio_return(vcpu, vcpu->run);
	if (ret)
		return ret;
	ret =3D kvm_arm_should_complete_emulated_instr_debug(vcpu);
	if (ret)
		return ret;

> =

> > At least, I think it would be nice that the name reflect that this
> > check is meant for emulated instructions.
> >
> > Otherwise:
> >
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> >
> > Thanks,
> =

> =

Thanks,
-Christoffer
