From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm64: vgic-its: Make updates to
 propbaser/pendbaser atomic
Date: Tue, 9 Aug 2016 12:19:53 +0100
Message-ID: <35bd94e0-949f-d1bd-9014-1cd6bfb9e5ab@arm.com>
References: <20160803161325.14933-1-christoffer.dall@linaro.org>
 <20160803161325.14933-4-christoffer.dall@linaro.org>
 <28496b0a-6ca3-4cba-ca53-d97aabfe9280@arm.com> <20160809103012.GD9175@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA804053F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:11:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QUVS9R4W9JG3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 07:11:44 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (unknown [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B0840402
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:11:43 -0400 (EDT)
In-Reply-To: <20160809103012.GD9175@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 09/08/16 11:30, Christoffer Dall wrote:
> On Mon, Aug 08, 2016 at 02:30:38PM +0100, Andre Przywara wrote:
>> Hi,
>>
>> On 03/08/16 17:13, Christoffer Dall wrote:
>>> There are two problems with the current implementation of the MMIO
>>> handlers for the propbaser and pendbaser:
>>>
>>> First, the write to the value itself is not guaranteed to be an atomic
>>> 64-bit write so two concurrent writes to the structure field could be
>>> intermixed.
>>>
>>> Second, because we do a read-modify-update operation without any
>>> synchronization, if we have two 32-bit accesses to separate parts of the
>>> register, we can loose one of them.
>>
>> I am still not 100% convinced that this is necessary, but leave it up to
>> the judgement of you senior guys.
> 
> ok, consider this case:
> 
>     reg = 0x55555555 55555555;
> 
>     CPU 0                CPU 1
>     -----                -----
>     tmp = reg;
>                          tmp = reg;
>     tmp[63:32] = ~0;
>                          tmp[31:0] = 0;
>     reg = tmp;
>                          reg = tmp;
> 
>     print("reg is %x", reg);
>       /* reg is 0x55555555 00000000 */
> 
> which is weird, because I think in hardware you'll get:
>     0xffffffff 00000000
> 
> no matter how you order the two 32-bit updates.
> 
> That is, unless the architecture tells us that you could observe the
> above behavior.

OK, I can see that this case is indeed broken. I was just wondering how
much software can expect if it allows unsynchronized accesses from
different CPUs to such a 64-bit register - even if it is for separate
halves of that register. I'd expect (guest) software to take a lock if
it can't atomically update prop/pendbaser and there are other agents
possibly chiming in.
And I hope we sanitize them enough now to avoid any bad things to happen
in the kernel ;-)

>>
>>> We can take the KVM mutex to synchronize accesses to these registers.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index ff668e0..e38b7a0 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -306,16 +306,19 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
>>>  {
>>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>> -	u64 propbaser = dist->propbaser;
>>> +	u64 propbaser;
>>>  
>>>  	/* Storing a value with LPIs already enabled is undefined */
>>>  	if (vgic_cpu->lpis_enabled)
>>>  		return;
>>>  
>>> +	mutex_lock(&vcpu->kvm->lock);
>>
>> I see that kvm->lock is becoming problematic in the future, since the
>> userland save/restore path for GICv2 is taking this lock as well. So we
>> have to come up with something better once we use migration on
>> GICv3/ITS. I have the gut feeling we need an extra lock for those two
>> registers.
> 
> that's why I started with a distributor lock, but you talked my out of
> it on IRC.  I'll just change this patch to introduce the distributor
> lock.  It's ok to have that as long as we don't grab it all over, which
> we won't.
> 
>> But this is not an issue for the purpose of this fix in the current code
>> base.
>>
>> Do we need to add the kvm->lock to our locking order documentation?
>>
> 
> I'll think about this.
> 
>>> +	propbaser = dist->propbaser;
>>>  	propbaser = update_64bit_reg(propbaser, addr & 4, len, val);
>>>  	propbaser = vgic_sanitise_propbaser(propbaser);
>>>  
>>>  	dist->propbaser = propbaser;
>>> +	mutex_unlock(&vcpu->kvm->lock);
>>>  }
>>>  
>>>  static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
>>> @@ -331,16 +334,19 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>>>  				     unsigned long val)
>>>  {
>>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>> -	u64 pendbaser = vgic_cpu->pendbaser;
>>> +	u64 pendbaser;
>>>  
>>>  	/* Storing a value with LPIs already enabled is undefined */
>>>  	if (vgic_cpu->lpis_enabled)
>>>  		return;
>>>  
>>> +	mutex_lock(&vcpu->kvm->lock);
>>> +	pendbaser = vgic_cpu->pendbaser;
>>>  	pendbaser = update_64bit_reg(pendbaser, addr & 4, len, val);
>>>  	pendbaser = vgic_sanitise_pendbaser(pendbaser);
>>>  
>>>  	vgic_cpu->pendbaser = pendbaser;
>>> +	mutex_unlock(&vcpu->kvm->lock);
>>>  }
>>>  
>>>  /*
>>>
>>
>> I checked all hits of 'git grep "kvm->lock"' (minus
>> arch/<some_obscure_arch>), and apart from that above mentioned GICv2
>> save/restore path couldn't find anything that looks prone to deadlocks
>> (on the first glance).
>> Also I enabled some locking checks in .config and am running three SMP
>> guests with ITS emulation simultaneously at the moment: the kernel
>> didn't complain so far.
>>
>> So this looks like a safe change to me.
>>
>> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> 
> Thanks for doing that.  It should be trivial to verify that this works
> with a dedicated distributor lock as well though.

Indeed it should be much easier. I think those two registers are special
because they affect the whole system (not just one ITS) and are not
interrupt specific as most of the distributor registers. And they are
the only writeable redistributor registers we actually implement.
That's why I was reluctant to re-introduce a BKL style dist lock for
just those two.

Looking forward to your cmpxchg solution ;-)

Cheers,
Andre.
