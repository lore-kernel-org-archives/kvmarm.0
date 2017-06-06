From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] kvm: arm/arm64: vgic: Fix the sequence principle about
 vgic save/restore.
Date: Tue, 6 Jun 2017 17:55:46 +0800
Message-ID: <59367C22.1090106@huawei.com>
References: <1496658604-20036-1-git-send-email-wanghaibin.wang@huawei.com>
 <e8c54af6-c774-a37e-a14f-04d422fe5234@arm.com> <59362027.4020302@huawei.com>
 <bc080925-adbf-3d13-bd0a-6b5ee834c85c@arm.com> <59367612.3000401@huawei.com>
 <87d1ahjvsm.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C509940962
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 05:53:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QPs08X4V-qBt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 05:53:55 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B17D94095A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 05:53:51 -0400 (EDT)
In-Reply-To: <87d1ahjvsm.fsf@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/6/6 17:43, Marc Zyngier wrote:

> On Tue, Jun 06 2017 at  5:29:54 pm BST, wanghaibin <wanghaibin.wang@huawei.com> wrote:
>> On 2017/6/6 16:34, Marc Zyngier wrote:
>>
>>> On 06/06/17 04:23, wanghaibin wrote:
>>>> On 2017/6/5 21:56, Marc Zyngier wrote:
>>>>
>>>>> On 05/06/17 11:30, wanghaibin wrote:
>>>>>> At present, take GICv3 as as an example, our implementation is
>>>>>> that, the operation
>>>>>> of the recovery ICH_HCR register is prior to the recovery of
>>>>>> ICH_LRn registers in vgic
>>>>>> state restore. Thus, the ICH_LRn registers are 0, and if
>>>>>> ICH_HCR.UIE is configured to 1,
>>>>>> a large number of unnecessary maintenance interrupts will be triggered.
>>>>>
>>>>> Is that a theoretical problem? Or something you've actually observed?
>>>>
>>>>
>>>> I observed this problem with that boot a android vm (with 4 vcpus)
>>>> on my hisilicon D03 board (4 LRs support).
>>>> Boot the android vm will failed because of any virtual interrupts
>>>> can't deliver to the vm timely.
>>>>
>>>> I watched the maintenance interrupt (/proc/interrupts, GICv3
>>>> hwirq:25), and the number can up to 200000+ per second.
>>>> (sorry for my express fault, the large number of unnecessary
>>>> maintenance interrupts means this).
>>>
>>> That's really odd, as we disable that interrupt before exiting HYP (you
>>> should never see that counter increasing). So either your GIC is
>>> incredibly slow (it fails to retire the interrupt in a timely manner),
>>> or it is configured as an Edge interrupt (and thus cannot be retired).
>>>
>>> Could you please investigate the last point? Also, do you see warnings
>>> from the virtual timer (something about unexpected interrupts)?
>>
>>
>> Yes, just like your said, it's a known defect on hisilicon D03 board,
>> and the that counter of maintenance interrupt does not increase on
>> hisilicon D05 board.
> 
> Can you please answer my question about the configuration (edge or
> level) of the maintenance interrupt?


The dts file GIC node:
        interrupt-controller@6d000000 {
                compatible = "hisilicon,gic-v3";
                #interrupt-cells = <0x3>;
                #address-cells = <0x2>;
                #size-cells = <0x2>;
                interrupts = <0x1 0x9 0xff04>;

The interrupt configuration is level triggered.

Thanks.

> 
>>
>>>
>>>>
>>>>>
>>>>> At the point where we restore the vgic state, interrupts are disabled.
>>>>> And by the time we enter the guest, we fully expect the HW to be in a
>>>>> stable state, and no spurious interrupt would be delivered.
>>>>
>>>>
>>>> At that point where restore the vgic state, it's true that
>>>> interrupts are disabled (local_irq_disable),
>>>> but in my opinion, here maybe a maintenance interrupt pending at
>>>> physical redist (at that point it can be delivered).
>>>> and it will be delivered at the moment that current vcpu's ctxt
>>>> restore and entry (eret, here, PSTATE.I maybe unmask).
>>>> Thus, the vcpu will be kicked out immediately. At the next vgic
>>>> state restore point, go round and begin again.
>>>
>>> I understand what happens when the interrupt is observed, but I want to
>>> understand why it is observed.
>>
>>
>> The ICH_HCR_EL2.UIE, spec says that:
>> Underflow Interrupt Enable. Enables the signaling of a maintenance
>> interrupt when the List
>> registers are empty, or hold only one valid entry.
>>
>> After the commit (b40c4892) , we clear the ICH_LRn when save the vgic state.
>> At next vgic restore point, if ICH_HCR_EL2.UIE = 1,  and ICH_LRn is all clear,
>> I think here will be a maintenance interrupt triggered when ICH_HCR
>> restore early than ICH_LRn restore.
> 
> I have a rather precise idea of how things work, and I've understood
> your point from your first email. I'm trying to understand why you're
> the only person having reported this. So can you please answer the above
> question?
> 
> Thanks,
> 
>         M.
