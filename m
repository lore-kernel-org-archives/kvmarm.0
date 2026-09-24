Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306347A0D1
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 13:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790256952; cv=none; b=D6jToUZzahn2Cv8xKNi5Bc/O/elPsEjgzqVo480tfZHW3SOer0CW5sYq7yL23ELWzSLgz7hF3Nz/JK1rSKYz9rUqerGT6N+nyGT5L9+HXjn9QcU/EPS6NyJOkWXH3j9VshYftos1gt4RonuuIAnJL71pUr+zIVMUkB5QnUx20YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790256952; c=relaxed/simple;
	bh=u/lA6o7fCQEsh2hBZwMAylg1baZipcXHA8L/hxwxNmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jv9qMzqFJIEOhC0JvNI2tjEw5EwdQMcmdwzo8g7tm1G8wTbJivuELCEgrC7iGyuPBtxud9CilrGXJXHEOTkr34AI2Z+1euQ/X+jiq8ARyU3FcS6UAOTNvwOsb4pWWRm7rxmenDyrWUPO9bMfEhqPC9htAf4hMvSNI+YYSTGXWtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UXksRXKQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXksRXKQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790256942;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vshkQVFITpqH2vOLyhtffskoGqItXSX3caa0iu331ug=;
	b=UXksRXKQgza08HqZoe71EY8WYVAJEM/U2QMAMTCS06X9vh7VFgE89fHkfryXuEjpZWRExV
	UCeOD5hNjeXWQ6ucdYigz9tIpX1HXIK/1Qs+0Y/WJOTh6dMF5BV0/uczDzB8WM1c0gxDJH
	GgcqtiUWp6IWHhPDE8pjlXnmE2en95Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-lHPeW8vQP5W-6pDqeq3prg-1; Thu, 24 Sep 2026 09:35:41 -0400
X-MC-Unique: lHPeW8vQP5W-6pDqeq3prg-1
X-Mimecast-MFC-AGG-ID: lHPeW8vQP5W-6pDqeq3prg_1790256940
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4870af30a85so714173f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790256940; x=1790861740;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vshkQVFITpqH2vOLyhtffskoGqItXSX3caa0iu331ug=;
        b=WSHjznc5mcyIdxlCbnWAEwpXgT0KpGfIZK5q5ZJ0oKgjnnIa0DkYcSRiM6lG3wqNFe
         fEIsoSTMK3mcR8Ob8ucxuw+zCtqWsPVv5lyZZH0pHUNLJSMbAJO78Xj1pHdAyzjlW1XB
         QoNsoOsrWmpAkkKY6vtV8anjH4SNm4P4MPDae5QGqO1cPnNtA8jYv2VwnVb4qUOwkfc6
         llgZ5/qxvD7w+8hMH+K+Bw7ogAcf+4KHjQUBaNAxlNOXE3cHNTr/zprwaDBbfLqXr7h+
         C9Mm12exKNdXmKNuS4DaWUMq8ahpZFjwAKCRtgiCR9wQgBNY9XRy8ndxibQ0+zGBL1yQ
         5f/g==
X-Forwarded-Encrypted: i=1; AKwUvBwtbwfqwE0s4eVcqRxR04Lihte515JA2Dkfiw4nHEWvXilhkgQUcswTfvg3kapTPkl8CKKNam0=@lists.linux.dev
X-Gm-Message-State: AFuF++kxzQWtVzjICHHbZLC+btdjR4s4l0m0PZfRr0qyhUatAHvnFFaq
	Ix6eNtrQauHwDAoeVbK/Az36jUBPgbORwSGrtegQuKNDEmWbiC+1fhvFVJkYsVeZICqYDDJK/Y4
	bOXEio9odcQShFshke2ZaMbQ8GvSPQFoa4w09wbeATQ1pMFUAjS23ED4yxw==
X-Gm-Gg: AYBFou26xkadXIEdYCHDF/QByQD198O1uvp8kCoHkzzggfMicJuuqtTuxpTV70lIiLZ
	B5VwTX82nF5MBIaeYrBdGPjMaVeRqZXL83gCW0OTmE+5xViDh8ZxuueI1MzrYt4Cb4AwV/GCtsu
	GthY/Nx+dOkmaQOrP16+MUjGMGIl6ZEXjOntJzGZo6szYzcQs61n4nnHgE1AgFyLiWPqWNcVsa3
	qisusEujjtsD7RDx33zZmUtfC5F4EWSl3gHTfOfYA2a7c5xB+eb6aVH0OKm2r3PXO85s/eEeAzh
	hB7jl/m16Y2ogHDsG8BPYipp0UmOOAGuHCuG9H1nN3OIvKGaCiuP7JFHQfIn/KIEwLByN5dIKah
	V4CL6JI/nWYKv9Q2XmllhI3uIp1fJicK+yAZZLVBYdeAui38z
X-Received: by 2002:a05:6000:184e:b0:488:5fa9:34aa with SMTP id ffacd0b85a97d-488716d22bcmr5147051f8f.20.1790256939842;
        Thu, 24 Sep 2026 06:35:39 -0700 (PDT)
