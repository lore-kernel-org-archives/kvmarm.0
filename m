From: Jia He <hejianet@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Thu, 14 Dec 2017 13:35:35 +0800
Message-ID: <f9f5ee12-f0a4-71b0-f765-84b0d7c2d453@gmail.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox> <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi


On 12/14/2017 12:57 PM, Jia He Wrote:
> Hi Christoffer
>
> I have tried your newer level-mapped-v7 branch, but bug is still there.
>
> There is no special load in both host and guest. The guest (kernel 
> 4.14) is often hanging when booting
>
> the guest kernel log
>
> [ OK ] Reached target Remote File Systems.
> Starting File System Check on /dev/mapper/fedora-root...
> [ OK ] Started File System Check on /dev/mapper/fedora-root.
> Mounting /sysroot...
> [ 2.670764] SGI XFS with ACLs, security attributes, no debug enabled
> [ 2.678180] XFS (dm-0): Mounting V5 Filesystem
> [ 2.740364] XFS (dm-0): Ending clean mount
> [ OK ] Mounted /sysroot.
> [ OK ] Reached target Initrd Root File System.
> Starting Reload Configuration from the Real Root...
> [ 61.288215] INFO: rcu_sched detected stalls on CPUs/tasks:
> [ 61.290791] 1-...!: (0 ticks this GP) idle=574/0/0 softirq=5/5 fqs=1
> [ 61.293664] (detected by 0, t=6002 jiffies, g=-263, c=-264, q=39760)
> [ 61.296480] Task dump for CPU 1:
> [ 61.297938] swapper/1 R running task 0 0 1 0x00000020
> [ 61.300643] Call trace:
> [ 61.301260] __switch_to+0x6c/0x78
> [ 61.302095] cpu_number+0x0/0x8
> [ 61.302867] rcu_sched kthread starved for 6000 jiffies! 
> g18446744073709551353 c18446744073709551352 f0x0 RCU_GP_WAIT_FQS(3) 
> ->state=0x402 ->cpu=1
> [ 61.305941] rcu_sched I 0 8 2 0x00000020
> [ 61.307250] Call trace:
> [ 61.307854] __switch_to+0x6c/0x78
> [ 61.308693] __schedule+0x268/0x8f0
> [ 61.309545] schedule+0x2c/0x88
> [ 61.310325] schedule_timeout+0x84/0x3b8
> [ 61.311278] rcu_gp_kthread+0x4d4/0x7d8
> [ 61.312213] kthread+0x134/0x138
> [ 61.313001] ret_from_fork+0x10/0x1c
>
> Maybe my previous patch is not perfect enough, thanks for your comments.
>
> I digged it futher more, do you think below code logic is possibly 
> problematic?
>
>
> vtimer_save_state           (vtimer->loaded = false, cntv_ctl is 0)
>
> kvm_arch_timer_handler        (read cntv_ctl and set vtimer->cnt_ctl = 0)
>
> vtimer_restore_state            (write vtimer->cnt_ctl to cntv_ctl, 
> then cntv_ctl will
>
>                        be 0 forever)
sorry, adjust the format, make it easy for reading:

vtimer_save_state                   (vtimer->loaded = false, cntv_ctl is 0)
kvm_arch_timer_handler        (read cntv_ctl and set vtimer->cnt_ctl = 0)
vtimer_restore_state              (write vtimer->cnt_ctl to cntv_ctl, 
then cntv_ctl will be 0 forever)

-- 
Cheers,
Jia

>
>
> If above analysis is reasonable, how about below patch? already tested 
> in my arm64 server.
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f9555b1..ee6dd3f 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -99,7 +99,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, 
> void *dev_id)
>         }
>         vtimer = vcpu_vtimer(vcpu);
>
> -       if (!vtimer->irq.level) {
> +       if (vtimer->loaded && !vtimer->irq.level) {
>                 vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>                 if (kvm_timer_irq_can_fire(vtimer))
>                         kvm_timer_update_irq(vcpu, true, vtimer);
>
> Cheers,
>
> Jia
>
>
>
> On 12/13/2017 5:18 PM, Christoffer Dall Wrote:
>> On Tue, Dec 12, 2017 at 11:00:07PM -0800, Jia He wrote:
>>> In our Armv8a server (qualcomm Amberwing, non VHE), after applying
>>> Christoffer's timer optimizing patchset(Optimize arch timer register
>>> handling), the guest is hang during kernel booting.
>>>
>>> The error root cause might be as follows:
>>> 1. in kvm_arch_timer_handler, it reset vtimer->cnt_ctl with current
>>> cntv_ctl register value. And then it missed some cases to update 
>>> timer's
>>> irq (irq.level) when kvm_timer_irq_can_fire() is false
>> Why should it set the irq level to true when the timer cannot fire?
>>
>>> 2. It causes kvm_vcpu_check_block return 0 instead of -EINTR
>>>     kvm_vcpu_check_block
>>>         kvm_cpu_has_pending_timer
>>>             kvm_timer_is_pending
>>>                 kvm_timer_should_fire
>>> 3. Thus, the kvm hyp code can not break the loop in kvm_vcpu_block 
>>> (halt
>>> poll process) and the guest is hang forever
>> This is just a polling loop which will expire after some time, so it
>> shouldn't halt the guest indefinitely, but merely slow it down for some
>> while, if we have a bug.  Is that the behavior you're seeing or are you
>> seeing the guest coming to a complete halt?
>>
>>> Fixes: b103cc3f10c0 ("KVM: arm/arm64: Avoid timer save/restore in 
>>> vcpu entry/exit")
>>> Signed-off-by: Jia He <jia.he@hxt-semitech.com>
>>> ---
>>>   virt/kvm/arm/arch_timer.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index f9555b1..bb86433 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -100,7 +100,6 @@ static irqreturn_t kvm_arch_timer_handler(int 
>>> irq, void *dev_id)
>>>       vtimer = vcpu_vtimer(vcpu);
>>>         if (!vtimer->irq.level) {
>>> -        vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>> This fix is clearly not correct, as it would prevent forwarding timer
>> interrupts in some cases.
>>
>>>           if (kvm_timer_irq_can_fire(vtimer))
>>>               kvm_timer_update_irq(vcpu, true, vtimer);
>>>       }
>>> -- 
>>> 2.7.4
>>>
>> I actually don't see how the above scenario you painted can happen.
>>
>> If you're in the polling loop, that means that the timer state is loaded
>> on the vcpu, and that means you can take interrupts from the timer, and
>> when you take interrupts, you will set the irq.level.
>>
>> And here's the first bit of logic in kvm_timer_is_pending():
>>
>>     if (vtimer->irq.level || ptimer->irq.level)
>>         return true;
>>
>> So that would break the loop.
>>
>> I'm not able to reproduce on my side with a non-VHE platform.
>>
>> What is the workload you're running to reproduce this, and what is the
>> exact kernel tree and kernel configuration you're using?
>>
>> Thanks,
>> -Christoffer
>>
>>
>>
