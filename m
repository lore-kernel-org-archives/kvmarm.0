From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 7/9] KVM: arm/arm64: PMU: remove request-less vcpu kick
Date: Tue, 4 Apr 2017 21:35:44 +0200
Message-ID: <20170404193544.GG31208@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-8-drjones@redhat.com>
 <20170404174612.GC31208@cbox>
 <20170404182918.buuvpsvh3cjo6wdn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA7640905
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 15:33:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tS+9E1tr9nJE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 15:33:30 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3604240625
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 15:33:29 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id x89so1657364wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 12:35:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170404182918.buuvpsvh3cjo6wdn@kamzik.brq.redhat.com>
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
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 08:29:18PM +0200, Andrew Jones wrote:
> On Tue, Apr 04, 2017 at 07:46:12PM +0200, Christoffer Dall wrote:
> > On Fri, Mar 31, 2017 at 06:06:56PM +0200, Andrew Jones wrote:
> > > Refactor PMU overflow handling in order to remove the request-less
> > > vcpu kick.  Now, since kvm_vgic_inject_irq() uses vcpu requests,
> > > there should be no chance that a kick sent at just the wrong time
> > > (between the VCPU's call to kvm_pmu_flush_hwstate() and before it
> > > enters guest mode) results in a failure for the guest to see updated
> > > GIC state until its next exit some time later for some other reason.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  virt/kvm/arm/pmu.c | 29 +++++++++++++++--------------
> > >  1 file changed, 15 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > > index 69ccce308458..9d725f3afb11 100644
> > > --- a/virt/kvm/arm/pmu.c
> > > +++ b/virt/kvm/arm/pmu.c
> > > @@ -203,6 +203,19 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
> > >  	return reg;
> > >  }
> > >  
> > > +static void kvm_pmu_check_overflow(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > > +	bool overflow;
> > > +
> > > +	overflow = !!kvm_pmu_overflow_status(vcpu);
> > > +	if (pmu->irq_level != overflow) {
> > > +		pmu->irq_level = overflow;
> > > +		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> > > +				    pmu->irq_num, overflow);
> > > +	}
> > > +}
> > > +
> > 
> > If we are changing the way the PMU works to adjust the interrupt
> > signaling whenever the PMU changes its internal state, do we still ahv
> > to call kvm_pmu_update_state() from each flush/sync path now?
> 
> The thought crossed my mind to rework that completely, in order to remove
> that flush/sync, but then went for the smaller patch for this series.  I
> can take a look at it though.
> 

Actually, now when I actually read what this code will be doing, the
extra thing in flush/sync won't do any work because it will find that
omu->irq_level == overflow, so never mind - we can improve that later as
an optimization patch.

Let's focus on getting it right.

Thanks,
-Christoffer


> > 
> > >  /**
> > >   * kvm_pmu_overflow_set - set PMU overflow interrupt
> > >   * @vcpu: The vcpu pointer
> > > @@ -210,31 +223,19 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
> > >   */
> > >  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
> > >  {
> > > -	u64 reg;
> > > -
> > >  	if (val == 0)
> > >  		return;
> > >  
> > >  	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
> > > -	reg = kvm_pmu_overflow_status(vcpu);
> > > -	if (reg != 0)
> > > -		kvm_vcpu_kick(vcpu);
> > > +	kvm_pmu_check_overflow(vcpu);
> > >  }
> > >  
> > >  static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
> > >  {
> > > -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > > -	bool overflow;
> > > -
> > >  	if (!kvm_arm_pmu_v3_ready(vcpu))
> > >  		return;
> > >  
> > > -	overflow = !!kvm_pmu_overflow_status(vcpu);
> > > -	if (pmu->irq_level != overflow) {
> > > -		pmu->irq_level = overflow;
> > > -		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> > > -				    pmu->irq_num, overflow);
> > > -	}
> > > +	kvm_pmu_check_overflow(vcpu);
> > >  }
> > >  
> > >  /**
> > > -- 
> > > 2.9.3
> > > 
