Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948AFC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:31:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9B44B27E;
	Mon,  9 May 2022 12:31:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NVaTURILVM-b; Mon,  9 May 2022 12:31:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA6B4B2B3;
	Mon,  9 May 2022 12:31:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4659D4B2C5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:31:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0k4HHRBPnZKY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:31:52 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15B6C4B2B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:31:52 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id fv2so13623042pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5m6MbZqTR/K0ls/JbmsnhfS4t8Ut8ls1IozELXnIajI=;
 b=s13iOT82pVhN2fLD51n/NkSFDJD8cuLjhPlrxBexcLZ+iCv7bxql+RQW5WZNA6fFA4
 z5l+nLKe3RnRjm9mBUN+Nff6o7y8D4q/xHGhe2K9N4IqAqRDugEr/Md2q9u3/c5F/JeM
 WrKAlaJvdQA05qhUztwbpvAVjRR+Klf10Dx7bfv4TjyzmvrwjiDZ7xthVIuwaa3gbA1g
 H+JuabtImAJ4cKsXDDOmsdE/LAdlpMI8Yb6Dy91JJ0dh+3ELSh7wwaaHAoS+aTacs9DY
 zdriLZJSyn2UsZueEqG5RS1L3NnSWos5SqYxdNX5gf2T6ZYpeD3PGG4H1BBc0gN5wHud
 HzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5m6MbZqTR/K0ls/JbmsnhfS4t8Ut8ls1IozELXnIajI=;
 b=etSq+/BCmTPIT5B0KrwHxSecE491MWE/jg3vvfKPyIgh3Nt7x2UwhzRDUhPI+ub/T8
 d0JJJgkz661yi8Ntu323Fhrkk57X/8JAeMpzEf5sV2v2ysECqg5JdOcWAz1UlUsVH2As
 qV4s31cvc00GpVSzYFeWKsRINyAVXRz/9134lcxj+tGRgIXVNV6q5QAYXQJkNvPa0mgM
 OaWYJLVC4hphzOBrQTXdY9ei7H58ghxomF1dA1MKiDnxY2bIPEYo7LtT01C69NJn/seH
 B81QUHQEVY5LqF9ror/GLBEH8Bb2+byY/fUJv+3NrV18U1H4BC/NXU9tIGGi9f5FArV6
 p59A==
X-Gm-Message-State: AOAM532kuRzz8sPB/aeDIsHH08u7hcRycMot9oKM53zTVzUlrtlynZYV
 BYAL0fGVYWXdtuwHYH5t1wWzaw==
X-Google-Smtp-Source: ABdhPJzGs1IwQJk/45XzTRSExCEERaP5PYcy1LzTQKkXOwouwsurcXkKRerTln5UGHN/bEbuxUUpMw==
X-Received: by 2002:a17:902:cf05:b0:156:8445:ce0f with SMTP id
 i5-20020a170902cf0500b001568445ce0fmr16888729plg.99.1652113910711; 
 Mon, 09 May 2022 09:31:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 u21-20020a17090abb1500b001d95cdb62d4sm12797700pjr.33.2022.05.09.09.31.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 09:31:50 -0700 (PDT)
Date: Mon, 9 May 2022 16:31:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 17/20] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
Message-ID: <YnlB8n8UMCuaCj1G@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-18-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-18-dmatlack@google.com>
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

Maybe a slight tweak to the shortlog?  "Zap collapsible SPTEs at all levels in
the shadow MMU" left me wondering "when is KVM zapping at all levels?"

  KVM: x86/mmu: Zap all possible levels in shadow MMU when collapsing SPTEs

On Fri, Apr 22, 2022, David Matlack wrote:
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> in the rmap). This is fine for now KVM never creates intermediate huge
> pages during dirty logging, i.e. a 1GiB page is never partially split to
> a 2MiB page.

"partially" is really confusing.  I think what you mean is that KVM can split a
1gb to a 2mb page, and not split all the way down to 4kb.  But "partially" makes
it sound like KVM ends up with a huge SPTE that is half split or something.  I
think you can just avoid that altogether and be more explicit:

  i.e. a 1GiB pager is never split to just 2MiB, dirty logging always splits
  down to 4KiB pages.

> However, this will stop being true once the shadow MMU participates in
> eager page splitting, which can in fact leave behind partially split

"partially" again.  Maybe

  which can in fact leave behind 2MiB pages after splitting 1GiB huge pages.

> huge pages. In preparation for that change, change the shadow MMU to
> iterate over all necessary levels when zapping collapsible SPTEs.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ed65899d15a2..479c581e8a96 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6098,18 +6098,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	return need_tlb_flush;
>  }
>  
> +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> +					   const struct kvm_memory_slot *slot)
> +{
> +	/*
> +	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> +	 * pages that are already mapped at the maximum possible level.
> +	 */
> +	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> +			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> +			      true))
> +		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +}
> +
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  				   const struct kvm_memory_slot *slot)
>  {
>  	if (kvm_memslots_have_rmaps(kvm)) {
>  		write_lock(&kvm->mmu_lock);
> -		/*
> -		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
> -		 * logging at a 4k granularity and never creates collapsible
> -		 * 2m SPTEs during dirty logging.
> -		 */
> -		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> -			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +		kvm_rmap_zap_collapsible_sptes(kvm, slot);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
