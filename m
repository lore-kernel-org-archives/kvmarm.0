From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Fri, 09 Oct 2015 10:30:31 +0300
Message-ID: <00e601d10264$61cdafb0$25690f10$@samsung.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> +  KVM_DEV_ARM_VGIC_CPU_SYSREGS
> +  Attributes:
> +    The attr field of kvm_device_attr encodes two values:
> +    bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
> +    values:   |         mpidr         |      RES     |    instr    |

 One small clarification: do you really want it to be different from KVM_DEV_ARM_VGIC_GRP_CPU_REGS?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


