From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 09/15] KVM: arm64: implement basic ITS register handlers
Date: Tue, 25 Aug 2015 11:23:01 +0100
Message-ID: <55DC4205.5030806@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-10-git-send-email-andre.przywara@arm.com>
 <55CCB6EC.50609@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <55CCB6EC.50609@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Eric Auger <eric.auger@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Pavel Fedin <p.fedin@samsung.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

....

>> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
>> index 659dd39..b498f06 100644
>> --- a/virt/kvm/arm/its-emul.c
>> +++ b/virt/kvm/arm/its-emul.c
>> @@ -32,10 +32,62 @@
>>  #include "vgic.h"
>>  #include "its-emul.h"
>>
>> +#define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>> +
>> +/* The distributor lock is held by the VGIC MMIO handler. */
>>  static bool handle_mmio_misc_gits(struct kvm_vcpu *vcpu,
>>                                 struct kvm_exit_mmio *mmio,
>>                                 phys_addr_t offset)
>>  {
>> +     struct vgic_its *its =3D &vcpu->kvm->arch.vgic.its;
>> +     u32 reg;
>> +     bool was_enabled;
>> +
>> +     switch (offset & ~3) {
>> +     case 0x00:              /* GITS_CTLR */
>> +             /* We never defer any command execution. */
>> +             reg =3D GITS_CTLR_QUIESCENT;
>> +             if (its->enabled)
>> +                     reg |=3D GITS_CTLR_ENABLE;
>> +             was_enabled =3D its->enabled;
>> +             vgic_reg_access(mmio, &reg, offset & 3,
>> +                             ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
>> +             its->enabled =3D !!(reg & GITS_CTLR_ENABLE);
>> +             return !was_enabled && its->enabled;
>> +     case 0x04:              /* GITS_IIDR */
>> +             reg =3D (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
>> +             vgic_reg_access(mmio, &reg, offset & 3,
>> +                             ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
>> +             break;
>> +     case 0x08:              /* GITS_TYPER */
>> +             /*
>> +              * We use linear CPU numbers for redistributor addressing,
>> +              * so GITS_TYPER.PTA is 0.
>> +              * To avoid memory waste on the guest side, we keep the
>> +              * number of IDBits and DevBits low for the time being.
>> +              * This could later be made configurable by userland.
>> +              * Since we have all collections in linked list, we claim
>> +              * that we can hold all of the collection tables in our
>> +              * own memory and that the ITT entry size is 1 byte (the
>> +              * smallest possible one).
>> +              */
>> +             reg =3D GITS_TYPER_PLPIS;
>> +             reg |=3D 0xff << GITS_TYPER_HWCOLLCNT_SHIFT;
>> +             reg |=3D 0x0f << GITS_TYPER_DEVBITS_SHIFT;
>> +             reg |=3D 0x0f << GITS_TYPER_IDBITS_SHIFT;
>> +             vgic_reg_access(mmio, &reg, offset & 3,
>> +                             ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
>> +             break;
>> +     case 0x0c:
>> +             /* The upper 32bits of TYPER are all 0 for the time being.
>> +              * Should we need more than 256 collections, we can enable
>> +              * some bits in here.
>> +              */
>> +             vgic_reg_access(mmio, NULL, offset & 3,
>> +                             ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
>> +             break;
>> +     }
>> +
>>       return false;
>>  }
>>
>> @@ -43,20 +95,142 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu=
 *vcpu,
>>                                   struct kvm_exit_mmio *mmio,
>>                                   phys_addr_t offset)
>>  {
>> +     u32 reg =3D 0;
>> +     int idreg =3D (offset & ~3) + GITS_IDREGS_BASE;
>> +
>> +     switch (idreg) {
>> +     case GITS_PIDR2:
>> +             reg =3D GIC_PIDR2_ARCH_GICv3;
>> +             break;
>> +     case GITS_PIDR4:
>> +             /* This is a 64K software visible page */
>> +             reg =3D 0x40;
>> +             break;
>> +     /* Those are the ID registers for (any) GIC. */
>> +     case GITS_CIDR0:
>> +             reg =3D 0x0d;
>> +             break;
>> +     case GITS_CIDR1:
>> +             reg =3D 0xf0;
>> +             break;
>> +     case GITS_CIDR2:
>> +             reg =3D 0x05;
>> +             break;
>> +     case GITS_CIDR3:
>> +             reg =3D 0xb1;
>> +             break;
>> +     }
>> +     vgic_reg_access(mmio, &reg, offset & 3,
>> +                     ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
>>       return false;
>>  }
>>
>> +static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
>> +{
>> +     return -ENODEV;
>> +}
>> +
>>  static bool handle_mmio_gits_cbaser(struct kvm_vcpu *vcpu,
>>                                   struct kvm_exit_mmio *mmio,
>>                                   phys_addr_t offset)
>>  {
>> +     struct vgic_its *its =3D &vcpu->kvm->arch.vgic.its;
>> +     int mode =3D ACCESS_READ_VALUE;
>> +
>> +     mode |=3D its->enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
>> +
>> +     vgic_handle_base_register(vcpu, mmio, offset, &its->cbaser, mode);
>> +
>> +     /* Writing CBASER resets the read pointer. */
>> +     if (mmio->is_write)
>> +             its->creadr =3D 0;
>> +
>>       return false;
>>  }
>>
>> +static int its_cmd_buffer_size(struct kvm *kvm)
>> +{
>> +     struct vgic_its *its =3D &kvm->arch.vgic.its;
>> +
>> +     return ((its->cbaser & 0xff) + 1) << 12;
>> +}
>> +
>> +static gpa_t its_cmd_buffer_base(struct kvm *kvm)
>> +{
>> +     struct vgic_its *its =3D &kvm->arch.vgic.its;
>> +
>> +     return BASER_BASE_ADDRESS(its->cbaser);
>> +}
>> +
>> +/*
>> + * By writing to CWRITER the guest announces new commands to be process=
ed.
>> + * Since we cannot read from guest memory inside the ITS spinlock, we
>> + * iterate over the command buffer (with the lock dropped) until the re=
ad
>> + * pointer matches the write pointer. Other VCPUs writing this register=
 in the
>> + * meantime will just update the write pointer, leaving the command
>> + * processing to the first instance of the function.
>> + */
> I am lost, isn't the dist lock hold by vgic_handle_mmio_access before
> calling call_range_handler/range->handle_mmio ?

Indeed, I was so focussed on the ITS lock...

> if confirmed we need to move the command enumeration + execution
> somewhere else.

I think we get away with dropping the dist lock after doing the actual
register access. Just before returning we then take it again to make the
caller happy.
I will give this a try. Thanks for spotting this!

> Besides that piece of code may deserve to be
> encaspulated in a function. what do you think?

Makes some sense, yes.

Cheers,
Andr=E9
