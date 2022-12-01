Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6689B1118
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 10:43:24 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso1157561wmp.5
        for <kvmarm@lists.linux.dev>; Thu, 01 Dec 2022 02:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=34xRbeJm4Ksf3agn72vdHuQrCy+xFaOAkMI20jSUs8E=;
        b=AzHg60UfqWIuniRDwSV0kUn58L84AxRbLj1KxaWUpkExnaz9Jf0mpMJsRIxs0KObgd
         soQ1W7t6DClFqZL5Sz4pVLJxPODSdcfWH2JFiVW2zEBMerlLvjkR1+DJoc4+WpNBKL+I
         PW6xkLEEUmN/Se6yT0vIWJph39WzqIA+SJPH1Jsv7h7dKXsKvjwPoKUClZhTIgXjAbFD
         m9zWUx0GIE8Dv1vkZzsH73Fq4mPpvgYZnpRmT8AL17xzVUC4+XcR3wej4y3vY5DfOIdr
         5pF7L9v5/ffa3NIJyyFg3JxW0kRC69giw2m5lejSbkJhsGZxR9w1oE4BDHpBORKVLYtO
         3/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34xRbeJm4Ksf3agn72vdHuQrCy+xFaOAkMI20jSUs8E=;
        b=WaADpCHETmW6L5nGihdxrSqK67gl3hWxcZorIY4pI6Xr2G75fF2JF/kglRnd9yPGRx
         1h2TQt+WUPze+6xCAN4/0IRgydV+T9TJwYkV+TKxndjE39gCVFMwhfxTtCBP6ntJncsf
         hKQf+2OfFnRO8UTcOhhpJglfb5K+1wV9zcUq2UwwevjU7voz5j0ww8R6HbyHQknpsbZh
         SK/bC+K6v4rd2KCljXAJ0DUqLu5+t9uYpcxasqs/j/31xdjZl21X4PSogk7RIfAsjIFi
         9OoAL2X79/a9qejztwv4eo44yo9VRTt0jp1oNYpYupJmyiHKxhEMLYn17NJOYFT7/th4
         pf6Q==
X-Gm-Message-State: ANoB5pkvSHa40FTqHs7+iK9wKIZLiq9gjh56DwGGR/6enejmacxqbtbX
	iHpJgt93sWiLsvyC3sR9Iok=
X-Google-Smtp-Source: AA0mqf6f8L9W/LFpuxiieU1hwL0SgbBmWKJep4VDP/7W75bGJuJSe0KFg6OoADvN7w7dpRP5siL0uQ==
X-Received: by 2002:a05:600c:1f16:b0:3cf:66a2:d440 with SMTP id bd22-20020a05600c1f1600b003cf66a2d440mr47429561wmb.108.1669891402569;
        Thu, 01 Dec 2022 02:43:22 -0800 (PST)
Received: from [192.168.0.248] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id i10-20020a1c540a000000b003cfc02ab8basm8303094wmb.33.2022.12.01.02.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 02:43:22 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <aa3be096-4f05-b653-b801-e102abe01903@xen.org>
Date: Thu, 1 Dec 2022 10:43:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 34/50] KVM: x86: Unify pr_fmt to use module name for
 all KVM modules
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
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
 Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
 <philmd@linaro.org>, Fabiano Rosas <farosas@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>,
 Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-35-seanjc@google.com>
Organization: Xen Project
In-Reply-To: <20221130230934.1014142-35-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221201104318.wp2ev_mq53bt2ik6CfDrfgBeUZ0aZ8pLgxvuTdRS03Y@z>

On 30/11/2022 23:09, Sean Christopherson wrote:
> Define pr_fmt using KBUILD_MODNAME for all KVM x86 code so that printks
> use consistent formatting across common x86, Intel, and AMD code.  In
> addition to providing consistent print formatting, using KBUILD_MODNAME,
> e.g. kvm_amd and kvm_intel, allows referencing SVM and VMX (and SEV and
> SGX and ...) as technologies without generating weird messages, and
> without causing naming conflicts with other kernel code, e.g. "SEV: ",
> "tdx: ", "sgx: " etc.. are all used by the kernel for non-KVM subsystems.
> 
> Opportunistically move away from printk() for prints that need to be
> modified anyways, e.g. to drop a manual "kvm: " prefix.
> 
> Opportunistically convert a few SGX WARNs that are similarly modified to
> WARN_ONCE; in the very unlikely event that the WARNs fire, odds are good
> that they would fire repeatedly and spam the kernel log without providing
> unique information in each print.
> 
> Note, defining pr_fmt yields undesirable results for code that uses KVM's
> printk wrappers, e.g. vcpu_unimpl().  But, that's a pre-existing problem
> as SVM/kvm_amd already defines a pr_fmt, and thankfully use of KVM's
> wrappers is relatively limited in KVM x86 code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
[snip]
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index b246decb53a9..3bf7d69373cf 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -5,6 +5,7 @@
>    *
>    * KVM Xen emulation
>    */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
>   #include "x86.h"
>   #include "xen.h"

Reviewed-by: Paul Durrant <paul@xen.org>

