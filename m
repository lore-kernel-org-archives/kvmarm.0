Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238A9C4320A
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:10:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98A6A61090
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98A6A61090
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 197F24B09E;
	Wed,  1 Sep 2021 18:10:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MGYKs7gCADGq; Wed,  1 Sep 2021 18:10:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE6C4B150;
	Wed,  1 Sep 2021 18:10:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDD434B120
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:10:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oGqd6BoL0ttS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 18:10:17 -0400 (EDT)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E329E4B09E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:10:17 -0400 (EDT)
Received: by mail-io1-f46.google.com with SMTP id z1so1112928ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 15:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
 b=OOv/w+/psizy/DhiK4zgTzBa+yQSn/axNYDdGlR698y7GMR6zMuAi8a9i4OuVbJLj3
 fxD9JF82Ws31zhzEUgBPX8DyK2uc5kiIr+iDVadf9MWECxBs6evXSoq5kcnSaN46O5bp
 B5VZpg7XIgwW5ytafFIlN9wteWQn88jXrRqcyEjFL0L1h6vjf0ZFDqOolmNB+QJ7q/ak
 3LdJxADcRoOE1RnP3pEbq+pX9f9mXOV4yNFMF89myZ/5WsWQWA4JzdA7i61pov79exlC
 45VVE8GosGLs1VbO1TF3PymyAC3q/7uspmPnOapVMh9PmqySmvvqo1DaS2J8kSn+Q4iu
 z7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
 b=DvAycQQOHfAshk2rv94YA0eZZsfP4KXuBMjUBhyRjuQeQqUwHQFvoISTBPdUp0u3Pw
 VBeGsi59HvOtDKquQamDiaaKEwZ3ecj4ohIppKRk7RGUywpOOszeNEFJZggU+akyKi4y
 d97am3423D+zZnW2gYhXp1vhPim+HMndP8XEcw/gNIGO2k8Mtm2PMfy+H4r493Rfrcsa
 PAGy7AByvoKRZdhJV0J8LuBP0PVqxrnEEqTldl/jQnMf1k6lZSv7rF5TNLtKmhnG4/6E
 BitLP6z8HJ6QWk7fnU/ofdQtKbtAZbpiV9k3QerzdDT/YzTF7P6bJFMCd7kJPrh2aXdN
 aICg==
X-Gm-Message-State: AOAM532M/KJzcWCJTpZLZihvrHIA51Qs3Gk4N5ac1oaIsTQpQyCugDPk
 4g/W/Dx4C7oJcigxraI0/+uy3w==
X-Google-Smtp-Source: ABdhPJySzt8yvEcNMvACBvDBo4zdwifpTI+hcV+s3GieMcGv75P4h3hv4hnkMh9HLpsRhVbkfBXl9Q==
X-Received: by 2002:a05:6602:2c07:: with SMTP id
 w7mr50345iov.122.1630534217200; 
 Wed, 01 Sep 2021 15:10:17 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id a17sm489028ios.36.2021.09.01.15.10.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 15:10:16 -0700 (PDT)
Date: Wed, 1 Sep 2021 22:10:13 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
Message-ID: <YS/6RZG7Elr9fPQP@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-4-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-4-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 01, 2021 at 09:14:03PM +0000, Raghavendra Rao Ananta wrote:
> Implement the guest helper routine, cpu_relax(), to yield
> the processor to other tasks.
> 
> The function was derived from
> arch/arm64/include/asm/vdso/processor.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 082cc97ad8d3..78df059dc974 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -191,6 +191,11 @@ asm(
>  	val;								  \
>  })
>  
> +static inline void cpu_relax(void)
> +{
> +	asm volatile("yield" ::: "memory");
> +}
> +
>  #define isb()		asm volatile("isb" : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
