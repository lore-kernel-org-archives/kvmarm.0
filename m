From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/2] KVM: arm: rename pause into power_off
Date: Tue, 07 Jul 2015 16:08:55 +0200
Message-ID: <559BDD77.7050202@linaro.org>
References: <1436186996-22528-1-git-send-email-eric.auger@linaro.org>
 <1436186996-22528-2-git-send-email-eric.auger@linaro.org>
 <20150707133629.GF3381@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D137857EB5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 09:58:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M3Z24f7rJxq9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 09:58:03 -0400 (EDT)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D15657EB4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 09:58:03 -0400 (EDT)
Received: by wgjx7 with SMTP id x7so169053491wgj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jul 2015 07:09:32 -0700 (PDT)
In-Reply-To: <20150707133629.GF3381@hawk.localdomain>
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
Cc: eric.auger@st.com, patches@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,
On 07/07/2015 03:36 PM, Andrew Jones wrote:
> On Mon, Jul 06, 2015 at 02:49:55PM +0200, Eric Auger wrote:
>> The kvm_vcpu_arch pause field is renamed into power_off to prepare
>> for the introduction of a new pause field.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> v4 -> v5:
>> - fix compilation issue on arm64 (add power_off field in kvm_host.h)
>> ---
>>  arch/arm/include/asm/kvm_host.h   |  4 ++--
>>  arch/arm/kvm/arm.c                | 10 +++++-----
>>  arch/arm/kvm/psci.c               | 10 +++++-----
>>  arch/arm64/include/asm/kvm_host.h |  4 ++--
>>  4 files changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index e896d2c..304004d 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -129,8 +129,8 @@ struct kvm_vcpu_arch {
>>  	 * here.
>>  	 */
>>  
>> -	/* Don't run the guest on this vcpu */
>> -	bool pause;
> 
> This patch should leave pause in. kvm_arch_vcpu_ioctl_set_mpstate still
> references it, compilation is broken until the next patch comes.
Effectively that's definitively wrong.
> 
>> +	/* vcpu power-off state */
>> +	bool power_off;
>>  
>>  	/* IO related fields */
>>  	struct kvm_decode mmio_decode;
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index bcdf799..7537e68 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -475,7 +475,7 @@ static void vcpu_pause(struct kvm_vcpu *vcpu)
>>  {
>>  	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
>>  
>> -	wait_event_interruptible(*wq, !vcpu->arch.pause);
>> +	wait_event_interruptible(*wq, !vcpu->arch.power_off);
> 
> Leaving pause in would allow this to already be
> 
> +       wait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> +                                      (!vcpu->arch.pause)));
> 
> which feels better. The function name is vcpu_pause, so it's nice
> to see state named 'pause' in there.
agreed

Thanks for the review!

Eric
> 
>>  }
>>  
>>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>> @@ -525,7 +525,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  
>>  		update_vttbr(vcpu->kvm);
>>  
>> -		if (vcpu->arch.pause)
>> +		if (vcpu->arch.power_off)
>>  			vcpu_pause(vcpu);
>>  
>>  		/*
>> @@ -766,12 +766,12 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>>  	vcpu_reset_hcr(vcpu);
>>  
>>  	/*
>> -	 * Handle the "start in power-off" case by marking the VCPU as paused.
>> +	 * Handle the "start in power-off" case.
>>  	 */
>>  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
>> -		vcpu->arch.pause = true;
>> +		vcpu->arch.power_off = true;
>>  	else
>> -		vcpu->arch.pause = false;
>> +		vcpu->arch.power_off = false;
>>  
>>  	return 0;
>>  }
>> diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
>> index 4b94b51..134971a 100644
>> --- a/arch/arm/kvm/psci.c
>> +++ b/arch/arm/kvm/psci.c
>> @@ -63,7 +63,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>>  
>>  static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
>>  {
>> -	vcpu->arch.pause = true;
>> +	vcpu->arch.power_off = true;
>>  }
>>  
>>  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>> @@ -87,7 +87,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>>  	 */
>>  	if (!vcpu)
>>  		return PSCI_RET_INVALID_PARAMS;
>> -	if (!vcpu->arch.pause) {
>> +	if (!vcpu->arch.power_off) {
>>  		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
>>  			return PSCI_RET_ALREADY_ON;
>>  		else
>> @@ -115,7 +115,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>>  	 * the general puspose registers are undefined upon CPU_ON.
>>  	 */
>>  	*vcpu_reg(vcpu, 0) = context_id;
>> -	vcpu->arch.pause = false;
>> +	vcpu->arch.power_off = false;
>>  	smp_mb();		/* Make sure the above is visible */
>>  
>>  	wq = kvm_arch_vcpu_wq(vcpu);
>> @@ -152,7 +152,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>>  	kvm_for_each_vcpu(i, tmp, kvm) {
>>  		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
>>  		if (((mpidr & target_affinity_mask) == target_affinity) &&
>> -		    !tmp->arch.pause) {
>> +		    !tmp->arch.power_off) {
>>  			return PSCI_0_2_AFFINITY_LEVEL_ON;
>>  		}
>>  	}
>> @@ -175,7 +175,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>>  	 * re-initialized.
>>  	 */
>>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>> -		tmp->arch.pause = true;
>> +		tmp->arch.power_off = true;
>>  		kvm_vcpu_kick(tmp);
>>  	}
>>  
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2709db2..009da6b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -122,8 +122,8 @@ struct kvm_vcpu_arch {
>>  	 * here.
>>  	 */
>>  
>> -	/* Don't run the guest */
>> -	bool pause;
>> +	/* vcpu power-off state */
>> +	bool power_off;
>>  
>>  	/* IO related fields */
>>  	struct kvm_decode mmio_decode;
>> -- 
>> 1.9.1
> 
> Thanks,
> drew
> 
