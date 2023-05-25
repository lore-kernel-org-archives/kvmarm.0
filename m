Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD053D7C
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 16:40:10 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-3f6cbf02747so6300715e9.1
        for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685032808; x=1687624808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AR0TcRh5E3uNMVlwV4MX3XAnDWVMVCj/HBAPlYOkb4Q=;
        b=SMOO/RHoH9sCbPbHZOhilUrB2bJNfvDLCzNO5ccrVnl5YTsggfxCAGw2enOsIJsw3S
         muOPMMbM8OB9rpMjOPTcLN0styrxHRbccc9yTmXWbgcevJUP1pwqZXi98iwgUX4Pfv55
         os7jsjCiXCLLhdD3CTPGSThlSx7rRpRDglbQkL4uhDoPpGndSA0UT7be/09Y3qB4sCTU
         9Jj2LjqrHnXVoyAXUQEyeCSGlSCPNGIKyvU2Ar0ZXlrITl5RpUUhEMrIW9rij7AQisZh
         pS4SfprjWAgXcStQyvo0bOqre47fTQRcCig3TUxi2T6iUTtbEYJBhRLX2YVECM6VJ7Ni
         /zsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685032808; x=1687624808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AR0TcRh5E3uNMVlwV4MX3XAnDWVMVCj/HBAPlYOkb4Q=;
        b=S9Jv29F1iOH4jXwsSRj0WK3u3uHN6quTyiEkN4TUnHe5Sb8kCT0crQUG1ONMUXjQ+d
         qKhaQZIC2ebEFj1w7J+UEOcWmZ9h/XMg3ZZMHyDE6ahqPrAfN9u9Nl3Zjb3wYdDpbnNO
         N26IPcxfrKrriOnAI2fEPh5Nu0mIj5QH8xcbeMq4+QKLOXVQ3rEUfLk4aPeYi6MfqyDz
         v7wBAJQFkFUhmQDjciP0Eeki3xF3mwaJbiHLdm6nt9lV6uJOFuBY6ZotrYOPdOJmBvI1
         8P1rwFUxGIrNvS0t5NhnfvCfwC5nb6MvjaZVBInXWG+5TeRSRe0ktc62q0wCAaKwmZeY
         iLzg==
X-Gm-Message-State: AC+VfDy0PkuAvJVLmnHyEuyQqMhWFHz6mODOGvVd+WFtm1Y9v/CWAfE/
	Qlz5zIpsECtBrNgzGBDsyg8gsQ==
X-Google-Smtp-Source: ACHHUZ4E3vZaFea6aEdcJxuXhPYk5shRp2rDROSu38VNjlX+Zz36M4ciiQeNekDxjPytu3ey3fhDvg==
X-Received: by 2002:a7b:cbd6:0:b0:3f4:2452:9669 with SMTP id n22-20020a7bcbd6000000b003f424529669mr3090300wmi.0.1685032808575;
        Thu, 25 May 2023 09:40:08 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id c2-20020adfed82000000b003078a3f3a24sm2311517wro.114.2023.05.25.09.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 09:40:07 -0700 (PDT)
Date: Thu, 25 May 2023 18:40:07 +0200
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
Subject: Re: [PATCH v2 09/11] KVM: riscv: selftests: Make check_supported
 arch specific
Message-ID: <20230525-705ddcbcd43aa63e3fd356c8@orel>
References: <cover.1684999824.git.haibo1.xu@intel.com>
 <26dea518fc5e8da51e61db279d175364bfecd009.1684999824.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26dea518fc5e8da51e61db279d175364bfecd009.1684999824.git.haibo1.xu@intel.com>

On Thu, May 25, 2023 at 03:38:33PM +0800, Haibo Xu wrote:
> check_supported() was used to verify whether a feature/extension was
> supported in a guest in the get-reg-list test. Currently this info
> can be retrieved through the KVM_CAP_ARM_* API in aarch64, but in
> riscv, this info was only exposed through the KVM_GET_ONE_REG on
> KVM_REG_RISCV_ISA_EXT pseudo registers.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/get-reg-list.c | 32 +++++++++++-----------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
> index f6ad7991a812..f1fc113e9719 100644
> --- a/tools/testing/selftests/kvm/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/get-reg-list.c
> @@ -99,6 +99,20 @@ void __weak print_reg(const char *prefix, __u64 id)
>  }
>  
>  #ifdef __aarch64__
> +static void check_supported(struct vcpu_reg_list *c)
> +{
> +	struct vcpu_reg_sublist *s;
> +
> +	for_each_sublist(c, s) {
> +		if (!s->capability)
> +			continue;

I was going to say that making this function aarch64 shouldn't be
necessary, since riscv leaves capability set to zero and this function
doesn't do anything, but then looking ahead I see riscv is abusing
capability by putting isa extensions in it. IMO, capability should
only be set to KVM_CAP_* values. Since riscv doesn't use it, then it
should be left zero.

If we're going to abuse something, then I'd rather abuse the 'feature'
member, but since it's only an int (not an unsigned long), then let's
just add an 'unsigned long extension' member.

Then, the finalize_vcpu() call can be moved back to run_test(), from
aarch64's vcpu_config_get_vcpu(). Both aarch64 and riscv will call it
right after vcpu_config_get_vcpu() and the riscv version of it will
do what your current riscv check_supported() is doing, using the
new 'extension' member instead of 'capability'.

And this patch gets dropped.

Thanks,
drew

> +
> +		__TEST_REQUIRE(kvm_has_cap(s->capability),
> +			       "%s: %s not available, skipping tests\n",
> +			       config_name(c), s->name);
> +	}
> +}
> +
>  static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
>  {
>  	struct vcpu_reg_sublist *s;
> @@ -126,6 +140,8 @@ static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm
>  	struct kvm_vcpu_init init = { .target = -1, };
>  	struct kvm_vcpu *vcpu;
>  
> +	check_supported(c);
> +
>  	prepare_vcpu_init(c, &init);
>  	vcpu = __vm_vcpu_add(vm, 0);
>  	aarch64_vcpu_setup(vcpu, &init);
> @@ -140,20 +156,6 @@ static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm
>  }
>  #endif
>  
> -static void check_supported(struct vcpu_reg_list *c)
> -{
> -	struct vcpu_reg_sublist *s;
> -
> -	for_each_sublist(c, s) {
> -		if (!s->capability)
> -			continue;
> -
> -		__TEST_REQUIRE(kvm_has_cap(s->capability),
> -			       "%s: %s not available, skipping tests\n",
> -			       config_name(c), s->name);
> -	}
> -}
> -
>  static bool print_list;
>  static bool print_filtered;
>  
> @@ -165,8 +167,6 @@ static void run_test(struct vcpu_reg_list *c)
>  	struct kvm_vm *vm;
>  	struct vcpu_reg_sublist *s;
>  
> -	check_supported(c);
> -
>  	vm = vm_create_barebones();
>  	vcpu = vcpu_config_get_vcpu(c, vm);
>  
> -- 
> 2.34.1
> 
