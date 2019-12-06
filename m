Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A422CC43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:46:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B38821823
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SMTgyLwG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B38821823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8537F4AEDE;
	Fri,  6 Dec 2019 12:46:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fhy20d8eCD-a; Fri,  6 Dec 2019 12:46:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746294AECD;
	Fri,  6 Dec 2019 12:46:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DFCF4AECD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:46:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3SLHPy2VGBP6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 12:45:59 -0500 (EST)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91D9E4AEC4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:45:59 -0500 (EST)
Received: by mail-pf1-f195.google.com with SMTP id y14so3675761pfm.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Dec 2019 09:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=+fTMpWPBwCKpCqV8qO6kMVlUDHWzwdoLpiyq66XcwJY=;
 b=SMTgyLwGgqmK5Lm16vV4iVIS9Sk0krw+MFRSBO+zlMkAZCYLbXBHOe0lsacOUxbmBk
 7DL9LjtmKxIb45jq3ai8hgSRFVbVx+5Q3bjlE8OPAZi6OKi3rTRs7Or6Bhyi2UvF4Ax2
 PHYHioQltXcdwXXBLwPAnoo/xVywvZJXuRXsPRl3uYPCh5ITFgb9HIoy+cgG2E20XXMw
 enyLxaGx4Ls+relyVAArpS4sjQkwRmKKkPFofzkNy0nf5GRWItC+6qAW/oSjHNBvz5Pj
 LK3TRoGRf4mh5C/EMtOlEDR3bwWur2jO0VHX2U6H3DFc+BA4fCb2UzcKCgOCUwzcRqEl
 PZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+fTMpWPBwCKpCqV8qO6kMVlUDHWzwdoLpiyq66XcwJY=;
 b=cS8Taqw4qtrZQMOgiIW6VwTVYX2TAeYbnp5JajFO8F+ZvREWxTjqGeRpZPhWQmTnO8
 yVYSOgeaCEiJlcImuO24JyylOE8IQ5GZaq1diyZ/7PW4prWWO4ftqjrMUL/fKkIIlzv4
 1Fd/EIzwf5n/4N7UsKdRmsvUz/qx/2H7EQ7jSxgMluMlgOrTi7tsa9nXHE8H0vWSNmoH
 48P7o7iXKvHB/Fqz5MkAxs3+RuR/KuSE8tnAX9vZ8hJOs3yMzMMajO2HvObcbumbTe0G
 uL1pxrgbfF+/w8OgmoqOzPS+g5RLI23K2BIWEVMxHMXfJmF2GlQq6vC0r28P50mNtmp6
 gyew==
X-Gm-Message-State: APjAAAVI2x1yhugM69xdEFQOzTfpKzeXgtUgbCekDfC8r59xP2sR6jRj
 xVa3dmT/CcgzG/IScTCcvuKBwg==
X-Google-Smtp-Source: APXvYqxWsL2vak7Zwd+GIlARGws6peo2c7aLHPenXpKWPsIGxl1JgY13+9ySoDyOIQu2NEE8PeIlbg==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr4807336pgl.246.1575654358388; 
 Fri, 06 Dec 2019 09:45:58 -0800 (PST)
Received: from [192.168.1.11] (97-113-7-119.tukw.qwest.net. [97.113.7.119])
 by smtp.gmail.com with ESMTPSA id 136sm15746431pgg.74.2019.12.06.09.45.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Dec 2019 09:45:57 -0800 (PST)
Subject: Re: [PATCH v2 3/5] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
To: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <maz@kernel.org>
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-4-maz@kernel.org>
 <CAFEAcA_YGBXY4X5KYE_xny1bYtP1fKefT+VubmNYbe8TxdwBOw@mail.gmail.com>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <9a13fdd7-9ee8-4b1b-5740-9b6d9488fe9b@linaro.org>
Date: Fri, 6 Dec 2019 09:45:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_YGBXY4X5KYE_xny1bYtP1fKefT+VubmNYbe8TxdwBOw@mail.gmail.com>
Content-Language: en-US
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On 12/6/19 6:08 AM, Peter Maydell wrote:
>>  DEF_HELPER_FLAGS_3(autdb, TCG_CALL_NO_WG, i64, env, i64, i64)
>>  DEF_HELPER_FLAGS_2(xpaci, TCG_CALL_NO_RWG_SE, i64, env, i64)
>>  DEF_HELPER_FLAGS_2(xpacd, TCG_CALL_NO_RWG_SE, i64, env, i64)
>> +
>> +DEF_HELPER_3(check_hcr_el2_trap, void, env, i32, i32)
> 
> This has to be in helper.h, not helper-a64.h, otherwise
> the arm-softmmu target won't build. helper-a64.h is for
> helper functions which only exist in the aarch64 binary.

Oh, while we're at it,

  DEF_HELPER_FLAGS_3(..., TCG_CALL_NO_WG, ...)

The helper does not modify tcg globals (on successful return).
It does read globals (via the exception path), and of course it has side
effects (the exception).


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
