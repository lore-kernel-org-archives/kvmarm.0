Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A202C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 10:37:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 100E5411C7;
	Tue, 15 Mar 2022 06:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zde8gF7KWQuq; Tue, 15 Mar 2022 06:37:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD45849DF6;
	Tue, 15 Mar 2022 06:37:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39610411C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:37:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKDBSnO520a8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 06:37:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C559A40C0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:37:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647340670;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/KyXBi502NBWJY1eIzGz6vA6KexTdmJyjzypUpAHTNE=;
 b=AYiLbc4VoDFKUfLmUoGH3A0KVDa+0BrjTL9nrCubyQt6x+0w0nLtYFv/EDZhSeWQbu9HK3
 neuxei+yAuI7YaHSGy5W59XkxINXAau2lipiQ/cOsTO/EfLPSOKQyU7K9PUjjuvSl43S41
 cAu5uQcL1zO8MJoq2rSlMKfKwB1GvFk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-WY7bPw0-NWageIUQnRSm8w-1; Tue, 15 Mar 2022 06:37:49 -0400
X-MC-Unique: WY7bPw0-NWageIUQnRSm8w-1
Received: by mail-pj1-f71.google.com with SMTP id
 g19-20020a17090a579300b001b9d80f3714so1757893pji.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/KyXBi502NBWJY1eIzGz6vA6KexTdmJyjzypUpAHTNE=;
 b=ARfPL4hTJicwMNCu/KeilMAJHKMBUnNQ3nIkd+J9pilsFnsdqktW4e0nbPYTWxQcuW
 nFmYpK2wIHtFgfGe+bDfFyUBs8GnwLjm71TdeQbTC8hQnTLM/Ipu+LasPY8091VeF2Sv
 +ZaKrjh9R0gTx2HqiJw7I2j8bfwKpbvBNsxw7yz/L/aaAy1A8+HZb03PEJmBwmDbLG1G
 /3jtrs1Cm6v7hCvn1NWdQJXSAXuhuuydKmMFvka6aXeDTg5UcQZoWUxBd77ugSwTWHL5
 wofV9E0Zt72Karf2YTIVzlPlir3TMdo+FWiMxBC4Gs4eSKY8oSHhFnZmol3uLezGF0v4
 2BUg==
X-Gm-Message-State: AOAM531Vjc9cclXAfOsJnAS7xtQRo98k3n8czdk5egbVC8ARrHCnXMCf
 lEDJ5/muNEaheRDxujE9unzF8OiX4S7oVyLSrfEvG3rSpIZsf8YWJKX7XWOKUYeNri8MEx/sZx/
 4UcFLBXdOxwQnI0nvA79O4QT2
X-Received: by 2002:a17:902:864b:b0:14c:d45e:a77b with SMTP id
 y11-20020a170902864b00b0014cd45ea77bmr27271949plt.143.1647340668173; 
 Tue, 15 Mar 2022 03:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuwiZgnCw2OZfY3/17qI+R/Vwptjj6tRCpsQcLyxgK5e+0w7DucK4ECAsJZKeHLCwxh0Ejkg==
X-Received: by 2002:a17:902:864b:b0:14c:d45e:a77b with SMTP id
 y11-20020a170902864b00b0014cd45ea77bmr27271914plt.143.1647340667879; 
 Tue, 15 Mar 2022 03:37:47 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 lp13-20020a17090b4a8d00b001c18b1114c8sm2789942pjb.10.2022.03.15.03.37.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 03:37:47 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:37:38 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 14/26] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
Message-ID: <YjBsctBz5RAWUd8r@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-15-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-15-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Fri, Mar 11, 2022 at 12:25:16AM +0000, David Matlack wrote:
> Allow adding new entries to the rmap and linking shadow pages without a
> struct kvm_vcpu pointer by moving the implementation of rmap_add() and
> link_shadow_page() into inner helper functions.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 43 +++++++++++++++++++++++++++---------------
>  1 file changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d7ad71be6c52..c57070ed157d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -725,9 +725,9 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>  
> -static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
> +static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
>  {
> -	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> +	return kvm_mmu_memory_cache_alloc(cache);
>  }

Nit: same here, IMHO we could drop mmu_alloc_pte_list_desc() already..

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
