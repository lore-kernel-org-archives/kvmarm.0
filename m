From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: arm64 sched_clock cpu accounting
Date: Wed, 2 Dec 2015 19:07:41 +0100
Message-ID: <20151202180741.GR18376@cbox>
References: <564CD5A7.8000007@samsung.com>
 <564D31D3.5040207@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E767412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 13:05:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YPDGpGuWlODl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 13:05:40 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C018410D7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 13:05:39 -0500 (EST)
Received: by wmvv187 with SMTP id v187so267705609wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2015 10:07:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <564D31D3.5040207@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mario,

On Wed, Nov 18, 2015 at 06:20:03PM -0800, Mario Smarduch wrote:
> Also with tick accounting enabled, and periodic timer HZ set to 1000 no irq time
> is reported. That's with running a ping flood - 1200 int/s, not sure why
> wouldn't any irq time be reported? The other two modes report irq time as expected.
> 
> On 11/18/2015 11:46 AM, Mario Smarduch wrote:
> > Hello,
> >   I noticed sched clock accounting can be enabled when arch-timer is
> > initialized. But arm64 doesn't appear to have 'HAVE_IRQ_TIME_ACCOUNTING'
> > selected (as of mainline 4.4-rc1) and IRQ_TIME_ACCOUNTING can't be selected.
> > After adding it to arch/arm64/Kconfig, option appears to work fine. Depending on
> > need all accounting options are fine, but irq time accounting appears to be most
> > preferable.
> > 
> > Any thoughts? Is it fine to enable it?
> > 
Is any of this related to KVM?

-Christoffer
