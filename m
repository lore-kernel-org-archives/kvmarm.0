From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add set_memory_nc
Date: Tue, 19 May 2015 12:03:22 +0200
Message-ID: <20150519100322.GC2815@localhost.localdomain>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-2-git-send-email-drjones@redhat.com>
 <20150514110509.GP32765@cbox>
 <20150514134644.GF12812@localhost.localdomain>
 <20150518155303.GF21251@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7091851B16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2015 05:54:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1IpqyjFxu1At for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 May 2015 05:54:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AD6951A09
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2015 05:54:08 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150518155303.GF21251@e104818-lin.cambridge.arm.com>
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


Hi Catalin,

Thanks for the feedback. Some comments to your comments below.

On Mon, May 18, 2015 at 04:53:03PM +0100, Catalin Marinas wrote:
> On Thu, May 14, 2015 at 02:46:44PM +0100, Andrew Jones wrote:
> > On Thu, May 14, 2015 at 01:05:09PM +0200, Christoffer Dall wrote:
> > > On Wed, May 13, 2015 at 01:31:52PM +0200, Andrew Jones wrote:
> > > > Provide a method to change normal, cacheable memory to non-cacheable.
> > > > KVM will make use of this to keep emulated device memory regions
> > > > coherent with the guest.
> > > > 
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > 
> > > Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > 
> > > But you obviously need Russell and Will/Catalin to ack/merge this.
> > 
> > I guess this patch is going to go away in the next round. You've
> > pointed out that I screwed stuff up royally with my over eagerness
> > to reuse code. I need to reimplement change_memory_common, but a
> > version that takes an mm, which is more or less what I did in the
> > last version of this series, back when I was pinning pages.
> 
> I kept wondering what this patch and the next one are doing with
> set_memory_nc(). Basically you were trying to set the cache attributes
> for the kernel linear mapping or kmap address (in the 32-bit arm case,
> which is removed anyway on kunmap).

Yeah, I was way to hasty with this version... Sorry for wasting people's
time with it.

> 
> What you need is changing the attributes of the user mapping as accessed
> by Qemu but I don't think simply re-implementing change_memory_common()
> would work, you probably need to pin the pages in memory as well.
> Otherwise, the kernel may remove such pages and, when bringing them
> back, would set the default cacheability attributes.

Yup, I read that code and saw it would inherit the memory attributes
from the vma. At the time I wasn't thinking about the userspace mapping
though, and thus had convinced myself that if "the" mapping goes away,
then we'll be invalidating the guest's mapping too, and thus we'd end up
faulting it in again when necessary, and at that time resetting the
attributes. If the guest never faulted it in again, then it wouldn't
have mattered what the attributes were anyway. Of course I was thinking
about the wrong mapping...

> 
> Another way would be to split the vma containing the non-cacheable
> memory so that you get a single vma with the vm_page_prot as
> Non-cacheable.

This sounds interesting. Actually, it even crossed my mind once when I
first saw that the vma would overwrite the attributes, but then, sigh,
I let my brain take a stupidity bath.

> 
> Yet another approach could be for KVM to mmap the necessary memory for
> Qemu via a file_operations.mmap call (but that's only for ranges outside
> the guest "RAM").

I guess I prefer the vma splitting, rather than this (the vma creating
with mmap), as it keeps the KVM interface from changing (as you point out
below). Well, unless there are other advantages to this that are worth
considering?

> 
> I didn't have time to follow these threads in details, but just to
> recap my understanding, we have two main use-cases:
> 
> 1. Qemu handling guest I/O to device (e.g. PCIe BARs)
> 2. Qemu emulating device DMA
> 
> For (1), I guess Qemu uses an anonymous mmap() and then tells KVM about
> this memory slot. The memory attributes in this case could be Device
> because that's how the guest would normally map it. The
> file_operations.mmap trick would work in this case but this means
> expanding the KVM ABI beyond just an ioctl().
> 
> For (2), since Qemu is writing to the guest "RAM" (e.g. video
> framebuffer allocated by the guest), I still think the simplest is to
> tell the guest (via DT) that such device is cache coherent rather than
> trying to remap the Qemu mapping as non-cacheable.

If we need a solution for (1), then I'd prefer that it work and be
applied to (2) as well. Anyway, I'm still not 100% sure we can count on
all guest types (booloaders, different OSes) to listen to us. They may
assume non-cacheable is typical and safe, and thus just do that always.
We can certainly change some of those bootloaders and OSes, but probably
not all of them.

Thanks,
drew
