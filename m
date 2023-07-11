Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2916C18AF7
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689071706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C44gRJnvKK81y1lA/2BMOESkp91eyGlQDqSpbuXrUhI=;
	b=KbEiKk88PnmXn8P9zqstnKw4YfDOzEL8EMZXcmbztA9ZiypK25196LizYqe9EKhkqde1rX
	9zdFpDgxUJxobjH7MCuRzsf6ASRforqJ+/4kITnfTrPKCGycKPcsMzbq9zUP9lK9faqO39
	oDMc/AJOlsqafpTeN78rZFHQAMDWbcE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-6Z33H3wnMPCjqtyJfTFaLA-1; Tue, 11 Jul 2023 06:35:05 -0400
X-MC-Unique: 6Z33H3wnMPCjqtyJfTFaLA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-765a632f342so621070585a.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 03:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689071705; x=1691663705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C44gRJnvKK81y1lA/2BMOESkp91eyGlQDqSpbuXrUhI=;
        b=cTXX0nO5607xptB2ebJLCp0HWuzttuykyE3fFsU1cuL41qd+jTR9gZyD6VLp7LMsNk
         CzD76CK0Pjn9mJIBnfDOg9Yh61fC4NcNQxbZRcXTvFDEXy/cKcRrHX8HIE9SL7sCMSaS
         eOekcYjKSmdC6etbZR8uromVYYJAK8ODoJeHvziRPL7aipTTiuapYoL2TaEPeGjo58r9
         0IBcsfFKNR7UIS/leulWf2Uc75dS/JedQm4bgsslGQe7jifOpDChVn5KYBgJW2snGg8G
         HtB+4GzDgZ/s0FNvEtPNSyc0n2Bl1NvYr/t8yx1OzDlLewztf3tmS8v2GuuBhyulnEKK
         mArQ==
X-Gm-Message-State: ABy/qLaW7To+ATSZRFgToNKO45Fu/zd5n0aXn1CjHV85yddLmuhDIs59
	RYedkD5mvbqGngZs0QL9h1065E8tlfRYAgE/t4fstAF83igNlAGxDM2Ad9YGbINX7Z6mBBewiYf
	6Aqnb/EuzqopqEbYc
X-Received: by 2002:a37:9341:0:b0:75e:6837:19f8 with SMTP id v62-20020a379341000000b0075e683719f8mr13771833qkd.54.1689071705001;
        Tue, 11 Jul 2023 03:35:05 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGxlq/7A4GdGaqnzBhicpMrwD0GAvJBt2eUgALa1GF781GEgnyNumTSHDI13TYvBhLFGWjlpA==
X-Received: by 2002:a37:9341:0:b0:75e:6837:19f8 with SMTP id v62-20020a379341000000b0075e683719f8mr13771821qkd.54.1689071704760;
        Tue, 11 Jul 2023 03:35:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a140d00b00767e62bcf0csm167613qkj.65.2023.07.11.03.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 03:35:04 -0700 (PDT)
Message-ID: <d49225cb-3240-ea8e-11e6-b8ed30ce2fc8@redhat.com>
Date: Tue, 11 Jul 2023 12:35:00 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting
 non-CNTKCTL_EL1 bits
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 stable@vger.kernel.org
References: <20230627140557.544885-1-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230627140557.544885-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,
On 6/27/23 16:05, Marc Zyngier wrote:
> It recently appeared that, whien running VHE, there is a notable
when
> difference between using CNTKCTL_EL1 and CNTHCTL_EL2, despite what
> the architecture documents:
> 
> - When accessed from EL2, bits [19:18] and [16:10] same bits have
s/same bits/of CNTKCTL_EL1/ ?
>   the same assignment as CNTHCTL_EL2
> - When accessed from EL1, bits [19:18] and [16:10] are RES0
s/bits/the same bits/
> 
> It is all OK, until you factor in NV, where the EL2 guest runs at EL1.
> In this configuration, CNTKCTL_EL11 doesn't trap, nor ends up in
s/CNTKCTL_EL11/CNTKCTL_EL1
> the VNCR page. This means that any write from the guest affecting
> CNTHCTL_EL2 using CNTKCTL_EL1 ends up losing some state. Not good.
> 
> The fix it obvious: don't use CNTKCTL_EL1 if you want to change bits
> that are not part of the EL1 definition of CNTKCTL_EL1, and use
> CNTHCTL_EL2 instead. This doesn't change anything for a bare-metal OS,
> and fixes it when running under NV. The NV hypervisor will itself
> have to work harder to merge the two accessors.
> 
> Note that there is a pending update to the architecture to address
> this issue by making the affected bits UNKNOWN when CNTKCTL_EL1 is
> user from EL2 with VHE enabled.
used
> 
> Fixes: c605ee245097 ("KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # v6.4
> ---
>  arch/arm64/kvm/arch_timer.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 0696732fa38c..6dcdae4d38cb 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -827,8 +827,8 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
>  	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
>  	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
>  
> -	/* This only happens on VHE, so use the CNTKCTL_EL1 accessor */
> -	sysreg_clear_set(cntkctl_el1, clr, set);
> +	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
> +	sysreg_clear_set(cnthctl_el2, clr, set);
>  }
>  
>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
> @@ -1563,7 +1563,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  void kvm_timer_init_vhe(void)
>  {
>  	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
> -		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
> +		sysreg_clear_set(cnthctl_el2, 0, CNTHCTL_ECV);
>  }
>  
>  int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

