Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294A3A31
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 07:18:18 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id cl5so1274983wrb.9
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 00:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D/SNnecemsjQs+W90QUlkgsOD/Rjb4+lDkgjOjEDTCQ=;
        b=jw3d99cvMg52Lg1tLW9BuRNFr97hU8VbjiyM8gochZWG1eGvxYgj4JDJfCZnnjS66j
         2lDmaY49Y9gNXV+0NqqYMPompzAvLelDDyxTDyv63Mzv1FpaKJ2B9UYwTxwc6+9E1fj5
         FJhI1fX/X/YYeQJFY71s0y5YmCRlxUG6ujCNUlpLlY/mY+G8+yumC0FbiEGwNFo+LVFU
         bsVfMxNPq9XriX8IesQE+M4MIPqclT9ZI+C/ooGdqt08Ib6SHWOMYVtcjCYmkNt5Y22V
         kEpFY0C9GTT/VRjoVENUsza65QqqGrehKGm4P0CKYdVEVtyKJm9XwB/y8pqmKkigPrlA
         3XhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/SNnecemsjQs+W90QUlkgsOD/Rjb4+lDkgjOjEDTCQ=;
        b=sHpS8f8DsWFeAu5Br+QxcBFAIgMtQnzq3gy53tZTl6b7iCzdg58UHifsjcrkU7kusf
         lsGWKkGAh4kIwfrDWvtmejB/+WD26VhhZeM+gyysLLgwRJE5ngtmp9InrCjDkSJGhPqX
         wojt3qE4zAhF5R5R0oP+Ekn3xl4loGNdrQOeIx2vDw5ywAWTzBVWmJOWTC+yy8btdsCg
         raRnoAF7I/EmFUrNcB2xcUb3Ffkh7oAhW/2HSBELQ1Zv8zdVnE0FbYiutC0jn6AyYedP
         R7BkbN7KztyvjJ7w8Ylzx3Iz/Hw0bkzlkw2x3rtowubbJ3Hv/VZTzLeDMAtHkEKKMfFT
         UEqQ==
X-Gm-Message-State: ACrzQf1OWgwOHEUvazmZbYzVvQqgB9/1Sy7N3JID7E77cXe2XTPsOC0v
	gWMr1JfrEhwAKzHJZ0VTpcnKMA==
X-Google-Smtp-Source: AMsMyM6jhYnE/aEjYcHXapzofavAu7pX7ddMD038s2P34j/GAHoNYKyfFysuRe52YUvpGlRBEmTO3A==
X-Received: by 2002:a5d:42c7:0:b0:236:4ddd:3576 with SMTP id t7-20020a5d42c7000000b002364ddd3576mr17938354wrr.289.1667459896483;
        Thu, 03 Nov 2022 00:18:16 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net. [88.29.181.216])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b003b477532e66sm6341187wmq.2.2022.11.03.00.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 00:18:15 -0700 (PDT)
Message-ID: <1da0b1fa-ca20-4370-26b4-9f18ab8ac95d@linaro.org>
Date: Thu, 3 Nov 2022 08:18:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 27/44] KVM: Drop kvm_arch_{init,exit}() hooks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-28-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-28-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221103071812.xx96fHwn0Kz6lVlGCJF2I2VC71JwqUz-FxIm64jEs78@z>

On 3/11/22 00:18, Sean Christopherson wrote:
> Drop kvm_arch_init() and kvm_arch_exit() now that all implementations
> are nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/arm.c                | 11 -----------
>   arch/mips/kvm/mips.c                | 10 ----------
>   arch/powerpc/include/asm/kvm_host.h |  1 -
>   arch/powerpc/kvm/powerpc.c          |  5 -----
>   arch/riscv/kvm/main.c               |  9 ---------
>   arch/s390/kvm/kvm-s390.c            | 10 ----------
>   arch/x86/kvm/x86.c                  | 10 ----------
>   include/linux/kvm_host.h            |  3 ---
>   virt/kvm/kvm_main.c                 | 19 ++-----------------
>   9 files changed, 2 insertions(+), 76 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

