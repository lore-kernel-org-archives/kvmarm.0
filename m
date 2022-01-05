Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BBEC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 21:37:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23F9049E39;
	Wed,  5 Jan 2022 16:37:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sLijThpYxKGW; Wed,  5 Jan 2022 16:37:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F196440C2B;
	Wed,  5 Jan 2022 16:37:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8275440CE3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 16:36:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7RAr+Uod1joH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 16:36:58 -0500 (EST)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B5F640C2B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 16:36:58 -0500 (EST)
Received: by mail-pg1-f177.google.com with SMTP id g22so338533pgn.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 13:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=7y6hmTrh+XpilH0JWrpkMEsCEa2s5PTiIKnfllY9V+w=;
 b=ef1mPGoiYNO9bFzHSdxkYWIA4OJvvdX+WlAqJ3S/pZ17k1gAJY/xEftfAw/jokvXVl
 f/g8KUxBfwLdQEtA8Fsn0mfS4H8yVSxLs2Hc/n61DxgQniR7DfJURYCVnGcK11vZ9qoF
 q4wioe8nPcgqy90aZQumTxwzZ8NuFFRKwn4LR4WC8j/ab/6/ZAm/GAbov3slaVyENPiz
 Hv2JvWb+VWqweOHiOw4OponRNQMQwuiZIswk0dnHjRKyCkdRG1sqlVTLrcFINBjGs01i
 CstWoBJtIBhXYcQxZAqEqnEoetLD2rV9KZfxjY/+4YAQhZvikB6Hm4lJjDiRpOjOffej
 DOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=7y6hmTrh+XpilH0JWrpkMEsCEa2s5PTiIKnfllY9V+w=;
 b=B+M8E4Tf5qO5piRNjmHUE+6IxDcRwxkuk2CJmbbGzSnhc0nILZ8X6CCRfTMkK7kI6v
 VgrjaNA8eS2hwhsgLLc/vIUx0jnD/0wVN8D5Vn9upc0sl/4vLG7+a3xPzTnrabncAooN
 7ng18WhDPcI1H3izPfTZJHpQT8lGUuNnNdZmS5YsxvmGonc7g0b1lmu3v+89NnDFGNo3
 HNnzugIng8G6hXJ2IBAjqEJ3kJcdapBVQWBeYE/svCHgbXlOovnD5pvC9p7w9j1D++DZ
 tUkQ7n+xEYZD8ZOouLou6ugqCNecFY7MUij38tn2Jok51fvvk388fg45VuUO6d+JwKQb
 rf5g==
X-Gm-Message-State: AOAM5303vAloiG8lNLVzeyCuLb8CCreHVVfzuLHhfUqSgAdyG+ojOci1
 GGVUySjU/qfq4zdITf3GngaiVg==
X-Google-Smtp-Source: ABdhPJyJiWi/3oUbChjBti2/dNa8FFbEZUcSL4GV891fgGqCN7Z1FryDrxNwAE1UbtMDk5fFFtFtKA==
X-Received: by 2002:a05:6a00:2189:b0:4bc:3def:b662 with SMTP id
 h9-20020a056a00218900b004bc3defb662mr32971770pfi.5.1641418617023; 
 Wed, 05 Jan 2022 13:36:57 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
 by smtp.gmail.com with ESMTPSA id t126sm4538pgc.61.2022.01.05.13.36.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 05 Jan 2022 13:36:56 -0800 (PST)
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220103180507.2190429-1-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c5bedb8e-55e3-877f-31aa-92d59e5aba34@linaro.org>
Date: Wed, 5 Jan 2022 13:36:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103180507.2190429-1-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On 1/3/22 10:05 AM, Marc Zyngier wrote:
> -        /*
> -         * KVM does not support modifications to this feature.
> -         * We have not registered the cpu properties when KVM
> -         * is in use, so the user will not be able to set them.
> -         */
> -        if (!kvm_enabled()) {
> -            arm_cpu_pauth_finalize(cpu, &local_err);
> -            if (local_err != NULL) {
> +	arm_cpu_pauth_finalize(cpu, &local_err);
> +	if (local_err != NULL) {
>                   error_propagate(errp, local_err);
>                   return;
> -            }
> -        }
> +	}

Looks like the indentation is off?

> +static bool kvm_arm_pauth_supported(void)
> +{
> +    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
> +}

Do we really need to have them both set to play the game?  Given that the only thing that 
happens is that we disable whatever host support exists, can we have "pauth enabled" mean 
whatever subset the host has?


> @@ -521,6 +527,17 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>        */
>       struct kvm_vcpu_init init = { .target = -1, };
>   
> +    /*
> +     * Ask for Pointer Authentication if supported. We can't play the
> +     * SVE trick of synthetising the ID reg as KVM won't tell us

synthesizing

> +     * whether we have the architected or IMPDEF version of PAuth, so
> +     * we have to use the actual ID regs.
> +     */
> +    if (kvm_arm_pauth_supported()) {
> +        init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
> +			     1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);

Align the two 1's.

Otherwise, it looks good.


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
