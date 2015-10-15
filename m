From: Mario Smarduch <m.smarduch@samsung.com>
Subject: its_alloc_tables() - with all BASER marked none
Date: Wed, 14 Oct 2015 18:30:32 -0700
Message-ID: <561F01B8.9060700@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F2D41711
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Oct 2015 21:28:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QpjUM5MV3L3n for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Oct 2015 21:28:17 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0E65410D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Oct 2015 21:28:17 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW800HN2MUY9YA0@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 14 Oct 2015 21:30:34 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

If its_init()/its_probe()/its_alloc_tables() finds all GITS_BASER type none, it
continues with ITS initialization.

Is there a reason to continue?

Started to look through this code recently - little confused here.

Thanks,
  mario
