From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: vgic: Virtual interrupt grouping
 support
Date: Mon, 25 Jun 2018 12:05:07 +0200
Message-ID: <20180625100507.GE8004@C02W217FHV2R.local>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
 <16588d45-5f24-90ff-57ca-6c670cc2c96c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <16588d45-5f24-90ff-57ca-6c670cc2c96c@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 25, 2018 at 10:59:06AM +0100, Andre Przywara wrote:
> Hi,
> 
> On 24/06/18 23:10, Christoffer Dall wrote:
> > This small series addresses a peculiarity of the current VGIC
> > implementation, namely that we don't support interrupt grouping.
> 
> Nice one and seems straight forward enough.
> Just curious: Were there any complaints or even users of FIQs and/or
> interrupt grouping?
> 

No, but the behavior wasn't strictly architecturally compliant so it was
on the table for the GICv2-on-GICv3 fixes that Marc was working on a
while back.

> > KVM either implements a GICv2 without support for the security
> > extensions, or a GICv3 with DS=1.  For GICv2, on systems without the
> > security extensions, group 0 interrupts can be configured to be either
> > signalled as FIQs or as IRQs by the VM, whereas group 1 interrupts are
> > always IRQs.  For GICv3, with DS=1, group 1 interrupts are always IRQs
> > and group 0 interrupts are always FIQs, and there is no concept of
> > secure vs. non-secure group 1 interrupts when DS=1.
> > 
> > We were treating all interrupts on GICv2 as group 0, but yet telling the
> > geust that they were group 1.  The first patch changes this behavior,
> > which seems to have no effect on no known guests, but still.
> > 
> > The remaining patches introduce proper interrupt grouping support, along
> > with MMIO accessors for the VM and userspace to retrieve and set the
> > which group SGIs, PPIs, and SPIs belong to.  LPIs are always group 1
> > interrupts as per the architecture, and there is no way to modify this
> > configuration (no IGROUPR registers for LPIs or equivalent ITS
> > commands).
> > 
> > Lightly tested on Seattle, TX1, and the foundation model.  I've run a
> > GICv2 guest on a GICv3 host on the foundation model.
> 
> I take it those were regression tests with Linux guests?
> Do we have any means of testing this with guests which actually use
> different groups or FIQs? Does kvm-unit-tests cover this?

I don't think so.  I did run kvm-unit-tests on a GICv3 system and didn't
observe anything.  I think I forgot to run it on a GICv2 system, I'll
expand coverage for the next round.

> 
> Did you do any tests on 32 bit? I am going to fire up something on my
> Midway later today ...
> 

Yes, I ran it on my cubietruck.

Thanks,
-Christoffer
