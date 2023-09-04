Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0915AB
	for <kvmarm@lists.linux.dev>; Mon,  4 Sep 2023 13:46:14 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-51a52a7d859so5003381a12.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Sep 2023 06:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693835173; x=1694439973; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MvFpohTVYIZg5zZrtXqASIgY84rg/Ko8jDcHzB0T9Sk=;
        b=L1MT2xnoRwQSqaFo1LV3JzFR2AE1bW2AgOZjboI5bqnEizqiVPPaCZEtY9F2UrBe1I
         oWLjIdbWQl9L7Yz2HkYyE8QFfzBXEhWsosDNx6mxHqXzUZOxBrTSNTSR/ZWsa2OigTFX
         lRithJJztXCDhDgvUNK+L8fykHB9viSRxG+J2hZ+1Y/Ig96agQGKj+F127iEOXt0tpw4
         SkgnkdBuKHoJJapKYJtJLgPgiSkUdT6C2Pj2J9k/45UU1hKyEsrl/te99LipUMRuIttB
         Sjar/3mLpOoSQmttQX5t8Jn1cr2K98NSkOwhYRBbz4XokhV50s20cYO6UiENfGsU89ZL
         xJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693835173; x=1694439973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvFpohTVYIZg5zZrtXqASIgY84rg/Ko8jDcHzB0T9Sk=;
        b=SuFk94OKpolfRh/pGyNcipe6xpycco0wx1uifPvvcqVMayPHN7pN2eORNxULpvhQdv
         2Jxtxwtu2tuHAxuS45V1WtVaYj7IkLKSouclt3oqEh70BPK2ICnvfopKyumhG/VA7VPX
         BvSLuYStVRp9u3NrYlhc452vkj7B5y/cvji3RkW5tAouZY7XjXiKKe6ezeAA1ftzkhlN
         0jSSnQll+Wt0ecgUClGVmZaMVjU8QH7gHe+0WosUeJO6Ve/BLjA8p5bJ74c2yAGPWrU4
         x2+EoPuBq9U2EC8fLUXfJQoY5dFluBzeDVEj/XO3PibbxKOVzpp+Eex32hE5Gop0ZPTh
         Zajg==
X-Gm-Message-State: AOJu0YwvfNmgscb21ckGVtXLIT1L5RYxdE4E+Vkn0uaiNJ5FAdcHJ+Zh
	WSULR2LnVeiaAvKel9pLrE93uw==
X-Google-Smtp-Source: AGHT+IEdZjuBxG+ZQHNKrQOJiw6f0psWqsTfKbwqOJ2nIP8Um69rD+e7ovBSZFqMEfeYtMk2y26GEQ==
X-Received: by 2002:a17:906:51c5:b0:99c:5056:4e31 with SMTP id v5-20020a17090651c500b0099c50564e31mr10901921ejk.15.1693835172485;
        Mon, 04 Sep 2023 06:46:12 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709066b9200b009930308425csm6163942ejr.31.2023.09.04.06.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 06:46:12 -0700 (PDT)
Date: Mon, 4 Sep 2023 15:46:11 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	wchen <waylingii@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Greentime Hu <greentime.hu@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Peter Gonda <pgonda@google.com>, Thomas Huth <thuth@redhat.com>, 
	Like Xu <likexu@tencent.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 5/8] KVM: riscv: selftests: Add exception handling
 support
Message-ID: <20230904-c4d2ea8fcfdea6e6722332b2@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <ff41e98a062e0fbb5c2d8dc26d9e4e02c4ce3ea8.1693659382.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff41e98a062e0fbb5c2d8dc26d9e4e02c4ce3ea8.1693659382.git.haibo1.xu@intel.com>

On Sat, Sep 02, 2023 at 08:59:27PM +0800, Haibo Xu wrote:
> Add the infrastructure for guest exception handling in riscv selftests.
> Customized handlers can be enabled by vm_install_exception_handler(vector)
> or vm_install_interrupt_handler().
> 
> The code is inspired from that of x86/arm64.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/riscv/processor.h   |  43 ++++++++
>  .../selftests/kvm/lib/riscv/handlers.S        | 101 ++++++++++++++++++
>  .../selftests/kvm/lib/riscv/processor.c       |  69 ++++++++++++
>  4 files changed, 214 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/lib/riscv/handlers.S
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
