From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v2 0/3] vfio-pci: Support INTx mode re-enabling
Date: Wed, 20 Mar 2019 14:20:43 +0800
Message-ID: <20190320062046.3895-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D7704A330
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rdc3a822voAu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 02:21:09 -0400 (EDT)
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com
 [209.85.167.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5378D49F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:09 -0400 (EDT)
Received: by mail-oi1-f195.google.com with SMTP id v84so917049oif.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 23:21:09 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <robin.murphy@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When enable vfio-pci mode for NIC driver on Juno board, the IRQ is
failed to forward properly from host to guest, finally root caused this
issue is related with kvmtool cannot re-enable INTx mode properly.

So the basic working flow to reproduce this issue is as below:

    Host             Guest
-------------  --------------------
  INTx mode
                 MSI enable failed in NIC driver
                 MSI disable in NIC driver
                 Switch back to INTx mode --> kvmtool doesn't support

So this patch is to support INTx mode re-enabling; 0001/0002 patches
are only minor fixing up for eventfd releasing and remove useless FDs
reservation for INTx.  0003 patch is the core patch for supporting
INTx mode re-enabling, when kvmtool detects MSI is disabled it
rollbacks to INTx mode.

This patch set has been tested on Juno-r2 board.

Leo Yan (3):
  vfio-pci: Release INTx's unmask eventfd properly
  vfio-pci: Remove useless FDs reservation in vfio_pci_enable_intx()
  vfio-pci: Re-enable INTx mode when disable MSI/MSIX

 include/kvm/vfio.h |  1 +
 vfio/pci.c         | 61 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 12 deletions(-)

-- 
2.19.1
