Return-Path: <SRS0=sT9x=ZS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3213C432C0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 10:12:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E7572089D
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 10:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YQW7E9Qg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E7572089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D7B4A598;
	Tue, 26 Nov 2019 05:12:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Ko+aL05WjBr; Tue, 26 Nov 2019 05:12:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECEC4A5A8;
	Tue, 26 Nov 2019 05:12:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A414A576
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 05:12:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BkwCpEBpBLoq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Nov 2019 05:12:12 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2E2B4A54B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 05:12:12 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id i12so21663381wrn.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 02:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=0qtQ/hyBWID+1umsgm3sBAyeOMVbobugTFybBrHw58E=;
 b=YQW7E9QgGYjVJYbWLczKPxU1t+Ljjv61Fe4fK+E0Z//nz+KqtsPtG902CTpvQ19EDU
 4O0K51X11sMw3aG/gg47DfuLfOkkfNNkdlemgMWtHPS+0kIoLa3kOZ85TaejvCQqetsa
 rlN22ypCy/PBba0sDbZXjdNi+XDtvvtMJ8eMqj2U+l+KNu3MdPjaegQYYs3xdimYnRKF
 yBMBo0f5aoOjY/6eAWDh3JXaqvQoJHduFdkR9iPsUONmWa2EpsmV+G8NIs7XzFR6EKFV
 U6PY0+N/2RKN91vB2a8y7fiMg/GyVCNIVysI5MrGLBN5+wejwZ9DKScGe2PJ/GSdK0Wj
 m6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=0qtQ/hyBWID+1umsgm3sBAyeOMVbobugTFybBrHw58E=;
 b=Zdu9WuBDXAoScRsdghFebXv4zqnmsz9yr6u1j0AJ8sKwbAKTOAsU5hKVObCqv/6W6T
 Qn+ih7J/Zuj5FlC2ddoMGCMKuAsthkEgoQm8v7mjxtl34RXFpJPQgvPYXYxB64PWK3iK
 xqJ95izMCGk+wK2x0asLQIOZ8UqVb9v0IPWpKpGg/tUdjjuH90T0faL6KEp8utjkKT0h
 gX9HqlsJqwx1hcP/RiaxApDBZqW9L0THhkR6fIVr+SIG7ZpSHeAKKFGT6g1dj1QqyXwY
 ZS68dcFhle/6Um4ARjGbf9yWv6juS922J2daavf4Hn/wy2f8291yq3gEX+AfdyFxAVo1
 Ue8w==
X-Gm-Message-State: APjAAAX79jxipmTgoFIRa4jSUwQs7v53ljbzjGAESjkBmU4+8kpA3IKp
 Kvp2KZJzV/xVk0Elx0V+Vrb6dPFTtnvZ0Q==
X-Google-Smtp-Source: APXvYqy8jOThm4GVME1+zZe+8H2yF9Eg3omLSA8ZrF9QDsgULgmPCkozO+309KezD7ThOTtDvzqWHg==
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr15433412wrs.200.1574763131174; 
 Tue, 26 Nov 2019 02:12:11 -0800 (PST)
Received: from [192.168.1.14] (88-107-188-217.dynamic.dsl.as9105.com.
 [88.107.188.217])
 by smtp.gmail.com with ESMTPSA id s17sm2451525wmh.41.2019.11.26.02.12.10
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 26 Nov 2019 02:12:10 -0800 (PST)
Subject: Re: [PATCH] target/arm: Honor HCR_EL2.TID3 trapping requirements
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20191123115618.29230-1-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <8f112583-c29c-11e2-c023-f4eb13831894@linaro.org>
Date: Tue, 26 Nov 2019 10:12:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191123115618.29230-1-maz@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 11/23/19 11:56 AM, Marc Zyngier wrote:
> +static CPAccessResult access_aa64idreg(CPUARMState *env, const ARMCPRegInfo *ri,
> +                                       bool isread)
> +{
> +    if ((arm_current_el(env) < 2) && (arm_hcr_el2_eff(env) & HCR_TID3)) {
> +        return CP_ACCESS_TRAP_EL2;
> +    }
> +
> +    return CP_ACCESS_OK;
> +}
> +

The only thing I would suggest is to call this access_aa64_tid3, because
tid{0,1,2} also need to be handled in a similar way, and we'll need little
helper functions for those too.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
