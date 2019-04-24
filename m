From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v4 0/3] vfio-pci: Support INTx mode re-enabling
Date: Wed, 24 Apr 2019 22:21:27 +0800
Message-ID: <20190424142127.GC8948@leoy-ThinkPad-X240s>
References: <20190408012719.16158-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5BE4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:21:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rtPWGYjCvos for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 10:21:37 -0400 (EDT)
Received: from mail-yb1-f196.google.com (mail-yb1-f196.google.com
 [209.85.219.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64BE24A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:21:37 -0400 (EDT)
Received: by mail-yb1-f196.google.com with SMTP id a13so996511ybm.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 07:21:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190408012719.16158-1-leo.yan@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Will Deacon <Will.Deacon@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <Robin.Murphy@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On Mon, Apr 08, 2019 at 09:27:16AM +0800, Leo Yan wrote:
> When enable vfio-pci mode for NIC driver on Juno board, the IRQ is
> failed to forward properly from host to guest, finally root caused this
> issue is related with kvmtool cannot re-enable INTx mode properly.
> 
> So the basic working flow to reproduce this issue is as below:
> 
>     Host             Guest
> -------------  --------------------
>   INTx mode
>                  MSI enable failed in NIC driver
>                  MSI disable in NIC driver
>                  Switch back to INTx mode --> kvmtool doesn't support
> 
> So this patch is to support INTx mode re-enabling; patch 0001 is one
> minor fixing up for eventfd releasing; patch 0002 introduces a new
> function vfio_pci_init_intx() which is used to finish INTx one-time
> initialisation; patch 0003 is the core patch for support INTx mode
> re-enabling, when kvmtool detects MSI is disabled it rollbacks to INTx
> mode.
> 
> This patch set has been tested on Juno-r2 board.
> 
> == Changes for V4 ==
> * Removed the unnecessary comments in patch 0003 (Jean-Philippe).
> * Added Jean-Philippe's review tags.

Could you pick up these 3 patches and merge into kvmtool?  All of them
has been received reviewing tag from Jean-Philippe.  Thanks.

> == Changes for V3 ==
> * Add new function vfio_pci_init_intx() for one-time initialisation.
> * Simplized INTx re-enabling (don't change irq_line anymore at the
>   runtime).
> 
> 
> Leo Yan (3):
>   vfio-pci: Release INTx's unmask eventfd properly
>   vfio-pci: Add new function for INTx one-time initialisation
>   vfio-pci: Re-enable INTx mode when disable MSI/MSIX
> 
>  include/kvm/vfio.h |  1 +
>  vfio/pci.c         | 95 ++++++++++++++++++++++++++++++----------------
>  2 files changed, 64 insertions(+), 32 deletions(-)
> 
> -- 
> 2.19.1
> 
