Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2F54C753F
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 13:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792158901; cv=none; b=jjNQMJcTY5GirtnOzy95ZMu6SnqXMpwFqFFjolSW9MxYXZ38H41SF7udQHlPlABssoV4kXH/eUYhNRhndS7Ol2wjGl6PWjHJN6p2GG9C05lflzu9T76eEbMynfOf4h93S+6ouA/YuxWQrywkonHh/e3wjK1i6z9lEWZUSifa9SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792158901; c=relaxed/simple;
	bh=2FWwlvBwLeY/hM8eULafw7e3nNraN1n+3FkXLdg5yTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GIOY1aggD3NsKZ+6cNFhXkJRvRa5Hn1qRNZnbYVuxCQAcNcAuJT+ktsAlFzppM/8CnUaIQ66JkK/Nf6j8fHFOGibho2GVc3UU3xMPbo06O1ift+8Vm76o4JWZWq/4FhowOk7gRH3G0RaxDEF+POa1be3b2FYI1V0aKKfKAI2N+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CZVcNMEI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZVcNMEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792158899;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3owZnDxfPPBPVhBKp7S/V/dJ4O1D5PPO4EeDa7UuIg=;
	b=CZVcNMEIrkO1W3MCmCAeL08w8hzIY1RJqjx8ww9NRLP9Lqy9kou+T8WyViCUnOlR0mEdHC
	Pv04xOrKLXQ5rzoJHzeVFYyBt4TO4wvMABY+ERv87Tt1K38N6e3IIqYWc6GhJNcGCWqXrx
	paz/dUY3ir5YbwZ/ecJBBn50MA08xi4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-s5gZ0wIxPd6h8cpjvaH3Ww-1; Fri, 16 Oct 2026 13:54:57 +0000
X-MC-Unique: s5gZ0wIxPd6h8cpjvaH3Ww-1
X-Mimecast-MFC-AGG-ID: s5gZ0wIxPd6h8cpjvaH3Ww_1792158896
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1d15e7bfaso4517285e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792158896; x=1792763696;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S3owZnDxfPPBPVhBKp7S/V/dJ4O1D5PPO4EeDa7UuIg=;
        b=uF92EycyAb+sH+SCXOMpmc2ZFWEnUfVhNls/xhIgSVLcPB039bMPQJ2Ab7Lh2cwrJU
         Rm5em5niwyrmo3h6JaNMS0QVhguJVBDZGUJG0o2wnA0ZMKqS4IlFrPPP8qYoc/88wcJ8
         Vya8dz2CXHxRZOQKYiltl95FvIA2OHDar0bEASkY5ixgucd7r14F8cigFmSPsTik6gIr
         GQrjTIPxD4u3vyG4UJlUAEK6WKxRFy8wcI9+84QSUVwtXqQkgeXJpRBLuT8MtmcsLcnz
         cc7lC5j1Wi+eS7//HBu7+5b5mDff9tjoNYiDjTVDCmnLCO3YiZUHrTcXENuox1hIZUID
         1yaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzY9vHPLXeYXF90LczsuJ9nYEizoGC48HpHLtRQopnbov7GzHWsIw3FxEksRQ1VP3Hyf6TOy0I=@lists.linux.dev
X-Gm-Message-State: AFq9FYKD4ZvXFVtcD1bTWKfSsNDQQxeXulLZ+Qp2ZVzzIgpQ2UBqlV+/
	odflEIhUFQsmadymjPi+xRPDBZ9qzjDIDPVSFr78Ewo2mLQ1lwhuyMjVYLt+txG11n2JU5qKUV1
	N4cfAwm+1LAZeRFGoIbrWhxDDaZJ9yMWnePugzi0cLZuEp9JBAULWTpiy5g==
X-Gm-Gg: AYBFou3LCMELD7qFq3s2DyUrjuwnXyv1+HvQIU9+TtS1RTuSZcOOExbt9vdHCylE/Xq
	JSfH6UNrw/fXf+UeJMiEhhyuV1NpNTZAFOSftdsO/It7b5H2H3o3yJ5ZQY2mroLE29Mz46TgJ8y
	lan/TqpQdF+JTm3DDh4402QJixaeuAqiTNmatHwzwFJLT7mFMTtJ0hl/U/N4kZW7OycY29Upwxc
	DRP4/1fQKLt0TlrgB/U4Upn9ct+z/feMXb5UOoERDVPfkdIi4ux7qTqT7a1qRYgWO4bEjgSlwYw
	T+nFJNM8W9E5Yw0vROeD2ubpz20CfPMy+BOX/0cAVVp3Fax8D/qIoEtymO5+T+uLiC/PvnH3qeq
	dEqMe0RR3suD7wukLDKE++3/4HqAK3jsRWOv9sjGSd13BrMUZ