X-Received: by 2002:a05:6000:184e:b0:488:5fa9:34aa with SMTP id ffacd0b85a97d-488716d22bcmr5146982f8f.20.1790256939370;
        Thu, 24 Sep 2026 06:35:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488682673bdsm14729085f8f.2.2026.09.24.06.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 06:35:38 -0700 (PDT)
Message-ID: <872fd689-3a28-4c0d-ab0f-86a7062bf974@redhat.com>
Date: Thu, 24 Sep 2026 15:35:36 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 09/25] target/arm: introduce named CPU model
 infrastructure
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
 <20260921123249.1708067-10-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-10-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jdg0gA9K6ivGP0oGsuQhgYhTn2lqnFDmAHmMfuoCFHA_1790256940
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Add scaffolding for named CPU models on Arm on top of the property
> layer. A model is a list of (property, value) overrides plus an
> optional parent; a child inherits its parent's property values and may
> override them.
>
> Instance init steps:
>     - host feature discovery.
>     - zero out isar.idregs[] and restore RES1 fields.
>     - install SYSREG_ and sve* properties.
>     - walk the parent chain root-first and apply each level's
>       properties.
you should explain about prop types. I see they are either bool or uint.
Given the parent series bool usage is not obvious.
>
> This assumes that each property is idempotent. `pauth` is intentionally
> not installed because the model's ID register view is authoritative
> and can be configured through SYSREG_ properties.
>
> No models are defined yet.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu-models.c | 191 ++++++++++++++++++++++++++++++++++++++++
>  target/arm/cpu-models.h |  36 ++++++++
>  target/arm/meson.build  |   1 +
>  3 files changed, 228 insertions(+)
>  create mode 100644 target/arm/cpu-models.c
>  create mode 100644 target/arm/cpu-models.h
>
> diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
> new file mode 100644
> index 0000000000..fed3197186
> --- /dev/null
> +++ b/target/arm/cpu-models.c
> @@ -0,0 +1,191 @@
> +/*
> + * ARM named CPU models.
> + *
> + * Each model is defined as an array of MODEL_PROP macros, listing only
> + * the properties that DIFFER from the parent model.
> + *
> + * Initialization starts with a zeroed idregs[] array.
> + *
> + * During initialization, the parent chain is walked root-first and every
> + * level's properties are applied via QOM, so the leaf's values naturally
> + * override its ancestors.
> + *
> + * Assumptions:
> + *     - All named CPU model properties are idempotent.
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "system/kvm.h"
> +#include "cpu.h"
> +#include "internals.h"
> +#include "kvm_arm.h"
> +#include "cpu-idregs.h"
> +#include "cpu-models.h"
> +
> +#define MODEL_PROP_FIELD_STR  str
> +#define MODEL_PROP_FIELD_BOOL b
> +#define MODEL_PROP_FIELD_NUM  num
> +
> +#define MODEL_PROP(_name, _type, _value) \
> +    { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
> +      .u.MODEL_PROP_FIELD_##_type = (_value) }
> +
> +#define MODEL_PROP_END  { .name = NULL }
> +
> +/* Maximum parent-chain depth for named CPU models. */
inheritence depth?
> +#define ARM_NAMED_CPU_MODEL_MAX_DEPTH 16
> +
> +static const ArmNamedCpuModel arm_cpu_models[] = {
> +    {NULL, NULL, NULL}
> +};
> +
> +const ArmNamedCpuModel *arm_find_model(const char *name)
> +{
> +    for (size_t i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
> +        if (!arm_cpu_models[i].name) {
> +            break;
> +        }
> +
> +        if (g_str_equal(arm_cpu_models[i].name, name)) {
> +            return &arm_cpu_models[i];
> +        }
> +    }
> +    return NULL;
> +}
> +
> +void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
> +                           Error **errp)
> +{
> +    const ArmModelPropValue *pv;
> +    ERRP_GUARD();
> +
> +    for (pv = props; pv->name; pv++) {
> +        switch (pv->type) {
> +        case ARM_MODEL_PROP_BOOL:
> +            object_property_set_bool(obj, pv->name, pv->u.b, errp);
> +            break;
> +        case ARM_MODEL_PROP_NUM:
> +            object_property_set_uint(obj, pv->name, pv->u.num, errp);
> +            break;
> +        default:
> +            g_assert_not_reached();
> +        }
> +
> +        if (*errp) {
> +            error_prepend(errp, "property '%s': ", pv->name);
> +            return;
> +        }
> +    }
> +}
> +
> +void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
> +                             Error **errp)
> +{
> +    const ArmNamedCpuModel *cur, *parent;
> +    const ArmNamedCpuModel *chain[ARM_NAMED_CPU_MODEL_MAX_DEPTH];
> +    size_t depth = 0;
> +
> +    for (cur = model; cur; ) {
> +        if (depth >= ARRAY_SIZE(chain)) {
> +            error_setg(errp, "model '%s': parent chain too deep", model->name);
> +            return;
> +        }
> +        chain[depth++] = cur;
Please add a comment about the so-called chain and especially describing
that chain[0] is the child and high-level eindex lements are the parents
it derives from.
> +
> +        if (!cur->parent) {
> +            break;
> +        }
> +        parent = arm_find_model(cur->parent);
I guess you directly assert
> +        if (!parent) {
> +            error_setg(errp, "model '%s': unknown parent '%s'", cur->name,
> +                cur->parent);
> +            return;
> +        }
> +        cur = parent;
> +    }
> +
> +    while (depth--) {
> +        arm_apply_model_props(obj, chain[depth]->props, errp);
> +        if (*errp) {
> +            return;
> +        }
> +    }
> +}
> +
> +static void reset_res1_fields(ARMCPU *cpu)
> +{
> +    for (size_t i = 0; i < NUM_ID_IDX; i++) {
> +        for (size_t j = 0; j < arm64_id_regs[i].fields_count; j++) {
> +            if (strcmp(arm64_id_regs[i].fields[j].name, "RES1") == 0) {
> +                cpu->isar.idregs[i] = deposit64(cpu->isar.idregs[i],
> +                    arm64_id_regs[i].fields[j].shift,
> +                    arm64_id_regs[i].fields[j].length,
> +                    MAKE_64BIT_MASK(0, arm64_id_regs[i].fields[j].length));
> +            }
> +        }
> +    }
> +}
> +
> +static void arm_named_cpu_initfn(Object *obj)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
> +    const ArmNamedCpuModel *model = arm_find_model(acc->info->name);
> +
> +    if (!model) {
> +        error_report("'%s' CPU model entry not found",
> +                     acc->info->name);
> +        return;
> +    }
> +
> +    if (!kvm_enabled()) {
> +        error_report("'%s' CPU model requires KVM (-accel kvm)",
> +                     acc->info->name);
> +        return;
> +    }
> +
> +    kvm_arm_set_cpu_features_from_host(cpu);
> +    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
> +        return;
> +    }
> +
> +    /* 1.a Reset ID regs to 0 */
> +    memset(cpu->isar.idregs, 0, sizeof(cpu->isar.idregs));
> +
> +    /* 1.b Properly set RES1 fields. */
> +    reset_res1_fields(cpu);
> +
> +    /* 2. Add sveNNNN and SYSREG_ properties */
> +    aarch64_add_sve_properties(obj);
> +    aarch64_add_idregs_properties(obj);
Can you give more explanations about why we don't have
aarch64_add_pauth_properties()
kvm_arm_set_cpreg_mig_tolerances()

