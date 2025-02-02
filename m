Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8971DDC1B
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 23:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738538130; cv=none; b=mrqWSQPskcIBpyvDvhKfgHTB/hOJeDoCJ5fMIbHi0Fi7C9iZaisP/QbzO5qhIwfQVwFwMr8cMjhVfMSuOs3qX7+EA31ONX16BoKNEOmdIJMNX/AB7ixtQkD9Db2flIEBGp2/hQYm2Hxc5BV71u6KK6T7BYvcRAeOfDDWigQjjak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738538130; c=relaxed/simple;
	bh=z4db+2e0h419DE1q2WVYFefMz+/sAeD1xP8xxo9CJHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfyQBZltmVh6DTMfwMITq6SCAQb0qbSHMHhR2/qm0LsB86H1V6uPNl8UUs8cvsg2cHGTXNO08920g1/Q857/c2pYv8Yc3sJjH9ZCKpHf8AuWwNob0cWKUmJTcGZiXXP3DUS8xi+KSbXew43GOtyHfg6l6DUcwVNp6tcGwW3OZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ze3Juraj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ze3Juraj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738538126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e1dos8mPCCNcJjz8w4voHe85/j4TJkmhqF45HVaBd4U=;
	b=Ze3JurajOqjXDLx8UyPKcUrizBwqwS2QtKokQ2ffW8nsQ5jj+3VOCQGzIqe00QUjqnhMvj
	giQKusinQkz7pRvFHBWkyB3wcWSnjRUbi6k2d1lKFeHL88VKFdqROKJNfzSc1mDzOx5ecy
	cMt9GfTYkyIrM40mW9buosZm8wfSiuc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-9xIz5VUaOpeze0THNiyrig-1; Sun, 02 Feb 2025 18:15:23 -0500
X-MC-Unique: 9xIz5VUaOpeze0THNiyrig-1
X-Mimecast-MFC-AGG-ID: 9xIz5VUaOpeze0THNiyrig
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2163d9a730aso77777335ad.1
        for <kvmarm@lists.linux.dev>; Sun, 02 Feb 2025 15:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738538122; x=1739142922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e1dos8mPCCNcJjz8w4voHe85/j4TJkmhqF45HVaBd4U=;
        b=MtVi5x2u3N86AnW+XAqJ+wIr/jR0H+Wtv8wfPrsmcYUSb7WZedspoJvgrDkteQGR44
         IEIUfEc+uSAiuHSyWU5UmtHeEOuPyrQtuEvJd4FxYGV7vSJNnz+HPbSy3m0sZPPPP3Kc
         yyUThYML5nCB+YAdvtfh4zlpNyQs4lMuHCQ8vX/l4dHFrIXHKAl1HlcnPUfZyr25sjft
         w4/2MyqdUh1y58GRYYK4v6ivDWU/hTiQ43tmNfXhQeOBmuj1Mrm2sulVP13OMNpx/l5s
         xTwHRCUqNLptdOgHpyhgOGALeJShGc/qOYwVnrJkXmIHhMx0Q1l6qIHh3w9Ld+L11DJi
         sk9w==
X-Forwarded-Encrypted: i=1; AJvYcCVR4x9zxlKxv6YeM9Sx50w6Ki1z7lxThrC/q3S9kjG7ggB7ynMvAsbfRST3UjkO3rY4mAcCHUA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoNaKloFTMMD8vlRI8Chq0lQ38ewtyfqQUbmuKd/wJfvz/6np8
	NkQeT/O6pOJbx6Nyn7mLohc0f6LHj1v67RV3RRj9xizt854h5kSwT1cEfyb8uZ3uOtDB22ju834
	193vffVPg38ZDcS+Pte+oz6/GOnohoh1fS8Q7ytxErdSRVsYGDMHhAQ==
X-Gm-Gg: ASbGncs5i+46z1LFoZEE88doCVBLCsXrKMSXfS1F1TpsRm8raB89vUQACJRmwh3fK11
	uBxKu5dWFtPgukf/fclaJnvwtTtXSaUtxFXE/kFNFPS4RU97ZzvA408zm9X5TSHMzPvL8EuBCoz
	kjA9s/PXovRJouF0KcYLnRLxn4CUDYHvvr0NvJ7/zMDtVparBudkRNPCHJhAYmzEmLa3t9+yTbJ
	6VaVHZO3MMmr6XkZ1tdK9cCJO7owY2JIh+WRItG1EkLFfirv+ed2WGvCLbMby2+esRhxFStEhVd
	SAjk/A==
X-Received: by 2002:a17:903:120a:b0:216:3f6e:fabd with SMTP id d9443c01a7336-21edd7eafccmr173598945ad.7.1738538122322;
        Sun, 02 Feb 2025 15:15:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2mf76DirOg9TZyfOkrJfXsutpQ6g81h2feZA7/LYyJlI04cSOqf6NavNatW10Gphrl5eu/w==
X-Received: by 2002:a17:903:120a:b0:216:3f6e:fabd with SMTP id d9443c01a7336-21edd7eafccmr173598665ad.7.1738538121968;
        Sun, 02 Feb 2025 15:15:21 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ea5fesm62974185ad.132.2025.02.02.15.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2025 15:15:21 -0800 (PST)
Message-ID: <34990c4f-b65e-4af2-8348-87ea078afc16@redhat.com>
Date: Mon, 3 Feb 2025 09:15:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-35-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-35-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NqoxNYIYeomeq77uZfOspBvhXT_PpueNiJYICqfJdA4_1738538122
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 0d89ab1645c1..f8e37907e2d5 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>   bool kvm_rme_supports_sve(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index e562e77c1f94..d21042d5ec9a 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -63,6 +63,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>   }
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +	u32 ctx_cmps;
> +
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return val;
> +
> +	/* Ensure CTX_CMPs is still valid */
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
> +	ctx_cmps = min(bps, ctx_cmps);
> +
> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_CTX_CMPs);
> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
> +
> +	return val;
> +}
> +

The the filed ID_AA64DFR0_EL1_WRPs_MASK of the system register ID_AA64DFR0_EL1 is
writtable, as declared in sys_reg.c. We need to consolidate the field when the
system register is written.

         ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
                     ID_AA64DFR0_EL1_DoubleLock_MASK |
                     ID_AA64DFR0_EL1_WRPs_MASK |
                     ID_AA64DFR0_EL1_PMUVer_MASK |
                     ID_AA64DFR0_EL1_DebugVer_MASK),

>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - stage2_pgtable_levels(realm->ia_bits);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a4713609e230..55cde43b36b9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1806,7 +1806,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   	/* Hide SPE from guests */
>   	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
>   
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>   }
>   
>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,

Thanks,
Gavin

