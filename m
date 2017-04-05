From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: arm/arm64: fix race in kvm_psci_vcpu_on
Date: Wed, 5 Apr 2017 10:35:59 +0200
Message-ID: <20170405083559.k3ivjzgevcksjoaq@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-9-drjones@redhat.com>
 <20170404194208.GH31208@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0034E40B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 04:33:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uh+2bo7eh5T7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 04:33:56 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07DCD40190
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 04:33:55 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170404194208.GH31208@cbox>
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
Cc: Levente Kurusa <lkurusa@redhat.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 09:42:08PM +0200, Christoffer Dall wrote:
> On Fri, Mar 31, 2017 at 06:06:57PM +0200, Andrew Jones wrote:
> > From: Levente Kurusa <lkurusa@redhat.com>
> > 
> > When two vcpus issue PSCI_CPU_ON on the same core at the same time,
> > then it's possible for them to both enter the target vcpu's setup
> > at the same time. This results in unexpected behaviors at best,
> > and the potential for some nasty bugs at worst.
> > 
> > Signed-off-by: Levente Kurusa <lkurusa@redhat.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/kvm/psci.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> > index f732484abc7a..0204daa899b1 100644
> > --- a/arch/arm/kvm/psci.c
> > +++ b/arch/arm/kvm/psci.c
> > @@ -88,7 +88,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	 */
> >  	if (!vcpu)
> >  		return PSCI_RET_INVALID_PARAMS;
> > -	if (!test_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
> > +
> > +	if (!test_and_clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
> >  		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
> >  			return PSCI_RET_ALREADY_ON;
> >  		else
> > @@ -116,7 +117,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	 * the general puspose registers are undefined upon CPU_ON.
> >  	 */
> >  	vcpu_set_reg(vcpu, 0, context_id);
> > -	clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
> >  
> >  	wq = kvm_arch_vcpu_wq(vcpu);
> >  	swake_up(wq);
> > -- 
> > 2.9.3
> > 
> 
> Depending on what you end up doing with the requests, if you keep the
> bool flag you could just use the kvm->lock mutex instead.
> 
> Have you considered if there are any potential races between
> kvm_psci_system_off() being called on one VCPU while two other VPCUs are
> turning on the same CPU that is being turend off as part of system-wide
> power down as well?

Sounds like a nice unit test.  I haven't considered it, but I guess
the kvm_psci_system_off/reset calling VCPU will ultimately "win", as
it'll cause an exit to userspace that initiates a shutdown/reset.
When the VCPUs are restarted then vcpu init should reset the power_off
state correctly.  As long as the race this patch addresses is fixed, then
I'm not sure there should be any risk with the actual system_off/reset
being delayed wrt a vcpu being "on'ed" again, nor with there being more
than one VCPU trying to "on" it at the same time.

> 
> I'm wondering if this means we should take the kvm->lock at a higher
> level when handling PSCI events...

That would simplify our analysis of the PSCI emulation, but I'm not
sure we want to give a guest the power to constantly acquire that
mutex with a barrage of PSCI calls.  Maybe we should create a PSCI
mutex?  In order to avoid holding it too long we may want power_off to
be more than a boolean though, i.e. the PENDING state might also be
a good idea to represent.

Thanks,
drew
