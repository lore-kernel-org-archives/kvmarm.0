From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 11/11] KVM: arm/arm64: timer: remove request-less vcpu
 kick
Date: Thu, 1 Jun 2017 13:09:00 +0200
Message-ID: <20170601110900.bwxffuh2nyp3jsx2@kamzik.brq.redhat.com>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-12-drjones@redhat.com>
 <20170601103454.GA20919@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601103454.GA20919@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 12:34:54PM +0200, Christoffer Dall wrote:
> On Tue, May 16, 2017 at 04:20:35AM +0200, Andrew Jones wrote:
> > The timer work is only scheduled for a VCPU when that VCPU is
> > blocked. This means we only need to wake it up, not kick (IPI)
> > it. While calling kvm_vcpu_kick() would just do the wake up,
> > and not kick, anyway, let's change this to avoid request-less
> > vcpu kicks, as they're generally not a good idea (see
> > "Request-less VCPU Kicks" in
> > Documentation/virtual/kvm/vcpu-requests.rst)
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  virt/kvm/arm/arch_timer.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 5976609ef27c..c9cd56f39b1e 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -95,7 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
> >  	 * If the vcpu is blocked we want to wake it up so that it will see
> >  	 * the timer has expired when entering the guest.
> >  	 */
> > -	kvm_vcpu_kick(vcpu);
> > +	swake_up(kvm_arch_vcpu_wq(vcpu));
> 
> We have kvm_vcpu_wake_up().  Why not use that?

The are two differences between swake_up(kvm_arch_vcpu_wq(vcpu)) and
kvm_vcpu_wake_up(vcpu)
 1. kvm_vcpu_wake_up() has a return value: true on wake up, else false
 2. kvm_vcpu_wake_up() increments the halt_wakeup stat when the vcpu
    is awaken

(1) doesn't really matter, but (2) might. Hmm, I think we do want to
increment that stat in this case though, so I should change this.

Also, we have another use of swake_up(kvm_arch_vcpu_wq(vcpu)), in
kvm_arm_resume_guest(), but there I don't think we want to increment
the halt stat, so that one is probably OK.

Thanks,
drew
