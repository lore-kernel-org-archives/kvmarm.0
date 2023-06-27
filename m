Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC210F9
	for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 09:16:37 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-986d8332f50so541803366b.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 02:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1687857395; x=1690449395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+MCoS/GbrEqpT4HJQ2GjfyBERH9spXNSgBlAnljQlo8=;
        b=hxzm0GKQS+eom3slcVJwuaQB9SbpkcfrgGFcNPoFyyIGNADZabL4nQv4gszNAGffMe
         lDvcAP3Ghl5j87LvIMP0tvxaDJO5dLmgCDIBMw4x2AqUk0Z06cXw2PHzxhdIva9WTfgT
         6PYn64hxE1JpVa5KuCqgw60STT4o7kEIqeDbQXinO6DoHzf3XFrtxWiBLPireQe8lFEp
         47eQyDKL7rL9U/8yuEQRbmm7dLdr4HIvaW63994gvfJXi7ogLu0onQXJPY+Zu8T638Bm
         toYA9lWto9yOvy9yDPITMK/s6pPZkTIqUdS2A76+SHKBmet/Q/CwNY5HMpBPoqI+rsAK
         HQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687857395; x=1690449395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+MCoS/GbrEqpT4HJQ2GjfyBERH9spXNSgBlAnljQlo8=;
        b=TkB2LwbeEKNUHH/Uer+jubpQO4K84eAeIE1DPRpHKglRAczhtph8JrYlCgwT5TLqBE
         uEKi2tUWMxqcJEYn15yHac4PkCUCJDzZ8phJf7Q3l9IJdCUOUESJ5Z/xtptyzZugnu96
         yibYFNIZZNyacwI1gilfQx6yDubDw/WuRwirjCJ7s49zB0HcoeECQqXE9THVt78AiZ2V
         88NOZ6rCWTwTDIOIxlLy7VhkqO+0IPsrl6XpI5TEAZR1Z3dhmjskq6fF/NMbHwBUviOv
         khJfYXdUamjrXJ4vUO6eLNFdDbl0KwF6DONxis0IS35vYt8qiofT9umjoRkoIrciwhhX
         B4hg==
X-Gm-Message-State: AC+VfDzCYJlz/46o7ggwPJSMOJ8xq2sj/S1XOrQ1nVzgHpf0RKYrP8x8
	0jx28zGb7kbkyYWdtsxHvARGhA==
X-Google-Smtp-Source: ACHHUZ575a/YzRNsfdhJWLZPMJ3YdSkM8BP8AyU7T0mt/iflGtaHCLSXzIB+tLAYyf2UCf7ECFnkfw==
X-Received: by 2002:a17:906:eec1:b0:970:c9f:2db6 with SMTP id wu1-20020a170906eec100b009700c9f2db6mr24231824ejb.63.1687857395256;
        Tue, 27 Jun 2023 02:16:35 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n19-20020a170906841300b00988d0ad4477sm4283531ejx.29.2023.06.27.02.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 02:16:34 -0700 (PDT)
Date: Tue, 27 Jun 2023 11:16:33 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 11/12] KVM: riscv: selftests: Add finalize_vcpu check
 in run_test
Message-ID: <20230627-feb5bf584a3fd16d2c0ffe66@orel>
References: <cover.1687515463.git.haibo1.xu@intel.com>
 <fa6b80b578553e561ccacaeb24091e0716975593.1687515463.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa6b80b578553e561ccacaeb24091e0716975593.1687515463.git.haibo1.xu@intel.com>

On Fri, Jun 23, 2023 at 06:40:13PM +0800, Haibo Xu wrote:
> Disable all vcpu extensions which were enabled by default
> if they were available in the risc-v host, and only enable
> the desired one for a vcpu_config.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/get-reg-list.c | 42 +++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
> index 3beb6b62de0a..612dabc61137 100644
> --- a/tools/testing/selftests/kvm/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/get-reg-list.c
> @@ -138,11 +138,50 @@ static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm
>  	prepare_vcpu_init(c, &init);
>  	vcpu = __vm_vcpu_add(vm, 0);
>  	aarch64_vcpu_setup(vcpu, &init);
> -	finalize_vcpu(vcpu, c);
>  
>  	return vcpu;
>  }
>  #else
> +static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> +{
> +	int ret;
> +	unsigned long value;
> +
> +	ret = __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> +	if (ret) {
> +		printf("Failed to get ext %d", ext);
> +		return false;
> +	}
> +
> +	return !!value;
> +}
> +
> +static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
> +{
> +	struct vcpu_reg_sublist *s;
> +
> +	/*
> +	 * Disable all extensions which were enabled by default
> +	 * if they were available in the risc-v host.
> +	 */
> +	for (int i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++) {
> +		__vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(i), 0);
> +	}

nit: can drop the {}

> +
> +	for_each_sublist(c, s) {
> +		if (!s->feature)
> +			continue;
> +
> +		/* Try to enable the desired extension */
> +		__vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature), 1);
> +
> +		/* Double check whether the desired extension was enabled */
> +		__TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> +			       "%s: %s not available, skipping tests\n",
> +			       config_name(c), s->name);
> +	}
> +}
> +
>  static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm_vm *vm)
>  {
>  	return __vm_vcpu_add(vm, 0);
> @@ -178,6 +217,7 @@ static void run_test(struct vcpu_reg_list *c)
>  
>  	vm = vm_create_barebones();
>  	vcpu = vcpu_config_get_vcpu(c, vm);
> +	finalize_vcpu(vcpu, c);

Now that both arm and riscv call finalize_vcpu() we could do the weak
function trick for it and move the arch-specific implementations to
their own arch-specific files.

>  
>  	reg_list = vcpu_get_reg_list(vcpu);
>  
> -- 
> 2.34.1
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
