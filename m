Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC5325393E
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156220; cv=none; b=YjQc8bIyitz2nQVQYI7KINKgYqYpb9Xpb4SUJXmaZwMXV2UFV7VEUoRZrwZpp1/85dWUtSyV2WH/T1PspgMySnfMXW+2cxqYLBy3kykEtdYeHq7kXLLYtKUO6KoWG9EIT4RdX0BhNylY0iJIvk3sWSXsS1oolacPZUlgLaJyuOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156220; c=relaxed/simple;
	bh=OBoUO1/HWCDTdtVeDdamKF50WmvnvVlJ5exMCaxA2Lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWOd8c+PM5IXJm7AWToSQS14UnRUmvBjYOV8PjU9Mbzo9J7EqnLG34ZqttGYCVBKqcEXxOTWOLBqHO2b2HntOHdR8C8G9DTtrbc8jWzzXiCdZsvFMygc9rdOPskWw5Bg472YphXrF4iIQAfFNr1Ww+I8JGr69yJBApjHw5zFDI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bHVsWOg+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHVsWOg+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792156217;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Af5urTeD3afgs1G+MH27XDb+cPeKPt9pbqkwAvjLXI=;
	b=bHVsWOg+1U4N8EuffKCTqqCv+fa8g7Mn6uBGWOkGtuzPus4io2LFP5FQAuP+tdruXJvD4V
	ngBY7F6au+oO7K3HVitJKyEjN6dpeZYadRoCFHPqsinPq0zCjLTvXFuHStZU16moco/rgW
	Tcm/jW809Z83YsTAvifrdZKnqAOJ5YM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-afCi7WZFPiCBG_7cqHKhyw-1; Fri, 16 Oct 2026 13:10:15 +0000
X-MC-Unique: afCi7WZFPiCBG_7cqHKhyw-1
X-Mimecast-MFC-AGG-ID: afCi7WZFPiCBG_7cqHKhyw_1792156214
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1ac6663e1so37856265e9.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156214; x=1792761014;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Af5urTeD3afgs1G+MH27XDb+cPeKPt9pbqkwAvjLXI=;
        b=fa6vzQyINkVX3Na+aBrAfzbrG6gYzZB/6YQ1FKcL5XhlJ0AieAlOez2Sv4q7FKzSHM
         wS7zfNtIQ1M2q5S42xcBfSYyqnVz8l6cZV4uQ6rID9PPuULT9CpX/V3govfmV0/TJvmj
         3g6HJ6DXysN8q/cNpZlMckKEF8lSTgyykuIjoGUNH9GQjj5au/hdPGq0RGBJJ5ONvURL
         xQU8rsSX57AHmDmvaSsMdxe4cTQrjBAFTRgw9UAFqr4H8DmQ3jcjfBZB0RlSuhXrZ2tY
         SNCx32OpRFP+Q3iCXEUxboWslh16BzU8K1KPl5y/ByWLqnOs3ve+XAUI6BJXHpfg5W6E
         8i8w==
X-Forwarded-Encrypted: i=1; AKwUvBzicDU6Pr75axMQR437+nIs7gpknKhZufqMIC0V3Yf7DUkqlOSGNLAonUzEY+XzJASIHflgG9k=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ0p3wkHbxzk5u+ryI8+6ePFmuEfdG5/KCGYHLXI5adjO8MqndX
	/FX2jM4+qToHmQxIS4fTEe1Y9t/xNDGH9W0DGz65jVkcfFMoV4D5hSHBtUw74zy2XVXKpW1DT3P
	JX5yLQUdqIIjhbLUX8p5TBS6YFlFf+uwPuRFuwaMdgAhCKw6sS2a4ucwmBw==
X-Gm-Gg: AYBFou0S/ACetiHbEpMBR9h+pPBnB+pnP1IG7sOh44x3cEZtPt2nV2ToOBFMZD7PjGh
	Mdx946Y2uMTwPYvykQ+q5vKPGcgZFfxL34L58wwvwgZlx0LEHWPA8IPiuu2SwXnz15F6abZiduj
	cc3AbDd61BwSS0K0/UFduX1uPJAp0At8BdBbj8WfuRGAzzy2jpMya/DRzQgIissP+mApY8fYW+k
	uhSIihUDCFEuc5VXJVX0PU55IjfPJnw5aDcv9tzc5W4lfzw0CvEQqbsOglN0Nyn305BkUag6ohw
	mZrsG/nO3rYSn5FoJlLdVQ95LjAbay6vwa3QPX+YifO0JPDCo2I+z3QH7CsIL42AnZaKErFvhBm
	hRm+KPStis5g/nswryD8r1BDdEweF0Cmeu4w63i3OTAatvGnS
