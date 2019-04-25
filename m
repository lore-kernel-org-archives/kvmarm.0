From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 0/3] vfio-pci: Support INTx mode re-enabling
Date: Thu, 25 Apr 2019 15:03:01 +0100
Message-ID: <20190425140301.GD23796@fuggles.cambridge.arm.com>
References: <20190408012719.16158-1-leo.yan@linaro.org>
 <20190424142127.GC8948@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E424A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 10:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XD5-hUGdkQ86 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 10:03:06 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F6FC4A321
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 10:03:06 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190424142127.GC8948@leoy-ThinkPad-X240s>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 10:21:27PM +0800, Leo Yan wrote:
> On Mon, Apr 08, 2019 at 09:27:16AM +0800, Leo Yan wrote:
> > When enable vfio-pci mode for NIC driver on Juno board, the IRQ is
> > failed to forward properly from host to guest, finally root caused this
> > issue is related with kvmtool cannot re-enable INTx mode properly.
> > 
> > So the basic working flow to reproduce this issue is as below:
> > 
> >     Host             Guest
> > -------------  --------------------
> >   INTx mode
> >                  MSI enable failed in NIC driver
> >                  MSI disable in NIC driver
> >                  Switch back to INTx mode --> kvmtool doesn't support
> > 
> > So this patch is to support INTx mode re-enabling; patch 0001 is one
> > minor fixing up for eventfd releasing; patch 0002 introduces a new
> > function vfio_pci_init_intx() which is used to finish INTx one-time
> > initialisation; patch 0003 is the core patch for support INTx mode
> > re-enabling, when kvmtool detects MSI is disabled it rollbacks to INTx
> > mode.
> > 
> > This patch set has been tested on Juno-r2 board.
> > 
> > == Changes for V4 ==
> > * Removed the unnecessary comments in patch 0003 (Jean-Philippe).
> > * Added Jean-Philippe's review tags.
> 
> Could you pick up these 3 patches and merge into kvmtool?  All of them
> has been received reviewing tag from Jean-Philippe.  Thanks.

Sorry, I've fallen behind on kvmtool patches recently. I'll make a note
to queue this lot up tomorrow.

Cheers,

Will
