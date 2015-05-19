From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add set_memory_nc
Date: Tue, 19 May 2015 13:38:42 +0200
Message-ID: <20150519113842.GE2815@localhost.localdomain>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-2-git-send-email-drjones@redhat.com>
 <20150514110509.GP32765@cbox>
 <20150514134644.GF12812@localhost.localdomain>
 <20150518155303.GF21251@e104818-lin.cambridge.arm.com>
 <20150519100322.GC2815@localhost.localdomain>
 <20150519111854.GA14109@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D25C251B54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2015 07:29:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e5UmuwDBRDpv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 May 2015 07:29:33 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8476351A79
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2015 07:29:33 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150519111854.GA14109@localhost>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "lersek@redhat.com" <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 19, 2015 at 12:18:54PM +0100, Catalin Marinas wrote:
> On Tue, May 19, 2015 at 11:03:22AM +0100, Andrew Jones wrote:
> > On Mon, May 18, 2015 at 04:53:03PM +0100, Catalin Marinas wrote:
> > > Another way would be to split the vma containing the non-cacheable
> > > memory so that you get a single vma with the vm_page_prot as
> > > Non-cacheable.
> > 
> > This sounds interesting. Actually, it even crossed my mind once when I
> > first saw that the vma would overwrite the attributes, but then, sigh,
> > I let my brain take a stupidity bath.
> > 
> > > 
> > > Yet another approach could be for KVM to mmap the necessary memory for
> > > Qemu via a file_operations.mmap call (but that's only for ranges outside
> > > the guest "RAM").
> > 
> > I guess I prefer the vma splitting, rather than this (the vma creating
> > with mmap), as it keeps the KVM interface from changing (as you point out
> > below). Well, unless there are other advantages to this that are worth
> > considering?
> 
> The advantage is that you don't need to deal with the mm internals in
> the KVM code.
> 
> But you can probably add such code directly to mm/ and reuse some of the
> existing code in there already as part of change_protection(),
> mprotect_fixup(), sys_mprotect(). Actually, once you split the vma and
> set the new protection (something similar to mprotect_fixup), it looks
> to me like you can just call change_protection(vma->vm_page_prot).

I'll start playing around with this today.

> 
> > > I didn't have time to follow these threads in details, but just to
> > > recap my understanding, we have two main use-cases:
> > > 
> > > 1. Qemu handling guest I/O to device (e.g. PCIe BARs)
> > > 2. Qemu emulating device DMA
> > > 
> > > For (1), I guess Qemu uses an anonymous mmap() and then tells KVM about
> > > this memory slot. The memory attributes in this case could be Device
> > > because that's how the guest would normally map it. The
> > > file_operations.mmap trick would work in this case but this means
> > > expanding the KVM ABI beyond just an ioctl().
> > > 
> > > For (2), since Qemu is writing to the guest "RAM" (e.g. video
> > > framebuffer allocated by the guest), I still think the simplest is to
> > > tell the guest (via DT) that such device is cache coherent rather than
> > > trying to remap the Qemu mapping as non-cacheable.
> > 
> > If we need a solution for (1), then I'd prefer that it work and be
> > applied to (2) as well. Anyway, I'm still not 100% sure we can count on
> > all guest types (booloaders, different OSes) to listen to us. They may
> > assume non-cacheable is typical and safe, and thus just do that always.
> > We can certainly change some of those bootloaders and OSes, but probably
> > not all of them.
> 
> That's fine by me. Once you get the vma splitting and attributes
> changing done, I think you get the second one for free.
> 
> Do we want to differentiate between Device and Normal Non-cacheable
> memory? Something like KVM_MEMSLOT_DEVICE?
> 
> Nitpick: I'm not sure whether "uncached" is clear enough. In Linux,
> pgprot_noncached() returns Strongly Ordered memory. For Normal
> Non-cachable we used pgprot_writecombine (e.g. a video framebuffer).
> 
> Maybe something like KVM_MEMSLOT_COHERENT meaning a request to KVM to

Sounds good to me. I'll rename for the next round.

> ensure that guest and host access it coherently (which would mean
> writecombine for ARM). That's similar naming to functions like
> dma_alloc_coherent() that return cacheable or non-cacheable memory based
> on what the device supports. Anyway, I'm not to bothered with the
> naming.
>

Thanks for your help!

drew 
