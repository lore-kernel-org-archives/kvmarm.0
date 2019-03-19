From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Tue, 19 Mar 2019 09:33:58 +0800
Message-ID: <20190319013358.GA3374@leoy-ThinkPad-X240s>
References: <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
 <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
 <e98d267e-db97-8680-62e4-f0788c00cea8@redhat.com>
 <20190315093748.GA20568@leoy-ThinkPad-X240s>
 <adde331f-1be9-2f0c-435a-bd906e0f253f@redhat.com>
 <0e58d46a-a076-e7b6-9b14-6bbefa2ef404@arm.com>
 <20190316045632.GA5330@leoy-ThinkPad-X240s>
 <f245a401-163c-7819-9af5-4226b0ac5f25@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A804A42B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Mar 2019 21:34:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqMZSTi6lkow for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Mar 2019 21:34:06 -0400 (EDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A26A64A414
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Mar 2019 21:34:06 -0400 (EDT)
Received: by mail-oi1-f176.google.com with SMTP id t206so14718118oib.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Mar 2019 18:34:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <f245a401-163c-7819-9af5-4226b0ac5f25@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Robin Murphy <robin.murphy@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Robin,

On Mon, Mar 18, 2019 at 12:25:33PM +0000, Robin Murphy wrote:

[...]

> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index b9d486d..43f78b1 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -7,10 +7,10 @@
> > 
> >   #include "arm-common/gic.h"
> > 
> > -#define ARM_IOPORT_AREA                _AC(0x0000000000000000, UL)
> > -#define ARM_MMIO_AREA          _AC(0x0000000000010000, UL)
> > -#define ARM_AXI_AREA           _AC(0x0000000040000000, UL)
> > -#define ARM_MEMORY_AREA                _AC(0x0000000080000000, UL)
> > +#define ARM_IOPORT_AREA                _AC(0x0000000080000000, UL)
> > +#define ARM_MMIO_AREA          _AC(0x0000000080010000, UL)
> > +#define ARM_AXI_AREA           _AC(0x0000000088000000, UL)
> > +#define ARM_MEMORY_AREA                _AC(0x0000000090000000, UL)
> > 
> > Anyway, very appreciate for the suggestions; it's sufficent for me to
> > dig more for memory related information (e.g. PCIe configurations,
> > IOMMU, etc) and will keep posted if I make any progress.
> 
> None of those should need to change (all the MMIO emulation stuff is
> irrelevant to PCIe DMA anyway) - provided you don't give the guest more than
> 2GB of RAM, passthrough with legacy INTx ought to work out-of-the-box. For
> MSIs to get through, you'll further need to change the host kernel to place
> its software MSI region[2] within any of the host bridge windows as well.

>From PCI configurations dumping, I can see after launch the guest with
kvmtool, the host receives the first interrupt (checked with the
function vfio_intx_handler() has been invoked once) and then PCI sent
command with PCI_COMMAND_INTX_DISABLE to disable interrupt line.  So
this flow is very likely the interrupt is not forwarded properly and
guest doesn't receive interrupt.

It's lucky that I found below flow can let interrupt forwarding from
host to guest after I always set "sky2.disable_msi=1" for both kernel
command lines:

    host                    guest

  INTx mode               INTx mode

So far, it still cannot work well if I only set "sky2.disable_msi=1"
for host kernel command line, with this config it runs with below flow
and which cannot forward interrupt properly from host to guest:

    host                    guest

  INTx mode               msi enable
                          msi disable
                          Switch back to INTx mode

I am so happy now I can use pure INTx mode on Juno board for NIC
enabling and pinged successfully from guest OS to my router :)

Will look into the issue in the second secnario; and if I have more
time I will look into msi mode as well (I confirmed msi mode can work
with host OS but failed in guest OS).

Very appreciate you & Eric helping!

Thanks,
Leo Yan
