Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3178237E304
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785075756; cv=none; b=YBYmkbKpKLz5sZ1VQ0QWXeVXTT/FanhOxMKxkwlyT0d4GlqOkcbBIDYq4aAPjSrTZtKIjm7eX/v7C1kbGwxCxBQMTmZ1kQIkv5pIEkAuNp3Wl80ot81mcYgv3A4/BmkNqKuRvKB80p/IrFj1254B8MMks3YprbOJjVNVXhZiurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785075756; c=relaxed/simple;
	bh=nzn+eYnCb5HXp6mgBb31dOirGbP6SPYRG2Ljj4e13oQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IB8HqwKxsIRXtDyruOzZjuhZMh0A5M5GIL3geC9TaLxMDQfXvY328ibVhsBDAxSLdF788qtUKStCcV8u4gQRlt6N1Z4RERa6NsE0rR6UwxK4EQ5FEOSgOvcb5AhKSHzTTfPfICp8QKfJd2pZ2QzrbdvOgnN7RyflopNBecK8I6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTujde8a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTujde8a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785075753;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9onKOvuadw2ucT1LclFaSpJKEsgm8Ez+YxGJOnocJ4=;
	b=aTujde8ahoibV2j7EdnMNc3NriHCOV3FDZw9BWFbQybmhBSz/hX/mvkKdPfqqbi+2z1Ii9
	xRkvViStrJIK2KI6iJOFv9HJkG7TrMMzgrJ3j5oQScKYwfVB4EJo6gT48BmxYQtLI6YP0F
	GFX8+RsvHmUNmYLunefQ4IstixKGOIk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-tklA3XI-NKiT-RIJQLOTZg-1; Sun, 26 Jul 2026 10:22:31 -0400
X-MC-Unique: tklA3XI-NKiT-RIJQLOTZg-1
X-Mimecast-MFC-AGG-ID: tklA3XI-NKiT-RIJQLOTZg_1785075750
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495569acf8dso12509335e9.1
        for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 07:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785075750; x=1785680550;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9onKOvuadw2ucT1LclFaSpJKEsgm8Ez+YxGJOnocJ4=;
        b=k6jmo+xqM0RiKddqhwFtJ1Q8j9crIf0dNJYrRe1QtfUDUNA0fkf0ROx7o5KaRGZZgI
         iozTzxkGuMrhL51y6AltbsbZII0H1gPobTiEZmh4JVUnrAlgyTGGWFsW4u1MXcfDDGIi
         qQ1uJEpOtHIyhi7kw+U0F1s9BGjqC830ctH0hNj1H5lW5Mx7apcSKMZd66pW8u13OPmO
         epvwkCdLRnNuVafrDhhxwEkTZT6awQ7W/q3cJp3oiOiBnKM3dthYsICVN0bGYQjxGVZJ
         j1iYL5S3NN0UXsaaCs8UiA+Kk+okB4Vw1NCJ/hftbuiY3Mv6FhCYQHfJuoM2eBFKbZFt
         Slvw==
X-Forwarded-Encrypted: i=1; AHgh+RqXZA5YIqkM+cKB7BsliquShVve8rBBjavmWEK2SH0piSiEyJ2kwgmY7K1cbXdL18ppCiwn21Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEA+BzsNANta52yz91Qilo9G4iskDS/HdyIMWN4l6iNERkkKfh
	5eiRUZBPxiDm+KmZyBu7uL9aSfRMBUZ0Mcm/xO8E7vL6omapfEXB5VjJWFNVTAoMT7nYuHbjVEz
	jzYc3zev99TTNxPXrJfgZ72zCiGlWCVxj97sEOPbqGpqR8UobGgA1b0Dz4A==
X-Gm-Gg: AR+sD13ZjujSijPMnHt8t2yAlHvk/p6Tb8V87fcUbXdDt/9IagwQ9Kk2Vz4oN7NmGwu
	ldwgkrMkTD+CBTZvI42eK4rODkGzjpAZ/xKkEe7e7dHHuXmMNy6FUBw3N37E3LRGTnjqAZDx7rq
	INY+1L52ryuk2Uh62z6IjGBm1uY82jhWxG79fV/MhcY/0rPElC2YVGnQbIy6ZSp5MJ7Xt91dA0N
	DK38oDzA5t6A34pDQR+FXpqe9kTibVgvaGyLLyQCFM92URcrW+HMb3YK3VugthDt8oq+8eUBh4S
	76azK1Oi29UGBxypcJbpU6lR3M2pAaJjHmV7g0EFkKrODUAyzbmXGk3O4nInj5aFdYyMHkzFO37
	nZfrowS69JRZAhHbR+215NPMVnxhifyeVbr0=
