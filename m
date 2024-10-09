Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3723A36D
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 06:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454363; cv=none; b=ZBIuz3Ytfc3McS6bopsszFis+J3SsNOgSgrVj5vjuJeBOZ1uX9Ao2+Uo0x25zOhxQbl/UXRFbB3OvB8OpHMR0i0iQ8v1InsBHHojgANvf4HsMiA7e/Lkzup2bd8Rau+lUTu7BKm+zdlBLgJv6fZmjcDf0SZhV1gdLlZ61VRizjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454363; c=relaxed/simple;
	bh=YZArur3xo7i/2B6ae+eMuVtMiHlANQ6P6ZT4tTG1fIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQdGKCjcCBd3aIPGaCUfdCgiYlp2FPW6GUN2X2wC0YY48T8VlpCPdZDtq52pEvIR9P/kYt2zARO4nZOyUdCmbWE0EKy+ZeTqFj4+0a1h1vJW279ZaB1S2VzM9PXCwgTfumPf4AuhrCTWxaTMoxfE6AZ9KpixpiSfIi+dp3lhZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ex3gADoT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ex3gADoT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728454360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWCrDVY1QHGwuzKsAgSCJUox8r6YSpQfYuO0QZvJ8G4=;
	b=ex3gADoTRtB6RAhUFzrcBwheyHard1Il4Q9ljbkC3I5HgW8LTy5ans3VdRHB6zxFBWTZTU
	+uhVRRv40aqSgcbAO489XPyHOgsI8pv1stiHANc6QpwQcZNrKwam+CxVyEEAqsAG5U6ZJY
	fpihjQ/h3lNfrxsd/8HL49gY/M+zXxQ=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-1S4WVrzcPm6l0BJUurGUnw-1; Wed, 09 Oct 2024 02:12:39 -0400
X-MC-Unique: 1S4WVrzcPm6l0BJUurGUnw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso500203a12.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Oct 2024 23:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728454359; x=1729059159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wWCrDVY1QHGwuzKsAgSCJUox8r6YSpQfYuO0QZvJ8G4=;
        b=LsYCVA4c+Qeaj442/iE6hmWJKIM9k241nZ1PUtdqyNkARTAG7/Nqa58Y0JyghhZGiU
         0/5hUmQVGhtvOV9K6SLrqUqjCnkW3MZjI6NjNLx4sGWOAG62wUcQ5wwWF9KTyu98HGk7
         3d36pYhQxb2QzMg3hpgH/G0GIodYIRtkaVXLGEpTIcQ5YRoM8EdxbHuDT2/bs701i9jE
         o1DAGI0RAE1s31swh7yR+n6UzEde+8DWDfPKFZlS+F1BjVXzPDSHPb6LW62m6acMmr71
         Tp6F9XOdD7Tuc/q9l8OIASo45bIRwsKDJZ7sGGj/vtND18rhe7Kqj3KsFB4XBgs+t31+
         YXoA==
X-Forwarded-Encrypted: i=1; AJvYcCWnHvrLdWLyv+DrQ3/zAQYtEbVq2nKSKxfwPDs4KEdCqGYVbYpzCTci3magyYw2cYDZ5ydxyYY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAbNX0Y85Tu7vG1hifN8PmXnme1bRbItIUOAmeUs90D1ZAsjWl
	6YKbOXQsA3PFNepc6CZMB38aK2p7IKUKNe3eUmPSRhJF51oUIjnQmS3+rNL1ssUz+y7Fl0S9Sr5
	aKEJKI1nbC0cC5c96jTMcgcwXovl865LB43IQOWlhbMlkM5V9CQj+Zg==
X-Received: by 2002:a17:90a:9a9:b0:2da:6e46:ad48 with SMTP id 98e67ed59e1d1-2e2a0758299mr2627912a91.1.1728454358718;
        Tue, 08 Oct 2024 23:12:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7pK3x27vXs8b2CyjV7xUcxV0b7iw89YOVtT9MINIXxU8SElUIYRnvikpH62rBQwvm3L21nA==
X-Received: by 2002:a17:90a:9a9:b0:2da:6e46:ad48 with SMTP id 98e67ed59e1d1-2e2a0758299mr2627882a91.1.1728454358313;
        Tue, 08 Oct 2024 23:12:38 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2a58574f5sm716293a91.36.2024.10.08.23.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:12:37 -0700 (PDT)
