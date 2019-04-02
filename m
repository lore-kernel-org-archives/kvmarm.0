From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool v3 0/3] vfio-pci: Support INTx mode re-enabling
Date: Tue, 2 Apr 2019 17:50:25 +0100
Message-ID: <20190402165025.GA1442@fuggles.cambridge.arm.com>
References: <20190326074131.4284-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 813894A3B2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 12:50:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2GOJ24Bs+xxy for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Apr 2019 12:50:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44F274A34E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 12:50:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190326074131.4284-1-leo.yan@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Leo Yan <leo.yan@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Leo,

On Tue, Mar 26, 2019 at 03:41:28PM +0800, Leo Yan wrote:
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
> == Changes for V3 ==
> * Add new function vfio_pci_init_intx() for one-time initialisation.
> * Simplized INTx re-enabling (don't change irq_line anymore at the
>   runtime).

Just checking, but is this series intended to supersede this one:

https://www.spinics.net/lists/kvm/msg183750.html

?

Thanks,

Will
