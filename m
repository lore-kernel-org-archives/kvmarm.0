From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
Date: Wed, 21 Oct 2015 17:50:02 +0300
Message-ID: <01c601d10c0f$c4e17e10$4ea47a30$@samsung.com>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
 <1445357947-6022-4-git-send-email-christoffer.dall@linaro.org>
 <672714208.55851501.1445370665940.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
 <9140096.cYCnE2rDUr@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <9140096.cYCnE2rDUr@wuerfel>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Arnd Bergmann' <arnd@arndb.de>, 'Paolo Bonzini' <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> The only platform I can think of that uses ARMv7ve without actually having
> a GIC is BCM2836 (Raspberry Pi 2). Can we actually run KVM on a platform
> like that?

 We can, with two limitations:
1. GIC has to be emulated in software. I have recently fixed support for this. The only problem here would be that KVM currently
refuses to initialize if there's no vGIC, but it is easy to fix, i posted patches for this too.
2. We cannot emulate CP15 timer, because accessing virtual timer registers cannot be trapped to HYP. However, it is possible to trap
physical timer access, but a small KVM API extension is needed for this.

 Currently it is possible to run qemu vexpress model in this mode, because it has another, memory-mapped timer. It is only necessary
to either remove CP15 timer from guest device tree, or disable support in guest .config.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

