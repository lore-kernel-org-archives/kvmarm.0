Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC44A4F0C
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 13:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156915; cv=none; b=sekx5HPf2LgJRTxytbUOvCk/iAKzND/qKDXZt0Jx0PNWAEopnq3vcLgQ8ExVDV6KtAAkKdtK9TVN5e2ks2VPKzhrmk8pzKH84T8AK3JxnVXHtrx/vzvt6ZxGpGCjKl/+7gmLS4ShKRvLegxEY4FDynuzzXPln896mIoLfUcbvP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156915; c=relaxed/simple;
	bh=y93t19qTUov1y2sLa1Hy0fBLm5DgTEafXbawc95i7fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxgykEN2MtcoASU1T6KIOOEXSkT+1m5dmNUz0WF75w1CdS5LYot9v2Rxgm2h2fy+7PCBNtsS7YW1Ti4D+Z8/zs6Qy2u84kwpvgk8BKdyBVMzLaasPSEkguw1yLJQEz1nR4VOznXlUmoMzOiuGx9lpBsNcjognf6U9AwSM8YtkdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C+aEn36N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+aEn36N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792156912;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nvNMJKy5hEsNmX3h2yw6AJYeXfgIvjlosnD74UtrqYM=;
	b=C+aEn36NzuycGolqcoagJv/YT/bqAqBadu2IG4a21g0g3zPLGOj3SfJAhfzZ55u791OOp9
	AdnWTiPRUQv1YYj+F4SFOKGVGnCZQK/2nfO0rP7t1Nss1Fe2n3AcwjZIsXhb/UDzPfQh0R
	lFGs5SdUOAlWVK035kz1yUpjtd7ldeQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-acRXHovOM7KexuZYvbgJ5g-1; Fri, 16 Oct 2026 13:21:50 +0000
X-MC-Unique: acRXHovOM7KexuZYvbgJ5g-1
X-Mimecast-MFC-AGG-ID: acRXHovOM7KexuZYvbgJ5g_1792156909
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-487038bc9b8so5147398f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156909; x=1792761709;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nvNMJKy5hEsNmX3h2yw6AJYeXfgIvjlosnD74UtrqYM=;
        b=EpUX39uUIHjCqZGEn4LivNSw7eKV3FCsVGmzgj2PSdMNoLYKl53LsOuns3AZuA6xc5
         7yKc6VLvV8ATuKrYhgKDtW1kxlKKALki4kuD61pJDz7YtUzspnbsDBzNk656b+0n2635
         oTnFV8Yjhmxnx746vYMB3mcJhL9xfSbdS2HJSNA+apJDJnB5RjsZJL8xcGDvtukVzfOD
         N9sQrnSlq668+KHiEMIng4wRL4HACbc6/Z2DXMy1dbodLXejI2f5H+qcitNOhPRNbLJw
         u6nxgrrL6lvSaUPP105EtrQZIZJCMw0U2HsxfPBAPlUXAuunsQHWa/IHOXk0fHGzeTzv
         Resg==
X-Forwarded-Encrypted: i=1; AKwUvByfi3B02pMjoFfDk2ZHDZUCoFh4t8QcNozCanX+GCQk1idict1rD/AMydJ9tITgOn1RBCsAfpM=@lists.linux.dev
X-Gm-Message-State: AFq9FYIZjUa16m4x44b0bxMYKR7i0KpwFCMiySkqERJfNs6/jFfbRDm1
	wjPKBDK+dRrwqRAc/X1Re+BamI2NIpLmFrKbMRsOsyNIg8j3urmAlH35ZlXq56fisquzMrktxcZ
	fS3dFRl/MF7hd/7iLALAoXS8c7z+7i2je6pVRyoiOfSYKA88i27VonSRHRg==
X-Gm-Gg: AYBFou3tqPyN9WawprNjMlHlR3cgnWVCyQWbFAcLrf2eOnPMUHFVAd8ygoapUnK/bKa
	gQ4/cecWbbMFLKi8s1xwNmpMkJpB9MiC8fsSfj1PR2KPib2G2JUe+G/F6JdCT7zhb+2tnAWMdFd
	8ypCAAhFygH7H2SQsfvi8ejonilFVXkJbuCH6PKW6FPfv+X3a8RndANfUY07ckUBwcFfC2zpata
	cQPecK7QhGWh5aiVdPo/Fns7Jguv/Dqy1jc2cQLQ9hWwV2K693ZuVTg2DRhJNwABWu637DPoTpc
	YRXIDuSMwEaRnhn5m4yVyOaw9VXm3dnVtBcswpQNopI5PblFwQtry3qXhSeaZcNjCPE6+dgVrmE
	Zklp+xlmZ8JdWu939L2GKhTh7ki2H3in4cRNTCuy6X11RhG4I
X-Received: by 2002:a05:6000:4b15:b0:48d:fbee:3dec with SMTP id ffacd0b85a97d-48dfbee3fa9mr5402185f8f.29.1792156909340;
        Fri, 16 Oct 2026 06:21:49 -0700 (PDT)
