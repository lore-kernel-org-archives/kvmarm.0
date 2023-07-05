Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A363C
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688518290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=05Y7FRqpionSiuOM6vbmN3tWEYWnCWQeWHLoVh2gOCU=;
	b=ff31dfAYVERqJhJ7S+5eF6w3+Q65AET1yMIV6LQVZsOq7ijAIBSdwj1wJaia537gNQQDpm
	tVq+ALb0JCnhdxBzwDNtaZptc6gbOJ+65epLmoqsMW9GgrrIv0pleOv2AYc2YjgE+kSlb2
	Et5eZevWYcTMNLW9VTcrp3pIxUxFBHI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-_YRS5x0zPlWcYcdBhl5x8w-1; Tue, 04 Jul 2023 20:51:29 -0400
X-MC-Unique: _YRS5x0zPlWcYcdBhl5x8w-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-57059f90cc5so66417907b3.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 17:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688518289; x=1691110289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05Y7FRqpionSiuOM6vbmN3tWEYWnCWQeWHLoVh2gOCU=;
        b=d1S9oWVx/RuzG24KLhwGCNG53pN1zTfHLa3S4XkDbO5HRqvO3b4k9E+MzR5MpfIHvh
         GfGk5uXOT3EKDiRDCBsfDQ+GaMCEdHphKPnLEAIOqFzIAnuhEZbTMCeZ80NP2rVYdwCs
         NMpfQx7WBprO/LBB4o5Gd1AKNDkl72iQJxuuSTb3lK8P0Y0Rp0OXlz1MKIjh5BG8LcI2
         xd0K3O6UilklRIz0TZGsAkORCfPAhwYy0Em2MZJ43u7DZglHuQGbEGMT+n9qmMha9+pG
         RE9NDOb2xxOg8YMlm4e8icdQhNMQ1uIq8xLXFNQC9QjLXHuppti/RPa0KofaIPARGVXZ
         AtPg==
X-Gm-Message-State: ABy/qLbpTWNSpPWsq9qkDfg6vcrz8Nmx+e05Ia2DTcgFhJmAgIRUQisd
	ybJHqu/7vUV1+kY8YDgG2zYSAJ1vvg1wVhxUn95C/E0zsgE4z/aRo1LFPEPRBfiS2ETGnZ3LK/r
	ak8kB2zAwEPXTRH9z
X-Received: by 2002:a81:6643:0:b0:573:592a:6f7e with SMTP id a64-20020a816643000000b00573592a6f7emr15236889ywc.19.1688518289388;
        Tue, 04 Jul 2023 17:51:29 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGNQHLeMCWSeIz0qJufd+RXKyUWMQNzzlL6WDmNr44iY2x5LiPzRok2Cx6uzmegN+Hqo8Q60A==
X-Received: by 2002:a81:6643:0:b0:573:592a:6f7e with SMTP id a64-20020a816643000000b00573592a6f7emr15236876ywc.19.1688518289160;
        Tue, 04 Jul 2023 17:51:29 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id j25-20020aa78dd9000000b006687b4f2044sm16074713pfr.164.2023.07.04.17.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 17:51:28 -0700 (PDT)
Message-ID: <fa99d4ea-7390-906e-b691-9fa838df2788@redhat.com>
Date: Wed, 5 Jul 2023 10:51:18 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 10/11] KVM: arm64: Invalidate the table entries
 upon a range
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-11-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-11-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 6/22/23 03:50, Raghavendra Rao Ananta wrote:
> Currently, during the operations such as a hugepage collapse,
> KVM would flush the entire VM's context using 'vmalls12e1is'
> TLBI operation. Specifically, if the VM is faulting on many
> hugepages (say after dirty-logging), it creates a performance
> penalty for the guest whose pages have already been faulted
> earlier as they would have to refill their TLBs again.
> 
> Instead, leverage kvm_tlb_flush_vmid_range() for table entries.
> If the system supports it, only the required range will be
> flushed. Else, it'll fallback to the previous mechanism.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index df8ac14d9d3d4..50ef7623c54db 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -766,7 +766,8 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>   	 * value (if any).
>   	 */
>   	if (kvm_pte_table(ctx->old, ctx->level))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +		kvm_tlb_flush_vmid_range(mmu, ctx->addr,
> +					kvm_granule_size(ctx->level));
>   	else if (kvm_pte_valid(ctx->old))
>   		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
>   

