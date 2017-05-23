From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 3/3] KVM: arm/arm64: Simplify active_change_prepare and
 plug race
Date: Tue, 23 May 2017 11:36:36 +0100
Message-ID: <df01e241-3463-bc55-63ff-81fb09dc7df0@arm.com>
References: <20170516100431.4101-1-cdall@linaro.org>
 <20170516100431.4101-4-cdall@linaro.org>
 <9a412ed2-70ea-b651-dd75-18d723ee8b71@arm.com> <20170523084329.GC6319@cbox>
 <cf2875a8-faef-4d2f-7394-9378fadb9d1d@arm.com> <20170523095605.GA19598@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170523095605.GA19598@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/05/17 10:56, Christoffer Dall wrote:
> On Tue, May 23, 2017 at 10:05:13AM +0100, Marc Zyngier wrote:
>> On 23/05/17 09:43, Christoffer Dall wrote:
>>> On Mon, May 22, 2017 at 04:30:22PM +0100, Marc Zyngier wrote:
>>>> On 16/05/17 11:04, Christoffer Dall wrote:
>>>>> We don't need to stop a specific VCPU when changing the active state,
>>>>> because private IRQs can only be modified by a running VCPU for the
>>>>> VCPU itself and it is therefore already stopped.
>>>>>
>>>>> However, it is also possible for two VCPUs to be modifying the active
>>>>> state of SPIs at the same time, which can cause the thread being stuck
>>>>> in the loop that checks other VCPU threads for a potentially very long
>>>>> time, or to modify the active state of a running VCPU.  Fix this by
>>>>> serializing all accesses to setting and clearing the active state of
>>>>> interrupts using the KVM mutex.
>>>>>
>>>>> Reported-by: Andrew Jones <drjones@redhat.com>
>>>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>>>>> ---
>>>>>  arch/arm/include/asm/kvm_host.h   |  2 --
>>>>>  arch/arm64/include/asm/kvm_host.h |  2 --
>>>>>  virt/kvm/arm/arm.c                | 20 ++++----------------
>>>>>  virt/kvm/arm/vgic/vgic-mmio.c     | 18 ++++++++++--------
>>>>>  virt/kvm/arm/vgic/vgic.c          | 11 ++++++-----
>>>>>  5 files changed, 20 insertions(+), 33 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>>> index f0e6657..12274d4 100644
>>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>>> @@ -233,8 +233,6 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>>>>>  struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
>>>>>  void kvm_arm_halt_guest(struct kvm *kvm);
>>>>>  void kvm_arm_resume_guest(struct kvm *kvm);
>>>>> -void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
>>>>> -void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
>>>>>  
>>>>>  int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>>>>>  unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>> index 5e19165..32cbe8a 100644
>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>> @@ -333,8 +333,6 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>>>>>  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>>>>>  void kvm_arm_halt_guest(struct kvm *kvm);
>>>>>  void kvm_arm_resume_guest(struct kvm *kvm);
>>>>> -void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
>>>>> -void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
>>>>>  
>>>>>  u64 __kvm_call_hyp(void *hypfn, ...);
>>>>>  #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
>>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>>>> index 3417e18..3c387fd 100644
>>>>> --- a/virt/kvm/arm/arm.c
>>>>> +++ b/virt/kvm/arm/arm.c
>>>>> @@ -539,27 +539,15 @@ void kvm_arm_halt_guest(struct kvm *kvm)
>>>>>  	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
>>>>>  }
>>>>>  
>>>>> -void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
>>>>> -{
>>>>> -	vcpu->arch.pause = true;
>>>>> -	kvm_vcpu_kick(vcpu);
>>>>> -}
>>>>> -
>>>>> -void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
>>>>> -{
>>>>> -	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>>>>> -
>>>>> -	vcpu->arch.pause = false;
>>>>> -	swake_up(wq);
>>>>> -}
>>>>> -
>>>>>  void kvm_arm_resume_guest(struct kvm *kvm)
>>>>>  {
>>>>>  	int i;
>>>>>  	struct kvm_vcpu *vcpu;
>>>>>  
>>>>> -	kvm_for_each_vcpu(i, vcpu, kvm)
>>>>> -		kvm_arm_resume_vcpu(vcpu);
>>>>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>>>>> +		vcpu->arch.pause = false;
>>>>> +		swake_up(kvm_arch_vcpu_wq(vcpu));
>>>>> +	}
>>>>>  }
>>>>>  
>>>>>  static void vcpu_sleep(struct kvm_vcpu *vcpu)
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>>>>> index 64cbcb4..c1e4bdd 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>>>> @@ -231,23 +231,21 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>>>>>   * be migrated while we don't hold the IRQ locks and we don't want to be
>>>>>   * chasing moving targets.
>>>>>   *
>>>>> - * For private interrupts, we only have to make sure the single and only VCPU
>>>>> - * that can potentially queue the IRQ is stopped.
>>>>> + * For private interrupts we don't have to do anything because userspace
>>>>> + * accesses to the VGIC state already require all VCPUs to be stopped, and
>>>>> + * only the VCPU itself can modify its private interrupts active state, which
>>>>> + * guarantees that the VCPU is not running.
>>>>>   */
>>>>>  static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
>>>>>  {
>>>>> -	if (intid < VGIC_NR_PRIVATE_IRQS)
>>>>> -		kvm_arm_halt_vcpu(vcpu);
>>>>> -	else
>>>>> +	if (intid > VGIC_NR_PRIVATE_IRQS)
>>>>>  		kvm_arm_halt_guest(vcpu->kvm);
>>>>>  }
>>>>>  
>>>>>  /* See vgic_change_active_prepare */
>>>>>  static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
>>>>>  {
>>>>> -	if (intid < VGIC_NR_PRIVATE_IRQS)
>>>>> -		kvm_arm_resume_vcpu(vcpu);
>>>>> -	else
>>>>> +	if (intid > VGIC_NR_PRIVATE_IRQS)
>>>>>  		kvm_arm_resume_guest(vcpu->kvm);
>>>>>  }
>>>>>  
>>>>> @@ -271,11 +269,13 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>>>>>  {
>>>>>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>>>>>  
>>>>> +	mutex_lock(&vcpu->kvm->lock);
>>>>>  	vgic_change_active_prepare(vcpu, intid);
>>>>>  
>>>>>  	__vgic_mmio_write_cactive(vcpu, addr, len, val);
>>>>>  
>>>>>  	vgic_change_active_finish(vcpu, intid);
>>>>> +	mutex_unlock(&vcpu->kvm->lock);
>>>>
>>>> Any reason not to move the lock/unlock calls to prepare/finish? Also, do
>>>> we need to take that mutex if intid is a PPI?
>>>
>>> I guess we strictly don't need to take the mutex if it's a PPI, no.
>>>
>>> But I actually preferred this symmetry because you can easily tell we
>>> don't have a bug (famous last words) by locking and unlocking the mutex
>>> in the same function.
>>>
>>> I don't feel strongly about it though, so I can move it if you prefer
>>> it.
>>
>> No, that's fine, I just wanted to check whether my understanding was
>> correct.
>>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>>
> 
> Thanks.
> 
> So assuming Drew's patches will go on top of these, should we merge this
> as fixes to -rcX, or queue them for v4.13 ?
> 
> I'm leaning towards the latter because I don't think we've seen these
> races do something bad in the wild, and they're probably not going to be
> backportable to stable anyway.  Thoughts?

The race would only impact a guest hammering its own registers, so I'm
quite happy for this to go into 4.13.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
