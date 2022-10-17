Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A0D4A01
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 20:29:05 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id f11so20235494wrm.6
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 13:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2IMN4gNjwV4VBWuOeqMza8Wt49qGerSXwLQ1YGSitwQ=;
        b=TfXUu3s3qPV4BBT6vUGPxy6HpB9PG2ZD2y1l3c2QXrIu1MWsxtsSLwLNDj8Acjj8yW
         cyoG8RY42PKQGfiRexZWYj7J8bC4CzOHlPB/rHA5h+VHyDvwcdCLnmdgCNblVLh72YKv
         5O3TI9GDMvomgZmofAhXoSKuvR+zWupriTph78/f6/2buTzKwHFRo9LYtuKcQHQ6n2cs
         j08hsgu8oaZlbHfgRNvVONrzAPIrxiizspwD1bXhxadA0mu5TmK95gDAmpbbq/iwVpO4
         75+r9Xo1vY34n1cJi7k/mvuiN/b7aaQWdezdtBdhGolFkq3iEwNY/ImbCS5q5uPw9GLM
         uArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2IMN4gNjwV4VBWuOeqMza8Wt49qGerSXwLQ1YGSitwQ=;
        b=IItCTDkMB0HjGJ7bTjfWlrbwnWznGyiDMQWH/XViB7kaaqiv9MyWkcG1gfxpF90gXD
         P4j1ldFgc9me/8sI/Xd6EtGZYJ2ZJh7XJ8kXZo+9VcqlFFJYuk1AVMrgS+cPauvn9wbN
         MEqVoAVZbBpRyapPT6pYce+KYSoHIWkDxQvh4QhTeshCDUcmu7tTMCW36fxLRUQTG8oI
         TB70xUApY5opUGBEsV/t/EDbEf/aPxpmIqXc6x/9lbnajfRjn2jgYt3Ysa1GjoUJ04PI
         Fijeqcsyk3FgM/XoXts5iHGVb0jrVV3pvFbra/7GCj3jLL2N84XQ45nkyyz3dYnnn+/k
         K6sQ==
X-Gm-Message-State: ACrzQf1PJ8vEbg7sYmk8fsB8c7r8x1WPew31nQYmGhxDpYG6f6rgu/ib
	1K1rdbi1wPD2Lt+BufTX5JoADQ==
X-Google-Smtp-Source: AMsMyM7XmTQpO4YeME5joK/zSjPkgmYYjt4bxua8latURAc/NNVTbtvNDtlwT7WmJWFatkJAib9PcA==
X-Received: by 2002:a5d:4150:0:b0:22f:f9f6:cca1 with SMTP id c16-20020a5d4150000000b0022ff9f6cca1mr7468159wrq.510.1666038543810;
        Mon, 17 Oct 2022 13:29:03 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id m2-20020adfe0c2000000b0022e6178bd84sm9546712wri.8.2022.10.17.13.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:29:03 -0700 (PDT)
Message-ID: <baa1094f-227a-96bf-8bf7-f7d0d094bec4@linaro.org>
Date: Mon, 17 Oct 2022 22:29:00 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 01/25] KVM: arm64: Move hyp refcount manipulation
 helpers to common header file
Content-Language: en-US
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, James Morse
 <james.morse@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Quentin Perret <qperret@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-2-will@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-2-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/10/22 13:51, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> We will soon need to manipulate 'struct hyp_page' refcounts from outside
> page_alloc.c, so move the helpers to a common header file to allow them
> to be reused easily.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/memory.h | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 19 -------------------
>   2 files changed, 22 insertions(+), 19 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
