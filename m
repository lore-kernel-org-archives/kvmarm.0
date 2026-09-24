Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E138426D03
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232883; cv=none; b=lAokqcQ4vIgRlLF/myv0NW+IyYvcjoOmlBexJ5L6km5bcd8Qg1Ppv2cy1eUXdQ+YL/m6kYtmusCFgMYSc4yqbRZnecL2pnzU5fuIs4zH6q5ZoezA+sxGBSkK7dOswzMHveWdKznfuHUw0CL0LRZhxFWtRryWykB1cgXIhcfsqn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232883; c=relaxed/simple;
	bh=XNsh3CFpDL750Zpz4sjaPGp9iBaQ1GbeceVXuwLCOAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AkvWkcB1ATcOJzxE8ftsEQ7EXoQrwf5STObwKxN90rBPLKxpL1VKcmzJn8cRkb8bATIxVEAnDyfcS5as/yuhghhy1Ln5KhQXklSr4qh4R3XE2cs4Ow3rAnHHyq7N5AKllR0TUtrU+cUYWoaYLQlZZ2UIZAmH2v6ekUf+q6SF7a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NKYJ5Ayr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NKYJ5Ayr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232855;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jDLbeH2FlzuhXW9rwMbnBfXwetXfylZcqNOyrQMFHF4=;
	b=NKYJ5Ayr2hngEfWJ13QBLwDcDs/mpOnN3ibOJ7BOnkHKMun6w+AhRpD+MBbGk3d/SxaBGX
	UKdxaaK+r+r7r9gQAs8/3Lqxf6oMVK3+3pr3Xe0EKogIVUcpLTn+uDMb0GOvi/LGps9wt0
	INEyKMG9cLowCQH9IGc0ed4+X7bArGM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-00E5TbomMQGOtUsnc4U1Jg-1; Thu, 24 Sep 2026 02:54:14 -0400
X-MC-Unique: 00E5TbomMQGOtUsnc4U1Jg-1
X-Mimecast-MFC-AGG-ID: 00E5TbomMQGOtUsnc4U1Jg_1790232853
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48585fce16fso576669f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 23:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232853; x=1790837653;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jDLbeH2FlzuhXW9rwMbnBfXwetXfylZcqNOyrQMFHF4=;
        b=CpNLT3LJ7nBx0/6XV7/wjTBLlqEhXxiJtMirWxqQUbw5Riaj5dh/P3uQSCdTansAHu
         CjdfeZhm/UBvsuTOpRx4zNoRELai2j0Pouo/ElS+OgdU//glDT+k+bp6IScoC3CeXIPp
         u820kc8hV/fygPWU8cZd17ZU0OLKhJ/LwOafA2YrALt2B6kv7aNlsfH5MqXTtu2Tlvw0
         LSW47gKlBO8/JN1v1Tr5FrJYhMGPcUJCt48kAULKntQIIHVlvjorX1zu3MSMqsPGnJsJ
         8G69ykxLSxvAxl6VutJ2cl46tk6UQSx7z4swrU1QCm/vCaI9hMOPBizZEZ0UfAp5CFt9
         /wmg==
X-Forwarded-Encrypted: i=1; AKwUvBwCuH7KulW9GGrgHNp9x5VKlmxH6sOVCxZDb9HtKBTU2RkrV2YbaeuNjrYRM7KuXKGXy/2y15w=@lists.linux.dev
X-Gm-Message-State: AFuF++ksGscVWbETXExmidxnGpRw7l/yoi991ozplW1GXbD+2m2ui50O
	gzWZF9/CXFjNwnzmQOf21o0thIvofEka61m9F7gUZeGj3xzNpCj10pkmSyZU/EpuNdZ3SRYUN+0
	vT5bNoVVaEi6iF2eZnFo+2lkN9igfLUAPdLQ1KELXji9wehCx/5JIvTLTCA==
X-Gm-Gg: AYBFou3AwdrSF/ASotPlqQPVdFRvINp1zSvMllajtq9GaqtG4DCUBN98d/Ys6mBHnRD
	bwFT71zTs3fkg1iBy531gxWGmM5sS93j8ineUr30J37a/b9G4DUypj1DRTxnC27eBydma+lnTY7
	/dJDQIqILFzs/3TNiFU5Tgd4iJSI8Jxf2cp2E3oosytFCQN20VQzTvxnMNP+ABLdN/w0VBzihZR
	rpfHf5Y8yPdXym+Rtb85DXF2iSLHFctcEeiW9Wl00Aow/sJ5ayolo8T8byLTbLluzxxX4lm0ubN
	XfQzlcF3tXtXMgnECjTr2ERQ3iys3jQEDnJILtrKrjQgQjWeph+xTSzZppZz39T4+sfAc6500Yk
	BbjD4nsZ2pn/4NTDTLyQcgXRQS6NlD2TMa60srZPjrEbw5mZm
X-Received: by 2002:a05:6000:71a:b0:487:c3e:8df8 with SMTP id ffacd0b85a97d-488716b6caemr2225425f8f.5.1790232853147;
        Wed, 23 Sep 2026 23:54:13 -0700 (PDT)