X-Received: by 2002:a05:600c:4445:b0:495:4fd4:144b with SMTP id 5b1f17b1804b1-496b5719f73mr62370295e9.21.1785075750356;
        Sun, 26 Jul 2026 07:22:30 -0700 (PDT)
X-Received: by 2002:a05:600c:4445:b0:495:4fd4:144b with SMTP id 5b1f17b1804b1-496b5719f73mr62370005e9.21.1785075749875;
        Sun, 26 Jul 2026 07:22:29 -0700 (PDT)
Received: from [192.168.3.191] (228.246.150.77.rev.sfr.net. [77.150.246.228])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f939c1465sm25982791f8f.26.2026.07.26.07.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 07:22:29 -0700 (PDT)
Message-ID: <fe76f638-81aa-43cf-aafb-c774ab1902f8@redhat.com>
Date: Sun, 26 Jul 2026 16:22:24 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 14/19] target/arm/kvm: compute supported values for
 ID register fields
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-15-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260716213858.609699-15-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hkzh1y93pJiYD0bPDzWsJZ9zJK6AReinQ8zl-ZZ_CIs_1785075750
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 7/16/26 11:38 PM, Khushit Shah wrote:
> Add arm_field_get_supported_values() which, for a given ID register
> field, builds the set of values KVM allows it to take on the live host.
>
> Non-writable fields are pinned to the host value. Writable fields follow
> their per field constraints. This function likely needs change when
> KVM starts exposing a new writable field that is not lower-safe, hence,
> the special handling of TGranX_2/SpecSEI/L1Ip/MIDR/REVIDR/AIDR.
so this looks quite risky. 
>
> Cross-field constraints are not modelled; for example ID_AA64ZFR0_EL1
> is gated by SVE. Reproducing every inter-field dependency in QEMU
> would only duplicate KVM's logic and drift out of sync with it.

