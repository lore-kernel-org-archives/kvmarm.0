Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F330C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 21:59:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DEEB49EEB;
	Thu,  5 May 2022 17:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2784diLZT10U; Thu,  5 May 2022 17:58:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E1D44B234;
	Thu,  5 May 2022 17:58:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EC94B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 17:58:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OKSfCOPn3lqG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 17:58:57 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52D1949EEB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 17:58:57 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id
 a15-20020a17090ad80f00b001dc2e23ad84so9148034pjv.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 14:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eAKJ/icQ2pJarmVikk6ugi8Bvpa8Rc3R9Y/ObEeqjH8=;
 b=M3ZzJgDT9ekyNJ96FH0MMSzeB14ns1BDlk016eZT1S0ep/cD4p1f1RTvih2cYmfuI6
 vFHrqU+9vIndYuNNK3AH4Dgm7kuFxZWZJkhyzMR4YOGjxZkYm1Z0EMXaLClIa8P7IVwL
 QtyC+BFeYTLUFomnyGMTCsLedrWhZCqZ/iU5JEbvABbUYTbxAczSe3AxtOSaTXAdovrL
 gXSYBjiw/rhbl7qw1z1JlCdnFZNzo1cOnflppFA0mTKn0HVdVUWqg4ori73GbSGNuRUY
 Q0QxlbRs+rt1HWOWCDy8/jExhZUX/p+D3mWU5Dz1V6JSaLpCcsd9QEMbSyHxxECeDk4v
 uA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eAKJ/icQ2pJarmVikk6ugi8Bvpa8Rc3R9Y/ObEeqjH8=;
 b=HPgQGuG4pVrJDRVc/IR6td8uqofPAQ1oft0CPenLQazEoCHzW415jQnvfvfw2weYFG
 VH8WaiitHCM+/Kyg8yNeNJFk5Tp04Ympv1wwKnHz8LiEJoPM0WRKaTQ5g30/iZngNUJQ
 rXB3HVQvqD3wYxgNDwZW7noQVY3nbGlvy3sP7iyfwglGfXQ5ctEFFomHydndk8RPdHF3
 rwcO4WmKQeQWX3EpI7wHiCSx3qnmNiTR0Mj4ischQxFQLSyRBAkCoA+OkOW8bEnmt//T
 2uK02/6oYv7CoB/FkspRC6k5cyPgh1jaJWAIEkzJHVFwK91l4fgiLHGG932YjS0Go878
 S0ZA==
X-Gm-Message-State: AOAM530oqPrtWFoBz8ZsSl5A8vtpVCny5MWg/HVhkv4uwRse1Pag0Kww
 fYZwwl3Rawed2jz+bIZPs27Vvw==
X-Google-Smtp-Source: ABdhPJy4viwkpqIW9TUUZ8Fu3CuE6qIgT5lnM973mXUD1A/F1HkwRsjvVk5v2hTKHhjIcHpWlHRYYQ==
X-Received: by 2002:a17:902:cf05:b0:156:8445:ce0f with SMTP id
 i5-20020a170902cf0500b001568445ce0fmr178549plg.99.1651787936011; 
 Thu, 05 May 2022 14:58:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 a3-20020a170902900300b0015e8d4eb1e7sm128177plp.49.2022.05.05.14.58.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 14:58:55 -0700 (PDT)
Date: Thu, 5 May 2022 21:58:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 04/20] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
Message-ID: <YnRInPVAd7BEBpk6@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-5-dmatlack@google.com>
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
> Decompose kvm_mmu_get_page() into separate helper functions to increase
> readability and prepare for allocating shadow pages without a vcpu
> pointer.
> 
> Specifically, pull the guts of kvm_mmu_get_page() into 2 helper
> functions:
> 
> kvm_mmu_find_shadow_page() -
>   Walks the page hash checking for any existing mmu pages that match the
>   given gfn and role.
> 
> kvm_mmu_alloc_shadow_page()
>   Allocates and initializes an entirely new kvm_mmu_page. This currently
>   requries a vcpu pointer for allocation and looking up the memslot but
>   that will be removed in a future commit.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Nice!

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
