Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037BDC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 11:09:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DDE661107
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 11:09:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DDE661107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA294B120;
	Fri,  2 Apr 2021 07:09:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fCAP-URA+s1J; Fri,  2 Apr 2021 07:09:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B66884B12A;
	Fri,  2 Apr 2021 07:09:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A2F4B111
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 07:09:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x2YssvE7OCDo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 07:09:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B8074B082
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 07:09:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617361744;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0hU09Gh7VhRgV7xvcyXGklubADiCKUnFuUwdUO/8C8M=;
 b=CVM6KpVVkvQ8LOyXAlQUsTag3ZwHOok/5nhs/BAIIRHnqxScidthnUMM57mxKJ/mbwKPSq
 4cmOjGot8lP+ghEwtmIp82LC6WFUHQJd32Z8BEJCqK4G+hMUxyj2eYD+3cgkGS89MZoq2f
 m9IoY4AntzzX5zFj7+P5a5i2026PlKQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-8n3Sq_AeMyeMCRQkavgNDA-1; Fri, 02 Apr 2021 07:09:02 -0400
X-MC-Unique: 8n3Sq_AeMyeMCRQkavgNDA-1
Received: by mail-wr1-f72.google.com with SMTP id f3so4209253wrt.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 04:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=0hU09Gh7VhRgV7xvcyXGklubADiCKUnFuUwdUO/8C8M=;
 b=GIRxrsePU1XCQBpNLSYGOrxyrsimaEEYyw/98F2d38YfeWtcrMzCGw7KpfefyluClW
 JoOk+FINyPkZRvzFov6772+cyWM4tDCjpYOwwHn9iS3L6ULkRd6u5dFlNk36HzL687G7
 7kWLY8h9z0dvwmYmB9QryPjswUCk/5keORrEKzYK8h7h1q3aWZOX0poOalV7rhTtZhje
 BYd1yx+pWDYiNoZ9r7dqXZCsBe0+qxXOpSiDRIb48UjiD5r/vuKl2GsM7hXxizUT70JQ
 LXkU5nREyEZdFNkHbRgybFKT5GlrgqD/ed3h1OqZAfCA8NMlEbvyUtYAHV8kNnHG5Hsb
 LkpA==
X-Gm-Message-State: AOAM533uxQi+Su/w/yRvFwP0wIvz85WQuVWG2AbnlFWIWAHDXwh+aaok
 TxeWUwwDKKWPZYT7cSXDV5iVEXsu+XQz30pSprvxglO/tC/z5ljfXTWmLBjTn3qm3JjbWWux0GE
 meGNysxup1UoHZ8lWY7/IJOHH
X-Received: by 2002:a7b:c407:: with SMTP id k7mr12554638wmi.136.1617361739975; 
 Fri, 02 Apr 2021 04:08:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTzlBVbJGp7zOm3yypid9AymbapTJgMzZcFAv4/0wGVk1JV0HTRbkNFWcPN0Mr5tyDof6yiw==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr12554609wmi.136.1617361739749; 
 Fri, 02 Apr 2021 04:08:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id p17sm11190916wmq.47.2021.04.02.04.08.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Apr 2021 04:08:59 -0700 (PDT)
Subject: Re: [PATCH v2 01/10] KVM: Assert that notifier count is elevated in
 .change_pte()
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3fb5283e-21f0-8eb2-03ab-96113ca1f463@redhat.com>
Date: Fri, 2 Apr 2021 13:08:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-2-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 02/04/21 02:56, Sean Christopherson wrote:
> In KVM's .change_pte() notification callback, replace the notifier
> sequence bump with a WARN_ON assertion that the notifier count is
> elevated.  An elevated count provides stricter protections than bumping
> the sequence, and the sequence is guarnateed to be bumped before the
> count hits zero.
> 
> When .change_pte() was added by commit 828502d30073 ("ksm: add
> mmu_notifier set_pte_at_notify()"), bumping the sequence was necessary
> as .change_pte() would be invoked without any surrounding notifications.
> 
> However, since commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify
> with invalidate_range_start and invalidate_range_end"), all calls to
> .change_pte() are guaranteed to be bookended by start() and end(), and
> so are guaranteed to run with an elevated notifier count.
> 
> Note, wrapping .change_pte() with .invalidate_range_{start,end}() is a
> bug of sorts, as invalidating the secondary MMU's (KVM's) PTE defeats
> the purpose of .change_pte().  Every arch's kvm_set_spte_hva() assumes
> .change_pte() is called when the relevant SPTE is present in KVM's MMU,
> as the original goal was to accelerate Kernel Samepage Merging (KSM) by
> updating KVM's SPTEs without requiring a VM-Exit (due to invalidating
> the SPTE).  I.e. it means that .change_pte() is effectively dead code
> on _all_ architectures.
> 
> x86 and MIPS are clearcut nops if the old SPTE is not-present, and that
> is guaranteed due to the prior invalidation.  PPC simply unmaps the SPTE,
> which again should be a nop due to the invalidation.  arm64 is a bit
> murky, but it's also likely a nop because kvm_pgtable_stage2_map() is
> called without a cache pointer, which means it will map an entry if and
> only if an existing PTE was found.
> 
> For now, take advantage of the bug to simplify future consolidation of
> KVMs's MMU notifier code.   Doing so will not greatly complicate fixing
> .change_pte(), assuming it's even worth fixing.  .change_pte() has been
> broken for 8+ years and no one has complained.  Even if there are
> KSM+KVM users that care deeply about its performance, the benefits of
> avoiding VM-Exits via .change_pte() need to be reevaluated to justify
> the added complexity and testing burden.  Ripping out .change_pte()
> entirely would be a lot easier.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1de843b7618..8df091950161 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -461,12 +461,17 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   
>   	trace_kvm_set_spte_hva(address);
>   
> +	/*
> +	 * .change_pte() must be bookended by .invalidate_range_{start,end}(),

Changed to "surrounded" for the benefit of non-native speakers. :)

Paolo

> +	 * and so always runs with an elevated notifier count.  This obviates
> +	 * the need to bump the sequence count.
> +	 */
> +	WARN_ON_ONCE(!kvm->mmu_notifier_count);
> +
>   	idx = srcu_read_lock(&kvm->srcu);
>   
>   	KVM_MMU_LOCK(kvm);
>   
> -	kvm->mmu_notifier_seq++;
> -
>   	if (kvm_set_spte_hva(kvm, address, pte))
>   		kvm_flush_remote_tlbs(kvm);
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
