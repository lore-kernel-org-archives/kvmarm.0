Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359CBC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 20:24:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 795D64B283;
	Fri,  7 Jan 2022 15:24:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KrLg7IQFf+Zv; Fri,  7 Jan 2022 15:23:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F604B2AC;
	Fri,  7 Jan 2022 15:23:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E3FA4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 15:23:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bhRXVZPWsXGv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 15:23:57 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 360E14B220
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 15:23:57 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id z30so2865877pge.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 12:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=xDdfZmWyqdSVTAXVBADg0hD3oX2PNa9PSothirQTFSc=;
 b=GwFaMgbOJ7vA6rwcaZq6QXY9LSIBtiqYffH5RrxDF70uezPqIy7HuzeQ2SjW+QEbUz
 CKT8I/s+pt1nYnGQZ/O3D5QH7UcQu7QSnMS81azkgUo+9wjFyuwZlaQ5CPLw+ZzBDHOR
 Q9t2e0yQCppOMHHOEWhdFw9AO4HLdkdBAFpOZNtu9bjQ3ej25vV1ttXJXhy/EBqNHtgx
 pJuI4xCtsiAznyoXE0fPfCUSWmOcp40jwUOKW4vI4q98KxU7hhnQAcdPfRMy1F3v6sOp
 568KU5kdPZthHU8gwNSyJJ7e7GHeazy13Jg2fKMA5yeEKAIAjqyb9NtPvAA5vX+MJR+e
 GMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=xDdfZmWyqdSVTAXVBADg0hD3oX2PNa9PSothirQTFSc=;
 b=2DWuFDTsajqw7+YYPqGt1BIPpkTWz4odRVh9wgQPxiSFQG1Z8AjaeUMtPKYLd6Ruzt
 VwBEKTWZUX8RGav11UNxGc8my50eDW08+j151rSG11DdtgQSQNwIl6tYKZ/+appwkrlM
 HOSXhl8TsA0sJZIIfN/azBtTN3sD4HmUwPPGnFSdyqdOiWcQAxA6xc5BKx3OozOJMg9h
 SzfEWibNVQiAKfGVMe19jGzNNfH1/PVizsXPJ4F8jZp7rBLupcqr0BeKNJr9ms9LbxJi
 J3xdf/iI5mxRYcvECctM1gZ7a5X0pntY+SEGYVcKrw9FlcrboLDgpRiMfwaqA1NUHWI8
 j70g==
X-Gm-Message-State: AOAM530D36FlBPFLC91ORZVB7AOYCU2VOnfgAco4oP2j1AQ0SWP58230
 QPJmtQVVtV8icqN565nNhSIFzQ==
X-Google-Smtp-Source: ABdhPJzftw4PEotEHASckTN5Gy0MMQebU7XjsnC+2xdRTZQFdnCEJ67BUd0zbNp7g3vfVMes2gAU8A==
X-Received: by 2002:a63:9602:: with SMTP id c2mr42975234pge.538.1641587036373; 
 Fri, 07 Jan 2022 12:23:56 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
 by smtp.gmail.com with ESMTPSA id p24sm6121962pfn.33.2022.01.07.12.23.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 07 Jan 2022 12:23:55 -0800 (PST)
Subject: Re: [PATCH v3] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220107150154.2490308-1-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Message-ID: <a3d32f18-dbbb-e462-82ce-722f424707f9@linaro.org>
Date: Fri, 7 Jan 2022 12:23:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220107150154.2490308-1-maz@kernel.org>
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

On 1/7/22 7:01 AM, Marc Zyngier wrote:
> @@ -1380,17 +1380,10 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
>               return;
>           }
>   
> -        /*
> -         * KVM does not support modifications to this feature.
> -         * We have not registered the cpu properties when KVM
> -         * is in use, so the user will not be able to set them.
> -         */
> -        if (!kvm_enabled()) {
> -            arm_cpu_pauth_finalize(cpu, &local_err);
> -            if (local_err != NULL) {
> +        arm_cpu_pauth_finalize(cpu, &local_err);
> +        if (local_err != NULL) {
>                   error_propagate(errp, local_err);
>                   return;
> -            }
>           }

Indentation is still off -- error + return should be out-dented one level.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
