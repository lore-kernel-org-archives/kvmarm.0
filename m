Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D87483BE5;
	Thu, 10 Sep 2026 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042792; cv=none; b=NbEAxvZ14Wx1E2wyO/Azvi9FQubrubbJx9TtQ1o54oTt8lAmF09C3uZKZlL81pl08Yoke3yqbrn+vZwOt+OeboVq6pFLszk6WMOp+daa/Ul6YL4huZKtfdXHmN82O+TzCKil+AeEfkYud1ssCLUDDSOSG1dRy5+B2+dJVv8Ffcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042792; c=relaxed/simple;
	bh=cgjIvGk64xm6wIC8g+V0Ot45lsy2Ho2erWZmfhiISqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxnNuImOsX6a4SzIJGxCGuCrdW7ZlKPXISAAs8uY1N5WU9Lpjy8xdORDfQrkP+gf4DPwRTtkadUs2vyoVHSUEol6/ZpM0oiGZilcOPqymHwQLxpawsQ5icIyYsb1h+oZEp2bszGAsYXFuUynfmWP5ZftyDU+Axd291NW0j74HwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NBheRzNO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NBheRzNO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDA07153B;
	Thu, 10 Sep 2026 05:19:45 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADC4A3F7B4;
	Thu, 10 Sep 2026 05:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042789; bh=cgjIvGk64xm6wIC8g+V0Ot45lsy2Ho2erWZmfhiISqs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NBheRzNO+EaTwIE+Pi/Plbx+7F7WlCuB8wg3buPDBtE4G4dEeJj35NT/q2J64qIHp
	 u0tB9tx4whoghfgK57/iyVp5ydRmdrH37cT2NJnyaBBZjCatKKKE39Tn2mq1hYX+2D
	 ie04ePScOrd4zIGdi6l6ROR7jGoyrGSbvILjtiqk=
Message-ID: <cdbf8e5c-fd45-4970-9835-1fe2f4530f36@arm.com>
Date: Thu, 10 Sep 2026 13:19:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 09/20] KVM: arm64: coco: arch_timer: Prevent timer
 offset configuration
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-10-suzuki.poulose@arm.com>
 <20260908164641.416911F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260908164641.416911F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 17:46, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Unprivileged host userspace can trigger a kernel WARN (and potential host panic) by setting SYS_CNTVCT_EL0 or SYS_CNTPCT_EL0 via KVM_SET_ONE_REG for a confidential VM.
> --
> 
> commit 563a7eb94c0d2b010c530d4a42b1717738d5106a
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: coco: arch_timer: Prevent timer offset configuration
>      
> Confidential guests, including protected PKVM guests and Arm CCA Realms, always
> runs with 0 timer offset. Prevent the configuration for them.
> 
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index 6ac3321f4c575..eba84cab95d01 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -1079,7 +1079,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>>   
>>   	ctxt->timer_id = timerid;
>>   
>> -	if (!kvm_vm_is_protected(vcpu->kvm)) {
>> +	if (!vcpu_is_confidential(vcpu)) {
>>   		if (timerid == TIMER_VTIMER)
>>   			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>>   		else
> 
> [ ... ]
> 
>> @@ -1110,7 +1110,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>   		timer_context_init(vcpu, i);
>>   
>>   	/* Synchronize offsets across timers of a VM if not already provided */
>> -	if (!vcpu_is_protected(vcpu) &&
>> +	if (!vcpu_is_confidential(vcpu) &&
>>   	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>>   		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>>   		timer_set_offset(vcpu_ptimer(vcpu), 0);
> 
> [Severity: High]
> This is a pre-existing issue, but does this configuration allow unprivileged
> host userspace to trigger a kernel WARN?
> 
> For confidential VMs, ctxt->offset.vm_offset is initialized to NULL in
> timer_context_init(), and KVM_ARCH_FLAG_VM_COUNTER_OFFSET is skipped
> here in kvm_timer_vcpu_init().
> 
> However, if userspace calls KVM_SET_ONE_REG for SYS_CNTVCT_EL0,
> arch_timer_set_user() handles it like this:
> 
> arch/arm64/kvm/sys_regs.c:arch_timer_set_user() {
>      ...
>      case SYS_CNTVCT_EL0:
>          if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
>              timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
>          return 0;
>      ...
> }
> 
> Since the flag is clear for confidential VMs, this will unconditionally invoke
> timer_set_offset() with a userspace-controlled offset.
> 
> In timer_set_offset():
> 
> include/kvm/arm_arch_timer.h:timer_set_offset() {
>      ...
>      if (!ctxt->offset.vm_offset) {
>          WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
>          return;
>      }
>      ...
> }
> 
> Because vm_offset is NULL, this triggers the WARN if the computed offset is
> non-zero. With panic_on_warn enabled (common in cloud environments), could
> this allow unprivileged host userspace to panic the host?

I have added the following patch to the series to fix this :

KVM: arm64: pKVM: Prevent setting CNTVCT_EL0/CNTPCT_EL0 for
  protected VMs

Protected VMs run doesn't allow setting offsets for virtual and phyiscal 
counters.
However we don't prevent the userspace from trying to write to the 
CNTVCT/CNTPCT
registers. This would lead to KVM triggering a WARN() in 
timer_set_offset() as
the vm_offset pointer is set to NULL. Prevent this by denying the writes to
them for protected VMs.

Reported by Sashiko here
  
https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org

Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer 
offsets for protected VMs")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
  arch/arm64/kvm/sys_regs.c | 4 ++++
  1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..ba44873799b23 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1787,10 +1787,14 @@ static int arch_timer_set_user(struct kvm_vcpu 
*vcpu,
                 val &= ~ARCH_TIMER_CTRL_IT_STAT;
                 break;
         case SYS_CNTVCT_EL0:
+               if (vcpu_is_protected(vcpu))
+                       return -EPERM;
                 if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, 
&vcpu->kvm->arch.flags))
                         timer_set_offset(vcpu_vtimer(vcpu), 
kvm_phys_timer_read() - val);
                 return 0;
         case SYS_CNTPCT_EL0:
+               if (vcpu_is_protected(vcpu))
+                       return -EPERM;
                 if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, 
&vcpu->kvm->arch.flags))
                         timer_set_offset(vcpu_ptimer(vcpu), 
kvm_phys_timer_read() - val);
                 return 0;

