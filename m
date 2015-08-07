From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 2/2] kvm: arm/arm64: implement kvm_arm_[halt, resume]_guest
Date: Fri, 07 Aug 2015 18:17:05 +0200
Message-ID: <55C4DA01.7040603@linaro.org>
References: <1436186996-22528-1-git-send-email-eric.auger@linaro.org>
 <1436186996-22528-3-git-send-email-eric.auger@linaro.org>
 <20150718091851.GO14024@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D6DA5A55F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 12:04:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ksBkZNcqny3r for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 12:04:54 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1341D5A528
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 12:04:53 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so66057305wic.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Aug 2015 09:17:46 -0700 (PDT)
In-Reply-To: <20150718091851.GO14024@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: eric.auger@st.com, patches@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Chistoffer,
On 07/18/2015 11:18 AM, Christoffer Dall wrote:
> On Mon, Jul 06, 2015 at 02:49:56PM +0200, Eric Auger wrote:
>> On halt, the guest is forced to exit and prevented from being
>> re-entered. This is synchronous.
>>
>> Those two operations will be needed for IRQ forwarding setting.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>> RFC v1 -> v2:
>> - add __maybe_unused
>>
>> RFC:
>> - rename the function and this latter becomes static
>> - remove __KVM_HAVE_ARCH_HALT_GUEST
>>
>> v4 -> v5: add arm64 support
>> - also defines __KVM_HAVE_ARCH_HALT_GUEST for arm64
>> - add pause field
>> ---
>>  arch/arm/include/asm/kvm_host.h   |  3 +++
>>  arch/arm/kvm/arm.c                | 35 ++++++++++++++++++++++++++++++++---
>>  arch/arm64/include/asm/kvm_host.h |  3 +++
>>  3 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 304004d..899ae27 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -132,6 +132,9 @@ struct kvm_vcpu_arch {
>>  	/* vcpu power-off state */
>>  	bool power_off;
>>  
>> +	/* Don't run the guest */
>> +	bool pause;
>> +
>>  	/* IO related fields */
>>  	struct kvm_decode mmio_decode;
>>  
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 7537e68..46d4ef6 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -471,11 +471,39 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
>>  	return vgic_initialized(kvm);
>>  }
>>  
>> +static void kvm_arm_halt_guest(struct kvm *kvm) __maybe_unused;
>> +static void kvm_arm_resume_guest(struct kvm *kvm) __maybe_unused;
>> +
>> +static void kvm_arm_halt_guest(struct kvm *kvm)
>> +{
>> +	int i;
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm)
>> +		vcpu->arch.pause = true;
>> +	force_vm_exit(cpu_all_mask);
>> +}
>> +
>> +static void kvm_arm_resume_guest(struct kvm *kvm)
>> +{
>> +	int i;
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
>> +
>> +		vcpu->arch.pause = false;
>> +		wake_up_interruptible(wq);
>> +	}
>> +}
>> +
>> +
>>  static void vcpu_pause(struct kvm_vcpu *vcpu)
>>  {
>>  	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
>>  
>> -	wait_event_interruptible(*wq, !vcpu->arch.power_off);
>> +	wait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
>> +				       (!vcpu->arch.pause)));
>>  }
>>  
>>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>> @@ -525,7 +553,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  
>>  		update_vttbr(vcpu->kvm);
>>  
>> -		if (vcpu->arch.power_off)
>> +		if (vcpu->arch.power_off || vcpu->arch.pause)
>>  			vcpu_pause(vcpu);
> 
> These two changes really make me feel like kvm_arch_vcpu_runnable()
> should be changed to check for both flags and all thes eplaces should
> check for runnable instead.
> 
> To make the runnable function more robust, perhaps it should check:
> 
> 1. The vcpu is neither paused nor powered off
> 2. The vcpu is not in a WFI state (vcpu->arch.wfi_request) OR there are
>    pending interrupts (the current check).

I did not understand what you meant by this vcpu->arch.wfi_request,
which I could not find. In case we call runnable from
kvm_vcpu_block/kvm_vcpu_check_block we sometimes are in WFI
(kvm_handle_wfx)?

Thanks

Eric
> 
> Then the logic would fit the name of the function, instead of being a
> specific check only called through handle_wfx.
> 
>>  
>>  		/*
>> @@ -551,7 +579,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  			run->exit_reason = KVM_EXIT_INTR;
>>  		}
>>  
>> -		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
>> +		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
>> +		    vcpu->arch.pause) {
> 
> so why do we need to re-check the pause flag, but not the power_off
> flag?  That is non-trivial for sure, so if it's correct, deserves a
> comment.  Also see my comment on the last patch.
> 
>>  			local_irq_enable();
>>  			preempt_enable();
>>  			kvm_vgic_sync_hwstate(vcpu);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 009da6b..69e3785 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -125,6 +125,9 @@ struct kvm_vcpu_arch {
>>  	/* vcpu power-off state */
>>  	bool power_off;
>>  
>> +	/* Don't run the guest */
> 
> Probably need to be more clear about this being an implementation
> requirement rather than being guest visible or related to any
> architectural concept.
> 
>> +	bool pause;
>> +
>>  	/* IO related fields */
>>  	struct kvm_decode mmio_decode;
>>  
>> -- 
>> 1.9.1
>>
> 
> Thanks,
> -Christoffer
> 
