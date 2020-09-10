Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35E7C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 01:45:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F77D206A1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 01:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u/iv2lgV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F77D206A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BBE54B376;
	Wed,  9 Sep 2020 21:45:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XVpH6Xe3xIRM; Wed,  9 Sep 2020 21:45:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B104B35D;
	Wed,  9 Sep 2020 21:45:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6EA4B35D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 21:45:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43KU-SwX+2EC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 21:45:37 -0400 (EDT)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DF634B35C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 21:45:37 -0400 (EDT)
Received: by mail-pf1-f193.google.com with SMTP id o20so3681408pfp.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 18:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=srlzi6kO9KxXkI8QJDt5Z43HoR7v2ko9LYXQ8jt4y44=;
 b=u/iv2lgVycfu88AolfBLdcxoQkKwFXlBKbtJ8zj8UK6eoFLqKxQheAfb05BlbcjwKz
 G8IsBcKBAAda2DaUi0COUFu04Hgo/bR90dfH8TpuflZRaHnC1khAEnRbSFJQPHZdmbOU
 52oCPFtp2JMMYx+7+DIob4TqY2CPbrFgfDAD4HYjqQ0FZNHOF9gB/q+C2Fs3bpOQg0YE
 hue7OYmW6G4eWQeXxXOT1y6I0qdgh2BpgOh4Ybit8LKhLF1Gi1vG2NHllpk0fVbF9hS8
 f0vWsNBOavuocqCQkz3yBm5hrrBsPxXEPuV1wvG1Tk++5ZE9iciU1ZSfbVrnFoMcVRO7
 rjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=srlzi6kO9KxXkI8QJDt5Z43HoR7v2ko9LYXQ8jt4y44=;
 b=LdpXDn1gTsrDJJHC6ktpzANqSN/NupoEM+woVGFuBnskYvxOvGjOddXJlEPzXEle7p
 Gqg5fzYQjzKqnQTH4sC3kMY3dgEqfOdfnLZw1X6wmstfpQd1bF7xrJpmbirXYJ1cMME2
 wQmldB3FpJyUSjAiKWv4au7JRCXyU36am78R+W2ebY5AOZzY/mOlFDI1W4aUoQGyTxNy
 kPIk+ODypoSjiipIdj4yoGfwfl2Ht5SwqX4w0/bYs4qSKi9jowZ81XWwx/GywLbCo1b9
 jvPerSIBQhCynY8/3rcB+84HrmFgFR3guVvoYp9HR0LiF1iujh78x/EFNr9pFEHqLmla
 B/Fw==
X-Gm-Message-State: AOAM531kRkIN0AsHUC9h+o3jNrAsS1akMr2HKOWYt/BL8YKWuETVNX5c
 OHvOb7g5XJAKWrN7XlFsTYt6DA==
X-Google-Smtp-Source: ABdhPJyqpWOeqHuTEIwwj1uDXktA1dBPRjOp1EaAUDe2coNSXU+KFMxtpo7uhsAAcumooCW0G+ElHQ==
X-Received: by 2002:a62:b407:: with SMTP id h7mr3166747pfn.134.1599702336093; 
 Wed, 09 Sep 2020 18:45:36 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.141.89])
 by smtp.gmail.com with ESMTPSA id s20sm3936396pfu.112.2020.09.09.18.45.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Sep 2020 18:45:35 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] MTE support for KVM guest
To: Andrew Jones <drjones@redhat.com>, Steven Price <steven.price@arm.com>
References: <20200904160018.29481-1-steven.price@arm.com>
 <20200909152540.ylnrljd6aelxoxrf@kamzik.brq.redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <5cb1d7ed-54a5-4337-6c3d-2e3e7df89f17@linaro.org>
Date: Wed, 9 Sep 2020 18:45:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909152540.ylnrljd6aelxoxrf@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: Peter Maydell <Peter.Maydell@arm.com>, Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

On 9/9/20 8:25 AM, Andrew Jones wrote:
>>  * Provide a KVM-specific method to extract the tags from guest memory.
>>    This might also have benefits in terms of providing an easy way to
>>    read bulk tag data from guest memory (since the LDGM instruction
>>    isn't available at EL0).
> 
> Maybe we need a new version of KVM_GET_DIRTY_LOG that also provides
> the tags for all addresses of each dirty page.

KVM_GET_DIRTY_LOG just provides one bit per dirty page, no?  Then VMM copies
the data out from its local address to guest memory.

There'd be no difference with or without tags, afaik.  It's just about how VMM
copies the data, with or without tags.

>>  * Provide support for user space setting the TCMA0 or TCMA1 bits in
>>    TCR_EL1. These would allow the VMM to generate pointers which are not
>>    tag checked.
> 
> So this is necessary to allow the VMM to keep tag checking enabled for
> itself, plus map guest memory as PROT_MTE, and write to that memory when
> needed? 

I don't see a requirement for the VMM to set TCMA0.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
