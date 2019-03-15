From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Fri, 15 Mar 2019 17:37:48 +0800
Message-ID: <20190315093748.GA20568@leoy-ThinkPad-X240s>
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
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9933B4A44D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 05:37:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4LkgL6SioM4K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 05:37:55 -0400 (EDT)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FCDA4A41C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 05:37:55 -0400 (EDT)
Received: by mail-oi1-f175.google.com with SMTP id k8so6769659oik.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 02:37:55 -0700 (PDT)
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

Hi Eric, Robin,

On Wed, Mar 13, 2019 at 11:24:25AM +0100, Auger Eric wrote:

[...]

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

Below is some following investigation at my side:

Firstly, must admit that I don't understand well for up paragraph; so
based on the description I am wandering if can use INTx mode and if
it's lucky to avoid this hardware pitfall.

But when I want to rollback to use INTx mode I found there have issue
for kvmtool to support INTx mode, so this is why I wrote the patch [1]
to fix the issue.  Alternatively, we also can set the NIC driver
module parameter 'sky2.disable_msi=1' thus can totally disable msi and
only use INTx mode.

Anyway, finally I can get INTx mode enabled and I can see the
interrupt will be registered successfully on both host and guest:

Host side:

           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
 41:          0          0          0          0          0          0     GICv2  54 Level     arm-pmu
 42:          0          0          0          0          0          0     GICv2  58 Level     arm-pmu
 43:          0          0          0          0          0          0     GICv2  62 Level     arm-pmu
 45:        772          0          0          0          0          0     GICv2 171 Level     vfio-intx(0000:08:00.0)

Guest side:

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
 12:          0          0          0          0          0          0     GIC-0  96 Level     eth1

So you could see the host can receive the interrupts, but these
interrupts are mainly triggered before binding vfio-pci driver.  But
seems now after launch kvm I can see there have very small mount
interrupts are triggered in host and the guest kernel also can receive
the virtual interrupts, e.g. if use 'dhclient eth1' command in guest
OS, this command stalls for long time (> 1 minute) after return back,
I can see both the host OS and guest OS can receive 5~6 interrupts.
Based on this, I guess the flow for interrupts forwarding has been
enabled.  But seems the data packet will not really output and I use
wireshark to capture packets, but cannot find any packet output from
the NIC.

I did another testing is to shrink the memory space/io/bus region to
less than 0x40000000, so this can avoid to put guest memory IPA into
0x40000000.  But this doesn't work.

@Robin, could you help explain for the hardware issue and review my
methods are feasible on Juno board?  Thanks a lot for suggestions.

I will dig more for the memory mapping and post at here.

Thanks,
Leo Yan

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/035055.html
