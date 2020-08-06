Return-Path: <SRS0=oyU/=BQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B70C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  6 Aug 2020 20:01:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC421221E2
	for <kvmarm@archiver.kernel.org>; Thu,  6 Aug 2020 20:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vXzP8kir"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC421221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D28014B213;
	Thu,  6 Aug 2020 16:01:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CfVlUY4w2oPe; Thu,  6 Aug 2020 16:01:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D6D4B1F4;
	Thu,  6 Aug 2020 16:01:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E784B1F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2020 16:01:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JOxbIMawfjuW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Aug 2020 16:01:01 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43F2C4B1D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2020 16:01:01 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id t14so10824655wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Aug 2020 13:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:from:to:cc:references:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=1efmHhkESZyyTkV4YjG9R+9VKAGSzU4A2n9DPJ51c6k=;
 b=vXzP8kirTQLXYXApQ4BkSpIMvXB164bzSWnTW5WsT1Th1fa0cfY/x6FOvSEdm6nXnD
 4uMl/EHRTfBE49HyFD6TbXG+Hbt9V3beqowzhdWO9GfYvHI8qphDINlGViHhAJ6zOBrw
 xcAP9Cz9DxEAPnVO0nF7ecih9rDg17vCXQ344u58AwahDEq5GCRn0dLorkX/GEAmHo6o
 pfQZy+AdC2UYQtWrQuCiFIWZ4oPFfcf8KshjJC5hDASRdCQF+B2vyYIHOJRsbCHgRriM
 29ipPohXt9rHbc0XtelExLCVJco6YzCcfGdfwuUTckpc42y+C0xQSd56DatK9MEviAhE
 4lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:from:to:cc:references:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=1efmHhkESZyyTkV4YjG9R+9VKAGSzU4A2n9DPJ51c6k=;
 b=d4hAKxdaUCfYdiM3DXDw8Zq52tH9Z68tcNDUN+mD7ostQRIrN52fXhxo6dWZ8vqJpk
 im+q47KqRyWIKPls8/IQK2lpv16ms9CZeQWAMeGddRKMud5V21Ar1tlrPJbHNb+rvUac
 qCRpnAb+hBEuX2LmAP0FuhkktdIUWonCUaP8bfboS63FCT7wtBb7PMpVSXHdC3Xkgaj4
 vF6umM8u2h/KgP7632AUbDoDHV4qb+xN2wAWHSj8gSMQGfyh/tF/+pf5jATCAQW532NF
 K8ks4Ldb7PP2qK9aDsAvZQ02srdEI6MqpG7j/c3fZ2YB1U4M1xIGfzu5hAnabK53ngRW
 MieA==
X-Gm-Message-State: AOAM530fuZllZLU/Vz8nEle/d8Wxx4p6HJtUtOZNabjK5ud2KMmj7cDa
 jrCCUK+x6o9sFymKF1EWambqVrmu
X-Google-Smtp-Source: ABdhPJwGV5s3DdZeTmZurz5B8CV3xP8yPdmxkvz6E0i1ONWbghrttEfIOdrVF+lRXrsTMBAlrjsgyw==
X-Received: by 2002:a1c:964b:: with SMTP id y72mr9536627wmd.69.1596744059869; 
 Thu, 06 Aug 2020 13:00:59 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id y203sm8105701wmc.29.2020.08.06.13.00.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 06 Aug 2020 13:00:59 -0700 (PDT)
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
From: Florian Fainelli <f.fainelli@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>,
 Will Deacon <will@kernel.org>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
Message-ID: <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
Date: Thu, 6 Aug 2020 13:00:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
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



On 7/20/2020 11:26 AM, Florian Fainelli wrote:
> On 7/20/20 6:04 AM, Greg KH wrote:
>> On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>>> From: Will Deacon <will.deacon@arm.com>
>>>
>>> commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>>>
>>> Some CPUs can speculate past an ERET instruction and potentially perform
>>> speculative accesses to memory before processing the exception return.
>>> Since the register state is often controlled by a lower privilege level
>>> at the point of an ERET, this could potentially be used as part of a
>>> side-channel attack.
>>>
>>> This patch emits an SB sequence after each ERET so that speculation is
>>> held up on exception return.
>>>
>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>> [florian: Adjust hyp-entry.S to account for the label
>>>  added change to hyp/entry.S]
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>> Changes in v2:
>>>
>>> - added missing hunk in hyp/entry.S per Will's feedback
>>
>> What about 4.19.y and 4.14.y trees?  I can't take something for 4.9.y
>> and then have a regression if someone moves to a newer release, right?
> 
> Sure, send you candidates for 4.14 and 4.19.

Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?

https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/

Thanks
-- 
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
