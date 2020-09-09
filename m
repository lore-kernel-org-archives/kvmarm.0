Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7319C43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 03:04:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 506EA2098B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 03:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WUiHeb9P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 506EA2098B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9431D4B37F;
	Tue,  8 Sep 2020 23:04:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YcX1rl8byMcg; Tue,  8 Sep 2020 23:04:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 896324B3C3;
	Tue,  8 Sep 2020 23:04:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEBE54B385
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 23:04:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G8JGqJHhW-jd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 23:04:15 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFCF74B37F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 23:04:15 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id t14so981324pgl.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Sep 2020 20:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=C+IfSGe94xucF1QhV7eqJ/jdABpcZgXKQwlmBQeviCo=;
 b=WUiHeb9P7f0IMWcOhpKSdim26wdrz0WACI9DJVJS9Rf6ALf9F9cAk6XMc0pK8KO1ic
 YBTSW1kPediH4nT+Mbw19eVe2kh19tIigjpwfsLHNXh5mfTzb4iFHb6ORjRTSwaDkfvH
 CsrgnHiEeOsLSfwy1J1AarsWh8Ag7iv7YBXNNXOWcgdYA9Z7TqmZyrJoQcL5ExAsLgWE
 DmOcLzVpNyKFWvZY3IJUO+mU0qDedOnSkU5c9n9ee4hK/lhciJ9jC4pwvKV1xywuSR+4
 IAlvMIyyy5x6plgIBiAyuHe7iWEHX8qKoPYDLqhxbsaJpVKhOLouZYLYXTOnSqdXsgBO
 rBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=C+IfSGe94xucF1QhV7eqJ/jdABpcZgXKQwlmBQeviCo=;
 b=XOBgwwOxN+2DVhweNvYSVWw2J3c8dKFvCL/XtNJHa3hO60s7Ohr/sEiV9dwHSvEuj8
 om8cJarQfyAKBirW+XD4kmyVI8hfZARWmbvAD49fZyVfw9kiFjltC7cnSJMdILI0Mv67
 KgLkoS1R1fw/5RFCe06+mAzd21V6KQMKeaLWG4Hrg3XDXXnxBo9hCaiAw56hz6ZzpNs3
 gZk6l9SMiUQs46AilGvFLN4YMFBwmD9NEBrQmtdjEOrr5Cf9DBCR8ROoD6LlrcodkUfp
 M7UU00TsRslVSg8Kg3WvYPED1xjA1hb+WYkzMKYij63uA290QW88Bx5+nMIOnFDobNru
 E8TQ==
X-Gm-Message-State: AOAM530eeDgTD/ONDVRka79RxLsdMrIfSGh+uc6lQ3u075KzgW2gZyDu
 QetGND24jfYE1NIyWgkbyltUDXvFsaQ=
X-Google-Smtp-Source: ABdhPJwmc2Z0m7EDOxBIMnUo+vv6gABQGHJl1aUKYXH43c2UF//wN0cGJBCTsBPCw/kIMCqlXnpFMQ==
X-Received: by 2002:a63:f70e:: with SMTP id x14mr1338922pgh.407.1599620654326; 
 Tue, 08 Sep 2020 20:04:14 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id u10sm738927pfn.122.2020.09.08.20.04.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Sep 2020 20:04:13 -0700 (PDT)
Subject: Re: [PATCH stable 4.19 v2 0/2] arm64: entry: Place an SB sequence
 following an ERET instruction
To: linux-arm-kernel@lists.infradead.org
References: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <282ca27e-474c-ea1f-beba-52f361f16b20@gmail.com>
Date: Tue, 8 Sep 2020 20:04:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Fangrui Song <maskray@google.com>, Marc Zyngier <maz@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Greg KH <gregkh@linuxfoundation.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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



On 8/24/2020 11:35 AM, Florian Fainelli wrote:
> Changes in v2:
> 
> - included missing preliminary patch to define the SB barrier instruction
> 
> Will Deacon (2):
>    arm64: Add support for SB barrier and patch in over DSB; ISB sequences
>    arm64: entry: Place an SB sequence following an ERET instruction

Does anybody at ARM or Android care about those changes? If so, would 
you be willing to review these?

Thanks

> 
>   arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
>   arch/arm64/include/asm/barrier.h    |  4 ++++
>   arch/arm64/include/asm/cpucaps.h    |  3 ++-
>   arch/arm64/include/asm/sysreg.h     |  6 ++++++
>   arch/arm64/include/asm/uaccess.h    |  3 +--
>   arch/arm64/include/uapi/asm/hwcap.h |  1 +
>   arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
>   arch/arm64/kernel/cpuinfo.c         |  1 +
>   arch/arm64/kernel/entry.S           |  2 ++
>   arch/arm64/kvm/hyp/entry.S          |  1 +
>   arch/arm64/kvm/hyp/hyp-entry.S      |  4 ++++
>   11 files changed, 47 insertions(+), 3 deletions(-)
> 

-- 
Florian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
