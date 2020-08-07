Return-Path: <SRS0=lYnr=BR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AC5C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Aug 2020 19:04:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E9DB2086A
	for <kvmarm@archiver.kernel.org>; Fri,  7 Aug 2020 19:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEYA/snm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E9DB2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9321E4B52D;
	Fri,  7 Aug 2020 15:04:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wmbm+S3833gV; Fri,  7 Aug 2020 15:04:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D85484B66F;
	Fri,  7 Aug 2020 15:03:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E865F4B8EE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2020 14:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0PXOhtUzjB7w for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2020 14:17:32 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01C4E4B8ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2020 14:17:31 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id p14so2502628wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Aug 2020 11:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=+RLcMf039Fja7+NVYfWd7LsUb0HLd5N8YbD0HQCYGKs=;
 b=hEYA/snmkEnBTWT41qnElh5RISovyGYu/KkzthXY5h6DXG3W0hdwlPVFr/1TAoXzeN
 g3hdpKG0rlvrSWBRhz3pHgXCOMaLU4F64766xythYWHQHlIEwrrFLdcqeFPRyJmojb1E
 heapMjHWiXzttkUCvdfk+AGwfd5/QdZ4kkv5nO1iVEmH96vtecMuYb4rsXnqnFW2BoXK
 pLMpM+R+B5IagfhSenzb51rHcZH1tGJMgwVOQRwG6S2/ilDdHL7Dd/kVhwIF3HsUKr17
 VHBukSpEB9zVSSuJ5A3A0ny9PKP+RldiUG6Jami6ucXsNk21I6t1AdOCQvr0jFMJott7
 F22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+RLcMf039Fja7+NVYfWd7LsUb0HLd5N8YbD0HQCYGKs=;
 b=fyH6TMzmnBAOZ7nWg72nHm09x0h+kd7YVjE1VVA5tK8wQREtfeOSfF3nXeTeyQzMcf
 OBhsnp5Vhl6hllZlv7EHZZyDcuzSft5GBztXc4ZqFbBV5bqGjjIGdXSivKoWXd1ToQ/G
 Zz2W4+NlNHzCP2Nh+Zj3pbdXXTgt+VffV8x+lSBxb510NwGMS5U59dweUR2R56++Wxwe
 9VUq8DGVh80F6dWzFPxADsOcczpNtTdg/znPYuhNj6SgzgJOHf8MH7Gr8tViBWIwQjQG
 UdTEnd3QQPVluMp8Z+AZRtuxJqW7mwvr7OMqyX3tJL7o50VlQGSy0ICy6CUf7mfXyR4N
 iUgg==
X-Gm-Message-State: AOAM532RUk8UoRL7hl/bjevMarVkAlf/l5kTBUNuxyQTYNCIpBRRIHUe
 kKbs1XD6HPxzYQRIMeFNB3vo1Fb2
X-Google-Smtp-Source: ABdhPJw1gAmZHJQX55Ci8aLNAo0vKfunS/WHs1CJQjlHAcjBEZCQV97jdptYDEHSsVMoBeR0Tazsvg==
X-Received: by 2002:a7b:c38a:: with SMTP id s10mr14609217wmj.13.1596824250547; 
 Fri, 07 Aug 2020 11:17:30 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id k184sm11289988wme.1.2020.08.07.11.17.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 07 Aug 2020 11:17:29 -0700 (PDT)
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
To: Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>,
 Will Deacon <will@kernel.org>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
 <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
 <20200807131429.GB664450@kroah.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fb3be972-106e-e171-1c2f-6df20ce186d6@gmail.com>
Date: Fri, 7 Aug 2020 11:17:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807131429.GB664450@kroah.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 8/7/2020 6:14 AM, Greg KH wrote:
> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
>>
>>
>> On 7/20/2020 11:26 AM, Florian Fainelli wrote:
>>> On 7/20/20 6:04 AM, Greg KH wrote:
>>>> On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>>>>> From: Will Deacon <will.deacon@arm.com>
>>>>>
>>>>> commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>>>>>
>>>>> Some CPUs can speculate past an ERET instruction and potentially perform
>>>>> speculative accesses to memory before processing the exception return.
>>>>> Since the register state is often controlled by a lower privilege level
>>>>> at the point of an ERET, this could potentially be used as part of a
>>>>> side-channel attack.
>>>>>
>>>>> This patch emits an SB sequence after each ERET so that speculation is
>>>>> held up on exception return.
>>>>>
>>>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>>>> [florian: Adjust hyp-entry.S to account for the label
>>>>>  added change to hyp/entry.S]
>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>> ---
>>>>> Changes in v2:
>>>>>
>>>>> - added missing hunk in hyp/entry.S per Will's feedback
>>>>
>>>> What about 4.19.y and 4.14.y trees?  I can't take something for 4.9.y
>>>> and then have a regression if someone moves to a newer release, right?
>>>
>>> Sure, send you candidates for 4.14 and 4.19.
>>
>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
>>
>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
> 
> Nope, I was waiting for Will's "ack" for these.

OK, Will, can you review those? Thanks
-- 
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
