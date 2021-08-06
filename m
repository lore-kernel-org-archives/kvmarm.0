Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3077DC432BE
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 13:40:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABCAC61181
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 13:40:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ABCAC61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 231D54B0F0;
	Fri,  6 Aug 2021 09:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id riPgKxcqdUhw; Fri,  6 Aug 2021 09:40:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7FFA4B0EA;
	Fri,  6 Aug 2021 09:40:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 264AD4B0E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 09:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ks99tt9pvQWF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 09:40:05 -0400 (EDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 540BD4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 09:40:05 -0400 (EDT)
Received: by mail-wm1-f49.google.com with SMTP id
 d131-20020a1c1d890000b02902516717f562so6153444wmd.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Aug 2021 06:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fp2FsksUpuC70lwZPSSi0nDjJByoDoO4PpzbqKW0cT4=;
 b=icR9Int0QvvI0heodeFJD0pbyAXz7QjoptO/0cpBITayVgP+KEmgyE3q91jHhPzHVI
 lYJw8LFsckdwvdFPQMEtHdnm3Uf2LDM4NItv569axeYl+AjCA/t626QzX0lO2iplkG6N
 3OaHzooQYDQ9QfMyjYg3BI9lRYZHyNtcOvtmx9sOx+krNFV2uVxVblsGpTqYFwh7JPB+
 x3mc5O8XuPLPW3G8h8kPgmvmBwxG3WoV5/wuAYY+egCFkWssTPFoUnJX22FHO0pnWuVF
 2SX/pJ8mI73ryLUNvPXmnC/EpD57Fp42Ag08haakgb2+h9WcVcpSATaZtkupBV0rDt4X
 /W0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fp2FsksUpuC70lwZPSSi0nDjJByoDoO4PpzbqKW0cT4=;
 b=aWCc6wABwb7XLek+g0byEBpc5grfHhCSmewOLLn8SpPvKHLR8hNI5EviYXftX3jC7n
 GvYlTB3tzm0xCywupewHA9MKVW8Kv41jjufyzFmmTlViCizc6Aj92z8vsz8qbEteNDDo
 yMYm3bb6RDCHQi2nAeeWOHwDg9gkx70LOvE05olBRem0txOzxZgnJAaAR8q+IDDS6ylW
 3iqJkDhH/5jn7PZAb+3Ch2JCyqWmmZQX8luJiJXAP68YBRpkbZo2ehK1ttBW28t7zcEx
 5PhOxHItPDg8amD/rXoRhryxlGAwyN5kgSr2rjWaJRHT0tnRTv7CTD+HQAU4bfnBsb8h
 yoqA==
X-Gm-Message-State: AOAM533vxstpduBQ9pU7NtSexh9+TsZEc52tivvKVI6K+87dFhif88ED
 cpPkXgMWLtvh/l6tkQJoNZIArQ==
X-Google-Smtp-Source: ABdhPJwMgXpUIgZ3CNM/dKFQroYWHpilibQOGQpLE/mgmpvBuB7hT+mGvH4kRQZS3oJY1s8Xi9S9Zg==
X-Received: by 2002:a05:600c:ad6:: with SMTP id
 c22mr3502882wmr.114.1628257204149; 
 Fri, 06 Aug 2021 06:40:04 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:41d5:61f3:25d7:c384])
 by smtp.gmail.com with ESMTPSA id i14sm5642824wmq.40.2021.08.06.06.40.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 06 Aug 2021 06:40:03 -0700 (PDT)
Date: Fri, 6 Aug 2021 14:40:00 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: Convert the host S2 over to
 __load_guest_stage2()
Message-ID: <YQ07sPoa4ACizYrp@google.com>
References: <20210806113109.2475-1-will@kernel.org>
 <20210806113109.2475-5-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210806113109.2475-5-will@kernel.org>
Cc: linux-arch@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jade Alglave <jade.alglave@arm.com>
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

On Friday 06 Aug 2021 at 12:31:07 (+0100), Will Deacon wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The protected mode relies on a separate helper to load the
> S2 context. Move over to the __load_guest_stage2() helper
> instead.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jade Alglave <jade.alglave@arm.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h              | 11 +++--------
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  2 +-
>  3 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 05e089653a1a..934ef0deff9f 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -267,9 +267,10 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>   * Must be called from hyp code running at EL2 with an updated VTTBR
>   * and interrupts disabled.
>   */
> -static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu, unsigned long vtcr)
> +static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu,
> +						struct kvm_arch *arch)
>  {
> -	write_sysreg(vtcr, vtcr_el2);
> +	write_sysreg(arch->vtcr, vtcr_el2);
>  	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
>  
>  	/*
> @@ -280,12 +281,6 @@ static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu, unsigned long
>  	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>  }
>  
> -static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu,
> -						struct kvm_arch *arch)
> -{
> -	__load_stage2(mmu, arch->vtcr);
> -}
> -
>  static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>  {
>  	return container_of(mmu->arch, struct kvm, arch);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 9c227d87c36d..a910648bc71b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -29,7 +29,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
>  static __always_inline void __load_host_stage2(void)
>  {
>  	if (static_branch_likely(&kvm_protected_mode_initialized))
> -		__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
> +		__load_guest_stage2(&host_kvm.arch.mmu, &host_kvm.arch);
>  	else
>  		write_sysreg(0, vttbr_el2);
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d938ce95d3bd..d4e74ca7f876 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -126,7 +126,7 @@ int __pkvm_prot_finalize(void)
>  	kvm_flush_dcache_to_poc(params, sizeof(*params));
>  
>  	write_sysreg(params->hcr_el2, hcr_el2);
> -	__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
> +	__load_guest_stage2(&host_kvm.arch.mmu, &host_kvm.arch);

Nit: clearly we're not loading a guest stage-2 here, so maybe the
function should take a more generic name?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
