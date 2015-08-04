From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 06/11] KVM: arm/arm64: vgic: Allow dynamic mapping
 of physical/virtual interrupts
Date: Tue, 04 Aug 2015 19:10:55 +0100
Message-ID: <55C1002F.6070801@arm.com>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com> <1437753309-17989-7-git-send-email-marc.zyngier@arm.com> <20150804130457.GA29335@cbox> <55C0D9C7.7060707@arm.com> <20150804173650.GG29335@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150804173650.GG29335@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/08/15 18:36, Christoffer Dall wrote:
> On Tue, Aug 04, 2015 at 04:27:03PM +0100, Marc Zyngier wrote:
>> On 04/08/15 14:04, Christoffer Dall wrote:
>>> On Fri, Jul 24, 2015 at 04:55:04PM +0100, Marc Zyngier wrote:
>>>> In order to be able to feed physical interrupts to a guest, we need
>>>> to be able to establish the virtual-physical mapping between the two
>>>> worlds.
>>>>
>>>> The mappings are kept in a set of RCU lists, indexed by virtual interrupts.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm/kvm/arm.c     |   2 +
>>>>  include/kvm/arm_vgic.h |  26 +++++++
>>>>  virt/kvm/arm/vgic.c    | 189 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  3 files changed, 216 insertions(+), 1 deletion(-)
>>>>

[...]

>>>> +/**
>>>> + * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
>>>> + * @vcpu: The VCPU pointer
>>>> + * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
>>>> + *
>>>> + * Remove an existing mapping between virtual and physical interrupts.
>>>> + */
>>>> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
>>>> +{
>>>> +     struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>> +     struct irq_phys_map_entry *entry;
>>>> +     struct list_head *root;
>>>> +
>>>> +     if (!map)
>>>> +             return -EINVAL;
>>>> +
>>>> +     root = vgic_get_irq_phys_map_list(vcpu, map->virt_irq);
>>>> +
>>>> +     spin_lock(&dist->irq_phys_map_lock);
>>>> +
>>>> +     list_for_each_entry(entry, root, entry) {
>>>> +             if (&entry->map == map && !map->deleted) {
>>>> +                     map->deleted = true;
>>>
>>> why do you need the 'deleted' flag?  You now search the list only after
>>> holding the lock, so the race I pointed out before doesn't exist
>>> anymore.  Is there an additional issue that the deleted flag is taking
>>> care of?
>>
>> This could still race with a destroy occuring before we take the lock,
>> and before we get get RCU to do the cleanup (the list would still be
>> populated).
>>
> 
> That's not how I understand list_del_rcu; I think it deletes the entry
> immediately with the right memory barriers.  It is only the free
> operation that happens on rcu sync and can be/is deferred.

Indeed. I stupidly though the two were deferred, but reading the code
definitely confirmed your point. I'll get rid of the delete stuff.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
