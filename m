From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Tue, 23 Jun 2015 10:38:00 +0300
Message-ID: <052d01d0ad87$8a2a90e0$9e7fb2a0$@samsung.com>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <5587D398.8040002@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: christoffer.dall@linaro.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> What is done currently at qemu level for other archs -  if I understand
> it correctly -  is there is static GSI routing for standard IRQ.

 Yes, this is correct. GSI number = SPI number for ARM. Also something similar for MIPS (haven't
study that).

> For MSI
> irqfd setup they use spare gsi number not yet used for GSI routing < max
> route number.

 No.
 On ARM with vGICv2m MSI data is effectively IRQ offset, with base being 32. So, original convention
works without any change, they simply retrieve SPI number from MSI data and set up irqfd to that
SPI. No allocation is done.
 Allocation is done only on x86, with routing. They just allocate GSI numbers starting from zero and
route them to something (either irqchip or MSI).

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


--
To unsubscribe from this list: send the line "unsubscribe kvm" in
