Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40C178383
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 06:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728456557; cv=none; b=fiGkxu2WmHhgnwe2SYjutm2oZeU0XVwEvQwkSvumZY2Dq8N4FSX1n+8CV1cA1Ti8NrjE1HfyIztqS66srtXZ72koJrZF0ul9aCaIro6q0xm1WKpFo9nLnk0HmdQyFJE5MHaBo0xGZI/MBmQLkm0K4EtlBeqho6PQyvYcfclMgug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728456557; c=relaxed/simple;
	bh=VQJKumCq/VdZTNgyzyqm80JbwfeGjysZuc059v075PU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MX3OXHvMvPVRJAXh9aqbTx0iFGILijbytvwDvPVed9eBJhePJb1APugtrkbx+RAwsgsgjOJHLCsy069runSUiRvRsCAC9gqoWA+iPr9WonfO47aHqfBkvmOsMrE7ZBfcTi5yDJxSl1FhaYeEPWiuNH7sTuHfA8YbYRdIgUMtp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8531f+j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8531f+j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728456553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6tLCoZvkiK7k3dI0cr65Uum2yBNbkpbhoTMZbC0FENA=;
	b=b8531f+juEjk8+e3aeIahfYCAdgeJ4TvE5ed3cDIemsneAc6VZZzTSoh/3B9ex0s4B9qFo
	mh7OU3Upcj/66vTZiqZZZNmOmfysQ4lYkA/XLFsuP1e5Tj1tgDAEQoG5MPJULVhjZwzsk5
	gO5LKi768Ddmvc3QUMC9Fu0xLTluFHY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-ZBEdpj-xOa2_AwqqdKBGnA-1; Wed, 09 Oct 2024 02:48:55 -0400
X-MC-Unique: ZBEdpj-xOa2_AwqqdKBGnA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-6e31d9c8efcso20958007b3.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Oct 2024 23:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728456534; x=1729061334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6tLCoZvkiK7k3dI0cr65Uum2yBNbkpbhoTMZbC0FENA=;
        b=GOFwdKkQOoSPLRLoIUXHKFs9pvZyb8yskZ44miCJ2pqLBKyrJ3f/qEttZqCCy0f4UC
         4Kog6MSMsgQzWF63BGpOWGdc8n7s3onRyry2nOFTwcPchy2ERRmCi/W35Yze+Ri+TD4A
         LGegCFe9bKwVofBnSLUDG+IxsUv5/jym9Q6SsGa3nEpzLjNFGXRdoXtDe4Unt/J1eoZ3
         /Vcb9Qjx1C0sXIy7xE3lZsOU+ywAU0JnaDwD/SmCFRGnBoa8aG/TuyI+4XQLAj4+zsbr
         2DcZ0lIM2K8/OVXZU1jxEEGkcnt6+YFJBKzUulP4CmYaCgsEHX72fUoNsM1odfqX7Gi8
         boNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUra7sqOfPcEFEmVAiuaZPA113EOx918ehxFW+RoMFJ+lM8bDm0+OH1ZV+LYPYbxj8TAc0KVzU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw59tPDI8aMIz3lzd7KWE8BoYkfGbadx6marVjZk1x7roTwegUS
	fh9PMNEn2cNsGS9q5e2R9hFjTVLB+KqVw5cAOQ1S03lYg/Yps7Io652GLWp8qnm7VsWdwXp7L+Q
	TtfBEti8bdjmgJr2Ti+k4jQqbfrzdkyMdFghwTLaHnDpsRl0FJpdWzw==
X-Received: by 2002:a05:6830:6206:b0:70f:3720:16bb with SMTP id 46e09a7af769-716a42054c6mr1141897a34.19.1728456057889;
        Tue, 08 Oct 2024 23:40:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVHdjMTGJxNQemoknjVTV63mxoEa/f2mp8WYoWbQqe7q56hAA5nt/KYNaAP25rLAEmOU0KqA==
