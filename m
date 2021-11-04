Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACEAFC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:23:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 288F8611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 288F8611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838AF4B106;
	Wed,  3 Nov 2021 20:23:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 429bsBIgN8xB; Wed,  3 Nov 2021 20:23:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092534A531;
	Wed,  3 Nov 2021 20:23:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F114A531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:23:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U8iQTgsKGm6i for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:23:50 -0400 (EDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEA3F4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:23:50 -0400 (EDT)
Received: by mail-io1-f41.google.com with SMTP id i79so4672692ioa.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GJHduIoLbm++PXo1EI9ctmGW1RwoyK72y3OY0VPBDcU=;
 b=jUR/GFvWK1GOvD7Tfxk3VIQLmqOGgFb5VaXQJqkZQpsZVHVN1VvJwhZ9ekdTub4o3Y
 /FoswRQyi2S84daaMTIAWZ+mbmA4/ahSy+DhuOt0Gs4dAsaoDjJsyaxFD1o/zDdXwMwr
 IQeiiLI//6cJ1aPm9ItJN8j7Y5V+O5EUei3K7AEOsdK7bAREGOclHn9V3b3D/qfWNdnQ
 46bl9OMMumnpjKt5V3ThiCfCTAjXlmBk6pMLd2s++zGNkoI7NOhithCH4bedvs+7gl1d
 odN7ejoM2KJDLUmOnsxjtAq0MYDaTBwDI81FkSVeYHBkWV87C4htjIKhLS0zCxoxGl1s
 jObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GJHduIoLbm++PXo1EI9ctmGW1RwoyK72y3OY0VPBDcU=;
 b=7zdWtDgen3/l2Hzfh69dmIvq+xhVASelSpNVSQtBAf6PFwJvcQaUzDiS1LPHqh2zWj
 eD/J2JGpaUf/l5gD0z1ZdhBRHFcwNERKxbNvLgq9wEqAjJtDWYz3Q6zK57lNY/N5osco
 k/T6wSMneJfLsQEG8BPZQYcpDbAYu+0M7HCm2F16PXjxQqm+lqIWNxNqOKRI5uk7BMVp
 YBfQODy4yFmBvvB3ayH2IkD/ciVveH0x7TPOrG4KAWD7vPUQUhAavhzEVh7WO9dGbHm8
 7ha862VFQ3XyHphPZPbfSfT6YjJvxjcnqpMFyVK7cvPgaG28+tlO2AS5PPKSXHz5bblb
 N0rA==
X-Gm-Message-State: AOAM530lP4ch1E0hVAnWU+e0PR+Zg7FCf4g6MT5J9jRjiDLrqo/wCAQA
 2ORpw5uphHPmLpG7cPy85R7ZpA==
X-Google-Smtp-Source: ABdhPJyTGKht0zujMuYCiiB6MJx/sODaKaDOpIuVJQZerGrdP28hHl/7//HWQ2d2tD6/tKDFH4UFMQ==
X-Received: by 2002:a5d:954b:: with SMTP id a11mr33541647ios.99.1635985429851; 
 Wed, 03 Nov 2021 17:23:49 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id s5sm1881667ilq.59.2021.11.03.17.23.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 03 Nov 2021 17:23:49 -0700 (PDT)
Date: Thu, 4 Nov 2021 00:23:45 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH 6/8] tools: Import the firmware registers
Message-ID: <YYMoEYzBvEqN5MD7@google.com>
References: <20211102002203.1046069-1-rananta@google.com>
 <20211102002203.1046069-7-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211102002203.1046069-7-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Nov 02, 2021 at 12:22:01AM +0000, Raghavendra Rao Ananta wrote:
> Import the firmware definitions for the firmware registers,
> KVM_REG_ARM_STD, KVM_REG_ARM_STD_HYP, and KVM_REG_ARM_VENDOR_HYP.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> 
> ---
>  tools/arch/arm64/include/uapi/asm/kvm.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Won't we have the latest UAPI headers available in usr/include/ at build
time?

--
Oliver

> diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..a1d0e8e69eed 100644
> --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
> @@ -281,6 +281,24 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
>  
> +#define KVM_REG_ARM_STD			KVM_REG_ARM_FW_REG(3)
> +enum kvm_reg_arm_std_bmap {
> +	KVM_REG_ARM_STD_TRNG_V1_0,
> +	KVM_REG_ARM_STD_BMAP_MAX,
> +};
> +
> +#define KVM_REG_ARM_STD_HYP		KVM_REG_ARM_FW_REG(4)
> +enum kvm_reg_arm_std_hyp_bmap {
> +	KVM_REG_ARM_STD_HYP_PV_TIME_ST,
> +	KVM_REG_ARM_STD_HYP_BMAP_MAX,
> +};
> +
> +#define KVM_REG_ARM_VENDOR_HYP		KVM_REG_ARM_FW_REG(5)
> +enum kvm_reg_arm_vendor_hyp_bmap {
> +	KVM_REG_ARM_VENDOR_HYP_PTP,
> +	KVM_REG_ARM_VENDOR_HYP_BMAP_MAX,
> +};
> +
>  /* SVE registers */
>  #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
>  
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
