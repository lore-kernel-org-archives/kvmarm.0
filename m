Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22A4C432BE
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 14:25:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38B5C611C3
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 14:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38B5C611C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A56BD4B0E8;
	Fri,  6 Aug 2021 10:25:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V8C--sAzobkl; Fri,  6 Aug 2021 10:25:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE884B0EA;
	Fri,  6 Aug 2021 10:25:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5717A4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 10:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWfe9x7dJQTp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 10:25:01 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 328774B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 10:25:01 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id
 l11-20020a7bcf0b0000b0290253545c2997so6257192wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Aug 2021 07:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cSeT0W6nMXWssnlqJp8Z8IJyv8VXh5EkL7xMtCUxbZo=;
 b=rTvOTFZrYKap4OeFRQmOdby67/SMy4EclOGQvSbCVcKowzIGH+vfZ58I4oJ+094wjK
 Tndqrd+HE4X1GfXNTJv9G6Mrl9EQF0henRAcC3PYey2ZE3I2oJ6DW0DoFDVUD41e3+uU
 e63/xjTQhUEdJS5AnNzq94Ttve77A0+7RmfWuMJ5dkpw69gSZmjuQsGRKw4fvV6wzKGn
 J8UPk89tMiYU+kc6yrvMvI4Ni6Eu+EhbzuOAOcHndPYxTGB3zyK2NMq6M7bjzrLS0InO
 Qf+47FFxQOzkojBCPILMWjazUkqz0P2HErji3eoiohr4Bl/0o/7Z+O31xQifteOokVc8
 LWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cSeT0W6nMXWssnlqJp8Z8IJyv8VXh5EkL7xMtCUxbZo=;
 b=WKhELwIhWI01+j63LIHbQJjHP5NuCJzq+J4jtvn6EzA4lru/RN+eQblV0K5l3AGYRY
 5QXMYCSfEuT965RIIO6FrdDPnvrFtqCT9uTL85pmtv5qSndD4/7uBBjGJRkUa0yfn6kK
 yavdpC+cyAnHTpyIz3Xziwt/3ERqCxSh/fRFso0bR81Lp3uPwPZhI0EID+WF+7NyhHVT
 JT2A7LW9E5HmreNFE0TGJ/HuxcxuBC7RDOxGOYJxsbkAMzHqp+4FmPRr7j1wOBTdIDv5
 AmEhwXu0UTkSK4ZFDKIl631mLuziPeXglZAfGR3ZlZw+TbpiMe5SLEB+SLQ5bJeyp8Sg
 PLgw==
X-Gm-Message-State: AOAM532wEzrk3etm79M9IjVQ0zxa9hGX+1pWfwhYA06K1MxWny7lJab2
 8MMzEPdd+SjIRBRtLF2sWimVQg==
X-Google-Smtp-Source: ABdhPJy7p/Et1Nr62zf/Pd2hl1nK7Slpb+mjAFunudSgaOucOCVT1s4BHvF8R31IyxeA9a2VeRqjcg==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr3538410wmc.95.1628259900037;
 Fri, 06 Aug 2021 07:25:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:41d5:61f3:25d7:c384])
 by smtp.gmail.com with ESMTPSA id m9sm9460025wrz.75.2021.08.06.07.24.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 06 Aug 2021 07:24:59 -0700 (PDT)
Date: Fri, 6 Aug 2021 15:24:56 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 4/4] KVM: arm64: Upgrade VMID accesses to {READ,WRITE}_ONCE
Message-ID: <YQ1GOAqlG9+25XS4@google.com>
References: <20210806113109.2475-1-will@kernel.org>
 <20210806113109.2475-6-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210806113109.2475-6-will@kernel.org>
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

On Friday 06 Aug 2021 at 12:31:08 (+0100), Will Deacon wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Since TLB invalidation can run in parallel with VMID allocation,
> we need to be careful and avoid any sort of load/store tearing.
> Use {READ,WRITE}_ONCE consistently to avoid any surprise.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jade Alglave <jade.alglave@arm.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h      | 7 ++++++-
>  arch/arm64/kvm/arm.c                  | 2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++--
>  arch/arm64/kvm/mmu.c                  | 2 +-
>  4 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 934ef0deff9f..5828dd8fa738 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -252,6 +252,11 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
>  
>  #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
>  
> +/*
> + * When this is (directly or indirectly) used on the TLB invalidation
> + * path, we rely on a previously issued DSB so that page table updates
> + * and VMID reads are correctly ordered.
> + */
>  static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>  {
>  	struct kvm_vmid *vmid = &mmu->vmid;
> @@ -259,7 +264,7 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>  	u64 cnp = system_supports_cnp() ? VTTBR_CNP_BIT : 0;
>  
>  	baddr = mmu->pgd_phys;
> -	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
> +	vmid_field = (u64)READ_ONCE(vmid->vmid) << VTTBR_VMID_SHIFT;
>  	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
>  }
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..658f76067f46 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -571,7 +571,7 @@ static void update_vmid(struct kvm_vmid *vmid)
>  		kvm_call_hyp(__kvm_flush_vm_context);
>  	}
>  
> -	vmid->vmid = kvm_next_vmid;
> +	WRITE_ONCE(vmid->vmid, kvm_next_vmid);
>  	kvm_next_vmid++;
>  	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d4e74ca7f876..55ae97a144b8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -109,8 +109,8 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
>  	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
>  	mmu->arch = &host_kvm.arch;
>  	mmu->pgt = &host_kvm.pgt;
> -	mmu->vmid.vmid_gen = 0;
> -	mmu->vmid.vmid = 0;
> +	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
> +	WRITE_ONCE(mmu->vmid.vmid, 0);

I'm guessing it should be safe to omit those? But they certainly don't
harm and can serve as documentation anyway, so:

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin

>  
>  	return 0;
>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..b1a6eaec28ff 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -485,7 +485,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>  	mmu->arch = &kvm->arch;
>  	mmu->pgt = pgt;
>  	mmu->pgd_phys = __pa(pgt->pgd);
> -	mmu->vmid.vmid_gen = 0;
> +	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
>  	return 0;
>  
>  out_destroy_pgtable:
> -- 
> 2.32.0.605.g8dce9f2422-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
