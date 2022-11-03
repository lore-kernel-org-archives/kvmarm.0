Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE97A31
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 07:14:19 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id r186-20020a1c44c3000000b003cf4d389c41so2669162wma.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 00:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Pdpi+9UoXFmBx6WS1nIzeC5GAA4ErfSd67Sd5AqWcg=;
        b=H1aAZTt5omn1creuvv0ovxmACFg4pOnVWmYHZn4E4lfgT71L/+bkBqMdS2VJqi5qOj
         YmATL6SnR5o+XQBpr5Zki/b3eg+7a33Y6+MAjm8hsgmFIym9xbyYuh0hkg0prpG2xE5F
         PuLR8pBfv6BBbgXz9sU9CedCiJ2OZly1K4pMrBC8+JOwPT599bO9tsyb8SJGk4MzThPL
         1kCqwm334cbHc7nOfuU0bDlyQDVQIepbwXFRhrNPfzdSZaSvyNIoq33No6jykj/v3m8W
         r8ppiNCB0xs+LOISHZCIqL+1GiXCOzslnZH2Bev57sQnF5H5kmf2+UwyKku2qWO1cQWO
         MoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Pdpi+9UoXFmBx6WS1nIzeC5GAA4ErfSd67Sd5AqWcg=;
        b=MQKkXlRTX++JjkapEQ1mQq3sKmTHZuZcV+TNML4hMazQFU1R3RLw6icrxX5hIeP/+l
         IoPU1VmPzFBhZhr+dDXIe13PX1ptqDdQKc6RLPp1k9E4f75OWIW/AG+rQV8wM9hYMmoe
         m1IZpBVH9rMixhwZAmrvHhhKzenLK6/XJPObPxEEga0dx8XXswPGw7rxg26vvu0uGNF0
         p75wyC2HWvsEOndy2p3aChyx/zeDXt3xV2gTAVDrSdjI3bnqo48vrcnuh8rgJ5Is24c/
         TEZb4VnKByCctlAis+kUVxtnMYv4OrCXnlfbcFFUtzxncQYq2WdnWz0KZk0diJikc27Y
         LDQQ==
X-Gm-Message-State: ACrzQf1kHrwJ8RhPCTduJvX1ivkfjaEe6/F8k8G7cjkUVN/g+JCgSpBJ
	0+oWQ/zHINqJCmKFcDeXqpC8eQ==
X-Google-Smtp-Source: AMsMyM5MQbAO6gubSSNJTg2fBstLeZi84Spz6yMzRnw+j7KRE9PRabE8XztmxDtlM/M+GTvsQ9gWSw==
X-Received: by 2002:a05:600c:5127:b0:3c6:47ff:5d33 with SMTP id o39-20020a05600c512700b003c647ff5d33mr19212651wms.68.1667459657899;
        Thu, 03 Nov 2022 00:14:17 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net. [88.29.181.216])
        by smtp.gmail.com with ESMTPSA id e7-20020a5d5007000000b00236644228besm34910wrt.40.2022.11.03.00.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 00:14:17 -0700 (PDT)
Message-ID: <cb935198-e2f3-bc9e-a13c-2fa2bf8ea46b@linaro.org>
Date: Thu, 3 Nov 2022 08:14:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 22/44] KVM: RISC-V: Do arch init directly in
 riscv_kvm_init()
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
 <20221102231911.3107438-23-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221103071413.W7CBPuEsgAaIv2NZ0KnTnSEBvJMogWiI4Se8vmVwOcI@z>

On 3/11/22 00:18, Sean Christopherson wrote:
> Fold the guts of kvm_arch_init() into riscv_kvm_init() instead of
> bouncing through kvm_init()=>kvm_arch_init().  Functionally, this is a
> glorified nop as invoking kvm_arch_init() is the very first action
> performed by kvm_init().
> 
> Moving setup to riscv_kvm_init(), which is tagged __init, will allow
> tagging more functions and data with __init and __ro_after_init.  And
> emptying kvm_arch_init() will allow dropping the hook entirely once all
> architecture implementations are nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/riscv/kvm/main.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

