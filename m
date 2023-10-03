Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC70D302
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 10:28:46 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-9a9d82d73f9so124101966b.3
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 03:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696328924; x=1696933724; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XsdqrdEkDSj8N1JGo8GS+Y+t1N9Ffxo49rjL66LLWiU=;
        b=UGf0aFIqnRtqKgfpHtcd3S2Ec2j2ci5xu/568aUqjclnFTpJQ+M9L+viBpMl2zKV1/
         kJr+YffjIMRVtl8osr9B/zr7Gdg+uHRu/EZTBAkzFAy6bMvm9CBnMJAbchhyLEBk7aLZ
         iBWCxl231nE+fgxnfPhkU5jV2qN3KVLozU6IR0+ceQh9KXVDsS1NmMmpM8Pmg5YzoJTh
         dahzL2Jia1EiUFEEtJp7E2hz0aVnnUVb7DbVMATKW/5LfRXUQjns4eQNX+2j5xe7v/UB
         jtggbLsqIdh0q6EePtGN0IB5oTiA6xVI4udvorI2ha8RPm0gfQNLYmM7rtvq/L2zTHIt
         HtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696328924; x=1696933724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XsdqrdEkDSj8N1JGo8GS+Y+t1N9Ffxo49rjL66LLWiU=;
        b=omDXmBEHYDpUIzWVPKwWb92cPQs9mDQ1CMsY8eYkF2FM3kcl7N9y0VBU4GLKECmCmw
         hMv0ISfasBzLY2fRoRvgK/biEOwvKLOXNPHTDa1ECrq5lM7u4UYyX8uD2uLNu3jwwzHM
         ch4Doa7C2TdR1StzQ4LhdYJ8jSkL86VcLgyQWzEBTf9wl+0G6FBqkcPjw0rDjbp6mqgw
         LwA0P45UOgwF2giBGjRlpDF1eryrTPR8SMbYx2vZI3sPhXmPNyRORwnVWu0r35r0vOp7
         M4QDmcIIp1ue6j+kqR3L/HX4+PbmCqifH9vedSO+BsPyujaOQ8DMLmENeGZNagI5ZHAo
         2wzw==
X-Gm-Message-State: AOJu0Yw1qpAzyiMr7Xzju3vfiGtK2uHowFllL7qUSRy+3tGzTvFYKHPR
	Sd6KqXLmqRPibiK1FZYCUplF8A==
X-Google-Smtp-Source: AGHT+IG9ar/of5h3vBdRHdNrUbHgfPXCJHKRmFUO92+SzwFtgCwBykQiZdbI9ipIbOFvP0+0VOSg1w==
X-Received: by 2002:a17:906:109e:b0:9ae:6d0:84f7 with SMTP id u30-20020a170906109e00b009ae06d084f7mr11197111eju.32.1696328924382;
        Tue, 03 Oct 2023 03:28:44 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id op19-20020a170906bcf300b009adc743340fsm822007ejb.197.2023.10.03.03.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 03:28:43 -0700 (PDT)
Date: Tue, 3 Oct 2023 12:28:42 +0200
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
Message-ID: <20231003-d44206f71d0b22e539833697@orel>
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

I just noticed that with and without this patch we're building the
arch-specific part in tools/testing/selftests/kvm/riscv even when we have
an $(OUTPUT) directory (e.g. O=build). Those build artifacts should be in
build/kselftest/kvm/riscv instead.

Thanks,
drew
