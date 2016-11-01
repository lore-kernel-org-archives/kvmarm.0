From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Prevent VGIC_ADDR_TO_INTID from
 emiting divisions
Date: Tue, 1 Nov 2016 20:31:48 +0100
Message-ID: <20161101193148.GG13677@cbox>
References: <20161029111901.16668-1-marc.zyngier@arm.com>
 <20161101152849.GC13677@cbox>
 <a0336267-4180-5c1d-2122-d76e23120939@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C60E403F1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 15:31:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jcju6ZPnGaxo for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2016 15:31:44 -0400 (EDT)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E777440286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 15:31:43 -0400 (EDT)
Received: by mail-lf0-f41.google.com with SMTP id b81so133696722lfe.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2016 12:31:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <a0336267-4180-5c1d-2122-d76e23120939@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 01, 2016 at 04:50:26PM +0000, Andre Przywara wrote:
> Hej,
> 
> On 01/11/16 15:28, Christoffer Dall wrote:
> > On Sat, Oct 29, 2016 at 12:19:01PM +0100, Marc Zyngier wrote:
> >> Using non-constant number of bits for VGIC_ADDR_TO_INTID() leads
> >> to gcc 6.1 emiting calls to __aeabi_uldivmod, which the kernel
> >> does not implement.
> >>
> >> As we really don't want to implement complex division in the kernel,
> >> the only other option is to prove to the compiler that there is only
> >> a few values that are possible for the number of bits per IRQ, and
> >> that they are all power of 2.
> >>
> >> We turn the VGIC_ADDR_TO_INTID macro into a switch that looks for
> >> the supported set of values (1, 2, 8, 64), and perform the computation
> >> accordingly. When "bits" is a constant, the compiler optimizes
> >> away the other cases. If not, we end-up with a small number of cases
> >> that GCC optimises reasonably well. Out of range values are detected
> >> both at build time (constants) and at run time (variables).
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >> This should be applied *before* Andre's patch fixing out of bound SPIs.
> >>
> >>  virt/kvm/arm/vgic/vgic-mmio.h | 33 ++++++++++++++++++++++++++++++++-
> >>  1 file changed, 32 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> >> index 4c34d39..a457282 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> >> @@ -57,10 +57,41 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
> >>   * multiplication with the inverted fraction, and scale up both the
> >>   * numerator and denominator with 8 to support at most 64 bits per IRQ:
> >>   */
> >> -#define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
> >> +#define __VGIC_ADDR_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
> >>  					64 / (bits) / 8)
> 
> I remember we discussed this in length some months ago, but I was
> wondering if this isn't simply:
> 	((addr & mask) * 8) / bits

that's just dividing 8 into the 64, so that should be fine, yes.

> and thus can be written as:
> 	((addr & mask) * 8) >> ilog2(bits)

right, I follow that.

> We require <bits> to be a power of two anyway for the MASK macro.
> 
> ilog2(constant) is nicely optimized at compile time, but even at runtime
> on both ARM variants it boils down to "31 - clz(bits)", which are two or
> three instructions AFAICS.

cool with the ilog2 macro.

> 
> Does that make sense or am I missing something here?

makes sense I think.  Good luck writing a comment so that I can
understand this calculation later ;)

> 
> I changed this in my patch and adjusted the comment, quick testing seems
> to be fine on Midway and Juno.
> 
> Will send it out in a minute, if no-one objects.
> 
I don't object.

-Christoffer
