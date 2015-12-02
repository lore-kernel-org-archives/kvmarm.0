From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: arm64 sched_clock cpu accounting
Date: Wed, 02 Dec 2015 15:42:10 -0800
Message-ID: <565F81D2.3060401@samsung.com>
References: <564CD5A7.8000007@samsung.com> <564D31D3.5040207@samsung.com>
 <20151202180741.GR18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 579D048537
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 18:40:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wmjn+ZKvtAkD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 18:40:43 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6EAE40C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 18:40:43 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYR00C4D8ICXQ50@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 02 Dec 2015 18:42:12 -0500 (EST)
In-reply-to: <20151202180741.GR18376@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 12/2/2015 10:07 AM, Christoffer Dall wrote:
> Hi Mario,
> 
> On Wed, Nov 18, 2015 at 06:20:03PM -0800, Mario Smarduch wrote:
>> Also with tick accounting enabled, and periodic timer HZ set to 1000 no irq time
>> is reported. That's with running a ping flood - 1200 int/s, not sure why
>> wouldn't any irq time be reported? The other two modes report irq time as expected.
>>
>> On 11/18/2015 11:46 AM, Mario Smarduch wrote:
>>> Hello,
>>>   I noticed sched clock accounting can be enabled when arch-timer is
>>> initialized. But arm64 doesn't appear to have 'HAVE_IRQ_TIME_ACCOUNTING'
>>> selected (as of mainline 4.4-rc1) and IRQ_TIME_ACCOUNTING can't be selected.
>>> After adding it to arch/arm64/Kconfig, option appears to work fine. Depending on
>>> need all accounting options are fine, but irq time accounting appears to be most
>>> preferable.
>>>
>>> Any thoughts? Is it fine to enable it?
>>>
> Is any of this related to KVM?

Indirectly, given the guest should yield same results. To be on the safe side I
ran the guest in all combinations (7) to confirm that's the case.

Also verified that guest time on host appears fine in all these configurations.
It takes extra effort to get the guest time as opposed to other modes.

- Mario
> 
> -Christoffer
> 
