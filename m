Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8DFC38145
	for <kvmarm@archiver.kernel.org>; Thu,  8 Sep 2022 08:34:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C904CD61;
	Thu,  8 Sep 2022 04:34:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5+Ohgn2qD-Cc; Thu,  8 Sep 2022 04:34:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3AE4CD0A;
	Thu,  8 Sep 2022 04:34:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 748664CB16
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 17:32:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sCRHgzBMpVDg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2022 17:32:37 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 593E54C97E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 17:32:37 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id y136so10946674pfb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2022 14:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=7na4QT6yvyqzijLFE24Wbx46oe0wPXj14j8P2u6pP1w=;
 b=UzP2VbnLuTjsou56LGJV0IVy5dUZ5ia4mREFcUwJvUKzdU8EDsewlGPEqnX1NiOp41
 0AEOCI8E6a9AH/bp0M9AkwM4K6pi18gbxaa9FQHA025LecN9vHkWk0yr6itCVz1d1Sip
 1hCbbLMb+pp9LQqwQoKnGLrTRuEJZNa1YXODMatGENOmG6TlEBYYj8PYxGXt6CEutDx+
 IV+B0IBRq8uMk2z0ZxrVuQ+GHrRdb+ZEWwt0rLSohMESgquu3gLQECLXi22E0+Z7e7gm
 nwGEqq/ifhlOgAjjcm4c9omWSxvG9GV/r3l3r275GllZjalkTy0cWgw6P9peAzfM5qZx
 LHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=7na4QT6yvyqzijLFE24Wbx46oe0wPXj14j8P2u6pP1w=;
 b=2Q68wHaq8akcIWlwDjGHXuV/oMg+GqucxYzranhQdp0Vckt6vmawyYv9ojVCCNfy83
 U5JbZQr6aVQNJVnl62yVSCa4R79kWbnSwfG+Juhgh7aCrIF1z2dQTW/E9ObvubpPQzCr
 Du/E74fV3bdZd3JZOTWNYs6wg6Adsozo4hn2s2Lx8FaPbghXiAvDFhsCLN1+wTySh4zP
 T9LnN12wTp27ZETgPa5EIdfK/fXZpidXIlmS4GitMWi3ls8kwOzt4ZP9tJXvOdgnPX2V
 37uWy7eb4JyG+XXqe6tj5ZwwveNK/+GAZf95PhfNGIODoTDPs6r2QIzRRCnnEe8+qqc4
 BoNQ==
X-Gm-Message-State: ACgBeo0WTGmK8UA3D7KhPg7WmBVcH0H8r+tWA+PKwXECyX5o1OXybjpI
 X0vanVxL2DMgGpah9DWrtxXpDA==
X-Google-Smtp-Source: AA6agR7Q4eHfCORqq/GdxHWoHptDop8lLgJyVx3iDY9vFGg98YhF6AsRZ4mhtYSuJiPSkfoyXtLNow==
X-Received: by 2002:a63:6c01:0:b0:429:ea6e:486d with SMTP id
 h1-20020a636c01000000b00429ea6e486dmr4993947pgc.247.1662586355791; 
 Wed, 07 Sep 2022 14:32:35 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 j3-20020a170902da8300b001752216ca51sm13034032plx.39.2022.09.07.14.32.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Sep 2022 14:32:34 -0700 (PDT)
Date: Wed, 7 Sep 2022 14:32:29 -0700
From: David Matlack <dmatlack@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 06/14] KVM: arm64: Return next table from map callbacks
Message-ID: <YxkN7XmHiU3ddknR@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-7-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-7-oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 08 Sep 2022 04:34:28 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Aug 30, 2022 at 07:41:24PM +0000, Oliver Upton wrote:
> The map walkers install new page tables during their traversal. Return
> the newly-installed table PTE from the map callbacks to point the walker
> at the new table w/o rereading the ptep.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 331f6e3b2c20..f911509e6512 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -202,13 +202,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
>  		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
>  					     KVM_PGTABLE_WALK_LEAF);
> -		pte = *ptep;
> -		table = kvm_pte_table(pte, level);
>  	}
>  
>  	if (ret)
>  		goto out;

Rather than passing a pointer to the local variable pte and requiring
all downstream code to update it (and deal with dereferencing to read
the old pte), wouldn't it be simpler to just re-read the PTE here? e.g.

        /*
         * Explicitly re-read the PTE since it may have been modified
         * during the TABLE_PRE or LEAF callback.
         */
        pte = kvm_pte_read(ptep);

This should also result in better behavior once parallelization is
introduced, because it will prevent the walker from traversing down and
doing a bunch of work on page tables that are in the process of being
freed by some other thread.

>  
> +	table = kvm_pte_table(pte, level);
>  	if (!table) {

nit: Technically there's no reason to set @table again. e.g. This could
just be:

        if (!kvm_pte_table(pte, level)) {

>  		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
>  		data->addr += kvm_granule_size(level);
> @@ -427,6 +426,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte
>  	new = kvm_init_table_pte(childp, mm_ops);
>  	mm_ops->get_page(ptep);
>  	smp_store_release(ptep, new);
> +	*old = new;
>  
>  	return 0;
>  }
> @@ -768,7 +768,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  }
>  
>  static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -				struct stage2_map_data *data);
> +				kvm_pte_t *old, struct stage2_map_data *data);
>  
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  				     kvm_pte_t *ptep, kvm_pte_t *old,
> @@ -791,7 +791,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  	 */
>  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
>  
> -	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> +	ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
>  
>  	mm_ops->put_page(ptep);
>  	mm_ops->free_removed_table(childp, level + 1, pgt);
> @@ -832,6 +832,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	new = kvm_init_table_pte(childp, mm_ops);
>  	mm_ops->get_page(ptep);
>  	smp_store_release(ptep, new);
> +	*old = new;
>  
>  	return 0;
>  }
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
