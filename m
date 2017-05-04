From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 02/10] KVM: Add documentation for VCPU requests
Date: Thu, 4 May 2017 15:31:21 +0200
Message-ID: <20170504133121.tv2xdmorcmv23d4x@kamzik.brq.redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-3-drjones@redhat.com>
 <a6f81568-57dc-931e-c7b1-36b0f6ac38d6@redhat.com>
 <20170504120618.fa6xpr7uibfkaw6e@kamzik.brq.redhat.com>
 <897c798f-24ab-96d6-e013-dc1a34c307b1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <897c798f-24ab-96d6-e013-dc1a34c307b1@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 02:51:39PM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/05/2017 14:06, Andrew Jones wrote:
> >>> +VCPU threads may need to consider requests before and/or after calling
> >>> +functions that may put them to sleep, e.g. kvm_vcpu_block().  Whether they
> >>> +do or not, and, if they do, which requests need consideration, is
> >>> +architecture dependent.  kvm_vcpu_block() calls kvm_arch_vcpu_runnable()
> >>> +to check if it should awaken.  One reason to do so is to provide
> >>> +architectures a function where requests may be checked if necessary.
> >> What did you have in mind here?
> > I was trying to point out vcpu request concerns with respect to sleeping
> > vcpus, but to stay as general as possible. I can't really think of
> > anything else to say here, other than to give some hypothetical example.
> > For a while I was thinking I might check requests (kvm_request_pending())
> > from the kvm_arch_vcpu_runnable() call for ARM, but then changed my mind
> > on that - leaving it only checking the pause and power_off booleans.
> > Anyway, I don't think the above paragraph is "wrong", but if it's
> > confusing then I can change / remove it as people like. Just let me know
> > how you'd like it changed :-)
> 
> I think the x86 scheme, where you only process requests once you have
> decided you'll get IN_GUEST_MODE, is a good one.
> 
> That is, they _may_ check some requests in kvm_arch_vcpu_runnable but
> not process them.

This was my thought too, but checking that there are pending requests
seems like a valid reason to unblock - although only for certain requests.

> 
> For ARM this would be:
> 
>                 if (vcpu->arch.power_off || vcpu->arch.pause) {
>                         vcpu_sleep(vcpu);
> 			ret = 0;
> 		} else {
> 			ret = vcpu_enter_guest(vcpu);
> 		}
> 
> where vcpu_enter_guest is basically the "while (ret > 0)" loop in
> kvm_arch_vcpu_ioctl_run:

I'm not sure this refactoring is necessary, but I can experiment
with it.

> 
> 
>                 /*
>                  * Check conditions before entering the guest
>                  */
>                 cond_resched();
> 
>                 update_vttbr(vcpu->kvm);
>                 preempt_disable();
> 		...
>                 if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
>                         vcpu->arch.power_off || vcpu->arch.pause) {

This needs to check kvm_requests_pending(), like patch 3/10 adds.

>                         local_irq_enable();
>                         kvm_pmu_sync_hwstate(vcpu);
>                         kvm_timer_sync_hwstate(vcpu);
>                         kvm_vgic_sync_hwstate(vcpu);
>                         preempt_enable();
>                         return ret;
>                 }
> 		...
>                 preempt_enable();
>                 return handle_exit(vcpu, run, ret);
> 
> In your case, you don't need to check any request in
> kvm_arch_vcpu_runnable, I think.

Right. That was might final determination as well, so I don't check
any requests there with this series. I still tried writing this paragraph
to capture the general idea though, as I still think it's a valid idea to
want to check for certain pending requests in kvm_arch_vcpu_runnable(),
in order to know if a wakeup is necessary.

> This split would also solve my review
> doubt from "Re: [PATCH v3 05/10] KVM: arm/arm64: don't clear exit

I haven't received your doubt yet. Problem with mail delivery? Or did
you forget to send it :-)

> request from caller".
> 
> Paolo

Thanks,
drew
