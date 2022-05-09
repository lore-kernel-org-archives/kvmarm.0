Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F329BC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:10:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A6E49E44;
	Mon,  9 May 2022 12:10:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OTZOZOEKs-U9; Mon,  9 May 2022 12:10:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 680DF4B27F;
	Mon,  9 May 2022 12:10:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CF149E44
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:10:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v9XND4JqbnS4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:10:16 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94EA940BDF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:10:16 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id n8so14316202plh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cu/jiZxH6OGpEZOL+PQieADiAgi9jfOz/B++XfNJktg=;
 b=mhnslXdEZD4iLSuPRVVDxjSn6+FvXzI4Bcai5sRw8fKKc3MLOz0UYsczXlk1PHsKbC
 THfEA22X/nb+xS6QBIvswdYFZeqHqn+dEjYGdEmxr7d4It/gdFXtvmWw8IZatYmd9ueh
 XnrwFPDDqz0UzPc8YVMEq1gDwmmx9mQyJC4o6U45EhhxSrPodB/cz0hPWmwd4Ltd+Zma
 9hkQZ+42gt2tPedeVqnrBRXKhHSDcGbPfs4XEdFvlZsKUhBKr6Dqb1dOGMlryalSjaQA
 +PJmeJyD7rJpRm6so4lClPmND19dMoeaqEnPBys3Jd2/NsX29i9JNwJPQiF4BGOsu8Tq
 3JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cu/jiZxH6OGpEZOL+PQieADiAgi9jfOz/B++XfNJktg=;
 b=NM5nh7PC2DEy1t7nrK09coenc0STaYpbv92hKpcZLmprFEmIwxQWn95ynt3HZZfCOR
 oevILIASXt7Lx5RrwoLEsfoYOHbDV7ZFlgwzDfgm06JLfT76or+e89cNVyFPcEDviR7x
 nrVRLQAWTpuxY1uMHIHlISJwNjN+F083aIDdsM9JP1s7aUBtlff+qX60nDF50udS+h5m
 zA3fPk6NwwVBZkk34PLb5/GK6eMcYyLEp3mvpkv28MnckbLQKmn37FSMAe107a8V56B1
 HJtQ6RKacZVTntDQnC06faOB1eR16haBuWvKSuNtdsfzjEX2KsUMUbqYrttTB3QpPEG6
 4m+A==
X-Gm-Message-State: AOAM530F2yVbi3aynfrlXGZu1mm4wXS55kZz0qT/WJ28/0j3Ms4jmG7B
 FmbRux9qUQHDXkOrWkbny46tMw==
X-Google-Smtp-Source: ABdhPJw25Pjuh0E3wte+D0++UVsLqfNoyFyxpKkkTJFLfZkGy695uMwCI3FkNxQhcC97eHo59R4/Og==
X-Received: by 2002:a17:90b:4c88:b0:1dc:60c2:25b2 with SMTP id
 my8-20020a17090b4c8800b001dc60c225b2mr27045719pjb.133.1652112615226; 
 Mon, 09 May 2022 09:10:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 b29-20020aa7951d000000b0050dc762819asm8852722pfp.116.2022.05.09.09.10.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 09:10:14 -0700 (PDT)
Date: Mon, 9 May 2022 16:10:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 15/20] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <Ynk84xydEn4/3xkT@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-16-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> @@ -2820,7 +2861,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  
>  	if (!was_rmapped) {
>  		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> -		rmap_add(vcpu, slot, sptep, gfn);
> +		rmap_add(vcpu, slot, sptep, gfn, pte_access);
> +	} else {
> +		/* Already rmapped but the pte_access bits may have changed. */
> +		kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
>  	}
>  
>  	return ret;

...

> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index a8a755e1561d..97bf53b29b88 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -978,7 +978,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  }
>  
>  /*
> - * Using the cached information from sp->gfns is safe because:
> + * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
> + * and kvm_mmu_page_get_access()) is safe because:
>   * - The spte has a reference to the struct page, so the pfn for a given gfn
>   *   can't change unless all sptes pointing to it are nuked first.
>   *
> @@ -1052,12 +1053,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
>  			continue;
>  
> -		if (gfn != sp->gfns[i]) {
> +		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
>  			drop_spte(vcpu->kvm, &sp->spt[i]);
>  			flush = true;
>  			continue;
>  		}
>  
> +		if (pte_access != kvm_mmu_page_get_access(sp, i))

I think it makes sense to do this unconditionally, same as mmu_set_spte().  Or
make the mmu_set_spte() case conditional.  I don't have a strong preference either
way, but the two callers should be consistent with each other.

> +			kvm_mmu_page_set_access(sp, i, pte_access);
> +
>  		sptep = &sp->spt[i];
>  		spte = *sptep;
>  		host_writable = spte & shadow_host_writable_mask;
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
