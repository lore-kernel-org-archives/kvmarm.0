From: Mario Smarduch <m.smarduch@samsung.com>
Subject: arm64 sched_clock cpu accounting
Date: Wed, 18 Nov 2015 11:46:47 -0800
Message-ID: <564CD5A7.8000007@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D25CF49954
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2015 14:46:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dA3BDPNeQvM1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2015 14:46:12 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47E4D49723
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2015 14:46:11 -0500 (EST)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NY100DTW0A00600@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 18 Nov 2015 14:46:48 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hello,
  I noticed sched clock accounting can be enabled when arch-timer is
initialized. But arm64 doesn't appear to have 'HAVE_IRQ_TIME_ACCOUNTING'
selected (as of mainline 4.4-rc1) and IRQ_TIME_ACCOUNTING can't be selected.
After adding it to arch/arm64/Kconfig, option appears to work fine. Depending on
need all accounting options are fine, but irq time accounting appears to be most
preferable.

Any thoughts? Is it fine to enable it?

Thanks,
  Mario
