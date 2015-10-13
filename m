From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [Qemu-devel] Live migration sequence
Date: Tue, 13 Oct 2015 15:41:42 +0300
Message-ID: <00e001d105b4$83c62c70$8b528550$@samsung.com>
References: <008b01d101be$0228d720$067a8560$@samsung.com>
 <20151009152942.GF2702@work-vm> <00b801d1059e$d6d4ffb0$847eff10$@samsung.com>
 <20151013110527.GB2555@work-vm> <00d801d105ae$fa1eb5a0$ee5c20e0$@samsung.com>
 <CAFEAcA8P9okmf012ocoo6bx5y-0yObTFrsrPo1tQ99yGiHYo7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F6C41145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 08:39:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zr0KcCjBrJ4J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Oct 2015 08:39:32 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 771A24113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 08:39:32 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW5005VUSLJ1E80@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 13 Oct 2015 13:41:43 +0100 (BST)
In-reply-to: <CAFEAcA8P9okmf012ocoo6bx5y-0yObTFrsrPo1tQ99yGiHYo7A@mail.gmail.com>
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
To: 'Peter Maydell' <peter.maydell@linaro.org>
Cc: 'Juan Quintela' <quintela@redhat.com>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'QEMU' <qemu-devel@nongnu.org>, "'Dr. David Alan Gilbert'" <dgilbert@redhat.com>, 'Amit Shah' <amit.shah@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Our idea at the discussion at Connect was to have an ioctl to request
> a flush, rather than to do it automatically when a CPU is stopped
> (you probably don't want to flush when only one CPU in an SMP system
> is stopped, for instance).

 Yes, you're right. Looks like this would be more complicated but better way to do the thing. I'll look at migration state notifier mechanism.

> But we wanted to get the basic no-ITS ABI sorted out and agreed first

 Yes, this is good idea, too much changes otherwise. But here at Samsung we have a project, and it has deadlines, so please understand that i try to do things quickly.
 Of course, you see that as soon as i make something, i post it at least as RFCs, because i don't want to have something misdesigned, which will be dropped afterwards. Cooperation with OSS is one of goals of our project.

 Thank you very much for your cooperation and explanations.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
