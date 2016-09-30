From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Fri, 30 Sep 2016 17:55:28 +0200
Message-ID: <d3d1d3ef-27af-bb97-62bd-1c467f39a2f1@suse.de>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
 <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de> <20160930154335.GB7996@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0A54113E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Sep 2016 11:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kvDX9-hoJQ3Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Sep 2016 11:45:59 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDE40410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Sep 2016 11:45:59 -0400 (EDT)
In-Reply-To: <20160930154335.GB7996@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 30.09.16 17:43, Christoffer Dall wrote:
> On Fri, Sep 30, 2016 at 05:38:11PM +0200, Alexander Graf wrote:
>>
>>
>> On 30.09.16 16:54, Alexander Graf wrote:
>>>
>>>
>>> On 27.09.16 21:08, Christoffer Dall wrote:
>>>> Hi Alex,
>>>>
>>>> Marc and I have been looking at this during Linaro connect and have
>>>> slightly reworked your patch into this small series.
>>>>
>>>> It would be good if you could have a look at it and test it out.
>>>>
>>>> I've tested it with your QEMU, and it works for UP, but secondary CPUs
>>>> fail to come up, and it looks like the kernel never gets an IPI for
>>>> those CPUs from userspace.  Any chance you're willing to take a look at
>>>> that?
>>>
>>> I still need to see whether I can come up with a prettier solution, but
>>> for now this works:
>>>
>>> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
>>
>> Eh, no, not in i386 code :). But the problem seems to be a missing
>> mpstate sync.
>>
> Yeah, that looked really dodgy.  Have you tested it? :)

I have, but I ran the wrong command line and by accident used -M
...,kernel-irqchip=on :)


Alex
