Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F8DC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 00:33:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFE0C21D80
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 00:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V7QvBYZm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFE0C21D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351F14B39D;
	Wed,  9 Sep 2020 20:33:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xTmpe6cLSEk1; Wed,  9 Sep 2020 20:33:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F19744B391;
	Wed,  9 Sep 2020 20:33:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF2C4B385
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 20:33:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rnk0iMOrFs6b for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 20:33:34 -0400 (EDT)
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com
 [209.85.216.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C58F24B341
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 20:33:34 -0400 (EDT)
Received: by mail-pj1-f67.google.com with SMTP id q4so2148221pjh.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 17:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=+CAnJ6K51a/Q1rf8+zN1lXgwBk9dz+8lbDuUR7mG78A=;
 b=V7QvBYZmjvIIciOiQahLDEhlA7JmdBMFkTGy7ZcJvHaxxSi0KpQ9P+trKUr4dD/1LG
 vxHXMt5Dp9uGDeOir+ebQe/qCtzp5FJTE9V3PfAiCfqYqwPOUK9ZWApBTsZpBhH6O3Tk
 g5N411ocAl+fZi1I1Wwk2ruc63dkWhLGwSsH8KDxulR8wsRnHIwcZh9IgnxNsYNZLjIk
 ZUG4xJ9Y4WNRiriQzdRqBWZ9wTfPnBbpRLj9OAu2oA+OYzQ5pfsGHH3qXY1ynwpPu8Hu
 ObQOfa/oXsi1zp7YAA3ijGpqIS/O0Vi5mc1/n52k4cb0l469pAy1VF5tQAef6qHA4c+2
 QRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+CAnJ6K51a/Q1rf8+zN1lXgwBk9dz+8lbDuUR7mG78A=;
 b=P2wKovSVCkTJKD+v6PDEXXa3q+S4DnL69tLqPC0Ny7XmuZRCsFT/GpByaIyj32HleO
 6Rmn+7jRtQA/zPfucv1b4uFbV2TBe/yYoI7Z4iVo+Jm/d6/aWiwxLFe91l/pl/mrKc+T
 5siXjQ2bpihu/TMisJlyRNRj5YCYWAKWbxiaHtZHvIojjeAUzeKuzznonc1PqUIrdXHf
 NU4ZU48qQmhonn8o7tsNKrR0ni9GXRsNY51pqkWTg4liLJ138w4mAkWbn5A2ZBbGHmUQ
 zXk6LIBoXa+xb0/gA4CQFR5jFgkUyhn78r4EqsukiG13r5qWcbx/Eu/F1aDaPnO2HvjN
 XFlw==
X-Gm-Message-State: AOAM532ltB0DQYEYAvF50dHoKsLDD2jsFDarD9iB2359iJfj5RfCEzJA
 +CEcm9GUaO/SZ4DxPWNTXcRv5g==
X-Google-Smtp-Source: ABdhPJzSlIZZ0t/eR2XoepX7ZXStzafMl25vu8/vN0U+R8icUnYxOx9GHDnC+lOspzzpvRs1LkJaHg==
X-Received: by 2002:a17:90a:b78b:: with SMTP id
 m11mr1684889pjr.13.1599698013824; 
 Wed, 09 Sep 2020 17:33:33 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.141.89])
 by smtp.gmail.com with ESMTPSA id x20sm3769882pfr.190.2020.09.09.17.33.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Sep 2020 17:33:32 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
References: <20200904160018.29481-1-steven.price@arm.com>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <8e661984-70bc-790c-8636-39dcd8b00131@linaro.org>
Date: Wed, 9 Sep 2020 17:33:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904160018.29481-1-steven.price@arm.com>
Content-Language: en-US
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Peter Maydell <Peter.Maydell@arm.com>, qemu-devel@nongnu.org,
 Juan Quintela <quintela@redhat.com>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 9/4/20 9:00 AM, Steven Price wrote:
>  3. Doesn't provide any new methods for the VMM to access the tags on
>     memory.
...
> (3) may be problematic and I'd welcome input from those familiar with
> VMMs. User space cannot access tags unless the memory is mapped with the
> PROT_MTE flag. However enabling PROT_MTE will also enable tag checking
> for the user space process (assuming the VMM enables tag checking for
> the process)...

The latest version of the kernel patches for user mte support has separate
controls for how tag check fail is reported.  Including

> +- ``PR_MTE_TCF_NONE``  - *Ignore* tag check faults

That may be less than optimal once userland starts uses tags itself, e.g.
running qemu itself with an mte-aware malloc.

Independent of that, there's also the TCO bit, which can be toggled by any
piece of code that wants to disable checking locally.

However, none of that is required for accessing tags.  User space can always
load/store tags via LDG/STG.  That's going to be slow, though.

It's a shame that LDGM/STGM are privileged instructions.  I don't understand
why that was done, since there's absolutely nothing that those insns can do
that you can't do with (up to) 16x LDG/STG.

I think it might be worth adding some sort of kernel entry point that can bulk
copy tags, e.g. page aligned quantities.  But that's just a speed of migration
thing and could come later.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
