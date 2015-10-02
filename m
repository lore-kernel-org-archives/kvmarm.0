From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 4/8] arm/arm64: KVM: Implement GICD_ICFGR as RO for
 PPIs
Date: Fri, 2 Oct 2015 22:52:34 +0200
Message-ID: <20151002205234.GF32011@cbox>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
 <1443538145-11990-5-git-send-email-christoffer.dall@linaro.org>
 <560E9A06.3040404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <560E9A06.3040404@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 03:51:50PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> On 29/09/15 15:49, Christoffer Dall wrote:
> > The GICD_ICFGR allows the bits for the SGIs and PPIs to be read only.
> > We currently simulate this behavior by writing a hardcoded value to the
> > register for the SGIs and PPIs on every write of these bits to the
> > register (ignoring what the guest actually wrote), and by writing the
> > same value as the reset value to the register.
> > 
> > This is a bit counter-intuitive, as the register is RO for these bits,
> > and we can just implement it that way, allowing us to control the value
> > of the bits purely in the reset code.
> > 
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index fe0e5db..e606f78 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -655,7 +655,7 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
> >  			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
> >  	if (mmio->is_write) {
> >  		if (offset < 8) {
> > -			*reg = ~0U; /* Force PPIs/SGIs to 1 */
> > +			/* Ignore writes to read-only SGI and PPI bits */
> >  			return false;
> >  		}
> 
> Nit: Isn't this now violating kernel coding style because of a single
> statement not needing braces? Maybe move the comment in front of the
> if-statement to make this more obvious?
> 
sure

> Other than that:
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> 
Thanks,
-Christoffer
