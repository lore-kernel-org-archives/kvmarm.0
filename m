From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: IRQFD support with GICv3 ITS (WAS: RE: [PATCH 00/13] arm64: KVM:
 GICv3 ITS emulation)
Date: Wed, 10 Jun 2015 18:38:44 +0300
Message-ID: <05db01d0a393$895bf710$9c13e530$@samsung.com>
References: <042601d0a357$d3cec4d0$7b6c4e70$@samsung.com>
 <557842A0.9070503@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6965327C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 11:28:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jC6RhxN0E9rt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 11:28:28 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9583553266
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 11:28:27 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NPQ001ODJGLGRC0@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 10 Jun 2015 16:38:45 +0100 (BST)
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

 Hello!

> KVM GSI routing, even if only used for MSI routing then mandates to
> build entries for non MSI IRQs, using irqchip routing entries. Then you
> draw the irqchip.c kvm_irq_routing_table
> chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS] static allocation issue.

 Sorry for this add-on, needed time to look at the code.
 Actually, if we don't use this code at all, and implement our own kvm_set_irq_routing()
and kvm_free_irq_routing(), we don't have to bother about all these limitations.
 The simplest thing to do there would be to store GSI number in struct its_itte. In this
case raising an MSI by GSI would not differ from what i currently do.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
