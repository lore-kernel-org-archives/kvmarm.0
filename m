From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 32/56] KVM: arm/arm64: vgic-new: Add SGIPENDR register
 handlers
Date: Wed, 18 May 2016 15:50:22 +0200
Message-ID: <20160518135022.GL3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-33-git-send-email-andre.przywara@arm.com>
 <20160518131449.GI3827@cbox>
 <573C6EA6.90803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <573C6EA6.90803@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 18, 2016 at 02:31:18PM +0100, Andre Przywara wrote:
> Hi,
>=20
> On 18/05/16 14:14, Christoffer Dall wrote:
> > On Mon, May 16, 2016 at 10:53:20AM +0100, Andre Przywara wrote:
> >> As this register is v2 specific, its implementation lives entirely
> >> in vgic-mmio-v2.c.
> >> This register allows setting the source mask of an IPI.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> ---
> >> Changelog RFC..v1:
> >> - remove IRQ lock from read handler
> >> - update pending bit on setting the first / clearing the last bit
> >> - queue virtual IRQ if necessary
> >>
> >> Changelog v1 .. v2:
> >> - adapt to new MMIO framework
> >>
> >> Changelog v3 .. v4:
> >> - specify accessor width
> >>
> >>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 62 +++++++++++++++++++++++++++=
+++++++++++--
> >>  1 file changed, 60 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/=
vgic-mmio-v2.c
> >> index c884e9b..3925d4c 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> @@ -146,6 +146,64 @@ static void vgic_mmio_write_target(struct kvm=
_vcpu *vcpu,
> >>  	}
> >>  }
> >> =20
> >> +static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu=
,
> >> +					    gpa_t addr, unsigned int len)
> >> +{
> >> +	u32 intid =3D addr & 0x0f;
> >=20
> > is there a reason why we cannot use the magic macro here?
>=20
> I wasn't sure about this, because it's not covering all 1024 interrup=
ts,
> but just SGIs, so it's always fixed to 16 interrupts =E1 8 bits. The
> default mask would be too big in this case.
> I guess it would work anyway because this region is limited to 16 byt=
es
> in our description, so we could use this here anyway to make it more
> aligned with the other handlers, maybe adding a comment about the
> difference?
>=20
meh, either way works for me actually, whatever you prefer.

Thanks,
-Christoffer
