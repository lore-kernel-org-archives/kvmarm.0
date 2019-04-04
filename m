From: "Tangnianyao (ICT)" <tangnianyao@huawei.com>
Subject: Re: [RFC] Question about enable doorbell irq and halt_poll process
Date: Thu, 4 Apr 2019 18:07:59 +0800
Message-ID: <e32d81ed-d1f5-ce0b-7845-d4b680d556df@huawei.com>
References: <0fb3c9ba-8428-ea6c-2973-952624f601cc@huawei.com>
 <20190320170219.510f2e1e@why.wild-wind.fr.eu.org>
 <5df934fd-06d5-55f2-68a5-6f4985e4ac1b@huawei.com>
 <86zhpc66jl.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86zhpc66jl.wl-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linuxarm@huawei.com, guoheyi@huawei.com, kvm@vger.kernel.org, xuwei5@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2019/3/30 17:43, Marc Zyngier wrote:

Hi, Marc

> On Sat, 30 Mar 2019 08:42:58 +0000,
> "Tangnianyao (ICT)" <tangnianyao@huawei.com> wrote:
>>
>> Hi, Marc
>>
>> On 2019/3/21 1:02, Marc Zyngier Wrote:
>>> On Tue, 19 Mar 2019 21:25:47 +0800
>>> "Tangnianyao (ICT)" <tangnianyao@huawei.com> wrote:
>>>
>>>> Hi, all
>>>>
>>>> Using gicv4, when guest is waiting for irq, it sends wfi and traps to kvm.
>>>> When vlpi is forwarded to PE after its_vpe_deschedule, before halt_poll in
>>>> kvm_vcpu_block, halt_poll may increase latency for this vlpi getting to guest.
>>>> In halt_poll process, it checks if there's pending irq for vcpu using pending_last.
>>>> However, doorbell is not enable at this moment and vlpi or doorbell can not set
>>>> pending_last true, to stop halt_poll. It will run until halt_poll time ends, if
>>>> there's no other physical irq coming in the meantime. And then vcpu is scheduled out.
>>>> This pending vlpi has to wait for vcpu getting schedule in next time.
>>>>
>>>> Should we enable doorbell before halt_poll process ?
>>>
>>> Enabling doorbells can be quite expensive. Depending on the HW, this is
>>> either:
>>>
>>> - a write to memory (+DSB, potential cache maintenance), a write to the
>>>   INVLPI register, and a poll of the SYNC register
>>> - a write to memory (+DSB, potential cache maintenance), potentially
>>>   a string of DISCARD+SYNC+MAPI+SYNC commands, and an INV+SYNC command
>>>
>> I have tested average cost of kvm_vgic_v4_enable_doorbell in our machine.
>> When gic_rdists->has_direct_lpi is 1, it costs 0.35 us.
>> When gic_rdists->has_direct_lpi is 0, it costs 1.4 us.
> 
> This looks pretty low. Which HW is that on? How about on something
> like D05?

I tested it on D06.
D05 doesn't not support gicv4 and I haven't tested on D05.

> 
>> Compared to default halt_poll_ns, 500000ns, enabling doorbells is not
>> large at all.
> 
> Sure. But I'm not sure this is a universal figure.
> 
>>
>>> Frankly, you want to be careful with that. I'd rather enable them late
>>> and have a chance of not blocking because of another (virtual)
>>> interrupt, which saves us the doorbell business.
>>>
>>> I wonder if you wouldn't be in a better position by drastically
>>> reducing halt_poll_ns for vcpu that can have directly injected
>>> interrupts.
>>>
>>
>> If we set halt_poll_ns to a small value, the chance of
>> not blocking and vcpu scheduled out becomes larger. The cost
>> of vcpu scheduled out is quite expensive.
>> In many cases, one pcpu is assigned to only
>> one vcpu, and halt_poll_ns is set quite large, to increase
>> chance of halt_poll process got terminated. This is the
>> reason we want to set halt_poll_ns large. And We hope vlpi
>> stop halt_poll process in time.
> 
> Fair enough. It is certainly realistic to strictly partition the
> system when GICv4 is in use, so I can see some potential benefit.
> 
>> Though it will check whether vcpu is runnable again by
>> kvm_vcpu_check_block. Vlpi can prevent scheduling vcpu out.
>> However it's somewhat later if halt_poll_ns is larger.
>>
>>> In any case, this is something that we should measure, not guess.
> 
> Please post results of realistic benchmarks that we can reproduce,
> with and without this change. I'm willing to entertain the idea, but I
> need more than just a vague number.
> 
> Thanks,
> 
> 	M.
> 

I tested it with and without change (patch attached in the last).
halt_poll_ns is keep default, 500000ns.
I have merged the patch "arm64: KVM: Always set ICH_HCR_EL2.EN if GICv4 is enabled"
to my test kernel, to make sure ICH_HCR_EL2.EN=1 in guest.

netperf result:
D06 as server, intel 8180 server as client
with change:
package 512 bytes - 5400 Mbits/s
package 64 bytes - 740 Mbits/s
without change:
package 512 bytes - 5000 Mbits/s
package 64 bytes - 710 Mbits/s

Also I have tested D06 as client, intel machine as server,
with the change, the result remains the same.


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 55fe8e2..0f56904 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2256,6 +2256,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	if (vcpu->halt_poll_ns) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);

+#ifdef CONFIG_ARM64
+		/*
+		 * When using gicv4, enable doorbell before halt pool wait
+		 * so that direct vlpi can stop halt poll.
+		 */
+		if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm) {
+			kvm_vgic_v4_enable_doorbell(vcpu);
+		}
+#endif
+
 		++vcpu->stat.halt_attempted_poll;
 		do {
 			/*


Thanks,
Nianyao Tang		
