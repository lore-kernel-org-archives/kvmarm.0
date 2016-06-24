From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: issues with emulated PCI MMIO backed by host memory under KVM
Date: Fri, 24 Jun 2016 16:04:45 +0200
Message-ID: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A25E49B4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2016 09:59:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PNDPzShrL5lm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2016 09:59:47 -0400 (EDT)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com
 [209.85.214.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 301DB41390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2016 09:59:46 -0400 (EDT)
Received: by mail-it0-f41.google.com with SMTP id h190so15057004ith.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2016 07:04:46 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Alexander Graf <agraf@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

This old subject came up again in a discussion related to PCIe support
for QEMU/KVM under Tianocore. The fact that we need to map PCI MMIO
regions as cacheable is preventing us from reusing a significant slice
of the PCIe support infrastructure, and so I'd like to bring this up
again, perhaps just to reiterate why we're simply out of luck.

To refresh your memories, the issue is that on ARM, PCI MMIO regions
for emulated devices may be backed by memory that is mapped cacheable
by the host. Note that this has nothing to do with the device being
DMA coherent or not: in this case, we are dealing with regions that
are not memory from the POV of the guest, and it is reasonable for the
guest to assume that accesses to such a region are not visible to the
device before they hit the actual PCI MMIO window and are translated
into cycles on the PCI bus. That means that mapping such a region
cacheable is a strange thing to do, in fact, and it is unlikely that
patches implementing this against the generic PCI stack in Tianocore
will be accepted by the maintainers.

Note that this issue not only affects framebuffers on PCI cards, it
also affects emulated USB host controllers (perhaps Alex can remind us
which one exactly?) and likely other emulated generic PCI devices as
well.

Since the issue exists only for emulated PCI devices whose MMIO
regions are backed by host memory, is there any way we can already
distinguish such memslots from ordinary ones? If we can, is there
anything we could do to treat these specially? Perhaps something like
using read-only memslots so we can at least trap guest writes instead
of having main memory going out of sync with the caches unnoticed? I
am just brainstorming here ...

In any case, it would be good to put this to bed one way or the other
(assuming it hasn't been put to bed already)

Thanks,
Ard.
