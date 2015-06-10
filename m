From: Pavel Fedin <p.fedin@samsung.com>
Subject: IRQFD support with GICv3 ITS (WAS: RE: [PATCH 00/13] arm64: KVM: GICv3
 ITS emulation)
Date: Wed, 10 Jun 2015 11:31:19 +0300
Message-ID: <042601d0a357$d3cec4d0$7b6c4e70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19A2C54091
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 04:21:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgjckgU2jECs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 04:21:04 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B28B15407A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 04:21:03 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NPP001D6ZO8YV20@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 10 Jun 2015 09:31:20 +0100 (BST)
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

 Hello guys!

> Currently on ARM, irqfd supports routing an host eventfd towards a
> virtual SPI:
> eventfd -> vSPI = gsi+32
> parameters of irqfd are the eventfd and the gsi.

 Yes, but this works only with GICv2m, because it actually turns MSI data into SPI number.
ITS works in a completely different way.

> 2) now we have virtual msi injection, we could use msi routing to inject
> virtual LPI's. But is it what you need for your qemu integration?

 Actually this is what i wanted to discuss here...
 I have studied a little bit IRQ routing mechanism... And it comes to a question what is
'GSI'. As far as i could understand, on x86 GSI is a completely virtual entity, which can
be tied either to irqchip's pin (physical IRQ) or MSI event. There is totally no
correspondence between GSI numbers and guest IRQ numbers. GSIs are just allocated by the
userspace starting from 0 and on. Is my understanding correct?
 On ARM, i see, completely different approach is used. For KVM_IRQ_LINE ioctl GSI is
actually a raw GIC IRQ number plus some extra bits for target and type. For KVM_IRQFD with
GICv2m GSI is actually SPI number (starting from zero, so that IRQ = GSI + 32).
 First of all, i would say that we already have an inconsistence in ARM API. The same
thing called GSI has two different meanings for different functions.
 I think it would be a bad idea to introduce a third, separate meaning for MSIs. However,
this is what we could do:

 Approach 1: GICv2m way.
 We could add one more IOCTL which would decode MSI data into IRQ (in our case it's LPI)
number. What it would return is LPI - 32, to keep in line with existing convention.
 Pros: does not bring any more inconsistence into KVM API.
 Cons: requires adding one more IOCTL and one more MSI handling mechanism. Isn't there too
many of them already?

 Approach 2: IRQ routing.
 We could implement MSI routing using virtual GSI numbers. In order to stay compatible
with what we have, we could say that GSI numbers below 8192 are SPI GSIs, and everything
starting from 8192 is MSI. Then we could use KVM_SET_GSI_ROUTING ioctl to assign these
GSIs to actual MSIs which then will go full-cycle through ITS.
 Pros: Does not introduce any new APIs.
 Cons:
    - Introduces third meaning for GSI on ARM.
    - Slower than approach 1 because in that case every interrupt is pre-translated while
here we engage ITS every time.

 Personally i have already tried approach 1 and i can say that it works. There is no
problem with target specification because current ITS code stores everything in a single
bunch so that i anyway have to locate a particular ITTE corresponding to an LPI and get
collection ID from there. However, yes, i agree, this approach has the same performance
drawback as my suggested approach 2.

 Any thoughts / ideas ?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
