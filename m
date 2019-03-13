From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Wed, 13 Mar 2019 19:35:49 +0800
Message-ID: <20190313113549.GK13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
 <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECED4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 07:35:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qnmevZiljsev for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Mar 2019 07:35:56 -0400 (EDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com
 [209.85.161.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 918E249F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 07:35:56 -0400 (EDT)
Received: by mail-yw1-f52.google.com with SMTP id m207so1133349ywd.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 04:35:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On Wed, Mar 13, 2019 at 11:01:33AM +0100, Auger Eric wrote:

[...]

> >   I want to confirm, if this is the recommended mode for
> >   passthrough PCI-e device to use msi both in host OS and geust OS?
> >   Or it's will be fine for host OS using msi and guest OS using
> >   INTx mode?
> 
> If the NIC supports MSIs they logically are used. This can be easily
> checked on host by issuing "cat /proc/interrupts | grep vfio". Can you
> check whether the guest received any interrupt? I remember that Robin
> said in the past that on Juno, the MSI doorbell was in the PCI host
> bridge window and possibly transactions towards the doorbell could not
> reach it since considered as peer to peer. Using GICv2M should not bring
> any performance issue. I tested that in the past with Seattle board.

I can see below info on host with launching KVM:

root@debian:~# cat /proc/interrupts | grep vfio
 46:          0          0          0          0          0          0       MSI 4194304 Edge      vfio-msi[0](0000:08:00.0)

And below is interrupts in guest:

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
  3:        506        400        281        403        298        330     GIC-0  27 Level     arch_timer
  5:        768          0          0          0          0          0     GIC-0 101 Edge      virtio0
  6:        246          0          0          0          0          0     GIC-0 102 Edge      virtio1
  7:          2          0          0          0          0          0     GIC-0 103 Edge      virtio2
  8:        210          0          0          0          0          0     GIC-0  97 Level     ttyS0
 13:          0          0          0          0          0          0       MSI   0 Edge      eth1

> > - The second question is for GICv2m.  If I understand correctly, when
> >   passthrough PCI-e device to guest OS, in the guest OS we should
> >   create below data path for PCI-e devices:
> >                                                             +--------+
> >                                                          -> | Memory |
> >     +-----------+    +------------------+    +-------+  /   +--------+
> >     | Net card  | -> | PCI-e controller | -> | IOMMU | -
> >     +-----------+    +------------------+    +-------+  \   +--------+
> >                                                          -> | MSI    |
> >                                                             | frame  |
> >                                                             +--------+
> > 
> >   Since now the master is network card/PCI-e controller but not CPU,
> >   thus there have no 2 stages for memory accessing (VA->IPA->PA).  In
> >   this case, if we configure IOMMU (SMMU) for guest OS for address
> >   translation before switch from host to guest, right?  Or SMMU also
> >   have two stages memory mapping?
> 
> in your use case you don't have any virtual IOMMU. So the guest programs
> the assigned device with guest physical device and the virtualizer uses
> the physical IOMMU to translate this GPA into host physical address
> backing the guest RAM and the MSI frame. A single stage of the physical
> IOMMU is used (stage1).

Thanks a lot for the explaination.

> >   Another thing confuses me is I can see the MSI frame is mapped to
> >   GIC's physical address in host OS, thus the PCI-e device can send
> >   message correctly to msi frame.  But for guest OS, the MSI frame is
> >   mapped to one IPA memory region, and this region is use to emulate
> >   GICv2 msi frame rather than the hardware msi frame; thus will any
> >   access from PCI-e to this region will trap to hypervisor in CPU
> >   side so KVM hyperviso can help emulate (and inject) the interrupt
> >   for guest OS?
> 
> when the device sends an MSI it uses a host allocated IOVA for the
> physical MSI doorbell. This gets translated by the physical IOMMU,
> reaches the physical doorbell. The physical GICv2m triggers the
> associated physical SPI -> kvm irqfd -> virtual IRQ
> With GICv2M we have direct GSI mapping on guest.

Just want to confirm, in your elaborated flow the virtual IRQ will be
injected by qemu (or kvmtool) for every time but it's not needed to
interfere with IRQ's deactivation, right?

> >   Essentially, I want to check what's the expected behaviour for GICv2
> >   msi frame working mode when we want to passthrough one PCI-e device
> >   to guest OS and the PCI-e device has one static msi frame for it.
> 
> Your config was tested in the past with Seattle (not with sky2 NIC
> though). Adding Robin for the peer to peer potential concern.

Very appreciate for your help.

Thanks,
Leo Yan
