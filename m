From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 01/15] KVM: arm/arm64: VGIC: don't track used LRs in
 the distributor
Date: Wed, 2 Sep 2015 10:00:02 +0100
Message-ID: <55E6BA92.9020906@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
 <55CB0B80.5040508@linaro.org> <55DB474F.7010202@arm.com>
 <55E41383.2000109@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0F1412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 04:59:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0RnLPoSMl5ol for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 04:59:54 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FBE2412DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 04:59:54 -0400 (EDT)
In-Reply-To: <55E41383.2000109@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/08/15 09:42, Eric Auger wrote:
> On 08/24/2015 06:33 PM, Andre Przywara wrote:

Salut Eric,

...

>>>> @@ -1126,9 +1124,9 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu=
 *vcpu, int irq,
>>>>   */
>>>>  bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
>>>>  {
>>>> -   struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
>>>>     struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
>>>> -   struct vgic_lr vlr;
>>>> +   u64 elrsr =3D vgic_get_elrsr(vcpu);
>>>> +   unsigned long *elrsr_ptr =3D u64_to_bitmask(&elrsr);
>>>>     int lr;
>>>>
>>>>     /* Sanitize the input... */
>>>> @@ -1138,42 +1136,20 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 =
sgi_source_id, int irq)
>>>>
>>>>     kvm_debug("Queue IRQ%d\n", irq);
>>>>
>>>> -   lr =3D vgic_cpu->vgic_irq_lr_map[irq];
>>>> -
>>>> -   /* Do we have an active interrupt for the same CPUID? */
>>>> -   if (lr !=3D LR_EMPTY) {
>>>> -           vlr =3D vgic_get_lr(vcpu, lr);
>>>> -           if (vlr.source =3D=3D sgi_source_id) {
>>>> -                   kvm_debug("LR%d piggyback for IRQ%d\n", lr, vlr.ir=
q);
>>>> -                   BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
>>>> -                   vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>>>> -                   return true;
>>>> -           }
>>>> -   }
>>>> +   lr =3D find_first_bit(elrsr_ptr, vgic->nr_lr);
>>>>
>>>> -   /* Try to use another LR for this interrupt */
>>>> -   lr =3D find_first_zero_bit((unsigned long *)vgic_cpu->lr_used,
>>>> -                          vgic->nr_lr);
>>>>     if (lr >=3D vgic->nr_lr)
>>>>             return false;
>>>>
>>>>     kvm_debug("LR%d allocated for IRQ%d %x\n", lr, irq, sgi_source_id);
>>>> -   vgic_cpu->vgic_irq_lr_map[irq] =3D lr;
>>>> -   set_bit(lr, vgic_cpu->lr_used);
>>>>
>>>> -   vlr.irq =3D irq;
>>>> -   vlr.source =3D sgi_source_id;
>>>> -   vlr.state =3D 0;
>>>> -   vgic_queue_irq_to_lr(vcpu, irq, lr, vlr);
>>>> +   vgic_queue_irq_to_lr(vcpu, irq, lr, sgi_source_id);
>>>>
>>>>     return true;
>>>>  }
>>>>
>>>>  static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
>>>>  {
>>>> -   if (!vgic_can_sample_irq(vcpu, irq))
>>>> -           return true; /* level interrupt, already queued */
>>>> -
>>> I think that change needs to be introduced in a separate patch as the
>>> other one mentioned above and justified since it affects the state mach=
ine.
>>
>> But this change is dependent on this patch: it will not work without
>> this patch and this patch will not work without that change.
>> So the idea is that on returning from the guest we now harvest all
>> _used_ LRs by copying their state back into the distributor. The
>> previous behaviour was to just check _unused_ LRs for completed IRQs.
>> So now all IRQs need to be re-inserted into the LRs before the next
>> guest run, that's why we have to remove the test which skipped this for
>> IRQs where the code knew that they were still in the LRs.
>> Does that make sense?
> In level sensitive case, what if the IRQ'LR state was active. LR was
> kept intact. IRQ is queued. With previous code we wouldn't inject a new
> IRQ. Here aren't we going to inject it?

Effectively we only inject _pending_ IRQs: I was going forth and back
through the current code and couldn't find a place where we actually
make use of any active-only interrupt - the only exception being
migration, where we explicitly iterate through all LRs again and pick up
active-only IRQs as well. We never set the active state except there.

So I decided to keep only-active IRQs in the LRs and do not propagate
them back into the emulated distributor state. One reason is that we
don't use it, which makes the code look silly and secondly we avoid the
issue you described above.

> In the sync when you move the IRQ from the LR reg to the state variable,
> shouldn't you reset the queued state for level sensitive case? In such a
> case I think you could keep that check.

We keep them as "queued" in our emulation until they become inactive and
we clear the queued bit in the EOI handler.

Admittedly this whole approach is not obvious and it's perfectly
possible that I missed something. So please can you check and confirm my
assumptions above?

Merci,
Andr=E9
