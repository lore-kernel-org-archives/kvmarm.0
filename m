Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E43ECE
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 04:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691554285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc2RrwZUDP/ZLfqGAQFdphKEXcWYocBgrdrh4msM7SQ=;
	b=MOy4Y2puhh9rxJ+wE7myLqtWLPaHgcrIglMMmq70Ip5eqN6U4WGh13drMSr5EUUgV4BD3v
	imrv6q2fbgd2oiFBjRMTQDDlNufrKLK1+R8GgRk8v2eMBK4V4BQl6rU3Xtc5MRVGIyJqou
	ZwiGt7HgPy6gjn4RlaB6U+DXTt0F+NM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-z1N8TvnnMhyM6mUbfQ6q4Q-1; Wed, 09 Aug 2023 00:11:23 -0400
X-MC-Unique: z1N8TvnnMhyM6mUbfQ6q4Q-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-55c04f5827eso4519345a12.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 21:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691554283; x=1692159083;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jc2RrwZUDP/ZLfqGAQFdphKEXcWYocBgrdrh4msM7SQ=;
        b=JRNNajUejCryaoLlJ51Xg2bm0TYS5j+WKRAdx7MrVNVaRJRp/qwLFsDmJ9sHspxWMd
         GXdNR5fvlZpoA0aBvKYt5ddT35EPjtF2qOllrcFgWYoUAN3y6SGmEDeSdSGWu31qdx4z
         2y1JiAae6X1ozEe/WkR6wFqkhNvp674P4g4NkJ2bI/sJ52+QU1NCqcUR3NDSEWiVY6tK
         KCPiT4MSKRcS+GDkKwspKpJDlzaH6q6v1MmmCBsylLEBxzNB4+VuwwZPBgufBkzpDsrS
         UQXJZ2VrcRZSKyTer9D8CGH3czmj99D000XyYRQ0m1Ji3ZUmY/TGW2xIabHCrptacEPv
         zjOA==
X-Gm-Message-State: AOJu0YyOed1T6PoMnogz+qLOlxXXkWpO7mXbknzCtBHTpMVD3tICfHvC
	DjjE6qbYTZtUAXG72aHQO/dHL2ZKp+1korZoikRF/0nr1fd49mB6FTv2UIr1RJHHQnZmGFG6hE2
	pnmeyinRgC+vJnkWr
X-Received: by 2002:a05:6a21:328b:b0:121:ca90:df01 with SMTP id yt11-20020a056a21328b00b00121ca90df01mr1394019pzb.40.1691554282923;
        Tue, 08 Aug 2023 21:11:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuTcKraAGNvme4rsh9nauIBvvaQvIf9BEXJr92oZnpUAljzMU4HrA4zieEd0juLoJJfRohRg==
X-Received: by 2002:a05:6a21:328b:b0:121:ca90:df01 with SMTP id yt11-20020a056a21328b00b00121ca90df01mr1394005pzb.40.1691554282647;
        Tue, 08 Aug 2023 21:11:22 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090322c900b001b2069072ccsm9850474plg.18.2023.08.08.21.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 21:11:22 -0700 (PDT)
Message-ID: <79b8548e-715a-85ee-aad6-cb0b97753df6@redhat.com>
Date: Wed, 9 Aug 2023 14:11:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 04/14] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, David Matlack <dmatlack@google.com>,
 Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shaoqin Huang <shahuang@redhat.com>
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-5-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230808231330.3855936-5-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> kvm_arch_flush_remote_tlbs() or CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> are two mechanisms to solve the same problem, allowing
> architecture-specific code to provide a non-IPI implementation of
> remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of
> maintaining two mechanisms.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   virt/kvm/Kconfig    | 3 ---
>   virt/kvm/kvm_main.c | 2 --
>   2 files changed, 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index b74916de5183a..484d0873061ca 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -62,9 +62,6 @@ config HAVE_KVM_CPU_RELAX_INTERCEPT
>   config KVM_VFIO
>          bool
>   
> -config HAVE_KVM_ARCH_TLB_FLUSH_ALL
> -       bool
> -
>   config HAVE_KVM_INVALID_WAKEUPS
>          bool
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e5479797ac3..d6b0507861550 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -345,7 +345,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>   }
>   EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>   
> -#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
>   void kvm_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	++kvm->stat.generic.remote_tlb_flush_requests;
> @@ -366,7 +365,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   		++kvm->stat.generic.remote_tlb_flush;
>   }
>   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> -#endif
>   
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {

