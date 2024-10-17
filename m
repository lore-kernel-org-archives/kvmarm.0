Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C13C30
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729125690; cv=none; b=ioZO76miIYt2pwtcPNoxtTTbQ03/0f9Dk2TVTqaf/wBNqx7vB2GXBze9zgrIzw6pr6ODa0h1GwYsSqUIlgJyRyrv9amFznnxXlzUO/4Nn8ud9ZLKPFF9DOVaHbv3OQ5QLU6Csz6ojjyLr/OHld/zjSBJeTHGLCYnYwmQjAoLY/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729125690; c=relaxed/simple;
	bh=O8zEwYc6dkvIVdbvr69Jpl3zP9gtHA3FcjA2rxf99uE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8uTMCynSWyHBum1HCyluXHlEDXbbDVHYG6d03bnXMfC9BSQQVyIxQLCyAo6io5HjIjE3kl1KXUnC/ISpH3BdrHpisqoaA+x9dS2JaJm2xcJD4/0ia+tcwqBLKCyCQfSfZTuK5r6OLJCgJY5TwQekAStEKTX6OrCFaSHXgd3gf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ROB2Ym+b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROB2Ym+b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729125687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=niTNkW+OclggLNNlY2+mg3vY9pQhEh6midy5UkQuFK4=;
	b=ROB2Ym+b/CTAbFojs06TlMJPowIxI++nZ/9oJ68hDrZh/cAdJhX7tas9fLJL2ibkyHPoNQ
	t2ova89Z7Y6jmfAqR/tLX+0UhoehTET9syvVJodJMiBoFumYACVURWSDYn3R1KeRNkVVXQ
	AWBG98mv+j3zUdwTBV0QaSoXL6yj2sI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-OxpKrUH8OgyX3RwPO0YM7w-1; Wed, 16 Oct 2024 20:41:23 -0400
X-MC-Unique: OxpKrUH8OgyX3RwPO0YM7w-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-20c70cc9d27so3335065ad.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 17:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729125683; x=1729730483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=niTNkW+OclggLNNlY2+mg3vY9pQhEh6midy5UkQuFK4=;
        b=p+QFLuD6yRjvKmcD5/GNOMtFtXR2MhYxTzU643osFPf1BxlaR0OkxHY92OGHPusobC
         Mrq+QlS3mfaCmihFzr3ZU33hmSEyfvBc5kOjc4yBR1Q4GuUYvS0gWuCxfG1Ms6a8RoZo
         ukN8ZW/1CbXUFAOjnzwaDhGn1RtjwB5SCqKp+2KUsgJ2vTCWg0X6rXp6EFWKqzWJoh0/
         Uo2t9NWupMRBXq536hl+8SeukmD8rmWZ0fvAnVA44S62Vh3tXftFDGDP+shGVUcuf3oA
         UplEWr31inaAYI394gYaE87HDBKHIlWJIigpwyTvPzw2wcfQZDeBpgzYtBoJ79oCx4zy
         vNFw==
X-Forwarded-Encrypted: i=1; AJvYcCUiwHUFq3S/DXnNADHC8T+CLwTytGKbY+D7t30rFogJkULN+P27UkDJIFTKxmJ0jyhGkyll8D0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXNBX+OfaPbZnEOLBHCA5l7UfQr727ppVeO2dL9d9Jy8k8Br52
	7Tv/hxQVsTPj7lsMTz2T2MuxNLLYgVfPgmy1cJUT2c2mbH27ong4AA6vTCffycGyFYcSMtT6Avf
	Qwh+sWNnTzoDZIeG8jqaop0mdfBsrV4luJmXbcUlY658N6HWdDNGQtg==
X-Received: by 2002:a17:903:18b:b0:20c:5e86:9b5e with SMTP id d9443c01a7336-20d27e7eb06mr83879645ad.3.1729125682799;
        Wed, 16 Oct 2024 17:41:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHawaEYV2O1eOxLrSm7MRPeaSYPxuZsNHFnRzCDycCmp1JJCAqkT9Li5rOzDL1eOM6hlm8bvQ==
X-Received: by 2002:a17:903:18b:b0:20c:5e86:9b5e with SMTP id d9443c01a7336-20d27e7eb06mr83879435ad.3.1729125682400;
        Wed, 16 Oct 2024 17:41:22 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d17fa5f2fsm34291385ad.119.2024.10.16.17.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 17:41:21 -0700 (PDT)
