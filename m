Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAB1C388F9
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 12:52:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E3FF20857
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 12:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="n+SsvAnO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E3FF20857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6DF84B909;
	Mon, 23 Nov 2020 07:51:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1gAmx6aDmbsR; Mon, 23 Nov 2020 07:51:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D12724B96B;
	Mon, 23 Nov 2020 07:51:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D84794B8C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 07:51:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4SiVI2E3AAMQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 07:51:56 -0500 (EST)
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0DE54B909
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 07:51:56 -0500 (EST)
Received: by mail-ej1-f68.google.com with SMTP id gj5so23118034ejb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jnD6JxIyxc4vm54K4tKnhPWtevyVeHY1Zgn00laUUfA=;
 b=n+SsvAnOuvFpo9fuYFpraPfRqMJQBKN5DmMsO67xbOdk7xeiFLjd9qowus6ere1Cg3
 IyClkLOxj+jm6I2dSTy2Tx1nAoEZtFF6N2t915Kw+bQ+hCeNUQe+u8vfps7+3A37Wd0i
 Xw468ZyUMHg34aARMw+5sCah5Ife3hgkIOgBaEFtTkrdvjw+F3UZo5x6JCdflbNWKuPL
 +gH7yEC9lZxw9iErt3++xiBCrsbPc8RsDMEJx2rKd5jMKKG8buEGI2odLG0PEC0EqUaX
 T33iehIZOGb9ctsRDtPWP1OUCnXL1/JQt4rpA1d7l2yVOfogxApssQ/fZAMIbiU6O13Y
 pn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jnD6JxIyxc4vm54K4tKnhPWtevyVeHY1Zgn00laUUfA=;
 b=QacM51aVJrwAhKMf6Held8Vlr3VJ25xL8aNBQLixfAh/+Tr6PNnemgl8D2OtfXbVy1
 stAldgnpSRCY8Zw23r1fmCnXpJpQNG3wwgf1h661Pz7uDFSHIB293dnaA4w2UClbD1Ko
 MPFvRDiAdB0JD4Ggbrqu0t3VA4AN2islbuMCDRwbtoRS9/Rbhv8HH2OG+atL7bL0uEfc
 bW3A3F+QSkRJwc/JT06G5XnzzjQiRAqqT3lTivwUoUyvIbmQE622jbpOR8c0M69iUZ5g
 lPzLwVkuD33zAjPIDdzYKw9l/BS+ytGDvxQi/4/+Jyy1o3KpOXBNNpkTh9LHFHOc8fE2
 iQRg==
X-Gm-Message-State: AOAM531xZo+2+hkiwfslvJL+Nk5oJiENeUyuAwbdB0MwRt9mdDBykzFE
 hoNZZJlE0osMuy8aU/J0cpEM2g==
X-Google-Smtp-Source: ABdhPJzoJRpQuSQbyVo4FnWnIGE0h6PqMXD5ASqgZR/lDI3/6lf/+dq9ThIlEFnuoEOJELCR8o+4KQ==
X-Received: by 2002:a17:907:c14:: with SMTP id
 ga20mr43858051ejc.526.1606135915525; 
 Mon, 23 Nov 2020 04:51:55 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acac:b2ef:c7d:fd8a])
 by smtp.gmail.com with ESMTPSA id z19sm4921235ejj.101.2020.11.23.04.51.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 04:51:54 -0800 (PST)
Date: Mon, 23 Nov 2020 12:51:53 +0000
From: David Brazdil <dbrazdil@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 08/27] KVM: arm64: Make kvm_call_hyp() a function
 call at Hyp
Message-ID: <20201123125153.hnipzls2ijptpti7@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-9-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201117181607.1761516-9-qperret@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Tue, Nov 17, 2020 at 06:15:48PM +0000, 'Quentin Perret' via kernel-team wrote:
> kvm_call_hyp() has some logic to issue a function call or a hypercall
> depending the EL at which the kernel is running. However, all the code
> compiled under __KVM_NVHE_HYPERVISOR__ is guaranteed to run only at EL2,
> and in this case a simple function call is needed.
> 
> Add ifdefery to kvm_host.h to symplify kvm_call_hyp() in .hyp.text.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac11adab6602..7a5d5f4b3351 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -557,6 +557,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> +#ifndef __KVM_NVHE_HYPERVISOR__
>  #define kvm_call_hyp_nvhe(f, ...)						\
>  	({								\
>  		struct arm_smccc_res res;				\
> @@ -596,6 +597,11 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  									\
>  		ret;							\
>  	})
> +#else /* __KVM_NVHE_HYPERVISOR__ */
> +#define kvm_call_hyp(f, ...) f(__VA_ARGS__)
> +#define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
> +#define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
> +#endif /* __KVM_NVHE_HYPERVISOR__ */

I was hoping we could define this as the following instead. That would require
adding host-side declarations of all functions currently called with _nvhe.

#define kvm_call_hyp_nvhe(f, ...)					\
+	is_nvhe_hyp_code() ? f(__VA_ARGS__) :				\
	({								\
		struct arm_smccc_res res;				\
									\
		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
				##__VA_ARGS__, &res);			\
		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
									\
		res.a1;							\
	})

Up to you what you think is cleaner, just my 2 cents...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
