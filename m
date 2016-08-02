From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: ITS: return 1 on successful MSI injection
Date: Tue, 2 Aug 2016 13:28:44 +0100
Message-ID: <57A091FC.9070607@arm.com>
References: <20160802111058.31496-1-andre.przywara@arm.com>
 <20160802122309.GH32244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC60411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 08:22:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SGy7TmgZ8zIz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Aug 2016 08:22:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0424113E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 08:22:00 -0400 (EDT)
In-Reply-To: <20160802122309.GH32244@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/08/16 13:23, Christoffer Dall wrote:
> On Tue, Aug 02, 2016 at 12:10:58PM +0100, Andre Przywara wrote:
>> According to the KVM API documentation a successful MSI injection
>> should return a value > 0 on success.
>> Since we pass the return value of vgic_its_inject_msi() directly on
>> to upper layers and userland, we need to use the same semantics here.
>> Briefly tested with QEMU and kvmtool on GICv3 hardware and the model.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Applies on top of next-20160728. Let me know if I should use a
>> different base.
>>
>> Cheers,
>> Andre.
>>
>>  virt/kvm/arm/vgic/vgic-its.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 07411cf..3268250 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -468,6 +468,7 @@ static void vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
>>   * Queries the KVM IO bus framework to get the ITS pointer from the given
>>   * doorbell address.
>>   * We then call vgic_its_trigger_msi() with the decoded data.
>> + * According to the KVM_SIGNAL_MSI API description returns > 0 on success.
>>   */
>>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>>  {
>> @@ -493,7 +494,7 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>>  	vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
>>  	mutex_unlock(&iodev->its->its_lock);
>>  
>> -	return 0;
>> +	return 1;
>>  }
>>  
>>  /* Requires the its_lock to be held. */
> 
> Do we have a clear understanding of what 'guest blocked the MSI'
> constitutes in the ARM world?

I would define it as "the guest has not configured the ITS so that the
corresponding LPI could be successfully delivered". Which is any of the
conditions where the interrupt cannot make it into the pending table,
and is dropped on the floor.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
