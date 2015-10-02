From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 02 Oct 2015 13:18:55 +0300
Message-ID: <00cc01d0fcfb$bf8994c0$3e9cbe40$@samsung.com>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
 <560E4EC4.5050101@redhat.com>
 <CAFEAcA8WjD9zf8GW_ARdK-wZCA5Ttyd3_a7WikhdjhHsAqvRHA@mail.gmail.com>
 <560E56DC.6020406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1610A41289
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 06:17:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tBBCidW1DSTI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 06:17:17 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 452BE4126B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 06:17:16 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVL00CBY8NL8HA0@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 02 Oct 2015 11:18:57 +0100 (BST)
In-reply-to: <560E56DC.6020406@redhat.com>
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
To: 'Paolo Bonzini' <pbonzini@redhat.com>, 'Peter Maydell' <peter.maydell@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, 'kvm-devel' <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> How do boards other than 'virt' work when emulated without KVM?

 Under "emulated without KVM" we normally suppose full software emulation (known in qemu as TCG). In this case CPU code is interpreted, and KVM is not used at all.
 Some boards (like vexpress) have own platform-specific timer, so they can work under KVM without CP15 timer. In order to make it working one should either disable CP15 timer in guest .config or remove the node from device tree.
 CP15 timer never worked in this configuration (KVM without irqchip).

> It must be possible to emulate the physical timer in QEMU.

 Of course it is, and with TCG it works. But we currently cannot use it with KVM because KVM assumes that it emulates all CP15 (or system) registers by itself, and never hands any of them outside.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
