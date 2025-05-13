Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F4819F111
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747146833; cv=none; b=lDTMEYXiooG8aa4fb+MtJIr04u61TfW1Aj0KlA0Rm47DBoksM50pSpfTh+uxHxwv1/SDi7bKJ0AX7m8Nwz0iaqtVacGr3H5UQJoMonP9xk4fYMSqszCU6b9/jVeGyKuTuBdEFDKo6sKFZNsbnPhYHR0gpPdiCoTDiwD+w5l7/rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747146833; c=relaxed/simple;
	bh=qsv0njkJLfbigiXR5sPfUjeOX4joIODSTnU7wwMhrLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WAxvOMhIf0sVjBHCvNRWLDHCcPRiBHWH9OqgnnfWZu9nxDTddq02eZnYjJ7ZooL3y/PPUMZPLKaSD8vE7XFNW3yVdj92EFHvxB3yNAsyr0hG5QBLC1Vr3iEdBN2UihILrkNafIYthGzVvpXJwVccV+oJ0Y571iUQiE6URS00PAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PV+fVnGy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PV+fVnGy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747146831;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y909bR0YHzufKEcfXdMfMZPq0NlMISVrbvKpfk9Zrzg=;
	b=PV+fVnGyJwwlEam+6o4HmAmBhPF+nTR3ylNCYTLaKwnUAKgXhm5kl9MwWIOLhtXtxjFwmF
	E47DWWX3CwGsxEvlZAuYrr6ZiOukb14SL++0ENqtvqZz44K2ji84G2vhx2bLGIDLxOWD8y
	tYRG08qjtuerAIRuWCaKcuGQuXJH6+Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-ee9hwkcSMpOkb3zdlwIy0Q-1; Tue, 13 May 2025 10:33:49 -0400
X-MC-Unique: ee9hwkcSMpOkb3zdlwIy0Q-1
X-Mimecast-MFC-AGG-ID: ee9hwkcSMpOkb3zdlwIy0Q_1747146828
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-442d472cf84so26612655e9.2
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 07:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747146828; x=1747751628;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y909bR0YHzufKEcfXdMfMZPq0NlMISVrbvKpfk9Zrzg=;
        b=VyobjtQEmH6rEd5A5x8WWpwPWHHXGqyxoDOwYI0gDPnxzMPRGS306wBbdS/BfDnwfR
         e2b403b7tSWk2IdASTy/oZgpWvbmwdD39JyJeUloLJv8PjP6lY73UA+RUv1QYKMEC7mE
         y/X2SA3RR/n/sqNMWAHeikvStWxv9o3TNJtdqQrxZd5zglshl4cI/BwvMVpkiyWZ/coq
         cx636n+T15B+c/SOv71MEkehOMu8/R7UhRkh3FcRAS1Snf1FnkR4mOOR31ZZn1TH2XOy
         Ag1pbCHQUmhEJU8XreFmnf2SemYrX303mfMb8+2ydT50RybE4wKxdG7YBZwCm40y0y44
         qX+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV2p6LUVxjhK/feMZWh2sZ49LWOU0ENIUtndphx98KbEsX6xBxuokfn5pBQDtRf/LFUxtmmPLk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvaqxDrRAwep5HBigZPBdH3xixdVOkNXvoR3VX5Fd0yy6xTtyp
	Zmb1N4a5xJ3I81PsHhSp7j28a+t3Fux+O7BhEQTp8WOKen2w8dOAnz9xSvnpuCSVWcey5ff4dQR
	/HUxcQwp40zzfxObE83f7eeQ2NZqnSUXBqM2Y/Kqx3LgY4vUj/IeEkA==
