From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 5/5] KVM: arm64: Implement vGICv3 CPU interface access
Date: Thu, 24 Sep 2015 15:08:13 +0300
Message-ID: <16a001d0f6c1$b113cbd0$133b6370$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <20be17e4e8aebcd7f1a52a634f449955bef99996.1441370053.git.p.fedin@samsung.com>
 <55E9B528.50106@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55E9B528.50106@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> The only thing that is pure 64-bit is the MRS/MSR _instruction_ in
> Aarch64, which always takes a x<nn> register.
> So can you model the register size according to the spec and allow
> 32-bit accesses from userland?

 I would like to complete the rework and respin v4, but this is, i guess, the only major issue left.
Additionally, it impacts the API. So...
 In order to allow 32-bit accesses we would have to drop using ARM64_SYS_REG() for building
attribute ID and introduce something own, like KVM_DEV_ARM_VGIC_REG(). It will have different bits
layout (actually it will be missing 'arch' and 'size' field, and instead i will use
KVM_DEV_ARM_VGIC_64BIT flag for length specification, the same as for redistributor.
 Will this be OK ?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


