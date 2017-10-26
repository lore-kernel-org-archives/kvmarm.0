From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 17/26] KVM: arm/arm64: GICv4: Propagate VLPI properties
 at map time
Date: Thu, 26 Oct 2017 09:21:53 +0100
Message-ID: <86po9ab9pa.fsf@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-18-marc.zyngier@arm.com>
 <20171025164827.GO91785@lvm> <86tvynb1rm.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F7649D23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 04:20:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XtQbbYMjKKEk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Oct 2017 04:20:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 011D5406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 04:20:35 -0400 (EDT)
In-Reply-To: <86tvynb1rm.fsf@arm.com> (Marc Zyngier's message of "Wed, 25 Oct
 2017 18:01:01 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 25 2017 at  6:01:01 pm BST, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Wed, Oct 25 2017 at  6:48:27 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
>> On Fri, Oct 06, 2017 at 04:33:52PM +0100, Marc Zyngier wrote:
>>> When the VLPI gets mapped, it must inherit the configuration of
>>> the LPI configured at the vITS level. For that purpose, let's make
>>> update_lpi_config globally available and call it just after
>>> having performed the VLPI map operation.
>>> 
>>> Acked-by: Christoffer Dall <cdall@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 6 ++----
>>>  virt/kvm/arm/vgic/vgic-v4.c  | 2 ++
>>>  virt/kvm/arm/vgic/vgic.h     | 2 ++
>>>  3 files changed, 6 insertions(+), 4 deletions(-)
>>> 
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index eb72eb027060..f434748439ee 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -37,8 +37,6 @@
>>>  static int vgic_its_save_tables_v0(struct vgic_its *its);
>>>  static int vgic_its_restore_tables_v0(struct vgic_its *its);
>>>  static int vgic_its_commit_v0(struct vgic_its *its);
>>> -static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>> -			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
>>>  
>>>  /*
>>>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
>>> @@ -272,8 +270,8 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
>>>   * If filter_vcpu is not NULL, applies only if the IRQ is targeting this
>>>   * VCPU. Unconditionally applies if filter_vcpu is NULL.
>>>   */
>>> -static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>> -			     struct kvm_vcpu *filter_vcpu, bool needs_inv)
>>> +int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>> +		      struct kvm_vcpu *filter_vcpu, bool needs_inv)
>>>  {
>>>  	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>>>  	u8 prop;
>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>> index ba1dd3162eba..b79a0450bb1c 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>> @@ -147,6 +147,8 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>>  	irq->hw		= true;
>>>  	irq->host_irq	= virq;
>>>  
>>> +	/* Force the property update and invalidate */
>>> +	update_lpi_config(kvm, irq, NULL, true);
>>
>> Actually, when re-reading this patch, this looks weird to me.
>>
>> I think this needs to either be done as part of the map, or before the
>> map, to prevent for example a disabled interrupt from the guest'ss PoV
>> to fire when it doesn't expect it.
>
> Indeed, that's a good point. I don't really like making it part of the
> VLPI mapping, as this is an ITS thing (and the property update is more a
> redistributor concept), but moving it it before the map is probably the
> best thing to do. Thanks for pointing this out!

Scratch that. Doing it before the map cannot succeed, as the ITS driver
explicitly refuses to do any VLPI changes until this is actually mapped
(which is a completely unreasonable behaviour).

I guess that leaves setting the properties as part of the map operation
the only viable choice. I'll give it a go.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
