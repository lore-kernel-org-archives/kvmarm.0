From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH] arm64: KVM: Optimize arm64 guest exit VFP/SIMD register
 save/restore
Date: Mon, 15 Jun 2015 12:08:41 -0700
Message-ID: <557F22B9.9020902@samsung.com>
References: <557CACC4.8040405@samsung.com> <557EA23D.4090200@arm.com>
 <557F13A5.9030603@samsung.com> <557F1765.8040405@arm.com>
 <557F1CFB.8040106@samsung.com> <557F1EC0.6060004@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E41555150
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 14:58:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WmR5M29EOBee for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2015 14:58:15 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AA5555142
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 14:58:15 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ000L472IOXS50@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 15 Jun 2015 15:08:48 -0400 (EDT)
In-reply-to: <557F1EC0.6060004@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/15/2015 11:51 AM, Marc Zyngier wrote:
> On 15/06/15 19:44, Mario Smarduch wrote:
>> On 06/15/2015 11:20 AM, Marc Zyngier wrote:
>>> On 15/06/15 19:04, Mario Smarduch wrote:
>>>> On 06/15/2015 03:00 AM, Marc Zyngier wrote:
>>>>> Hi Mario,
>>>>>
[...]
>>>
>>> The 32bit code is starting to show its age, and could probably do with a
>>> refactor. If you have some cycles to spare, that'd be quite interesting.
>>
>> Yep, will do, ARMv7 is still very relevant.
> 
> You bet it is. My home router is a v7 VM...
> 
> 	M.
> 
Definitely nice use case, another one RPi2 appears like
everyone is hacking on it :)
