From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/21] arm64: KVM: VHE: Patch out use of HVC
Date: Tue, 2 Feb 2016 16:42:12 +0100
Message-ID: <20160202154212.GD6190@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-7-git-send-email-marc.zyngier@arm.com>
 <20160201131634.GI1478@cbox>
 <56AF5ED8.7010303@arm.com>
 <20160201153635.GH15514@e104818-lin.cambridge.arm.com>
 <56AF85D8.7080907@arm.com>
 <CAKv+Gu9_KG7Zss3g1OMzcnRKQFhCcYtbSDEk-gwwgqPP-R6DOA@mail.gmail.com>
 <56AF95C0.3080006@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AF95C0.3080006@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, KVM devel mailing list <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 01, 2016 at 05:28:32PM +0000, Marc Zyngier wrote:
> On 01/02/16 17:08, Ard Biesheuvel wrote:
> > On 1 February 2016 at 17:20, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >> On 01/02/16 15:36, Catalin Marinas wrote:
> >>> On Mon, Feb 01, 2016 at 01:34:16PM +0000, Marc Zyngier wrote:
> >>>> On 01/02/16 13:16, Christoffer Dall wrote:
> >>>>> On Mon, Jan 25, 2016 at 03:53:40PM +0000, Marc Zyngier wrote:
> >>>>>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> >>>>>> index 93e8d983..9e0683f 100644
> >>>>>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> >>>>>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> >>>>>> @@ -38,6 +38,32 @@
> >>>>>>    ldp     x0, x1, [sp], #16
> >>>>>>  .endm
> >>>>>>
> >>>>>> +.macro do_el2_call
> >>>>>> +  /*
> >>>>>> +   * Shuffle the parameters before calling the function
> >>>>>> +   * pointed to in x0. Assumes parameters in x[1,2,3].
> >>>>>> +   */
> >>>>>> +  stp     lr, xzr, [sp, #-16]!
> >>>>>
> >>>>> remind me why this pair isn't just doing "str" instead of "stp" with the
> >>>>> xzr ?
> >>>>
> >>>> Because SP has to be aligned on a 16 bytes boundary at all times.
> >>>
> >>> You could do something like:
> >>>
> >>>       sub     sp, sp, #16
> >>>       str     lr, [sp]
> >>>
> >>
> >> Ah, fair enough. I'll fold that in.
> >>
> > 
> > Since we're micro-reviewing: what's wrong with
> > 
> > str lr, [sp, #-16]!
> > 
> > ?
> > 
> 
> I suspect that on most micro-architectures, a register writeback is
> going to be slower than doing the sub independently.
> 
> I may be wrong, though.
> 
For the record, I don't mind it the way it was in the original patch
either, I was just curious about the store of xzr and had forgottten the
stack alignment thing.

-Christoffer