X-Gm-Gg: ASbGncut+JV5ILpI9l62kwibLDpI4HFrd1YUISrTKnL9RWsG4xymcyXOHWnGgKgK0g5
	zIAKW8+WkB/Tax2G2t6mg9z7KuMO/2dXtwgZ2oHCUDqR9FSMQBph2Rjw70C4XpAaFpQzwgQrpyY
	TJl8l8AJKFUCUkeki9NeMXcWA6OGgv6ep9VBlME6MdSI8fy9DqEbzXfHICvSWTHgv1wiIJrjJbr
	435nhsWJ5UttCGB8RuOb+FAz3/kyPnV/C1dwqh5C4eS7ltQH1DRxbJ4t+UwjRBsfIRl7euGfmxa
	DfOOUZlYHRGlQKtqjlct2Njmn3uVoNlAFffM3b0U7EUr/cGIJiSOMUoC43A=
X-Received: by 2002:a05:600c:4f53:b0:440:61eb:2ce5 with SMTP id 5b1f17b1804b1-442d9a0db9cmr143579045e9.17.1747146828131;
        Tue, 13 May 2025 07:33:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqSymGLiEPl5V0duEN/fsyq3JfX8N2e2t3KGImeE08cAaBoCzAymj5g4i9Yxx8mP5niwfg9A==
X-Received: by 2002:a05:600c:4f53:b0:440:61eb:2ce5 with SMTP id 5b1f17b1804b1-442d9a0db9cmr143578685e9.17.1747146827672;
        Tue, 13 May 2025 07:33:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d687ad31sm168969195e9.34.2025.05.13.07.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 07:33:47 -0700 (PDT)
Message-ID: <412f69cc-a54a-496e-bee7-e80dc1246a42@redhat.com>
Date: Tue, 13 May 2025 16:33:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 07/10] arm/kvm: write back modified ID regs to KVM
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-8-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250414163849.321857-8-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sV7sUD8fsnd3Xyj54fZZuRXnkksZYZsJb36VEpU7gMY_1747146828
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/14/25 6:38 PM, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> We want to give a chance to override the value of host ID regs.
> In a previous patch we made sure all their values could be fetched
> through kvm_get_one_reg() calls before their modification. After
> their potential modification we need to make sure we write back
nit: write their value back?

Eric
> the values through kvm_set_one_reg() calls.
>
> Make sure the cpreg_list is modified with updated values and
> transfer those values back to kvm.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++-
>  target/arm/trace-events |  1 +
>  2 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b07d5f16db50..9e4cca1705c8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1083,6 +1083,39 @@ void kvm_arm_cpu_post_load(ARMCPU *cpu)
>      }
>  }
>  
> +static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
> +{
> +    if (!cpu->writable_map) {
> +        return;
> +    }
> +    for (int i = 0; i < NR_ID_REGS; i++) {
> +        uint64_t writable_mask = cpu->writable_map->regs[i];
> +        uint64_t *cpreg;
> +
> +        if (writable_mask) {
> +            uint64_t previous, new;
> +            int idx = kvm_idx_to_idregs_idx(i);
> +            ARM64SysReg *sysregdesc;
> +            uint32_t sysreg;
> +
> +            if (idx == -1) {
> +                /* sysreg writable, but we don't know it */
> +                continue;
> +            }
> +            sysregdesc = &arm64_id_regs[idx];
> +            sysreg = sysregdesc->sysreg;
> +            cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
> +            previous = *cpreg;
> +            new = cpu->isar.idregs[idx];
> +            if (previous != new) {
> +                *cpreg = new;
> +                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
> +                                                            previous, new);
> +            }
> +        }
> +    }
> +}
> +
>  void kvm_arm_reset_vcpu(ARMCPU *cpu)
>  {
>      int ret;
> @@ -2050,7 +2083,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      }
>      cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>  
> -    return kvm_arm_init_cpreg_list(cpu);
> +    ret = kvm_arm_init_cpreg_list(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +    /* overwrite writable ID regs with their updated property values */
> +    kvm_arm_writable_idregs_to_cpreg_list(cpu);
> +
> +    write_list_to_kvmstate(cpu, 3);
> +
> +    return 0;
>  }
>  
>  int kvm_arch_destroy_vcpu(CPUState *cs)
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 17e52c0705f2..955149ee1ac4 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -14,3 +14,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>  # kvm.c
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
> +kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64

