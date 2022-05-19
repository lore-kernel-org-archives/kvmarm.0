Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8315BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 03:48:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE94A4B2A5;
	Wed, 18 May 2022 23:48:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JrNyMJ1E7x8h; Wed, 18 May 2022 23:48:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC024B333;
	Wed, 18 May 2022 23:48:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0676E4B2DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 23:48:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PR7gecih7xxJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 23:48:05 -0400 (EDT)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA98B4B2A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 23:48:05 -0400 (EDT)
Received: by mail-io1-f46.google.com with SMTP id f4so4556142iov.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 20:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=V7aykxkpRlTrHcdok+1A8qMCzSLka/rVSLMo9eqIxnA=;
 b=nCjjPyCmNUJwmxdEVP2MJRlqhK1VkKhityQGd1WRlCSn1KQoYBU7MSH7G9iBptN0ZA
 K9F/9TOtJDNQ6HlNozRI9gtk+YKBCMp6p1alj9uaGotX3V4uQnc6RclOHQpJoMb8tC52
 kUfLP0MeMGnms+fOZi0nljeddiouf8PS1LChbh7rouNciJANho6lK6y6e8JZlw5oqc5i
 1HW/FeboKCrQHRzUdaXSuUDy44kHr3JnrNSp55V38SMxTp48Bv65UUhRxDEegqsVbsRv
 x4UiPJUKeZDHotEucB35lECImraRroX9wvVueZLWO2rzVs2iSqBV4wTlAWP3cDy724d3
 UIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=V7aykxkpRlTrHcdok+1A8qMCzSLka/rVSLMo9eqIxnA=;
 b=yc/tJVxamZkzNbY0YPNz2SOEeBJny+P0gIW5YHJPZJ3w/ksSIu9qHZcDcg9LJ8K92O
 uBBDWe1mhPLuAvFZp3giugBNC0VYuddWra2/Uy/stx9Z7siaWH9wqb1vwXfLGOyUF2Dk
 Os86ln6TNEfKVZkTp46wdnWrWBBFfL8mUMw758v0cvtMfa1QI7xFD7nh6tyjBptcXb2F
 FrYUmcc4D3sRmaM+oez7G3eVDedRaE4uvUgqFfAyZLB7xx9fEz7pwzqd70cch5cbGyMF
 /vlI0wdf9GomqjC0NvGAjYPYgCOoLm08N5PYOwjoCcMxTfPDoYk056aSH4FfcFupXWFX
 xQWg==
X-Gm-Message-State: AOAM533BkY/7OFfquEeRTXY8ZxHARNGHQKMISh0K+uxMesld3cq6j1Qf
 6T3DPNQUNMo2yOgm0nXa1uCFYQ==
X-Google-Smtp-Source: ABdhPJyF43/gmULs/erOMWf06SK+pEavs8YWgCinIHa60Rx65dQweOqX0OpvpMJfoexchX+275tbQw==
X-Received: by 2002:a05:6602:2f0c:b0:65a:d5f3:7572 with SMTP id
 q12-20020a0566022f0c00b0065ad5f37572mr1475954iow.22.1652932084930; 
 Wed, 18 May 2022 20:48:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f1-20020a02a101000000b0032e833105fesm332923jag.177.2022.05.18.20.48.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 20:48:04 -0700 (PDT)
Date: Thu, 19 May 2022 03:48:00 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 02/13] KVM: selftests: aarch64: Add vm_get_pte_gpa
 library function
Message-ID: <YoW98HI27sP5lHKR@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-3-ricarkol@google.com>
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

Hey Ricardo,

Sorry about my last email hitting your v2. I fudged my inbox filtering
so v3 missed my explicit-cc inbox. Oops!

On Thu, Apr 07, 2022 at 05:41:09PM -0700, Ricardo Koller wrote:
> Add a library function (in-guest)

This function is called from host userspace, no?

> to get the GPA of the PTE of a
> particular GVA.  This will be used in a future commit by a test to clear
> and check the AF (access flag) of a particular page.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  2 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 24 +++++++++++++++++--
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 8f9f46979a00..caa572d83062 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -125,6 +125,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
>  void vm_install_sync_handler(struct kvm_vm *vm,
>  		int vector, int ec, handler_fn handler);
>  
> +vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva);
> +
>  static inline void cpu_relax(void)
>  {
>  	asm volatile("yield" ::: "memory");
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9343d82519b4..ee006d354b79 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -139,7 +139,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  	_virt_pg_map(vm, vaddr, paddr, attr_idx);
>  }
>  
> -vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>  	uint64_t *ptep;
>  
> @@ -162,7 +162,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  			goto unmapped_gva;
>  		/* fall through */
>  	case 2:
> -		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
> +		ptep = (uint64_t *)(pte_addr(vm, *ptep) + pte_index(vm, gva) * 8);

this seems a bit odd. ptep is an HVA in the above cases, but really a
GPA here.

Also -- not your code but the baked-in assumption that the stage-1 MMU
always maps at leaf page granularity might be a bit of a mess if we ever
do anything more interesting inside of the guest.

>  		if (!ptep)
>  			goto unmapped_gva;
>  		break;
> @@ -170,6 +170,26 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  		TEST_FAIL("Page table levels must be 2, 3, or 4");
>  	}
>  
> +	return (vm_paddr_t)ptep;
> +
> +unmapped_gva:
> +	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
> +	exit(1);

Isn't this just a workaround for the fact that TEST_FAIL() doesn't have
the noreturn attribute specified somewhere?

> +}
> +
> +vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +{
> +	uint64_t *ptep;
> +	vm_paddr_t ptep_gpa;
> +
> +	ptep_gpa = vm_get_pte_gpa(vm, gva);
> +	if (!ptep_gpa)
> +		goto unmapped_gva;

This branch will never be taken since vm_get_pte_gpa() will explode on
its own, right?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
