From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Sat, 16 Mar 2019 12:56:32 +0800
Message-ID: <20190316045632.GA5330@leoy-ThinkPad-X240s>
References: <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
 <20190313080048.GI13422@leoy-ThinkPad-X240s>
 <35c22d0c-7da5-4e68-effb-05c8571d8b63@redhat.com>
 <e98d267e-db97-8680-62e4-f0788c00cea8@redhat.com>
 <20190315093748.GA20568@leoy-ThinkPad-X240s>
 <adde331f-1be9-2f0c-435a-bd906e0f253f@redhat.com>
 <0e58d46a-a076-e7b6-9b14-6bbefa2ef404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90F084A486
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Mar 2019 00:56:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id voeEDLmGUOnc for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Mar 2019 00:56:40 -0400 (EDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ED944A485
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Mar 2019 00:56:40 -0400 (EDT)
Received: by mail-ot1-f53.google.com with SMTP id v62so10197221otb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 21:56:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <0e58d46a-a076-e7b6-9b14-6bbefa2ef404@arm.com>
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

On Fri, Mar 15, 2019 at 12:54:10PM +0000, Robin Murphy wrote:
> Hi Leo,
> 
> Sorry for the delay - I'm on holiday this week, but since I've made the
> mistake of glancing at my inbox I should probably save you from wasting any
> more time...

Sorry for disturbing you in holiday and appreciate your help.  It's no
rush to reply.

> On 2019-03-15 11:03 am, Auger Eric wrote:
> > Hi Leo,
> > 
> > + Jean-Philippe
> > 
> > On 3/15/19 10:37 AM, Leo Yan wrote:
> > > Hi Eric, Robin,
> > > 
> > > On Wed, Mar 13, 2019 at 11:24:25AM +0100, Auger Eric wrote:
> > > 
> > > [...]
> > > 
> > > > > If the NIC supports MSIs they logically are used. This can be easily
> > > > > checked on host by issuing "cat /proc/interrupts | grep vfio". Can you
> > > > > check whether the guest received any interrupt? I remember that Robin
> > > > > said in the past that on Juno, the MSI doorbell was in the PCI host
> > > > > bridge window and possibly transactions towards the doorbell could not
> > > > > reach it since considered as peer to peer.
> > > > 
> > > > I found back Robin's explanation. It was not related to MSI IOVA being
> > > > within the PCI host bridge window but RAM GPA colliding with host PCI
> > > > config space?
> > > > 
> > > > "MSI doorbells integral to PCIe root complexes (and thus untranslatable)
> > > > typically have a programmable address, so could be anywhere. In the more
> > > > general category of "special hardware addresses", QEMU's default ARM
> > > > guest memory map puts RAM starting at 0x40000000; on the ARM Juno
> > > > platform, that happens to be where PCI config space starts; as Juno's
> > > > PCIe doesn't support ACS, peer-to-peer or anything clever, if you assign
> > > > the PCI bus to a guest (all of it, given the lack of ACS), the root
> > > > complex just sees the guest's attempts to DMA to "memory" as the device
> > > > attempting to access config space and aborts them."
> > > 
> > > Below is some following investigation at my side:
> > > 
> > > Firstly, must admit that I don't understand well for up paragraph; so
> > > based on the description I am wandering if can use INTx mode and if
> > > it's lucky to avoid this hardware pitfall.
> > 
> > The problem above is that during the assignment process, the virtualizer
> > maps the whole guest RAM though the IOMMU (+ the MSI doorbell on ARM) to
> > allow the device, programmed in GPA to access the whole guest RAM.
> > Unfortunately if the device emits a DMA request with 0x40000000 IOVA
> > address, this IOVA is interpreted by the Juno RC as a transaction
> > towards the PCIe config space. So this DMA request will not go beyond
> > the RC, will never reach the IOMMU and will never reach the guest RAM.
> > So globally the device is not able to reach part of the guest RAM.
> > That's how I interpret the above statement. Then I don't know the
> > details of the collision, I don't have access to this HW. I don't know
> > either if this problem still exists on the r2 HW.

Thanks a lot for rephrasing, Eric :)

> The short answer is that if you want PCI passthrough to work on Juno, the
> guest memory map has to look like a Juno.
> 
> The PCIe root complex uses an internal lookup table to generate appropriate
> AXI attributes for outgoing PCIe transactions; unfortunately this has no
> notion of 'default' attributes, so addresses *must* match one of the
> programmed windows in order to be valid. From memory, EDK2 sets up a 2GB
> window covering the lower DRAM bank, an 8GB window covering the upper DRAM
> bank, and a 1MB (or thereabouts) window covering the GICv2m region with
> Device attributes.

I checked kernel memory blocks info, it gives out below result:

root@debian:~# cat /sys/kernel/debug/memblock/memory
   0: 0x0000000080000000..0x00000000feffffff
   1: 0x0000000880000000..0x00000009ffffffff

So I think the lower 2GB DRAM window is: [0x8000_0000..0xfeff_ffff]
and the high DRAM window is [0x8_8000_0000..0x9_ffff_ffff].

BTW, now I am using uboot rather than UEFI, so not sure if uboot has
programmed memory windows for PCIe.  Could you help give a point for
which registers should be set in UEFI thus I also can check related
configurations in uboot?

> Any PCIe transactions to addresses not within one of
> those windows will be aborted by the RC without ever going out to the AXI
> side where the SMMU lies (and I think anything matching the config space or
> I/O space windows or a region claimed by a BAR will be aborted even earlier
> as a peer-to-peer attempt regardless of the AXI Translation Table setup).
> 
> You could potentially modify the firmware to change the window
> configuration, but the alignment restrictions make it awkward. I've only
> ever tested passthrough on Juno using kvmtool, which IIRC already has guest
> RAM in an appropriate place (and is trivially easy to hack if not) - I don't
> remember if I ever actually tried guest MSI with that.

I did several tries with kvmtool to tweak memory regions but it's no
lucky.  Since the host uses [0x8000_0000..0xfeff_ffff] as the first
valid memory window for PCIe, thus I tried to change all memory/io
regions into this window with below changes but it's no lucky:

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b9d486d..43f78b1 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -7,10 +7,10 @@

 #include "arm-common/gic.h"

-#define ARM_IOPORT_AREA                _AC(0x0000000000000000, UL)
-#define ARM_MMIO_AREA          _AC(0x0000000000010000, UL)
-#define ARM_AXI_AREA           _AC(0x0000000040000000, UL)
-#define ARM_MEMORY_AREA                _AC(0x0000000080000000, UL)
+#define ARM_IOPORT_AREA                _AC(0x0000000080000000, UL)
+#define ARM_MMIO_AREA          _AC(0x0000000080010000, UL)
+#define ARM_AXI_AREA           _AC(0x0000000088000000, UL)
+#define ARM_MEMORY_AREA                _AC(0x0000000090000000, UL)

Anyway, very appreciate for the suggestions; it's sufficent for me to
dig more for memory related information (e.g. PCIe configurations,
IOMMU, etc) and will keep posted if I make any progress.

Thanks,
Leo Yan
