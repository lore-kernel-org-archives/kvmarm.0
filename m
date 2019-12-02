Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B11C432C0
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 16:57:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4ACC620640
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 16:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uugigD6c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ACC620640
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4BDB4AEDE;
	Mon,  2 Dec 2019 11:57:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TTXtwZIthCko; Mon,  2 Dec 2019 11:57:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D78DA4AEE3;
	Mon,  2 Dec 2019 11:57:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7AC4AEDE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 11:57:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n5jvebgcumQi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 11:57:01 -0500 (EST)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 000204AEDC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 11:57:00 -0500 (EST)
Received: by mail-pf1-f196.google.com with SMTP id h14so8534830pfe.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 08:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=MeuV4D6ktxPa/YgEl2UBmPn7x6GUvNqnWKVZFqr0yzI=;
 b=uugigD6cpfvgcFC2IlS928ViBqPEvvedoctgOp//5OYApNLYAhtzondWkwVd31BSPr
 JwMXaHfYVkBLbpaolj5OiiPwqpJDLduCyT8ZxmxChxZKqz8L1EnLVsT229E5iJHPxnOS
 CtwvNwK5rzq3y5XEOWg6sV7ejfqitWc1hmy9kmWu43i+4kIlmHd4J0VAXQF0k5tqtDOH
 3Nls31wxkMrMAkTNloMgNvixwtqwx3KJUtQgdZGeYkSq/49JJvlt8d2dRdExc3IG5L+/
 6QPQzO0z7ghkdtBwtRa+Q+ts+1nVjor5tIR3TbXJMScx/NktgTf/hM5ligwGBRLfs1Gs
 FFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=MeuV4D6ktxPa/YgEl2UBmPn7x6GUvNqnWKVZFqr0yzI=;
 b=JlNjM99H2p5c6iYCLh/ftl5lLliQdjpCI74U4EmxhKy3AfByZptGzCbWtCwXkTZjO/
 /NQ6Ppdw5oA4ubXePb5cx/fk3U7j+u2KMqN7AGG+n2yh7xt5HVFwva5AbfA0QAk1XwQY
 m9XGKDBSlTr8haGLpftegy5u1G/zEKFydP3USa4JA9IrNghiu3djKTfWOG3wLY1pEtFc
 sPTROA3L0x+piC/jeoKdFD5oCNs/4Fx+6c0iwaHKDeFzDJhfzVvP3Anix/RVhHwd9H0M
 uWQkP8EwoIun6JZ7cI7Bl4D99B6+u5KnvC6JtgORcoKbpNSxO3A0KfhEp2ELIbCebtkq
 B1mw==
X-Gm-Message-State: APjAAAU+7WP5IMVzhH8A2YTw5t2RERwl1gcw3LYdto80t4zbhDjNTe4e
 WI/qCVoXmKuytxVtnR0l8GKBHA==
X-Google-Smtp-Source: APXvYqyOLbBMa6qw/CKGehc/nTrONPFSgu0BQIXkHZJTEPRR4cFTf7y013lfGabVq6fKLkUqIv1IaQ==
X-Received: by 2002:aa7:86ce:: with SMTP id h14mr17978631pfo.248.1575305819965; 
 Mon, 02 Dec 2019 08:56:59 -0800 (PST)
Received: from [192.168.1.11] (97-113-7-119.tukw.qwest.net. [97.113.7.119])
 by smtp.gmail.com with ESMTPSA id k19sm1335pfg.132.2019.12.02.08.56.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 02 Dec 2019 08:56:59 -0800 (PST)
Subject: Re: [PATCH v2 3/5] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
To: Marc Zyngier <maz@kernel.org>
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-4-maz@kernel.org>
 <0bc7c461-6b92-2782-4aec-2f649f5bc8cf@linaro.org>
 <d2875338d734fca3e5263b94eaf52c18@www.loen.fr>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <9909b304-9e52-6960-4397-b7d33159cebf@linaro.org>
Date: Mon, 2 Dec 2019 08:56:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <d2875338d734fca3e5263b94eaf52c18@www.loen.fr>
Content-Language: en-US
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>, qemu-devel@nongnu.org,
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

On 12/2/19 4:45 PM, Marc Zyngier wrote:
>> Annoying that there's a bug in the manual -- FPSID is listed as group 0 in
>> plenty of places, except in the pseudo-code for Accessing the FPSID
>> which uses TID3.
> 
> Are you sure? I'm looking at DDI0487E_a,
...
> Or have you spotted a discrepancy
> somewhere else (which would be oh-so-surprising...)?

In DDI0487E_a, page G8-6028:

> elsif EL2Enabled() && !ELUsingAArch32(EL2) && HCR_EL2.TID3 == '1' then
>   AArch64.AArch32SystemAccessTrap(EL2, 0x08);
> elsif EL2Enabled() && ELUsingAArch32(EL2) && HCR.TID3 == '1' then
>   AArch32.TakeHypTrapException(0x08);
> else
>   return FPSID;

within the summary documentation for FPSID.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
