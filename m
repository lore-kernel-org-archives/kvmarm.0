Return-Path: <SRS0=hhnY=BX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2753C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 20:53:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0EF5B20715
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 20:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BY/RaFL1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EF5B20715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372684B9E9;
	Thu, 13 Aug 2020 16:53:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LWbpFXfRc8wN; Thu, 13 Aug 2020 16:53:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DE064BA18;
	Thu, 13 Aug 2020 16:53:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D60B4B9E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 16:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aV9msijYIYvr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2020 16:53:09 -0400 (EDT)
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9B814B64E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 16:53:09 -0400 (EDT)
Received: by mail-pl1-f196.google.com with SMTP id r4so3174766pls.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 13:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:subject:to:cc:references:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=KMEdmNBQWTzUTOzp1bnF8SX2rCsME0fqtsH4k5tjFgk=;
 b=BY/RaFL1BVNPFlGHJzyLzey4vsiBfNtRMsw3MUihtFPevNI6wBAodIqL8l9LyiC8Oq
 Eo21w0GU1xVIaAU2FMgX28MU4LpFfWXG7LZOiSCe0R/mxr8L/6WKNnWW/OPaTZa0B53o
 auaWm/ULLH4BluQuWM3Ptb6CmqOTrQ3wf7Xp/8XN/Tn5603OECm26w+DcCTMJtNaXmdp
 5P4+FVUNcAC7KebDKPDI9F01gUfj1ezszF/xQ4G1kPSHW2W3DFX2M7WfibPvOkoiAQnl
 +w3p5mbG0qTjS+NjvbNWIeaVGsRmDPPrP1xx/Yl/fB3LWVgi4GjTn4XyHDbY7oQiXx+I
 3eEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:subject:to:cc:references:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=KMEdmNBQWTzUTOzp1bnF8SX2rCsME0fqtsH4k5tjFgk=;
 b=lpYdB0JtCZtpif365cfreuGj/Vi+94Pu0DsaW03kOq4yP4VOXHqJ4GMoTxFFhfI+yo
 HRJ30Iuqdp3AYJXjkx61NW6kgYGoen1hHkIhlGLPGG/8KoELXZT43EFeBlfN4OvojPVR
 UHCuYRiTg5e1o7irtz4ZYnjaAhiG3o85WDfrLdA89rq/C55iDfFlWtdE+pSEYVfJvpAt
 VsQvOr9nXGewYMv6RbyolsdliyWOm+J5BmmUiGn0tlotERqFCdHShIko/fjHT+j/n5QD
 fa9C1w2PcaYmm8kUd/+pA6aJVuqjbdWegiefmIP8nuNMe+OcwgprRiSk+7sWC0Pl0ysR
 vUJg==
X-Gm-Message-State: AOAM531GgMOTwVTr4KIl0iHqzyZ2BZaMq2zF3hiwKaRhqBX0L6ZaE3vA
 P6MtONeZ2ebbmVwhjb22F9kVEzJ4
X-Google-Smtp-Source: ABdhPJwJ7SDcRA3ZGymFvn6xsKEpJWj4sIm+NKcGlAI2M7tYtar9FKkQpMc6BjAOeT2ZGaSmFR8MVw==
X-Received: by 2002:a17:90a:8918:: with SMTP id
 u24mr6329006pjn.7.1597351988125; 
 Thu, 13 Aug 2020 13:53:08 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id z25sm6975261pfg.150.2020.08.13.13.52.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 13 Aug 2020 13:53:07 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
To: Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>,
 Will Deacon <will@kernel.org>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
 <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
 <20200807131429.GB664450@kroah.com>
 <fb3be972-106e-e171-1c2f-6df20ce186d6@gmail.com>
Message-ID: <647d771d-441b-39f9-809a-19335ef16036@gmail.com>
Date: Thu, 13 Aug 2020 13:52:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <fb3be972-106e-e171-1c2f-6df20ce186d6@gmail.com>
Content-Language: en-US
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Fangrui Song <maskray@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
 Marc Zyngier <maz@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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



On 8/7/2020 11:17 AM, Florian Fainelli wrote:
> 
> 
> On 8/7/2020 6:14 AM, Greg KH wrote:
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
>>>>>>   added change to hyp/entry.S]
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
> OK, Will, can you review those? Thanks

Will, can you please review those patches?
-- 
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
