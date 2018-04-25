From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 0/3] arm/gic: minor fixes to ITS and GICv2m
Date: Wed, 25 Apr 2018 11:09:42 +0100
Message-ID: <20180425100945.19171-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAB594070F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:01:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TKU-1wxNfgzA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 06:00:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC5040170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:00:39 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Three minor fixes I stumbled upon when hacking around in kvmtool.
Not sure how the v2m support actually worked at the moment.
We might want to look at some MMIO space allocation algorithm to use for
the GIC as well, possibly merging it with the virtio MMIO allocation we
already have in place (virtio_mmio_get_io_space_block()). Not sure what
the reason was to put the GIC at a different place.

Cheers,
Andre.

Andre Przywara (3):
  arm/gic: remove extra 64K from ITS allocation
  arm/gic: avoid GICv2m MMIO frame overlap
  arm/gic: move GICv2M gadget size into private header

 arm/aarch32/include/asm/kvm.h | 2 --
 arm/aarch64/include/asm/kvm.h | 2 --
 arm/gic.c                     | 6 +++---
 arm/include/arm-common/gic.h  | 2 ++
 4 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.14.1
