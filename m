Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94E6C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 13:38:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57BAC610FB
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 13:38:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57BAC610FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FAA4B0AD;
	Tue, 20 Jul 2021 09:38:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V1zHGR8-L94m; Tue, 20 Jul 2021 09:38:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90CFD4B0BB;
	Tue, 20 Jul 2021 09:38:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A79004B0AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 09:38:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J56ZjOUEgA9Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 09:38:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C43594AED4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 09:38:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626788296;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=vU/6bjwZL5Bd6mANqCXpmHsjLsH8+dFlpfCQrauhKS0=;
 b=AcuoE5vI4XT6VOw1F7tuxgaJq3oPif4DO4XrC6NUz8PBWESf/gqGW4OVTT8a09CxwSDZ6D
 G8JK7tzU+GWCJPPIY17f+F0etm+y6PPZVmKb5ANObOHCB1b4VYeOtjaApKdbgL8bb4exI7
 uP34M6nH74Q7NsuPX9kxOExdvpAr0yc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-OXbBdjmXOJCbZKqW1GKDGg-1; Tue, 20 Jul 2021 09:38:15 -0400
X-MC-Unique: OXbBdjmXOJCbZKqW1GKDGg-1
Received: by mail-il1-f197.google.com with SMTP id
 t12-20020a92c0cc0000b0290210d3ffca31so13081326ilf.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vU/6bjwZL5Bd6mANqCXpmHsjLsH8+dFlpfCQrauhKS0=;
 b=VG61DAFarEeT6biOSnzpZ2nHD6goBBB1rY56PmxMH00K6uqt9GBYSpF7/c48kXS04l
 rFbMeRrg7QJ1l43PTsXPJAcRGLB64Ss1zkAUQzPska1a92O04XIp/ldRGrztAtzXAmLn
 ox1rS5gfVb+ScSrtRzv31cv2+bh8y2lWrTXDpEKdcvbjHhkistYveS51Av23/p3Oati+
 spTFeS2LNSS6bOmTFXm56QGIrDEbE6EVgxk8M9GcBCPemncqoDzu2l4RFG1N1BpQhT7W
 4PcKAHfbUGjgbW9OuiwpjLXTHeQ/5PwS34iTWe/5dHKoSQU545AiWYs4e+jLjyXhZZJQ
 TAmw==
X-Gm-Message-State: AOAM531SLDuR2T3H+VyuyG2BCIXDtiTFetoYy66EQ3b/8BRxGSK7d5MQ
 xSKGQh3LIuWoFkiWGoa+rSuhxjVeKeWbFRttyYXyX7UdSkO7QAgwWsxTWs8qvUyhphqVeCOt7ty
 GedUJpkqsftqXZL8TBmAH/4RT
X-Received: by 2002:a05:6e02:2162:: with SMTP id
 s2mr20749934ilv.99.1626788294460; 
 Tue, 20 Jul 2021 06:38:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2c+KuF4Es06cQJtPkV9Pm8wrKxtYAjfiHMsDibZFB3bZtEeXiPfi39fOPzymmy4PgDZFt1Q==
X-Received: by 2002:a05:6e02:2162:: with SMTP id
 s2mr20749917ilv.99.1626788294272; 
 Tue, 20 Jul 2021 06:38:14 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id e9sm11345255ils.61.2021.07.20.06.38.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 06:38:13 -0700 (PDT)
Date: Tue, 20 Jul 2021 15:38:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h, c for nVHE reuse
Message-ID: <20210720133810.7q4k2yde57okgvmm@gator>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-6-tabba@google.com>
MIME-Version: 1.0
In-Reply-To: <20210719160346.609914-6-tabba@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jul 19, 2021 at 05:03:36PM +0100, Fuad Tabba wrote:
> Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> common code. It will be used in nVHE in a later patch.
> 
> Note that the refactored code uses __inline_bsearch for find_reg
> instead of bsearch to avoid copying the bsearch code for nVHE.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  3 +++
>  arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
>  arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 7b9c3acba684..326f49e7bd42 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1153,6 +1153,9 @@
>  #define ICH_VTR_A3V_SHIFT	21
>  #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
>  
> +/* Extract the feature specified from the feature id register. */
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))

