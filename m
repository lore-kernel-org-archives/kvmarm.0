From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 08/15] KVM: arm64: introduce ITS emulation file with
 stub functions
Date: Tue, 25 Aug 2015 10:39:45 +0100
Message-ID: <55DC37E1.6060401@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-9-git-send-email-andre.przywara@arm.com>
 <55CC921B.503@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55CC921B.503@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Salut Eric,

=2E...

>> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul=
=2Ec
>> index 5269ad1..f5865e7 100644
>> --- a/virt/kvm/arm/vgic-v3-emul.c
>> +++ b/virt/kvm/arm/vgic-v3-emul.c
>> @@ -48,6 +48,7 @@
>>  #include <asm/kvm_mmu.h>
>> =20
>>  #include "vgic.h"
>> +#include "its-emul.h"
>> =20
>>  static bool handle_mmio_rao_wi(struct kvm_vcpu *vcpu,
>>  			       struct kvm_exit_mmio *mmio, phys_addr_t offset)
>> @@ -530,9 +531,20 @@ static bool handle_mmio_ctlr_redist(struct kvm_=
vcpu *vcpu,
>>  				    struct kvm_exit_mmio *mmio,
>>  				    phys_addr_t offset)
>>  {
>> -	/* since we don't support LPIs, this register is zero for now */
>> -	vgic_reg_access(mmio, NULL, offset,
>> -			ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
>> +	struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
>> +	u32 reg;
>> +
>> +	if (!vgic_has_its(vcpu->kvm)) {
>> +		vgic_reg_access(mmio, NULL, offset,
>> +				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
>> +		return false;
>> +	}
> can't we remove above block and ...
>> +	reg =3D dist->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
>> +	vgic_reg_access(mmio, &reg, offset,
>> +			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
>> +	if (!dist->lpis_enabled && (reg & GICR_CTLR_ENABLE_LPIS
> add vgic_has_its(vcpu->kvm) && above?

Yeah, makes some sense. Changed that.
>=20
> Besides Reviewed-by: Eric Auger <eric.auger@linaro.org>

Merci!

Andr=E9

>=20
> Eric
> )) {
>> +		/* Eventually do something */
>> +	}
>>  	return false;
>>  }
>> =20
>> @@ -861,6 +873,12 @@ static int vgic_v3_map_resources(struct kvm *kv=
m,
>>  		rdbase +=3D GIC_V3_REDIST_SIZE;
>>  	}
>> =20
>> +	if (vgic_has_its(kvm)) {
>> +		ret =3D vits_init(kvm);
>> +		if (ret)
>> +			goto out_unregister;
>> +	}
>> +
>>  	dist->redist_iodevs =3D iodevs;
>>  	dist->ready =3D true;
>>  	goto out;
>>
>=20
