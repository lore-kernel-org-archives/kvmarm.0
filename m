From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [Qemu-devel] Live migration sequence
Date: Tue, 13 Oct 2015 15:02:03 +0300
Message-ID: <00d801d105ae$fa1eb5a0$ee5c20e0$@samsung.com>
References: <008b01d101be$0228d720$067a8560$@samsung.com>
 <20151009152942.GF2702@work-vm> <00b801d1059e$d6d4ffb0$847eff10$@samsung.com>
 <20151013110527.GB2555@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8492541291
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 07:59:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MP23tWD+83N9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Oct 2015 07:59:54 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97E7041145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 07:59:53 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW50018DQRH5C20@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 13 Oct 2015 13:02:05 +0100 (BST)
In-reply-to: <20151013110527.GB2555@work-vm>
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
To: "'Dr. David Alan Gilbert'" <dgilbert@redhat.com>
Cc: quintela@redhat.com, marc.zyngier@arm.com, 'QEMU' <qemu-devel@nongnu.org>, amit.shah@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

>   b) Once you're in the device state saving (a above) you must not change guest RAM,
>      because at that point the migration code won't send any new changes across
>      to the destination. So any sync's you're going to do have to happen before/at
>      the time we stop the CPU and do the final RAM sync.  On the plus side, when
>      you're loading the device state in (a) you can be sure the RAM contents are there.

 This is good. I think, in this case i can teach the kernel (here we talk about accelerated
in-kernel irqchip implementation) to flush ITS caches when a CPU is stopped. This will do the job.

>   c) Watch out for the size of that final sync; if you have lots of these ITS
>      and they all update their 64k page at the point we stop the CPU then you're
>      going to generate a lot of RAM that needs syncing.

 Well, reducing downtime would be the next task. :) First i'd like to get it working at all.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