X-Received: by 2002:a05:6000:71a:b0:487:c3e:8df8 with SMTP id ffacd0b85a97d-488716b6caemr2225395f8f.5.1790232852820;
        Wed, 23 Sep 2026 23:54:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886877970fsm12638914f8f.24.2026.09.23.23.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 23:54:12 -0700 (PDT)
Message-ID: <41f47202-cf63-4586-a6b8-9dd9001a1f6b@redhat.com>
Date: Thu, 24 Sep 2026 08:54:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 03/25] target/arm: move SYSREG_ prop infra to
 cpu64.c
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
 <20260921123249.1708067-4-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-4-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uuaYHrH4Pr84UYl6rjEglCjRKq4Rna36Tzi_-9YXMhI_1790232853
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> kvm_arm_expose_idreg_properties() no longer depends on KVM-specific
> logic. Move it to cpu64.c as aarch64_add_idregs_properties() along with
> all SYSREG_ property infra, making it accelerator-agnostic.
Even before, the code had no real kvm adherence, I mean even if we keep
reg->writable_mask checks. This latter could be populated with another
accelerator. So I think I can move in this direction in the parent series.

Eric
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu64.c      | 101 +++++++++++++++++++++++++++++++++++++++-
>  target/arm/internals.h  |   1 +
>  target/arm/kvm.c        | 100 ---------------------------------------
>  target/arm/kvm_arm.h    |  10 ----
>  target/arm/trace-events |   4 +-
>  5 files changed, 104 insertions(+), 112 deletions(-)
>
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 3d522bf20d..7487b48cc9 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -38,6 +38,7 @@
>  #include "internals.h"
>  #include "cpu-features.h"
>  #include "cpu-idregs.h"
> +#include "trace.h"
>  
>  /* convert between <register>_IDX and SYS_<register> */
>  #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
> @@ -644,6 +645,104 @@ static const Property arm_cpu_pauth_qarma3_property =
>  static Property arm_cpu_pauth_qarma5_property =
>      DEFINE_PROP_BOOL("pauth-qarma5", ARMCPU, prop_pauth_qarma5, false);
>  
> +#ifndef CONFIG_USER_ONLY
> +static void set_sysreg_prop(Object *obj, Visitor *v,
> +                            const char *name, void *opaque,
> +                            Error **errp)
> +{
> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    uint64_t *idregs = cpu->isar.idregs;
> +    uint64_t old, value, mask;
> +    int lower = field->shift;
> +    int length = field->length;
> +    int index = field->index;
> +
> +    if (!visit_type_uint64(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    if (length < 64 && value > ((1 << length) - 1)) {
> +        error_setg(errp,
> +                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
> +                   name, value, length);
> +        return;
> +    }
> +
> +    if (field->arch_vals) {
> +        /* this field has some enum values */
> +        for (int i = 0; i < field->arch_vals_count; i++) {
> +            if (value == field->arch_vals[i]) {
> +                goto valid;
> +            }
> +        }
> +        error_setg(errp,
> +                   "idreg %s set value (0x%lx) does not match any "
> +                   "arch valid enum value", name, value);
> +        return;
> +    }
> +
> +valid:
> +
> +    mask = MAKE_64BIT_MASK(lower, length);
> +    value = value << lower;
> +    old = idregs[index];
> +    idregs[index] = old & ~mask;
> +    idregs[index] |= value;
> +    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
> +}
> +
> +static void get_sysreg_prop(Object *obj, Visitor *v,
> +                            const char *name, void *opaque,
> +                            Error **errp)
> +{
> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    uint64_t *idregs = cpu->isar.idregs;
> +    uint64_t value, mask;
> +    int lower = field->shift;
> +    int length = field->length;
> +    int index = field->index;
> +
> +    mask = MAKE_64BIT_MASK(lower, length);
> +    value = (idregs[index] & mask) >> lower;
> +    visit_type_uint64(v, name, &value, errp);
> +    trace_get_sysreg_prop(name, value);
> +}
> +
> +static void add_idregs_properties(Object *obj, ARM64SysReg *reg)
> +{
> +    int nb_sysreg_props = 0;
> +
> +    for (int i = 0; i < reg->fields_count; i++) {
> +        ARM64SysRegField *field = &reg->fields[i];
> +
> +        /* skip reserved fields */
> +        if (g_str_equal(field->name, "RES0") ||
> +            g_str_equal(field->name, "RES1") ||
> +            g_str_equal(field->name, "RAZ")) {
> +            continue;
> +        }
> +
> +        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
> +                                          field->name);
> +        object_property_add(obj, prop_name, "uint64",
> +                            get_sysreg_prop, set_sysreg_prop, NULL, field);
> +        g_free(prop_name);
> +        nb_sysreg_props++;
> +    }
> +
> +    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
> +}
> +
> +void aarch64_add_idregs_properties(Object *obj)
> +{
> +    for (int i = 0; i < NUM_ID_IDX; i++) {
> +        add_idregs_properties(obj, &arm64_id_regs[i]);
> +    }
> +}
> +#endif
> +
>  void aarch64_add_pauth_properties(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> @@ -810,7 +909,7 @@ void aarch64_host_initfn(Object *obj)
>      aarch64_add_sve_properties(obj);
>  
>      /* generate SYSREG properties */
> -    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
> +    aarch64_add_idregs_properties(obj);
>  
>  #elif defined(CONFIG_HVF)
>      hvf_arm_set_cpu_features_from_host(cpu);
> diff --git a/target/arm/internals.h b/target/arm/internals.h
> index f6b4e173a5..7c76ffea7d 100644
> --- a/target/arm/internals.h
> +++ b/target/arm/internals.h
> @@ -1813,6 +1813,7 @@ void aarch64_max_tcg_initfn(Object *obj);
>  void aarch64_add_pauth_properties(Object *obj);
>  void aarch64_add_sve_properties(Object *obj);
>  void aarch64_add_sme_properties(Object *obj);
> +void aarch64_add_idregs_properties(Object *obj);
>  void aarch64_aa32_a57_init(ARMCPU *cpu, bool aa64_enabled);
>  void aarch64_host_initfn(Object *obj);
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 2f6c090e43..d5155a3706 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -416,106 +416,6 @@ bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
>      return true;
>  }
>  
> -static void set_sysreg_prop(Object *obj, Visitor *v,
> -                            const char *name, void *opaque,
> -                            Error **errp)
> -{
> -    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
> -    ARMCPU *cpu = ARM_CPU(obj);
> -    uint64_t *idregs = cpu->isar.idregs;
> -    uint64_t old, value, mask;
> -    int lower = field->shift;
> -    int length = field->length;
> -    int index = field->index;
> -
> -    if (!visit_type_uint64(v, name, &value, errp)) {
> -        return;
> -    }
> -
> -    if (length < 64 && value > ((1 << length) - 1)) {
> -        error_setg(errp,
> -                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
> -                   name, value, length);
> -        return;
> -    }
> -
> -    if (field->arch_vals) {
> -        /* this field has some enum values */
> -        for (int i = 0; i < field->arch_vals_count; i++) {
> -            if (value == field->arch_vals[i]) {
> -                goto valid;
> -            }
> -        }
> -        error_setg(errp,
> -                   "idreg %s set value (0x%lx) does not match any "
> -                   "arch valid enum value", name, value);
> -        return;
> -    }
> -
> -valid:
> -
> -    mask = MAKE_64BIT_MASK(lower, length);
> -    value = value << lower;
> -    old = idregs[index];
> -    idregs[index] = old & ~mask;
> -    idregs[index] |= value;
> -    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
> -}
> -
> -static void get_sysreg_prop(Object *obj, Visitor *v,
> -                            const char *name, void *opaque,
> -                            Error **errp)
> -{
> -    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
> -    ARMCPU *cpu = ARM_CPU(obj);
> -    uint64_t *idregs = cpu->isar.idregs;
> -    uint64_t value, mask;
> -    int lower = field->shift;
> -    int length = field->length;
> -    int index = field->index;
> -
> -    mask = MAKE_64BIT_MASK(lower, length);
> -    value = (idregs[index] & mask) >> lower;
> -    visit_type_uint64(v, name, &value, errp);
> -    trace_get_sysreg_prop(name, value);
> -}
> -
> -static void
> -add_idreg_field_properties(Object *obj, ARM64SysReg *reg)
> -{
> -    int nb_sysreg_props = 0;
> -
> -    for (int i = 0; i < reg->fields_count; i++) {
> -        ARM64SysRegField *field = &reg->fields[i];
> -
> -        /* skip reserved fields */
> -        if (g_str_equal(field->name, "RES0") ||
> -            g_str_equal(field->name, "RES1") ||
> -            g_str_equal(field->name, "RAZ")) {
> -            continue;
> -        }
> -
> -        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
> -                                          field->name);
> -        object_property_add(obj, prop_name, "uint64",
> -                            get_sysreg_prop, set_sysreg_prop, NULL, field);
> -        g_free(prop_name);
> -        nb_sysreg_props++;
> -    }
> -
> -    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
> -}
> -
> -void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
> -{
> -    Object *obj = OBJECT(cpu);
> -
> -    for (int i = 0; i < NUM_ID_IDX; i++) {
> -        ARM64SysReg *sysregdesc = &regs[i];
> -        add_idreg_field_properties(obj, sysregdesc);
> -    }
> -}
> -
>  static void
>  kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>  {
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index aafb3cd232..997120966f 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -163,16 +163,6 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>   */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>  
> -typedef struct ARM64SysReg ARM64SysReg;
> -/**
> - * kvm_arm_expose_idreg_properties:
> - * @cpu: The CPU object to generate the properties for
> - * @reg: registers from the host
> - *
> - * analyze the writable mask and generate properties for writable fields
> - */
> -void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs);
> -
>  /**
>   * kvm_arm_steal_time_finalize:
>   * @cpu: ARMCPU for which to finalize kvm-steal-time
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 7696a8ed40..bbf2e5dfa2 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -15,10 +15,12 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>  kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
> +kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
> +
> +# cpu64.c
>  get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
>  set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
>  nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
> -kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
>  
>  # cpu.c
>  arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64

