From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [report] boot a vm that with PCI only hierarchy devices and with
 GICv3 , it's failed.
Date: Tue, 18 Jul 2017 11:02:51 +0100
Message-ID: <03cf57bf-a22a-c679-21d6-1ea174c4f809@arm.com>
References: <596D8969.8060107@huawei.com>
 <dd59da6d-b775-4b2b-385c-ff8a909399d8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F46240A86
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 06:02:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P0OpLJ-lp3xu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 06:02:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D404D40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 06:02:06 -0400 (EDT)
In-Reply-To: <dd59da6d-b775-4b2b-385c-ff8a909399d8@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, wanghaibin <wanghaibin.wang@huawei.com>, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 18/07/17 10:15, Marc Zyngier wrote:
> On 18/07/17 05:07, wanghaibin wrote:
>> Hi, all:
>>
>> I met a problem, I just try to test PCI only hierarchy devices model (qemu/docs/pcie.txt  sections 2.3)
>>
>> Here is part of qemu cmd:
>> -device i82801b11-bridge,id=pci.1,bus=pcie.0,addr=0x1 -device pci-bridge,chassis_nr=2,id=pci.2,bus=pci.1,addr=0x0 -device usb-ehci,id=usb,bus=pci.2,addr=0x2
>> -device virtio-scsi-pci,id=scsi0,bus=pci.2,addr=0x3 -netdev tap,fd=27,id=hostnet0,vhost=on,vhostfd=28 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:60:6b:1d,bus=pci.2,addr=0x1
>> -vnc 0.0.0.0:0 -device virtio-gpu-pci,id=video0,bus=pci.2,addr=0x4
>>
>> A single DMI-PCI Bridge, a single PCI-PCI Bridge attached to it.  Four PCI_DEV legacy devices (usb, virtio-scsi-pci, virtio-gpu-pci, virtio-net-pci)attached to the PCI-PCI Bridge.
>> Boot the vm, it's failed.

What's the nature of the failure? Does it hit some actual error case in
the GIC code, or does it simply hang up probing the virtio devices
because interrupts never arrive?

>> I try to debug this problem, and the info just as follow:
>> (1) Since Eric Auger commit (0d44cdb631ef53ea75be056886cf0541311e48df: KVM: arm64: vgic-its: Interpret MAPD Size field and check related errors), This problem has been exposed.
>>     Of course, I think this commit must be correct surely.
>>
>> (2) For guestOS, I notice Marc commit (e8137f4f5088d763ced1db82d3974336b76e1bd2: irqchip: gicv3-its: Iterate over PCI aliases to generate ITS configuration).  This commit brings in that the
>>     four PCI_DEV legacy devices shared the same devID, same its_dev, same ITT tables, but I think here calculate with wrong total msi vector count.
>>     (Currently, It seems the total count is the vector count of virtio-net-pci + PCI-PCI bridge + dmi-pci bridge, maybe here should be the total count of the four PCI_DEV legacy devices vector count),
>>     So that, any pci device using the over bounds eventID and mapti at a certain moment , the abnormal behavior will captured by Eric's commit.

Now, at worst that patch *should* result in the same number of vectors
being reserved as before - never fewer. Does anything change with it
reverted?

>> Actually, I don't understand very well about non-transparent bridge, PCI aliases. So just supply these message.

Note that there are further issues with PCI RID to DevID mappings in the
face of aliases[1], but I think the current code does happen to work out
OK for the PCI-PCIe bridge case already.

> +Robin, who is the author of that patch.
> 
> Regarding (2), the number of MSIs should be the total number of devices
> that are going to generate the same DevID. Since the bridge is
> non-transparent, everything behind it aliases with it. So you should
> probably see all the virtio devices and the bridges themselves being
> counted. If that's not the case, then "we have a bug"(tm).
> 
> Can you please post your full qemu cmd line so that we can reproduce it
> and investigate the issue?

Yes, that would be good.

Robin.

[1] https://patchwork.ozlabs.org/patch/769303/

> Thanks,
> 
> 	M.
> 
