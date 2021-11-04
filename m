Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9290C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:10:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AC2660D43
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5AC2660D43
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0A514B089;
	Thu,  4 Nov 2021 12:10:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id amMkxG00m6XM; Thu,  4 Nov 2021 12:10:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10EA649F5D;
	Thu,  4 Nov 2021 12:10:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9823549F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:10:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TfCO6HlRzVyi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 12:10:21 -0400 (EDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B5A849E5F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:10:21 -0400 (EDT)
Received: by mail-io1-f45.google.com with SMTP id p193so7486395iod.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 09:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tUqoCGNnbxt+oywUiqReWRW9/LoLH193vc9R2cKGEpc=;
 b=oUHtN5yvmtuLU7Rt+p4AHRDksWqkQE+q3NqxcycZqtF9qmtzdBQ2tL5D+HqyyO/6T6
 6RAH0Gm9enHnLZalZqd5vPhRiGo2BfuVG1/UtiQ5AlwtVyQxemDr2UAwLCeojaWJY//d
 HNaQIvQ9Z/HOjrGtUSDqmFuin9f0hb4Y5NwlAWG/Qb2plZ0RdYYhu1GhofX6SKx3Fcec
 jwV3+ZgpfWp9BUkGER+zSl8pSOY4QNbMW2htCUrZqDu7/lMD/Gm1y3hTLz0Q76u2LZ7Z
 UzOJSTuv5DMxl/thqh42/QR39gXTNNEE4XRxPV9P0rl7usFCGjCvM9eOZ5QGb5QuEpX8
 Umtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tUqoCGNnbxt+oywUiqReWRW9/LoLH193vc9R2cKGEpc=;
 b=VD/CBOctCTUkfwDN36mT709+1nBHTKC52na3vx1bxF/YBrERlJomVVTFqzPRwZlgYI
 XLdpPLNTrViWAMEAzAtEn4jHJwO6gmE05yj/Abegv3r7Ol1wEHlD5oLAQMdPFf8wGcy8
 zKxPxvNYuOVfDdEUSd+x3DGdeXGMjlOZTuMwTeVpuI7zCvW4DdIVc/s6lOFZK8dvuE8e
 +m4EaNUJqMUZJ3uFlrrR7FOoxCWlOMpDe03Vm5FV444z6NjQcpYRIrzKQ0tgMYTsSIAh
 AQimBWHoJXBePqP/90GJhjsLKUkBNeh3mirBU4kAKtql4TzU0/KmVD5QW79De+gUoCzV
 OJdQ==
X-Gm-Message-State: AOAM531iKwBTwE+mRPdcyJOF4elttYbi5/ETv7g3GDHQK6p8gvctEfvE
 2A9W68wOj8mS/3iUi7v/GjoF6w==
X-Google-Smtp-Source: ABdhPJysdsBusunjAyJwyQgc6/PueGiLqEhbeMUOLxDa87sm4If+utgQP/RXb6DCfoSyUOfBj47T8g==
X-Received: by 2002:a05:6638:d84:: with SMTP id
 l4mr4682907jaj.30.1636042220331; 
 Thu, 04 Nov 2021 09:10:20 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id w11sm2661526ior.40.2021.11.04.09.10.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Nov 2021 09:10:19 -0700 (PDT)
Date: Thu, 4 Nov 2021 16:10:16 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v2 01/28] KVM: arm64: Add has_reset_once flag for vcpu
Message-ID: <YYQF6HSMYDww1Gk7@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-2-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-2-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

On Tue, Nov 02, 2021 at 11:24:53PM -0700, Reiji Watanabe wrote:
> Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> if the vCPU reset has been done once, for later use.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/reset.c            | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..9b5e7a3b6011 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +	bool has_reset_once;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> +#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)						\
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 5ce36b0a3343..4d34e5c1586c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	if (loaded)
>  		kvm_arch_vcpu_load(vcpu, smp_processor_id());
>  	preempt_enable();
> +
> +	if (!ret && !vcpu->arch.has_reset_once)
> +		vcpu->arch.has_reset_once = true;
> +
>  	return ret;
>  }
>  
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