I think the comment would be better as

 Create a mask for the feature bits of the specified feature.

And, I think a more specific name than FEATURE would be better. Maybe
FEATURE_MASK or even ARM64_FEATURE_MASK ?

> +
>  #ifdef __ASSEMBLY__
>  
>  	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 80a6e41cadad..1a939c464858 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -44,10 +44,6 @@
>   * 64bit interface.
>   */
>  
> -#define reg_to_encoding(x)						\
> -	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
> -		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> -
>  static bool read_from_write_only(struct kvm_vcpu *vcpu,
>  				 struct sys_reg_params *params,
>  				 const struct sys_reg_desc *r)
> @@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> -
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
>  	return 0;
>  }
>  
> -static int match_sys_reg(const void *key, const void *elt)
> -{
> -	const unsigned long pval = (unsigned long)key;
> -	const struct sys_reg_desc *r = elt;
> -
> -	return pval - reg_to_encoding(r);
> -}
> -
> -static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
> -					 const struct sys_reg_desc table[],
> -					 unsigned int num)
> -{
> -	unsigned long pval = reg_to_encoding(params);
> -
> -	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> -}
> -
>  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
>  {
>  	kvm_inject_undefined(vcpu);
> @@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> -	params.Op0 = (esr >> 20) & 3;
> -	params.Op1 = (esr >> 14) & 0x7;
> -	params.CRn = (esr >> 10) & 0xf;
> -	params.CRm = (esr >> 1) & 0xf;
> -	params.Op2 = (esr >> 17) & 0x7;
> +	params = esr_sys64_to_params(esr);
>  	params.regval = vcpu_get_reg(vcpu, Rt);
> -	params.is_write = !(esr & 1);
>  
>  	ret = emulate_sys_reg(vcpu, &params);
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 9d0621417c2a..cc0cc95a0280 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -11,6 +11,12 @@
>  #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
>  #define __ARM64_KVM_SYS_REGS_LOCAL_H__
>  
> +#include <linux/bsearch.h>
> +
> +#define reg_to_encoding(x)						\
> +	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
> +		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> +
>  struct sys_reg_params {
>  	u8	Op0;
>  	u8	Op1;
> @@ -21,6 +27,14 @@ struct sys_reg_params {
>  	bool	is_write;
>  };
>  
> +#define esr_sys64_to_params(esr)                                               \
> +	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
> +				  .Op1 = ((esr) >> 14) & 0x7,                  \
> +				  .CRn = ((esr) >> 10) & 0xf,                  \
> +				  .CRm = ((esr) >> 1) & 0xf,                   \
> +				  .Op2 = ((esr) >> 17) & 0x7,                  \
> +				  .is_write = !((esr) & 1) })
> +
>  struct sys_reg_desc {
>  	/* Sysreg string for debug */
>  	const char *name;
> @@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>  	return i1->Op2 - i2->Op2;
>  }
>  
> +static inline int match_sys_reg(const void *key, const void *elt)
> +{
> +	const unsigned long pval = (unsigned long)key;
> +	const struct sys_reg_desc *r = elt;
> +
> +	return pval - reg_to_encoding(r);
> +}
> +
> +static inline const struct sys_reg_desc *
> +find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
> +	 unsigned int num)
> +{
> +	unsigned long pval = reg_to_encoding(params);
> +
> +	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> +}
> +
>  const struct sys_reg_desc *find_reg_by_id(u64 id,
>  					  struct sys_reg_params *params,
>  					  const struct sys_reg_desc table[],
> -- 
> 2.32.0.402.g57bb445576-goog
>

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
