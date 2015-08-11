From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: KVM Live migration with GICv3
Date: Tue, 11 Aug 2015 09:41:42 +0300
Message-ID: <009101d0d400$c92925f0$5b7b71d0$@samsung.com>
References: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACEFB5A854
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 02:28:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PZjIDqxFWagE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 02:28:43 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD82D5A850
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 02:28:43 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NSW00KUDNXJBE90@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 11 Aug 2015 07:41:43 +0100 (BST)
In-reply-to: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
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
To: 'Vijay Kilari' <vijay.kilari@gmail.com>, kvmarm@lists.cs.columbia.edu, 'Christoffer Dall' <christoffer.dall@linaro.org>, =?UTF-8?Q?'Alex_Benn=C3=A9e'?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

>    I have prototyped Live migration with GICv3.

 This is interesting of course, i will need this for my project too and i was also going to take a look at this later.

> For this I have made following changes
> 
> 1) Save and Restore of GICv3 registers in QEMU.
>     - For GICv2, QEMU is saving/restoring GICD, GICC  registers. For GICv3,
>      we have to save/restore GICD, GICR and ICC registers.
>      However ICC registers are system registers which cannot be
> accessed @ EL0 level (SRE=1). So these ICC registers should be
> accessed as mmio registers by QEMU, for this we have to add ioctl to
> access ICC @ EL1 level similar to GICC registers of GICv2.

 Sorry, your description is a bit fuzzy. What ioctl's did you have to add and why?
 The kernel already has KVM_GET_ONE_REG and KVM_SET_ONE_REG ioctl's. And they can be used to access anything inside the VM, including system registers. I believe you would need only to implement handlers for GICv3 registers.

> Please provide your initial feedback.

 Would be nice to take a look at patches.

> I am attending KVM-forum next week @ Seattle. We can discuss there as well.

 I would love to go there, and my company wanted to send me there. But it appears to be extremely difficult for a tech specialist from Russia to get a US visa. They are still considering me and the time is running out, so i'm unlikely to attend, unfortunately.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
