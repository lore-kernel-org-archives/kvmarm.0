From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 3/5] KVM: arm/arm64: Require VCPU threads to turn them
 self off
Date: Wed, 30 Jan 2019 10:49:09 +0100
Message-ID: <20190130094909.GF13482@e113682-lin.lund.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-4-christoffer.dall@arm.com>
 <20190129161644.v4ncrcgvukkd7d5w@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 827A44A32D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 04:49:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EQ0PXkNLFTJg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 04:49:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E234A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 04:49:11 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190129161644.v4ncrcgvukkd7d5w@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 05:16:44PM +0100, Andrew Jones wrote:
> 
> Summary edit
> 
> > KVM: arm/arm64: Require VCPU threads to turn them self off
> 
> themselves
> 
> On Fri, Jan 25, 2019 at 10:46:54AM +0100, Christoffer Dall wrote:
> > To avoid a race between turning VCPUs off and turning them on, make sure
> > that only the VCPU threat itself turns off the VCPU.  When other threads
> > want to turn of a VCPU, they now do this via a request.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  2 ++
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  virt/kvm/arm/arm.c                |  8 ++++++--
> >  virt/kvm/arm/psci.c               | 11 ++---------
> >  4 files changed, 12 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 50e89869178a..b1cfae222441 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -49,6 +49,8 @@
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> > +#define KVM_REQ_VCPU_OFF \
> > +	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index da3fc7324d68..d43b13421987 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -49,6 +49,8 @@
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> > +#define KVM_REQ_VCPU_OFF \
> > +	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 9c486fad3f9f..785076176814 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -404,8 +404,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  
> >  static void vcpu_power_off(struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu->arch.power_off = true;
> > -	kvm_make_request(KVM_REQ_SLEEP, vcpu);
> > +	kvm_make_request(KVM_REQ_VCPU_OFF, vcpu);
> >  	kvm_vcpu_kick(vcpu);
> >  }
> 
> I think we should leave this function alone. Otherwise if userspace sets
> the MP state to STOPPED and then queries the state before the vcpu
> has a chance to manage its vcpu requests, the state will still indicate
> RUNNBLE. The same goes for a query right after doing a vcpu init.
> 

We can't leave this alone, because that could lead to userspace racing
with two PSCI_VCPU_ON requests which could then both enter the critical
section gated only by the cmpxchg in kvm_psci_vcpu_on.

But we could do something like this (completely untested):


diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 1e3195155860..538b5eb9d920 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -404,6 +404,17 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 static void vcpu_power_off(struct kvm_vcpu *vcpu)
 {
+	enum vcpu_power_state old_power_state;
+
+	/*
+	 * Set power_state directly to reflect the power state back to user
+	 * space even when the VCPU thread has not had a chance to run, but
+	 * only if this doesn't accidentally allow interleaved PSCI_VCPU_ON
+	 * requests.
+	 */
+	old_power_state = cmpxchg(&vcpu->arch.power_state,
+				  KVM_ARM_VCPU_ON,
+				  KVM_ARM_VCPU_OFF);
 	kvm_make_request(KVM_REQ_VCPU_OFF, vcpu);
 	kvm_vcpu_kick(vcpu);
 }


> >  
> > @@ -646,6 +645,11 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> >  			vcpu_req_sleep(vcpu);
> >  
> > +		if (kvm_check_request(KVM_REQ_VCPU_OFF, vcpu)) {
> > +			vcpu->arch.power_off = true;
> > +			vcpu_req_sleep(vcpu);
> > +		}
> > +
> >  		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
> >  			kvm_reset_vcpu(vcpu);
> >  
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> > index b9cff1d4b06d..20255319e193 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -97,9 +97,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  
> >  static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu->arch.power_off = true;
> > -	kvm_make_request(KVM_REQ_SLEEP, vcpu);
> > -	kvm_vcpu_kick(vcpu);
> > +	kvm_make_request(KVM_REQ_VCPU_OFF, vcpu);
> >  }
> 
> This was currently fine since it implements CPU_OFF which only applies to
> the calling vcpu, but there's also no reason not to change it to be
> consistent with the below change
> 

Same problem as above, we don't want two VCPUs to be messing with a
target VCPU state at the same time.


Thanks,

    Christoffer
