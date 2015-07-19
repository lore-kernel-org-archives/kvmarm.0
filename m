From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Sun, 19 Jul 2015 17:05:36 +0300
Message-ID: <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <55A93488.9060408@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D4D58E3A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jul 2015 09:53:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rXqKZzu0GRVR for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jul 2015 09:53:38 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88D5158E24
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jul 2015 09:53:37 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRQ00N1JN5D4P70@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sun, 19 Jul 2015 15:05:38 +0100 (BST)
In-reply-to: <55A93488.9060408@arm.com>
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
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Believe it or not, we're not only patch reviewing machines, and if you
> count the number of pending patches, you'll quickly notice that yours
> are basically noise in the grand scheme of things.
> 
> So please cut us some slack.

 What do you mean exactly? Stop discussions and just do everything you suggest before respin? Plz
don't attempt to read this between lines, i can be bad at communication; this is not a complain
and/or hurt indication, i am just asking. :)

> > complete implementation of API which allows to emulate GIC in userspace by
> > qemu, and now i can run any virtual machine, including generic timer, on
> > vGIC-less machine. RasPI-2 is expected to benefit too.
> 
> Do you mean feeding interrupts back to userspace?

 Yes, exactly. I have a working proof-of-concept here.

> How is that going to
> work with the active-timer series that really mandates a full blown GIC?
> Your pet platform might cope with it, but I can't see that happening on
> the RPi.

 I don't know, sorry, things are happening too fast and i can't follow everything.
 Well, actually it is possible to work without virtual timer at all. Yes, this means qemu has to
implement some memory-mapped timer. With HW models like vexpress this is already done and works
fine. I even tried to address this:
https://lists.gnu.org/archive/html/qemu-devel/2015-06/msg06627.html, but Peter suggested to complete
an API instead.
 I have done this as a proof-of-concept and case study for my project, so i want to upstream this in
order not to be lost.
 After all, recent specs say that generic timer can also be memory-mapped. So, making KVM working
without both vGIC and vTimer is not a real problem. This patchset addresses this scenario too, just
needs some extra bits on vtimer side (ability to init KVM without it).

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
