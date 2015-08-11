From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: KVM Live migration with GICv3
Date: Tue, 11 Aug 2015 18:24:11 +0300
Message-ID: <019101d0d449$c6721210$53563630$@samsung.com>
References: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
 <009101d0d400$c92925f0$5b7b71d0$@samsung.com>
 <CALicx6s4BOuHsP40r2zuqgiLh+Rx=e=UQvwV5_R7LJB9-dpkig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB1C5A926
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 11:11:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vahfAiBLPWS5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 11:11:11 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B39B5A925
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 11:11:10 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NSX00G3OC4C7P00@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 11 Aug 2015 16:24:12 +0100 (BST)
In-reply-to: <CALicx6s4BOuHsP40r2zuqgiLh+Rx=e=UQvwV5_R7LJB9-dpkig@mail.gmail.com>
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
To: 'Vijay Kilari' <vijay.kilari@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I mean CPU interface registers GICC* defined for vgicv2 under
> "vgic_cpu_ranges[]" in
> virt/kvm/arm/vgic-v2-emul.c needs to be saved and restored for vgicv3 as well.
> So to  access vgic_cpu_ranges[] for vgicv3, we need to register device
> for CPU registers space
> similar to gicv2 in QEMU for gicv3.

 This thing is optional and can be missing. It is for backwards compatibility only, it allows to run GICv2 guests on GICv3. You should not use this API for accessing system registers.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
