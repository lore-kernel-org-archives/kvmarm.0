Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B710DC43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 15:36:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16F8E2087C
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 15:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GKVS6dK7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16F8E2087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F28A4B2FF;
	Thu, 10 Sep 2020 11:36:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 73ouUazIb+R5; Thu, 10 Sep 2020 11:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7BB4B2F8;
	Thu, 10 Sep 2020 11:36:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C4B4B2DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 11:36:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NuLEpFE2buQV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 11:36:48 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 332564B251
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 11:36:48 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id v15so4432051pgh.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 08:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=+NphFAz+bbbGOLPoViKWvapYAGN08JtmjYnLzZIKOxo=;
 b=GKVS6dK77bx/0jZLujlXrhsPEnEfKJjffubPbjyONPpDBt8aKV+/WikhO98lFUcqBg
 fknNlKQUgg0UcuMI4rvH6oQicx7azui4MD9+lZC8HzP87Vi4TbpnL5wsy+KtaRvsh2LC
 56er56VCnPG1cwnDpL+FZu4sdinoEO6m0lag595MpAp4J3HgJxKTp/ftgfAClZ5xpG9e
 IGh4od5fDmnNKVRLqhekiwgA0ji4hW/l6rP7Ub0rdSacgB+QsToPnSt5fJEOro/bh0y5
 tfWDEo6mZ+GCGnCsbnFxd4FHFyfq+MjpuaQe3PdZTqbmYXIk7DHpN7njMs/8y0p1rs/E
 iOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+NphFAz+bbbGOLPoViKWvapYAGN08JtmjYnLzZIKOxo=;
 b=d2diUAuwDGUV244KCE3tBGHhMLaO08TPFYFumWq5OpLSyKUvbzM7o9UwD0oJG7rsQ2
 KzW8x1jBUC8dDGdyBJZzXd/ZkjX5M01Rp7dR5uq9QFEwBqWdvO40Rl28mwh+ws6uEj8u
 cqPBuZHCqOhLw2P1yeVJTAWW7EKMiJ2LXOuEs4yUPphLlHajBhojVpotO5cw5si94T/n
 Rnzb0lyW1+bUx1NJk9QnGbgkSJsilAnNItyndZ2nK7r94/UPHvgKLmAuEkrh6Mckli5F
 9+n2q5vMl+3ZIUnqjk2E1YAnQ7mNNsL1u4pyWi0LI1mJTHf9+vIyj9HU8DoBLzKXyTtP
 cs+g==
X-Gm-Message-State: AOAM531ulGTDnhXeDrbWNm4RAQO6wN/3Qm1APBmWIeD0HKhpJ2sWkniH
 KUNiiiBKBF5VlFubvsUmCcxqEw==
X-Google-Smtp-Source: ABdhPJxIZ4y5XTc4IrXUnrqP73HVFyQx7PSmSplY3yEEr1jJKnjEfVZhyGyxvSD2g5MX5wlOI8kPiA==
X-Received: by 2002:aa7:8bd4:0:b029:13c:1611:6538 with SMTP id
 s20-20020aa78bd40000b029013c16116538mr6137309pfd.10.1599752207202; 
 Thu, 10 Sep 2020 08:36:47 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.141.89])
 by smtp.gmail.com with ESMTPSA id s187sm6690150pfc.134.2020.09.10.08.36.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 10 Sep 2020 08:36:46 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
References: <20200904160018.29481-1-steven.price@arm.com>
 <8e661984-70bc-790c-8636-39dcd8b00131@linaro.org>
 <842807ac-562a-36ce-8061-aa323341b605@arm.com>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c6043c5c-4bf1-e42c-1337-a892e6fd7402@linaro.org>
Date: Thu, 10 Sep 2020 08:36:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <842807ac-562a-36ce-8061-aa323341b605@arm.com>
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

On 9/10/20 3:24 AM, Steven Price wrote:
> It is a shame, however I suspect this is because to use those instructions you
> need to know the block size held in GMID_EL1. And at least in theory that could
> vary between CPUs.

Which is no different from having to read DCZID_EL0 in order to implement
memset, in my opinion.  But, whatever.


> When we have some real hardware it would be worth profiling this. At the moment
> I've no idea whether the kernel entry overhead would make such an interface
> useful from a performance perspective or not.

Yep.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
