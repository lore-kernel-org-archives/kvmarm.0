From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Wed, 13 Mar 2019 19:52:30 +0800
Message-ID: <20190313115230.GL13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
 <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
 <e98d267e-db97-8680-62e4-f0788c00cea8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 152A04A321
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 07:52:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43xgVSHN1qV4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Mar 2019 07:52:37 -0400 (EDT)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com
 [209.85.161.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4327D49F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 07:52:37 -0400 (EDT)
Received: by mail-yw1-f41.google.com with SMTP id a199so1188620ywa.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 04:52:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <e98d267e-db97-8680-62e4-f0788c00cea8@redhat.com>
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

On Wed, Mar 13, 2019 at 11:24:25AM +0100, Auger Eric wrote:

[...]

> >> I am stucking at the network card cannot receive interrupts in guest
> >> OS.  So took time to look into the code and added some printed info to
> >> help me to understand the detailed flow, below are two main questions
> >> I am confused with them and need some guidance:
> >>
> >> - The first question is about the msi usage in network card driver;
> >>   when review the sky2 network card driver [1], it has function
> >>   sky2_test_msi() which is used to decide if can use msi or not.
> >>
> >>   The interesting thing is this function will firstly request irq for
> >>   the interrupt and based on the interrupt handler to read back
> >>   register and then can make decision if msi is avalible or not.
> >>
> >>   This can work well for host OS, but if we want to passthrough this
> >>   device to guest OS, since the KVM doesn't prepare the interrupt for
> >>   sky2 drivers (no injection or forwarding) thus at this point the
> >>   interrupt handle will not be invorked.  At the end the driver will
> >>   not set flag 'hw->flags |= SKY2_HW_USE_MSI' and this results to not
> >>   use msi in guest OS and rollback to INTx mode.
> >>
> >>   My first impression is if we passthrough the devices to guest OS in
> >>   KVM, the PCI-e device can directly use msi;  I tweaked a bit for the
> >>   code to check status value after timeout, so both host OS and guest
> >>   OS can set the flag for msi.
> >>
> >>   I want to confirm, if this is the recommended mode for
> >>   passthrough PCI-e device to use msi both in host OS and geust OS?
> >>   Or it's will be fine for host OS using msi and guest OS using
> >>   INTx mode?
> > 
> > If the NIC supports MSIs they logically are used. This can be easily
> > checked on host by issuing "cat /proc/interrupts | grep vfio". Can you
> > check whether the guest received any interrupt? I remember that Robin
> > said in the past that on Juno, the MSI doorbell was in the PCI host
> > bridge window and possibly transactions towards the doorbell could not
> > reach it since considered as peer to peer.
> 
> I found back Robin's explanation. It was not related to MSI IOVA being
> within the PCI host bridge window but RAM GPA colliding with host PCI
> config space?
> 
> "MSI doorbells integral to PCIe root complexes (and thus untranslatable)
> typically have a programmable address, so could be anywhere. In the more
> general category of "special hardware addresses", QEMU's default ARM
> guest memory map puts RAM starting at 0x40000000; on the ARM Juno
> platform, that happens to be where PCI config space starts; as Juno's
> PCIe doesn't support ACS, peer-to-peer or anything clever, if you assign
> the PCI bus to a guest (all of it, given the lack of ACS), the root
> complex just sees the guest's attempts to DMA to "memory" as the device
> attempting to access config space and aborts them."

Thanks a lot for the info, Eric.

Seems to me, this issue can be bypassed by using other memory address
rather than 0x40000000 for kernel IPA thus can avoid colliding with
host PCI config space.

Robin, just curious have you tried to change guest memory start address
for bypassing this issue?  Or tried kvmtool for on Juno-r2 board (e.g.
kvmtool uses 0x4000000 for AXI bus and 0x80000000 for RAM, we can do
some quickly shrinking thus can don't touch 0x40000000 region?)

Thanks,
Leo Yan
