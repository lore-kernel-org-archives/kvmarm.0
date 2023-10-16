Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AE1347CA
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 19:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TybcCOhh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697485513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xZ+lM6qiUe430iAXN5s22ta/PRg8BuZiUs2eY9X5sX4=;
	b=TybcCOhhIEEA1rZXE2ppZ2w5ER3UWMZSc+G6GVo/EF4Ys8vY+MYX6gD7zcR2nIkAid+s88
	PI7HDkNRflqxUCk0FEFGE5SyO+6/t6FgadEIm+hsLblJVj5baW4QQxNlAhMNbwYOl4WG0f
	Z8FKR7/CK0EYspPGZt0JXQXvRE4NpAQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-CrE9pcnbMIW4vF01IysFiQ-1; Mon, 16 Oct 2023 15:45:12 -0400
X-MC-Unique: CrE9pcnbMIW4vF01IysFiQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4199725b054so58337041cf.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 12:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485512; x=1698090312;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZ+lM6qiUe430iAXN5s22ta/PRg8BuZiUs2eY9X5sX4=;
        b=nl9ZC7gOSaY8uA1BaGxcOV4p9etkkcpsbNejYzn42p2wmxEBBW+V008AJJJ4Q3JPin
         1emJxp+CKpFUjhbK+3YUbXi9N36VzoejZWXb0xojsZodRmduAg7qLQ+Vcjz5AUM+ykKp
         wSXSAsX6xyaSlZw8VAtOfHhEnRBOn27KAlhcFQ726gvd48lxO0OB+pyuvKpgqr6joM37
         L2hXaUpfQcspQwlasHhsXEokN2FCiRHvkvfIwXRCIR6uKy/fr1eXz0YFNpw2YSqoy6hV
         78Hqgw5sWmI+9JXiBBccq3Gz7Ve4l/+chSDqZw5i4Oc6hGAe3fjHGpswjbwkJVOaSGun
         cibA==
X-Gm-Message-State: AOJu0Yxiu6bizsD9rJJypucoYcAqCC2qNY5oGhtfy2tuSz49D563j3Gq
	8XAxkLRxt+psMX8OLNpOk1jpNQifJbQB6Sw6ZmO+P99J+4KBZgvSEjpPcMSGOpu6el+3aT9AzfO
	n2WoTXlhw6ZzSNKjt
X-Received: by 2002:a05:622a:1647:b0:40f:ce6d:775e with SMTP id y7-20020a05622a164700b0040fce6d775emr358688qtj.42.1697485511789;
        Mon, 16 Oct 2023 12:45:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+BVq+KUxheztoApR7LQWN+TLgEn9lkpkOXaqFKlCFxMhMymfU8fkOizIZF+6mTbltVn/Xxg==
X-Received: by 2002:a05:622a:1647:b0:40f:ce6d:775e with SMTP id y7-20020a05622a164700b0040fce6d775emr358668qtj.42.1697485511520;
        Mon, 16 Oct 2023 12:45:11 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id h10-20020ac85e0a000000b00418122186ccsm9852qtx.12.2023.10.16.12.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 12:45:10 -0700 (PDT)
Message-ID: <76f9ca4a-a805-0b15-78ff-f1a50282abba@redhat.com>
Date: Mon, 16 Oct 2023 21:45:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 01/12] KVM: arm64: PMU: Introduce helpers to set the
 guest's PMU
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-2-rananta@google.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-2-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reiji,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Introduce new helper functions to set the guest's PMU
> (kvm->arch.arm_pmu) either to a default probed instance or to a
> caller requested one, and use it when the guest's PMU needs to
> be set. These helpers will make it easier for the following
> patches to modify the relevant code.
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/pmu-emul.c | 50 +++++++++++++++++++++++++++------------
>  1 file changed, 35 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 3afb281ed8d2..eb5dcb12dafe 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -874,6 +874,36 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	return true;
>  }
>  
> +static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> +{
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	kvm->arch.arm_pmu = arm_pmu;
> +}
> +
> +/**
> + * kvm_arm_set_default_pmu - No PMU set, get the default one.
> + * @kvm: The kvm pointer
> + *
> + * The observant among you will notice that the supported_cpus
> + * mask does not get updated for the default PMU even though it
> + * is quite possible the selected instance supports only a
> + * subset of cores in the system. This is intentional, and
> + * upholds the preexisting behavior on heterogeneous systems
> + * where vCPUs can be scheduled on any core but the guest
> + * counters could stop working.
> + */
> +static int kvm_arm_set_default_pmu(struct kvm *kvm)
> +{
> +	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
> +
> +	if (!arm_pmu)
> +		return -ENODEV;
> +
> +	kvm_arm_set_pmu(kvm, arm_pmu);
> +	return 0;
> +}
> +
>  static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -893,7 +923,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  				break;
>  			}
>  
> -			kvm->arch.arm_pmu = arm_pmu;
> +			kvm_arm_set_pmu(kvm, arm_pmu);
>  			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
>  			ret = 0;
>  			break;
> @@ -917,20 +947,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		return -EBUSY;
>  
>  	if (!kvm->arch.arm_pmu) {
> -		/*
> -		 * No PMU set, get the default one.
> -		 *
> -		 * The observant among you will notice that the supported_cpus
> -		 * mask does not get updated for the default PMU even though it
> -		 * is quite possible the selected instance supports only a
> -		 * subset of cores in the system. This is intentional, and
> -		 * upholds the preexisting behavior on heterogeneous systems
> -		 * where vCPUs can be scheduled on any core but the guest
> -		 * counters could stop working.
> -		 */
> -		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
> -		if (!kvm->arch.arm_pmu)
> -			return -ENODEV;
> +		int ret = kvm_arm_set_default_pmu(kvm);
> +
> +		if (ret)
> +			return ret;
>  	}
>  
>  	switch (attr->attr) {