X-Received: by 2002:a05:600c:8b78:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4a18e47acf5mr511272995e9.11.1792156213997;
        Fri, 16 Oct 2026 06:10:13 -0700 (PDT)
X-Received: by 2002:a05:600c:8b78:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4a18e47acf5mr511271195e9.11.1792156212849;
        Fri, 16 Oct 2026 06:10:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8d12sm5106320f8f.36.2026.10.16.06.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 06:10:12 -0700 (PDT)
Message-ID: <3e20590e-4276-4166-91d4-47db4875543b@redhat.com>
Date: Fri, 16 Oct 2026 15:10:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 20/25] target/arm/kvm: compute host-supported
 values for ID register fields
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-21-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-21-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QjtUK-KwyNyrdeJDEc0TXjbTmbuPvoGGU-VCGJTffWo_1792156214
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Add kvm_arm_field_get_supported_values() which, for a given ID register
> field, builds the set of values KVM allows it to take on the given host.
>
> Non-writable fields are pinned to the host value. Writable fields follow
> their per-field constraints. This function must be updated when KVM
> starts exposing a new writable field that is not lower-safe; hence the
> special handling of TGranX_2/SpecSEI/L1Ip/MIDR/REVIDR/AIDR.

This effectively advocates for having a snapshot of all the IDREGS that
are known to be writable and handled by the qemu code. Because otherwise
we may return wrong safe values for a given prop.

> signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>
> --------
> Note:
> - We should have an authoritative static list of "writable" fields in
>   QEMU.
> ---
>  target/arm/kvm-stub.c |  7 +++
>  target/arm/kvm.c      | 99 +++++++++++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h  | 28 ++++++++++++
>  3 files changed, 134 insertions(+)
>
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
> index d263adc921..c9cd47bf47 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -144,3 +144,10 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
>  {
>      g_assert_not_reached();
>  }
> +
> +void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
> +                                        const ARMISARegisters *host_isar,
> +                                        ArmFieldValueSet **value_set)
> +{
> +    g_assert_not_reached();
> +}
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 6f704c0509..77b1bcdf55 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1324,6 +1324,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
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
> +}
> +
> +static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
> +{
> +    ArmFieldRange r = { .min = min, .max = max };
> +    g_array_append_val(ranges, r);
> +}
> +
> +void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
> +                                        const ARMISARegisters *host_isar,
> +                                        ArmFieldValueSet **value_set)
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
> +    }
> +
> +    if (field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4_2")  ||
> +        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran16_2") ||
> +        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64_2")) {
> +        /* Either support the host value or the "off" value */
> +        ranges_add(ranges, host, host);
> +        if (host != 1) { /* 1 = "off" */
> +            ranges_add(ranges, 1, 1);
those are tagged with SAFE_EXACT policy in the kernel. Could you elaborate?
> +        }
> +    } else if (field_matches(field, CTR_EL0_IDX, "L1Ip")) {
> +        /* Only safe to downgrade to VIPT, other values are reserved. */
> +        ranges_add(ranges, host, host);
> +        if (host != 2) { /* 2 = "VIPT" */
> +            ranges_add(ranges, 2, 2);
*ID_AA64FPFR0_EL1_F8* hals have* EXACT policy and I don't see them
special cased here.


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
> +                uint64_t av = field->arch_vals[i];
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
> index 4e563fab96..9481e56412 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -175,6 +175,34 @@ int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
>   */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>  
> +typedef struct ARM64SysReg ARM64SysReg;
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
> + * kvm_arm_field_get_supported_values:
> + * @field: The field to get the supported values for
> + * @host_isar: The host ISAR registers
> + * @value_set: The set of supported values for the @field
> + *
> + * Will be allocated and filled in with the supported values for the @field
> + * based on the host_isar and whether the field is writable or not.
> + * The caller must free the value_set.
> + */
> +void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
> +                                        const ARMISARegisters *host_isar,
> +                                        ArmFieldValueSet **value_set);
> +
>  /**
>   * kvm_arm_steal_time_finalize:
>   * @cpu: ARMCPU for which to finalize kvm-steal-time
Eric

