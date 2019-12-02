Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0CBC432C0
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:23:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CF9820833
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kso3PZ6Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CF9820833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F41AE4AEF0;
	Mon,  2 Dec 2019 10:23:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cW1t+LTRWhsc; Mon,  2 Dec 2019 10:23:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9A14AE9E;
	Mon,  2 Dec 2019 10:23:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9BF4AE9E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:22:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oTDV3ulcKXFl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 10:22:57 -0500 (EST)
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com
 [209.85.214.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 028AF4AC7C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:22:56 -0500 (EST)
Received: by mail-pl1-f194.google.com with SMTP id bd4so55556plb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 07:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=ldcnmnooKILtDx94So09EDIGm9UD4WSVWcIJ2KkcoWY=;
 b=kso3PZ6QOqgPPWy19VBduikUfsO0OwOXqex0XEGSzCDHmerQGHcvxHijOjqS2yOaxI
 pKMnFxy/K3jKZG2yKHGttNpcBKphxTik//M5ttZSk+6R0+5gmqY+zP+6JOOXPod+Qwir
 0ribSVkhVY2ZUQIBsfwYYM3TJBnetkubaQjcsYxcLdG9tcPFb2zLWmz1AQKGlUf0lZYb
 D0UU7YVLJoK4neCl3BSQq54pRj0YQ7zFpuAd7H4Se0s1AA24qJVgE+tCF+i8xAFNWJV5
 7xrbKVn73VNJm47Y6jfQ7gMWxn45GwNSbkPtq1uCSPuC8zswKknDufkwIkynLE2oUc6k
 BX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ldcnmnooKILtDx94So09EDIGm9UD4WSVWcIJ2KkcoWY=;
 b=VDKiiTLENU3SrVw5KpWfoWjdYQ4MdCXvM/DgoeKWzUyejD3n7VFsSHhrIkMappg06l
 gAortYkNps5I9HScE7JBuJMcutm6QNMSXiA2z+r6j/SBHVjeF8yylqg3aUed9T2LrCwK
 iVxLFySXs+s74PsJ1RzaxLv3JOoXFgAToN/5tSf46Uf0zbeyzfY+T0XmKaDRWJg9n5JD
 Wv+kNcORvjkOxFXa2b2BQ5feSrJcDjzFkfHrhIIEX0iPLIe/7fITVg1uPxjLRtlbFXK0
 U1hkahlAJVy2pTbhfDFio/Pa0SXpZyPb4/9RxOateNg+gmjQFOveOaGTyRRK7s7ADk0v
 HDnA==
X-Gm-Message-State: APjAAAU6xw+3/mySuVYNnHwCRoWiIWkK9WaXMfmaSz9tuu1lRD09ruuI
 vi2tpKIsaPrwWhZCrHHwRp/9pQ==
X-Google-Smtp-Source: APXvYqxnH+PBf5it+wzYONc/94C4UzYEocuz275/VrRDVchl/OTFzUEjp+7NsTjQjuH4Co7JEzmgwg==
X-Received: by 2002:a17:902:bb8c:: with SMTP id
 m12mr5261981pls.320.1575300175851; 
 Mon, 02 Dec 2019 07:22:55 -0800 (PST)
Received: from [192.168.1.11] (97-113-7-119.tukw.qwest.net. [97.113.7.119])
 by smtp.gmail.com with ESMTPSA id e4sm6810026pfj.125.2019.12.02.07.22.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 02 Dec 2019 07:22:55 -0800 (PST)
Subject: Re: [PATCH v2 2/5] target/arm: Honor HCR_EL2.TID1 trapping
 requirements
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-3-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <091eee4b-dd8f-477d-438e-699dc3c587af@linaro.org>
Date: Mon, 2 Dec 2019 07:22:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191201122018.25808-3-maz@kernel.org>
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
> HCR_EL2.TID1 mandates that access from EL1 to REVIDR_EL1, AIDR_EL1
> (and their 32bit equivalents) as well as TCMTR, TLBTR are trapped
> to EL2. QEMU ignores it, making it harder for a hypervisor to
> virtualize the HW (though to be fair, no known hypervisor actually
> cares).
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID1 is set.
> 
> Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/helper.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
