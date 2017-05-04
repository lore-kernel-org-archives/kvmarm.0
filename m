From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 02/10] KVM: Add documentation for VCPU requests
Date: Thu, 4 May 2017 14:51:39 +0200
Message-ID: <897c798f-24ab-96d6-e013-dc1a34c307b1@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-3-drjones@redhat.com>
 <a6f81568-57dc-931e-c7b1-36b0f6ac38d6@redhat.com>
 <20170504120618.fa6xpr7uibfkaw6e@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1125D40AF5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 08:48:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hCfVmcxu2fVx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 08:48:38 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 054CA40190
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 08:48:37 -0400 (EDT)
In-Reply-To: <20170504120618.fa6xpr7uibfkaw6e@kamzik.brq.redhat.com>
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
Cc: marc.zyngier@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/05/2017 14:06, Andrew Jones wrote:
>>> +VCPU threads may need to consider requests before and/or after calling
>>> +functions that may put them to sleep, e.g. kvm_vcpu_block().  Whether they
>>> +do or not, and, if they do, which requests need consideration, is
>>> +architecture dependent.  kvm_vcpu_block() calls kvm_arch_vcpu_runnable()
>>> +to check if it should awaken.  One reason to do so is to provide
>>> +architectures a function where requests may be checked if necessary.
>> What did you have in mind here?
> I was trying to point out vcpu request concerns with respect to sleeping
> vcpus, but to stay as general as possible. I can't really think of
> anything else to say here, other than to give some hypothetical example.
> For a while I was thinking I might check requests (kvm_request_pending())
> from the kvm_arch_vcpu_runnable() call for ARM, but then changed my mind
> on that - leaving it only checking the pause and power_off booleans.
> Anyway, I don't think the above paragraph is "wrong", but if it's
> confusing then I can change / remove it as people like. Just let me know
> how you'd like it changed :-)

I think the x86 scheme, where you only process requests once you have
decided you'll get IN_GUEST_MODE, is a good one.

That is, they _may_ check some requests in kvm_arch_vcpu_runnable but
not process them.

For ARM this would be:

                if (vcpu->arch.power_off || vcpu->arch.pause) {
                        vcpu_sleep(vcpu);
			ret = 0;
		} else {
			ret = vcpu_enter_guest(vcpu);
		}

where vcpu_enter_guest is basically the "while (ret > 0)" loop in
kvm_arch_vcpu_ioctl_run:


                /*
                 * Check conditions before entering the guest
                 */
                cond_resched();

                update_vttbr(vcpu->kvm);
                preempt_disable();
		...
                if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
                        vcpu->arch.power_off || vcpu->arch.pause) {
                        local_irq_enable();
                        kvm_pmu_sync_hwstate(vcpu);
                        kvm_timer_sync_hwstate(vcpu);
                        kvm_vgic_sync_hwstate(vcpu);
                        preempt_enable();
                        return ret;
                }
		...
                preempt_enable();
                return handle_exit(vcpu, run, ret);

In your case, you don't need to check any request in
kvm_arch_vcpu_runnable, I think.  This split would also solve my review
doubt from "Re: [PATCH v3 05/10] KVM: arm/arm64: don't clear exit
request from caller".

Paolo
