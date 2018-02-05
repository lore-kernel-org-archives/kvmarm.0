From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 12/18] arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast
 handling
Date: Mon, 5 Feb 2018 11:18:22 +0100
Message-ID: <20180205101822.GA16136@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-13-marc.zyngier@arm.com>
 <20180204183907.GP21802@cbox>
 <1d30fe51-22dd-6938-2f8f-c823858a3bbd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1d30fe51-22dd-6938-2f8f-c823858a3bbd@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jon Masters <jcm@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, Jayachandran C <jnair@caviumnetworks.com>, Hanjun Guo <guohanjun@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 05, 2018 at 09:08:31AM +0000, Marc Zyngier wrote:
> On 04/02/18 18:39, Christoffer Dall wrote:
> > On Thu, Feb 01, 2018 at 11:46:51AM +0000, Marc Zyngier wrote:
> >> We want SMCCC_ARCH_WORKAROUND_1 to be fast. As fast as possible.
> >> So let's intercept it as early as we can by testing for the
> >> function call number as soon as we've identified a HVC call
> >> coming from the guest.
> > 
> > Hmmm.  How often is this expected to happen and what is the expected
> > extra cost of doing the early-exit handling in the C code vs. here?
> 
> Pretty often. On each context switch of a Linux guest, for example. It
> is almost as bad as if we were trapping all VM ops. Moving it to C is
> definitely visible on something like hackbench (I remember something
> like a 10-12% degradation on Seattle, but I'd need to rerun the tests to
> give you something accurate). 

If it's that easily visible (although hackbench is clearly the
pathological case here), then we should try to optimize it.  Let's hope
we don't have to add too many of these workarounds in the future.

> It is the whole GPR save/restore dance
> that costs us a lot (31 registers for the guest, 12 for the host), plus
> some the extra SError synchronization that doesn't come for free either.
> 

Fair enough.

> > I think we'd be better off if we only had a single early-exit path (and
> > we should move the FP/SIMD trap to that path as well), but if there's a
> > measurable benefit of having this logic in assembly as opposed to in the
> > C code, then I'm ok with this as well.
> 
> I agree that the multiplication of "earlier than early" paths is
> becoming annoying. Moving the FP/SIMD stuff to C would be less
> problematic, as we have patches to move some of that to load/put, and
> we'd only take the trap once per time slice (as opposed to once per
> entry at the moment).

Yes, and we can even improve on that (see separate discussions around
KVM support for SVE with Dave).

> 
> Here, we're trying hard to do exactly nothing, because each instruction
> is just an extra overhead (we've already nuked the BP). I even
> considered inserting that code as part of the per-CPU-type vectors (and
> leave the rest of the KVM code alone), but it felt like a step too far.
> 

We can always look at adjusting this more in the future if we want.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
