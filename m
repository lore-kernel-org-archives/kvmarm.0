Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C257F
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 02:10:19 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-668711086f4so125046b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 19:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688609419; x=1691201419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XP4DoYShnes9Cy59WziHKZBgrcvxKmEUSZdVCQbtmAo=;
        b=SiGwLZkXRQbaBMbrgXGl2qlB55MI4HtE6Zz0Ahf+azm3H9frsgD3CHxeH0FMY/Ahga
         k5/N/N58xOlRM2rRxrpaXh8GHc3W6erqhZba0QnxabUDJMcTstryJjjebQykhyI3gWpc
         O+mJL3hfBfsidLjX5IzwfmAunrS2YBQeDsmnA0MIUUP+Ij5N9XkXDMEBpe8KbdfxOZ2i
         pl5hyh/aDVkMSXaOdqrccRZZCT1iAGKzCsOrD0KKswMgxTTZI+leyZQtEK0YAILR0vEo
         5Hg8tisFTY0f89837ayC6nQ/woPvdZPnsVLp/ROpM3QzHhjVCx2mN+LnzV3Dq3mV92Ly
         mUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688609419; x=1691201419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XP4DoYShnes9Cy59WziHKZBgrcvxKmEUSZdVCQbtmAo=;
        b=eX9fnpxHhC/ViXQhOGpf01qsZKTql329q+j9cP61iDAo4xCtdAvu2r1wKBoxXGB73t
         bmq+1vbaQtt26dvmHChcARlnV1PgSit2GHrliv27TwNyYji8OULXG5gqmaz97Q3qckRs
         3HyBiVgzDeElQmP15YDe3c3AlSXhX9SdPjVdCksDLjuFGCd9V66oCFTAA086CVoK1Uy+
         zgyIHsNKAQb8N/hTcbt1wD4DGAHQ576OBzlXH69sDvVrGldCe8EWtTqBdgXjkZhCvGo4
         /FKHqtv3/yX7sibHQt99okHn14GrfRDSbnznHBxA2MfWMBPXMNyau+VhmLs6N0PJGerh
         9wqQ==
X-Gm-Message-State: ABy/qLbfSnDLKo+Y3/QHVG81VD8wHbwDO9iRqceNIL9Cipqocrq3ozKb
	d/anfSmLkUdFrgw3DbdXrvY=
X-Google-Smtp-Source: APBJJlFGIXMd21EZwNe+mHhmpVNVRsUEG4H560bcYgHix9NzfbeGSSSH0lTScJcFK2LuCN7La3jaWQ==
X-Received: by 2002:aa7:85d2:0:b0:666:6c01:2e9e with SMTP id z18-20020aa785d2000000b006666c012e9emr4693901pfn.15.1688609418703;
        Wed, 05 Jul 2023 19:10:18 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id 10-20020aa7924a000000b0066a31111cc5sm159784pfp.152.2023.07.05.19.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 19:10:18 -0700 (PDT)
Date: Wed, 5 Jul 2023 19:10:16 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230706021016.GC3894444@ls.amr.corp.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-6-stevensd@google.com>

On Tue, Jul 04, 2023 at 04:50:50PM +0900,
David Stevens <stevensd@chromium.org> wrote:

> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index cf2c6426a6fc..46c681dc45e6 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -138,7 +138,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       const struct kvm_memory_slot *slot,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
> -	       bool host_writable, u64 *new_spte)
> +	       bool host_writable, bool is_refcounted, u64 *new_spte)
>  {
>  	int level = sp->role.level;
>  	u64 spte = SPTE_MMU_PRESENT_MASK;
> @@ -188,6 +188,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  
>  	if (level > PG_LEVEL_4K)
>  		spte |= PT_PAGE_SIZE_MASK;
> +	else if (is_refcounted)
> +		spte |= SPTE_MMU_PAGE_REFCOUNTED;

Is REFCOUNTED for 4K page only?  What guarantees that large page doesn't have
FOLL_GET? or can we set the bit for large page?


>  
>  	if (shadow_memtype_mask)
>  		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
