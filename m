Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E51CC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 18:42:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDF93238E3
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 18:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDF93238E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE6E4B22F;
	Mon,  7 Dec 2020 13:42:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QA+xbyFgoTad; Mon,  7 Dec 2020 13:42:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBE54B234;
	Mon,  7 Dec 2020 13:42:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76B984B190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 13:42:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i18NaGCkw1KK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 13:42:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 671B04B12A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 13:42:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD2AD1FB;
 Mon,  7 Dec 2020 10:42:25 -0800 (PST)
Received: from [10.57.61.6] (unknown [10.57.61.6])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 983D03F66B;
 Mon,  7 Dec 2020 10:42:24 -0800 (PST)
Subject: Re: [PATCH] arm64: Work around broken GCC handling of "S" constraint
To: Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20201207154341.1004276-1-maz@kernel.org>
 <CAMj1kXHb9=KPkCAwYWDFH1ddy_p3sDTZ7QemtvWV8nC_14rN+g@mail.gmail.com>
 <CAMj1kXG9mmC8wY9Gvo-oJat0bZTNk495x1Hmmi-_FXbu-gDzDw@mail.gmail.com>
 <87316821c90a13a912a624250055f50f@kernel.org>
 <CAMj1kXG0DRX22SuoXC9VypKfwaUWTUJPAJ6mOZ=ra7+c9UCMXg@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <ce1666ea-eb6f-33d6-cfd8-934bfcf7e336@arm.com>
Date: Mon, 7 Dec 2020 18:42:23 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXG0DRX22SuoXC9VypKfwaUWTUJPAJ6mOZ=ra7+c9UCMXg@mail.gmail.com>
Content-Language: en-GB
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-12-07 17:47, Ard Biesheuvel wrote:
> On Mon, 7 Dec 2020 at 18:41, Marc Zyngier <maz@kernel.org> wrote:
>>
>> On 2020-12-07 17:19, Ard Biesheuvel wrote:
>>> (resend with David's email address fixed)
>>
>> Irk. Thanks for that.
>>
>>>>> +#ifdef CONFIG_CC_HAS_BROKEN_S_CONSTRAINT
>>>>> +#define SYM_CONSTRAINT "i"
>>>>> +#else
>>>>> +#define SYM_CONSTRAINT "S"
>>>>> +#endif
>>>>> +
>>>>
>>>> Could we just check GCC_VERSION here?
>>
>> I guess we could. But I haven't investigated which exact range of
>> compiler is broken (GCC 6.3 seems fixed, but that's the oldest
>> I have apart from the offending 4.9).
>>
> 
> I tried 5.4 on godbolt, and it seems happy. And the failure will be
> obvious, so we can afford to get it slightly wrong and refine it
> later.

FWIW the Linaro 14.11, 15.02 and 15.05 releases of GCC 4.9.3 seem to 
build rc7 without complaint. The only thing older that I have to hand is 
Ubuntu's GCC 4.8.4, which Kbuild chokes on entirely now.

Robin.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
