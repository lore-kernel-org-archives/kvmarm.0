From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 0/3] Add support for for GICv2m and MSIs to arm-virt
Date: Wed, 6 May 2015 17:39:28 +0100
Message-ID: <CAFEAcA84kB2iq-fwW6950rVtjuh5Li5b=edkSxooo9bDMgDuPw@mail.gmail.com>
References: <1430155872-27030-1-git-send-email-christoffer.dall@linaro.org>
 <CAFEAcA8WecTOiAKYxOOOrsJPyaQxpNskjE799kS8kipg4q3KMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D4350AD3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 12:31:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YI1Ve63LYxc9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2015 12:31:01 -0400 (EDT)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
 [209.85.223.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF3B950ACC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 12:31:00 -0400 (EDT)
Received: by iedfl3 with SMTP id fl3so20690362ied.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 May 2015 09:39:48 -0700 (PDT)
In-Reply-To: <CAFEAcA8WecTOiAKYxOOOrsJPyaQxpNskjE799kS8kipg4q3KMQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 6 May 2015 at 17:33, Peter Maydell <peter.maydell@linaro.org> wrote:
> On 27 April 2015 at 18:31, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> Now when we have a host generic PCIe controller in the virt board, it
>> would be nice to be able to use MSIs so that we can eventually enable
>> VHOST with KVM.
>>
>> With these patches you can use MSIs with TCG and with KVM, but you still
>> need some fixes for the mapping of the IRQ index to the GSI number for
>> IRQFD to work.  A separate series that enables IRQFD and vhost
>> is available: "ARM adaptations for vhost irqfd setup"
>> https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg01054.html)
>>
>> Tested with KVM on XGene and with TCG by configuring a virtio-pci
>> network adapter for the guest and verifying MSIs going through as
>> expected.
>
> You forgot to change the QOM device name to 'arm-gicv2m', but
> I'll fix that up as I apply this to target-arm.next.

...except this series breaks booting of a linux guest using PCI
on the virt board with aarch32:

PCI host bridge /pcie@10000000 ranges:
   IO 0x3eff0000..0x3effffff -> 0x00000000
  MEM 0x10000000..0x3efeffff -> 0x10000000
pci-host-generic 3f000000.pcie: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-0f]
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x10000000-0x3efeffff]
PCI: bus0: Fast back to back transfers disabled
pci 0000:00:01.0: of_irq_parse_pci() failed with rc=-22
pci 0000:00:02.0: of_irq_parse_pci() failed with rc=-22
pci 0000:00:02.0: BAR 6: assigned [mem 0x10000000-0x1003ffff pref]
pci 0000:00:01.0: BAR 1: assigned [mem 0x10040000-0x10040fff]
pci 0000:00:02.0: BAR 1: assigned [mem 0x10041000-0x10041fff]
pci 0000:00:01.0: BAR 0: assigned [io  0x1000-0x103f]
pci 0000:00:02.0: BAR 0: assigned [io  0x1040-0x105f]
virtio-pci 0000:00:01.0: enabling device (0100 -> 0103)
virtio-pci 0000:00:02.0: enabling device (0100 -> 0103)
virtio_blk: probe of virtio32 failed with error -22
virtio_net: probe of virtio33 failed with error -22

(and without virtio-blk we don't mount our rootfs).

-- PMM
