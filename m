From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Tue, 23 Jun 2015 11:50:37 +0300
Message-ID: <001701d0ad91$ad985850$08c908f0$@samsung.com>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org>
 <052d01d0ad87$8a2a90e0$9e7fb2a0$@samsung.com> <55890FB2.2090609@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55890FB2.2090609@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: christoffer.dall@linaro.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I was talking about what
> is done without this "gsi direct mapping" feature. In that case the low
> GSI numbers are used by irqchip routing entries. So kvm_irqchip_get_virq
> returns a gsi beyond the irqchip routed gsi's.

 But aren't these low numbers just routed by the qemu too? I don't see qemu getting any predefined
routing from the kernel. kvm_init_irq_routing() allocates used_gsi_bitmap as all zeros, and
kvm_irqchip_get_virq() just starts to give those free numbers, starting from zero. I believe during
machine init we allocate virq's and route them to irqchip explicitly, don't we ?
 Sorry for being perhaps ignorant, i haven't studied x86 qemu code too much.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


