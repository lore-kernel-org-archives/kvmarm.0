From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Wed, 1 Feb 2017 10:01:02 +0000
Message-ID: <67c55d45-545e-a787-e2ad-3d6e675df593@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 <86sho199jx.fsf@arm.com> <20170201080440.GB6226@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170201080440.GB6226@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Jintack Lim <jintack@cs.columbia.edu>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/17 08:04, Christoffer Dall wrote:
> On Sun, Jan 29, 2017 at 03:21:06PM +0000, Marc Zyngier wrote:
>> On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>> Now that we maintain the EL1 physical timer register states of VMs,
>>> update the physical timer interrupt level along with the virtual one.
>>>
>>> Note that the emulated EL1 physical timer is not mapped to any hardware
>>> timer, so we call a proper vgic function.
>>>
>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>> ---
>>>  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index 0f6e935..3b6bd50 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>>>  	WARN_ON(ret);
>>>  }
>>>  
>>> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>>> +				 struct arch_timer_context *timer)
>>> +{
>>> +	int ret;
>>> +
>>> +	BUG_ON(!vgic_initialized(vcpu->kvm));
>>
>> Although I've added my fair share of BUG_ON() in the code base, I've
>> since reconsidered my position. If we get in a situation where the vgic
>> is not initialized, maybe it would be better to just WARN_ON and return
>> early rather than killing the whole box. Thoughts?
>>
> 
> Could we help this series along by saying that since this BUG_ON already
> exists in the kvm_timer_update_mapped_irq function, then it just
> preserves functionality and it's up to someone else (me) to remove the
> BUG_ON from both functions later in life?

Works for me.

	M.
-- 
Jazz is not dead. It just smells funny...
