From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [Qemu-devel] Live migration sequence
Date: Fri, 16 Oct 2015 10:24:18 +0300
Message-ID: <00b201d107e3$ac36acd0$04a40670$@samsung.com>
References: <008b01d101be$0228d720$067a8560$@samsung.com>
 <20151009152942.GF2702@work-vm> <00b801d1059e$d6d4ffb0$847eff10$@samsung.com>
 <20151013110527.GB2555@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24DB441451
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 03:22:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sMvgXUY5rtW0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Oct 2015 03:22:02 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61DD6412EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 03:22:01 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWA00BNDXWKEA00@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 16 Oct 2015 08:24:20 +0100 (BST)
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

> Some thoughts:
>   a) There is a migration state notifier list - see add_migration_state_change_notifier (spice
> calls it)
>      - but I don't think it's called in the right places for your needs;  we
>      could add some more places that gets called.

 I am now trying to add one more state, something like MIGRATION_STATUS_FINISHING. It would mean that CPUs are stopped.
 Can you explain me migration code a bit? Where is iteration loop, and where are CPUs stopped? I am looking at migration.c but
cannot say that i understand some good portion of it. :)

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
