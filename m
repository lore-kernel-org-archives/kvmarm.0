From: Alexander Graf <agraf@suse.de>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Sat, 25 Jun 2016 09:19:38 +0200
Message-ID: <2698E29E-BEDE-4DCA-9DAC-732540B3BAC2@suse.de>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E81E849B21
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 03:14:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jU0X7MfmaFAn for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Jun 2016 03:14:40 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0F3649B1D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 03:14:40 -0400 (EDT)
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



> Am 24.06.2016 um 16:04 schrieb Ard Biesheuvel <ard.biesheuvel@linaro.org>:
> 
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
> into cycles on the PCI bus. That means that mapping such a region
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

The "easiest" first step would be to simply not map host memory into the guest when we're on arm. Unfortunately that would mean we trap on everything as mmio accesses, including user space access from Xorg for example. That in turn means we'd need to mmio emulate neon instructions and all other sorts of things that can trigger mmio exits without being emulated today.

Also, even with that working and maybe even coalesced mmio implemented, I'd guess it'd still be too slow for real world usage...


Alex
