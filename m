Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAE0C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 22:15:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C64349EB1;
	Thu,  5 May 2022 18:15:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vE+tEFs05SmY; Thu,  5 May 2022 18:15:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DC974B190;
	Thu,  5 May 2022 18:15:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F13EA49E49
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 18:15:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PGmD41i0koAX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 18:15:06 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC38F49E44
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 18:15:06 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id
 z5-20020a17090a468500b001d2bc2743c4so5323597pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 15:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rhmYFBuuuGy1RxOFm4pAb+0D/79gx/RMlr5Dc55L7tE=;
 b=Hevs7iSy4zrNQh8iUyApFus8Hf9y6uwirVrl404PJBhu4YCBeMs/nvv/PiBjRl+b9i
 goS/roI0Sv6/OsNtAcxoeKDrrvT4LL4FxzU1MF23u9/kotSU7iUbeJiTEl0dKhoec8HI
 1g1ivpEqMwBvd+hGNePXFx1rDNZF7KcydiJOp+m2RS7cIFUDaycqErgr2PVPG0U7fSOq
 skKBUtXQrXg71hEIZsbWE+vb7R0oG9f9JAsO7Z/Ov/52rUXtfu3vbd3dtaquznZRy3aW
 rlOJ3uaUYC5GnvEOnDiOi70MiKyrjhRYDxUdUJG6fAoZ/btOiY9IbYZK0vT+0sp5ol/T
 UEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rhmYFBuuuGy1RxOFm4pAb+0D/79gx/RMlr5Dc55L7tE=;
 b=Kw0a75RO/eFFclSyul+LT1RNrKpEUs8LefNyfsqFDnCs3LzWRAo9cJwbjuymYcIFRJ
 pGBD21uvZTF2/1dLPr4lcUFmX5xvyGV3nGghD50n5DPyEsNSSB0hplTBut3Q3R+o0d0E
 3oe3b4LLtE1NZmWLPfW593UK8YUmpPHRirqYBgGKunLvmWl2IoBa98xMhGdQcq8FtR4E
 ptmifsE/gtEl1YJ7uJ9BauubxkfuPq6s/Hu+K0vds1iIygnvVosXZZFouBalM+RbcxgS
 0W5kpN0OE8RLEyaytivtxA2hVd4CGne5DtUFh2L0MM+AxFtWLdDtZ4JEFir6VOLRF1bj
 E/2A==
X-Gm-Message-State: AOAM531KEoL00NzbiJo3ZxgDFthG+QP6Lo319kQjuSpfZ+QqixrfHwzY
 cf9nMrEJG8kW31BgeLV6//lbgA==
X-Google-Smtp-Source: ABdhPJzsuSElxGPQgHtlbw0iGopvkRi5CXOoenk4IleklHGbnOGmfb8DaUwsp1YoXq+iTVmqk8ldWg==
X-Received: by 2002:a17:902:9005:b0:158:e46e:688c with SMTP id
 a5-20020a170902900500b00158e46e688cmr222968plp.173.1651788905567; 
 Thu, 05 May 2022 15:15:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 n23-20020a17090a929700b001d7f3bb11d7sm5793137pjo.53.2022.05.05.15.15.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 15:15:05 -0700 (PDT)
Date: Thu, 5 May 2022 22:15:01 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 06/20] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
Message-ID: <YnRMZZi6vskW9p60@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-7-dmatlack@google.com>
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
> Rename 2 functions:
> 
>   kvm_mmu_get_page() -> kvm_mmu_get_shadow_page()
>   kvm_mmu_free_page() -> kvm_mmu_free_shadow_page()
> 
> This change makes it clear that these functions deal with shadow pages
> rather than struct pages. It also aligns these functions with the naming
> scheme for kvm_mmu_find_shadow_page() and kvm_mmu_alloc_shadow_page().
> 
> Prefer "shadow_page" over the shorter "sp" since these are core
> functions and the line lengths aren't terrible.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
