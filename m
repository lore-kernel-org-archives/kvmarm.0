Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CB7C432C0
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:10:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AECD82070B
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IX7OPS9C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AECD82070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1238E4AEF0;
	Mon,  2 Dec 2019 10:10:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oNYYHZK7XlfC; Mon,  2 Dec 2019 10:10:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2800E4AEC0;
	Mon,  2 Dec 2019 10:10:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 503974AC7C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:10:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PgmIpGwwAYTh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 10:10:52 -0500 (EST)
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A4604AC65
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:10:52 -0500 (EST)
Received: by mail-pg1-f195.google.com with SMTP id x8so4736660pgk.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 07:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=4LtuvHrdNM3HYoKVotRcdu6O8PoEJJHbSkOX1onLScg=;
 b=IX7OPS9Clnw4llEJZqi7INbxDS0rEcux4JiGrblm5PhpInJtKTgkT50zkp//bE+oLC
 OeWaGig9S2GAI58JCAUIn2UdDrR/xu+mw44AmaH6k5DTcRLjhjvqZRVJUChRNjjEZkzn
 3IqNMCEt74TDktQx8uhrpMBBQajBSWtrttmIuq0LFFn4a7BsNuDoEPNit1UUI+78qF+F
 0elDP3x/Q9/Socdenx6tXnBltLiX3bd9hsAtm625MW5d10eHmb/crGuN9e5f0l7chEci
 nQ4Mddud01muL/QuvW2OR7aUxIV3SjWhipjSxPX8/no0mGmps77yCUIiX6NrnMiw0CmE
 NXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=4LtuvHrdNM3HYoKVotRcdu6O8PoEJJHbSkOX1onLScg=;
 b=QwT4drDHITE5VY1p433uIGsAN/x45lamvkfemK/BX453uxuNEWRyUypWvfdcL+y92T
 uVypS11lfl4xG6P4aEuAuwlItXrjGsY7lpK4uMhSMP1QemJGo6nFt3l5W5pXJazR3rJv
 OxDVbLJPJcCcBss6LBL15ZLC6m0LLJFHG2Wokagdacxw2l5NAfCuG7IYHk96Gvz7WzcB
 FMK7qee9QPNmP3VtJwwXEXhVmCvGtJ/J+vIrAHcOtc/m6Jn+58wxI2g5SmdG9woRrte3
 ZlCJNcSjqhYz5ouhi7teWKeYYMWzx3MhtAIsyfWgFU0DlBodc7EJoBq0HzEI+Epegl5S
 hL+w==
X-Gm-Message-State: APjAAAUrJZ6zRC6ls45XWS+WqjRU0a8GoXXyvtYR+V1eZruep+jRMflF
 x+yCE95cWQ8ai9pm/sn5i5BAtA==
X-Google-Smtp-Source: APXvYqySd6q9PH4r5aJ4ooh2RxYENLiGwUlVlCK/pdU6t/wznrt1TM7FA0lPL8tHok7wS6Z1EqU4Kw==
X-Received: by 2002:a63:5c59:: with SMTP id n25mr12346348pgm.415.1575299451314; 
 Mon, 02 Dec 2019 07:10:51 -0800 (PST)
Received: from [192.168.1.11] (97-113-7-119.tukw.qwest.net. [97.113.7.119])
 by smtp.gmail.com with ESMTPSA id w131sm13325568pfc.16.2019.12.02.07.10.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 02 Dec 2019 07:10:50 -0800 (PST)
Subject: Re: [PATCH v2 1/5] target/arm: Honor HCR_EL2.TID2 trapping
 requirements
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-2-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <78a7047a-bc8e-0a90-db9c-7f3a0d3d60d8@linaro.org>
Date: Mon, 2 Dec 2019 07:10:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191201122018.25808-2-maz@kernel.org>
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
> HCR_EL2.TID2 mandates that access from EL1 to CTR_EL0, CCSIDR_EL1,
> CCSIDR2_EL1, CLIDR_EL1, CSSELR_EL1 are trapped to EL2, and QEMU
> completely ignores it, making it impossible for hypervisors to
> virtualize the cache hierarchy.
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID2 is set.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
