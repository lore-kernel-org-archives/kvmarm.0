From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v3 0/3] vfio-pci: Support INTx mode re-enabling
Date: Tue, 26 Mar 2019 15:41:28 +0800
Message-ID: <20190326074131.4284-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 090214A3FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 03:42:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wvtRGs7sA9mO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 03:42:10 -0400 (EDT)
Received: from mail-yw1-f66.google.com (mail-yw1-f66.google.com
 [209.85.161.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD1F840A52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 03:42:10 -0400 (EDT)
Received: by mail-yw1-f66.google.com with SMTP id c4so9033772ywa.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 00:42:10 -0700 (PDT)
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

So this patch is to support INTx mode re-enabling; patch 0001 is one
minor fixing up for eventfd releasing; patch 0002 introduces a new
function vfio_pci_init_intx() which is used to finish INTx one-time
initialisation; patch 0003 is the core patch for support INTx mode
re-enabling, when kvmtool detects MSI is disabled it rollbacks to INTx
mode.

This patch set has been tested on Juno-r2 board.

== Changes for V3 ==
* Add new function vfio_pci_init_intx() for one-time initialisation.
* Simplized INTx re-enabling (don't change irq_line anymore at the
  runtime).


Leo Yan (3):
  vfio-pci: Release INTx's unmask eventfd properly
  vfio-pci: Add new function for INTx one-time initialisation
  vfio-pci: Re-enable INTx mode when disable MSI/MSIX

 include/kvm/vfio.h |   1 +
 vfio/pci.c         | 108 +++++++++++++++++++++++++++++----------------
 2 files changed, 72 insertions(+), 37 deletions(-)

-- 
2.19.1