at least.

By the way it is not clear what will become legacy compositive options
with named vcpu models. I see you keep sve but what about the others.
> +
> +    /* 3. Realize the model chain. */
> +    arm_realize_model_chain(obj, model, &error_abort);
> +}
> +
> +void arm_register_named_cpu_models(void)
> +{
> +    static ARMCPUInfo *arm_named_cpu_infos;
> +    size_t i, n = ARRAY_SIZE(arm_cpu_models);
> +
> +    if (!n) {
> +        return;
> +    }
> +
> +    arm_named_cpu_infos = g_new0(ARMCPUInfo, n);
> +    for (i = 0; i < n; i++) {
> +        if (!arm_cpu_models[i].name) {
> +            break;
> +        }
> +
> +        arm_named_cpu_infos[i].name = arm_cpu_models[i].name;
> +        arm_named_cpu_infos[i].initfn = arm_named_cpu_initfn;
> +        arm_cpu_register(&arm_named_cpu_infos[i]);
> +    }
> +}
> +
> +type_init(arm_register_named_cpu_models)
> diff --git a/target/arm/cpu-models.h b/target/arm/cpu-models.h
> new file mode 100644
> index 0000000000..144778744e
> --- /dev/null
> +++ b/target/arm/cpu-models.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef ARM_CPU_MODELS_H
> +#define ARM_CPU_MODELS_H
> +
> +#include "qapi/error.h"
> +#include "qom/object.h"
> +
> +typedef enum ArmModelPropType {
> +    ARM_MODEL_PROP_BOOL,
> +    ARM_MODEL_PROP_NUM,
> +} ArmModelPropType;
> +
> +typedef struct ArmModelPropValue {
> +    const char *name;
> +    ArmModelPropType type;
> +    union {
> +        bool b;
> +        uint64_t num;
> +    } u;
> +} ArmModelPropValue;
> +
> +typedef struct ArmNamedCpuModel {
> +    const char *name;
> +    const char *parent;
any reason why you don't point to the patent ArmNamedCpuModel pointer
instead?
> +    const ArmModelPropValue *props;
> +} ArmNamedCpuModel;
> +
> +void arm_register_named_cpu_models(void);
> +
> +const ArmNamedCpuModel *arm_find_model(const char *name);
> +void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
> +                           Error **errp);
> +void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
> +                             Error **errp);
> +
> +#endif /* ARM_CPU_MODELS_H */
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index 384d90c530..dd28146c52 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -32,6 +32,7 @@ arm_common_system_ss.add(files(
>    'arm-qmp-cmds.c',
>    'cpu-idregs.c',
>  ))
> +arm_system_ss.add(when: 'TARGET_AARCH64', if_true: files('cpu-models.c'))
>  arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
>  arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
>  
Eric