Message-ID: <f6475ddb-c583-4ad0-8511-1e7b76b8f716@redhat.com>
Date: Thu, 17 Oct 2024 10:41:14 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't
 completely ignored
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-8-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-8-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> The ID_AA64PFR0.MPAM bit was previously accidentally exposed to guests,
> and is ignored by KVM. KVM will always present the guest with 0 here,
> and trap the MPAM system registers to inject an undef.
> 
> But, this value is still needed to prevent migration when the value
> is incompatible with the target hardware. Add a kvm unit test to try
> and write multiple values to ID_AA64PFR0.MPAM. Only the hardware value
> previously exposed should be ignored, all other values should be
> rejected.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   .../selftests/kvm/aarch64/set_id_regs.c       | 100 +++++++++++++++++-
>   1 file changed, 99 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index 2a3fe7914b72..d985ead2cc45 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -433,6 +433,103 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
>   	}
>   }
>   
> +#define MPAM_IDREG_TEST	6
> +static void test_user_set_mpam_reg(struct kvm_vcpu *vcpu)
> +{
> +	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
> +	struct reg_mask_range range = {
> +		.addr = (__u64)masks,
> +	};
> +	uint64_t val, ftr_mask;
> +	int idx, err;
> +
> +	/*
> +	 * If ID_AA64PFR0.MPAM is _not_ officially modifiable and is zero,
> +	 * check that if it can be set to 1, (i.e. it is supported by the
> +	 * hardware), that it can't be set to other values.
> +	 */
> +
> +	/* Get writable masks for feature ID registers */
> +	memset(range.reserved, 0, sizeof(range.reserved));
> +	vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
> +
> +	/* Writeable? Nothing to test! */
> +	idx = encoding_to_range_idx(SYS_ID_AA64PFR0_EL1);
> +	ftr_mask = ID_AA64PFR0_EL1_MPAM_MASK;
> +	if ((masks[idx] & ftr_mask) == ftr_mask) {
> +		ksft_test_result_skip("ID_AA64PFR0_EL1.MPAM is officially writable, nothing to test\n");
> +		return;
> +	}
> +

The question is shall we proceed to test ID_AA64PFR1_EL1.MPAM_frac instead of
bailing when ID_AA64PFR0_EL1.MPAM accepts arbitrary values? To me, it doesn't
mean ID_AA64PFR1_EL1.MPAM_frac can accept arbitrary values when ID_AA64PFR0_EL1.MPAM
does.

@ftr_mask can be dropped since it's initialized to a fixed mask and used for
only for once.

     if (mask[idx] & ID_AA64PFR0_EL1_MPAM_MASK] == ID_AA64PFR0_EL1_MPAM_MASK) {
         :
     }

> +	/* Get the id register value */
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> +
> +	/* Try to set MPAM=0. This should always be possible. */
> +	val &= ~GENMASK_ULL(44, 40);
> +	val |= FIELD_PREP(GENMASK_ULL(44, 40), 0);
> +	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
> +	if (err)
> +		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM=0 was not accepted\n");
> +	else
> +		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM=0 worked\n");
> +
> +	/* Try to set MPAM=1 */
> +	val &= ~GENMASK_ULL(44, 40);
> +	val |= FIELD_PREP(GENMASK_ULL(44, 40), 1);
> +	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
> +	if (err)
> +		ksft_test_result_skip("ID_AA64PFR0_EL1.MPAM is not writable, nothing to test\n");
> +	else
> +		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM=1 was writable\n");
> +
> +	/* Try to set MPAM=2 */
> +	val &= ~GENMASK_ULL(43, 40);
> +	val |= FIELD_PREP(GENMASK_ULL(43, 40), 2);
> +	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
> +	if (err)
> +		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM not arbitrarily modifiable\n");
> +	else
> +		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM value should not be ignored\n");
> +

GENMASK_ULL(44, 40) looks wrong to me. According to the spec, GENMASK_ULL(43, 40)
is the correct mask. Besides, I think it would be nice to use ID_AA64PFR0_EL1_MPAM_MASK
here, for example:

     val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
     val |= FIELD_PREP(ID_AA64PFR0_EL1_MPAM_MASK, 2);

> +	/* And again for ID_AA64PFR1_EL1.MPAM_frac */
> +	idx = encoding_to_range_idx(SYS_ID_AA64PFR1_EL1);
> +	ftr_mask = ID_AA64PFR1_EL1_MPAM_frac_MASK;
> +	if ((masks[idx] & ftr_mask) == ftr_mask) {
> +		ksft_test_result_skip("ID_AA64PFR1_EL1.MPAM_frac is officially writable, nothing to test\n");
> +		return;
> +	}
> +
> +	/* Get the id register value */
> +	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), &val);
> +
> +	/* Try to set MPAM_frac=0. This should always be possible. */
> +	val &= ~GENMASK_ULL(19, 16);
> +	val |= FIELD_PREP(GENMASK_ULL(19, 16), 0);
> +	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), val);
> +	if (err)
> +		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM_frac=0 was not accepted\n");
> +	else
> +		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM_frac=0 worked\n");
> +
> +	/* Try to set MPAM_frac=1 */
> +	val &= ~GENMASK_ULL(19, 16);
> +	val |= FIELD_PREP(GENMASK_ULL(19, 16), 1);
> +	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), val);
> +	if (err)
> +		ksft_test_result_skip("ID_AA64PFR1_EL1.MPAM_frac is not writable, nothing to test\n");
> +	else
> +		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM_frac=1 was writable\n");
> +
> +	/* Try to set MPAM_frac=2 */
> +	val &= ~GENMASK_ULL(19, 16);
> +	val |= FIELD_PREP(GENMASK_ULL(19, 16), 2);
> +	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), val);
> +	if (err)
> +		ksft_test_result_pass("ID_AA64PFR1_EL1.MPAM_frac not arbitrarily modifiable\n");
> +	else
> +		ksft_test_result_fail("ID_AA64PFR1_EL1.MPAM_frac value should not be ignored\n");
> +}
> +

Similarly, ID_AA64PFR1_EL1_MPAM_frac_MASK can be used?

>   static void test_guest_reg_read(struct kvm_vcpu *vcpu)
>   {
>   	bool done = false;
> @@ -571,12 +668,13 @@ int main(void)
>   		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
>   		   ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
>   		   ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
> -		   ARRAY_SIZE(test_regs) + 2;
> +		   ARRAY_SIZE(test_regs) + 2 + MPAM_IDREG_TEST;
>   
>   	ksft_set_plan(test_cnt);
>   
>   	test_vm_ftr_id_regs(vcpu, aarch64_only);
>   	test_vcpu_ftr_id_regs(vcpu);
> +	test_user_set_mpam_reg(vcpu);
>   
>   	test_guest_reg_read(vcpu);
>   

Thanks,
Gavin

