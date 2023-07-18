Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C21FD8
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 11:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689679057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OtPAFim1cDpcp/PLXUaQwLiMk8Vxwyxo/NiSi3JW/f0=;
	b=Na1vgKloy740OdgWskxt8P7Fosy1DDCe4VuZfVapyj54CMIewjcLhg0veSIPoibaAl/Mod
	e+ejvHFdP2PsHpbGyRPWjCbuJX/sHLZa4hgW7S8AVQfmOCdz6sAw1Ue9Nfi2OUj2jlvmum
	/7PRd9gk1acjmuHdeTHIVdBRI5RP2k0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-x4NFo_HlOkm_h5VFC4rkpQ-1; Tue, 18 Jul 2023 07:17:34 -0400
X-MC-Unique: x4NFo_HlOkm_h5VFC4rkpQ-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-553c68126f8so771624a12.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 04:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689679053; x=1692271053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OtPAFim1cDpcp/PLXUaQwLiMk8Vxwyxo/NiSi3JW/f0=;
        b=aYtX6xNzXtkIYnz2ND+AJeOSHsbOtfcvhjG7GyZxgckaRLuyR78nuUNw6nWoPHrZZi
         6C9Ha66OPwGwCXNBhNBQdZCrbVQXXwxpSA647akRkAYmqesZ3S2yRn+PBKXxynw5Kh7R
         jsVss9B9E8X2mCHtmzBoFGrFk6j1Ql4w+/RfmctHiQyIIZgL9H8O3Chp4E6Ef+NkvqYd
         EuBDh3qzkGr8hi+1540a1QpejOaZ+MtFcinFYQS/xzVcP8keZlTcOP1F88eSltUDpZzM
         cS49LcYbWymPyVzO/DzcRC/YWtgDtnLdQXGp70vMrNSw8Fqj1sCi9R7DAG/+vwD1S4pW
         hdGQ==
X-Gm-Message-State: ABy/qLZWqiztLTWASq4y9aIX7toGyw9ue7eX7kFoGpXv2SsYBACvYGfr
	Yaz2D+DGCO0vGdQr3/5tIdq2twYBN8nMEtOyDVfzAz9LllLQGoX4KH19O2956a5F5qa9NlSuVkv
	wuFvMxHK50Ftnt3vh
X-Received: by 2002:a05:6a20:3d07:b0:133:89e:bf1a with SMTP id y7-20020a056a203d0700b00133089ebf1amr12988287pzi.4.1689679053259;
        Tue, 18 Jul 2023 04:17:33 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGlX4aGknKfPCjhtPs4zbhCwYUKXUWNkmQcI4lBrRW+0354cqKkBfpbN1eJEAJfM+P9UQWRbQ==
X-Received: by 2002:a05:6a20:3d07:b0:133:89e:bf1a with SMTP id y7-20020a056a203d0700b00133089ebf1amr12988260pzi.4.1689679052990;
        Tue, 18 Jul 2023 04:17:32 -0700 (PDT)
Received: from [10.72.112.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k22-20020aa792d6000000b00682868714fdsm1369203pfa.95.2023.07.18.04.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 04:17:32 -0700 (PDT)
Message-ID: <a8a43069-ca4c-07e6-3b65-de749f295365@redhat.com>
Date: Tue, 18 Jul 2023 19:17:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 10/11] KVM: arm64: Invalidate the table entries upon a
 range
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
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-11-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-11-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
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
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5d14d5d5819a..5ef098af1736 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -806,7 +806,8 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>   		 * evicted pte value (if any).
>   		 */
>   		if (kvm_pte_table(ctx->old, ctx->level))
> -			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +			kvm_tlb_flush_vmid_range(mmu, ctx->addr,
> +						kvm_granule_size(ctx->level));
>   		else if (kvm_pte_valid(ctx->old))
>   			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
>   				     ctx->addr, ctx->level);

-- 
Shaoqin

