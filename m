From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v3 15/20] KVM: arm64: Set an impdef ESR for
 Virtual-SError using VSESR_EL2.
Date: Sun, 15 Oct 2017 16:09:47 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2016959EE@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1EDB49D28
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Oct 2017 12:09:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ1OWwNHu0u5 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Oct 2017 12:09:42 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87DDA49D26
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Oct 2017 12:09:41 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: "Jonathan.Zhang@cavium.com" <Jonathan.Zhang@cavium.com>, Wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "wangxiongfeng
 (C)" <wangxiongfeng2@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  Thanks for your mail.

> Hi gengdongjiu,
> 
> On 13/10/17 10:25, gengdongjiu wrote:
> > After checking this patch, I think my patch[1] already include this
> > logic(only a little difference).
> 
> Your kvm_handle_guest_sei() is similar to where this series ends up, but the purpose of this patch is to keep KVMs existing behaviour.
> 
> KVM already injects SError into the guest all by itself, now with the RAS extensions it can specify and ESR, and because of the new ESR
> encoding it can't use the reset value of all-zeroes.


Understand it, thanks for your explanation.

> 
> 
> > In my first version patch [2], It sets the virtual ESR in the KVM, but
> > Marc and other people disagree that[3][4],and propose to set its value
> > and injection by userspace(when RAS is enabled).
> 
> Not quite: for RAS errors.
> When we want to hand a RAS error to a guest, Qemu should be driving that.
> 
> What about impdef SError? Qemu should be able to drive that with the same API.
> 
> What about this nasty corner where KVM already injects an impdef SError directly? This patch keeps that working.
> 
> 
> I'd love to get rid of KVMs internal use of kvm_inject_vabt(). But what do we replace it with? It needs to be a guest exit type that existing
> software can't ignore...
> 
> (The best I can suggest is: Once we have a mechanism to inject SError into a guest from Qemu, KVM could make an impdef SError pending,
> then give Qemu the opportunity to kill the guest, or set a different ESR. Existing software can ignore the exit, and take the existing
> behaviour.)

In fact I have below method for that, what do you think about that?

1.  If there is no RAS, old method, directly inject virtual SError, not need to specify ESR, as shown in the [1]
2.  If there is RAS, KVM set "the kvm_run" guest exit type value to let user space handle the SError abort
   A. If ESR_EL2 is IMPLEMENTATION or uncategorized, return " ESR_ELx_ISV " to let user space specify an implementation-defined value, as shown [2]
   B. If ESR_EL2 is categorized and error not propagated,  the error come from guest user space, return " (ESR_ELx_AET_UCU | ESR_ELx_FSC_SERROR " to let user space specify a recoverable ESR. 
     Here one side calling memory failure, another side let user pace inject SError. Because usually SEI notification does not deliver SIGBUS signal to user space, so here inject virtual SEI to ensure that. As shown [3]
   C. If ESR_EL2 is categorized and error not propagated,  the error come from guest kernel, return "-1" to terminate guest. As shown [4]
   D. Otherwise, Panic host OS. As shown [5]


static int kvm_handle_guest_sei(struct kvm_vcpu *vcpu, struct kvm_run *run)
{
       unsigned int esr = kvm_vcpu_get_hsr(vcpu);
       bool impdef_syndrome =  esr & ESR_ELx_ISV;      /* aka IDS */
       unsigned int aet = esr & ESR_ELx_AET;

      if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))                      [1]
               kvm_inject_vabt(vcpu);
               return 1;
       }

       kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
	   kvm_run->ex.exception = KVM_EXCEPTION_SERROR;

	   If (impdef_syndrome || ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR) {
			kvm_run->ex.error_code = ESR_ELx_ISV;
		}

       switch (aet) {
       case ESR_ELx_AET_CE:    /* corrected error */                            [2]
       case ESR_ELx_AET_UEO:   /* restartable error, not yet consumed */
			   kvm_run->ex.error_code = (ESR_ELx_AET_UC | ESR_ELx_FSC_SERROR );   
               break;      /* continue processing the guest exit */


       case ESR_ELx_AET_UEU:  /* The error has not been propagated */            [3]
	   case ESR_ELx_AET_UER:
       /*
        * Only handle the guest user mode SEI if the error has not been propagated
        */
       if ((!vcpu_mode_priv(vcpu)) && !handle_guest_sei(kvm_vcpu_get_hsr(vcpu)))
			kvm_run->ex.error_code = (ESR_ELx_AET_UCU | ESR_ELx_FSC_SERROR );
      		break;
       else
			return -1;                                                    [4]
       /* If SError handling is failed, continue run */
       default:                                                           [5]
               /*
                * Until now, the CPU supports RAS and SEI is fatal, or user space
                * does not support to handle the SError.
                */
               panic("This Asynchronous SError interrupt is dangerous, panic");
       }

	   return 0;
}

> 
> > So I think we no need to submit another patch, it will be duplicated,
> > and waste our review time. thank you very much. I will combine that.
> 
> I agree we're posting competing series, there was some off-list co-ordination on this with Xie XiuQi and Xiongfeng Wang in ~may, it looks
> like you weren't involved at that point.
  
Thanks very much for your agreement, I will add you to the off-list.

> 
> In your last series touching all this:
> https://lkml.org/lkml/2017/8/31/698
> 
> You had Xie XiuQi's RAS-cpufeature patch in isolation, without the SError rework underneath it. Applied like this SError is still always masked
> in the kernel, so any system without firmware-first will silently consume and discard an uncontained-RAS-error using the esb() in
> __switch_to(). We can't do this, hence the first half of this series.


Yes, seems I lost your SError rework series patches. When my patch update and modification almost done, hope we can combine to one series. thanks

> 
> 
> James
