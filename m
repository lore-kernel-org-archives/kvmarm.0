From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 4/7] KVM: arm/arm64: Check that system supports split
 eoi/deactivate
Date: Fri, 6 Jan 2017 10:24:04 +0000
Message-ID: <c3f788da-4cae-76ee-d186-ad44fcf3a318@arm.com>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
 <20161210204712.21830-5-christoffer.dall@linaro.org>
 <7e44980f-d4b9-a5d0-b0a9-5424548300d8@arm.com> <20170106100257.GD21089@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D9E4044B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 05:22:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hRmuvL-VsN07 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jan 2017 05:22:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D4140187
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 05:22:29 -0500 (EST)
In-Reply-To: <20170106100257.GD21089@cbox>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/01/17 10:02, Christoffer Dall wrote:
> On Thu, Jan 05, 2017 at 05:40:58PM +0000, Marc Zyngier wrote:
>> On 10/12/16 20:47, Christoffer Dall wrote:
>>> Some systems without proper firmware and/or hardware description data
>>> don't support the split EOI and deactivate operation and therefore
>>> don't provide an irq_set_vcpu_affinity implementation.  On such
>>> systems, we cannot leave the physical interrupt active after the timer
>>> handler on the host has run, so we cannot support KVM with the timer
>>> changes we about to introduce.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>  virt/kvm/arm/arch_timer.c | 30 ++++++++++++++++++++++++++++++
>>>  1 file changed, 30 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index c7c3bfd..f27a086 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -418,6 +418,31 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>>>  	return 0;
>>>  }
>>>  
>>> +static bool has_split_eoi_deactivate_support(void)
>>> +{
>>> +	struct irq_desc *desc;
>>> +	struct irq_data *data;
>>> +	struct irq_chip *chip;
>>> +
>>> +	/*
>>> +	 * Check if split EOI and deactivate is supported on this machine.
>>> +	 */
>>> +	desc = irq_to_desc(host_vtimer_irq);
>>> +	if (!desc) {
>>> +		kvm_err("kvm_arch_timer: no host_vtimer_irq descriptor\n");
>>> +		return false;
>>> +	}
>>> +
>>> +	data = irq_desc_get_irq_data(desc);
>>> +	chip = irq_data_get_irq_chip(data);
>>> +	if (!chip || !chip->irq_set_vcpu_affinity) {
>>> +		kvm_err("kvm_arch_timer: no split EOI/deactivate; abort\n");
>>> +		return false;
>>> +	}
>>> +
>>> +	return true;
>>> +}
>>
>> That feels really involved. How about reporting that we don't have a
>> usable VGIC altogether from the GIC driver?
>>
> 
> You mean not booting the kernel at all, or establish some communication
> from the GIC driver to KVM, telling KVM if it's usable for
> virtualization or not?

We already query the vgic configuration by calling gic_get_kvm_info() at
boot time. My suggestion is to make it return NULL if the GIC can't
support split EOI/deactivate, and fallback to the "no-vgic" mode, if
ever implemented.

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
