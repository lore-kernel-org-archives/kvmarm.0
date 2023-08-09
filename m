Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC802A52
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691553634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQlmNO2lLhBYx7/A3bGLPPLUydSYqDE41nBYvmLEPYg=;
	b=CojlntDlMjVaiWEIejl0cRs7F6bsMBN398zMGZQndvWxqpiJGNi3mFJPnHQajQtuTGpKf2
	+Yk75pqCEKZzWqEl5dp3vm5NM8+ADglQgNGAYuupc9VJyy++/5iMpmRoXn0n/lTg8PEf0b
	VnjuS6Zp6ZXdP0ISy5hyyhmAgpgKg5o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-5Od_c_b8Ndm_Z4hi1iZKww-1; Wed, 09 Aug 2023 00:00:28 -0400
X-MC-Unique: 5Od_c_b8Ndm_Z4hi1iZKww-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-686ef3d5ab8so5133241b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 21:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691553627; x=1692158427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rQlmNO2lLhBYx7/A3bGLPPLUydSYqDE41nBYvmLEPYg=;
        b=fB/VbRQX5Uds3kuyX/ass6ExkoBFS58L7HVOR5nYRjRm7K2UtPASsMFB7VbQk2hAwq
         oPPA37J6SfiecqZKr43+NuOr0wsVnJ5YiiBfHVMkXZj2cJf6ucmjtum0XcE1zf9u/BwY
         zOwyvCuitayQ4iAhGz7xrnCk17zfJjGbRjLnTspZem/hANImIrfadj79PN5tyavWEFDY
         d751SIC7UVcvMFTjc8AVW55lIOAasdzex1MK2CQdeoIoFG9CBBlJQXQdePfOcypgZ4Zw
         byPMhPO7IkMILhycnAIkulAk5BMc1lZoBnleecajmZwQZxA3gFmdffkywqJKrs77XL3j
         y/GA==
X-Gm-Message-State: AOJu0Yy2jGr26SCFQ04YDtuBZdfo31Q5FWdlrTs1VVFHNFpsTa9LTJqF
	9A95SJd6zVn6578m5t9PqDdIirgiQkZiVtkFDMWRc5oEB83ce085sR+fmkHmHmOxatIjYrWkR8N
	s1JE+gSHpnUeqjxw8
X-Received: by 2002:a05:6a20:2c98:b0:141:d54e:a907 with SMTP id g24-20020a056a202c9800b00141d54ea907mr938662pzj.19.1691553627004;
        Tue, 08 Aug 2023 21:00:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOvufvyUoufFYXdfEuvYMIQHRTZK4zZPGr4dTmruEN2n1tJuTAm2AE/WhYVDypt5ObnuK/mg==
X-Received: by 2002:a05:6a20:2c98:b0:141:d54e:a907 with SMTP id g24-20020a056a202c9800b00141d54ea907mr938627pzj.19.1691553625804;
        Tue, 08 Aug 2023 21:00:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902c3c600b001bc930d4517sm470398plj.42.2023.08.08.21.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 21:00:25 -0700 (PDT)
Message-ID: <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com>
Date: Wed, 9 Aug 2023 14:00:15 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
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
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230808231330.3855936-3-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> There's no reason for the architectures to declare
> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
> avoid this duplication, make the declaration global, leaving
> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> as needed.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
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

Is the declaration inconsistent to that in arch/x86/include/asm/kvm_host.h?
In order to keep them consistent, I guess we need move kvm_arch_flush_remote_tlbs()
from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs to be dropped.

Thanks,
Gavin

