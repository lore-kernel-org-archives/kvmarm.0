Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4EEC432C3
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:52:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C36D2084F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 15:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pq92iD6j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C36D2084F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64CE54AEEE;
	Mon,  2 Dec 2019 10:52:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mSOMK8b6Wg45; Mon,  2 Dec 2019 10:52:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8714AEC5;
	Mon,  2 Dec 2019 10:52:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA3A4AEC5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:52:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QV2M8L6-j0g8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 10:52:40 -0500 (EST)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17E254AEAB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 10:52:40 -0500 (EST)
Received: by mail-pg1-f194.google.com with SMTP id t3so18092777pgl.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Dec 2019 07:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=gqxsmiAV7JV1SONG7XrgAI1qIjgS9GyeEQFLfkiVFD4=;
 b=Pq92iD6jSYY+Ddpfv6Dp5gg9SJCEnRLUPS/7ajDa44KmJyecfS+x5TfeL0on5o0Lwm
 zwzTjOSIB7OZsF+OA4+WPsaL0FEvikO/O28zSNB5JAyGCiNXhIw2Zq2NhrBUZPRWacfv
 jTOAYx9vZh3m/OTCYSls3KNvpKcUiHjmE2+lalTeRUt5QH8lhbXIJhe041ROhTFU4Sfz
 2oTO4y9yWpde03wDwWg8EYE0bJeFQ+5Paya0+LcGHIsya6BCP3JbXF+qd/mv6D6ktB20
 PhBbj9uW9j7vh/yUAKzEeh+CmP6SJW4Z02muxIYGE0Z9O96JNFQsG0CGEomZwaWFALPm
 y8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=gqxsmiAV7JV1SONG7XrgAI1qIjgS9GyeEQFLfkiVFD4=;
 b=n9IxWHhpSuPyqteyFg1g8jOmojkoEWbfweQ4sQCDVH+cwGz0pvEyDS84o+uBKa47q1
 oDzdV2Y+osCcoL+fWUWa1XPsWVkUqMJab72WKazzIAnJCC3ZWaYBZYkwTt8BAGxFpi+m
 gFK/M0O+Dw9jfosXwFnvugN/do7u3QRgjS4ZkF432JBu8bSWPsa/X5FJLmopcce8/WNb
 9MA07hjibhW3uc8SR7VpDCyo5jU8wzRtGsjEyk15oLn4NjgksYUI5Wy6u0piddt7jz6n
 n4iSsPHJB6mN9QGkuNsLvpwzu8cNul/n4j/WXc7qgGIdNgMUO376XhWhm8g3RsE0yDsf
 /E0A==
X-Gm-Message-State: APjAAAUqQhJpgJ88Tz49a56Tanaq5JEZLG6D0B3QjoCaUHMU+HpX8lXr
 u0v22/fbCcVRTIih7dgpoYR5xg==
X-Google-Smtp-Source: APXvYqxxWz256voFtzIHZgU8EratAp/k2RNw2W/RSW4y9Und1CdhZvQjCmdQlDoVfX8eKNj8bdDasA==
X-Received: by 2002:a63:364d:: with SMTP id d74mr32507600pga.408.1575301959004; 
 Mon, 02 Dec 2019 07:52:39 -0800 (PST)
Received: from [192.168.1.11] (97-113-7-119.tukw.qwest.net. [97.113.7.119])
 by smtp.gmail.com with ESMTPSA id o23sm35484257pgj.90.2019.12.02.07.52.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 02 Dec 2019 07:52:38 -0800 (PST)
Subject: Re: [PATCH v2 4/5] target/arm: Handle AArch32 CP15 trapping via
 HSTR_EL2
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-5-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <be437b20-20d7-ebbe-b3b2-8db45774fbbf@linaro.org>
Date: Mon, 2 Dec 2019 07:52:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191201122018.25808-5-maz@kernel.org>
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
> +    /* Check for an EL2 trap due to HSTR_EL2. We expect EL0 accesses
> +     * to sysregs non accessible at EL0 to have UNDEF-ed already.
> +     */

We're enforcing

    /*
     * Multi-line comment
     */

for qemu now; checkpatch should be reporting on that.

> +    if (!env->aarch64 && arm_current_el(env) < 2 && ri->cp == 15 &&
> +        (arm_hcr_el2_eff(env) & (HCR_E2H | HCR_TGE)) != (HCR_E2H | HCR_TGE)) {

Use is_a64(env) not env->aarch64 directly.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
