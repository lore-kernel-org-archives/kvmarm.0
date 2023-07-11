Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A732598
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689080469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dM/oA3ylwQcxdQzGFJBZacj4io37QMRhZqmBvFcKjyM=;
	b=dgy27UdoeESFXLwFbXlmOiR9aM3asqPNROr4MH/KIk5Pjj+dwmJdp0BgSqi9NZ9rMH9Rzc
	ZFLewpc8HunozZ8AuA5TWs88PMQ5UBxHUlLCgC61FiFpRg5dKvZzXoMf1ZE0BFZHaaWkgG
	1Q/H5uPtN9+vc5lc/hh/kVb6K80iXRs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-GDXQ_eTRNqCU5cVXFONYIw-1; Tue, 11 Jul 2023 09:01:08 -0400
X-MC-Unique: GDXQ_eTRNqCU5cVXFONYIw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-262d2cae3efso1130730a91.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 06:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689080467; x=1689685267;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dM/oA3ylwQcxdQzGFJBZacj4io37QMRhZqmBvFcKjyM=;
        b=aKKljbnIgCo1whVIsAl4c+ZtbERXVfuYjR1Sl1XgOldLfYSYg0d8soSBTLoXE1OAj+
         R+ZMkF6OU7POiG3quY1izXAmjhFmIXqsMYZG9ftn5lmQWIh4vT1kqyqXqAqFj1hMJRBJ
         WoEZmLSDb2+YUWV6c8cJnkjR2zlZ1eiH00c/tCEEcqBp+gsJ07Vgp5aNzOblo7RictkM
         gTuekDM2+bLcpliL67T8SlpNgAj7JVGCEq8Z5Nk9RvF4tVr9/3JkKXdN4NpVvMLOpHu0
         IQBFE8keVmwMeytMilRev5cobh0LGB7FlE0xPl8GMgka+j2tyWPSg7b7KjPN0EntnP8W
         STlQ==
X-Gm-Message-State: ABy/qLYA31rrHnYu58JX6j/uXHVvQ3EMXMXfihtnBLgu1CxwIXV951Ah
	H/r44LH6T4mzdb1F+qhTHINQ3ppmkLp6zJ1VvyqflmbBS4YLev193QY5abpPI4RhvNEZeZcY67O
	1QdOEc6aMu4A8urNf
X-Received: by 2002:a17:90b:1946:b0:262:c2a1:c01f with SMTP id nk6-20020a17090b194600b00262c2a1c01fmr16865562pjb.3.1689080467351;
        Tue, 11 Jul 2023 06:01:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFrDDIqLGT9ndqAm+HeCdCQR/rFwQCn7tXXse5z4hCaX8XXiR26OPsEVob4h+T8oo/l/5/nHw==
X-Received: by 2002:a17:90b:1946:b0:262:c2a1:c01f with SMTP id nk6-20020a17090b194600b00262c2a1c01fmr16865514pjb.3.1689080466739;
        Tue, 11 Jul 2023 06:01:06 -0700 (PDT)
Received: from [10.72.12.150] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a1f4600b00262e485156esm8656011pjy.57.2023.07.11.06.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 06:01:06 -0700 (PDT)
Message-ID: <ffc2f370-97e1-0252-0322-28bffddcbe6b@redhat.com>
Date: Tue, 11 Jul 2023 21:00:54 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/4] KVM: arm64: Delete pointless switch statement in
 kvm_reset_vcpu()
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
 <20230710193140.1706399-2-oliver.upton@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230710193140.1706399-2-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/11/23 03:31, Oliver Upton wrote:
> The vCPU target hasn't mattered for quite a long time now. Delete the
> useless switch statement in kvm_reset_vcpu(), which hilariously only had
> a default case in it.
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/reset.c | 25 ++++++++++---------------
>   1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index bc8556b6f459..7a65a35ee4ac 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -248,21 +248,16 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   		}
>   	}
>   
> -	switch (vcpu->arch.target) {
> -	default:
> -		if (vcpu_el1_is_32bit(vcpu)) {
> -			pstate = VCPU_RESET_PSTATE_SVC;
> -		} else if (vcpu_has_nv(vcpu)) {
> -			pstate = VCPU_RESET_PSTATE_EL2;
> -		} else {
> -			pstate = VCPU_RESET_PSTATE_EL1;
> -		}
> -
> -		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -		break;
> +	if (vcpu_el1_is_32bit(vcpu))
> +		pstate = VCPU_RESET_PSTATE_SVC;
> +	else if (vcpu_has_nv(vcpu))
> +		pstate = VCPU_RESET_PSTATE_EL2;
> +	else
> +		pstate = VCPU_RESET_PSTATE_EL1;
> +
> +	if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
> +		ret = -EINVAL;
> +		goto out;
>   	}
>   
>   	/* Reset core registers */

-- 
Shaoqin

