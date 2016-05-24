From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH 00/10] arm/arm64: add gic
 framework
Date: Tue, 24 May 2016 13:58:19 +0200
Message-ID: <20160524115819.GC3582@cbox>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
 <20160518090714.GA3827@cbox>
 <20160523152423.2zc26na33jt2abdi@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160523152423.2zc26na33jt2abdi@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: peter.maydell@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, alex.bennee@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 23, 2016 at 05:24:23PM +0200, Andrew Jones wrote:
> On Wed, May 18, 2016 at 11:07:14AM +0200, Christoffer Dall wrote:
> > Hi Drew,
> > 
> > Thanks for doing this.  I'm happy to see some tests for the GIC.
> > 
> > I've been pondering with how to write unit tests for all the MMIO
> > implementations.  If you have some thoughts on how that could be easily
> > fitted into this framework, that would probably be a good place to do it
> > ;)
> 
> Hi Christoffer,
> 
> Sorry for my slow response, I've been on vacation. For MMIO
> implementations, are you referring to the emulation done for
> gicv2 accesses and for gicv3 legacy accesses? And, if so, is
> your question how we might be able to use the same test
> framework for both? And, if that's so, then I think this series
> gets us pretty close already. If I'm completely off-base, then
> please give me a quick high-level description of what you'd like
> to be able to do.
> 
What I meant was testing all the MMIO accesses to the various
distributor MMIO regions.

For example, writing full words to all registers (some value) reading
back the value, correcting for RAZ/WI semantics, and testing that byte
accesses to those registers where that's allowed also works.

If adding that on top of this series sounds like a good idea, someone
should add it to the bottom of their (presumably already long) todo
list, myself included.

Thanks,
-Christoffer
