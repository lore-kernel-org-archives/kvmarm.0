Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2EB10A0E
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 08:46:33 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-401da71b83cso7449285e9.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694681191; x=1695285991; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQEPjdH4Gli9KAKRohOP4WFvJ7BvjQDzxENQGkakYUo=;
        b=iDxmG4akMZDaTqdpuW06CdAEDNK+f+hFaGv7t29oVo0Wd6TaHtPQFh5QVrJjXyGDjv
         yGa5l1CQYYNUPSH5dOhp+ftgyofJ8eyeIFclN6xRKKeJjBwpUhnvAyBocWphi9EF/iJh
         Asjfa8aQraHhg8D12NXhXgJYxTEyUleXJj2Fb9FXSdwj2d3dFygWBCkmfOjBsBBZfkRu
         5Wx5NIHUlofcAulmmmmRJWHlIOiblGXxwU2Oz7s8R333xrD83MtWAyXUU3kjbWa5kANq
         OdCVC0l1Ar86ReyEgA5Zc9idVwWc0TqTawVVe34F5UND6q+xrrak5VnIWSXMy2XdwlAV
         WcEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694681191; x=1695285991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQEPjdH4Gli9KAKRohOP4WFvJ7BvjQDzxENQGkakYUo=;
        b=Fp9JR1ZJApzxykL9eBzCEBgK8rcvhN3+Vh9mI7eez7SkVs0qKCHAyppEF2PbKWxrzm
         RkY1Mq8x49wtsiknk6dSXjmvUgCp+RsQMyYfWLdTonQhu6weeeKHD+r4eGj3gYUD005n
         BZPaneVWhS1G7iJqCvQ84b9oOlk1U6Sg7krRSLNKmYx2bCYrobNwmozYDg33WFZTK3/r
         iAQM1pf4W+gYgq3scsVzNnsGaccbOnTEVy3zzSVB5cEy3yij6nbjm+IHMNadySPi4/j9
         9j0FLN6uKUcgE/owiQ0OF8d6nuHnzkja6EkAF9lPkB1nIXElruUQ+ry6ZzuCmY70WPCI
         dfZA==
X-Gm-Message-State: AOJu0YzTJo6UpaAbaGOf/zHZ5uo8xOxlrMPH55tYNuKh6HqdEo8dlp/9
	han6nzvZlbmL2ubJ7bpL/n/Nrw==
X-Google-Smtp-Source: AGHT+IEirTjVMIzTLjC7sB1QXwQuxnOxm1+1fH/gEKNI6n9l8wkInADFzO37/+IpdsjO1bWWulPatg==
X-Received: by 2002:a5d:6105:0:b0:319:8427:d221 with SMTP id v5-20020a5d6105000000b003198427d221mr4297904wrt.62.1694681191504;
        Thu, 14 Sep 2023 01:46:31 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id y14-20020a5d4ace000000b003176eab8868sm1157269wrs.82.2023.09.14.01.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:46:31 -0700 (PDT)
Date: Thu, 14 Sep 2023 10:46:30 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 2/9] KVM: selftests: Unify the makefile rule for split
 targets
Message-ID: <20230914-393dcb077c664af16c4830e4@orel>
References: <cover.1694421911.git.haibo1.xu@intel.com>
 <cda6cc71c9bdde87fe87f6c2dec4f03ca249dd62.1694421911.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda6cc71c9bdde87fe87f6c2dec4f03ca249dd62.1694421911.git.haibo1.xu@intel.com>

On Thu, Sep 14, 2023 at 09:36:56AM +0800, Haibo Xu wrote:
> A separate makefile rule was used for split targets which was added
> in patch(KVM: arm64: selftests: Split get-reg-list test code). This
> could be avoided by minor changes to the recipes of current rule.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a3bb36fb3cfc..7972269e8c5f 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -249,13 +249,10 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TESTS_OBJS))
>  -include $(TEST_DEP_FILES)
>  
>  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o
> -	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBKVM_OBJS) $(LDLIBS) -o $@
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
>  $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> -$(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
> -	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
> -
>  EXTRA_CLEAN += $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(SPLIT_TESTS_OBJS) cscope.*
>  
>  x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> @@ -274,6 +271,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> +$(SPLIT_TESTS_TARGETS): $(OUTPUT)/%: $(ARCH_DIR)/%.o
>  
>  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
>  cscope:
> -- 
> 2.34.1
>

Nice.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
