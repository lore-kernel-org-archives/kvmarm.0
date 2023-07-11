Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A5218AFF
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689082687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1yG7su0lWGREXXiyOTctgrvSS6fNzhkoaCR5hRK7VuE=;
	b=a73Bg8CpVq7BzBCQK8SQWTDjQNU7iTeLoZfvuQbDb45TAaesg6Ki8TKk6s2c2SSlLSthiL
	fpv1O6i08gQ1qXjPfdIUCuwb+xdpHWx1bJVAioIz8Xrpu0Zq+Q6pJ8ZB8DuXiWTCLSfAwk
	E6j8XdnCED3t4N7Rq085YH+3zbPzxnk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248--vdtfuo6P7igO4RvEfp7cw-1; Tue, 11 Jul 2023 09:38:06 -0400
X-MC-Unique: -vdtfuo6P7igO4RvEfp7cw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-51dcec9425bso867832a12.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 06:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689082685; x=1691674685;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1yG7su0lWGREXXiyOTctgrvSS6fNzhkoaCR5hRK7VuE=;
        b=irHpnVCwZbPIlKw6UdQqFmuk9mWP9T4Wbjh444UoCK3WSDVt2IcaAO2WmNN9MQAkV6
         7C+/K0eSypSYahdEnFrGLU30rD0aKhOzVZvTt2SzklznTonslluWj2E13EbnjM/+/+Ye
         sA0jAfhwEHYWUU5s1yr9ZBGEiw2/3f48tX0hP23OdLUluqkQOrTUq2LkwjMGhxuEOG99
         G7ah2Abd0ficR8zkXE1CmpqKPFadLvUEkdN+wvNDvMH6YNFjNRrS997Xn66F7+ozrqRF
         iNFNYKW9U9M4Nx6XdpCWNsb947OAAgGpgnI/NYQOUf6sSnn7bkNmfKVRtDEu78/e0TT/
         XMrQ==
X-Gm-Message-State: ABy/qLZQcsJCINl/f536KSAQpPSBekFoPazhIeLyztPzCa0AuvML2Gu0
	E5qGgzj0rwy9lFF+HYk/tK1qTp+VQf9cplI0CJgjjrEUYz76idDTsQRVEXneOpc0bwuuFFOuHsb
	OtwAPVqA5khFXbIPrqvKOPbyccqZ7lg==
X-Received: by 2002:a05:6a20:3ca7:b0:11a:efaa:eb88 with SMTP id b39-20020a056a203ca700b0011aefaaeb88mr20308668pzj.3.1689082684891;
        Tue, 11 Jul 2023 06:38:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH3waarxfx/9EXBW0IYRWtInIeKrArTDBJjjntjjyhzn4UJud7oSfSNgQtZCczPhPmQBvKbiQ==
X-Received: by 2002:a05:6a20:3ca7:b0:11a:efaa:eb88 with SMTP id b39-20020a056a203ca700b0011aefaaeb88mr20308654pzj.3.1689082684627;
        Tue, 11 Jul 2023 06:38:04 -0700 (PDT)
Received: from [10.72.12.150] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t9-20020a63b709000000b0055be951145csm1463853pgf.36.2023.07.11.06.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 06:38:04 -0700 (PDT)
Message-ID: <5995ad7a-0867-a3d7-09cd-78382501e779@redhat.com>
Date: Tue, 11 Jul 2023 21:37:59 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/4] KVM: arm64: Remove pointless check for changed
 init target
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
 <20230710193140.1706399-3-oliver.upton@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230710193140.1706399-3-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/11/23 03:31, Oliver Upton wrote:
> At any time there is only a single valid value for KVM_ARM_VCPU_INIT,
> depending on the current CPU implementation. In all likelihood, this
> will be the generic ARMv8 target.
> 
> Drop the pointless check for a changed target value between calls to
> KVM_ARM_VCPU_INIT and instead rely on the check against
> kvm_target_cpu().
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/arm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c2c14059f6a8..3f844934b9f3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1212,8 +1212,7 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
>   {
>   	unsigned long features = init->features[0];
>   
> -	return !bitmap_equal(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES) ||
> -			vcpu->arch.target != init->target;
> +	return !bitmap_equal(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
>   }
>   
>   static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,

-- 
Shaoqin

