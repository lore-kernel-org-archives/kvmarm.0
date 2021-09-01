Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0806DC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 23:27:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 793B561053
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 23:27:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 793B561053
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81134B0AC;
	Wed,  1 Sep 2021 19:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zam1loBdTL3x; Wed,  1 Sep 2021 19:26:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 165134B192;
	Wed,  1 Sep 2021 19:26:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAACE4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 19:26:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E9u3zrnDGHSA for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 19:26:57 -0400 (EDT)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC0954B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 19:26:56 -0400 (EDT)
Received: by mail-io1-f46.google.com with SMTP id b7so163543iob.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 16:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rOUt9lzL9h2nq8MizjgBr+LfkDuELuuwWbBlNJOQ814=;
 b=jR/4VwVeeFqV1reopTHZE859VRG+CTWfBgJ8xN+yYGIx367PJ9Bws70Zg1EV1ucG2W
 Y2lFJoMSCpZf0ZOBx+NjhIwk4yEFfXdTmKpLSNameuBcxm0f3b2xsZjDWWLkXQzioQzB
 rdiu2pi+dfj/LlK0SlnX6FXxRO6MlVrubO0LNbHQ1f2H+r49vZAn5pbFbLXLrAIpkyvv
 0mbcwbkA1+xfcqzsopbM8IzOFTKlUOVzRZtTJtxfRnE1RlJMRGD/lXwDFs9D701+M4E3
 2garEAvPOF6McbV+BoD72/uphVFvhiZwvjqcrhncYz9MizgjNlM4Tikc2xVWnh6P+yPf
 Hg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rOUt9lzL9h2nq8MizjgBr+LfkDuELuuwWbBlNJOQ814=;
 b=O2hvKz1zkIsWKbx09omYd28x18BjAUsZYpPm0Ypwjtu2nx7C7qzj/QccBe+5OR+GW8
 HnOWKvhWcoe+S1/hZDMQEhybngt6Ap/NL++Pcdq0hX0ZAGHDA3lrY1r4hLNmasMYtkmC
 MT36pYuhvUP+yRKwAIw6oaXn7kDhyJeJ/Y71g/MeHosLJIj+fUJkQS47w5RRnGWVWUTr
 qLCEDRpR9S9MLpLJ3fCQHEM5QL0BL2w6p+IxDxHKVqMT5hovZgsxuZcTwST5VedShmz4
 LGQhHo0BV6IDfOBEnMndAGN0dT9d+Pp9afikNd5MCIU+tB0mdzE4JqkdXDOXRDs5q/fc
 CQoQ==
X-Gm-Message-State: AOAM531PULhWtF76+YbJ38gNS5S3e/5MmtOcHZY0wLpzW5itekE2fJ2U
 RNT9ZpXES1//cc6w4URudKn+xg==
X-Google-Smtp-Source: ABdhPJzCa6eAMWUaKvrSDwb4bW983RzCXex8DdL6ys7hZpXkcFNe3o+vWqlq6lWO9U5Kc26/5lS5Gw==
X-Received: by 2002:a5d:9b99:: with SMTP id r25mr279115iom.104.1630538816261; 
 Wed, 01 Sep 2021 16:26:56 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id q12sm14251ioh.20.2021.09.01.16.26.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 16:26:55 -0700 (PDT)
Date: Wed, 1 Sep 2021 23:26:52 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 06/12] KVM: arm64: selftests: Add support to disable
 and enable local IRQs
Message-ID: <YTAMPIBDSl1rJHUR@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-7-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-7-rananta@google.com>
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

On Wed, Sep 01, 2021 at 09:14:06PM +0000, Raghavendra Rao Ananta wrote:
> Add functions local_irq_enable() and local_irq_disable() to
> enable and disable the IRQs from the guest, respectively.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 78df059dc974..c35bb7b8e870 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -241,4 +241,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
>  #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
>  #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
>  
> +static inline void local_irq_enable(void)
> +{
> +	asm volatile("msr daifclr, #3" : : : "memory");
> +}
> +
> +static inline void local_irq_disable(void)
> +{
> +	asm volatile("msr daifset, #3" : : : "memory");
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
