Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189DDC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 17:01:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7004B33A;
	Fri, 17 Jun 2022 13:01:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3VyRirZrN7s6; Fri, 17 Jun 2022 13:01:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B6F14B371;
	Fri, 17 Jun 2022 13:01:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8844B353
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:01:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JuUIyD2VkiPx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 13:01:35 -0400 (EDT)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BD3749ED1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:01:35 -0400 (EDT)
Received: by mail-pg1-f182.google.com with SMTP id g186so4547193pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SRO7S+VtYQQ7CuT0HxqPXVXaFoJKc9kcpBIC9Ny2GXE=;
 b=H/yPj2x7BlxCCt81iCpTE5EkFP3Dty/VK1bZV1z25KE/LjGyN7SXeTJT2hDinGXVsP
 yKnWD+bSnMg17PHjkfrn+c3NqZSIABspHotC46x9KpdL1XIujrP880h5/dYfIzpJqffP
 r/IGHr8StQdM9Pv4HgEjUqpIBy/hAmMbDAuwsEalh68jgIXoLI4hMSbBS9C8QKV77NWi
 1wOP8X1/Imj52YER3j06T7ncEH788Qvydm5p/zpwISDRL1jsOMw1jIGPJnqg/bFRCKJz
 J43GPBCSUETfo7/1PtSdE4Pi9GCX0J2+XuZVUwLzY3a44bo+0aQMg7lgiSVpVcOKhTf5
 hOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SRO7S+VtYQQ7CuT0HxqPXVXaFoJKc9kcpBIC9Ny2GXE=;
 b=lyqlwMDVsyNjGIZEypllheiDMWhhp6WJv4IDALHx+/o+4haAYcnFsnZMUdIJIUxcmW
 uSDGwPaFQlPaoGFzRFTm7UVLMrKoAVG3q6vRRfPbDdg7NOwKcIrmiaQUF1hxnuwDoDFk
 mXC8n5rw8Nzj02AbiFhxsBOIExZZyHWUpjibNDSwf3PmzsiSmU6HjcnsNSx0vztQdUdu
 DrBsX/S+f1CQC/s9pQX7uYsMzvn6U6x21uOy8Fhtu/u62iX/mDHe88lwyuGffhaVuEQB
 ePUPXOCS+bVM2i/8MFafpv4+TKBAUesRl9LWGkMvRTJMN4whofvDKWNjYtMHHAy80pon
 rdIg==
X-Gm-Message-State: AJIora/gnhM8+GC7MglzCbPXjCLgJb8inuLA9gE6hhy7SsjpYnz7mVpR
 2wU14X4JR9/rRH1im3FBg/cBrQ==
X-Google-Smtp-Source: AGRyM1sFPXEURTOwpo2fql5+Md+sSZz0Ko9Lq4pBbmT0ckr/KaLsXrnXfTdc/59+n072/62ew2vEbw==
X-Received: by 2002:a63:5a13:0:b0:3c6:3d28:87e5 with SMTP id
 o19-20020a635a13000000b003c63d2887e5mr10117659pgb.452.1655485294325; 
 Fri, 17 Jun 2022 10:01:34 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 a29-20020aa7971d000000b0051bc1865ca5sm4007529pfg.122.2022.06.17.10.01.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 10:01:33 -0700 (PDT)
Date: Fri, 17 Jun 2022 17:01:30 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 19/22] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
Message-ID: <Yqyzavjp9eS9p4+m@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-20-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-20-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
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

On Mon, May 16, 2022, David Matlack wrote:
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
> is fine for now since KVM never creates intermediate huge pages during
> dirty logging. In other words, KVM always replaces 1GiB pages directly
> with 4KiB pages, so there is no reason to look for collapsible 2MiB
> pages.
> 
> However, this will stop being true once the shadow MMU participates in
> eager page splitting. During eager page splitting, each 1GiB is first
> split into 2MiB pages and then those are split into 4KiB pages. The
> intermediate 2MiB pages may be left behind if an error condition causes
> eager page splitting to bail early.
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
> index f83de72feeac..a5d96d452f42 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6177,18 +6177,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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

No need to wrap, "true" fits easily on the previous line.  That said, I don't see
any point in adding a helper.  It's highly unlike there will be another caller,
and IMO it's not any more readable since I have to go look at another function
when reading kvm_mmu_zap_collapsible_sptes().

With some gentle massaging, the comment can squeeze onto two lines even with the
extra level of indentation.

		/*
	 	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1, there's no need to zap
		 * pages that are already mapped at the maximum hugepage level.
		 */
		if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
				      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true)
			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);

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
> 2.36.0.550.gb090851708-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
