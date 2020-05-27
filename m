Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CA6C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67FED208B8
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LfimCiEp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67FED208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0AB14B1DD;
	Wed, 27 May 2020 03:18:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oEuQOFW-3nb1; Wed, 27 May 2020 03:18:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7D34B1FF;
	Wed, 27 May 2020 03:18:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B834B1A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 22:39:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fJHUsxbX5+x4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 22:39:28 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9AE84B18E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 22:39:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590547168;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OSB4MQ0sSc72lQAw+UxZAF+ryvkbXacyBfPHDaEQ7+0=;
 b=LfimCiEpU0GqUfDLW41knd0ZF9rM9tQSfZODinOURTsMxOzV3rvGKJTPfIUCu5I++ZQRnl
 R7LkDoKjoWb7l0uVu6JHtraUjfw4s/4Pz5CRLZEzoVQk8tia2Z9cFp0mHFw14KNet+woPJ
 Ak7mk22mxJ74/uiobaWR3rAxV6mp/Tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-y0cRexijNpynYVGTrN8pPQ-1; Tue, 26 May 2020 22:39:21 -0400
X-MC-Unique: y0cRexijNpynYVGTrN8pPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1558E100CCC0;
 Wed, 27 May 2020 02:39:20 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-130.bne.redhat.com
 [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A927F6FB86;
 Wed, 27 May 2020 02:39:12 +0000 (UTC)
Subject: Re: [PATCH RFCv2 0/9] kvm/arm64: Support Async Page Fault
To: Mark Rutland <mark.rutland@arm.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200526130927.GH1363@C02TD0UTHF1T.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <987785b2-2533-c3d8-8f6a-4193aa82d502@redhat.com>
Date: Wed, 27 May 2020 12:39:09 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200526130927.GH1363@C02TD0UTHF1T.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mailman-Approved-At: Wed, 27 May 2020 03:18:39 -0400
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, pbonzini@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Mark,

On 5/26/20 11:09 PM, Mark Rutland wrote:
> At a high-level I'm rather fearful of this series. I can see many ways
> that this can break, and I can also see that even if/when we get things
> into a working state, constant vigilance will be requried for any
> changes to the entry code.
> 
> I'm not keen on injecting non-architectural exceptions in this way, and
> I'm also not keen on how deep the PV hooks are injected currently (e.g.
> in the ret_to_user path).
> 

First of all, thank you for your time and providing your comments continuously.
Since the series is tagged as RFC, it's not a surprise to see something is
obviously broken. However, Could you please provide more details? With more
details, I can figure out the solutions. If I'm correct, you're talking about
the added entry code and the injected PV hooks. Anyway, please provide more
details about your concerns so that I can figure out the solutions.

Let me briefly explain why we need the injected PV hooks in ret_to_user: There
are two fashions of wakeup and I would call them as direct wakeup and delayed
wakeup. The sleeping process is waked up directly when received PAGE_READY
notification from the host, which is the process of direct wakeup. However there
are some cases the direct wakeup can't be carried out. For example, the sleeper
and the waker are same process or the (CFS) runqueue has been locked by somebody
else. In these cases, the wakeup is delayed until the idle process is running or
in ret_to_user. It's how delayed wakeup works.

> I see a few patches have preparator cleanup that I think would be
> worthwhile regardless of this series; if you could factor those out and
> send them on their own it would get that out of the way and make it
> easier to review the series itself. Similarly, there's some duplication
> of code from arch/x86 which I think can be factored out to virt/kvm
> instead as preparatory work.
> 

Yep, I agree there are several cleanup patches can be posted separately
and merged in advance. I will do that and thanks for the comments.

About the shared code between arm64/x86, I need some time to investigate.
Basically, I agree to do so. I also included Paolo here to check his opnion.

It's no doubt these are all preparatory work, to make the review a bit
easier as you said :)

> Generally, I also think that you need to spend some time on commit
> messages and/or documentation to better explain the concepts and
> expected usage. I had to reverse-engineer the series by reviewing it in
> entirety before I had an idea as to how basic parts of it strung
> together, and a more thorough conceptual explanation would make it much
> easier to critique the approach rather than the individual patches.
> 

Yes, sure. I will do this in the future. Sorry about having taken you
too much to do the reverse-engineering. In next revision, I might put
more information in the cover letter and commit log to explain how things
are designed and working :)

> On Fri, May 08, 2020 at 01:29:10PM +1000, Gavin Shan wrote:
>> Testing
>> =======
>> The tests are carried on the following machine. A guest with single vCPU
>> and 4GB memory is started. Also, the QEMU process is put into memory cgroup
>> (v1) whose memory limit is set to 2GB. In the guest, there are two threads,
>> which are memory bound and CPU bound separately. The memory bound thread
>> allocates all available memory, accesses and them free them. The CPU bound
>> thread simply executes block of "nop".
> 
> I appreciate this is a microbenchmark, but that sounds far from
> realistic.
> 
> Is there a specitic real workload that's expected to be representative
> of?
> 
> Can you run tests with a real workload? For example, a kernel build
> inside the VM?
> 

Yeah, I agree it's far from a realistic workload. However, it's the test case
which was suggested when async page fault was proposed from day one, according
to the following document. On the page#34, you can see the benchmark, which is
similar to what we're doing.

https://www.linux-kvm.org/images/a/ac/2010-forum-Async-page-faults.pdf

Ok. I will test with the workload to build kernel or another better one to
represent the case.

>> The test is carried out for 5 time
>> continuously and the average number (per minute) of executed blocks in the
>> CPU bound thread is taken as indicator of improvement.
>>
>>     Vendor: GIGABYTE   CPU: 224 x Cavium ThunderX2(R) CPU CN9975 v2.2 @ 2.0GHz
>>     Memory: 32GB       Disk: Fusion-MPT SAS-3 (PCIe3.0 x8)
>>
>>     Without-APF: 7029030180/minute = avg(7559625120 5962155840 7823208540
>>                                          7629633480 6170527920)
>>     With-APF:    8286827472/minute = avg(8464584540 8177073360 8262723180
>>                                          8095084020 8434672260)
>>     Outcome:     +17.8%
>>
>> Another test case is to measure the time consumed by the application, but
>> with the CPU-bound thread disabled.
>>
>>     Without-APF: 40.3s = avg(40.6 39.3 39.2 41.6 41.2)
>>     With-APF:    40.8s = avg(40.6 41.1 40.9 41.0 40.7)
>>     Outcome:     +1.2%
> 
> So this is pure overhead in that case?
> 

Yes, It's the pure overhead, which is mainly contributed by the injected
PV code in ret_to_user.

> I think we need to see a real workload that this benefits. As it stands
> it seems that this is a lot of complexity to game a synthetic benchmark.
> 
> Thanks,
> Mark.
> 
>> I also have some code in the host to capture the number of async page faults,
>> time used to do swapin and its maximal/minimal values when async page fault
>> is enabled. During the test, the CPU-bound thread is disabled. There is about
>> 30% of the time used to do swapin.
>>
>>     Number of async page fault:     7555 times
>>     Total time used by application: 42.2 seconds
>>     Total time used by swapin:      12.7 seconds   (30%)
>>           Minimal swapin time:      36.2 us
>>           Maximal swapin time:      55.7 ms
>>

[...]

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
