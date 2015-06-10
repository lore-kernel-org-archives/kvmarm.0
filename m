From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: IRQFD support with GICv3 ITS (WAS: RE: [PATCH 00/13] arm64: KVM:
 GICv3 ITS emulation)
Date: Wed, 10 Jun 2015 18:30:13 +0300
Message-ID: <05da01d0a392$58bf5030$0a3df090$@samsung.com>
References: <042601d0a357$d3cec4d0$7b6c4e70$@samsung.com>
 <557842A0.9070503@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D0C53259
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 11:20:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S4vS9YJTSA+2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 11:19:57 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEDD753223
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 11:19:57 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NPQ00JFPJ2EIRC0@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 10 Jun 2015 16:30:14 +0100 (BST)
In-reply-to: <557842A0.9070503@linaro.org>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Eric Auger' <eric.auger@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <Andre.Przywara@arm.com>, christoffer.dall@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hi!

> indeed in newly added qemu kvm-all.c kvm_arch_msi_data_to_gsi we could
> call a new ioctl that translates the data + deviceid? into an LPI and
> program irqfd with that LPI. This is done once when setting irqfd up.
> This also means extending irqfd support to lpi injection, gsi being the
> LPI index if gsi >= 8192. in that case we continue using
> kvm_gsi_direct_mapping and gsi still is an IRQ index.

 This is exactly what i have done in my kernel + qemu. I have added a new KVM capability
and then in qemu i do this:
--- cut ---
    if (kvm_gsi_kernel_mapping()) {
        struct kvm_msi msi;

        msi.address_lo = (uint32_t)msg.address;
        msi.address_hi = msg.address >> 32;
        msi.data = le32_to_cpu(msg.data);
        memset(msi.pad, 0, sizeof(msi.pad));

        if (dev) {
            msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
            msi.flags = KVM_MSI_VALID_DEVID;
        } else {
            msi.devid = 0;
            msi.flags = 0;
        }

        return kvm_vm_ioctl(s, KVM_TRANSLATE_MSI, &msi);
    }
--- cut ---
 KVM_TRANSLATE_MSI returns an LPI number. This seemed to be the simplest and fastest thing
to do.
 If someone is interested, i could prepare an RFC patch series for this, which would apply
on top of Andre's ITS implementation.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
