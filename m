From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH 26/45] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Tue, 19 Apr 2016 13:57:33 +0100
Message-ID: <57162B3D.9000307@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-27-git-send-email-andre.przywara@arm.com>
 <CAFEAcA9Hy2cSVguOWrxBo6By24BjiE2rgoCPGbfo+OuuPMtSQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9Hy2cSVguOWrxBo6By24BjiE2rgoCPGbfo+OuuPMtSQg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

thanks for going through the pain of looking into this!

On 19/04/16 13:34, Peter Maydell wrote:
> On 15 April 2016 at 18:11, Andre Przywara <andre.przywara@arm.com> wrote:
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic_mmio.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
>> index 7d275a7..dafa235 100644
>> --- a/virt/kvm/arm/vgic/vgic_mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
>> @@ -784,6 +784,23 @@ static int vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
>>         return 0;
>>  }
>>
>> +static int vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>> +                                   struct kvm_io_device *dev,
>> +                                   gpa_t addr, int len, void *val)
>> +{
>> +       u32 regnr = (addr & 0x3f) - (GICD_IDREGS & 0x3f);
>> +       u32 reg = 0;
>> +
>> +       switch (regnr + GICD_IDREGS) {
>> +       case GICD_PIDR2:
>> +               /* report a GICv3 compliant implementation */
>> +               reg = 0x3b;
>> +               break;
>> +       }
> 
> We claim to be an ARM implementation, so we should report the full
> set of ARM ID registers, not just GICD_PIDR2:

Do we really have to? Please note that though we say our implementor is
ARM (because we lack alternatives, I think), we don't claim to be a
GIC-500, for instance, but a made-up KVM implementation.
So there is no need to implement the other ID registers, except for the
architecturally defined PIDR2, which Linux actually checks to confirm
that this is a GICv3 compliant GIC.

>         0x44, 0x00, 0x00, 0x00, 0x92, 0xB4, 0x3B, 0x00, 0x0D, 0xF0, 0x05, 0xB1

Yes, I had those registers defined like this in an earlier version, but
Marc's comment IIRC correctly was that we shouldn't claim to be a
GIC-500, for instance, because then we would need to mimic GIC-500
behavior quite closely, which we simply don't and also don't want to.

So architecturally we are fine, I think.

Do you think by claiming coming from ARM we are obliged to implement all
the other PIDR/CIDR registers the ARM way?

Cheers,
Andre.

> 
> (starting at 0xFFD0 and going up to 0xFFFC.)
> 
>> +       write_mask32(reg , addr & 3, len, val);
>> +       return 0;
>> +}
>>  #endif
> 
> thanks
> -- PMM
> 

