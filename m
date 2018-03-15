From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: VGIC MMIO: add missing irq_lock
Date: Thu, 15 Mar 2018 10:06:23 +0000
Message-ID: <d0453520-a27b-7efe-83ee-ad96ac16d061@arm.com>
References: <20180306092106.13044-1-andre.przywara@arm.com>
 <20180313010045.GC16740@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180313010045.GC16740@lvm>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

(sorry for the delay, forgot this in my draft folder)

On 13/03/18 01:00, Christoffer Dall wrote:
> On Tue, Mar 06, 2018 at 09:21:06AM +0000, Andre Przywara wrote:
>> Our irq_is_pending() helper function accesses multiple members of the
>> vgic_irq struct, so we need to hold the lock when calling it.
> 
> For the record I don't think this is necessarily a completely valid
> conclusion.  The fact that you access multiple members of a struct is a
> good indication that it might be a good idea to hold a lock, but it's
> not as simple as that.
> 
> I think the only thing that could happen here is that a caller
> mistakenly evaluates line_level when it shouldn't, but that would only
> happen when changing the configuration of an irq from level to edge,
> while the line_level is high, expecting the line_level to go down, and
> the pending state to be subsequently reported as false, but we only
> support changing the configuration of an interrupt when it's disabled,
> and as a result this can only affect reads of the PENDR registers.
> 
>> Add that requirement as a comment to the definition and take the lock
>> around the call in vgic_mmio_read_pending(), where we were missing it
>> before.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> Note, I'm fine with this change, but I don't agree with the rationale.
> The rationale is to take the lock on every use for consistency and to
> make the code easier to reason about, but it's possible that some future
> analysis in the future would relax this requirement if essential for
> performance.

  ^^^^^^^^^^^   vgic_mmio_read_pending  ;-)

So while I agree that one can build a case on why the *current* code
might be actually safe without the lock, I think this is a very fragile
approach. As documented, the lock protects the consistency of the
members of the data structure. Full stop. So whenever we access
multiple members, we should take the lock.
If - and only if - we:
- get a lot of contention on the lock, and
- we care about this, and
- we can prove that it's safe without the lock
*then* it would be fine to remove this. And it would need to be heavily
documented, possibly even with BUG()s.

Everything else looks like premature optimisation that even might break
in the future once we for instance extend irq_is_pending() for whatever
reason. Even today I am not sure that just reading
"irq->pending_latch || irq->line_level" is safe without a lock,
regardless of the configuration state.

In this particular case all other users take the lock, so this looked
like a case where we have just forgotten this.
And as hinted above, ISPENDR in a guest is probably not a frequently
accessed register.

I believe we don't disagree on the matter, actually, but I'd be cautious
and rather take the lock than avoid it, if in doubt.

Cheers,
Andre.

>> ---
>>  virt/kvm/arm/vgic/vgic-mmio.c | 3 +++
>>  virt/kvm/arm/vgic/vgic.h      | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index 83d82bd7dc4e..dbe99d635c80 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -113,9 +113,12 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>>  	/* Loop over all IRQs affected by this read */
>>  	for (i = 0; i < len * 8; i++) {
>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +		unsigned long flags;
>>  
>> +		spin_lock_irqsave(&irq->irq_lock, flags);
>>  		if (irq_is_pending(irq))
>>  			value |= (1U << i);
>> +		spin_unlock_irqrestore(&irq->irq_lock, flags);
>>  
>>  		vgic_put_irq(vcpu->kvm, irq);
>>  	}
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 12c37b89f7a3..5b11859a1a1e 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -96,6 +96,7 @@
>>  /* we only support 64 kB translation table page size */
>>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
>>  
>> +/* Requires the irq_lock to be held by the caller. */
>>  static inline bool irq_is_pending(struct vgic_irq *irq)
>>  {
>>  	if (irq->config == VGIC_CONFIG_EDGE)
>> -- 
>> 2.14.1
>>
