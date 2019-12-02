Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F3EC432C0
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:35:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC2F52073C
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tWzyLXlI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC2F52073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 474B04AEF7;
	Mon,  2 Dec 2019 10:35:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b307JsXOUKan; Mon,  2 Dec 2019 10:35:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DEE14AEA1;
	Mon,  2 Dec 2019 10:35:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 608254AC7C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:35:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id riG7eYPlj9Gn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 10:35:29 -0500 (EST)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 175E14A98A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:35:29 -0500 (EST)
Received: by mail-pf1-f194.google.com with SMTP id 2so441844pfg.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 07:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=kqhVzHLOp8uUueSk+iEINBMiBVWjaFwdSC0is+ty9ss=;
 b=tWzyLXlIuz0FlRLDIupY27VZevVsm+ECM0JreLi/dRvyNX9glFv4ugLfLLzs0Yl1vq
 fgjN9QPPQCz1l4iyI7aB7j0CELyCYr4RQUuykC5NF+cA0grdeMt1oymToBjht2ANwfFX
 kE1hyyZcOBb/AUSAdGbIbjw7Kd44JfNb90mhnZhKh8PPOTnVx3rQ7IErtY8VSB2vc87A
 fu63kjkgEtXRebdr9PfYnx+SxcfKrhTPF14LwGKnfBXjJz0bKh3w/Vr9I7InOpwNiaih
 88gGxbc9j+4lAbgQzx9GrJXQQBMyRtp/WkMOJfqDPL8csunw/v8LH/xn1ri8FQxwXjN1
 nyGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=kqhVzHLOp8uUueSk+iEINBMiBVWjaFwdSC0is+ty9ss=;
 b=icnzAyQ3YgYhlWoJiKIWZCSvIMKAMK/Fk7JoXBzTxJBgbPOkWFE7ejc/y+J0yYdYbS
 WQFaMzHX9/gBcN5R46eNoF+PvDqB2bsmqNRHUv0aD83RbynitP3agPKE2hAKv8UHYqrl
 QB671m1jKrGoTM4AovklUa6G8jcstR4AOB7jGBjcpmyukKeo5r7FPnUtugcTSPiY7Me2
 fHtExFIGuiwO7x0XXje3T4/h12AVLUnoqtjdjqPNxf/GAFsATC7w8cvCjsbv09BtZS58
 m3YQsIIaJoCsdOvTovFLO9deh7s0rmcdVl7BnVFzFdX3gfIkbCz1/9cGYvankx/uhzQu
 ZIPQ==
X-Gm-Message-State: APjAAAWb+JnSuVjmLDPrTocPZkHfHpLOy2LJioKZgLJzdFmOt/sK7GHk
 rzrM/yCeXz4xNpDM79Y/YklN7A==
X-Google-Smtp-Source: APXvYqzifVy1jGZVxzLL8obYrVnTLFD9lEud7qbUPBAXed3Kk/4v8rqoySOR/DH1PY3yDyD/wVZYLQ==
X-Received: by 2002:a63:ed48:: with SMTP id m8mr17301378pgk.399.1575300927972; 
 Mon, 02 Dec 2019 07:35:27 -0800 (PST)
Received: from [192.168.1.11] (97-113-7-119.tukw.qwest.net. [97.113.7.119])
 by smtp.gmail.com with ESMTPSA id w3sm24606337pfd.161.2019.12.02.07.35.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 02 Dec 2019 07:35:27 -0800 (PST)
Subject: Re: [PATCH v2 3/5] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-4-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <0bc7c461-6b92-2782-4aec-2f649f5bc8cf@linaro.org>
Date: Mon, 2 Dec 2019 07:35:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191201122018.25808-4-maz@kernel.org>
Content-Language: en-US
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>,
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

On 12/1/19 12:20 PM, Marc Zyngier wrote:
> HCR_EL2.TID3 requires that AArch32 reads of MVFR[012] are trapped to
> EL2, and HCR_EL2.TID0 does the same for reads of FPSID.
> In order to handle this, introduce a new TCG helper function that
> checks for these control bits before executing the VMRC instruction.
> 
> Tested with a hacked-up version of KVM/arm64 that sets the control
> bits for 32bit guests.
> 
> Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper-a64.h        |  2 ++
>  target/arm/translate-vfp.inc.c | 18 +++++++++++++++---
>  target/arm/vfp_helper.c        | 29 +++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Annoying that there's a bug in the manual -- FPSID is listed as group 0 in
plenty of places, except in the pseudo-code for Accessing the FPSID which uses
TID3.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
