From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 02 Oct 2015 13:22:54 +0300
Message-ID: <00cd01d0fcfc$4de250e0$e9a6f2a0$@samsung.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
 <560E4EC4.5050101@redhat.com>
 <CAFEAcA8WjD9zf8GW_ARdK-wZCA5Ttyd3_a7WikhdjhHsAqvRHA@mail.gmail.com>
 <560E56DC.6020406@redhat.com>
 <CAFEAcA9xuaE6DmpZGD1g9DXTSctiawwrV1iq1xXv+EO7qDR+xA@mail.gmail.com>
 <560E59FA.9070205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <560E59FA.9070205@redhat.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Paolo Bonzini' <pbonzini@redhat.com>, 'Peter Maydell' <peter.maydell@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, 'kvm-devel' <kvm@vger.kernel.org>, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I mean in the device tree.  Does the boot loader realize it's under a
> hypervisor, and provide different device trees to the kernel?

 This has nothing to do with the device tree. Device tree is static. The logic sits inside Linux kernel itself:
 a) If we are running in HYP mode (we are host) - use physical timer
 b) If there's no virtual timer IRQ specified - use physical timer
 c) Otherwise - use virtual vimer.

 On systems without virtualization support virtual timer is simply aliased to physical timer, this is architectural requirement. Therefore this logic just works everywhere.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


