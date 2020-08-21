Return-Path: <SRS0=jF9t=B7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE72C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 17:16:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5517E20738
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 17:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U03pv0x9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5517E20738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD2974C58F;
	Fri, 21 Aug 2020 13:16:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bPjAR4Ci-X4H; Fri, 21 Aug 2020 13:16:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF09E4C575;
	Fri, 21 Aug 2020 13:16:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 758C74C566
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 13:16:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jt3kjPf51xhk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 13:16:33 -0400 (EDT)
Received: from mail-io1-f65.google.com (mail-io1-f65.google.com
 [209.85.166.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4482C4C4B5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 13:16:33 -0400 (EDT)
Received: by mail-io1-f65.google.com with SMTP id h4so2442277ioe.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 10:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=P+EhKJ77YZVv5Qj4Rn7qQHBrz4vGF/LjWaciho8M2N8=;
 b=U03pv0x9mp+UtDvAjD7v56f2AeijmwIpfB1X2x4nsBeFhywufz7YwBUj+7lepqw3tI
 OYlupAL6c8BjT/x5PwqQny8ZG1GDB3deJ7gcDvy34DXx3lllh1phra6JoBQ1Yp/C387n
 vGrmkPxJqpoyJjnqgYQn3EqnpKiVomnoQV0ZpePtcgKnE1+0H51+oXIhXuN8SbWxJwnS
 0h2YT2AdY+E9HqWOIHFGhwhvEGMVjCRkvoNSEBEUAel1mp81zWEQbV1xGfB2LVy9Y1BJ
 GnMIlqvZz189OUHwaWypIoYre1FxfHloBCi/zbUCDdt7vWqwNHyxhYudWFCr2lj/CH5C
 9T+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:autocrypt
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=P+EhKJ77YZVv5Qj4Rn7qQHBrz4vGF/LjWaciho8M2N8=;
 b=OyZewZQGUHXVJO4BVvPJnFVlOHHiLp4mCrjTgb8IJO3FMmaeBYsFDxIF+gFHp8gBIJ
 Xa6XdhEPn8Otv+P0FLDkmvah6A6j1j68c2n7fMKaYL36jlQ1Q78dYZTua2U6Y2drl2yZ
 +IAN5eQS6q93+16iTQigg3a4UnomhwiQuEpOgmaQlZVF9Y9ug2mw4zQxXDhgXAMUcMHi
 oJZumR/m6+xyuH+6bilts9PCQ3+hEZXRb0emVGmfdHLe5acV8rIhij5wuNQRaI7vSHgK
 6pCDe+4Oi8JC/vv6FChObVbFe/gC3LE+tqG7M58o0mihwk6W9fdzC73Q7CIkIUWg3BB9
 N10A==
X-Gm-Message-State: AOAM532fqF0bxDtYMm9d9dVpAUSvJgvptwofNEUFTM6VFlRoIAXW8+6D
 ZVFFgxEalMW32Yh4UVxQFzf5HTSKkAQ=
X-Google-Smtp-Source: ABdhPJyrmrlZPuESvsHLuu/qjNHtZl+FwslZItbtopFllUYyG6wMkQ8Ds1xFC2SG5JLvkOt7ZGoxlA==
X-Received: by 2002:a6b:bc82:: with SMTP id m124mr3160184iof.172.1598030191947; 
 Fri, 21 Aug 2020 10:16:31 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
 by smtp.googlemail.com with ESMTPSA id t88sm1604962ild.8.2020.08.21.10.16.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 21 Aug 2020 10:16:31 -0700 (PDT)
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
To: Will Deacon <will@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
 <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
 <20200807131429.GB664450@kroah.com> <20200821160316.GE21517@willie-the-truck>
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <7480435b-355d-b9f7-3a42-b72a9c4b6f63@gmail.com>
Date: Fri, 21 Aug 2020 10:16:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821160316.GE21517@willie-the-truck>
Content-Language: en-US
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Fangrui Song <maskray@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Marc Zyngier <maz@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On 8/21/20 9:03 AM, Will Deacon wrote:
> On Fri, Aug 07, 2020 at 03:14:29PM +0200, Greg KH wrote:
>> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
>>>
>>>
>>> On 7/20/2020 11:26 AM, Florian Fainelli wrote:
>>>> On 7/20/20 6:04 AM, Greg KH wrote:
>>>>> On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>>>>>> From: Will Deacon <will.deacon@arm.com>
>>>>>>
>>>>>> commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>>>>>>
>>>>>> Some CPUs can speculate past an ERET instruction and potentially perform
>>>>>> speculative accesses to memory before processing the exception return.
>>>>>> Since the register state is often controlled by a lower privilege level
>>>>>> at the point of an ERET, this could potentially be used as part of a
>>>>>> side-channel attack.
>>>>>>
>>>>>> This patch emits an SB sequence after each ERET so that speculation is
>>>>>> held up on exception return.
>>>>>>
>>>>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>>>>> [florian: Adjust hyp-entry.S to account for the label
>>>>>>  added change to hyp/entry.S]
>>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>>> ---
>>>>>> Changes in v2:
>>>>>>
>>>>>> - added missing hunk in hyp/entry.S per Will's feedback
>>>>>
>>>>> What about 4.19.y and 4.14.y trees?  I can't take something for 4.9.y
>>>>> and then have a regression if someone moves to a newer release, right?
>>>>
>>>> Sure, send you candidates for 4.14 and 4.19.
>>>
>>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
>>>
>>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
>>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
>>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
>>
>> Nope, I was waiting for Will's "ack" for these.
> 
> This patch doesn't even build for me (the 'sb' macro is not defined in 4.9),
> and I really wonder why we bother backporting it at all. Nobody's ever shown
> it to be a problem in practice, and it's clear that this is just being
> submitted to tick a box rather than anything else (otherwise it would build,
> right?).

Doh, I completely missed submitting the patch this depended on that's
why I did not notice the build failure locally, sorry about that, what a
shame.

Would not be the same "tick a box" argument be used against your
original submission then? Sure, I have not been able to demonstrate in
real life this was a problem, however the same can be said about a lot
security related fixes.

What if it becomes exploitable in the future, would not it be nice to
have it in a 6 year LTS kernel?

> 
> So I'm not going to Ack any of them. As with a lot of this side-channel
> stuff the cure is far worse than the disease.
Assuming that my v3 does build correctly, which it will, would you be
keen on changing your position?
-- 
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
