From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: arm64 sched_clock cpu accounting
Date: Thu, 03 Dec 2015 10:26:48 -0800
Message-ID: <56608968.8000501@samsung.com>
References: <564CD5A7.8000007@samsung.com> <564D31D3.5040207@samsung.com>
 <20151202180741.GR18376@cbox> <565F81D2.3060401@samsung.com>
 <20151203092947.GB7023@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF12499E0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 13:25:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cyH8hBSvBXRH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 13:25:18 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0405499D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 13:25:18 -0500 (EST)
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYS00LCDOKQIK70@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 03 Dec 2015 13:26:50 -0500 (EST)
In-reply-to: <20151203092947.GB7023@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 12/3/2015 1:29 AM, Will Deacon wrote:
> On Wed, Dec 02, 2015 at 03:42:10PM -0800, Mario Smarduch wrote:
>> On 12/2/2015 10:07 AM, Christoffer Dall wrote:
>>> On Wed, Nov 18, 2015 at 06:20:03PM -0800, Mario Smarduch wrote:
>>>> Also with tick accounting enabled, and periodic timer HZ set to 1000 no irq time
>>>> is reported. That's with running a ping flood - 1200 int/s, not sure why
>>>> wouldn't any irq time be reported? The other two modes report irq time as expected.
>>>>
>>>> On 11/18/2015 11:46 AM, Mario Smarduch wrote:
>>>>> Hello,
>>>>>   I noticed sched clock accounting can be enabled when arch-timer is
>>>>> initialized. But arm64 doesn't appear to have 'HAVE_IRQ_TIME_ACCOUNTING'
>>>>> selected (as of mainline 4.4-rc1) and IRQ_TIME_ACCOUNTING can't be selected.
>>>>> After adding it to arch/arm64/Kconfig, option appears to work fine. Depending on
>>>>> need all accounting options are fine, but irq time accounting appears to be most
>>>>> preferable.
>>>>>
>>>>> Any thoughts? Is it fine to enable it?
>>>>>
>>> Is any of this related to KVM?
>>
>> Indirectly, given the guest should yield same results. To be on the safe side I
>> ran the guest in all combinations (7) to confirm that's the case.
>>
>> Also verified that guest time on host appears fine in all these configurations.
>> It takes extra effort to get the guest time as opposed to other modes.
> 
> I can take this via the arm64 tree (where it's queued, but I've not pushed
> anything yet).
> 
> Will

Great thanks.
> 
