Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEBB7F
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 01:54:53 +0000 (UTC)
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-55e04a83465so102637eaf.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 18:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688608492; x=1691200492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1R7giHFFm9lzKa2KFRVnvuXui30YgtW+mLiZpS636v4=;
        b=DVvGohzInocB2G0CE5BHhj00dNWqGoqrHPqrt2G17lPCsMUYKKsSVbf/v2qs4vd+BH
         TVAuRlrgj7qFdyc7ySUeR1ptkT6VqY8g0PcTuoGbfj+zpJtxWVA3ExnG9inRg72NB8ya
         97PvzrwpvZTE/IpWdnMQdtsBQKUgGylnqxFb0d+ku33oYPoxzLJqPitoAXs7P6qyNyOu
         WBvlYk74ZsB1GmBvxmmGoVL2B7UDS4BtOjPnsr9uMZp+cLqX2sFGbdLdIRNR0a2Ixofc
         kvxyXlICSAK6MZrMjNfH4kDVoONsBeKJXmSqNW6LuF2yi5fD78o/J6TRC+FmmtIvuU18
         uIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688608492; x=1691200492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1R7giHFFm9lzKa2KFRVnvuXui30YgtW+mLiZpS636v4=;
        b=i2BOIGX+hwIClaqJ2lAYg7EPIcXY7dUSO0Xmhz1iUk35tw1upRRi3yv6Na1mzLBY29
         Vqdp6rBjY+5M63hr2i+CIELgxitr62V6UOuTzmWPJL8RO/ydVacY3pxdhz5BbtaJSo+J
         pvUfjf/+jymrP3GcZT+wJdvlt2qF1DbBAZgLSsAOy7TmVXvtTogMnt8Z22h9ClfpxRdL
         TVDuidfVNFSopHVH7lm3sq0yuirfYni8U/b3Gxc/9qKemweBMH2cHtaobVz3n+DRKStW
         x3kyGhRrrCsNacbynukJw5t2Ud1t8Yda7Y237umgxckdCNxY75RPO3ie93l99zs/em9b
         Opqg==
X-Gm-Message-State: ABy/qLawLPFXwBsUwA8AaPRmWntnfMbmXtzz9FM0KmxBgbKRBJ1sWaCQ
	OOsKVe+z9FOMG68lIPUvUt8=
X-Google-Smtp-Source: APBJJlG1rcUiA7G6cfKIni/3YPqB6pOv+DveqzIRXSNVbOaD89TbpWJy4qWw7jhrSgFyIxdPitrcKA==
X-Received: by 2002:a05:6358:98a2:b0:134:c530:c2fa with SMTP id q34-20020a05635898a200b00134c530c2famr436044rwa.30.1688608491138;
        Wed, 05 Jul 2023 18:54:51 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090301d000b001a5fccab02dsm122674plh.177.2023.07.05.18.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 18:54:50 -0700 (PDT)
Date: Wed, 5 Jul 2023 18:54:49 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
Message-ID: <20230706015449.GB3894444@ls.amr.corp.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-5-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-5-stevensd@google.com>

On Tue, Jul 04, 2023 at 04:50:49PM +0900,
David Stevens <stevensd@chromium.org> wrote:

> From: David Stevens <stevensd@chromium.org>
> 
> Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..e44ab512c3a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> -	bool async;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = fault->gfn,
> +		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> +		.allow_write_mapping = true,
> +	};
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> -	if (!async)
> -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> +	foll.flags |= FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))

We have pfn in struct kvm_follow_pfn as output. Can we make __kvm_follow_pfn()
return int instead of kvm_pfn_t?  KVM_PFN_* seems widely used, though.


> +		goto success;
> +
> +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> +		return RET_PF_CONTINUE;
>  
>  	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>  		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
> @@ -4348,9 +4355,17 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * to wait for IO.  Note, gup always bails if it is unable to quickly
>  	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
>  	 */
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	foll.flags |= FOLL_INTERRUPTIBLE;
> +	foll.flags &= ~FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
> +
> +	return RET_PF_CONTINUE;
> +success:
> +	fault->hva = foll.hva;
> +	fault->map_writable = foll.writable;
>  	return RET_PF_CONTINUE;
>  }
>  
> -- 
> 2.41.0.255.g8b1d071c50-goog
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
