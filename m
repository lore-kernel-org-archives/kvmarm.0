Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3801125CC
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 18:50:51 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bb05f0e6ef9so9619344276.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686077450; x=1688669450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/kxh2UcUAcpjTVTH58LFlj31OMBp369OV6aYglfRazo=;
        b=paNtY3H6eqkQlzGxUw0CdfHkDeW3N+mHSa9Bmq1zenbINTGE1DcEi87/JJAIxZWZfZ
         8XxT6w+gua+A46wZqWG3L7WN06vswB0/q8EWRFyboaDdsGME/t/DxonPsI7RIX30AvJN
         a0TCHlWVIOF/cqLPIYkYhCbeF2idLmuYlndKCeOyCLRFEjSzK9UfKMIVmwV+1Px5gPR7
         u9bkHVmxwjbi8XuvSzis6u6EUM+HrokocTpobniJ/YXqxRUhSSuDnBiprIX7WyBD5rsx
         IAJTW8HEyWcmxASKqmxqw4IguBH4GgJEQRVwaGmUOGOVTKiCVzbGRwmMCLT5CFqKKCqy
         miwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077450; x=1688669450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/kxh2UcUAcpjTVTH58LFlj31OMBp369OV6aYglfRazo=;
        b=OMs9zBarg2j+dl6mk7Ztg/0v/OMZhM6h22ZvVQ1t+sFPk62cqh5PwJ0Ch8fek/LXOO
         iJoc7WNzpRMDVmpm3SQysYRnVxmW9f8VuiGDmqVdII4LKWFH6O6CkNDXm3XzHRZtpAcw
         WjHfgui5ALysqaVVGzYesnpRkw7etL3GjVonfnCe7eEkIU5ago1DfELN6yCim6dRdB/0
         HgGZfmV/S3Y1Aa70LxQlmD02/hEX6qccSKuHfwodzc5Xi76l6Ik3FyF+N30yCp4UdKTq
         I8tTD3LhgXw5gxjGWIqGHXBJokP3VrcT7M+uBt2PHLjlMwtPXTIs16t91Ip6dPLFXXQH
         SWzg==
X-Gm-Message-State: AC+VfDy8LKNyay66OiYiTT6O2Ttr0P8W6bBkxTNLqK/Kb1I9Z4mjFy8k
	RjohisGBCMmxBYVBsR/i9R8ZuGe136I=
X-Google-Smtp-Source: ACHHUZ4S2fmiUfxNuzvbexh6Uq0pRVx67oOgXZbtqqduZR2jJggkiI9o4A1c+992b/T5KHLfsG9o6WoAvJo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4ec3:0:b0:ba8:6422:bbec with SMTP id
 c186-20020a254ec3000000b00ba86422bbecmr1576209ybb.4.1686077450594; Tue, 06
 Jun 2023 11:50:50 -0700 (PDT)
Date: Tue, 6 Jun 2023 18:50:48 +0000
In-Reply-To: <20230606184814.456743-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230606184814.456743-1-oliver.upton@linux.dev>
Message-ID: <ZH+ACORPo5OxAl29@google.com>
Subject: Re: [PATCH] KVM: arm64: Use raw_smp_processor_id() in kvm_pmu_probe_armpmu()
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sebastian Ott <sebott@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 06, 2023, Oliver Upton wrote:
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 491ca7eb2a4c..560650972478 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -700,7 +700,25 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
>  
>  	mutex_lock(&arm_pmus_lock);
>  
> -	cpu = smp_processor_id();
> +	/*
> +	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
> +	 * the same value is used for the entirety of the loop. Given this, and
> +	 * the fact that no percpu data is used for the lookup there is no need
> +	 * to disable preemption.
> +	 *
> +	 * It is still necessary to get a valid cpu, though, to probe for the
> +	 * default PMU instance as userspace is not required to specify a PMU
> +	 * type. In order to uphold the preexisting behavior KVM selects the
> +	 * PMU instance for the core where the first call to the
> +	 * KVM_ARM_VCPU_PMU_V3_CTRL attribute group occurs. A dependent use case
> +	 * would be a user with disdain of all things big.LITTLE that affines
> +	 * the VMM to a particular cluster of cores.
> +	 *
> +	 * In any case, userspace should just do the sane thing and use the UAPI
> +	 * to select a PMU type directly. But, be wary of the baggage being
> +	 * carried here.
> +	 */

Thanks for humoring me :-)
