From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Mon, 27 Jun 2016 11:16:19 +0200
Message-ID: <20160627091619.GB26498@cbox>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 609F9411E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 05:10:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIkE7aBHB-Lm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 05:10:26 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F95741145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 05:10:25 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id a66so105579585wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 02:15:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I'm going to ask some stupid questions here...

On Fri, Jun 24, 2016 at 04:04:45PM +0200, Ard Biesheuvel wrote:
> Hi all,
> 
> This old subject came up again in a discussion related to PCIe support
> for QEMU/KVM under Tianocore. The fact that we need to map PCI MMIO
> regions as cacheable is preventing us from reusing a significant slice
> of the PCIe support infrastructure, and so I'd like to bring this up
> again, perhaps just to reiterate why we're simply out of luck.
> 
> To refresh your memories, the issue is that on ARM, PCI MMIO regions
> for emulated devices may be backed by memory that is mapped cacheable
> by the host. Note that this has nothing to do with the device being
> DMA coherent or not: in this case, we are dealing with regions that
> are not memory from the POV of the guest, and it is reasonable for the
> guest to assume that accesses to such a region are not visible to the
> device before they hit the actual PCI MMIO window and are translated
> into cycles on the PCI bus. 

For the sake of completeness, why is this reasonable?

Is this how any real ARM system implementing PCI would actually work?

> That means that mapping such a region
> cacheable is a strange thing to do, in fact, and it is unlikely that
> patches implementing this against the generic PCI stack in Tianocore
> will be accepted by the maintainers.
> 
> Note that this issue not only affects framebuffers on PCI cards, it
> also affects emulated USB host controllers (perhaps Alex can remind us
> which one exactly?) and likely other emulated generic PCI devices as
> well.
> 
> Since the issue exists only for emulated PCI devices whose MMIO
> regions are backed by host memory, is there any way we can already
> distinguish such memslots from ordinary ones? If we can, is there
> anything we could do to treat these specially? Perhaps something like
> using read-only memslots so we can at least trap guest writes instead
> of having main memory going out of sync with the caches unnoticed? I
> am just brainstorming here ...

I think the only sensible solution is to make sure that the guest and
emulation mappings use the same memory type, either cached or
non-cached, and we 'simply' have to find the best way to implement this.

As Drew suggested, forcing some S2 mappings to be non-cacheable is the
one way.

The other way is to use something like what you once wrote that rewrites
stage-1 mappings to be cacheable, does that apply here ?

Do we have a clear picture of why we'd prefer one way over the other?

> 
> In any case, it would be good to put this to bed one way or the other
> (assuming it hasn't been put to bed already)
> 

Agreed.

Thanks for the mail!

-Christoffer
