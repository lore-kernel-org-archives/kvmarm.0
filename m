Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45598C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 03:53:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F774B354;
	Wed, 18 May 2022 23:53:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vI6aowah5peK; Wed, 18 May 2022 23:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 849A74B341;
	Wed, 18 May 2022 23:53:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D782F4B33C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 23:53:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xt-pi5YV54Ld for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 23:53:26 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2CFE4B2BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 23:53:26 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id s23so4495918iog.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 20:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lufChGhIEUsgvEbinQ26kGFNXQ3rJPqXruGsydqK3Q8=;
 b=Ob5OHP1Cm2BDG5B8+mM1i3xAUIbpuTw6iH99FzXl3AB/gzmbRYt/8l9QgFDBFYjVF3
 WyMOmZBvcKILAabVoUX3CboQXeIeoyKQkRct8SDIa3lN9r9P3NGsUSraMrUAt3CiPGcO
 vutDZnp22fCSi4fzqIsjEWHnmT4d/E6FCBn+ZzpwYMOUAjZJVJw2aWtLp8FF3GgvIpSc
 4AZdVi/YVyCcEHLwcpnByKFo43lg3o9KEXvIY7QlZb9I69jl/Gvswdh6UBOgTeEyuruC
 Fr8+m+lxuU8T8NXvg3Jeda/7q1JZl89/yvknXaK4WlTI/HPlLtCLH+Q40EG8NBC/IqxN
 zwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lufChGhIEUsgvEbinQ26kGFNXQ3rJPqXruGsydqK3Q8=;
 b=e6ULPQCj500hKTGg4ivkRHw9Sx6Yu3W4q7ZHTt1jKXMXs7yiKoRIoY2CSndo3HqzZJ
 BEVUu++oJviWnEek9MN95okx6zY3t+VPXaX89IFUhbHMVaDeUQL6ynqZ4Y/oiLSiyOvW
 XuL0kNStVj/mkVQVkqcziIMVoSuU54GcTIV5gHB83r1WQYEGCRmoNlnsKialX9Z3KoMs
 5lXTsPv/4nSewqKPUwzMwb/UICD3zw4xPJDYR1obVIp6Y/PV1OaczlGTnrLpcrbBke3G
 Xc5M/g44OjGUT1zmL/RFrkNu+oEbEYfmK+srBgUFnFGNkA58Fb5UuBzR62CyrElsEsfG
 GvNg==
X-Gm-Message-State: AOAM530KZfsRS/uTFoL8HiyU3SIB91TAS9MaqHqgMjp1UlPs9qNe1EpA
 W+J5M3uxyDDWpCScT4oggt1/Gg==
X-Google-Smtp-Source: ABdhPJzHLuxQCrtYiefUcYjxdJJ2hDfZlHcdb0YN4AADKy0DKzgV1vNQp99haKIsXadjm4ZpAEcfhQ==
X-Received: by 2002:a05:6602:2e8c:b0:64d:633a:4148 with SMTP id
 m12-20020a0566022e8c00b0064d633a4148mr1432951iow.12.1652932405951; 
 Wed, 18 May 2022 20:53:25 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 p7-20020a92c107000000b002cde6e35309sm993845ile.83.2022.05.18.20.53.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 20:53:25 -0700 (PDT)
Date: Thu, 19 May 2022 03:53:21 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 03/13] KVM: selftests: Add
 vm_alloc_page_table_in_memslot library function
Message-ID: <YoW/MXYqP/O7JyX6@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-4-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 07, 2022 at 05:41:10PM -0700, Ricardo Koller wrote:
> Add a library function to allocate a page-table physical page in a
> particular memslot.  The default behavior is to create new page-table
> pages in memslot 0.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..3a69b35e37cc 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -306,6 +306,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  			      vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
>  
>  /*
>   * Create a VM with reasonable defaults
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d8cf851ab119..e18f1c93e4b4 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2386,9 +2386,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  /* Arbitrary minimum physical address used for virtual translation tables. */
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
>  
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> +{
> +	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,

Test code needs to plop the memslot with some space above
PAGE_TABLE_MIN_PADDR then, right?

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
