Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB474C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 02:55:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E774B11E;
	Mon, 18 Apr 2022 22:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tb1QoRetNgkY; Mon, 18 Apr 2022 22:55:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA7B49F1B;
	Mon, 18 Apr 2022 22:55:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A61E149F1B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:55:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1okGHsVydMwQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2022 22:55:30 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A1AB49E43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:55:30 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id s14so13903072plk.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 19:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=K5SWmkm3M1KXlKvWMogmnhHOSV5VRfdAKiKhpXad0MM=;
 b=kd1XaSqO+dDGtXb9gAKgf1G6moHxFNoBBGmqnuSt2atFJf60emXVMaEWXNhLzMVjfj
 5e15TxY5kse8eTXM7g0EUUPGuBzP/4iE+ehiOFIJNEWBEzONmgoo/mYhLiNQXVsnbawb
 9jZayC4pRjVJ5Dl4nWt0+D58XHnXhTorpCFbQCeqH2oNF8lgyvG3TOuBIVmJlFxhaFJf
 PGjhSglD7W6tMzfwa25eb3At4j94HbTlP20ihU6qmyfRJwbTQ4nOuNqbxyLK657IBJL6
 OvOBHOSu4sPdXLlnASZrBNUFYk2DwUfCQUwOsisO3M8g5lx/GZuPYqt5ojsShbDxr3uy
 /Iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=K5SWmkm3M1KXlKvWMogmnhHOSV5VRfdAKiKhpXad0MM=;
 b=ImLfX6AFJyEPig6RaItNtNS7G6X8dlsINQg5rkoZzTsIV69g7euMC6FNCG83l4yEey
 nmCgtdE0PT3pCbI8kFB8O+MHCe/iKgWNaBaNlLFxkcGRi1KVluTISCBtvy2Gg/1rwflk
 OB40HE+qaqRkw9THJXqEkTIVlmWfxcHx+JhP2f+B2C7Mj1g6MXm5uee0gGwLhexOV8Z2
 kQbtJSmpduL+P+iCVDRyCnmNiuQDB9sPCy2HbzzOt/yoJSEPyE/rwtkFp4Y/V5fXIUZB
 80sS4Mc8BjAjPB0cVQ8AJndMHf6/jpJX6frYgo6PkA4PDquJykDoNapuabKWCOdyCYIB
 nEeg==
X-Gm-Message-State: AOAM532TY+RoXnbTEmy9fVfGKW4URnyocj3wjqLgHr8+Dvc2epiRb9Rh
 IymLwpVywuSnSPzE+2EBAmK9Lw==
X-Google-Smtp-Source: ABdhPJxKlcRJjCzKGyjnWF3bYkZUsv4WUb3ngdGk4aVZN1U0VmPZG+/MVSwH4rG+04OpQL6kxvh7KQ==
X-Received: by 2002:a17:90a:638e:b0:1d2:b6e3:6e9d with SMTP id
 f14-20020a17090a638e00b001d2b6e36e9dmr4987050pjj.74.1650336929269; 
 Mon, 18 Apr 2022 19:55:29 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 h10-20020a056a001a4a00b004f7c76f29c3sm14255668pfv.24.2022.04.18.19.55.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Apr 2022 19:55:28 -0700 (PDT)
Date: Mon, 18 Apr 2022 19:55:24 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 04/17] KVM: arm64: Protect page table traversal with
 RCU
Message-ID: <Yl4knFR8E8XVbgDj@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-5-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-5-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Apr 15, 2022 at 09:58:48PM +0000, Oliver Upton wrote:
> Use RCU to safely traverse the page tables in parallel; the tables
> themselves will only be freed from an RCU synchronized context. Don't
> even bother with adding support to hyp, and instead just assume
> exclusive access of the page tables.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5b64fbca8a93..d4699f698d6e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -132,9 +132,28 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
>  	return pte;
>  }
>  
> +
> +#if defined(__KVM_NVHE_HYPERVISOR__)
> +static inline void kvm_pgtable_walk_begin(void)
> +{}
> +
> +static inline void kvm_pgtable_walk_end(void)
> +{}
> +
> +#define kvm_dereference_ptep	rcu_dereference_raw
> +#else
> +#define kvm_pgtable_walk_begin	rcu_read_lock
> +
> +#define kvm_pgtable_walk_end	rcu_read_unlock
> +
> +#define kvm_dereference_ptep	rcu_dereference
> +#endif
> +
>  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> -	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> +	kvm_pte_t __rcu *ptep = mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> +
> +	return kvm_dereference_ptep(ptep);
>  }
>  
>  static void kvm_clear_pte(kvm_pte_t *ptep)
> @@ -288,7 +307,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.walker	= walker,
>  	};
>  
> +	kvm_pgtable_walk_begin();
>  	return _kvm_pgtable_walk(&walk_data);
> +	kvm_pgtable_walk_end();

This might be fixed later in the series, but at this point the
rcu_read_unlock is never called.

>  }
>  
>  struct leaf_walk_data {
> -- 
> 2.36.0.rc0.470.gd361397f0d-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
