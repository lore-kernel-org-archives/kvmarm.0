From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v8 5/7] KVM: arm/arm64: Enable irqchip routing
Date: Fri, 22 Jul 2016 16:45:13 +0200
Message-ID: <3dc9986e-eaa1-4786-4921-736457dade56@redhat.com>
References: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
 <1469195200-6498-6-git-send-email-eric.auger@redhat.com>
 <20160722142401.GC9019@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160722142401.GC9019@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim

On 22/07/2016 16:24, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-22 13:46+0000, Eric Auger:
>> This patch adds compilation and link against irqchip.
>>
>> Main motivation behind using irqchip code is to enable MSI
>> routing code. In the future irqchip routing may also be useful
>> when targeting multiple irqchips.
>>
>> Routing standard callbacks now are implemented in vgic-irqfd:
>> - kvm_set_routing_entry
>> - kvm_set_irq
>> - kvm_set_msi
>>
>> They only are supported with new_vgic code.
>>
>> Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
>> KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed=
=2E
>>
>> So from now on IRQCHIP routing is enabled and a routing table entry
>> must exist for irqfd injection to succeed for a given SPI. This patc=
h
>> builds a default flat irqchip routing table (gsi=3Dirqchip.pin) cove=
ring
>> all the VGIC SPI indexes. This routing table is overwritten by the
>> first first user-space call to KVM_SET_GSI_ROUTING ioctl.
>>
>> MSI routing setup is not yet allowed.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic=
-irqfd.c
>> @@ -17,36 +17,101 @@
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  #include <trace/events/kvm.h>
>> +#include <kvm/arm_vgic.h>
>> +#include "vgic.h"
>> =20
>> -int kvm_irq_map_gsi(struct kvm *kvm,
>> -		    struct kvm_kernel_irq_routing_entry *entries,
>> -		    int gsi)
>> +/**
>> + * vgic_irqfd_set_irq: inject the IRQ corresponding to the
>> + * irqchip routing entry
>> + *
>> + * This is the entry point for irqfd IRQ injection
>> + */
>> +static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *=
e,
>> +			struct kvm *kvm, int irq_source_id,
>> +			int level, bool line_status)
>>  {
>> -	return 0;
>> +	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
>> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
>> +
>> +	if (spi_id > min(dist->nr_spis, VGIC_MAX_SPI))
>=20
> This is more strict that vgic_valid_spi(), because spi_id between
> "dist->nr_spis" and "dist->nr_spis + VGIC_NR_PRIVATE_IRQS" is not
> allowed, which probably wasn't intended.
Hum yes you're right. This is wrong.
>=20
> And shouldn't nr_spis always be less that VGIC_MAX_SPI?
Correct. I will use vgic_valid_spi which was introduced to avoid such m=
ixup.

Thanks for noticing

Eric
>=20
> Thanks.
>=20
>> +		return -EINVAL;
>> +	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
>>  }
