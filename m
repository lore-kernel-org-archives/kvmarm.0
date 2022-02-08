Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EF1C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 18:59:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 362624B0DB;
	Tue,  8 Feb 2022 13:59:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T4RopnE0B5MI; Tue,  8 Feb 2022 13:59:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D944B1BA;
	Tue,  8 Feb 2022 13:59:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32DC64B0A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 13:48:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lz2rSYBW-hHg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 13:48:42 -0500 (EST)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AEB34A119
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 13:48:42 -0500 (EST)
Received: by mail-io1-f48.google.com with SMTP id s18so170399ioa.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 10:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=LtG9xiEE4jQ44T6HhsufQS8ADKi1yJRAek9eLEpW3Ys=;
 b=ht1mBR1BKvtHYuXL0CeSG5fNz805lGf+inQGeHOQ9GZDWl4dbLbFfhtJcQJ3ldQjqA
 vQ3eGmgzG17XoIkACoJ+bheV8tS3KtZTE9QE/eZ6V3XfmxAI2+F3lXpDiortIXa7U6/I
 6hONZbB1KczxazQqEXdQ3gu/ylGsnumG0WFvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=LtG9xiEE4jQ44T6HhsufQS8ADKi1yJRAek9eLEpW3Ys=;
 b=dLRbO5SPgEibNwwZWQVM7nB8waQXpvbPi7OT1JJeEUlPMTbI8iHKRa1ohUHtOBxJ1A
 Zev7/REIwU0u0GynwTt/ORvhAcOxSR6I9ij8uLjAEvWfSV3zpkO55kGOtZ1REEP35LMh
 dYOZ8+oB+1U05X49DXkJFMVoivoKFQ+3tJOqpfQYgXcLAvPwjwiPbguYZ1Dwi5OIZweR
 c91f2m7Yko36zDIe19dPwTAjFFGTeC5i4k3yeYuyd+nITrBWx7L5Fl9oa7kKUbW9Lc7/
 9cGWGvWyTQOQ++toq9ukLuoXuYLBHIzhQuNQWxj4GBpk4hDBVvDRXY125hjqx08Z+cew
 BmMg==
X-Gm-Message-State: AOAM530B+kWfISQy72Mh6wsRDxYy4heByUTfg1Q6Ss2sfMePghuVDQrl
 hEyQYlAS7d+iLdqRek1XoZUV7w==
X-Google-Smtp-Source: ABdhPJybY7CIIniHpQEPbw++VUMg7Tcma6su/YX6uw9r/4qtIDTaKIhRtbG8v/LRWEK2aygphsOhKA==
X-Received: by 2002:a02:2301:: with SMTP id u1mr2833843jau.119.1644346121235; 
 Tue, 08 Feb 2022 10:48:41 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id i30sm693163ila.32.2022.02.08.10.48.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Feb 2022 10:48:40 -0800 (PST)
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
To: Mark Brown <broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
 <YgKQTLwW+ha5XNx8@sirena.org.uk> <YgK4kKrSs6e9seG8@sirena.org.uk>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e6d76104-b7f6-1588-d734-1a09c2990299@linuxfoundation.org>
Date: Tue, 8 Feb 2022 11:48:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YgK4kKrSs6e9seG8@sirena.org.uk>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 08 Feb 2022 13:59:31 -0500
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On 2/8/22 11:38 AM, Mark Brown wrote:
> On Tue, Feb 08, 2022 at 03:46:27PM +0000, Mark Brown wrote:
>> On Mon, Feb 07, 2022 at 05:10:35PM -0700, Shuah Khan wrote:
>>
>>>> +++ b/Documentation/arm64/sme.rst
>>>> @@ -0,0 +1,432 @@
>>>
>>> Missing SPDX here?
> 
>> Only a couple of rst files have SPDX documentation here, I guess the
>> SPDX people aren't worrying about documentation?
> 
> I can't find any free format plain text files with SPDX in them, even
> really prominent stuff like README.  The process documentation is silent
> on what's supposed to be done here too, it says you should use the
> comment style for whatever format you're writing in but that's not a
> thing for free format text.  Dealing with this feels out of scope for
> this series, probably something for whenever someone gets round to doing
> a conversion to .rst or some other format.
> 

There are about 570+ files under Documentation directory that have SPDX
including Documentation/index.rst

Based on a recent doc patch I did, I have seen warns during doc build
about the missing SPDX.

Let's add it now so it doesn't need fixing later.

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
