From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [RFT - PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Mon, 12 Oct 2015 09:29:23 -0700
Message-ID: <561BDFE3.5060403@samsung.com>
References: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
 <20151005154540.GJ9011@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4500A413E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 12:27:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TN7zPT2ugkoM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 12:27:14 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49248412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 12:27:13 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW4009KD8H03480@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 12 Oct 2015 12:29:24 -0400 (EDT)
In-reply-to: <20151005154540.GJ9011@cbox>
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

Hi Christoffer, Marc -
  I just threw this test your way without any explanation.

The test loops, does fp arithmetic and checks the truncated result.
It could be a little more dynamic have an initial run to
get the sum to compare against while looping, different fp
hardware may come up with a different sum, but truncation is
to 5'th decimal point.

The rationale is that if there is any fp/simd corruption
one of these runs should fail. I think most likely scenario
for that is a world switch in midst of fp operation. I've
instrumented (basically add some tracing to vcpu_put()) and
validated vcpu_put gets called thousands of time (for v7,v8)
for an over night test running two guests/host crunching
fp operations.

Other then that not sure how to really catch any problems
with the patches applied. Obviously this is a huge issues, if this has
any problems. If you or Marc have any other ideas I'd be happy
to enhance the test.

Thanks,
  Mario

On 10/5/2015 8:45 AM, Christoffer Dall wrote:
> On Tue, Sep 22, 2015 at 04:34:01PM -0700, Mario Smarduch wrote:
>> This is a 2nd itteration for arm64, v1 patches were posted by mistake from an 
>> older branch which included several bugs. Hopefully didn't waste too much of 
>> anyones time.
>>
>> This patch series is a followup to the armv7 fp/simd lazy switch
>> implementation, uses similar approach and depends on the series - see
>> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016516.html
>>
>> It's based on earlier arm64 fp/simd optimization work - see
>> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html
>>
>> And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
>> 32-bit guest on 64 bit host (and may require more here) - see
>> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html
>>
>> This series has be tested with arm64 on arm64 with several FP applications 
>> running on host and guest, with substantial decrease on number of 
>> fp/simd context switches. From about 30% down to 2% with one guest running.
>>
>> At this time I don't have arm32/arm64 working and hoping Christoffer and/or
>> Marc (or anyone) can test 32-bit guest/64-bit host.
>>
> Did you already have some test infrastructure/applications that I can
> reuse for this purpose or do I have to write userspace software?
> 
> -Christoffer
> 
