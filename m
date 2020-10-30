Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF1CC00A89
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 22:30:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ED97221EB
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 22:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ED97221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C674B1F9;
	Fri, 30 Oct 2020 18:30:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zARyRKEn9Frz; Fri, 30 Oct 2020 18:30:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 602794B25E;
	Fri, 30 Oct 2020 18:30:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 766FE4B25C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 18:30:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbaPL+T7nazR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 18:30:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E44F4B25A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 18:30:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB30F1063;
 Fri, 30 Oct 2020 15:30:23 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C8983F719;
 Fri, 30 Oct 2020 15:30:23 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 0/5] arm64: Statistical Profiling
 Extension Tests
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <88f5068a-7a1c-4870-ebc4-e2c45616e905@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c671a212-2a4b-b28f-e0be-36f9427aecb0@arm.com>
Date: Fri, 30 Oct 2020 22:31:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <88f5068a-7a1c-4870-ebc4-e2c45616e905@redhat.com>
Content-Language: en-US
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

Hi Eric,

On 10/30/20 6:17 PM, Auger Eric wrote:
> Hi Alexandru,
>
> [+ Drew]
>
> On 10/27/20 6:19 PM, Alexandru Elisei wrote:
>> This series implements two basic tests for KVM SPE: one that checks that
>> the reported features match what is specified in the architecture,
>> implemented in patch #3 ("arm64: spe: Add introspection test"), and another
>> test that checks that the buffer management interrupt is asserted
>> correctly, implemented in patch #5 ("am64: spe: Add buffer test"). The rest
>> of the patches are either preparatory patches, or a fix, in the case of
>> patch #2 ("lib/{bitops,alloc_page}.h: Add missing headers").
>>
>> This series builds on Eric's initial version [1], to which I've added the
>> buffer tests that I used while developing SPE support for KVM.
> As you respin my series, with my prior agreement, I expected to find
> most of the code I wrote, obviously with some potential fixes and
> adaptations to fit your needs for additional tests.

I believe there has been a misunderstanding. I asked you if I can pickup *some* of
your patches, not all of them.

>
> However, in this v2, two significant v1 patches have disappeared:
>
> 1) [3/4] spe: Add profiling buffer test (170 LOC diffstat)
> 2) [4/4] spe: Test Profiling Buffer Events (150 LOC diffstat)
>
> They were actually the crux of the original series (the introspection
> test being required as a prerequisite but not testing much really ;-).
>
> 1) consists in a "spe-buffer" test starting the profiling on a mastered
> sequence of instructions (as done for PMU event counters). It introduces
> the infra to start the profiling, prepare SPE reset config, the macro
> definitions, start/stop/drain, the code under profiling and basically
> checks that the buffer was effectively written. We also check we do not
> get any spurious event as it is not expected.
>
> => This test has disappeared and the infra now is diluted in
> [kvm-unit-tests RFC PATCH v2 5/5] am64: spe: Add buffer test. However no
> credit is given to my work as my S-o-b has disappeared.
>
> 2) consists in a "spe-events" test checking we effectively get the
> buffer full event when duly expected. This introduces the infra to
> handle interrupts, check the occurence of events by analyzing the
> syndrome registers, compare occurences against expected ones. This
> largely mimics what we have with PMU tests.
>
> => This test is part of [kvm-unit-tests RFC PATCH v2 5/5], relying on a
> different stop condition, and again the infra is diluted in the same
> patch, with large arbitrary changes, without any credit given to my
> work. Those changes may explain why you removed my S-o-b but given the
> anteriority of my series, this does not look normal to me, in a
> community environment.
>
> As discussed privately, this gives me the impression that those two
> patches were totally ignored while respinning.

Your impression is correct. The buffer test is my original work. No code has been
borrowed from your patches, hence why the differences might look like arbitrary
changes.

I believe there are some correctness issues with your patches, and I decided to
send my own test which I used when developing KVM SPE support instead of rebasing
your tests.

>
> Please could you restructure the series at least to keep the buffer-full
> test + infra separate from the new tests and reset a collaborative S-o-b.
>
> Then if you think there are issues wrt the 1st test, "spe-buffer", not
> included in this series, please let's discuss and fix/improve but not
> simply trash it as is (in an everyone growing spirit).
>
> An alternative is I can take back the ownership of my series and push it
> upstream in a standard way. Then either you rebase your new tests on top
> of it or I will be happy to do it for you after discussions on the
> technical comments.

It was not my intention to make you feel that your contribution is not appreciated
or ignored. Let's work on merging your series first and then I'll rebase and
resend any tests from my series which were not included.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
