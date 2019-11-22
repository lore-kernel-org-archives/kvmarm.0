Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680DDC432C3
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 16:17:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E27D02071C
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 16:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vzm0Xa7c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E27D02071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6433D4AEC5;
	Fri, 22 Nov 2019 11:17:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vNeRjd2vI4Zb; Fri, 22 Nov 2019 11:17:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65A384ACC4;
	Fri, 22 Nov 2019 11:17:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E76B4ACC4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 11:17:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AUbhQXf6qS-C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 11:17:40 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 687094ACBA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 11:17:40 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id z3so9301509wru.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 08:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=WvkgKLfCm3oyyF/6eWVRcAnvU9WJaNPwvddjPCT4la4=;
 b=vzm0Xa7cydf1lIrU+ou6NsJG/bGBAd8Y3sEQ60d5ixwboPDsgg5kklZhCKgTZRr+ld
 7EVGt/Fkar8DS3iDUAcSAO7N3+Fkjj5eJuWXWE1lcfvB7uKgCwCFim7apMb11PrfZLTC
 qAtcbTVkD38JHcM7Fc8JNOmSqqk12Mk21aGvTfkPFqYZMNTIY9EDfpXtpzbdsXtFpiPq
 3Wy80+m+UP0BdLxYCRIJlC3vG0IkFrV19FZ5Bn5ylkieqllxOFqrvmNPvn+v8tIBpIpF
 q3McRLoywWDkL/7WPwdozAWVRR4uHw5gFC9U+wJCCY/+A6nL+oe3TuuT2VNHXm/7ICZ9
 CLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=WvkgKLfCm3oyyF/6eWVRcAnvU9WJaNPwvddjPCT4la4=;
 b=GNn9natelJiQtXTPKaSAMG+wd6hLcxNcYVP3YPRC0jFdOtGZHicMNYcwUELBt34Wg9
 4g5osMDtTrgsis6IKeOJSnXtn2bf3eafX8Ckkllov972ftCmRDGJRawjodbNM7lJw/R/
 u+R3bk40cCAH5MrZ2qtSgxn9iM5MXE347oKCy5e5vmMeMUmoLI4/QagAxCpa0dbsVoj8
 YuVceN9wfcSIHTQIcYR7vC6t0cIY0s9jEsesEF+cLwafk+AIS8cmc/zdEzR5BRM0R7cN
 Bg4pprsMLnl3yWrYyRfQFgBdkyxYj7ZPNOKPtB0/6zgMsVjshyd3JsG9thXawoWz34RU
 iM+Q==
X-Gm-Message-State: APjAAAUZP7lsgPmDbRLOOPsJ6HKAZFdFk6Odo6r/yFjudSE2Z92LPZPa
 GruH07yyGerp1yl+XjhZ3UM4rQ==
X-Google-Smtp-Source: APXvYqzVHEhABmyalNc3HjsbmGT64hEKZ5wiz27rJOdJmb7xqQ5juGNVQRnlwH+yk1zabw2N5pDqGg==
X-Received: by 2002:a5d:6ac9:: with SMTP id u9mr17999585wrw.383.1574439459334; 
 Fri, 22 Nov 2019 08:17:39 -0800 (PST)
Received: from [10.0.0.120] (host-87-242-235-70.ppp.onetel.net.uk.
 [87.242.235.70])
 by smtp.gmail.com with ESMTPSA id d13sm179633wrv.88.2019.11.22.08.17.38
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 22 Nov 2019 08:17:38 -0800 (PST)
Subject: Re: [PATCH] target/arm: Fix ISR_EL1 tracking when executing at EL2
To: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <maz@kernel.org>
References: <20191122135833.28953-1-maz@kernel.org>
 <CAFEAcA-aRwc9bogn-QbT-q5FzkqieYmQOZMr6H=kK5ixMGANMg@mail.gmail.com>
From: Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <12a72593-6634-37a8-366b-56d48cfed9d1@linaro.org>
Date: Fri, 22 Nov 2019 16:17:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-aRwc9bogn-QbT-q5FzkqieYmQOZMr6H=kK5ixMGANMg@mail.gmail.com>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 kvmarm@lists.cs.columbia.edu
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

On 11/22/19 2:16 PM, Peter Maydell wrote:
> RTH: vaguely wondering if this might be related to the
> bug you ran into trying to test your VHE emulation
> patchset...

Thanks for the thought.  It might be related, but it isn't the final cause:
the inner guest does not yet succeed including this patch.


r~

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
