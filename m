Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D6C1F3B8A
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 05:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066195; cv=none; b=tSGl490Vzeh2eRMeYXTXtc0kTZYn5uN4JnS6ASNLVXq1I+YyhXtsgCNmvOx6FUekLMsl+Fvn+dAt0gT125/ftVg094yYt9ZOvo73mxT3+x1HuNSKw6qq8WlUC4O5eEqx/KFyC0MAC+OFhPEY8aAaa+cwZDniEzsmhMQAN9+voow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066195; c=relaxed/simple;
	bh=CAzIhVsIFi4/3ByvCvQJWA17BzFjI6peJWwCPB4wM7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AsKpwGt7EpUO4s8G2mma1X9GhoIsmU6ZzqF5u/17QZTtpmuJtkjHs8H5cZVHitpIQSDH0cBF10XbtuvuR5cLsNOXlxLMqlWWzkHL9Fj8yhRg8djr7AIIgyy8b4ulY9w8tpGxcQBNGVD/XytGsIz2cUH1h6uvXz58CHzQ7+pC4Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BbvRbR/S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BbvRbR/S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741066193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5NVuBpJLlZnTOLyK2ct+nvinMD4r7ch0nzerHgxTzg=;
	b=BbvRbR/SdaID1FaUt2dMWqEecqmXX1iUemD4ODsS5hXcJjtgGQDzGxItGpXbGG2SimG7W7
	kNwTytLl7z7B3W6HtOPTL10PGiwXPhH8Y4P7bFlgiQO0FsWslFiNvDVhM2Kmu+wYsD8VfY
	3B76kHlmCADaP54W2fIFRKBRRJKcPYc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-KI2ciSi1Pcaujc-CeEuf9A-1; Tue, 04 Mar 2025 00:29:49 -0500
X-MC-Unique: KI2ciSi1Pcaujc-CeEuf9A-1
X-Mimecast-MFC-AGG-ID: KI2ciSi1Pcaujc-CeEuf9A_1741066189
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2feda4729e9so8633700a91.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 21:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741066189; x=1741670989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5NVuBpJLlZnTOLyK2ct+nvinMD4r7ch0nzerHgxTzg=;
        b=RDX4+xPSkfjgzddhY7PkxCVRxXqr/2LtUS6nkNeGBbElS2AGw4mgZ4ni6tJjnRJchx
         6vGn95cyHtak2B4ze7gbGGOoaO8tcDhihz0aw6IiCV6H1AMUl/+624Oy7Wz2aibb47rk
         8MQIZaqFmLE7Cq4Eq6kCeOk4EvMD71OxKfCiDQ/BbgSqxO2RgguIqvkJ+hV2mXPYSFFE
         IjJExH81qan2UqqAE8CPu1KGg3+4tAO0VifDpVtKqqxIvCg9kvfuIxIT3QUuJ82h7DUW
         UZ4XpH61atP8ntwTN0gzRM0Yb4KQEiblEcaDcE8UaxsbTX9MqO8K6/dPElDRHQpWy52X
         gJsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjQANLG9+mIIEXMjxzQRcvRmkzOnlqyWVgOOE3iPNadWPq6lHC9YfXiu5oWFG6ckbpYSYj/x4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1HJ2d5Kb9EpKJZmdCj7T44LKcXOLtXF3feJRFs9BEd1P29al3
	EFosV/iYx5a7H/rEcHibcR5fLi0hYvbHhTafTL7erxfnm/SLX58fRAFU96ux9n/vSLfiWrPLy0L
	Thnmky7N+LwIKzx+w91SOLiuZA5AwJU4zsQmcKjoWLIdAWwxXy/9ZYg==
