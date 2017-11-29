From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 19/20] KVM: arm/arm64: Get rid of
 kvm_timer_flush_hwstate
Date: Wed, 29 Nov 2017 19:17:41 +0100
Message-ID: <20171129181741.jykflvgx67j7fxu4@kamzik.brq.redhat.com>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
 <1509093281-15225-20-git-send-email-cdall@linaro.org>
 <20171127165012.2egz3dos6h4zj7ub@kamzik.brq.redhat.com>
 <20171129173900.GE10563@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171129173900.GE10563@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 29, 2017 at 06:39:00PM +0100, Christoffer Dall wrote:
> On Mon, Nov 27, 2017 at 05:50:12PM +0100, Andrew Jones wrote:
> > On Fri, Oct 27, 2017 at 10:34:40AM +0200, Christoffer Dall wrote:
> > > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > > index 132d39a..14c50d1 100644
> > > --- a/virt/kvm/arm/arm.c
> > > +++ b/virt/kvm/arm/arm.c
> > > @@ -656,7 +656,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > >  
> > >  		local_irq_disable();
> > >  
> > > -		kvm_timer_flush_hwstate(vcpu);
> > >  		kvm_vgic_flush_hwstate(vcpu);
> > >  
> > >  		/*
> > > -- 
> > > 2.7.4
> > 
> > Hi Christoffer,
> > 
> > I realize this is already merged, but I have a question about the
> > above hunk. IIUC, the patch "KVM: arm/arm64: Move timer/vgic
> > flush/sync under disabled irq" only moved kvm_vgic_flush_hwstate()
> > under disabled irq because it had to be run after
> > kvm_timer_flush_hwstate(). Now that kvm_timer_flush_hwstate() is
> > gone can/should it be moved back out?
> > 
> 
> That's a great question.
> 
> I think my reasoning was, that since we now disable the VCPU interface
> (and thereby maintenance interrupts), any logic that relies on a
> maintenance interrupt firing and causing a guest exit after we've called
> flush, would no longer work if we move this back out where interrupts
> are enabled.
> 
> Thinking about this a bit more, I don't think that would ever make
> sense, and we should be able to move it out.
> 
> I've tested these patches pretty heavily and would want such a change to
> get the same kind of exposure, so I can start testing it, and if there
> are no issues, put it in next later on in the cycle.
> 
> Does that sound reasonable?

Sounds good to me. Thanks!

drew
