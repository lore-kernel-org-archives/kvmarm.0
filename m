Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEE3C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:36:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3BD4B150;
	Mon,  9 May 2022 12:36:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m0Qrzn5MRD5K; Mon,  9 May 2022 12:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0834B2E4;
	Mon,  9 May 2022 12:36:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C95C4B2E2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:36:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mj0BricY+Bfc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:36:49 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E81214B150
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:36:48 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id e24so13640890pjt.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vcWBrXUV0qsOw9lQLNi+OhiEHQuaLCtwTh7HA5F6tIs=;
 b=GQuDadAMhf8b7Fy/I8JaGOgRQOsWHOMhy0hcMvriphuVIDCLpL0PdaLuMbF3n56Nke
 dZiKU5Jef5j11YpXBiBq70I2jRtKHo1vmB1cAh8/4Ff8ldw79/NB/gHKnpjQvMceq5+H
 3qgkrnh9KKmaw7DH9R9uQgmGpUN1bWPoVqDKK8soMOBL/CE7D+C0wzwPs6cO+5D2o7i9
 BUxS3PijLvpY1XWcQQ5OOyPIkC+UrL32CQw4fU5VdLpUvBKmussISGRTBF6qAwdnpemg
 ji09qdkVslMmiKaiQZghkH/uEpByZli/lutMtfurjdn+YHWI2FuLLfHnwrACscaUBN8e
 ydmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vcWBrXUV0qsOw9lQLNi+OhiEHQuaLCtwTh7HA5F6tIs=;
 b=O4o8lF+olBr7Y5M7/53yNh4NxbFLhjiOZYnKXFmoSM+tVAB0pAFRfxsB/oRYY+xQez
 IEfsZq07mj2mst7VU4HAkI2p8c5C9VcKWtQ6JNRJHWwVYvPna4Nx+lsv0P94aQ5Z9Hh0
 j0dUxqq4bhs9cAzZURHVYsu7q1czXZ2QK3dVS85MeC6xYeZ5+qtByrKtDJ7d0mkfgth6
 R2bkF+nGYQo+cBH+pr8C3oUBE0El9MvQLhQcBfWsQkwJjB5B5wF+VKpsU8n1s7nAd5c2
 IqA2a3dmUZiBX0I5Nnl5W9G3p15E7xVwTZrD26HARJZdaT6t393rdr0Z3IW/9enOf3jc
 Q76g==
X-Gm-Message-State: AOAM531Ae/DmBu7qzK0ybhSmJAu7nRGDT0MBQdPwmo3mLJ6bq/CguZCA
 faXPP8+bEfdiOTKpgvCzEebMWA==
X-Google-Smtp-Source: ABdhPJwEmR4hWs02XZuuAcqgDnjovgeoKc9HZE29HI/cH7wXAaf0/EHn99rc8bnyOXL0A+d9B+qwog==
X-Received: by 2002:a17:902:9044:b0:15d:1c51:5bef with SMTP id
 w4-20020a170902904400b0015d1c515befmr16764065plz.170.1652114207747; 
 Mon, 09 May 2022 09:36:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 x71-20020a63864a000000b003c15f7f2914sm8650496pgd.24.2022.05.09.09.36.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 09:36:47 -0700 (PDT)
Date: Mon, 9 May 2022 16:36:43 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 18/20] KVM: x86/mmu: Refactor drop_large_spte()
Message-ID: <YnlDG/aRMB7js2Lc@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-19-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-19-dmatlack@google.com>
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
> drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
> Its helper function, __drop_large_spte(), does the drop without the
> flush.
> 
> In preparation for eager page splitting, which will need to sometimes
> flush when dropping large SPTEs (and sometimes not), push the flushing
> logic down into __drop_large_spte() and add a bool parameter to control
> it.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 479c581e8a96..a5961c17eb36 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1183,28 +1183,29 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  		rmap_remove(kvm, sptep);
>  }
>  
> -
> -static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
> +static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
>  {
> -	if (is_large_pte(*sptep)) {
> -		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
> -		drop_spte(kvm, sptep);
> -		return true;
> -	}
> +	struct kvm_mmu_page *sp;
>  
> -	return false;
> -}
> +	if (!is_large_pte(*sptep))
> +		return;
>  
> -static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> -{
> -	if (__drop_large_spte(vcpu->kvm, sptep)) {
> -		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +	sp = sptep_to_sp(sptep);
> +	WARN_ON(sp->role.level == PG_LEVEL_4K);
>  
> -		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> +	drop_spte(kvm, sptep);
> +
> +	if (flush) {

Unnecessary curly braces.

> +		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
>  			KVM_PAGES_PER_HPAGE(sp->role.level));
>  	}
>  }
>  
> +static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> +{
> +	return __drop_large_spte(vcpu->kvm, sptep, true);
> +}
> +
>  /*
>   * Write-protect on the specified @sptep, @pt_protect indicates whether
>   * spte write-protection is caused by protecting shadow page table.
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
