Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5584CCA47F
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 17:11:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5784B36F;
	Fri, 17 Jun 2022 13:11:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Iufw-OgHtgAr; Fri, 17 Jun 2022 13:11:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5535448F94;
	Fri, 17 Jun 2022 13:11:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA9A48F94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:11:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nv6ec2cq50a7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 13:11:32 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0677D40C0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:11:31 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id u18so4398237plb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 10:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bdDDbsy5CGOO7wZD0IM4Eh6cCyQ0ONF/h8Wgyy1Nd18=;
 b=QKAV7BGSNsPE9wA9Sqlq00olPyQu9PB6qK5tl1Rxnvu9fCuQ47fv7tZIRz9aybGRrv
 3UrV5mRaMilV9R4lDQuOmyt+MPr9yWyqZpS64RJ3BfkNuoC3cwCM2QwDj1IanZEjLIHz
 Fx/1KYX6+54ItOS2pBQcoF5+u1VFY7BL2bXTctivpXivDvWG3z4lR6r1ekopPf3Nj9GD
 JHgW/PpUbR50V8UtSyZ7a6wsZBHXawSsbaSERvSJc9ccG9WlaemjVf5pcnvjBndz49Cm
 dkSbH7nm5Mt86N20zqdhkw7OEFLOG9oMRPEcwR1uPz0/LHFlQj+EXTzTlNeOqnYalR45
 lR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bdDDbsy5CGOO7wZD0IM4Eh6cCyQ0ONF/h8Wgyy1Nd18=;
 b=r4mSlexTPYZC19DQUBWtdrNN2MPHLikeaofwmBm5fUkShNRFnN5MZ5ZPNbBLqtPa5Y
 TB2tunWUrmV5nD9HtDz8fkOHkOn44i4wQxAY32aSBUXD53+btRVWNOW3Bc5lJOl0ktA3
 hci6ptJ7RZNBzL+1Fw3L+0K4E5iUjIIjccX3bfwwaeaBgRiNT9Hm3BidsJaEI816+4Wv
 4+E9BJDnKcQeMYso/Pa/1bHv0MLy3bQhWcc2bQNneK56FIiJneppkn5XPN+YcKZ1ORik
 k6+ko/cahOzouztoeRRmiBq+lK7fatzqJyEn5F+VbDeoJ8ToQ926qizQuOXIBFXA7v2l
 cWTQ==
X-Gm-Message-State: AJIora95xJTu1tfUT5ZG1q7d4HqEcOeedpniZIh189iWQJb0jz64z6MR
 89Uf7OyUrte4SEBnfr97foNaKA==
X-Google-Smtp-Source: AGRyM1uXzqylJ7t0A4w2Rtgnm+iUT1OEcJxDjLWt6XST+qWVe58pzA+XrFJ2UZHi/ZCRvGo6mmHtTw==
X-Received: by 2002:a17:90b:4b90:b0:1e8:48bd:453 with SMTP id
 lr16-20020a17090b4b9000b001e848bd0453mr22483076pjb.86.1655485890790; 
 Fri, 17 Jun 2022 10:11:30 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 m2-20020a17090a858200b001ec7c8919f0sm1087504pjn.23.2022.06.17.10.11.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 10:11:30 -0700 (PDT)
Date: Fri, 17 Jun 2022 17:11:27 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 20/22] KVM: x86/mmu: Refactor drop_large_spte()
Message-ID: <Yqy1v59ZDJ7EkCix@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-21-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-21-dmatlack@google.com>
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
>  static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>  {
> -	if (__drop_large_spte(vcpu->kvm, sptep)) {
> -		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> -
> -		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> -			KVM_PAGES_PER_HPAGE(sp->role.level));
> -	}
> +	return __drop_large_spte(vcpu->kvm, sptep, true);

A "return" for a void function is unnecessary.  And since the shortlog is already
a somewhat vague "do a refactor", I vote to opportunistically:

  - rename drop_large_spte() to drop_spte_if_huge()
  - rename __drop_large_spte() to drop_huge_spte()
  - move "if (!is_large_pte(*sptep))" to drop_spte_if_huge() since the split path
    should never pass in a non-huge SPTE.

That last point will also clean up an oddity with with "flush" parameter; given
the command-like name of "flush", it's a bit weird that __drop_large_spte() doesn't
flush when the SPTE is large.


static void drop_huge_spte(struct kvm *kvm, u64 *sptep, bool flush)
{
	struct kvm_mmu_page *sp;

	sp = sptep_to_sp(sptep);
	WARN_ON(sp->role.level == PG_LEVEL_4K);

	drop_spte(kvm, sptep);

	if (flush)
		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
			KVM_PAGES_PER_HPAGE(sp->role.level));
}

static void drop_spte_if_huge(struct kvm_vcpu *vcpu, u64 *sptep)
{
	if (is_large_pte(*sptep))
		drop_huge_spte(vcpu->kvm, sptep, true);
}


>  }
>  
>  /*
> -- 
> 2.36.0.550.gb090851708-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
