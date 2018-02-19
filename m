From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 17/41] KVM: arm64: Remove noop calls to timer
 save/restore from VHE switch
Date: Mon, 19 Feb 2018 16:30:01 +0000
Message-ID: <591b3937-7a53-afb3-7f2f-e859d3e46601@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-18-christoffer.dall@linaro.org>
 <20074994-caac-2be0-6eaa-83115c616756@arm.com> <20180213223134.GK23189@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B54840480
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 11:23:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MOdUGLcqcZBc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Feb 2018 11:23:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1F98403FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 11:23:31 -0500 (EST)
In-Reply-To: <20180213223134.GK23189@cbox>
Content-Language: en-US
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

Sorry for the late reply.

On 13/02/18 22:31, Christoffer Dall wrote:
> On Fri, Feb 09, 2018 at 05:53:43PM +0000, Julien Grall wrote:
>> Hi Christoffer,
>>
>> On 01/12/2018 12:07 PM, Christoffer Dall wrote:
>>> The VHE switch function calls __timer_enable_traps and
>>> __timer_disable_traps which don't do anything on VHE systems.
>>> Therefore, simply remove these calls from the VHE switch function and
>>> make the functions non-conditional as they are now only called from the
>>> non-VHE switch path.
>>>
>>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>   arch/arm64/kvm/hyp/switch.c |  2 --
>>>   virt/kvm/arm/hyp/timer-sr.c | 44 ++++++++++++++++++++++----------------------
>>>   2 files changed, 22 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>> index 9aadef6966bf..6175fcb33ed2 100644
>>> --- a/arch/arm64/kvm/hyp/switch.c
>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>> @@ -354,7 +354,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>>>   	__activate_vm(vcpu->kvm);
>>>   	__vgic_restore_state(vcpu);
>>> -	__timer_enable_traps(vcpu);
>>>   	/*
>>>   	 * We must restore the 32-bit state before the sysregs, thanks
>>> @@ -373,7 +372,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>>>   	__sysreg_save_guest_state(guest_ctxt);
>>>   	__sysreg32_save_state(vcpu);
>>> -	__timer_disable_traps(vcpu);
>>>   	__vgic_save_state(vcpu);
>>>   	__deactivate_traps(vcpu);
>>> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
>>> index f24404b3c8df..77754a62eb0c 100644
>>> --- a/virt/kvm/arm/hyp/timer-sr.c
>>> +++ b/virt/kvm/arm/hyp/timer-sr.c
>>> @@ -27,34 +27,34 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
>>>   	write_sysreg(cntvoff, cntvoff_el2);
>>>   }
>>> +/*
>>> + * Should only be called on non-VHE systems.
>>> + * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
>>> + */
>>>   void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
>>
>> Would it be worth to suffix the function with nvhe? So it would be clear
>> that it should not be called for VHE system?
>>
> Actually, I decided against this, because it's also called from the
> 32-bit code and it looks a little strange there, and it's not like we
> have an equivalent _vhe version.

The main goal was to provide a naming that would prevent someone to use 
it in VHE case. This would have also  been inline with other patches 
where you rename some helpers to nvhe/vhe even in arm32 code.

Anyway, I guess the reviewers will be careful enough to spot that :).

Cheers,

-- 
Julien Grall
