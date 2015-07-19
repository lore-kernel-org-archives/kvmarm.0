From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 1/3] KVM: arm: Fix NULL pointer dereference if KVM is
 used without in-kernel irqchip
Date: Sun, 19 Jul 2015 17:19:09 +0300
Message-ID: <00e901d0c22d$e1b0c680$a5125380$@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <644bce2849b89bc8520c7efcb7752c92e31f9ccd.1436874248.git.p.fedin@samsung.com>
 <55A931B7.4000905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4590858E43
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jul 2015 10:07:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VlVQFpdCAb+R for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jul 2015 10:07:11 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78D4A58E24
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jul 2015 10:07:11 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRQ00M02NRZJV70@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sun, 19 Jul 2015 15:19:11 +0100 (BST)
In-reply-to: <55A931B7.4000905@arm.com>
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

> I'd appreciate a better commit log. Which patch broke it, why is that
> necessary.

 It was broken by 662d9715840aef44dcb573b0f9fab9e8319c868a.
 Actually, runtime detection was never implemented. The patch message just says that it can be done.
And in order to run KVM on my lame board i had to disable VGIC and VTIMER in kernel .config. The
actual breakage happened because without these definitions kvm_vgic_map_resources() was just a
do-nothing inline.

 vGIC can perfectly be emulated by userspace. And even generic timer can, with some tricks. So i
decided to restore this functionality.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