X-Received: by 2002:a05:6830:6206:b0:70f:3720:16bb with SMTP id 46e09a7af769-716a42054c6mr1141876a34.19.1728456057556;
        Tue, 08 Oct 2024 23:40:57 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d7d4a0sm7099554b3a.212.2024.10.08.23.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:40:57 -0700 (PDT)
Message-ID: <ba5bf078-fac5-4106-bfe2-778960633fdb@redhat.com>
Date: Wed, 9 Oct 2024 16:40:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] KVM: arm64: Disable MPAM visibility by default and
 ignore VMM writes
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-7-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004110714.2051604-7-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 9:07 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> but didn't add trap handling. A previous patch supplied the missing trap
> handling.
> 
> Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
> be migratable, but there is little point enabling the MPAM CPU
> interface on new VMs until there is something a guest can do with it.
> 
> Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
> that supports MPAM, politely ignore the VMMs attempts to set this bit.
> 
> Guests exposed to this bug have the sanitised value of the MPAM field,
> so only the correct value needs to be ignored. This means the field
> can continue to be used to block migration to incompatible hardware
> (between MPAM=1 and MPAM=5), and the VMM can't rely on the field
> being ignored.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/kvm/sys_regs.c | 53 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1fd08f12f2bb..f0c55d3907d9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1723,6 +1723,23 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>   
>   	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
>   
> +	/*
> +	 * MPAM is disabled by default as KVM also needs a set of PARTID to
> +	 * program the MPAMVPMx_EL2 PARTID remapping registers with. But some
> +	 * older kernels let the guest see the ID bit.
> +	 */
> +	val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
> +
> +	return val;
> +}
> +
> +static u64 read_sanitised_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
> +					  const struct sys_reg_desc *rd)
> +{
> +	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
> +
> +	val &= ~ID_AA64PFR1_EL1_MPAM_frac_MASK;
> +
>   	return val;
>   }
>   
> @@ -1834,9 +1851,38 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   }
>   
>   static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> -			       const struct sys_reg_desc *rd, u64 val)
> +			       const struct sys_reg_desc *rd, u64 user_val)
>   {
> -	return set_id_reg(vcpu, rd, val);
> +	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +	u64 mpam_mask = ID_AA64PFR0_EL1_MPAM_MASK;
> +
> +	/*
> +	 * Commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits
> +	 * in ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to
> +	 * guests, but didn't add trap handling. KVM doesn't support MPAM and
> +	 * always returns an UNDEF for these registers. The guest must see 0
> +	 * for this field.
> +	 *
> +	 * But KVM must also accept values from user-space that were provided
> +	 * by KVM. On CPUs that support MPAM, permit user-space to write
> +	 * the sanitizied value to ID_AA64PFR0_EL1.MPAM, but ignore this field.
> +	 */
> +	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
> +		user_val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
> +
> +	return set_id_reg(vcpu, rd, user_val);
> +}
> +
> +static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd, u64 user_val)
> +{
> +	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
> +	u64 mpam_mask = ID_AA64PFR1_EL1_MPAM_frac_MASK;
> +
> +	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
> +		user_val &= ~ID_AA64PFR1_EL1_MPAM_frac_MASK;
> +
> +	return set_id_reg(vcpu, rd, user_val);
>   }
>   
>   /*
> @@ -2390,7 +2436,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   		      ID_AA64PFR0_EL1_RAS |
>   		      ID_AA64PFR0_EL1_AdvSIMD |
>   		      ID_AA64PFR0_EL1_FP)),
> -	ID_SANITISED(ID_AA64PFR1_EL1),
> +	ID_FILTERED(ID_AA64PFR1_EL1, id_aa64pfr1_el1,
> +		    ~ID_AA64PFR1_EL1_MPAM_frac),

The 'reset' callback has been changed from kvm_read_sanitised_id_reg() to the newly
introduced read_sanitised_id_aa64pfr1_el1(). They're not interchangeable apart from
the MPAM_frac bits. For example, The SME bit has been hidden unconditionally and
the MTE bit is hidden conditionally in __kvm_read_sanitised_id_reg(), called by
kvm_read_sanitised_id_reg().

>   	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
>   	ID_UNALLOCATED(4,3),
>   	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),

Thanks,
Gavin