X-Received: by 2002:a05:600d:8488:10b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4a190780997mr316217845e9.31.1792158896262;
        Fri, 16 Oct 2026 06:54:56 -0700 (PDT)
X-Received: by 2002:a05:600d:8488:10b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4a190780997mr316217355e9.31.1792158895821;
        Fri, 16 Oct 2026 06:54:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9a88bbsm154675415e9.3.2026.10.16.06.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 06:54:55 -0700 (PDT)
Message-ID: <89403aff-9082-40fb-bd62-a13638bde9f7@redhat.com>
Date: Fri, 16 Oct 2026 15:54:53 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 25/25] target/arm/qmp: hook blockers in
 query-cpu-definitions
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
 <20260921123249.1708067-26-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-26-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nBbl4O-UW8Rkk7A1xESbqUQgaiiuKWV5vsYSGvCxMgY_1792158896
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Report blockers for named CPU models in query-cpu-definitions.
>
> Efficiently do this by validating the realized ID register values
> against the host values. sveNNNN properties need special handling
> because they are not stored in ID registers.
>
> This way, we need not instantiate each model to check if it can be
> realized on the host, and we also get granular information about the ID
> register fields blocking realization.
>
> Introduce arm_cpu_class_check_missing_features() and
> kvm_arm_idregs_get_blockers() to achieve this.

