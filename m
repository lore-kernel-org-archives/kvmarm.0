Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210C219BB3
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 09:04:19 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3fe4b95c371so3535895e9.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 02:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691658258; x=1692263058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRRGt270hpgqI4zE1zgSatf0+H4Bh/F+VZZfxHZMxJQ=;
        b=oAEb/UVBkppyVSOHobReOPQ5YTJ38GSYmmwnXKvWBacyY35eiBK3BbweF9r2wySUml
         MEcisqaWbMu75RD/yi2+TApQnL2dFNUOP3LxnRpHcOKij/GZo0w0ruS8u+2sRfizq7K0
         RXpbZa5ou88CCBGxGOuZX1JLIdZicfZdY/CT8cY9pTtnS0KjgGk4/lotdDB2sxhQlLsF
         KS8SGcoWUwYCt9WiECBncj/W3XO/pC9wzUYaNE5W9koIsUJNRDyCxnF+WlJ36Zyyu8gs
         E3wn44pqQEnSVjV3WUZmbwDcfSycWhFbxh8XhXu2aO73sGromowt+6Napedljzo4dNil
         4yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691658258; x=1692263058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRRGt270hpgqI4zE1zgSatf0+H4Bh/F+VZZfxHZMxJQ=;
        b=AZPncWtxc733IV8wAOlK4sXQQvIevR2gHgQGNGOpJehJnKW3WdvXkzpnxbWt/vGdUD
         LIg93lwmRn3YuP8TNe1d+jEOwqwVCGZc/i8wL6bo7Kl9x27lXdsK4tX7cQkMjoo7seJ7
         o1KGcEUi9axZ2ch0eviixz7RhlbjJ1TaYX9Jsr8FvBvMTiyEphQHusPFFgrz82x0i8KM
         m51vwdLPixDAc+PBNMQ+3J34nmSX+yuQWZ76pOnxJ6TLq1bBBk4XdFLjObj6kjYbc+eS
         4HRvFk42WpBVrPTlH0CYncgeWqEF4IwiVxVoCXr0TrczeAYQGSlizC6/HtzANW8nLRg3
         LcSA==
X-Gm-Message-State: AOJu0Ywe4iEDJ6hcWhXPP8iXz8G3vERTvldg8qJ4j09QX32rDvyfJKYW
	+uNMKy60GWxx3plWLQFaQwWr9A==
X-Google-Smtp-Source: AGHT+IEiyf6YzfxC02ypY0/hlAu3sZVgflth6mGPBaBQxUAqtG6jM0o50UoMEa2Wxjr8BGf/HBWSdg==
X-Received: by 2002:a05:600c:4fc8:b0:3fe:2120:eb7c with SMTP id o8-20020a05600c4fc800b003fe2120eb7cmr1225438wmq.0.1691658258110;
        Thu, 10 Aug 2023 02:04:18 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.158.65])
        by smtp.gmail.com with ESMTPSA id m22-20020a7bcb96000000b003fe2696ccfcsm1464479wmi.23.2023.08.10.02.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:04:17 -0700 (PDT)
Message-ID: <a645ce3e-dd24-8c06-5898-76f78828b608@linaro.org>
Date: Thu, 10 Aug 2023 11:04:14 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v8 04/14] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
Content-Language: en-US
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230808231330.3855936-5-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/8/23 01:13, Raghavendra Rao Ananta wrote:
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

