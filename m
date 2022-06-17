Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4C7C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 16:39:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0520D4B381;
	Fri, 17 Jun 2022 12:39:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BKsubglWOxgo; Fri, 17 Jun 2022 12:39:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BBC4B2B8;
	Fri, 17 Jun 2022 12:39:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E034B1CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 12:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A25JCBgtaoJa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 12:39:21 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41DBC4B1C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 12:39:21 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 h34-20020a17090a29a500b001eb01527d9eso3767925pjd.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 09:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wrdO5P+XurdaeOgOSQ+5kEyKwT7FiNPp233iypu4ges=;
 b=GLI0UsmAM2SwCj2zsTHa0oDcnMYgcUb1C8zvkJSBU2UTOlY+q5LsCvt8d+o0gH9deL
 EJxKuYIJsSURtNXkFUX2typL9jcEhnHUIRDb2fSyphm9SbBxXCf/MxljTwYKChU0WzD6
 /u1khMJU8yxHRUkSSrcsf2gPV+QsawCwxs6Z7CB1hM4QlTf2EFT/vN36oa28X48YXT+G
 dUjTHEpcxFF355xRlPkgRYJHYusbuSXE6SVvev0aFEMSpuRmMiYWYOgP6gRhRDvuQUkw
 f0gwMORKivzLEb67Z570CcSn5DcFYQGhm25keeGm2aqAsRUjtljk6RQGoKz0WIt/+DNi
 FCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wrdO5P+XurdaeOgOSQ+5kEyKwT7FiNPp233iypu4ges=;
 b=Qs2gStX+h6Ak/Qhpz0JZx9T2Ge4ZFRmdUMsh1h5j6jyG2BqXLZ/4DQizc2quRiq6GI
 6UlY3K8kPQ4jNjJRVkWbeMVn3VaujCLnc5+DW9X+CRq9OoCi5L2TmWTpVrtAeDeUrK8G
 ceWGCACm/ypgG6eM/bD9ceKnrnbWjM+AuZ1TegpOt79GJAnAkf8FW0TMQpgRoHjqIS72
 YCyBFGvwro2xL9jLmY2454Biu133hDDukDu0mYL/OTSNC/oETyUk/G90K5fytv6r753f
 1faxmiG5DC6Gn3PDvjxMmL60fdlO6wmamPMd2dSjOaqOmBIdXU4EQyI/gX+YepnUJ8/R
 5zAw==
X-Gm-Message-State: AJIora9ARThOLOyzF8FoWyyjzI6P+Gt1ydDAFCVkCBPl2YPyRzpKlbkH
 vXBdsGkOh6c1mhf5R124Jgd1gA==
X-Google-Smtp-Source: AGRyM1vVWqfyGPjBRUy89tBJu9kICwdn0HHYHxZToGtJz6hzC1Mdg/1dOrUNNuf4HFLCQTuqX0StEg==
X-Received: by 2002:a17:902:c407:b0:163:df01:bbbc with SMTP id
 k7-20020a170902c40700b00163df01bbbcmr10210387plk.4.1655483959855; 
 Fri, 17 Jun 2022 09:39:19 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 s10-20020a63af4a000000b003db7de758besm4134739pgo.5.2022.06.17.09.39.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 09:39:19 -0700 (PDT)
Date: Fri, 17 Jun 2022 16:39:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 15/22] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
Message-ID: <YqyuM3v0SNPyrOmP@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-16-dmatlack@google.com>
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
> @@ -1592,15 +1589,21 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>  	sp = sptep_to_sp(spte);
>  	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
>  	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
> -	rmap_count = pte_list_add(vcpu, spte, rmap_head);
> +	rmap_count = pte_list_add(cache, spte, rmap_head);
>  
>  	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
> -		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
> +		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));

Ewww, the existing code is awful.  This call passes NULL for @slot, but it already
has a slot!  This could simply be

		pte_list_destroy(vcpu->kvm, rmap_head);

but that's undesirable with the current name as it's not remotely obvious that
pte_list_destroy() actually zaps rmaps.

I'll send a separate series to clean this up, e.g. rename pte_list_destroy() to
make it clear that it zaps SPTEs.  That'll also give me a good excuse to kill the
"p is for pointer" rmapp() naming scheme.  The only conflict with your series is
this one vcpu->kvm => kvm change, which is easy to note and resolve.

>  		kvm_flush_remote_tlbs_with_address(
> -				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
> +				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
>  	}
>  }
>  
> +static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
> +		     u64 *spte, gfn_t gfn)
> +{
> +	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);

I prefer to grab "cache" locally,

	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_pte_list_desc_cache;

	__rmap_add(vcpu->kvm, cache, slot, spte, gfn);

both to keep the lines shorter in the final form (adding "access" runs yours out
to 93 chars), and because I find it easier to see read the call without a gigantic
parameter in the midde.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
