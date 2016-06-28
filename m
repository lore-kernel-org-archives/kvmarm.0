From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Tue, 28 Jun 2016 14:25:19 +0100
Message-ID: <20160628132518.GC4585@e104818-lin.cambridge.arm.com>
References: <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
 <CAKv+Gu9uBow4FqmA701J76CZ9Npi2j6ADXEJhXAax5whiQkP1A@mail.gmail.com>
 <20160627133508.GI26498@cbox>
 <CAKv+Gu_zQErcMy6h0J71TfrkwRC0TqoQxmjRCNoeyJeD-zX7Kg@mail.gmail.com>
 <20160628100405.GK26498@cbox>
 <9fbfb578-2235-2f2a-4502-a285e9ba22e6@redhat.com>
 <20160628122043.GO26498@cbox>
 <20160628131026.GB4585@e104818-lin.cambridge.arm.com>
 <CAKv+Gu_3ZUAFaxfu4Qha0jB6YActHg3t5JBmWxXUzR_J6g19Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED40749B34
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:20:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DV1ERJbmIdiT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 09:20:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8031F49B2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:20:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_3ZUAFaxfu4Qha0jB6YActHg3t5JBmWxXUzR_J6g19Ng@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 28, 2016 at 03:19:14PM +0200, Ard Biesheuvel wrote:
> On 28 June 2016 at 15:10, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Jun 28, 2016 at 02:20:43PM +0200, Christoffer Dall wrote:
> >> On Tue, Jun 28, 2016 at 01:06:36PM +0200, Laszlo Ersek wrote:
> >> > On 06/28/16 12:04, Christoffer Dall wrote:
> >> > > On Mon, Jun 27, 2016 at 03:57:28PM +0200, Ard Biesheuvel wrote:
> >> > >> So if vga-pci.c is the only problematic device, for which a reasonable
> >> > >> alternative exists (virtio-gpu), I think the only feasible solution is
> >> > >> to educate QEMU not to allow RAM memslots being exposed via PCI BARs
> >> > >> when running under KVM/ARM.
> >> > >
> >> > > It would be good if we could support vga-pci under KVM/ARM, but if
> >> > > there's no other way than rewriting the arm64 kernel's memory mappings
> >> > > completely, then probably we're stuck there, unfortunately.
> >
> > Just to be clear, the behaviour of mismatched memory attributes is
> > defined in the ARM ARM and so far Linux worked fine with such cacheable
> > vs non-cacheable (as long as only one of them is accessed *or* cache
> > maintenance is performed accordingly). I don't think the arm64 kernel
> > memory map needs to be rewritten.
> 
> That would suggest that having an uncached userland mapping in QEMU
> and an uncached kernel mapping in the guest would be ok as long as we
> don't access the host kernel's cacheable alias?

Yes, from an architecture perspective. Many framebuffer drivers already
work in a similar way and map the framebuffer memory in user as
non-cacheable. Of course, one difference is that the other agent
accessing the memory is a DMA device rather than the CPU.

> In that case, Drew's approach would be feasible, and the
> pci_register_bar() function in QEMU could be modified to force the
> userland mapping and the stage2 mapping to 'device' [when running
> under KVM/ARM] if it refers to a memslot that is backed by host
> memory.

Device or normal non-cacheable (depending on the unaligned access
requirements).

Since such memory is allocated by Qemu (rather than a kernel driver),
KVM would need to mark the pages as reserved so that they are not moved
around by the host kernel, especially since it would use the cacheable
alias.

Another issue is taking care of the host kernel merging adjacent vmas
since we only want to apply the attributes to a single region.

-- 
Catalin
