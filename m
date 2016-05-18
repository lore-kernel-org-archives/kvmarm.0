From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 32/56] KVM: arm/arm64: vgic-new: Add SGIPENDR register
 handlers
Date: Wed, 18 May 2016 14:31:18 +0100
Message-ID: <573C6EA6.90803@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-33-git-send-email-andre.przywara@arm.com>
 <20160518131449.GI3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AFBD4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 09:27:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-Q3G7taCXMn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 09:27:30 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F9C410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 09:27:29 -0400 (EDT)
In-Reply-To: <20160518131449.GI3827@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 18/05/16 14:14, Christoffer Dall wrote:
> On Mon, May 16, 2016 at 10:53:20AM +0100, Andre Przywara wrote:
>> As this register is v2 specific, its implementation lives entirely
>> in vgic-mmio-v2.c.
>> This register allows setting the source mask of an IPI.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>> Changelog RFC..v1:
>> - remove IRQ lock from read handler
>> - update pending bit on setting the first / clearing the last bit
>> - queue virtual IRQ if necessary
>>
>> Changelog v1 .. v2:
>> - adapt to new MMIO framework
>>
>> Changelog v3 .. v4:
>> - specify accessor width
>>
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 62 +++++++++++++++++++++++++++++++++=
+++++--
>>  1 file changed, 60 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-m=
mio-v2.c
>> index c884e9b..3925d4c 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -146,6 +146,64 @@ static void vgic_mmio_write_target(struct kvm_vcpu =
*vcpu,
>>  	}
>>  }
>>  =

>> +static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
>> +					    gpa_t addr, unsigned int len)
>> +{
>> +	u32 intid =3D addr & 0x0f;
> =

> is there a reason why we cannot use the magic macro here?

I wasn't sure about this, because it's not covering all 1024 interrupts,
but just SGIs, so it's always fixed to 16 interrupts =E1 8 bits. The
default mask would be too big in this case.
I guess it would work anyway because this region is limited to 16 bytes
in our description, so we could use this here anyway to make it more
aligned with the other handlers, maybe adding a comment about the
difference?

Cheers,
Andre.

> =

>> +	int i;
>> +	u64 val =3D 0;
>> +
>> +	for (i =3D 0; i < len; i++) {
>> +		struct vgic_irq *irq =3D vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		val |=3D (u64)irq->source << (i * 8);
>> +	}
>> +	return val;
>> +}
>> +
>> +static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
>> +				     gpa_t addr, unsigned int len,
>> +				     unsigned long val)
>> +{
>> +	u32 intid =3D addr & 0x0f;
>> +	int i;
>> +
>> +	for (i =3D 0; i < len; i++) {
>> +		struct vgic_irq *irq =3D vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		irq->source &=3D ~((val >> (i * 8)) & 0xff);
>> +		if (!irq->source)
>> +			irq->pending =3D false;
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +	}
>> +}
>> +
>> +static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>> +				     gpa_t addr, unsigned int len,
>> +				     unsigned long val)
>> +{
>> +	u32 intid =3D addr & 0x0f;
>> +	int i;
>> +
>> +	for (i =3D 0; i < len; i++) {
>> +		struct vgic_irq *irq =3D vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		irq->source |=3D (val >> (i * 8)) & 0xff;
>> +
>> +		if (irq->source) {
>> +			irq->pending =3D true;
>> +			vgic_queue_irq_unlock(vcpu->kvm, irq);
>> +		} else {
>> +			spin_unlock(&irq->irq_lock);
>> +		}
>> +	}
>> +}
>> +
>>  static const struct vgic_register_region vgic_v2_dist_registers[] =3D {
>>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
>> @@ -184,10 +242,10 @@ static const struct vgic_register_region vgic_v2_d=
ist_registers[] =3D {
>>  		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4,
>>  		VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
>> +		vgic_mmio_read_sgipend, vgic_mmio_write_sgipendc, 16,
>>  		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
>>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
>> +		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16,
>>  		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
>>  };
>>  =

>> -- =

>> 2.8.2
>>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> =
