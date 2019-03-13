From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Wed, 13 Mar 2019 18:01:17 +0800
Message-ID: <20190313100116.GJ13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42DCA4A369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 06:01:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6HRpLxJgd8Gu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Mar 2019 06:01:24 -0400 (EDT)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 294EA4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 06:01:24 -0400 (EDT)
Received: by mail-yw1-f68.google.com with SMTP id 189so940634ywi.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 03:01:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190313080048.GI13422@leoy-ThinkPad-X240s>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 13, 2019 at 04:00:48PM +0800, Leo Yan wrote:

[...]

> - The second question is for GICv2m.  If I understand correctly, when
>   passthrough PCI-e device to guest OS, in the guest OS we should
>   create below data path for PCI-e devices:
>                                                             +--------+
>                                                          -> | Memory |
>     +-----------+    +------------------+    +-------+  /   +--------+
>     | Net card  | -> | PCI-e controller | -> | IOMMU | -
>     +-----------+    +------------------+    +-------+  \   +--------+
>                                                          -> | MSI    |
>                                                             | frame  |
>                                                             +--------+
> 
>   Since now the master is network card/PCI-e controller but not CPU,
>   thus there have no 2 stages for memory accessing (VA->IPA->PA).  In
>   this case, if we configure IOMMU (SMMU) for guest OS for address
>   translation before switch from host to guest, right?  Or SMMU also
>   have two stages memory mapping?
> 
>   Another thing confuses me is I can see the MSI frame is mapped to
>   GIC's physical address in host OS, thus the PCI-e device can send
>   message correctly to msi frame.  But for guest OS, the MSI frame is
>   mapped to one IPA memory region, and this region is use to emulate
>   GICv2 msi frame rather than the hardware msi frame; thus will any
>   access from PCI-e to this region will trap to hypervisor in CPU
>   side so KVM hyperviso can help emulate (and inject) the interrupt
>   for guest OS?
> 
>   Essentially, I want to check what's the expected behaviour for GICv2
>   msi frame working mode when we want to passthrough one PCI-e device
>   to guest OS and the PCI-e device has one static msi frame for it.

>From the blog [1], it has below explanation for my question for mapping
IOVA and hardware msi address.  But I searched the flag
VFIO_DMA_FLAG_MSI_RESERVED_IOVA which isn't found in mainline kernel;
I might miss something for this, want to check if related patches have
been merged in the mainline kernel?

'We reuse the VFIO DMA MAP ioctl to pass this reserved IOVA region. A
new flag (VFIO_DMA_FLAG_MSI_RESERVED_IOVA ) is introduced to
differentiate such reserved IOVA from RAM IOVA. Then the base/size of
the window is passed to the IOMMU driver though a new function
introduced in the IOMMU API. 

The IOVA allocation within the supplied reserved IOVA window is
performed on-demand, when the MSI controller composes/writes the MSI
message in the PCIe device. Also the IOMMU mapping between the newly
allocated IOVA and the backdoor address page is done at that time. The
MSI controller uses a new function introduced in the IOMMU API to
allocate the IOVA and create an IOMMU mapping.
 
So there are adaptations needed at VFIO, IOMMU and MSI controller
level. The extension of the IOMMU API still is under discussion. Also
changes at MSI controller level need to be consolidated.'

P.s. I also tried two tools qemu/kvmtool, both cannot pass interrupt
for network card in guest OS.

Thanks,
Leo Yan

[1] https://www.linaro.org/blog/kvm-pciemsi-passthrough-armarm64/
