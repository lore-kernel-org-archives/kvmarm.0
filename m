Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12522C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 13:53:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88DA861283
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 13:53:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88DA861283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13BBF4B2AC;
	Thu,  7 Oct 2021 09:53:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cyJwQsRmKnSR; Thu,  7 Oct 2021 09:53:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D42E34B2AE;
	Thu,  7 Oct 2021 09:53:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 059C54B271
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 09:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IvZBvRiigmWW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 09:53:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7D9C4B137
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 09:53:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633614789;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=OCnUFCDFWcoWZv9I+WDnAKonvZ48CTfwyEqTI4QgXnI=;
 b=EBYggZydUhRC/sYoZaoNgBzZmTFPALxtqF4tb4HENA04iM6j5aDmAereF9kQJJ6xh8IxyV
 sJb11lvoAjTsWkQdlgQsUdiEimEcwoBfmWlFEnk6OLZN/qzd9eOCM48cpqyUErS7IJnU0x
 brlPE5VJOJDsf4+CliTyYM5Iv7LCUr8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-I_P0635uNQ-AN30j_e6bYQ-1; Thu, 07 Oct 2021 09:53:08 -0400
X-MC-Unique: I_P0635uNQ-AN30j_e6bYQ-1
Received: by mail-qv1-f70.google.com with SMTP id
 m10-20020ad4448a000000b003833687f674so960639qvt.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 06:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OCnUFCDFWcoWZv9I+WDnAKonvZ48CTfwyEqTI4QgXnI=;
 b=PcL+ZbRqVOg+QIuasI8Xj4GJ5GFEyaWnv9BoVsoqMq/fB+22/0bYYbFdYybqionWrz
 Y4K7H7k5WbrbMNuA8W+ICQXprSjqSImj1fTR3GuBiOKGKAmyZz1n8zbnvXr6qGiJ2rDE
 dWvO5m0u3RtsQZMTIKPshUNp3+oF6Hre2BNVteclQzTubfQtiNFQF2snzPnVVr1sWIys
 CX2UYO2ukKPOzq0TpJY6HpxNMv3HdxNdXeqg3luvRjw8D7+aQ/V4poZYp26/7TMjm5Jv
 NnUvEKG2tuoYA2nOHcEU3tNGdGFATbktVOkFEBTB5yxMzUgoM2SGTLIe+2lGrbzGLEzF
 8uDA==
X-Gm-Message-State: AOAM533gVQziz465gTQEPQYZfew1SLqQzZ3GHPH5VC/qQshz97vsvYy/
 rGxPDg6WQnJ2w4hbsP89rUzWr9vvpqkaMSb1DuPrxF65lyfUkBESnd1byNx4dQgPQg/W+Q7BXuY
 A6Me4rQR3vQf8NULo6h2Hk0q2
X-Received: by 2002:ac8:404f:: with SMTP id j15mr5067190qtl.361.1633614788500; 
 Thu, 07 Oct 2021 06:53:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQr9CRm+JNFfKdbw14ykOPjUDm4MfkE8BuAkCsB288O/A4ZkxEiEofqmPBzACzDam2GSnZUg==
X-Received: by 2002:ac8:404f:: with SMTP id j15mr5067165qtl.361.1633614788323; 
 Thu, 07 Oct 2021 06:53:08 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id x79sm13881345qkb.65.2021.10.07.06.53.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Oct 2021 06:53:07 -0700 (PDT)
Date: Thu, 7 Oct 2021 15:53:03 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 07/16] KVM: arm64: Wire MMIO guard hypercalls
Message-ID: <20211007135303.rbyvltetm3h4sqyy@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-8-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-8-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Mon, Oct 04, 2021 at 06:48:40PM +0100, Marc Zyngier wrote:
> Plumb in the hypercall interface to allow a guest to discover,
> enroll, map and unmap MMIO regions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hypercalls.c | 28 ++++++++++++++++++++++++++++
>  include/linux/arm-smccc.h   | 28 ++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..c39aab55ecae 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> @@ -129,10 +130,37 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> +		/* Only advertise MMIO guard to 64bit guests */
> +		if (!vcpu_mode_is_32bit(vcpu)) {
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP);
> +		}
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>  		kvm_ptp_get_time(vcpu, val);
>  		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			val[0] = PAGE_SIZE;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu)) {
> +			set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
> +			val[0] = SMCCC_RET_SUCCESS;
> +		}
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu) &&
> +		    kvm_install_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
> +			val[0] = SMCCC_RET_SUCCESS;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu) &&
> +		    kvm_remove_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
> +			val[0] = SMCCC_RET_SUCCESS;
> +		break;

Since these are all ARM_SMCCC_SMC_64 calls, can we do some sort of
refactoring first, similar to Oliver's "KVM: arm64: Clean up SMC64 PSCI
filtering for AArch32 guests", which would avoid the need for all the
!vcpu_mode_is_32bit's?

>  	case ARM_SMCCC_TRNG_VERSION:
>  	case ARM_SMCCC_TRNG_FEATURES:
>  	case ARM_SMCCC_TRNG_GET_UUID:
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 7d1cabe15262..4aab2078d8d3 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -107,6 +107,10 @@
>  /* KVM "vendor specific" services */
>  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
>  #define ARM_SMCCC_KVM_FUNC_PTP			1
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO	2
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL	3
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP	4
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP	5
>  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>  #define ARM_SMCCC_KVM_NUM_FUNCS			128
>  
> @@ -133,6 +137,30 @@
>  #define KVM_PTP_VIRT_COUNTER			0
>  #define KVM_PTP_PHYS_COUNTER			1
>  
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID		\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID		\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID			\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID		\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP)
> +
>  /* Paravirtualised time calls (defined by ARM DEN0057A) */
>  #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
>  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> -- 
> 2.30.2
>

Besides the refactoring suggestion,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
