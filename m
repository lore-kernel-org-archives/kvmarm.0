Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8627F4756DF
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792157036; cv=none; b=duVHPWonsFEk0O0bHMl5XHpHnd7A4ojpHpUxDP2o4qgi/nS1fJRl2wKV2UjueQKl8S94fwqAFcSIrv6M9o/H6jSt5+E34gpkpmxDXILYnfpQTZrSCLA7X92778FtKta4jJv3CPJZizoXJNzKshzmCvwb+2sIeC2V/y5gvmGdpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792157036; c=relaxed/simple;
	bh=/kLJGs3U7wop6dIZt6JxkYvhTC1yyWSgyMy4FWp7OwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMwXiPL0yvjmz5mkbeIxEpvtwHO+vZnFg8hstDAu/CN6Fu7xFru6REKVoHTip75xPDfQUCYYHOc5jkvWN1Gg0XEDP3wlx34aDu6y0R1/LA8sZ/PpETJzshxQCyqfMjj28IsO4R08HCkfZY2dAQy2fpQzYTWl1OOdXR9XJg/iRQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PkVDstdO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkVDstdO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792157034;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SE9V4G/G/hYgWtus+HDIk8cYxijfE4z5gZCyCIy9Vw4=;
	b=PkVDstdOS301iYWVEYiaK60QDnr3IYgxRLrTxZgAnpX4DCJIaxLUn37A9Ay9HJ9lpoqCbW
	27opKFhFs0rxd1mkCmnDSE/7PfFEClzsMXr+74NIinBsW4LHOTd30jtvdBxcRCieagl34Z
	rBDoR7wPi1qDP79CcwTNEhuKUi1Cd48=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-eOmAnfLWMNyJKgR89wOPRw-1; Fri, 16 Oct 2026 13:23:53 +0000
X-MC-Unique: eOmAnfLWMNyJKgR89wOPRw-1
X-Mimecast-MFC-AGG-ID: eOmAnfLWMNyJKgR89wOPRw_1792157032
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1cf5e7012so4710745e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792157032; x=1792761832;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SE9V4G/G/hYgWtus+HDIk8cYxijfE4z5gZCyCIy9Vw4=;
        b=mOxZI5Xw8e+jnqitaa71PCazsrNAkcCjJDNaaD50s3OvDH6Nv6wJqBsSZGy3699ARb
         huNjoOmvYaSKsgVw326XjeMBFNJUSySBjrMygsf/RTVLer0CH5FsJ0RBEPls4JN+VgtT
         ySU9OlSXfn+0eqjMi6D5QzhVz0AQWJMrsUYWUeuplI+vCHi4pEBVPcdrJERx/AMN73sB
         1yJxpytfcD+ECcX9UMkRyo82hUZFyKnbke0bwvFJ/y+hLW9mnE3sbBng821H1UNEdI6F
         o6TOgkqyF8M+kUGIHgz2X2LJe9CFTaVkc/0nY5MhvzepD62yPFm3v8m09IQ+0Uqa5sh7
         1+Lw==
X-Forwarded-Encrypted: i=1; AKwUvBw2Qbtmy0hBiJtiUJFnCsZWg4pZu44PPngeQbkziNx0WmruFaP9+U1JlO4C4CtbHmEyxL7uT0A=@lists.linux.dev
X-Gm-Message-State: AFq9FYJnxUVuF+GZapZX25y0QNuX8xS5Fo67NFswa+Xw8Nn8qCijod9E
	V/pie2aCf5FjWUorRs9rxvXj/A8uu9WQe98SfsjrKQwcU9VcvYBKmuUo71iNXDjwL6AC4sFrgwv
	zSmiprnf8JJHacYBdvbIfDQp3+LUo69I+nRT8TXpsQ8XNmaBUc84d27XhWw==
X-Gm-Gg: AYBFou3zKM6CLUrJL3qDrBbChZxI8ExGOYVj2p9/wnpsnpGzieLkRDkCWIewHxuzwer
	9+CeJXFnOfm7a4PlPZ3sCLIlYPZ+Hd0yDJRWf0WCUJenrwP1XASxNkspXWdBAoA2RD6RWpIS8Sn
	oJn+wjMKxl3sANXvS0Ckz1MN9IlhqnQ/SURXTb3eDdS1WYQ8zHhEyCrJGcUYteczvJ+10vUuquQ
	ryJBrNzZdUu11v+gQkX1sH13S8zijGKGybCbvLhAaqj8zUvP9S2Jz8i2cYHDxzIOmAJlaCN+ju/
	q21CwCpzXfx0YUDiaNHgdGiW/Jdboyt4SaiAbrZUZU8lKOoG0dD7ro+524DghVp1imqlimCRDsl
	K8Mo82D+NwkBPx4DswbZ9J0ovxU3tVDHydxe1xdmSSIbJ7k5S
X-Received: by 2002:a05:600c:c113:b0:4a1:985b:83a9 with SMTP id 5b1f17b1804b1-4a1985b87f5mr280530415e9.4.1792157031832;
        Fri, 16 Oct 2026 06:23:51 -0700 (PDT)
X-Received: by 2002:a05:600c:c113:b0:4a1:985b:83a9 with SMTP id 5b1f17b1804b1-4a1985b87f5mr280529705e9.4.1792157031375;
        Fri, 16 Oct 2026 06:23:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9b8b5fsm164077725e9.9.2026.10.16.06.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 06:23:50 -0700 (PDT)
Message-ID: <1dcb8628-2b99-4af1-92f4-08dcae197e82@redhat.com>
Date: Fri, 16 Oct 2026 15:23:49 +0200
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
X-Mimecast-MFC-PROC-ID: YZDi3WIXDXfZzXNMM0jlYkoPC3TpBiMLECPaHsduB9w_1792157032
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> Implement query-cpu-props-info for ARM64/KVM by creating and finalizing
> a temporary "host" CPU object and then walking its QOM properties.
side note: the new qmp command shall be documented in
docs/system/arm/cpu-features.rst

Eric
>
> For numeric SYSREG_ properties, report the host-supported value ranges
> computed by kvm_arm_field_get_supported_values(). For boolean
> properties, report false as always supported and true as supported when
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

