Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E9FA56
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691723913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiI+QsxMTBs9vA9vlC+ZyswANJfDDGFtsPp4BYCBVbg=;
	b=StEEFzzG3862GLAF7SiQthLuoO7p7Aio1jiXwNF1oFey2icr81eEA4461RMWpaLYR2sFRY
	tByJwjf7OxT1nzkSe4gdQ24NL4U3mOPHV6vu7uHPhVogz94p99jPp1sqmE/OHLX0B+zcfu
	RHVa9uWgE3J63dhpcEQE8jeFwVSTEhI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-Q3pl3WLaNbGxzvB7MaKSvw-1; Thu, 10 Aug 2023 23:18:31 -0400
X-MC-Unique: Q3pl3WLaNbGxzvB7MaKSvw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-563de65ac5dso306031a12.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723910; x=1692328710;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PiI+QsxMTBs9vA9vlC+ZyswANJfDDGFtsPp4BYCBVbg=;
        b=EnN/Tk4LVXM8oU1K9mycfSIB03aVR4Sj8LEUZI327+T0rTi04V086zNbhQ1YpeIpGO
         DtrBLoksyDPoAq3spTva4CjPnUjOk3t05G8vtkiRXG2K6rt2vcgfj8W4FYTuNvKDUqrO
         LdLYGUTcAPEu7VrS0CcRObknqQ70e3XLpBn2Xtlk4s7YBN/y0pNKY4qHpuJAYXjRGn2D
         PhA0GKLd1Hj0RD/qpX7lKe9JHDJnQEzJTTSory6rqBV+Tn6XhiQcYBjTVjyiXLgEwvzd
         y6tUDWHtyw5nCXM0GkDf92C2GJTg6TwU+5ZwRHS/nNwnPOQRn8cFR9SE3qsbMgeEk93u
         8UvQ==
X-Gm-Message-State: AOJu0YyeJW8zUV8hc48EOqdyyMU9XY8KXzo0Y7WyGiFUHU8w3NF2SLX1
	Nyzi7Kh95Sn0rwWQ2ryymRvEFEiVbDHNpiA41RwBH0hxZ8AU3f81UpJG+5ZlUwLnNejRmt/bNT6
	iE7STa3R1aRfst5P5
X-Received: by 2002:a17:903:11c8:b0:1b8:17e8:547e with SMTP id q8-20020a17090311c800b001b817e8547emr828128plh.1.1691723910733;
        Thu, 10 Aug 2023 20:18:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHID5R08qiLj5A7MSG7B2ILJx/BX/BiDQni1fswd5I7LC3NtLSpgFqmDqjcNklr7RUUka6Afw==
X-Received: by 2002:a17:903:11c8:b0:1b8:17e8:547e with SMTP id q8-20020a17090311c800b001b817e8547emr828095plh.1.1691723910468;
        Thu, 10 Aug 2023 20:18:30 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q22-20020a170902b11600b001bb24cb9a40sm2547142plr.39.2023.08.10.20.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:18:30 -0700 (PDT)
Message-ID: <60d1a498-2815-2465-ccc9-e4464791a3fb@redhat.com>
Date: Fri, 11 Aug 2023 11:18:23 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs()
 globally
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
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-3-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-3-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
> There's no reason for the architectures to declare
> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
> avoid this duplication, make the declaration global, leaving
> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> as needed.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/mips/include/asm/kvm_host.h | 1 -
>   include/linux/kvm_host.h         | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 9b0ad8f3bf327..54a85f1d4f2c8 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> -int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
>   #endif /* __MIPS_KVM_HOST_H__ */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e3f968b38ae97..ade5d4500c2ce 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	return -ENOTSUPP;
>   }
> +#else
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   #endif
>   
>   #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA

-- 
Shaoqin

