From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/3] kvmtool: fix vhost-net support
Date: Tue,  1 Mar 2016 16:49:35 +0000
Message-ID: <1456850978-14091-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8007841267
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 11:42:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9OUuDRqlwupz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 11:42:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18428411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 11:42:37 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this mini-series is a spin-off of my ITS emulation series, so those
patches have been on the list before [1].
I repost them separately here to get them merged, because patch 2/3
fixes a real issue:
Vhost-net support seems to be broken (on x86). In my experiments
(-n mode=tap,script=/etc/qemu-ifup,vhost=1) the guest hangs because
it waits for an virtio IRQ to trigger. But the MSI never makes it
through, because virtio-pci changes the MSI configuration _after_
having set up the IRQ routing for this interrupt. So we need to update
the IRQ routing in case PCI config space accesses change the MSIs.

I put the move of the IRQ routing code into generic code here as 1/3,
since we need this anyway later and swapping the two patches looks
like pain, which we would also need to redo later anyway. Also it
should help to consolidate other IRQ related patches.
Finally we deny vhost-net on any bi-endian architecture at the moment,
which is unnecessary as long as host and guest use the same endianess.
Patch 3/3 fixes this.

Please have a look and apply!

Cheers,
Andre.

[1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2015-July/357884.html

Andre Przywara (3):
  irq: move IRQ routing into irq.c
  MSI-X: update GSI routing after changed MSI-X configuration
  virtio: fix endianness check for vhost support

 Makefile             |   4 +-
 arm/irq.c            |   9 ----
 hw/pci-shmem.c       |   2 +
 include/kvm/irq.h    |   6 +++
 include/kvm/virtio.h |   9 +++-
 irq.c                | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mips/irq.c           |  10 -----
 powerpc/irq.c        |  31 --------------
 virtio/net.c         |   2 +-
 virtio/pci.c         |  54 ++++++++++++++++++++----
 x86/irq.c            |  45 +++-----------------
 11 files changed, 181 insertions(+), 105 deletions(-)
 delete mode 100644 arm/irq.c
 delete mode 100644 mips/irq.c
 delete mode 100644 powerpc/irq.c

-- 
2.6.4
