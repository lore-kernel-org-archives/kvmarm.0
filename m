Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC2F63C
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688517340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9kggeUHVn+fybi/vP4cTbHO7AeLXxPNqVprkHx0Chh4=;
	b=O81tKq8fRI8p+KUS98bkZeL+2EcMSYw834SFyQqs681DLC7biTgM/aKdv09zVSncHYPypj
	0d05YEp+krPQE7WX3RCmlVn60sUrwF2IZ+dJLfDiC5WWgRRcqhySV09PK7AfLdmyj9QVK1
	4ODMTLBTUEgVU5UnGTvcrnzRi1HozLU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-leEEovG7Np-2DM4WzUrvvA-1; Tue, 04 Jul 2023 20:35:38 -0400
X-MC-Unique: leEEovG7Np-2DM4WzUrvvA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b817cda09bso57903935ad.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 17:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688517338; x=1691109338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kggeUHVn+fybi/vP4cTbHO7AeLXxPNqVprkHx0Chh4=;
        b=KsRMozgF1MmOSnSj+IaW6+MPQ4GnOh2DSDGGxmY8oF1BETs6zt9ua3T4SGuG+HA2Qw
         cz9hP2ajYJa8UP/WtwDfLRsUDjpQvPkIuZFIaCzBgNocEPUZV0D2La/T69484XCuIiyx
         Up50zSKtqabfVnW8qiKVkzhXGQWYFf3qv0CnTYTE2d9pUJFgyAHqpzkrztLDZoGZpLSq
         aoLtxB9WHhBrNdgBxYWBlqeuKaqt1GBfklcD9ZqNNI5tK0jMO3v+C1ZtU73ZtnzC5aDz
         Epesbzrhj3Y9KTqg7lYikgZvFihJ4FFK5ckXHBbrvVWkZJH4WfrhDZMPvZT9QjU7jV1/
         U0mw==
X-Gm-Message-State: ABy/qLbYa4s80w2Ry+WE7AJ5KfuYN9R7QwfE9hu+kmQqG3Tvp7BE1F2y
	XJg1g5SkgPBtwlfX69yn9zwKcGKXZRJWbHKwdtiZJm2HLQYsKllBv+actdCC7MgGmI4VWTHpQ5U
	+vKDxdWhjuKuNavRY
X-Received: by 2002:a17:902:dac4:b0:1b8:9195:1dd8 with SMTP id q4-20020a170902dac400b001b891951dd8mr5383567plx.51.1688517337913;
        Tue, 04 Jul 2023 17:35:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG1dv3HBeoyb27A4Q9lu9hw82Tk11vqBX4veNPK7IWmCWzA4mOu6o5korMa8AFQToKad6zjdQ==
X-Received: by 2002:a17:902:dac4:b0:1b8:9195:1dd8 with SMTP id q4-20020a170902dac400b001b891951dd8mr5383559plx.51.1688517337630;
        Tue, 04 Jul 2023 17:35:37 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b001b87f957ba5sm6601048plb.12.2023.07.04.17.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 17:35:37 -0700 (PDT)
Message-ID: <73a4655a-2c63-3209-1153-2fc816e8990e@redhat.com>
Date: Wed, 5 Jul 2023 10:35:28 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 09/11] KVM: arm64: Flush only the memslot after
 write-protect
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
 <20230621175002.2832640-10-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-10-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/22/23 03:50, Raghavendra Rao Ananta wrote:
> After write-protecting the region, currently KVM invalidates
> the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
> scope the invalidation only to the targeted memslot. If
> supported, the architecture would use the range-based TLBI
> instructions to flush the memslot or else fallback to flushing
> all of the TLBs.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c3ec2141c3284..94f10e670c100 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -992,7 +992,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>   	write_lock(&kvm->mmu_lock);
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
>   	write_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   }
>   
>   /**

