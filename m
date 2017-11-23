From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 3/4] arm64/sve: KVM: Ensure user SVE use traps after
 vcpu execution
Date: Thu, 23 Nov 2017 14:34:04 +0000
Message-ID: <20171123143403.GK22781@e103592.cambridge.arm.com>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
 <1510936735-6762-4-git-send-email-Dave.Martin@arm.com>
 <20171122192344.GS28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B65D49D6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 09:31:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zbRjWgD8-YXh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Nov 2017 09:31:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C5749D26
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 09:31:29 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171122192344.GS28855@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 22, 2017 at 08:23:44PM +0100, Christoffer Dall wrote:
> On Fri, Nov 17, 2017 at 04:38:54PM +0000, Dave Martin wrote:
> > Currently, SVE use can remain untrapped if a KVM vcpu thread is
> > preempted inside the kernel and we then switch back to some user
> > thread.
> > 
> > This patch ensures that SVE traps for userspace are enabled before
> > switching away from the vcpu thread.
> 
> I don't really understand why KVM is any different then any other thread
> which could be using SVE that gets preempted?

The state of CPACR_EL1.ZEN is part of the per-task SVE state in the host,
and needs to be context switched.  This is different from CPACR_EL1.FEN
which is always 0b11 in the host.  KVM currently is unaware of the
context handling on flow in the host though, and corrupts the ZEN field
rather than saving/restoring it.

We could truly save/restore ZEN, but this feels like a misstep: firstly
this only applies to the VHE case so will be a bit ugly, and secondly
I expect context handling cleanup that makes KVM aware of the host
FPSIMD/SVE handling flow will make such save/restore unnecessary, in
any case, the affected ZEN bit is already recorded as the TIF_SVE flag,
so saving it is redundant.

> > In an attempt to preserve some clarity about why and when this is
> > needed, kvm_fpsimd_flush_cpu_state() is used as a hook for doing
> > this.  This means that this function needs to be called after
> > exiting the vcpu instead of before entry: 
> 
> I don't understand why the former means the latter?

I preferred to keep sve_flush_cpu_state() as the "invalidate any SVE
context cached in the CPU" notification, but if we handle CPACR here
then we need to do this after running the vcpu -- because the hyp
switch code will corrupt the trap state anyway in the VHE case, as a
side effect of disabling traps on vcpu exit.

Alternatively, the hyp trap disable code could be changed to actually
_enable_ SVE traps in the VHE case, but I thought this was both
confusing and tends to hide the real rationale.

> 
> > this patch moves the call
> > as appropriate.  As a side-effect, this will avoid the call if vcpu
> > entry is shortcircuited by a signal etc.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kernel/fpsimd.c | 2 ++
> >  virt/kvm/arm/arm.c         | 6 +++---
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 3dc8058..3b135eb 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -1083,6 +1083,8 @@ void sve_flush_cpu_state(void)
> >  
> >  	if (last->st && last->sve_in_use)
> >  		fpsimd_flush_cpu_state();
> > +
> > +	sve_user_disable();
> >  }
> >  #endif /* CONFIG_ARM64_SVE */
> >  
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 772bf74..554b157 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -651,9 +651,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		 */
> >  		preempt_disable();
> >  
> > -		/* Flush FP/SIMD state that can't survive guest entry/exit */
> > -		kvm_fpsimd_flush_cpu_state();
> > -
> >  		kvm_pmu_flush_hwstate(vcpu);
> >  
> >  		local_irq_disable();
> > @@ -754,6 +751,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		guest_exit();
> >  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> >  
> > +		/* Flush FP/SIMD state that can't survive guest entry/exit */
> > +		kvm_fpsimd_flush_cpu_state();
> > +
> 
> Could this be done in kvm_arch_vcpu_put() instead?

I think so -- I didn't want to take the VHE optimisation series into
account yet so I wasn't tracking a moving target, but I think this would
fit naturally there.


All of this is fairly confusing, so if there is a way to make it
clearer, I'd be happy to pick it up...

Cheers
---Dave
