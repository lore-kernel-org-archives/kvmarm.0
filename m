From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: arm64 sched_clock cpu accounting
Date: Wed, 18 Nov 2015 18:20:03 -0800
Message-ID: <564D31D3.5040207@samsung.com>
References: <564CD5A7.8000007@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F227240F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2015 21:19:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B03dANqw5ivF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2015 21:19:28 -0500 (EST)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39525497BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2015 21:19:27 -0500 (EST)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NY10023HIHG3L90@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 18 Nov 2015 21:20:05 -0500 (EST)
In-reply-to: <564CD5A7.8000007@samsung.com>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Also with tick accounting enabled, and periodic timer HZ set to 1000 no irq time
is reported. That's with running a ping flood - 1200 int/s, not sure why
wouldn't any irq time be reported? The other two modes report irq time as expected.

On 11/18/2015 11:46 AM, Mario Smarduch wrote:
> Hello,
>   I noticed sched clock accounting can be enabled when arch-timer is
> initialized. But arm64 doesn't appear to have 'HAVE_IRQ_TIME_ACCOUNTING'
> selected (as of mainline 4.4-rc1) and IRQ_TIME_ACCOUNTING can't be selected.
> After adding it to arch/arm64/Kconfig, option appears to work fine. Depending on
> need all accounting options are fine, but irq time accounting appears to be most
> preferable.
> 
> Any thoughts? Is it fine to enable it?
> 
> Thanks,
>   Mario
> 
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
