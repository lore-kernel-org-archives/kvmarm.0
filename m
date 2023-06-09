Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042EEC8FA
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 09:24:41 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-51494659d49so2686888a12.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 02:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686302680; x=1688894680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZarEebR8QFxdGd6BDii6BW9L7KO3qDDoKK/MEwvn90=;
        b=Rs9/5cIfXIF0X9dJtfJjl+S6T33jQp4Px3GDSrcvuwkppHWZXUsL8ehgtlEdVWgQhp
         wZ7iBamYWGVLJ2Km1VI+A0c5Pj7Vi69maem4T1UfWqzM1ICaSwbq2qvkARzSMmxsidJ4
         Z5s05RkJYCldhPOJj5incQPIqdVf8FiB/bV5WhSttaKgHDMK9XkzcR2l0+oh0PPWQR6l
         uxEnpUlJ/GuQWDgQMmKCIbr+mIkQxQIkjpUfyCHTc3RKgv8Hd2GG7MxnWsWVzPJErurs
         8/ZrLm00PA/JasYULG9e43reLoImOlkCmqVWgNktIvQsgTUqewnuDM6i+qfRNSbyMjR2
         JIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686302680; x=1688894680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZarEebR8QFxdGd6BDii6BW9L7KO3qDDoKK/MEwvn90=;
        b=lx534SyYMsWKq92kBvjL50zRIm2fRiBTGPkiGnZH4WnH2hwo2+D9XgGX9I13NX1bfw
         Nz5I17sX0JXilCsjgxWtBtzwfWOT1ywTE0odoTfQKnW+L3HA8NEVWeBDRaUn+bEIZKJ8
         7yH+uMpRrFWpfqUUUFD1PKx/717NSlGtp49dqZt6mK9C2iAtZzV71/rjioCcS/qoWp9F
         3LogSs+X2dt9NZmCrdzYShQfT3xFFuZ8p304ayws/T4gCuQd8IQ+WqmSxUQ4/hK1WflL
         9SS3+DnKz6H4JboxEJHXl0ZSjM0tIzB93nF/zOZP/Kn23xUuPLAdEnF/j4O8CbOQy2lN
         9cCw==
X-Gm-Message-State: AC+VfDzbGnyXH59TsILp2JncTgXfjBHFRvRVN426lGsrCvAAmB2p9xtt
	9Ld/26II3KyX/V2l3Vlhl0Q0rQ==
X-Google-Smtp-Source: ACHHUZ57wveqIUZeYQtbwSYnijhoIMs/IsyQJREmzHYMiZkR8YpHPOCyKtzTyeI/sdX9LNwraQyNBg==
X-Received: by 2002:a50:fb94:0:b0:4fa:3b3:c867 with SMTP id e20-20020a50fb94000000b004fa03b3c867mr858539edq.17.1686302679914;
        Fri, 09 Jun 2023 02:24:39 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b00502689a06b2sm1537895edd.91.2023.06.09.02.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:24:39 -0700 (PDT)
Date: Fri, 9 Jun 2023 11:24:38 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/10] KVM: riscv: selftests: Skip some registers set
 operation
Message-ID: <20230609-05521f954b0485c69612f00b@orel>
References: <cover.1686275310.git.haibo1.xu@intel.com>
 <73045958d9ab71d5266d012f1e13061afa8c5331.1686275310.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73045958d9ab71d5266d012f1e13061afa8c5331.1686275310.git.haibo1.xu@intel.com>

On Fri, Jun 09, 2023 at 10:12:17AM +0800, Haibo Xu wrote:
> Set operation on some riscv registers(mostly pesudo ones) was not
> supported and should be skipped in the get-reg-list test. Just
> reuse the rejects_set utilities to handle it in riscv.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  tools/testing/selftests/kvm/get-reg-list.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
> index c4bd5a5259da..abacb95c21c6 100644
> --- a/tools/testing/selftests/kvm/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/get-reg-list.c
> @@ -211,16 +211,22 @@ static void run_test(struct vcpu_reg_list *c)
>  			++failed_get;
>  		}
>  
> -		/* rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE */
> +		/*
> +		 * rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE on aarch64,
> +		 * or registers that should skip set operation on riscv.
> +		 */
>  		for_each_sublist(c, s) {
>  			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
>  				reject_reg = true;
> -				ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> -				if (ret != -1 || errno != EPERM) {
> -					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
> -					print_reg(config_name(c), reg.id);
> -					putchar('\n');
> -					++failed_reject;
> +				if ((reg.id & KVM_REG_ARCH_MASK) == KVM_REG_ARM64) {
> +					ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> +					if (ret != -1 || errno != EPERM) {
> +						printf("%s: Failed to reject (ret=%d, errno=%d) ",
> +								config_name(c), ret, errno);
> +						print_reg(config_name(c), reg.id);
> +						putchar('\n');
> +						++failed_reject;
> +					}

Thinking about this some more, shouldn't we attempt the set ioctl for
riscv reject registers as well, but look for different error numbers?

Thanks,
drew