I would recommend to show an excerpt of the output
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/arm-qmp-cmds.c    | 12 +++++++++
>  target/arm/cpu-models-stub.c |  5 ++++
>  target/arm/cpu-models.c      | 35 +++++++++++++++++++++++++
>  target/arm/cpu-models.h      |  2 ++
>  target/arm/kvm.c             | 50 ++++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h         | 13 ++++++++++
>  6 files changed, 117 insertions(+)
>
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index ba488d5c01..d837ec6653 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -379,6 +379,18 @@ static void arm_cpu_add_definition(gpointer data, gpointer user_data)
>      info->name = cpu_model_from_type(typename);
>      info->q_typename = g_strdup(typename);
>  
> +    /* calculate blockers */
> +    if (kvm_enabled()
> +            && !g_str_equal(info->name, "host")
> +            && !g_str_equal(info->name, "max")
> +            && arm_find_model(info->name) != NULL) {
> +        arm_cpu_class_check_missing_features(ARM_CPU_CLASS(oc),
> +                                    &info->unavailable_features);
> +        if (info->unavailable_features) {
> +            info->has_unavailable_features = true;
> +        }
> +    }
> +
>      QAPI_LIST_PREPEND(*cpu_list, info);
>  }
>  
> diff --git a/target/arm/cpu-models-stub.c b/target/arm/cpu-models-stub.c
> index 48f712d648..2d1be49e0a 100644
> --- a/target/arm/cpu-models-stub.c
> +++ b/target/arm/cpu-models-stub.c
> @@ -11,3 +11,8 @@ const ArmNamedCpuModel *arm_find_model(const char *name)
>  {
>      return NULL;
>  }
> +
> +void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
> +{
> +    return;
> +}
> diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
> index 855eb5ee6b..9591b6dbfc 100644
> --- a/target/arm/cpu-models.c
> +++ b/target/arm/cpu-models.c
> @@ -477,6 +477,41 @@ static void arm_named_cpu_initfn(Object *obj)
>      arm_named_cpu_zero_unknown_feature_ids(cpu, &error_abort);
>  }
>  
> +void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
> +{
> +    Error *err = NULL;
> +    Object *obj = object_new_with_class(OBJECT_CLASS(acc));
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    if (!kvm_enabled() || !arm_find_model(acc->info->name)) {
> +        goto out;
> +    }
> +
> +    if (cpu_isar_feature(aa64_sve, cpu)) {
> +        aarch64_cpu_sve_finalize(cpu, &err);
> +        if (err) {
> +            error_free(err);
> +            err = NULL;
> +            uint32_t host_vq_map = cpu->sve_vq.supported;
> +            uint32_t model_vq_map = cpu->sve_vq.map;
> +
> +            if ((model_vq_map & host_vq_map) != model_vq_map) {
> +                for (int vq = 1; vq <= ARM_MAX_VQ; vq++) {
> +                    uint32_t vq_bit = (1 << (vq - 1));
> +                    if ((model_vq_map & vq_bit) && !(host_vq_map & vq_bit)) {
> +                        QAPI_LIST_PREPEND(*blockers,
> +                            g_strdup_printf("sve%d", vq * 128));
> +                    }
> +                }
> +            }
> +        }
> +    }
> +
> +    kvm_arm_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
> +out:
> +    object_unref(obj);
> +}
> +
>  void arm_register_named_cpu_models(void)
>  {
>      static ARMCPUInfo *arm_named_cpu_infos;
> diff --git a/target/arm/cpu-models.h b/target/arm/cpu-models.h
> index 144778744e..41bb15d928 100644
> --- a/target/arm/cpu-models.h
> +++ b/target/arm/cpu-models.h
> @@ -4,6 +4,7 @@
>  
>  #include "qapi/error.h"
>  #include "qom/object.h"
> +#include "cpu.h"
>  
>  typedef enum ArmModelPropType {
>      ARM_MODEL_PROP_BOOL,
> @@ -32,5 +33,6 @@ void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
>                             Error **errp);
>  void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
>                               Error **errp);
> +void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers);
>  
>  #endif /* ARM_CPU_MODELS_H */
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index bb74f8c274..ca3da80262 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1485,6 +1485,56 @@ arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
>      return field_matches(field, ID_DFR0_EL1_IDX, "PerfMon");
>  }
>  
> +void kvm_arm_idregs_get_blockers(ARMCPU *cpu,
> +                                 const ARMISARegisters *host_isar,
> +                                 strList **blockers)
> +{
> +    for (int i = 0; i < NUM_ID_IDX; i++) {
> +        ARM64SysReg *reg = &arm64_id_regs[i];
> +
> +        if (!reg->name) {
> +            continue;
> +        }
> +
> +        for (uint32_t j = 0; j < reg->fields_count; j++) {
> +            const ARM64SysRegField *field = &reg->fields[j];
> +            ArmFieldValueSet *vs = NULL;
> +            bool supported = false;
> +            uint64_t model_val;
> +
> +            /* Not a blocker if the field is never written back to KVM. */
> +            if (arm_field_skip_writeback_always(field) ||
> +                (!arm_field_is_writable(field) &&
> +                 arm_field_skip_writeback_if_not_writable(field))) {
> +                continue;
> +            }
> +
> +            model_val = extract64(cpu->isar.idregs[field->index],
> +                                  field->shift, field->length);
nit I see you use that several times, you could introduce a helper
> +
> +            /*
> +             * If the field is written back, make sure a "supported" value
> +             * is requested.
> +             */
> +            kvm_arm_field_get_supported_values(field, host_isar, &vs);
> +            for (size_t k = 0; k < vs->n_ranges; k++) {
> +                if (model_val >= vs->ranges[k].min &&
> +                    model_val <= vs->ranges[k].max) {
> +                    supported = true;
> +                    break;
> +                }
> +            }
> +            g_free(vs->ranges);
> +            g_free(vs);
> +
> +            if (!supported) {
> +                QAPI_LIST_PREPEND(*blockers,
> +                    g_strdup_printf("SYSREG_%s_%s", reg->name, field->name));
> +            }
> +        }
> +    }
> +}
> +
>  /*
>   * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
>   * so the subsequent write_list_to_kvmstate() pushes them to KVM.
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index ab01ce8665..59832d8063 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -205,6 +205,19 @@ void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
>                                          const ARMISARegisters *host_isar,
>                                          ArmFieldValueSet **value_set);
>  
> +/**
> + * kvm_arm_idregs_get_blockers:
> + * @cpu: ARMCPU
> + * @host_isar: The host ISAR registers
> + * @blockers: The list of blockers
> + *
> + * Get the list of "blockers" in @cpu's idregs state for the given
> + * @host_isar.
> + */
> +void kvm_arm_idregs_get_blockers(ARMCPU *cpu,
> +                                 const ARMISARegisters *host_isar,
> +                                 strList **blockers);
> +
>  /**
>   * kvm_arm_steal_time_finalize:
>   * @cpu: ARMCPU for which to finalize kvm-steal-time
Thanks

Eric

