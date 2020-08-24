Return-Path: <SRS0=9KKW=CC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A23C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 16:43:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B1E52067C
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 16:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOiYUyUZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B1E52067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674C34BBCD;
	Mon, 24 Aug 2020 12:43:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mivuj5anxhEk; Mon, 24 Aug 2020 12:43:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA5C4CBF2;
	Mon, 24 Aug 2020 12:43:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4EE4CBEF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 12:43:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rScTBmkGT+Xn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Aug 2020 12:43:01 -0400 (EDT)
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com
 [209.85.216.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2C6D4BBCD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 12:43:00 -0400 (EDT)
Received: by mail-pj1-f65.google.com with SMTP id nv17so4606199pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 09:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=w41OmkoPspYNv6XjOAw8ahtDnY6c9BDmvOxAxpZTttk=;
 b=ZOiYUyUZBx+y2twZVDLNRNj7XcDKPZeSrlH1pKR2XVXQPyltnrUiF5XIL2Pi3UOJE0
 QESR928QCAsMbVv7IvrTsNl9dzQkt7ttEVo22hbkdd8dUrifgdVOREvnTvtePmoSa168
 LUMoDzFfey129AAzeHQzzhMcEFJEBuPwK0iIGyg5eV7eeKQsyzjJYoSHqPx+kktCO0WP
 gucacHnk+svFErQYZFyKb3ISKViLF8l6FlE982tB0lCYr6KbI36mn3lZKElTno2t7VnW
 88Qp4uOlQ1ROHrTxVoECzjBJHSxrk7CtSabgsYgfuVEBBLi35E8V9OKPG1xS/gAt6i3x
 vcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=w41OmkoPspYNv6XjOAw8ahtDnY6c9BDmvOxAxpZTttk=;
 b=XeU8DXh2weMH77Hqbzb1qk/lFJKDCs94K8QEU37RIkzbCmzn9dhnZQAEoqfUXLcR/6
 n5szODA1b7+f9HcQriIDqE0lIiX+ZiYwQFMpl+2kfNJG1/CS78gXsGkfBprtYNborAXO
 hnwjHpe2T2WcRMJTTFEXTqMFnCi8vibroTEczFWJELjS67X40jEXwpAMQxbTSQ7by2Od
 d/FBBkJMYVYvJrsSmUS5YpQ2vLcJaVL/CATUq3iIqtd3zCE+ZyHSPlvXyD7vc3HXmodD
 zLtJiLBPyOA6zwZmKzsqTveGs56Xlvh5opw+/hr1MfkPI7ufhrkYPgRKNAxkct1SqkJY
 yegA==
X-Gm-Message-State: AOAM532QMYZbEDjqLhhciTIDjUVeUgRItaWspGcxEjJtk6gP+Ire0+mh
 0ykApve4b81uCZaMmzcH1rP6zF/Wplc=
X-Google-Smtp-Source: ABdhPJxoYGplA4PD2xcotuP1hn0qFIYRCnXteeEmPRirh/XXpaV6W9tmtVZLocyIxdzG6AVoTaXu5g==
X-Received: by 2002:a17:90a:850b:: with SMTP id
 l11mr142577pjn.15.1598287375409; 
 Mon, 24 Aug 2020 09:42:55 -0700 (PDT)
Received: from [10.67.51.206] ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id 2sm72768pjg.32.2020.08.24.09.42.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 24 Aug 2020 09:42:54 -0700 (PDT)
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
To: Will Deacon <will@kernel.org>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
 <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
 <20200807131429.GB664450@kroah.com> <20200821160316.GE21517@willie-the-truck>
 <7480435b-355d-b9f7-3a42-b72a9c4b6f63@gmail.com>
 <20200824163208.GA25316@willie-the-truck>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f47841b0-bbbf-f03a-dfd1-88e92f4db7c6@gmail.com>
Date: Mon, 24 Aug 2020 09:42:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200824163208.GA25316@willie-the-truck>
Content-Language: en-US
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Fangrui Song <maskray@google.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will.deacon@arm.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Greg KH <gregkh@linuxfoundation.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 8/24/2020 9:32 AM, Will Deacon wrote:
> Hi Florian,
> 
> On Fri, Aug 21, 2020 at 10:16:23AM -0700, Florian Fainelli wrote:
>> On 8/21/20 9:03 AM, Will Deacon wrote:
>>> On Fri, Aug 07, 2020 at 03:14:29PM +0200, Greg KH wrote:
>>>> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
>>>>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
>>>>>
>>>>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
>>>>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
>>>>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
>>>>
>>>> Nope, I was waiting for Will's "ack" for these.
>>>
>>> This patch doesn't even build for me (the 'sb' macro is not defined in 4.9),
>>> and I really wonder why we bother backporting it at all. Nobody's ever shown
>>> it to be a problem in practice, and it's clear that this is just being
>>> submitted to tick a box rather than anything else (otherwise it would build,
>>> right?).
>>
>> Doh, I completely missed submitting the patch this depended on that's
>> why I did not notice the build failure locally, sorry about that, what a
>> shame.
>>
>> Would not be the same "tick a box" argument be used against your
>> original submission then? Sure, I have not been able to demonstrate in
>> real life this was a problem, however the same can be said about a lot
>> security related fixes.
> 
> Sort of, although I wrote the original patch because it was dead easy to do
> and saved having to think too much about the problem, whereas the complexity
> of backporting largerly diminishes that imo.
> 
>> What if it becomes exploitable in the future, would not it be nice to
>> have it in a 6 year LTS kernel?
> 
> Even if people are stuck on an old LTS, they should still be taking the
> regular updates for it, and we would obviously need to backport the fix if
> it turned out to be exploitable (and hey, we could even test it then!).
> 
>>> So I'm not going to Ack any of them. As with a lot of this side-channel
>>> stuff the cure is far worse than the disease.
>> Assuming that my v3 does build correctly, which it will, would you be
>> keen on changing your position?
> 
> Note that I'm not trying to block this patch from going in, I'm just saying
> that I'm not supportive of it. Perhaps somebody from Arm can review it if
> they think it's worth the effort.

How about I submit the actual full series (two patches) and we take the 
discussion from there?

Thanks for responding!
-- 
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
