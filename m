From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Tue, 28 Jun 2016 14:10:26 +0100
Message-ID: <20160628131026.GB4585@e104818-lin.cambridge.arm.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
 <CAKv+Gu9uBow4FqmA701J76CZ9Npi2j6ADXEJhXAax5whiQkP1A@mail.gmail.com>
 <20160627133508.GI26498@cbox>
 <CAKv+Gu_zQErcMy6h0J71TfrkwRC0TqoQxmjRCNoeyJeD-zX7Kg@mail.gmail.com>
 <20160628100405.GK26498@cbox>
 <9fbfb578-2235-2f2a-4502-a285e9ba22e6@redhat.com>
 <20160628122043.GO26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ABB549B46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:05:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NOYnrUACvLcB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 09:05:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D428249B32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:05:22 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160628122043.GO26498@cbox>
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
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 28, 2016 at 02:20:43PM +0200, Christoffer Dall wrote:
> On Tue, Jun 28, 2016 at 01:06:36PM +0200, Laszlo Ersek wrote:
> > On 06/28/16 12:04, Christoffer Dall wrote:
> > > On Mon, Jun 27, 2016 at 03:57:28PM +0200, Ard Biesheuvel wrote:
> > >> So if vga-pci.c is the only problematic device, for which a reasonable
> > >> alternative exists (virtio-gpu), I think the only feasible solution is
> > >> to educate QEMU not to allow RAM memslots being exposed via PCI BARs
> > >> when running under KVM/ARM.
> > > 
> > > It would be good if we could support vga-pci under KVM/ARM, but if
> > > there's no other way than rewriting the arm64 kernel's memory mappings
> > > completely, then probably we're stuck there, unfortunately.

Just to be clear, the behaviour of mismatched memory attributes is
defined in the ARM ARM and so far Linux worked fine with such cacheable
vs non-cacheable (as long as only one of them is accessed *or* cache
maintenance is performed accordingly). I don't think the arm64 kernel
memory map needs to be rewritten.

> > It's been mentioned earlier that the specific combination of S1 and S2
> > mappings on aarch64 is actually an *architecture bug*. If we accept that
> > qualification, then we should realize our efforts here target finding a
> > *workaround*.

I haven't read this thread in detail but I doubt it's an architecture
bug. You may say a missing feature.

> > In your blog post
> > <http://www.linaro.org/blog/core-dump/on-the-performance-of-arm-virtualization/>,
> > you mention VHE ("Virtualization Host Extensions"). That's clearly a
> > sign of the architecture adapting to virt software needs.
> > 
> > Do you see any chance that the S1-S2 combinations too can be fixed in a
> > new revision of the architecture?
> 
> I really can't speculate about this, I assume there are reasons for why
> the architecture is defined in this particular way, but I haven't
> investigated this aspect in any depth.

In general, there are software issues with forcing cacheability at S2
when S1 required non-cacheable transactions, with all the coherency
assumptions. The problem becomes even more complicated when memory
types, not just cacheability, are "upgraded". E.g. forcing S1 Device to
S2 Normal with consequences on memory ordering that the guest is not
aware of.

While there are potential, specific, hardware solutions, they can't be
"back-ported" to existing CPU implementation, so we need a solution in
software. *If* the only software solution has severe performance
implications and it is on a critical path, the architecture might be
improved in the future (like we did with VHE). But I don't think that's
the case here.

-- 
Catalin
