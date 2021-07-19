Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BE6C12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 06:31:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 662D261186
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 06:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 662D261186
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CEA24A7FD;
	Mon, 19 Jul 2021 02:31:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id buRTVdkVtXuo; Mon, 19 Jul 2021 02:31:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F714A4E5;
	Mon, 19 Jul 2021 02:31:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 689F84A3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 02:31:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8IsbPB-HQDm4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 02:31:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB6740856
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 02:31:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626676307;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=sDl9zJ8yJigPizUQxq5VDfedGB5Y2mU/bObQ9LMf+NY=;
 b=d4WKEHwru1rQlQ2jwZbZaU9BrQptj7DI0oAswioTfmBjmR3zMmA+szCCJacdzuH3fwTsG6
 TIcY1ze/sKM/7I8eYDkxpbMTGK8j+mAJGLVGqISgSWOfo09Zkea0MA7lHtDBWOO3tj6mDB
 AHp6SeLgudfF+l4M5jUn70pOLDppNMQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-M2nFjTiMNRuGB9JTNnfmcg-1; Mon, 19 Jul 2021 02:31:43 -0400
X-MC-Unique: M2nFjTiMNRuGB9JTNnfmcg-1
Received: by mail-ed1-f71.google.com with SMTP id
 eg53-20020a05640228b5b02903ad3cc35040so7339615edb.11
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Jul 2021 23:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=sDl9zJ8yJigPizUQxq5VDfedGB5Y2mU/bObQ9LMf+NY=;
 b=GPQfTOaTo/i3qdjaegtjf1W6KG4nbK71uCrHenbDUHu+PAzRvCj6zq+4pArMHTrrmO
 KVGAQAGptNN4sD+1AsOqRUv1hntQWWDy+QA7ksC2lmQ+sR80CVSHVWfpARj37zlh5ZUI
 EyYx0PLxznHM04BosfZGlmbucJaYDW4dJyZHMZv2ajfDkwIEdtPzKUAeKT8P+mGtw7mR
 6zNXmFyGP9WHkf7udgJAEk5S7nnbeTryBKqXBKb1sJH82tZuR5qXFp8tFfwOYnfkIR7t
 6A7BV2wtxbwj9eFsFSP1yzKCqSHvxPdO5OvF/kasP+R6HJpKJej3AME12sb69NYCiTnO
 +d0A==
X-Gm-Message-State: AOAM533Fs4IxasjWRov/Y580fr2d+wiCaG+Jxy8RJEq9OwVmN2OGM9JX
 kombJ+evs+kQfhBZPQg0Kd+6ivKm4xJNM1/CL49zLoXlDNxwe4DDHdxMDWFL32r1G/TpDZTTcy3
 WEjh1y6kvUngcE0BmwkLuq9r0
X-Received: by 2002:a05:6402:692:: with SMTP id
 f18mr33054717edy.327.1626676302244; 
 Sun, 18 Jul 2021 23:31:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy03G7eb3Ni5bq5T+4u9WmKa5rbbWmLEfjZhNZllL+I9GCy7NjuQxCbsv+toB/S7ycv5irrnA==
X-Received: by 2002:a05:6402:692:: with SMTP id
 f18mr33054692edy.327.1626676302062; 
 Sun, 18 Jul 2021 23:31:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id i10sm7237674edf.12.2021.07.18.23.31.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 18 Jul 2021 23:31:41 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: Remove kvm_is_transparent_hugepage() and
 PageTransCompoundMap()
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-4-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc371325-1e4c-b842-1b37-ec197175cb3b@redhat.com>
Date: Mon, 19 Jul 2021 08:31:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-4-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Will Deacon <will@kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 17/07/21 11:55, Marc Zyngier wrote:
> Now that arm64 has stopped using kvm_is_transparent_hugepage(),
> we can remove it, as well as PageTransCompoundMap() which was
> only used by the former.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   include/linux/page-flags.h | 37 -------------------------------------
>   virt/kvm/kvm_main.c        | 10 ----------
>   2 files changed, 47 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5922031ffab6..1ace27c4a8e0 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -632,43 +632,6 @@ static inline int PageTransCompound(struct page *page)
>   	return PageCompound(page);
>   }
>   
> -/*
> - * PageTransCompoundMap is the same as PageTransCompound, but it also
> - * guarantees the primary MMU has the entire compound page mapped
> - * through pmd_trans_huge, which in turn guarantees the secondary MMUs
> - * can also map the entire compound page. This allows the secondary
> - * MMUs to call get_user_pages() only once for each compound page and
> - * to immediately map the entire compound page with a single secondary
> - * MMU fault. If there will be a pmd split later, the secondary MMUs
> - * will get an update through the MMU notifier invalidation through
> - * split_huge_pmd().
> - *
> - * Unlike PageTransCompound, this is safe to be called only while
> - * split_huge_pmd() cannot run from under us, like if protected by the
> - * MMU notifier, otherwise it may result in page->_mapcount check false
> - * positives.
> - *
> - * We have to treat page cache THP differently since every subpage of it
> - * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
> - * mapped in the current process so comparing subpage's _mapcount to
> - * compound_mapcount to filter out PTE mapped case.
> - */
> -static inline int PageTransCompoundMap(struct page *page)
> -{
> -	struct page *head;
> -
> -	if (!PageTransCompound(page))
> -		return 0;
> -
> -	if (PageAnon(page))
> -		return atomic_read(&page->_mapcount) < 0;
> -
> -	head = compound_head(page);
> -	/* File THP is PMD mapped and not PTE mapped */
> -	return atomic_read(&page->_mapcount) ==
> -	       atomic_read(compound_mapcount_ptr(head));
> -}
> -
>   /*
>    * PageTransTail returns true for both transparent huge pages
>    * and hugetlbfs pages, so it should only be called when it's known
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7d95126cda9e..2e410a8a6a67 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -189,16 +189,6 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>   	return true;
>   }
>   
> -bool kvm_is_transparent_hugepage(kvm_pfn_t pfn)
> -{
> -	struct page *page = pfn_to_page(pfn);
> -
> -	if (!PageTransCompoundMap(page))
> -		return false;
> -
> -	return is_transparent_hugepage(compound_head(page));
> -}
> -
>   /*
>    * Switches to specified vcpu, until a matching vcpu_put()
>    */
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
