Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E8882F
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688514889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mna+dhhTYjAdqDBDtMfl56DYIGVzwso+E96k6VKVls0=;
	b=VWPKGZ6RXwA0INAHsuI+jOYafyeRKR7e1EjSx8JCUkuFlJGGLjXX566G2Qi2+lLUudeNmG
	DZnnpeKyM8WP471WHZ4PU3fj3sWpNpiRQiiCjoD44Og5BXWvwXR0F7XXNCcdDG0X+7Tg+I
	9TXyTNuqH8sb8qhrkF4FKc6lNd1NVH8=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-sboBo4I_OSOUFw9xGgRBAg-1; Tue, 04 Jul 2023 19:54:47 -0400
X-MC-Unique: sboBo4I_OSOUFw9xGgRBAg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a044f9104dso5179469b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 16:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688514886; x=1691106886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mna+dhhTYjAdqDBDtMfl56DYIGVzwso+E96k6VKVls0=;
        b=jnHBx+JC0E3FOxN1gJYL5lhprOPqGvyVdMIDj84CCAH9XrdUTfLeEmtHCMbonLcyWq
         YMBOuowxt4ousrRuFA8lurs1PEVtyXpnShc2AQeLR5aPT6J0NB+B/1KJfFClnWdfB+yW
         wmSzpbL/7cOKrM9yugTmAp1bZBEqgrfoVxxUfe4STZ3DBcvpnf8csbZXNrAY7yj8i4Ue
         CG11zkj6i6RFp35qKJRTFY/MIYKLZXOsYGDhqBZ7SHRu1efH2MinwbII9StdNE7Nx9AQ
         vwuTpmFvRB2YJ6wdD+y4LuIM5fEoQbP1++3rkazS6Xq4p+HPeeQoex6qPtJttQ2FdBSa
         KbUA==
X-Gm-Message-State: ABy/qLaSl2/TZEhVeXYSA8czsJJ92j+C6Fwrus8D9tPjLQ4/aIq32KIN
	oBHoGCcFI0WjfW1VLZuGYjAk95ZjcfzWLBoR3F/n9+1J+OwX2J4/9PMnoPnsQdc166eUtkDjrMR
	BkcIgxkPcivdfTH+h
X-Received: by 2002:a05:6808:1a17:b0:3a3:a8ce:c659 with SMTP id bk23-20020a0568081a1700b003a3a8cec659mr9277915oib.1.1688514886545;
        Tue, 04 Jul 2023 16:54:46 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEnYXHnAZgQaIRTnEPMZWgHY6PvyvdCKGOrf+hZuU/jzXUZFjXk6Vz5A95OweIIvkeHyw48vA==
X-Received: by 2002:a05:6808:1a17:b0:3a3:a8ce:c659 with SMTP id bk23-20020a0568081a1700b003a3a8cec659mr9277900oib.1.1688514886348;
        Tue, 04 Jul 2023 16:54:46 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c20200b001b03a7a40e7sm12047419pll.19.2023.07.04.16.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 16:54:45 -0700 (PDT)
Message-ID: <a0e4b07c-dea8-e45e-7bc8-588f8cbcb537@redhat.com>
Date: Wed, 5 Jul 2023 09:54:36 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 03/11] KVM: Allow range-based TLB invalidation
 from common code
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
 <20230621175002.2832640-4-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-4-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Make kvm_flush_remote_tlbs_range() visible in common code and create a
> default implementation that just invalidates the whole TLB.
> 
> This paves the way for several future features/cleanups:
> 
>   - Introduction of range-based TLBI on ARM.
>   - Eliminating kvm_arch_flush_remote_tlbs_memslot()
>   - Moving the KVM/x86 TDP MMU to common code.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/mmu/mmu.c          |  9 ++++-----
>   arch/x86/kvm/mmu/mmu_internal.h |  3 ---
>   include/linux/kvm_host.h        |  9 +++++++++
>   virt/kvm/kvm_main.c             | 13 +++++++++++++
>   5 files changed, 29 insertions(+), 8 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

