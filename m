Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F0415AB
	for <kvmarm@lists.linux.dev>; Mon,  4 Sep 2023 13:48:24 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-99c1d03e124so203654566b.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Sep 2023 06:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693835302; x=1694440102; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h3fvlfFXn3XSbLUjhzD0K7O7WyFDtRiY642hHRw1Uek=;
        b=h1vTJNBoSKg9hUI1d3n8FNI3p80UgQbLnA0ILC4B4QKf6ftedtkm447k5B5jPvX7S3
         LmekgrwbUJj8GLP8l3qbs5nHpVrIX6eotzr+nN6h5hMFN1/Wryha1ckyKx+Kpbk78zB1
         SHPerKK7BXyPKd+/rh3JfbM0yRwLjVXYdMLk8JIOtryixM1n1PZHBq8tuboEbcn3VyWs
         kyPIah5JF4cfVsVrT7vs5tQ9nJRjnXbVkLrEvc1UrdBJfwoW2N0AN1Grx4cdlD0WSohQ
         kpBpqn6ZhvNISMlaSTeTm/rIWkjbyvlI0kkbSoZVPgd38KK5/uncApSofooREoPTHPSs
         3PiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693835302; x=1694440102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3fvlfFXn3XSbLUjhzD0K7O7WyFDtRiY642hHRw1Uek=;
        b=Q2xDovIjhbDYfZVJriJ8woLmCxYOEVABQz9sB+JNjkEm9ypCPcib/LNa3FZ0oeIzGk
         zOBWaIAP6GBgN3+Egi3PJIl1RfzQeewZE/4IiN8OJ2A47TRk1HXl9CUTN21NruVMf9hM
         zQv6t1kjvuETmDvmgmoOQVBYm0JgYlEo7FDpipsXP5b1qyVaFdFkFM6VXhVgG6flzA+r
         joeH5taArMmStA+BeHzKksvRbI9r1ibBhO6xf+Y68u/Yu7Eo4SQdNUjqTDQqr/qcN7RG
         16ia5/xZ+syTLwNa68vnNLHksn/4sJwu5Vm2ozOu0AndScDSgaV/220TQbVxOXPNegUi
         FnCQ==
X-Gm-Message-State: AOJu0YwS3S/fxuCWOUhc6zPZ/9CDalHdBcBjhohIGeykJuY7IGePNNiF
	JxAUm0Bcei0RTHI8+QSTmeFadA==
X-Google-Smtp-Source: AGHT+IEdmuQ6wKTsIKPR4BXTBtwQWbUG0Viumxey9/oZVxntWMhJSLmNtJQgpZUnWcUIixf4ahyhVQ==
X-Received: by 2002:a17:907:2e19:b0:9a1:ce57:8e47 with SMTP id ig25-20020a1709072e1900b009a1ce578e47mr7114400ejc.68.1693835302263;
        Mon, 04 Sep 2023 06:48:22 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id h26-20020a1709062dda00b009a1fef32ce6sm6233554eji.177.2023.09.04.06.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 06:48:21 -0700 (PDT)
Date: Mon, 4 Sep 2023 15:48:21 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Greentime Hu <greentime.hu@sifive.com>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Lei Wang <lei4.wang@intel.com>, Vipin Sharma <vipinsh@google.com>, Like Xu <likexu@tencent.com>, 
	Peter Gonda <pgonda@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Thomas Huth <thuth@redhat.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 6/8] KVM: riscv: selftests: Add guest helper to get
 vcpu id
Message-ID: <20230904-db7e8ba933a271ef6aafa4b3@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <23d13f60b5a2fd31b87ae78458507f46442fac3a.1693659382.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23d13f60b5a2fd31b87ae78458507f46442fac3a.1693659382.git.haibo1.xu@intel.com>

On Sat, Sep 02, 2023 at 08:59:28PM +0800, Haibo Xu wrote:
> Add guest_get_vcpuid() helper to simplify accessing to per-cpu
> private data. The sscratch CSR was used to store the vcpu id.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 4 ----
>  tools/testing/selftests/kvm/include/kvm_util_base.h     | 2 ++
>  tools/testing/selftests/kvm/lib/riscv/processor.c       | 8 ++++++++
>  3 files changed, 10 insertions(+), 4 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
