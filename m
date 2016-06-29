From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 01/15] arm64: KVM: Merged page tables documentation
Date: Wed, 29 Jun 2016 10:05:55 +0100
Message-ID: <20160629100555.3a946689@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-2-git-send-email-marc.zyngier@arm.com>
 <20160627132815.GG26498@cbox> <577132D3.1030700@arm.com>
 <20160628114608.GM26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02ABE49B40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 05:01:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Or5Qkn-oV8M for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 05:01:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 846DA49B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 05:01:26 -0400 (EDT)
In-Reply-To: <20160628114608.GM26498@cbox>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 28 Jun 2016 13:46:08 +0200
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> On Mon, Jun 27, 2016 at 03:06:11PM +0100, Marc Zyngier wrote:
> > On 27/06/16 14:28, Christoffer Dall wrote:
> > > On Tue, Jun 07, 2016 at 11:58:21AM +0100, Marc Zyngier wrote:
> > >> Since dealing with VA ranges tends to hurt my brain badly, let's
> > >> start with a bit of documentation that will hopefully help
> > >> understanding what comes next...
> > >>
> > >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > >> ---
> > >>  arch/arm64/include/asm/kvm_mmu.h | 45 +++++++++++++++++++++++++++++++++++++---
> > >>  1 file changed, 42 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > >> index f05ac27..00bc277 100644
> > >> --- a/arch/arm64/include/asm/kvm_mmu.h
> > >> +++ b/arch/arm64/include/asm/kvm_mmu.h
> > >> @@ -29,10 +29,49 @@
> > >>   *
> > >>   * Instead, give the HYP mode its own VA region at a fixed offset from
> > >>   * the kernel by just masking the top bits (which are all ones for a
> > >> - * kernel address).
> > >> + * kernel address). We need to find out how many bits to mask.
> > >>   *
> > >> - * ARMv8.1 (using VHE) does have a TTBR1_EL2, and doesn't use these
> > >> - * macros (the entire kernel runs at EL2).
> > >> + * We want to build a set of page tables that cover both parts of the
> > >> + * idmap (the trampoline page used to initialize EL2), and our normal
> > >> + * runtime VA space, at the same time.
> > >> + *
> > >> + * Given that the kernel uses VA_BITS for its entire address space,
> > >> + * and that half of that space (VA_BITS - 1) is used for the linear
> > >> + * mapping, we can limit the EL2 space to the same size.
> > > 
> > > we can also limit the EL2 space to (VA_BITS - 1).
> > > 
> > >> + *
> > >> + * The main question is "Within the VA_BITS space, does EL2 use the
> > >> + * top or the bottom half of that space to shadow the kernel's linear
> > >> + * mapping?". As we need to idmap the trampoline page, this is
> > >> + * determined by the range in which this page lives.
> > >> + *
> > >> + * If the page is in the bottom half, we have to use the top half. If
> > >> + * the page is in the top half, we have to use the bottom half:
> > >> + *
> > >> + * if (PA(T)[VA_BITS - 1] == 1)
> > >> + *	HYP_VA_RANGE = [0 ... (1 << (VA_BITS - 1)) - 1]
> > >> + * else
> > >> + *	HYP_VA_RANGE = [(1 << (VA_BITS - 1)) ... (1 << VA_BITS) - 1]
> > > 
> > > Is this pseudo code or what am I looking at?  What is T?
> > 
> > Pseudocode indeed. T is the "trampoline page".
> > 
> > > I don't understand what this is saying.
> > 
> > This is giving you the range of HYP VAs that can be safely used to map
> > kernel ranges.
> 
> Ah, by PA(T)[bit_nr] you mean the value of an individual bit 'bit_nr' ?
> 
> I just think I choked on the pseudocode syntax, perhaps this is easier
> to understand?
> 
> T = __virt_to_phys(__hyp_idmap_text_start)
> if (T & BIT(VA_BITS - 1))
> 	HYP_VA_MIN = 0  //idmap in upper half
> else
> 	HYP_VA_MIN = 1 << (VA_BITS - 1)
> HYP_VA_MAX = HYP_VA_MIN + (1 << (VA_BITS - 1)) - 1

Yup, that's equivalent.

[...]

> > >> + *
> > >> + * In practice, the second case can be simplified to
> > >> + *	HYP_VA_RANGE = [0 ... (1 << VA_BITS) - 1]
> > >> + * because we'll never get anything in the bottom range.
> > > 
> > > and now I'm more confused, are we not supposed to map the idmap in the
> > > bottom range?  Is this part of the comment necessary?
> > 
> > Well, I found it useful when I wrote it. What I meant is that we're
> > never going to alias a kernel mapping there.
> 
> I think we should merge the documentation, this stuff is tricky so
> having it properly documented is important IMHO.
>
> The confusing part here is that we just said above that the HYP VA range
> may have to live in the upper part because the lower part would be used
> for the idmap, so why can we use it anyway?
> 
> Is the point that you'll be done with the idmap at some point?

No, the idmap has to stay (you definitely need it in order to enable
the MMU). It is not so much that we can or cannot bottom range, this
is simply where the idmap lives (the remark is confusing). The usable
VA space (to map kernel objects) is still between HYP_VA_MIN and
HYP_VA_MAX, as per your above definition.

> > 
> > > 
> > >> + *
> > >> + * This of course assumes that the trampoline page exists within the
> > >> + * VA_BITS range. If it doesn't, then it means we're in the odd case
> > >> + * where the kernel idmap (as well as HYP) uses more levels than the
> > >> + * kernel runtime page tables (as seen when the kernel is configured
> > >> + * for 4k pages, 39bits VA, and yet memory lives just above that
> > >> + * limit, forcing the idmap to use 4 levels of page tables while the
> > >> + * kernel itself only uses 3). In this particular case, it doesn't
> > >> + * matter which side of VA_BITS we use, as we're guaranteed not to
> > >> + * conflict with anything.
> > >> + *
> > >> + * An alternative would be to always use 4 levels of page tables for
> > >> + * EL2, no matter what the kernel does. But who wants more levels than
> > >> + * strictly necessary?
> 
> Our expectation here is that using an additional level is slower for TLB
> misses, so we want to avoid this, correct?  Also does the kernel never
> use 4 levels of page tables so that this is always an option.

A additional level is likely to increase the latency of a miss by an
additional 30% (compared to a 3 level miss). The kernel itself may be
configured for 4 levels, in which case we follow whatever it does.

> I appreciate the tongue-in-cheek, but since this hurts my brain (badly)
> I want to get rid of anything here that leaves the reader with open
> questions.
> 
> I don't mind trying to rewrite some of this, just have to make sure I
> actually understand it first.
> 
> > >> + *
> > >> + * Thankfully, ARMv8.1 (using VHE) does have a TTBR1_EL2, and doesn't
> > >> + * need any of this madness (the entire kernel runs at EL2).
> 
> So here I would simply state that using VHE, there are no separate hyp
> mappings and all KVM functionality is already mapped as part of the main
> kernel mappings, and none of this applies in that case.  Perhaps that's
> what you said already, and I just misread it for some reason.

Sure. I'll rewrite the thing.

> > > 
> > > Not sure how these two last paragraphs helps understanding what this
> > > patch set is about to implement, as it seems to raise more questions
> > > than answer them, but I will proceed to trying to read the code...
> > 
> > As I said, I found this blurb useful when I was trying to reason about
> > the problem. I don't mind it being dropped.
> > 
> 
> I would prefer if we can tweak it so I also understand it and then
> actually merge it.  That also makes it easier for me to review the patch
> set :)

Works for me!

	M.
-- 
Jazz is not dead. It just smells funny.
