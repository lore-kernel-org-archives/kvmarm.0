From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
Date: Mon, 08 Jun 2015 09:53:30 +0300
Message-ID: <01ad01d0a1b7$d4d4fe40$7e7efac0$@samsung.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF87953B46
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 02:43:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aqr7OLLinaXB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2015 02:43:21 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 098F6538D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 02:43:20 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NPM000LY5T74Z30@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 08 Jun 2015 07:53:31 +0100 (BST)
In-reply-to: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello everybody!

> The GICv3 ITS (Interrupt Translation Service) is a part of the
> ARM GICv3 interrupt controller used for implementing MSIs.
> It specifies a new kind of interrupts (LPIs), which are mapped to
> establish a connection between a device, its MSI payload value and
> the target processor the IRQ is eventually delivered to.
> In order to allow using MSIs in an ARM64 KVM guest, we emulate this
> ITS widget in the kernel.

 I have tested the patch and got some more ideas for future extension...

 First of all, it would be nice to have a possibility to directly inject LPIs by number.
This will be useful for irqfd support in qemu.
 Next, irqfd support currently poses a problem. We need to somehow know IRQ number from
MSI-X data (device ID plus event ID). ITS has all this information, so it would be nice to
be able to query for the translation from within userspace. The question is - how to do
it? Should we add some ioctl for this purpose? Currently i am experimenting with extra
KVM_TRANSLATE_MSI ioctl which, given MSI data, would return LPI number.
 Actually before your patch came out i have almost done the same thing. But instead i
decided to implement ITS in qemu while leaving LPI handling to kernel. In this case my
qemu would have everything needed.
 By the way, why did you decide to put everything into kernel? Yes, in-kernel emulation is
faster, but ITS is not accessed frequently.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
