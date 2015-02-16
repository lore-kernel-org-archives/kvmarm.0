From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: vexpress: Horribly slow MMC emulation on ARM host
Date: Mon, 16 Feb 2015 09:11:27 +0000
Message-ID: <CAFEAcA84nB-KGySZ8N++9jR8MGFUNt4ewd=fszSpiDW41ZOZ_g@mail.gmail.com>
References: <54E19496.6020905@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54E19496.6020905@web.de>
Sender: kvm-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@web.de>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 February 2015 at 06:56, Jan Kiszka <jan.kiszka@web.de> wrote:
> This applies to both emulated and KVM accelerated mode. If I run the
> same image (and guest kernel) emulated on my x86 box, there is still a
> difference between both disk modes, but it's not that excessive. On ARM
> the system requires minutes to boot from MMC - if it doesn't run into
> timeouts earlier. It's seconds with virtio.

MMC is slow for several reasons, which boil down to:
 * we aren't doing async I/O on the block device layer
   (the SD/MMC card code is old and probably a long way from
   current best practice)
 * we model the mmc-controller-to-card interface fairly closely,
   which is not a very efficient way of transferring data
 * the MMC card interface in the vexpress board doesn't do DMA,
   which means that all data transferred is via (at best) word
   at a time MMIO register accesses
 * MMIO register access is particularly bad with KVM because it
   requires us to come out of EL1 guest to EL2 which then switches
   to EL1 host (host kernel) which then drops out to EL0 (QEMU),
   and then on return we do the reverse transition EL0->EL1->EL2->EL1.

Some of this is likely fixable (and possibly there are bugs
which make it slower than it need be as well as the issues
we actually know about). But in general we've taken the
approach of saying "if you want sensible IO performance use
virtio", because some of the above list (no DMA, for instance)
is unavoidable.

-- PMM
