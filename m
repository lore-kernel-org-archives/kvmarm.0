From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [report] boot a vm that with PCI only hierarchy devices and with
 GICv3 , it's failed.
Date: Tue, 18 Jul 2017 12:07:05 +0800
Message-ID: <596D8969.8060107@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 347CE40D16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 00:07:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lj186NEDFAZz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 00:07:37 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CACE40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 00:07:36 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@linaro.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi, all:

I met a problem, I just try to test PCI only hierarchy devices model (qemu/docs/pcie.txt  sections 2.3)

Here is part of qemu cmd:
-device i82801b11-bridge,id=pci.1,bus=pcie.0,addr=0x1 -device pci-bridge,chassis_nr=2,id=pci.2,bus=pci.1,addr=0x0 -device usb-ehci,id=usb,bus=pci.2,addr=0x2
-device virtio-scsi-pci,id=scsi0,bus=pci.2,addr=0x3 -netdev tap,fd=27,id=hostnet0,vhost=on,vhostfd=28 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:60:6b:1d,bus=pci.2,addr=0x1
-vnc 0.0.0.0:0 -device virtio-gpu-pci,id=video0,bus=pci.2,addr=0x4

A single DMI-PCI Bridge, a single PCI-PCI Bridge attached to it.  Four PCI_DEV legacy devices (usb, virtio-scsi-pci, virtio-gpu-pci, virtio-net-pci)attached to the PCI-PCI Bridge.
Boot the vm, it's failed.

I try to debug this problem, and the info just as follow:
(1) Since Eric Auger commit (0d44cdb631ef53ea75be056886cf0541311e48df: KVM: arm64: vgic-its: Interpret MAPD Size field and check related errors), This problem has been exposed.
    Of course, I think this commit must be correct surely.

(2) For guestOS, I notice Marc commit (e8137f4f5088d763ced1db82d3974336b76e1bd2: irqchip: gicv3-its: Iterate over PCI aliases to generate ITS configuration).  This commit brings in that the
    four PCI_DEV legacy devices shared the same devID, same its_dev, same ITT tables, but I think here calculate with wrong total msi vector count.
    (Currently, It seems the total count is the vector count of virtio-net-pci + PCI-PCI bridge + dmi-pci bridge, maybe here should be the total count of the four PCI_DEV legacy devices vector count),
    So that, any pci device using the over bounds eventID and mapti at a certain moment , the abnormal behavior will captured by Eric's commit.

Actually, I don't understand very well about non-transparent bridge, PCI aliases. So just supply these message.

Thanks.
