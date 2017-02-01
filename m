From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Wed, 1 Feb 2017 10:17:12 +0000
Message-ID: <faff705e-78a9-d3ae-b09b-d6f5824b98d9@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 <86sho199jx.fsf@arm.com> <20170201080440.GB6226@cbox>
 <CAHyh4xjTWK0HeQhX9X6+6Ez706Sh4+=3wMq0b9rmvGTbD8q80g@mail.gmail.com>
 <20170201100716.GC6226@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 702FF408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 05:16:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AUup+FOiqOwt for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 05:16:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61E3840284
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 05:16:55 -0500 (EST)
In-Reply-To: <20170201100716.GC6226@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/17 10:07, Christoffer Dall wrote:
> On Wed, Feb 01, 2017 at 03:40:10AM -0500, Jintack Lim wrote:
>> On Wed, Feb 1, 2017 at 3:04 AM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>>> On Sun, Jan 29, 2017 at 03:21:06PM +0000, Marc Zyngier wrote:
>>>> On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>>>> Now that we maintain the EL1 physical timer register states of VMs,
>>>>> update the physical timer interrupt level along with the virtual one.
>>>>>
>>>>> Note that the emulated EL1 physical timer is not mapped to any hardware
>>>>> timer, so we call a proper vgic function.
>>>>>
>>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>>> ---
>>>>>  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
>>>>>  1 file changed, 20 insertions(+)
>>>>>
>>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>>>> index 0f6e935..3b6bd50 100644
>>>>> --- a/virt/kvm/arm/arch_timer.c
>>>>> +++ b/virt/kvm/arm/arch_timer.c
>>>>> @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>>>>>     WARN_ON(ret);
>>>>>  }
>>>>>
>>>>> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>>>>> +                            struct arch_timer_context *timer)
>>>>> +{
>>>>> +   int ret;
>>>>> +
>>>>> +   BUG_ON(!vgic_initialized(vcpu->kvm));
>>>>
>>>> Although I've added my fair share of BUG_ON() in the code base, I've
>>>> since reconsidered my position. If we get in a situation where the vgic
>>>> is not initialized, maybe it would be better to just WARN_ON and return
>>>> early rather than killing the whole box. Thoughts?
>>>>
>>>
>>> Could we help this series along by saying that since this BUG_ON already
>>> exists in the kvm_timer_update_mapped_irq function, then it just
>>> preserves functionality and it's up to someone else (me) to remove the
>>> BUG_ON from both functions later in life?
>>>
>>
>> Sounds good to me :) Thanks!
>>
> 
> So just as you thought you were getting off easy...
> 
> The reason we now have kvm_timer_update_irq and
> kvm_timer_update_mapped_irq is that we have the following two vgic
> functions:
> 
> kvm_vgic_inject_irq
> kvm_vgic_inject_mapped_irq
> 
> But the only difference between the two is what they pass
> as the mapped_irq argument to vgic_update_irq_pending.
> 
> What about if we just had this as a precursor patch:
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 6a084cd..91ecf48 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -175,7 +175,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>  	timer->irq.level = new_level;
>  	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
>  				   timer->irq.level);
> -	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> +
> +	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
>  					 timer->irq.irq,
>  					 timer->irq.level);
>  	WARN_ON(ret);
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index dea12df..4c87fd0 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -336,8 +336,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
>  }
>  
>  static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> -				   unsigned int intid, bool level,
> -				   bool mapped_irq)
> +				   unsigned int intid, bool level)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct vgic_irq *irq;
> @@ -357,11 +356,6 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  	if (!irq)
>  		return -EINVAL;
>  
> -	if (irq->hw != mapped_irq) {
> -		vgic_put_irq(kvm, irq);
> -		return -EINVAL;
> -	}
> -
>  	spin_lock(&irq->irq_lock);
>  
>  	if (!vgic_validate_injection(irq, level)) {
> @@ -399,13 +393,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level)
>  {
> -	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
> -}
> -
> -int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> -			       bool level)
> -{
> -	return vgic_update_irq_pending(kvm, cpuid, intid, level, true);
> +	return vgic_update_irq_pending(kvm, cpuid, intid, level);
>  }
>  
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
> 
> 
> That would make this patch simpler.  If so, I can send out the above
> patch with a proper description.

Indeed. And while you're at it, rename vgic_update_irq_pending to
kvm_vgic_inject_irq, as I don't think we need this simple stub?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
