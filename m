Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A097C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 23:47:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 948394B1E1;
	Thu,  5 May 2022 19:47:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aa91UnQ8239y; Thu,  5 May 2022 19:46:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 776D84B248;
	Thu,  5 May 2022 19:46:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0040D4B248
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 19:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4ZiQku65fAO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 19:46:57 -0400 (EDT)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E44DB4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 19:46:56 -0400 (EDT)
Received: by mail-pg1-f170.google.com with SMTP id g184so2303452pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 16:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UXlxQWVPF63McNIcQ+A040lcStWvWFpvQxHMkE9R0XY=;
 b=At67K2Y4KGg6aRuQ7SBWpf7VNQtpqf3Y1lbdewqOCGIOp9dBYcGBoaWLhYEoSIqxQP
 Zv8nH9HNjn04xhBHJnvRuaqDorPQBLGEleKUtbDW9+CVyCrzSCnQUe906MMzyfvI5cOp
 cphDe1trwuzxUWWfrEjR8RLktm6BDp7pMrINwNHC2Lj6C6poV2839PsPY7xjZoNuG/Xo
 RlEuXTtiokG2+cELXEYgNDgGHfnw+t1XqQH+Kdhv2oEegEx3lEbHa5XnPuPB4TtJuR43
 /0OP26/oUVQBq/o9zTyABDxGo+Zk5+FzKWWuXZM90ikc+sDNWr4R7RlS/ZzuShzLvU/m
 BtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UXlxQWVPF63McNIcQ+A040lcStWvWFpvQxHMkE9R0XY=;
 b=eb67Z9NKlbhqgKzxyXVRFpjaFzQzYLv8AG4vWDL8LAH7Oax64wtwxXlxG4P+m+0Rl7
 6Of4KF+o4SqcWjMfFO/Ic2h+0lbEPg5we4jxWjoPefuf9RSsQF8jFF3uabC5EjUNLM/e
 bWyv+PxUfsdOWPSGiWOTa7V7bWxfk3dEDr0el0h0nRo7BwTessPC14PtfWs/1Stkf1jI
 GXaq2gwO14r7pVF0AGs6j6WQ2QMJsNno/aZLfhEafVuRYpl5gFY+3aUAL/0O9XuZZgG8
 gJPteZS+1idcrRHIk9BcrBX4gLYgBdUAY6A3LNOId5ZJKrfDQHI0Y4bRCdaZqbQBRHhF
 NzrA==
X-Gm-Message-State: AOAM531GeunZSBRuzPk15kjhVJUOjv7emfmQSCePOm3lD4hCYoKR8b6r
 sSoV7cXf/F70ULo5qy4079fvIw==
X-Google-Smtp-Source: ABdhPJz58A4E/Uzn7xxWw89AW8b22CVIBbrmFsaLiw+m0NqSKF1b6yIOoFI8sXFMfGQhIvtZl+2WbA==
X-Received: by 2002:a63:88c3:0:b0:3ab:2edc:b95b with SMTP id
 l186-20020a6388c3000000b003ab2edcb95bmr473166pgd.233.1651794415699; 
 Thu, 05 May 2022 16:46:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 b10-20020a17090a550a00b001d954837197sm5814952pji.22.2022.05.05.16.46.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 16:46:55 -0700 (PDT)
Date: Thu, 5 May 2022 23:46:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 13/20] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
Message-ID: <YnRh6yyGQZ+U31U1@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-14-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-14-dmatlack@google.com>
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
> -static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> -			     struct kvm_mmu_page *sp)
> +static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
> +			       struct kvm_mmu_page *sp)
>  {
>  	u64 spte;
>  
> @@ -2297,12 +2300,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	mmu_spte_set(sptep, spte);
>  
> -	mmu_page_add_parent_pte(vcpu, sp, sptep);
> +	mmu_page_add_parent_pte(cache, sp, sptep);
>  
>  	if (sp->unsync_children || sp->unsync)
>  		mark_unsync(sptep);
>  }
>  
> +static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)

Nit, would prefer to wrap here, especially since __link_shadow_page() wraps.

> +{
> +	__link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
> +}
> +
>  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  				   unsigned direct_access)
>  {
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
