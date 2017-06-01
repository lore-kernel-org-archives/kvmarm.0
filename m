From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 11/11] KVM: arm/arm64: timer: remove request-less vcpu
 kick
Date: Thu, 1 Jun 2017 15:23:55 +0200
Message-ID: <20170601132355.GK20919@cbox>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-12-drjones@redhat.com>
 <20170601103454.GA20919@cbox>
 <20170601110900.bwxffuh2nyp3jsx2@kamzik.brq.redhat.com>
 <076a66da-7d55-bcdb-8466-ce2abed7fcf8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <076a66da-7d55-bcdb-8466-ce2abed7fcf8@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 02:37:52PM +0200, Paolo Bonzini wrote:
> 
> 
> On 01/06/2017 13:09, Andrew Jones wrote:
> >>> -	kvm_vcpu_kick(vcpu);
> >>> +	swake_up(kvm_arch_vcpu_wq(vcpu));
> >> We have kvm_vcpu_wake_up().  Why not use that?
> > The are two differences between swake_up(kvm_arch_vcpu_wq(vcpu)) and
> > kvm_vcpu_wake_up(vcpu)
> >  1. kvm_vcpu_wake_up() has a return value: true on wake up, else false
> >  2. kvm_vcpu_wake_up() increments the halt_wakeup stat when the vcpu
> >     is awaken
> > 
> > (1) doesn't really matter, but (2) might. Hmm, I think we do want to
> > increment that stat in this case though, so I should change this.
> 
> Yep.
> 
> > Also, we have another use of swake_up(kvm_arch_vcpu_wq(vcpu)), in
> > kvm_arm_resume_guest(), but there I don't think we want to increment
> > the halt stat, so that one is probably OK.
> 
> I would define a __kvm_vcpu_wake_up if you don't want the stat.
> 
I didn't mind the other one, because it is in a function in the code
right above the sleep function, which uses swait_event_interruptible
directly without calling kvm_vcpu_block, so the symmetry is clear there,
but not in the timer case.

-Christoffer