Message-ID: <d9098b8e-be0c-41d8-a0ee-a0090fbf8a1a@redhat.com>
Date: Wed, 9 Oct 2024 16:12:31 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] KVM: arm64: Add a macro for creating filtered
 sys_reg_descs entries
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-6-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004110714.2051604-6-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 9:07 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> The sys_reg_descs array holds function pointers and reset value for
> managing the user-space and guest view of system registers. These
> are mostly created by a set of macro's as only some combinations
> of behaviour are needed.
> 
> If a register needs special treatment, its sys_reg_descs entry is
> open-coded. This is true of some id registers where the value provided
> by user-space is validated by some helpers.
> 
> Before adding another one of these, add a helper that covers the
> existing special cases. 'ID_FILTERED' expects helpers to set the
> user-space value, and retrieve the modified reset value.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/kvm/sys_regs.c | 54 ++++++++++++++++++++-------------------
>   1 file changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8b1a6cedc49e..1fd08f12f2bb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1833,6 +1833,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   	return set_id_reg(vcpu, rd, val);
>   }
>   
> +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd, u64 val)
> +{
> +	return set_id_reg(vcpu, rd, val);
> +}
> +
>   /*
>    * cpufeature ID register user accessors
>    *
> @@ -2131,6 +2137,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>   	.val = 0,				\
>   }
>   
> +/* sys_reg_desc initialiser for cpufeature ID registers that need filtering */
> +#define ID_FILTERED(sysreg, name, filtered_fields) {	\
> +	ID_DESC(sysreg),				\
> +	.set_user = set_##name,				\
> +	.visibility = id_visibility,			\
> +	.reset = read_sanitised_##name,			\
> +	.val = (filtered_fields),			\
> +}
> +
>   /* sys_reg_desc initialiser for known cpufeature ID registers */
>   #define AA32_ID_SANITISED(name) {		\
>   	ID_DESC(name),				\
> @@ -2337,14 +2352,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	/* CRm=1 */
>   	AA32_ID_SANITISED(ID_PFR0_EL1),
>   	AA32_ID_SANITISED(ID_PFR1_EL1),
> -	{ SYS_DESC(SYS_ID_DFR0_EL1),
> -	  .access = access_id_reg,
> -	  .get_user = get_id_reg,
> -	  .set_user = set_id_dfr0_el1,
> -	  .visibility = aa32_id_visibility,
> -	  .reset = read_sanitised_id_dfr0_el1,
> -	  .val = ID_DFR0_EL1_PerfMon_MASK |
> -		 ID_DFR0_EL1_CopDbg_MASK, },
> +	ID_FILTERED(ID_DFR0_EL1, id_dfr0_el1,
> +		    ID_DFR0_EL1_PerfMon_MASK |
> +		    ID_DFR0_EL1_CopDbg_MASK),

The replacement causes logical change because the 'visibility' callback has been
changed from aa32_id_visibility() to id_visibility(). I think we need an aa32
variant of ID_FILTERED, to be used here.

  #define AA32_ID_FILTERED(sysreg, name, filtered_fields) {	\
  	ID_DESC(sysreg),				        \
	.set_user = set_##name,				        \
	.visibility = aa32_id_visibility,			\           /* the only differentiated field */
	.reset = read_sanitised_##name,			        \
	.val = (filtered_fields),			        \
}


>   	ID_HIDDEN(ID_AFR0_EL1),
>   	AA32_ID_SANITISED(ID_MMFR0_EL1),
>   	AA32_ID_SANITISED(ID_MMFR1_EL1),
> @@ -2373,17 +2383,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   
>   	/* AArch64 ID registers */
>   	/* CRm=4 */
> -	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
> -	  .access = access_id_reg,
> -	  .get_user = get_id_reg,
> -	  .set_user = set_id_reg,
> -	  .reset = read_sanitised_id_aa64pfr0_el1,
> -	  .val = ~(ID_AA64PFR0_EL1_AMU |
> -		   ID_AA64PFR0_EL1_MPAM |
> -		   ID_AA64PFR0_EL1_SVE |
> -		   ID_AA64PFR0_EL1_RAS |
> -		   ID_AA64PFR0_EL1_AdvSIMD |
> -		   ID_AA64PFR0_EL1_FP), },
> +	ID_FILTERED(ID_AA64PFR0_EL1, id_aa64pfr0_el1,
> +		    ~(ID_AA64PFR0_EL1_AMU |
> +		      ID_AA64PFR0_EL1_MPAM |
> +		      ID_AA64PFR0_EL1_SVE |
> +		      ID_AA64PFR0_EL1_RAS |
> +		      ID_AA64PFR0_EL1_AdvSIMD |
> +		      ID_AA64PFR0_EL1_FP)),

Note that the 'visibility' callback has been changed from NULL to id_visibility(),
not resulting in logical changes since id_visibility() returns 0 for ID_AA64PFR0_EL1.
However, it would be nice to be documented in the change log?

>   	ID_SANITISED(ID_AA64PFR1_EL1),
>   	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
>   	ID_UNALLOCATED(4,3),
> @@ -2393,13 +2399,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
>   
>   	/* CRm=5 */
> -	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
> -	  .access = access_id_reg,
> -	  .get_user = get_id_reg,
> -	  .set_user = set_id_aa64dfr0_el1,
> -	  .reset = read_sanitised_id_aa64dfr0_el1,
> -	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
> -		 ID_AA64DFR0_EL1_DebugVer_MASK, },
> +	ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
> +		    ID_AA64DFR0_EL1_PMUVer_MASK |
> +		    ID_AA64DFR0_EL1_DebugVer_MASK),

Same as above. The 'visibility' callback has been changed from NULL to id_visibility(),
even there is no logical changes.

>   	ID_SANITISED(ID_AA64DFR1_EL1),
>   	ID_UNALLOCATED(5,2),
>   	ID_UNALLOCATED(5,3),

Thanks,
Gavin

