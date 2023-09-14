Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B8B224F2
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 09:52:03 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-31dcf18f9e2so686083f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 02:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694685121; x=1695289921; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=87hkIaEeaycrb+JmT+Kn5bO8XmPQAs/7YcVaTE26sUI=;
        b=PRbB996z6CaSoJEsHW2BfeDzqW6bzYJPlvyUseU+jA6EbefXaxOlOrjDaGO8EPmSfD
         4B+fMdqXEe72ZqfCc+BacIZihiJGI2AwfWdRKB7JmyMxCVT2QpnkC1zhxoxTX0lS3//u
         15dbqPXeue6pTGej8G04vpZcJyy1h/CxpOAyTjQkhHv5ZI0fvhh6IebARCqz+oa0C8Ge
         FXG2ytA5wO/7PKrb9l/ASpIjCRQbDJtWTas78ucINGHIn5TPADMFLetR8Eh722Ahwfiv
         y+dKaD2iA0ST7kHTyijv2VtJ+SKWIRzHPUwKlwy46VyLfOwRB8sYo1c/T98Yb6lgljDE
         lWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694685121; x=1695289921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87hkIaEeaycrb+JmT+Kn5bO8XmPQAs/7YcVaTE26sUI=;
        b=AVFYlRkmYlsChWNR1bXq6KjbBlC0FxfuD4KEmyJkXkgJkPz2mP9QsGFWscKL6DUPjq
         T/pdca0TuB8FmjSF8j5rJCBADkvR/+4trVgLvm9L4eqwQNRZGsHcHVlq3qDBeflengT/
         Y7cszRJxNbOTH0TLM5bI865iWyrii1SiHwd8I7kckaMeiEFWnWD0KeK3velxzT+9Ak5s
         ckQ3v64UCfGJqnS9rH3TkTXa55WdITrRE5P/WKe+SjmjaUroA3jexMPN329kZ683R6Ad
         WYjdMrlA2GQzwh5tbEgJEETYsio3lyYgid5ZlaimDIMTEfAw3fyuG70HDOIrC6wk/A5D
         lBHw==
X-Gm-Message-State: AOJu0Yyq1VlFBQ+rZ74LLlUyZhyT3gNe/ztrd3bFrTlFZ3rXwW+1Vf+6
	sVC7JnX2Uzh6TJgi52dpoqHGdw==
X-Google-Smtp-Source: AGHT+IE9t7DU458yWwT1itzK5VNW8FsjrH1qSa0IsiYq57mBauEQWRv09OgpY8852LzCHRw39zKnyg==
X-Received: by 2002:adf:e7cb:0:b0:318:8ad:f9f with SMTP id e11-20020adfe7cb000000b0031808ad0f9fmr4346446wrn.24.1694685121603;
        Thu, 14 Sep 2023 02:52:01 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id j4-20020a5d6184000000b003176c6e87b1sm1290730wru.81.2023.09.14.02.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 02:52:00 -0700 (PDT)
Date: Thu, 14 Sep 2023 11:51:59 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 9/9] KVM: riscv: selftests: Add sstc timer test
Message-ID: <20230914-d2e594e7d84503ad14036e2d@orel>
References: <cover.1694421911.git.haibo1.xu@intel.com>
 <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>

On Thu, Sep 14, 2023 at 09:37:03AM +0800, Haibo Xu wrote:
> Add a KVM selftests to validate the Sstc timer functionality.
> The test was ported from arm64 arch timer test.

I just tried this test out. Running it over and over again on QEMU I see
it works sometimes, but it frequently fails with the
GUEST_ASSERT_EQ(config_iter + 1, irq_iter) assert and at least once I
also saw the __GUEST_ASSERT(xcnt >= cmp) assert.

Thanks,
drew