X-Received: by 2002:a05:6000:4b15:b0:48d:fbee:3dec with SMTP id ffacd0b85a97d-48dfbee3fa9mr5401985f8f.29.1792156907098;
        Fri, 16 Oct 2026 06:21:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfe4d2321sm5067555f8f.19.2026.10.16.06.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 06:21:46 -0700 (PDT)
Message-ID: <4c9d85b0-4dac-40f8-8541-d79bb3670f12@redhat.com>
Date: Fri, 16 Oct 2026 15:21:44 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 24/25] target/arm/qmp: implement
 query-cpu-props-info for KVM
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
 <20260921123249.1708067-25-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-25-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GXUUlJpy9QigS_5ACw9qINMwy0oMoNs2fvHvzKepy8U_1792156909
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Implement query-cpu-props-info for ARM64/KVM by creating and finalizing
> a temporary "host" CPU object and then walking its QOM properties.
>
> For numeric SYSREG_ properties, report the host-supported value ranges
> computed by kvm_arm_field_get_supported_values(). For boolean
> properties, report false as always supported and true as supported when
I am not sure false shall be always permitted. for instance iirc
aarch64=off requires a special KVM capability which is not tested here.

it is worth to emphasize those are the theoretical values that can be
easily guessed, this does not check cross feature consistency which can
only be tested when applying the values at KVM level I guess. So let's
do not pretend that this is fully reliable. I think the only way to
double check the chosen values is to do a full expansion for this models
featuring the new values
> the QOM property value is true.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/arm-qmp-cmds.c | 84 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
>
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index 0940285af1..ba488d5c01 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -84,6 +84,90 @@ static const char *cpu_model_advertised_features[] = {
>      NULL
>  };
>  
> +CpuPropertyInfoList *qmp_query_cpu_props_info(Error **errp)
> +{
> +    CpuPropertyInfoList *head = NULL;
> +    const ARMISARegisters *host_isar;
> +    ObjectPropertyIterator iter;
> +    ObjectProperty *prop;
> +    Error *err = NULL;
> +    ObjectClass *oc;
> +    Object *obj;
> +
> +    if (!kvm_enabled()) {
> +        error_setg(errp, "query-cpu-props-info requires KVM");
> +        return NULL;
> +    }
> +
> +    oc = cpu_class_by_name(TYPE_ARM_CPU, "host");
> +    if (!oc) {
> +        error_setg(errp, "The 'host' CPU type is not available");
> +        return NULL;
> +    }
> +
> +    host_isar = kvm_arm_get_host_isar();
> +
> +    /* Spin up a scratch "host" vCPU object and walk its QOM properties. */
> +    obj = object_new_with_class(oc);
> +    arm_cpu_finalize_features(ARM_CPU(obj), &err);
> +    if (err) {
> +        error_propagate(errp, err);
> +        object_unref(obj);
> +        return NULL;
> +    }
> +
> +    object_property_iter_init(&iter, obj);
> +    while ((prop = object_property_iter_next(&iter))) {
> +        CpuPropertyInfo *info;
> +
> +        if (g_str_has_prefix(prop->name, "SYSREG_")) {
> +            const ARM64SysRegField *field = prop->opaque;
> +            CpuPropertyValueRangeList *ranges = NULL;
> +            ArmFieldValueSet *vs = NULL;
> +
> +            info = g_new0(CpuPropertyInfo, 1);
> +            info->name = g_strdup(prop->name);
> +            info->type = CPU_PROPERTY_TYPE_NUMBER;
> +
> +            kvm_arm_field_get_supported_values(field, host_isar, &vs);
> +            for (size_t k = 0; k < vs->n_ranges; k++) {
> +                CpuPropertyValueRange *r = g_new0(CpuPropertyValueRange, 1);
> +                r->min = vs->ranges[k].min;
> +                r->max = vs->ranges[k].max;
> +                QAPI_LIST_PREPEND(ranges, r);
> +            }
> +            info->u.number.supported_values = ranges;
> +
> +            g_free(vs->ranges);
> +            g_free(vs);
> +        } else if (g_strv_contains(cpu_model_advertised_features, prop->name)) {
> +            bool cur = object_property_get_bool(obj, prop->name, &error_abort);
> +            boolList *values = NULL;
> +
> +            info = g_new0(CpuPropertyInfo, 1);
> +            info->name = g_strdup(prop->name);
> +            info->type = CPU_PROPERTY_TYPE_BOOLEAN;
> +
> +            /*
> +             * "off" is always supported. "on" is only supported when the
> +             * host already has the feature enabled.
> +             */
> +            QAPI_LIST_PREPEND(values, false);
> +            if (cur) {
> +                QAPI_LIST_PREPEND(values, true);
> +            }
> +            info->u.boolean.supported_values = values;
> +        } else {
> +            continue;
> +        }
> +
> +        QAPI_LIST_PREPEND(head, info);
> +    }
> +
> +    object_unref(obj);
> +    return head;
> +}
> +
>  CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>                                                       CpuModelInfo *model,
>                                                       Error **errp)
Thanks

Eric

