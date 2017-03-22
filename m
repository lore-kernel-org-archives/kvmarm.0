From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v3 19/19] KVM: arm64: ITS: Pending table save/restore
Date: Wed, 22 Mar 2017 16:22:50 +0000
Message-ID: <8e1ed8a9-c371-2972-8f0a-ffe9760d24ac@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-20-git-send-email-eric.auger@redhat.com>
 <6e2f94c2-8afe-9b5f-d097-a43e168b95df@arm.com>
 <52a9896e-f8ec-05aa-7b0e-e7b9aa97df15@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11FF240625
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 12:21:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Tx3eA-3wLXM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 12:21:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B28B400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 12:21:49 -0400 (EDT)
In-Reply-To: <52a9896e-f8ec-05aa-7b0e-e7b9aa97df15@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/03/17 15:12, Auger Eric wrote:
> Hi Andre,
> 
> On 20/03/2017 19:21, Andre Przywara wrote:
>> Hi Eric,
>>
>> just fast-forwarded to the end and noticed this one:
>>
>>
>> On 06/03/17 11:34, Eric Auger wrote:
>>> Save and restore the pending tables.
>>>
>>> Pending table restore obviously requires the pendbaser to be
>>> already set.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>>
>>> v1 -> v2:
>>> - do not care about the 1st KB which should be zeroed according to
>>>   the spec.
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 71 ++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 69 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 27ebabd..24824be 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -1736,7 +1736,48 @@ static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>>   */
>>>  static int vgic_its_flush_pending_tables(struct vgic_its *its)
>>>  {
>>> -	return -ENXIO;
>>> +	struct kvm *kvm = its->dev->kvm;
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	struct vgic_irq *irq;
>>> +	int ret;
>>> +
>>> +	/**
>>> +	 * we do not take the dist->lpi_list_lock since we have a garantee
>>> +	 * the LPI list is not touched while the its lock is held
>>
>> Can you elaborate on what gives us this guarantee? I see that we have a
>> locking *order*, but that doesn't mean we can avoid taking the lock. So
>> to me it looks like we need to take the lpi_list_lock spinlock here,
>> which unfortunately breaks the kvm_read_guest() calls below.
>>
>> If you agree on this, you can take a look at the INVALL implementation,
>> where I faced the same issue. The solution we came up with is
>> vgic_copy_lpi_list(), which you can call under the lock to create a
>> (private) copy of the LPI list, which you can later iterate without
>> holding the lock - and thus are free to call sleeping functions.
> 
> Yes the comment is wrong and at least I need to fix it. The its_lock
> prevents new commands to be absorbed but does not protect from a change
> of the pending status which is our interest here.
> 
> On the other hand, can't we simply consider the flush (and restore)
> cannot happen if the VM is in running state. In the current QEMU
> integration we wait for the VM to be paused before flushing the tables
> in guest RAM. Otherwise you will get some stall data anyway. So can't we
> simply document this requirement. I think the requirement is different
> from the INVALL's one. Does it make sense?

That's probably true, but then we should *enforce* this. Didn't we have
something like this somewhere (in the old VGIC?), where we collected all
VCPU locks to make sure nothing runs? This should then be checked upon
the flush and restore kvm_device ioctls.
And there should be comments on this, to not give people funny ideas. I
am sure Marc would love to see some BUG_ONs ;-)

Cheers,
Andre.

>>
>> Cheers,
>> Andre.
>>
>>> +	 */
>>> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>>> +		struct kvm_vcpu *vcpu;
>>> +		gpa_t pendbase, ptr;
>>> +		bool stored;
>>> +		u8 val;
>>> +
>>> +		vcpu = irq->target_vcpu;
>>> +		if (!vcpu)
>>> +			return -EINVAL;
>>> +
>>> +		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>>> +
>>> +		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
>>> +
>>> +		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
>>> +		if (ret)
>>> +			return ret;
>>> +
>>> +		stored = val & (irq->intid % BITS_PER_BYTE);
>>> +		if (stored == irq->pending_latch)
>>> +			continue;
>>> +
>>> +		if (irq->pending_latch)
>>> +			val |= 1 << (irq->intid % BITS_PER_BYTE);
>>> +		else
>>> +			val &= ~(1 << (irq->intid % BITS_PER_BYTE));
>>> +
>>> +		ret = kvm_write_guest(kvm, (gpa_t)ptr, &val, 1);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>> +
>>> +	return 0;
>>>  }
>>>  
>>>  /**
>>> @@ -1745,7 +1786,33 @@ static int vgic_its_flush_pending_tables(struct vgic_its *its)
>>>   */
>>>  static int vgic_its_restore_pending_tables(struct vgic_its *its)
>>>  {
>>> -	return -ENXIO;
>>> +	struct vgic_irq *irq;
>>> +	struct kvm *kvm = its->dev->kvm;
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	int ret;
>>> +
>>> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>>> +		struct kvm_vcpu *vcpu;
>>> +		gpa_t pendbase, ptr;
>>> +		u8 val;
>>> +
>>> +		vcpu = irq->target_vcpu;
>>> +		if (!vcpu)
>>> +			return -EINVAL;
>>> +
>>> +		if (!(vcpu->arch.vgic_cpu.pendbaser & GICR_PENDBASER_PTZ))
>>> +			return 0;
>>> +
>>> +		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>>> +
>>> +		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
>>> +
>>> +		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
>>> +		if (ret)
>>> +			return ret;
>>> +		irq->pending_latch = val & (1 << (irq->intid % BITS_PER_BYTE));
>>> +	}
>>> +	return 0;
>>>  }
>>>  
>>>  static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
>>>
