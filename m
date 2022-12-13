Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC9C28F0
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 09:47:27 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so7421340wmb.2
        for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 01:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUffeOkZJV6CbBOjXRvBE9aKOOUHPUai9QNqwF2Rw6k=;
        b=s1JH0apqKbSMIxIiwVTiEGvWlt6voHGA0Qg93k6bu0bo94Xy2pc1rgrx+aKZpEtkx6
         tAkY+DS3eAY/MbbRYxforucS9NjS3Y/J+tyLt2y4zma1TERO/0grq5KMq0vq/JPyZFBz
         uuzCElIdsA0WjdkodayUEVOjRvLIQMBQqZyE+ugj5nJLcFiHRq0Adeoz1JxR/vw5valn
         M6ePXoLF+ntrgyqEb+FWCTpZ/Y72s2I7CfUH8aDCBnPG2ygVESeMtHM7BOVqZvMx+DrN
         +34OyPj6HJPDo1O1oBSY+duAkwoi2k2YHG0FzskbkMhvLtYA4PBVWcLfgYnkAWBL9chR
         D2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUffeOkZJV6CbBOjXRvBE9aKOOUHPUai9QNqwF2Rw6k=;
        b=MQcK7GVRu1PDhWSc/3U5N5Ce5BXhvs5pRgej1g+1PSluuh2f70cMBXKYkhbrq8KYe9
         uvRnQUnrroUhdKmvyb9Sci4NO3TXBUzCvpT+1JgWBi9Eim5R10/FmNF7oyO0tzyAvBdZ
         tcXe0jUb/JB1b9a7MgHW4u4cuTqzVQRkl1jnT/iRgJfuEAua1eG15ZEf6Hl/iqlGKDRu
         6/zoH6jMaHUnqDcB3dMZWoenGGXLydLZ7b4eG3Xn02HYrPSUX6l5AW3ND9d2LPqZscGt
         rS7xboWQn0/YqI4QpKbnZ7mHsgk0klgdJibRe4QM9pkR/n9X1c87u/IcAWCRtYcGUgEd
         v7qA==
X-Gm-Message-State: ANoB5pn+SBV+NoqG+ctDSkI7Cm9jsfo1XCF91DzW/tr1TOd+1fca710P
	vqz1WWLrnXvKmamkrYUH5LvSow==
X-Google-Smtp-Source: AA0mqf45B8663eyuUa7gYYZoZljx5xDAypBaIEMtrhbpuNigeolIoqaS3rVH+IjTq+i8TltLJF+66w==
X-Received: by 2002:a05:600c:a54:b0:3cf:a41d:844b with SMTP id c20-20020a05600c0a5400b003cfa41d844bmr15253803wmq.5.1670924845957;
        Tue, 13 Dec 2022 01:47:25 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id ay13-20020a05600c1e0d00b003c6bd91caa5sm12602817wmb.17.2022.12.13.01.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 01:47:25 -0800 (PST)
Message-ID: <2505189d-c682-ed70-442b-798c258d3b68@linaro.org>
Date: Tue, 13 Dec 2022 10:47:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 05/14] KVM: selftests: Fix a typo in x86-64's
 kvm_get_cpu_address_width()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Tom Rix <trix@redhat.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
 Aaron Lewis <aaronlewis@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-6-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221213094723.hX1obvCVoQtKqWukAaCnFPj8G4-LM0iJ7eIAIuOJZlg@z>

On 13/12/22 01:16, Sean Christopherson wrote:
> Fix a == vs. = typo in kvm_get_cpu_address_width() that results in
> @pa_bits being left unset if the CPU doesn't support enumerating its
> MAX_PHY_ADDR.  Flagged by clang's unusued-value warning.
> 
> lib/x86_64/processor.c:1034:51: warning: expression result unused [-Wunused-value]
>                  *pa_bits == kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
> 
> Fixes: 3bd396353d18 ("KVM: selftests: Add X86_FEATURE_PAE and use it calc "fallback" MAXPHYADDR")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index c4d368d56cfe..acfa1d01e7df 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1031,7 +1031,7 @@ bool is_amd_cpu(void)
>   void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
>   {
>   	if (!kvm_cpu_has_p(X86_PROPERTY_MAX_PHY_ADDR)) {
> -		*pa_bits == kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
> +		*pa_bits = kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;

:)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


