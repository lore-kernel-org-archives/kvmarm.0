Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA0DC48BDF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 12:00:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93C91613EB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 12:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93C91613EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065404B176;
	Thu, 24 Jun 2021 08:00:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VFSsF0b7SsuN; Thu, 24 Jun 2021 08:00:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF794B162;
	Thu, 24 Jun 2021 08:00:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7D654B109
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 08:00:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mOccvglrHJ+D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 08:00:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A1D40825
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 08:00:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624536032;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=avGojGcO92NTULuhKarR1IMbTxAu/KipAq8BEw7I0Ko=;
 b=NwH7B5NWjpeo7xHuBdxiGRVZh4xvFr+1lFCIJJITHPUdkX1qQF6HaOwh7QLG0Nd8FkYAvF
 xESavrCoW3oJDHBQuPpw3tbG2YBsPxiC6jO70F5rBsHr1BY5umW0PjAB5zZ5EoQX6wnH1p
 zktQA9JdpEloy+r80cSPmHzIxlXLtTM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-5XbsVJaoMP-vOtMCS356uw-1; Thu, 24 Jun 2021 08:00:31 -0400
X-MC-Unique: 5XbsVJaoMP-vOtMCS356uw-1
Received: by mail-wr1-f72.google.com with SMTP id
 f9-20020a5d64c90000b029011a3c2a0337so2145661wri.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 05:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=avGojGcO92NTULuhKarR1IMbTxAu/KipAq8BEw7I0Ko=;
 b=uNYptK5BOTvYeUkH2qJa82tuvlNOeOkLPab8v83ji26wBWlP5naCDKnUuo2FlXYEYk
 Cu7OhOOyLAZy/MgE9lxrDt8LclYLBzLKapsG9iZRccSFNbaCicFHNWviq02MFdj5WlAP
 qUmZQIhEI1dOQQkd9uKGm3mW2xVvBagVYx+Hb4HL43bP0IukdZSydDcOyEAz7kKYzzvi
 PRfgtVw9gQJateV8Ek8XKjsKR+OUc9fekm9JrAx1rgO2bpp0xLfEYV8yKwd+7IoiU+56
 JXTeGi7sDYrBTUW/RY35ZcTX2AexxL2hvv+ALnMwaNIFIo9b19ekYfdVPh3KUIsDjZJ0
 31bg==
X-Gm-Message-State: AOAM533PFCPvaMho3Q4W1ffthkktqXvFKxchaN8bF0oKi1czPazSP4PL
 OKMhRracaYA0FObg/LfEojku34lvxsaatQmQdpFMjbPf8WxViCppc9Vm/l4yMJ7xNL0pcFW2AuI
 gTYdoC4ITz7EYSz/PYahLaB0n
X-Received: by 2002:a1c:f215:: with SMTP id s21mr3879370wmc.179.1624536030195; 
 Thu, 24 Jun 2021 05:00:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXFCnAp+BCIAB50GwF3Py3d9h4g0enz3/eZSVNkNtDC1Z07h1ecnwnq+OHmfePVB6B9P4IuQ==
X-Received: by 2002:a1c:f215:: with SMTP id s21mr3879281wmc.179.1624536029808; 
 Thu, 24 Jun 2021 05:00:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id o2sm3074141wrp.53.2021.06.24.05.00.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Jun 2021 05:00:29 -0700 (PDT)
To: Nicholas Piggin <npiggin@gmail.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, David Stevens <stevensd@chromium.org>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <1624530624.8jff1f4u11.astroid@bobo.none>
 <1624534759.nj0ylor2eh.astroid@bobo.none>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64 MMU
Message-ID: <d06a8a55-bb9d-a6ef-21bb-0633b99a50d1@redhat.com>
Date: Thu, 24 Jun 2021 14:00:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624534759.nj0ylor2eh.astroid@bobo.none>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Stevens <stevensd@google.com>, intel-gfx@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, kvm-ppc@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On 24/06/21 13:42, Nicholas Piggin wrote:
> +static int kvm_try_get_pfn(kvm_pfn_t pfn)
> +{
> +	if (kvm_is_reserved_pfn(pfn))
> +		return 1;

So !pfn_valid would always return true.  Yeah, this should work and is 
certainly appealing!

Paolo


> +	return get_page_unless_zero(pfn_to_page(pfn));
> +}
> +
>   static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   			       unsigned long addr, bool *async,
>   			       bool write_fault, bool *writable,
> @@ -2104,13 +2111,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 * Whoever called remap_pfn_range is also going to call e.g.
>   	 * unmap_mapping_range before the underlying pages are freed,
>   	 * causing a call to our MMU notifier.
> +	 *
> +	 * Certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages, but be allocated without refcounting e.g.,
> +	 * tail pages of non-compound higher order allocations, which
> +	 * would then underflow the refcount when the caller does the
> +	 * required put_page. Don't allow those pages here.
>   	 */
> -	kvm_get_pfn(pfn);
> +	if (!kvm_try_get_pfn(pfn))
> +		r = -EFAULT;
>   
>   out:
>   	pte_unmap_unlock(ptep, ptl);
>   	*p_pfn = pfn;
> -	return 0;
> +
> +	return r;
>   }
>   
>   /*
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
