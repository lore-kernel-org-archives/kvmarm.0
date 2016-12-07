From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Check for properly initialized timer on
 init
Date: Wed, 7 Dec 2016 11:06:16 +0000
Message-ID: <f66ed076-cd38-6eb4-40d6-e1ec031fc1ef@arm.com>
References: <20161205093211.11870-1-christoffer.dall@linaro.org>
 <1ed187ba-965b-6087-f74f-68627f0d0504@arm.com> <20161206195652.GF4816@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161206195652.GF4816@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/16 19:56, Christoffer Dall wrote:
> On Tue, Dec 06, 2016 at 11:25:42AM +0000, Marc Zyngier wrote:
>> On 05/12/16 09:32, Christoffer Dall wrote:
>>> When the arch timer code fails to initialize (for example because the
>>> memory mapped timer doesn't work, which is currently seen with the AEM
>>> model), then KVM just continues happily with a final result that KVM
>>> eventually does a NULL pointer dereference of the uninitialized cycle
>>> counter.
>>>
>>> Check directly for this in the init path and give the user a reasonable
>>> error in this case.
>>>
>>> Cc: Shih-Wei Li <shihwei@cs.columbia.edu>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>  virt/kvm/arm/arch_timer.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index 27a1f63..5c12f53 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -425,6 +425,11 @@ int kvm_timer_hyp_init(void)
>>>  	info = arch_timer_get_kvm_info();
>>>  	timecounter = &info->timecounter;
>>>  
>>> +	if (!timecounter->cc) {
>>> +		kvm_err("arch_timer: uninitialized timecounter\n");
>>
>> For consistency, I'll change the error message to say "kvm_arch_timer",
>> just like the below case.
>>
> 
> No objections, only problem is that the patch you queued uses
> kcm_arch_timer ;)

Yeah, that's the new and upgraded version: Kernel Cryogenic Machine, it
freezes time ;-).

I'll fix that shortly, thanks for the heads up!

	M.
-- 
Jazz is not dead. It just smells funny...
