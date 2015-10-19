From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [RFT - PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Mon, 19 Oct 2015 15:06:59 -0700
Message-ID: <56256983.2030506@samsung.com>
References: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
 <20151005154540.GJ9011@cbox> <561BDFE3.5060403@samsung.com>
 <20151018210738.GF7531@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA053412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 18:04:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wCX0vtMZXlp3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2015 18:04:30 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92A6140FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 18:04:30 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWH00F8AMROLG90@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 19 Oct 2015 18:07:00 -0400 (EDT)
In-reply-to: <20151018210738.GF7531@cbox>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/18/2015 2:07 PM, Christoffer Dall wrote:
> On Mon, Oct 12, 2015 at 09:29:23AM -0700, Mario Smarduch wrote:
>> Hi Christoffer, Marc -
>>   I just threw this test your way without any explanation.
> 
> I'm confused.  Did you send me something somewhere already?
Yes in the last patchset

https://lists.cs.columbia.edu/pipermail/kvmarm/2015-October/016698.html

I included a simple test I put together.

> 
>>
>> The test loops, does fp arithmetic and checks the truncated result.
>> It could be a little more dynamic have an initial run to
>> get the sum to compare against while looping, different fp
>> hardware may come up with a different sum, but truncation is
>> to 5'th decimal point.
>>
>> The rationale is that if there is any fp/simd corruption
>> one of these runs should fail. I think most likely scenario
>> for that is a world switch in midst of fp operation. I've
>> instrumented (basically add some tracing to vcpu_put()) and
>> validated vcpu_put gets called thousands of time (for v7,v8)
>> for an over night test running two guests/host crunching
>> fp operations.
>>
>> Other then that not sure how to really catch any problems
>> with the patches applied. Obviously this is a huge issues, if this has
>> any problems. If you or Marc have any other ideas I'd be happy
>> to enhance the test.
> 
> I think it's important to run two VMs at the same time, each with some
> floating-point work, and then run some floating point on the host at the
> same time.
> 
> You can make that even more interesting by doing 32-bit guests at the
> same time as well.

Yes that's the test combination I've been running.
> 
> I believe Marc was running Panranoia
> (http://www.netlib.org/paranoia/paranoia.c) to test the last lazy
> series.

I'll try this test and run it for several days, see if anything shows up.

Thanks.
> 
> Thanks,
> -Christoffer
> 
