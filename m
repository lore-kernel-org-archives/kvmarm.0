From: Heyi Guo <guoheyi@huawei.com>
Subject: Re: Unexpected interrupt received in Guest OS when booting after
 "system_reset"
Date: Fri, 29 Mar 2019 09:19:22 +0800
Message-ID: <9694b5f2-80bd-b85c-8fc5-bd1d917e1b33@huawei.com>
References: <e8ffbc4e-f7b7-14a1-7614-a3db85c9152f@huawei.com>
 <9a6ece7e-9984-dc9e-8fa2-df9736393dd2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 548F44A417
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 21:19:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MTX7NfyJKNvu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 21:19:35 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DED924A2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 21:19:34 -0400 (EDT)
In-Reply-To: <9a6ece7e-9984-dc9e-8fa2-df9736393dd2@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2019/3/29 1:18, Marc Zyngier wrote:
> [Please do not send HTML emails]
Sorry; will keep in mind next time :)
>
> On 28/03/2019 15:44, Heyi Guo wrote:
>> Hi Marc and Christoffer,
>>
>> When we issue "system_reset" from qemu monitor to a running VM, guest
>> Linux will occasionally get "Unexpected interrupt" after rebooting, with
>> kernel message at the bottom.
>>
>> After some investigation, we found it might be caused by the
>> preservation of virtual LPI during system reset: it seems the virtual
>> LPI remains in the ap_list during VM reset, as well as its "enabled" and
>> "pending_latch" status, and this causes the virtual LPI to be injected
>> wrongly after VCPU reboots and enables interrupt.
>>
>> We propose to clear "enabled" flag of virtual LPI when PROPBASER (or
>> GICR_CTRL) of virtual GICR is written to 0, and update virtual LPI
>> properties when GICR_CTRL.enableLPIs is set to 1 again.
>>
>> Any advice? Or did we miss something?
> We're clearly missing a trick here, but I'm not convinced of your
> approach.
To be honest, we were not fully convinced by ourselves either. I was worrying about guest switching GICR_CTRL or GICR_PROPBASER at runtime which probably causes issue for our rough approach.

> What should happend is that the redistributors should be reset
> as well, and that this should recall any LPI that has been made pending.
> Unfortunately, we don't seem to have such code in place, which is
> embarrassing.
>
> Can you give the following, untested patch a go? It isn't right either,
> but it should have the right effect. If you confirm that it solves your
> problem, we can look at adding the right hooks...
Thanks, I'll test this and get back to you.
Heyi

> Thanks,
>
> 	M.
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index ab3f47745d9c..bd9a9250f323 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2403,8 +2403,32 @@ static int vgic_its_commit_v0(struct vgic_its *its)
>   	return 0;
>   }
>   
> +static void vgic_nuke_pending_lpis(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_irq *irq, *tmp;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
> +
> +	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
> +		if (irq->intid >= VGIC_MIN_LPI) {
> +			list_del(&irq->ap_list);
> +			vgic_put_irq(vcpu->kvm, irq);
> +		}
> +	}
> +
> +	raw_spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
> +}
> +
>   static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
>   {
> +	struct kvm_vcpu *vcpu;
> +	int c;
> +
> +	kvm_for_each_vcpu(c, vcpu, kvm)
> +		vgic_nuke_pending_lpis(vcpu);
> +
>   	/* We need to keep the ABI specific field values */
>   	its->baser_coll_table &= ~GITS_BASER_VALID;
>   	its->baser_device_table &= ~GITS_BASER_VALID;
>
