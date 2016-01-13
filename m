From: Mario Smarduch <m.smarduch@samsung.com>
Subject: stage2_unmap_vm - softlockup watchdog
Date: Tue, 12 Jan 2016 17:20:12 -0800
Message-ID: <5695A64C.2010701@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46FB749B2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2016 20:16:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9MJPMZWe+hVj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2016 20:16:10 -0500 (EST)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C63D49B15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2016 20:16:10 -0500 (EST)
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0O0V0035HADQD520@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 12 Jan 2016 20:20:14 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

While running tests on foundation and fast models. stage2_unmap_vm()
triggers the softlockup watchdog (on a reboot). I have not tried to reproduce
on hardware or work with the thresholds (watchdog_thresh()) these could
be more aggressive and usually are in more critical environments.

I think that calling 'touch_softlockup_watchdog()' someplace while walking
second stage tables should prevent this.

On hardware huge VMs may be susceptible to this.

This is only likely to happen when main memory is fragmented and 2nd stage
tables are backed by pages. With huge pages only everything appears to work fine.

- Mario
