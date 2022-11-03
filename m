Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E40A31
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 07:11:03 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso529563wmp.5
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 00:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CvhsZshQWEcVMeUTUtOp+ihfqDRpu56SkXuVG8Len34=;
        b=kHZDPyIo8df19dqlQHWniGoyDch8A+hISU8X6gd7fp1VbScHETGhbytjJYmkhLQHKf
         fwi1nthEtQPwse9uctHll81mNdW31rmNNRadEcJOVs4CiYzIp2cFwfJ+eDzavRkFrV7o
         df5jmaTAaQvLc9v1sSmbABx4C5Rzw1nTgw7iXi1sO9xpDPFNsNp3LKzpz90wTIQNwZ1t
         Ho+YhWAPx1xMmOMWNMoEs/sIV1YU/vXuH0Fvy5rAwr8dsko79NvLMAybJkyUdKsceRMO
         iXCBxeebKyqxkZinLCfgL7TweGZd1asuEGHKg2vBla0voczqpexKdljfuec7O93BtHaM
         wjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CvhsZshQWEcVMeUTUtOp+ihfqDRpu56SkXuVG8Len34=;
        b=yQdtTYT276BFOkVKiqAcTvjFNW+etFD4SQYh72Ypt/rKjsGtwpE7uQwrpQg2vNRWiz
         dYBUQlBNc2bzoRCiNzJswHWDakVt1iS/DvjrGS5Q3zZACEM5Int66f3l8uOX43yhUCIX
         AsXFaRNGuH9ccTSlHsoFc5rdFe1pqCndRqIdmuWw2oDa90BzVvX1i5ELQYgh6bcBn20N
         ey5O8+ZLQSuTTbuqnrlL1+H9ZrLi1TIbiMdzR9HrhEfLJoE/qn3j+MmNsAiPciV6ufIF
         XfcFKDzv2pX0Q6eFAAX/4JJca9zPZiqdFATka0kU2/Njt6/APmJeWHehpedT1mVPn7wd
         jxsQ==
X-Gm-Message-State: ACrzQf25DNobLE6iTjd2FQRtzy5oymuZp0Psj01reuCXD7dskJ20CRtd
	Cfz5DKng6OfAAiw/KQQ/AXo+ug==
X-Google-Smtp-Source: AMsMyM6OzoP+QUJ8ptlTPBD8IHWudpkYNFjUBgo6cbOLfKoB/+Q6j9ksVTjQt2XeCIsVj6BjOQ3zrw==
X-Received: by 2002:a05:600c:1:b0:3c6:c456:f07a with SMTP id g1-20020a05600c000100b003c6c456f07amr18797697wmc.158.1667459461681;
        Thu, 03 Nov 2022 00:11:01 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net. [88.29.181.216])
        by smtp.gmail.com with ESMTPSA id y16-20020adff6d0000000b0023647841c5bsm17017wrp.60.2022.11.03.00.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 00:11:01 -0700 (PDT)
Message-ID: <e844905b-3775-b89d-8b19-0a1c2e916432@linaro.org>
Date: Thu, 3 Nov 2022 08:10:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 20/44] KVM: MIPS: Setup VZ emulation? directly from
 kvm_mips_init()
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
 <20221102231911.3107438-21-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221103071057.ts6Gsub-hrbsuxLgj78qtUGowhG0LYDoAGDrxDqA6oI@z>

On 3/11/22 00:18, Sean Christopherson wrote:
> Invoke kvm_mips_emulation_init() directly from kvm_mips_init() instead
> of bouncing through kvm_init()=>kvm_arch_init().  Functionally, this is
> a glorified nop as invoking kvm_arch_init() is the very first action
> performed by kvm_init().
> 
> Emptying kvm_arch_init() will allow dropping the hook entirely once all
> architecture implementations are nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/mips/kvm/mips.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