Isn't qmp_query_cpu_model_expansion sufficient? In general upper layers
will try to apply raw named models. If ajustements are needed between
source and destination, we know field candidate values (either the
source or dest one) and this latter can be directly tried using
qmp_query_cpu_model_expansion write. On top of that
qmp_query_cpu_model_expansion can be directly checked against a scratch
vcpu reusing the logic implemented at kernel level.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/kvm.c     | 99 ++++++++++++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h | 26 ++++++++++++
>  2 files changed, 125 insertions(+)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index c38b99cfce..8f452f9570 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1262,6 +1262,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>      return true;
>  }
>  
> +static bool arm_field_is_signed(const ARM64SysRegField *field)
> +{
> +    return field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4")    ||
> +           field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64")   ||
> +           field_matches(field, ID_MMFR0_EL1_IDX, "InnerShr")      ||
> +           field_matches(field, ID_MMFR0_EL1_IDX, "OuterShr")      ||
> +           field_matches(field, ID_AA64DFR0_EL1_IDX, "DoubleLock") ||
> +           field_matches(field, ID_AA64DFR0_EL1_IDX, "PMUVer")     ||
> +           field_matches(field, ID_DFR0_EL1_IDX, "PerfMon")        ||
> +           field_matches(field, ID_AA64PFR1_EL1_IDX, "MTE_frac")   ||
> +           field_matches(field, ID_AA64MMFR4_EL1_IDX, "E2H0")      ||
> +           field_matches(field, ID_DFR1_EL1_IDX, "MTPMU")          ||
> +           field_matches(field, ID_AA64PFR0_EL1_IDX, "FP")         ||
> +           field_matches(field, ID_AA64PFR0_EL1_IDX, "AdvSIMD");
Can't we extract this from Register.json instead?
> +}
> +
> +static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
> +{
> +    ArmFieldRange r = { .min = min, .max = max };
> +    g_array_append_val(ranges, r);
> +}
> +
> +void arm_field_get_supported_values(const ARM64SysRegField *field,
> +                                    const ARMISARegisters *host_isar,
> +                                    ArmFieldValueSet **value_set)
> +{
> +    bool is_signed = arm_field_is_signed(field);
> +    uint64_t host = extract64(host_isar->idregs[field->index],
> +                              field->shift, field->length);
> +    GArray *ranges = g_array_new(false, false, sizeof(ArmFieldRange));
> +
> +    /* A non-writable field can only ever hold the host value. */
> +    if (!arm_field_is_writable(field)) {
> +        ranges_add(ranges, host, host);
> +        goto done;
you already get this info from qmp_query_cpu_model_expansion
> +    }
> +
> +    if (field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4_2")  ||
> +        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran16_2") ||
> +        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64_2")) {
> +        /* Either support the host value or the "off" value */
> +        ranges_add(ranges, host, host);
> +        if (host != 1) { /* 1 = "off" */
> +            ranges_add(ranges, 1, 1);
> +        }
> +    } else if (field_matches(field, CTR_EL0_IDX, "L1Ip")) {
> +        /* Only safe to downgrade to VIPT, other values are reserved. */
> +        ranges_add(ranges, host, host);
> +        if (host != 2) { /* 2 = "VIPT" */
> +            ranges_add(ranges, 2, 2);
> +        }
> +    } else if (field_matches(field, ID_AA64MMFR1_EL1_IDX, "SpecSEI") ||
> +               field_matches(field, ID_MMFR4_EL1_IDX, "SpecSEI")) {
> +        /* It is safe to upgrade SpecSEI to 1, other values are reserved. */
> +        ranges_add(ranges, host, host);
> +        if (host != 1) {
> +            ranges_add(ranges, 1, 1);
> +        }
> +    } else if (field->index == MIDR_EL1_IDX ||
> +               field->index == REVIDR_EL1_IDX ||
> +               field->index == AIDR_EL1_IDX) {
> +        /*
> +         * No restriction on value that can be set for implementation ID
> +         * registers fields.
> +         */
> +        uint64_t max = 0;
> +        if (field->length == 64) {
> +            max = ~0ULL;
> +        } else {
> +            max = (1ULL << field->length) - 1;
> +        }
> +        ranges_add(ranges, 0, max);
> +    } else {
> +        /*
> +         * After handling the special cases, other writable fields are
> +         * either lower-safe or signed lower-safe.
> +         */
> +        if (field->arch_vals_count) {
> +            for (uint32_t i = 0; i < field->arch_vals_count; i++) {
> +                uint64_t av = field->arch_vals[i].value;
> +                int64_t v = is_signed ?
> +                    sextract64(av, 0, field->length) : (int64_t)av;
> +                int64_t hv = is_signed ?
> +                    sextract64(host, 0, field->length) : (int64_t)host;
> +                if (v <= hv) {
> +                    ranges_add(ranges, av, av);
> +                }
> +            }
> +        } else {
> +            g_assert(!is_signed); /* No signed field with no arch vals */
> +            ranges_add(ranges, 0, host);
> +        }
> +    }
> +done:
> +    *value_set = g_new0(ArmFieldValueSet, 1);
> +    (*value_set)->n_ranges = ranges->len;
> +    (*value_set)->ranges = (ArmFieldRange *)g_array_free(ranges, false);
> +}
> +
>  static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
>  {
>      /*
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 133a026036..9f15c91c4e 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -143,6 +143,32 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>  
>  typedef struct ARM64SysReg ARM64SysReg;
> +typedef struct ARM64SysRegField ARM64SysRegField;
> +typedef struct ARMISARegisters ARMISARegisters;
> +
> +typedef struct ArmFieldRange {
> +    uint64_t min;
> +    uint64_t max;
> +} ArmFieldRange;
> +
> +typedef struct ArmFieldValueSet {
> +    ArmFieldRange *ranges;
> +    size_t n_ranges;
> +} ArmFieldValueSet;
> +
> +/**
> + * arm_field_get_supported_values:
> + * @field: The field to get the supported values for
> + * @host_isar: The host ISAR registers
> + * @value_set: The set of supported values for the @field
> + *
> + * Will be allocated and filled in with the supported values for the @field
> + * based on the host_isar and whether the field is writable or not.
> + * The caller must free the value_set.
> + */
> +void arm_field_get_supported_values(const ARM64SysRegField *field,
> +                                    const ARMISARegisters *host_isar,
> +                                    ArmFieldValueSet **value_set);
>  
>  /**
>   * kvm_arm_steal_time_finalize:
Thanks

Eric

