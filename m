Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D32C388F2
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 12:20:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FF28222B9
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 12:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVytNpFi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FF28222B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A2574B462;
	Mon,  2 Nov 2020 07:20:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RKcAhRNTnhQg; Mon,  2 Nov 2020 07:20:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57A304B4C5;
	Mon,  2 Nov 2020 07:20:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F39E4B462
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 07:20:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RNVR8kJezEEp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 07:20:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49FE34B454
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 07:20:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604319600;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5daGIcvib8BdFuOtlTnGeZwfGtcp6Wo0sryrP+kbKvE=;
 b=bVytNpFimLQyVhpNibClvD4pd2ficUzXbfnXhx2AcZYBwDuQcmpw9jazQpKhjsZypu/Wco
 hWeYRhAAgs72oweOsConMR0P871bId+QJo5LzOA80IWnUPjekIfMy76RzPHt+xQ90BK9vS
 73JM/UvNZgyWvBQFyQ8VeLvVfTOqXXY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-kZmfLO5wPtunuxNICOtrjg-1; Mon, 02 Nov 2020 07:19:58 -0500
X-MC-Unique: kZmfLO5wPtunuxNICOtrjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A522D1B6A;
 Mon,  2 Nov 2020 12:19:57 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AFC875138;
 Mon,  2 Nov 2020 12:19:55 +0000 (UTC)
Subject: Re: [kvm-unit-tests RFC PATCH v2 0/5] arm64: Statistical Profiling
 Extension Tests
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <88f5068a-7a1c-4870-ebc4-e2c45616e905@redhat.com>
 <c671a212-2a4b-b28f-e0be-36f9427aecb0@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <58176b8d-6dc9-1583-c3ec-102a9637f71b@redhat.com>
Date: Mon, 2 Nov 2020 13:19:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c671a212-2a4b-b28f-e0be-36f9427aecb0@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alexandru,

On 10/30/20 11:31 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 10/30/20 6:17 PM, Auger Eric wrote:
>> Hi Alexandru,
>>
>> [+ Drew]
>>
>> On 10/27/20 6:19 PM, Alexandru Elisei wrote:
>>> This series implements two basic tests for KVM SPE: one that checks that
>>> the reported features match what is specified in the architecture,
>>> implemented in patch #3 ("arm64: spe: Add introspection test"), and another
>>> test that checks that the buffer management interrupt is asserted
>>> correctly, implemented in patch #5 ("am64: spe: Add buffer test"). The rest
>>> of the patches are either preparatory patches, or a fix, in the case of
>>> patch #2 ("lib/{bitops,alloc_page}.h: Add missing headers").
>>>
>>> This series builds on Eric's initial version [1], to which I've added the
>>> buffer tests that I used while developing SPE support for KVM.
>> As you respin my series, with my prior agreement, I expected to find
>> most of the code I wrote, obviously with some potential fixes and
>> adaptations to fit your needs for additional tests.
> 
> I believe there has been a misunderstanding. I asked you if I can pickup *some* of
> your patches, not all of them.
> 
>>
>> However, in this v2, two significant v1 patches have disappeared:
>>
>> 1) [3/4] spe: Add profiling buffer test (170 LOC diffstat)
>> 2) [4/4] spe: Test Profiling Buffer Events (150 LOC diffstat)
>>
>> They were actually the crux of the original series (the introspection
>> test being required as a prerequisite but not testing much really ;-).
>>
>> 1) consists in a "spe-buffer" test starting the profiling on a mastered
>> sequence of instructions (as done for PMU event counters). It introduces
>> the infra to start the profiling, prepare SPE reset config, the macro
>> definitions, start/stop/drain, the code under profiling and basically
>> checks that the buffer was effectively written. We also check we do not
>> get any spurious event as it is not expected.
>>
>> => This test has disappeared and the infra now is diluted in
>> [kvm-unit-tests RFC PATCH v2 5/5] am64: spe: Add buffer test. However no
>> credit is given to my work as my S-o-b has disappeared.
>>
>> 2) consists in a "spe-events" test checking we effectively get the
>> buffer full event when duly expected. This introduces the infra to
>> handle interrupts, check the occurence of events by analyzing the
>> syndrome registers, compare occurences against expected ones. This
>> largely mimics what we have with PMU tests.
>>
>> => This test is part of [kvm-unit-tests RFC PATCH v2 5/5], relying on a
>> different stop condition, and again the infra is diluted in the same
>> patch, with large arbitrary changes, without any credit given to my
>> work. Those changes may explain why you removed my S-o-b but given the
>> anteriority of my series, this does not look normal to me, in a
>> community environment.
>>
>> As discussed privately, this gives me the impression that those two
>> patches were totally ignored while respinning.
> 
> Your impression is correct. The buffer test is my original work. No code has been
> borrowed from your patches, hence why the differences might look like arbitrary
> changes.
> 
> I believe there are some correctness issues with your patches, and I decided to
> send my own test which I used when developing KVM SPE support instead of rebasing
> your tests.
> 
>>
>> Please could you restructure the series at least to keep the buffer-full
>> test + infra separate from the new tests and reset a collaborative S-o-b.
>>
>> Then if you think there are issues wrt the 1st test, "spe-buffer", not
>> included in this series, please let's discuss and fix/improve but not
>> simply trash it as is (in an everyone growing spirit).
>>
>> An alternative is I can take back the ownership of my series and push it
>> upstream in a standard way. Then either you rebase your new tests on top
>> of it or I will be happy to do it for you after discussions on the
>> technical comments.
> 
> It was not my intention to make you feel that your contribution is not appreciated
> or ignored. Let's work on merging your series first and then I'll rebase and
> resend any tests from my series which were not included.

Sure. So let's continue our technical discussion on both your respin and
my original series to identify issues and potential improvements to get
the best of them.

Thanks

Eric
> 
> Thanks,
> Alex
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
