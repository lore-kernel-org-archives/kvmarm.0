Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734635;
	b=izUnOwVrGoBqiZFYzPev4zZrbQt1LwTOq6J9YQ8jHGywm2sVozvZUAzvzKq6sD9hHG+e
	 y6pG7ZLVTJiemv6DomKtSmEUJmPy2VWUA8UI2lACb/qn3kKhXoDW+upGz5MhiTKvUT5Pa
	 UUeFh5N6bTcYRtA1iSwww3lNXVdc/v937XtY9oeyzSiYO+tCCzdCa/SC9HSE+uvB3BuJ9
	 Mj5OdJ8GSf/Xb0VphrxkwpMPhOwHICQk3kciouIdK+OYIMkByLvjE3QnvU1GkmeVWRg/7
	 WOjTgjOCpnQnk7gtk5Ka2fusqSpUghsFhD5Te69RDekY4ykI0YJ6foOzZwdYRpfB+GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734635;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Uys6yr4tcLiwlwRTacuVA59XDMV3OBaXJTAYNtM0vm8=;
	b=4pHFJDD3VW9EuUcxCi4lWxFuih9ArcBepaH/GLpzSHJcIfUFPv/9hv7pdtTuJKYCMkdQ
	 HVnqJk2os34Ov/Wfu9wgnNmSjOqtQqpMHqy6E4CiVc+2GfEJ4d4P+3pnqJPev1tlN/ZC2
	 nHkpCpqh9rzDWdEXz2JmHN9mQvH1Sy94RdcPpabqfrpXx+p8IopIIuddXwZCSvvMNmcrX
	 h7fyhAmj6YvX8xA+7jPKy1WFM6+Xj463O01F+az7jr9gfw9U9wpjPWKt58skBo1WAuTnl
	 7i9gGKclNvinrGlc2JRMOrUYM4T6+RJnXoI3IiUXB/oIeUKKKfH3kH+dnU+D6f2wyDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EnMn7RCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864B8606A31B;
	Tue,  3 Nov 2026 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EnMn7RCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907651F000C1;
	Tue,  3 Nov 2026 19:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734635;
	bh=Uys6yr4tcLiwlwRTacuVA59XDMV3OBaXJTAYNtM0vm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EnMn7RCncExjnU/CMRONUA4eU5A4fG2orJRsNdZOyZfTHU3KfzxCB96ykG2mta+iE
	 0kEXhOQOHIoUy4abkDxFcwcI2oGF/AfW1wjxZDUCWdSwpM1cM7SbrDzz0MhG8jP//0
	 l5+byyGP/p/zrAzujcnBuLmdK+vZl7BHzxPi5PKDiaHt0R0l+jTy4HrzOmf3dfoQ/c
	 PVu6NkcmSw8zEqkHVs9BYVoJDmCn7E5LJR5v/o0fAVK58fjzMnsiiy1FPuXVv59MS1
	 zdZdEA/C3JbbU9ILmKOQbfo6RuKeMxHavsIOBH+F6rZNffrb+qCGJyKKbpMGevfWUL
	 fwjxhTgeNCBBA==
Date: Tue, 3 Nov 2026 19:37:08 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 23/28] KVM: arm64: Add kvm-arm.ignore_spe_errata
 kernel parameter
Message-ID: <auoxMOkCaxjbjiJY@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-24-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-24-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:18PM +0100, Alexandru Elisei wrote:
> Add a new kernel command line parameter, kvm-arm.ignore_spe_errata with the
> effect of ignoring any errata that might inhibit userspace from creating a
> SPE enabled virtual machine.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Hmm, is this for testing purposes somehow? If so it should say so, if not
then why don't we specifically detect the erratum and handle it by default?

Also you're explicitly addressing ARM64_ERRATUM_3023823, I think you should
explicitly mention this and explain what it is and why this is worth doing.

And in general - does it make sense to have a generalised 'ignore errata'?
Surely you either want to workaround the errata automatically or disallow
broken things?

And if you want to do the latter you'd want to be able to specify which?

In which case perhaps you could specify a comma-separated list of the
specific errata you want to workaround perhaps?

> ---
>  Documentation/admin-guide/kernel-parameters.txt |  3 +++
>  arch/arm64/kvm/spe.c                            | 10 +++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..2d91ce8e8c4b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3299,6 +3299,9 @@ Kernel parameters
>
>  			notrap: clear WFI instruction trap
>
> +	kvm-arm.ignore_spe_errata=
> +			[KVM,ARM] Ignore SPE errata and expose SPE to guests.
> +

NIT: Should be in alphabetical order. Also this is very bare-boned, should
mention the erratum and the consequences of ignoring it.

If it's got security implications this should be mentioned here too.

>  	kvm_cma_resv_ratio=n [PPC,EARLY]
>  			Reserves given percentage from system memory area for
>  			contiguous memory allocation for KVM hash pagetable
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index ce68789d184b..3e82edc8be85 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -21,8 +21,16 @@ struct spe_pmu_entry {
>  	struct arm_spe_pmu *spe_pmu;
>  };
>
> +static bool ignore_spe_errata;
> +
>  static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level);
>
> +static int __init kvm_ignore_spe_errata(char *arg)
> +{
> +	return kstrtobool(arg, &ignore_spe_errata);

This will be an error if empty (e.g. just kvm-arm.ignore_spe_errata).

if intended, you should document that, otherwise you should handle an empty
input.


> +}
> +early_param("kvm-arm.ignore_spe_errata", kvm_ignore_spe_errata);
> +
>  void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
>  {
>  	struct spe_pmu_entry *entry;
> @@ -290,7 +298,7 @@ static int kvm_spe_set_spe_id(struct kvm_vcpu *vcpu, int spe_id)
>  		return 0;
>  	}
>
> -	if (spe_pmu->has_workaround_3023823)
> +	if (spe_pmu->has_workaround_3023823 && !ignore_spe_errata)

Small note, but seems odd for something that is called a workaround to
actually be indicating that a bug exists. Maybe 'has_erratum_3023823'? Will
comment on relevant patch obv.

>  		return -EINVAL;
>
>  	if (!try_module_get(spe_pmu->pmu.module))
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
