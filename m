Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3C7C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 13:32:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B23634CB6C;
	Tue, 19 Jul 2022 09:32:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s7b8xPrxGQWB; Tue, 19 Jul 2022 09:32:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFC7C4CB5A;
	Tue, 19 Jul 2022 09:32:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EBC34CB5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 09:32:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LkpBP27giG8j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 09:32:24 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 524BF4C8C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 09:32:24 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id a5so21588282wrx.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 06:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FrozUrwgIOtPZPU7Vt+EwKFtk6342ujDLZysxCGk/2U=;
 b=S5+hpwih6SZVqj/aZj22GkTtB6kZfbDkhiG9Hf++s/M60OXgNZ/J9S/iUKontqxajh
 OzXnE52J9XzWdiwGbTqN1ITAQKNwzA4v3az0hShMM6Va2ngQvc5JMkF4xEx34Jek+4hX
 xqIY6w51YepwMJdLLJUAeAc+jbuEZPdqniB9QcMW0l12HW6bgo5C0nE5rvUq5oSo93eZ
 MgfZljgodBz8jCjeI/ve6kl4ger6fvg1/P9WWN/hiiTxkThSTx5Uc9CpWqBpwNbmYBkb
 YMB6utRhH5yLR2qAIvbA/yi19l14EDbTsMIcnboJI/3gyW6RtBzaRL/gtAshqmzTkcXa
 2b3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FrozUrwgIOtPZPU7Vt+EwKFtk6342ujDLZysxCGk/2U=;
 b=JBNYa/HcZQt/CZ74Mb2D/ebQrCNF3PNULLyWcL65I5ic1qu0n2eUT0irc6BCYGLzSh
 R/uu5cocnFDapuwW/Wc5J1uk4JtcO66+95lQc15VK3SGUaG69URPdukB4jkPOUSoOm76
 OL9/yYJIUY4qStBvY/D1fUwJZ/FPB+d9Wo70z+w2VJYGyT4OOo3rfDsUrg9E0Tb4B7FL
 NJAuO1sJ4RRp3H18AZ4XsAMkx/2qndk+NSDkQBvpMQeyhK2bBBKkrOf7830b+tplefl6
 x3TdORQQVpROQcsaGF8cjrUwNtR8FGagXAXNr9iUZdUM4shlNy4b5SqjyLPgRmDZiXLZ
 v+SA==
X-Gm-Message-State: AJIora9uyVXpB852ebh3Li7L44GoPOJfiUrowRcCvEHjX7N2HNmjFc35
 TMHGHDMLFGzULFBKtEIX3+tqOQ==
X-Google-Smtp-Source: AGRyM1tBOCHh1mly6SNagRp9Dh5EU1Ka18SIzDcfqYtAbUecvNXPxURgsOuO1nVIX4WV8COO/Prb7A==
X-Received: by 2002:a05:6000:1081:b0:21d:6b27:b12d with SMTP id
 y1-20020a056000108100b0021d6b27b12dmr25759245wrw.504.1658237543035; 
 Tue, 19 Jul 2022 06:32:23 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com.
 [35.187.36.109]) by smtp.gmail.com with ESMTPSA id
 i4-20020a05600c354400b003a2c7bf0497sm17206016wmq.16.2022.07.19.06.32.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Jul 2022 06:32:22 -0700 (PDT)
Date: Tue, 19 Jul 2022 14:32:18 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 18/24] KVM: arm64: Instantiate guest stage-2
 page-tables at EL2
Message-ID: <YtayYuo2qBplXcdi@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-19-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-19-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

[...]

>  }
>  
>  void reclaim_guest_pages(struct kvm_shadow_vm *vm)
>  {
> -	unsigned long nr_pages;
> +	unsigned long nr_pages, pfn;
>  
>  	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
> -	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
> +	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
> +
> +	guest_lock_component(vm);
> +	kvm_pgtable_stage2_destroy(&vm->pgt);
> +	vm->kvm.arch.mmu.pgd_phys = 0ULL;
> +	guest_unlock_component(vm);
> +
> +	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
>  }

The pfn introduction being removed in a subsequent patch, this is probably
unecessary noise.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
