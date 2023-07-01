Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9168BE61
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 14:21:38 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-51dd0205b2cso5014838a12.1
        for <kvmarm@lists.linux.dev>; Sat, 01 Jul 2023 07:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688221297; x=1690813297;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ltc0O996d2bJf/usVXZjvRnz8qhepirqOjCRCwuDkdg=;
        b=mDa0A4ah1iKgzXPnYv6/44AHozwnFGGexPg+UG35lheBAs2gxqEQVUT75hMDymftsC
         0fRnCqPM7tXd26//jB7kOakAX0ym5Naru8vmf0OCMxxtMl2DPXtfyxhv0KthKTTiwirZ
         fjsOTUpn9YXNB9lStXMEnjUnzUqC+Y62quzZNOsNN5P4wd3f/hfEtKVlDn/Gv2vX9LUl
         1x1FTpGdFhG7i1ycYDHyPnKhv1v2H/eT5xE5NzuzWkAzpiNYxRcxQHbKT6WiIPMBRlEx
         MyyGYNFWvbX5/dR91U9v12GyQFs5eINSLn4N5xBTyAHwIkCDZXbkvJWs2m9ko7eqGUB0
         JoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688221297; x=1690813297;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ltc0O996d2bJf/usVXZjvRnz8qhepirqOjCRCwuDkdg=;
        b=W1LmlwhW/ZbE8YoKy3S/N9/bXeRewodwNXvgLB2NoaFuxU6oNa777qQtmY5PDcF2+O
         Swo8hnSBFdck29GoAplUtL6jbWINHxYCa4APi/gX85wkxQedJzefQLt2nPDDjJ0T7Syb
         fdIxP2FbclugXZzkvNWsjjQGpHqfr2+1pq6qmhJaYR8Sl+SZcYaL/XCXMEwT6ZsBcnF6
         UNqhOuwnO+G1JRc+GK6TylFJ30TgT+q24z51IDyK3JEq3mN72vEwlC0sJOvYv2dGqtpm
         wTqnid32YIz4oLSX/x+E1pvaKx/yUSsLWsS9NLCkSe9lyvfY9o5p2HU64ni1/rXFLfmt
         4mPg==
X-Gm-Message-State: ABy/qLa8kRKIQRVlGq38zyoKwFs2/0OWFyMbA4juIVK/eGDRuiXOurCS
	1TTNW3dGAL1KTi22WJXkX9GROQ==
X-Google-Smtp-Source: APBJJlEtL7xdUIWMV/E0QfeYCsba39LkB77KKUGXjQoxprjQKPF+i7ItT2onHvagrIj3biWKLiOLlA==
X-Received: by 2002:a17:906:18d:b0:991:d883:3df9 with SMTP id 13-20020a170906018d00b00991d8833df9mr6213162ejb.21.1688221296673;
        Sat, 01 Jul 2023 07:21:36 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id a18-20020a1709063a5200b00988f168811bsm9355065ejf.135.2023.07.01.07.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jul 2023 07:21:36 -0700 (PDT)
Date: Sat, 1 Jul 2023 16:21:34 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Matlack <dmatlack@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/13] KVM: arm64: selftests: Move reject_set check
 logic to a function
Message-ID: <20230701-0255de0b29b22f180bb3bbbf@orel>
References: <cover.1688010022.git.haibo1.xu@intel.com>
 <f5ef26e862260efdf1c809d0eee46ee1c8b457f2.1688010022.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5ef26e862260efdf1c809d0eee46ee1c8b457f2.1688010022.git.haibo1.xu@intel.com>

On Sat, Jul 01, 2023 at 09:42:56PM +0800, Haibo Xu wrote:
> No functional changes. Just move the reject_set check logic to a
> function so we can check for specific errno for specific register.

'for specific register' part isn't true anymore.

> This is a preparation for support reject_set in riscv.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 5 +++++
>  tools/testing/selftests/kvm/get-reg-list.c         | 7 ++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index aaf035c969ec..4aa58f1aebe3 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -27,6 +27,11 @@ bool filter_reg(__u64 reg)
>  	return false;
>  }
>  
> +bool check_reject_set(int err)
> +{
> +	return err == EPERM;
> +}
> +
>  #define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_COPROC_MASK)
>  
>  #define CORE_REGS_XX_NR_WORDS	2
> diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
> index f6ad7991a812..79e198968860 100644
> --- a/tools/testing/selftests/kvm/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/get-reg-list.c
> @@ -98,6 +98,11 @@ void __weak print_reg(const char *prefix, __u64 id)
>  	printf("\t0x%llx,\n", id);
>  }
>  
> +bool __weak check_reject_set(int err)
> +{
> +	return true;
> +}
> +
>  #ifdef __aarch64__
>  static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
>  {
> @@ -216,7 +221,7 @@ static void run_test(struct vcpu_reg_list *c)
>  			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
>  				reject_reg = true;
>  				ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> -				if (ret != -1 || errno != EPERM) {
> +				if (ret != -1 || !check_reject_set(errno)) {
>  					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
>  					print_reg(config_name(c), reg.id);
>  					putchar('\n');
> -- 
> 2.34.1
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
