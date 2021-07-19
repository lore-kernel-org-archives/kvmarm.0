Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EF4C12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 06:31:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 350D261165
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 06:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 350D261165
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCC634B087;
	Mon, 19 Jul 2021 02:31:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9-VMOKzacx4G; Mon, 19 Jul 2021 02:31:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6CD4A500;
	Mon, 19 Jul 2021 02:31:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DACC740856
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 02:31:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KWL+GcHUWZbo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 02:31:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 100BE4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 02:31:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626676311;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5iBFyoa3ekzBjt+3mHKhKLuzk3TVXqOUxd9HJiVKOWA=;
 b=VyL8LrzoP8cupK4fD6/DLdTVXUk17NBDDFrnzUmb2HxDjCS6D2Uo5Opm5URyEc1KvkaDnS
 7tcSEyzDLnlPIIJzmG0aBmPAfyOZhCnUOBj3KvIocQYqFTYnrp4sLB6uswXMIWSRKcuRRG
 X2zulMuBCpdNCSbkiihBCU1PytfkmRE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-FtN3UmEgPYSalBd_e5_uAg-1; Mon, 19 Jul 2021 02:31:48 -0400
X-MC-Unique: FtN3UmEgPYSalBd_e5_uAg-1
Received: by mail-ej1-f72.google.com with SMTP id
 jx16-20020a1709077610b02904e0a2912b46so4866553ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Jul 2021 23:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=5iBFyoa3ekzBjt+3mHKhKLuzk3TVXqOUxd9HJiVKOWA=;
 b=XOqsvBZ85teA+r/vljly0G/tdKAvqwGt8+BxFB1FHmrRJNFDSZaN8uS1+Peg8x0KYA
 D65bc0VIC0Jn0rNfX1CsF9btfn4MVeHSLR6/O3o34lPyvSkYbErgjfVIjqkGSxp+p+5p
 5GBFi0j5CqrCMhzVBsDpbBWnVwKa2Z8gf+wvl9KXbqgYAhKSLze4h/lew/wQ8ra9/78W
 Fupi4kE4FR1+Tet/B0nLqUUa1lKu12jQJ6Ev36V5H9U9M4b/WzIv9PbJ9gZFdO/Mir21
 H/DLXzKd4lqt+kGjR9SbzWuqqfQK6U7pV+lb4u1QE5juLkVjnD1+7/gbB5jyPt+edp6H
 3LUw==
X-Gm-Message-State: AOAM532ikwRUpy44kpOGlExMIGmtmNh/QliwY7U1EHyknnWsZETtjNs0
 6mAsRCGAyBPwiHOQ2ZsMPpxRszrYkN2Tswp2edYQ8RSoeCz8NdbvkHQZqN0ZZqA2pX+C0md5ZRx
 WAWgfBFXmefXalU09cEJa8L40
X-Received: by 2002:a17:906:660f:: with SMTP id
 b15mr26130818ejp.443.1626676307274; 
 Sun, 18 Jul 2021 23:31:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwKAXQ0jz8kg1aBiPUIh7/qkMfflW9/UFkvvWaaFSOpzP+F0zQJJOF6m/qps2butenIEa5BQ==
X-Received: by 2002:a17:906:660f:: with SMTP id
 b15mr26130798ejp.443.1626676307142; 
 Sun, 18 Jul 2021 23:31:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id f24sm4761419edv.93.2021.07.18.23.31.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 18 Jul 2021 23:31:46 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: Get rid of kvm_get_pfn()
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-6-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ef15f26a-4701-9d8c-b856-e7bb717a69f9@redhat.com>
Date: Mon, 19 Jul 2021 08:31:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-6-maz@kernel.org>
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
> Nobody is using kvm_get_pfn() anymore. Get rid of it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   include/linux/kvm_host.h | 1 -
>   virt/kvm/kvm_main.c      | 9 +--------
>   2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b490b4..9818d271c2a1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -824,7 +824,6 @@ void kvm_release_pfn_clean(kvm_pfn_t pfn);
>   void kvm_release_pfn_dirty(kvm_pfn_t pfn);
>   void kvm_set_pfn_dirty(kvm_pfn_t pfn);
>   void kvm_set_pfn_accessed(kvm_pfn_t pfn);
> -void kvm_get_pfn(kvm_pfn_t pfn);
>   
>   void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
>   int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2e410a8a6a67..0284418c4400 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2215,7 +2215,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 * Get a reference here because callers of *hva_to_pfn* and
>   	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
>   	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
> -	 * set, but the kvm_get_pfn/kvm_release_pfn_clean pair will
> +	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
>   	 * simply do nothing for reserved pfns.
>   	 *
>   	 * Whoever called remap_pfn_range is also going to call e.g.
> @@ -2612,13 +2612,6 @@ void kvm_set_pfn_accessed(kvm_pfn_t pfn)
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
>   
> -void kvm_get_pfn(kvm_pfn_t pfn)
> -{
> -	if (!kvm_is_reserved_pfn(pfn))
> -		get_page(pfn_to_page(pfn));
> -}
> -EXPORT_SYMBOL_GPL(kvm_get_pfn);
> -
>   static int next_segment(unsigned long len, int offset)
>   {
>   	if (len > PAGE_SIZE - offset)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
