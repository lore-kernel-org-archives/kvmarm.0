Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A3D3AEB35
	for <kvmarm@lists.linux.dev>; Sun,  2 Aug 2026 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785670382; cv=none; b=FcIbbVqjfQxqUoUzh967gD15YcdEDyyLDV7EJRQIvfgXFg/hBc6oq6BnVX5uXMKy5NMEwq0DQ7RFCvkvxGd6LkU6hN1BSKRzuu5mw18yHBT/CzTnqSQcbrAPRbCV+3tusSR+nDQmeWFKYKuilS6wJBt+i7FenyFPtckAXy/mTpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785670382; c=relaxed/simple;
	bh=6x8vPLAdn355tmP/ANDI2S4PH+v3cK2MaXG10kriN10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfVRRqiRATBXd4YeqNF54R1rV1FyIPOq6+kkaJGgi+jCtrK76LkHHz90vWpkmJE0GANomVu23TWvOWKPVl8HcxsrEZkJUSbpYapv/m8K0fO6RVp+rsnCAOy8l/WqnAVYCh7qD7lV3+vYH79zGPG6ioj/R0K9zi0DCTCJbhzmA94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JaUE+JdH; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JaUE+JdH"
X-Forwarded-Encrypted: i=1; AHgh+RqIrQa0+21EDo4SgmLWfvMfQKE59WfKjK2+MBeB+hl3MULspa3e0cl2UVqAQ/3bVqeWFwmcvNQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785670362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=563oNXUIkeVMeBvn7KJOWvs/zhYBpCRLhQXu0aHBhw8=;
	b=JaUE+JdHFP7MaVGI98pPRHgqUT4piafvGqmnLAegteTR/SGJNy5mQlCSVEKk/Xyj6EdjUX
	D+3HCGtvYkUWlBJZ1KYJEJTx+B3hYGZsRbb8Zs04F474fvgPjx4WFEeevYyGsNxC1xtJeF
	FT1NQgqenx3S/244RNEasc66F+uNqko=
X-Gm-Message-State: AOJu0YwFOhvph4qyXP+mY3efkvceOVvsyL10lgAawNjg8aD2uKMAZnZm
	D+mB1acHSgT1uCD/Ee4gHG7/c+HyoxKVZyYJzxkOQVHA5qmZGr3w9gRuP4pTSdM24vX9M5ujSQT
	AxHLkIDnLosG9yUExya1MCvMztel++7vR7+MXtlkh
X-Received: by 2002:ac8:580e:0:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52b5b0b0160mr17986791cf.5.1785670353005; Sun, 02 Aug 2026
 04:32:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731182231.1277064-1-vdonnefort@google.com>
In-Reply-To: <20260731182231.1277064-1-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 2 Aug 2026 12:31:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxwJ+e4nOuVE3nuMJxRk62fDhY-GVDjO6HLGzGmUVj5Qg@mail.gmail.com>
X-Gm-Features: AUfX_mzYz28lGkU5fFeVKuoX3O7CJ-5QBWq0Fe673Jb9b-5t2OiaUr7qhE-dcTs
Message-ID: <CA+EHjTxwJ+e4nOuVE3nuMJxRk62fDhY-GVDjO6HLGzGmUVj5Qg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Fri, 31 Jul 2026 at 19:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Currently, the host stage-2 is lazily mapped. kallsyms, accessed with
> the modifier %pB is therefore potentially unmapped. If the hyp panic
> occured with the host stage-2 lock taken, a dead lock will occur.
>
> Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b..2e1951c215ae 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -509,8 +509,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>
>  static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
>  {
> -       kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
> -               (void *)(panic_addr + kaslr_offset()));
> +       /* Kallsyms might not be mapped in the host stage-2 */
> +       if (is_protected_kvm_enabled() && !IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC))

nit: this is the negation of the find_bug() guard a few lines up (not
visible here), so could the two could share a helper?

> +               kvm_err("nVHE hyp %s at: %016llx!\n", name, panic_addr);
> +       else
> +               kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
> +                       (void *)(panic_addr + kaslr_offset()));
>  }

Tested on a pKVM host with CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC=n:
triggered an nVHE hyp panic and confirmed the new branch is taken and
the panic reports cleanly. The later dump_kernel_instr() is fine too,
it reads hyp text, which stays RO-mapped in the host stage-2 for
inspection, so no fault.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad
>
>  static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> --
> 2.55.0.508.g3f0d502094-goog
>
