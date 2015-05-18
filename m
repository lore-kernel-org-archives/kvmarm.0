From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add set_memory_nc
Date: Mon, 18 May 2015 16:53:03 +0100
Message-ID: <20150518155303.GF21251@e104818-lin.cambridge.arm.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-2-git-send-email-drjones@redhat.com>
 <20150514110509.GP32765@cbox>
 <20150514134644.GF12812@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968C251A02
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2015 11:43:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GSmyEmBCPRtk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2015 11:43:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FAD0519FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2015 11:43:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150514134644.GF12812@localhost.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "lersek@redhat.com" <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 02:46:44PM +0100, Andrew Jones wrote:
> On Thu, May 14, 2015 at 01:05:09PM +0200, Christoffer Dall wrote:
> > On Wed, May 13, 2015 at 01:31:52PM +0200, Andrew Jones wrote:
> > > Provide a method to change normal, cacheable memory to non-cacheable.
> > > KVM will make use of this to keep emulated device memory regions
> > > coherent with the guest.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > But you obviously need Russell and Will/Catalin to ack/merge this.
> 
> I guess this patch is going to go away in the next round. You've
> pointed out that I screwed stuff up royally with my over eagerness
> to reuse code. I need to reimplement change_memory_common, but a
> version that takes an mm, which is more or less what I did in the
> last version of this series, back when I was pinning pages.

I kept wondering what this patch and the next one are doing with
set_memory_nc(). Basically you were trying to set the cache attributes
for the kernel linear mapping or kmap address (in the 32-bit arm case,
which is removed anyway on kunmap).

What you need is changing the attributes of the user mapping as accessed
by Qemu but I don't think simply re-implementing change_memory_common()
would work, you probably need to pin the pages in memory as well.
Otherwise, the kernel may remove such pages and, when bringing them
back, would set the default cacheability attributes.

Another way would be to split the vma containing the non-cacheable
memory so that you get a single vma with the vm_page_prot as
Non-cacheable.

Yet another approach could be for KVM to mmap the necessary memory for
Qemu via a file_operations.mmap call (but that's only for ranges outside
the guest "RAM").

I didn't have time to follow these threads in details, but just to
recap my understanding, we have two main use-cases:

1. Qemu handling guest I/O to device (e.g. PCIe BARs)
2. Qemu emulating device DMA

For (1), I guess Qemu uses an anonymous mmap() and then tells KVM about
this memory slot. The memory attributes in this case could be Device
because that's how the guest would normally map it. The
file_operations.mmap trick would work in this case but this means
expanding the KVM ABI beyond just an ioctl().

For (2), since Qemu is writing to the guest "RAM" (e.g. video
framebuffer allocated by the guest), I still think the simplest is to
tell the guest (via DT) that such device is cache coherent rather than
trying to remap the Qemu mapping as non-cacheable.

-- 
Catalin
