From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Fri, 19 Jun 2015 09:37:30 +0300
Message-ID: <011e01d0aa5a$6b14fae0$413ef0a0$@samsung.com>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> The series therefore allows and mandates the usage of KVM_SET_GSI_ROUTING
> ioctl along with KVM_IRQFD. If the userspace does not define any routing
> table, no irqfd injection can happen. The user-space can use
> KVM_CAP_IRQ_ROUTING to detect whether a routing table is needed.

 Yesterday, half-sleeping in the train back home, i've got a simple idea how to resolve
conflicts with existing static GSI->SPI routing without bringing in any more
inconsistencies.
 So far, in current implementation GSI is an SPI index (let alone KVM_IRQ_LINE, because
it's already another story on ARM). In order to maintain this convention we could simply
implement default routing which sets all GSIs to corresponding SPI pins. So, if the
userland never cares about KVM_SET_GSI_ROUTING, everything works as before. But it will be
possible to re-route GSIs to MSI. It will perfectly work because SPI signaling is used
with GICv2m, and MSI with GICv3(+), which cannot be used at the same time.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