X-Gm-Gg: ASbGncvYmU6VKCYiPckT0B0WFPC1UQJ6dSwQGJadq1js0Y45UNcEjkfM8pW5mjA26pE
	EO+zqs/kO2abt5Vhtiq9fFCNdhq2BB4UaZ4DbdCeVjOvJeZhD9x2xf1Ngs3TkC//EY0Xh2iewCR
	F8OuVldG2mXdIV3njxNjDgEDtKwxMkRNwezN8k0sZ9EAIWRMsR9RyY5rphWtqKOc0QsG1lkIwtz
	w9bk7Q6G4sjxw521HDRMFwv08S1w2Khdxy8dUrZGbxvs9Soh8X6ix4GeEw4TDv7LqjsjByCcdMK
	jWd99W3nOVAWWIUSew==
X-Received: by 2002:a05:6a21:3d83:b0:1f3:289e:36d9 with SMTP id adf61e73a8af0-1f3289e3a2fmr9220372637.40.1741066188755;
        Mon, 03 Mar 2025 21:29:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWg73A+PEVA+mHDKOgju64xlHqN6DY26ozmlm+MoWJ+dQTX/kJaWOUjo5QtcrSQGbf6nj6HQ==
X-Received: by 2002:a05:6a21:3d83:b0:1f3:289e:36d9 with SMTP id adf61e73a8af0-1f3289e3a2fmr9220343637.40.1741066188462;
        Mon, 03 Mar 2025 21:29:48 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af174933aa5sm6247124a12.46.2025.03.03.21.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:29:47 -0800 (PST)
Message-ID: <b4cc58db-b9d8-4cdb-8954-8697972a54ae@redhat.com>
Date: Tue, 4 Mar 2025 15:29:38 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 23/45] KVM: arm64: Validate register access for a Realm
 VM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-24-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-24-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AaSvegERV-RkXA1l6US8i4YXrg8-g0JAaTsCWFI23QA_1741066189
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> The RMM only allows setting the GPRS (x0-x30) and PC for a realm
> guest. Check this in kvm_arm_set_reg() so that the VMM can receive a
> suitable error return if other registers are accessed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Upper GPRS can be set as part of a HOST_CALL return, so fix up the
>     test to allow them.
> ---
>   arch/arm64/kvm/guest.c | 40 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
> 

The subject isn't 100% matching with what has been done in this patch.
It's actually to limit the scope for the write operations. The question
is do we need similar limitation for the read operations? If not, it's
nice to explain in the change log :)

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2196979a24a3..ff0306650b39 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -73,6 +73,24 @@ static u64 core_reg_offset_from_id(u64 id)
>   	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>   }
>   
> +static bool kvm_realm_validate_core_reg(u64 off)
> +{
> +	/*
> +	 * Note that GPRs can only sometimes be controlled by the VMM.
> +	 * For PSCI only X0-X6 are used, higher registers are ignored (restored
> +	 * from the REC).
> +	 * For HOST_CALL all of X0-X30 are copied to the RsiHostCall structure.
> +	 * For emulated MMIO X0 is always used.
> +	 */
> +	switch (off) {
> +	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
> +	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
> +	case KVM_REG_ARM_CORE_REG(regs.pc):
> +		return true;
> +	}
> +	return false;
> +}
> +
>   static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>   {
>   	int size;
> @@ -783,12 +801,34 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	return kvm_arm_sys_reg_get_reg(vcpu, reg);
>   }
>   
> +/*
> + * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
> + * that are available depends on the Realm state and the reason for the last
> + * exit.  All other registers are reset to architectural or otherwise defined
> + * reset values by the RMM, except for a few configuration fields that
> + * correspond to Realm parameters.
> + */
> +static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
> +		u64 off = core_reg_offset_from_id(reg->id);
> +
> +		return kvm_realm_validate_core_reg(off);
> +	}
> +
> +	return false;
> +}
> +
>   int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   {
>   	/* We currently use nothing arch-specific in upper 32 bits */
>   	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
>   		return -EINVAL;
>   
> +	if (kvm_is_realm(vcpu->kvm) && !validate_realm_set_reg(vcpu, reg))
> +		return -EINVAL;
> +
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
>   	case KVM_REG_ARM_FW:

Thanks,
Gavin

