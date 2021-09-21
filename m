Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25705C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:38:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9379E60FDA
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9379E60FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 000004A5A0;
	Tue, 21 Sep 2021 13:38:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dN4yV4hJUh8y; Tue, 21 Sep 2021 13:38:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0C44A19A;
	Tue, 21 Sep 2021 13:38:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6F649FB7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bkpnbUFa0BxJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 13:38:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57AD140667
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:38:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632245901;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ps7sRkcD6VYl85kI1uxsep0hwsJ0/fdk/o4evC4yU9U=;
 b=dV54fTW5lIp1Pf8+xCJYuE616EchGA/UdQ9pfM4wMapMOzw1MaNr8h+k7SlhX2QaE7FK4l
 fJtNh9n6ut9rKNHhOsV0uNcyToN6Z0oEy2EV0Ho31TwBWAhsEGzGeIQFifiX1oJ7NaQIOg
 jQp/1Y/IjKet0QpSvRkwkG8+2JM2OVs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-JZzoU5BaO4GOJ3UxjS9FSQ-1; Tue, 21 Sep 2021 13:38:19 -0400
X-MC-Unique: JZzoU5BaO4GOJ3UxjS9FSQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 l29-20020a50d6dd000000b003d80214566cso15414606edj.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 10:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Ps7sRkcD6VYl85kI1uxsep0hwsJ0/fdk/o4evC4yU9U=;
 b=bG5qR8CxauN2QEZdhcuAgyFy8e0TrL00+yDi7+O8mYG7CTd+em26Mj0BjXccIvEZrc
 eK+WC9rqH/A9Yr4Bs/ICqczeXTToCMmtAvMW0dGU4B6sU9LZbhPIxxPM4vO0pN9+8sfW
 W7CLUOyPc/uZrk6zjIr3E+zDh1iUxQvH2aDLO299WvFpHDS4t3Nde6Q9HdGqsC8Eu3qS
 q2SH1nw4lNvpEAsx+3Amkww8O0/qBUAzMhG89iigtMzx8BFEStcLkF1rO+Q+vIxms/4g
 40LQ73eI/xJKg4HzfDVuFrxtgyQVcR0FrNE96lXsRkos+vtNB4rBUx9qsmTS6V+rAkFK
 2bhw==
X-Gm-Message-State: AOAM533qLS++649LMlL1IZCSVrIcDHU5Tc9ufAblgkxrdbF1FV7fQ98p
 nilHjULqoiCFMweyZbYynyq0ykf8f7PYeU8R/nbzVblSZIp6Ujfnd4xFg0xwrqaiztJJF9qW7uZ
 shtKHJx+Cm/u+TrN4wbsqWnyO
X-Received: by 2002:a17:906:dbcb:: with SMTP id
 yc11mr36471898ejb.111.1632245898679; 
 Tue, 21 Sep 2021 10:38:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeGPiiIE6s377p1uYluTAIC8tQvILE4GRsSkZJJoDkyFhMyBtQ6u9q0bUlYbHFk0utlKJ7EQ==
X-Received: by 2002:a17:906:dbcb:: with SMTP id
 yc11mr36471879ejb.111.1632245898484; 
 Tue, 21 Sep 2021 10:38:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id qc12sm816874ejb.117.2021.09.21.10.38.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 10:38:17 -0700 (PDT)
Subject: Re: [PATCH 2/2] selftests: KVM: Fix 'asm-operand-width' warnings in
 steal_time.c
To: Andrew Jones <drjones@redhat.com>, Oliver Upton <oupton@google.com>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-3-oupton@google.com>
 <20210921071904.5irj3q5yiquoubj2@gator.home>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b242d9d8-ec1c-bba5-6272-a7a42e2e4011@redhat.com>
Date: Tue, 21 Sep 2021 19:38:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921071904.5irj3q5yiquoubj2@gator.home>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <seanjc@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 21/09/21 09:19, Andrew Jones wrote:
> On Tue, Sep 21, 2021 at 01:01:20AM +0000, Oliver Upton wrote:
>> Building steal_time.c for arm64 with clang throws the following:
>>
>>>> steal_time.c:130:22: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>>            : "=r" (ret) : "r" (func), "r" (arg) :
>>                                ^
>>>> steal_time.c:130:34: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>>            : "=r" (ret) : "r" (func), "r" (arg) :
>>                                            ^
>>
>> Silence by casting operands to 64 bits.
>>
>> Signed-off-by: Oliver Upton <oupton@google.com>
>> ---
>>   tools/testing/selftests/kvm/steal_time.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
>> index ecec30865a74..eb75b31122c5 100644
>> --- a/tools/testing/selftests/kvm/steal_time.c
>> +++ b/tools/testing/selftests/kvm/steal_time.c
>> @@ -127,7 +127,7 @@ static int64_t smccc(uint32_t func, uint32_t arg)
>>   		"mov	x1, %2\n"
>>   		"hvc	#0\n"
>>   		"mov	%0, x0\n"
>> -	: "=r" (ret) : "r" (func), "r" (arg) :
>> +	: "=r" (ret) : "r" ((uint64_t)func), "r" ((uint64_t)arg) :
> 
> Actually, I think I'd rather fix this smccc implementation to match the
> spec, which I think should be done like this
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..7da957259ce4 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -118,12 +118,12 @@ struct st_time {
>          uint64_t st_time;
>   };
>   
> -static int64_t smccc(uint32_t func, uint32_t arg)
> +static int64_t smccc(uint32_t func, uint64_t arg)
>   {
>          unsigned long ret;
>   
>          asm volatile(
> -               "mov    x0, %1\n"
> +               "mov    w0, %w1\n"
>                  "mov    x1, %2\n"
>                  "hvc    #0\n"
>                  "mov    %0, x0\n"
> 

Agreed, can you send out a patch?  Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
