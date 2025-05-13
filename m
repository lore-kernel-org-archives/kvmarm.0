Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C751C07C3
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747147680; cv=none; b=Ncl4oVFvKZCVo29d9xdYCeVPnZOTs528qseCGIrH+kOf+D3bD4odP2UIwDpjpVyCpMa7W/LeYjqO1n5nIzhTnFY489z87Wh2oKM0RIf4Jb2A9iY4dp88KPdr+uDI02oVa/FRJRNZxr8EDOGzWX/6WX5ui3aN45zvxrnQfAZkaak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747147680; c=relaxed/simple;
	bh=jaaqkxXgwFssrMhn4+npuHderrI4ShJC09x2ABQ9Wt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bc63pdU4nuvfN6riNoK/nO7xpLtkeDSSe+qobURO16+z/rWmN5oc93c6YYmya5z40EeFEDtCN2n77hzokJOw2S1YyOWzmBnoRc/br1+ZnTxC9Aun50mSP03HMfEg8XntYFB4KMBjFveFOEBjfz9MCB8FyzNw13n8nM35mHif9lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaMVzLG7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaMVzLG7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747147676;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KO5SYIXLZCeX5S3WIj7POPk8p8ZK2T5x7U07pEAcVtE=;
	b=PaMVzLG7YmBYW2NoTtVT3gMHXk9FiaLTwmjxTHUMG4xfU2QAlU6FuzVgQCVFoRjpz7Yukm
	gy6zjN6FzHXnoJRKcaxgs7vBo0lR1kIqH0QgCHPaj+i3vyNmYUsCeLh+tqfN3gcJZKkyzd
	Ggr9AgnEk+9F0L56orimetKLxnHV664=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-B7Hi2ZCrPV2bNYE26gBdyQ-1; Tue, 13 May 2025 10:47:55 -0400
X-MC-Unique: B7Hi2ZCrPV2bNYE26gBdyQ-1
X-Mimecast-MFC-AGG-ID: B7Hi2ZCrPV2bNYE26gBdyQ_1747147674
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442dc702850so21258785e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 07:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747147674; x=1747752474;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KO5SYIXLZCeX5S3WIj7POPk8p8ZK2T5x7U07pEAcVtE=;
        b=kSYe+HE90mv6OU2Ey6nOy8sfKZyTKAsFcUPufxVE9/g8o7RJv9p4eD6yAb2iq9Glry
         hHO/KfKwr0P0nR+loxXb9JChZmXymp6sRo9b+N8WATDois/JkhoUd4O956ycNN0FF3l3
         OAxWhlF3ihGKFkFMMAZcRutKiohjmoXqwxCZLz+jF63i7/tgDjOm1+aSh5URa39nHCG6
         tsrTw9/7DWh9GXd9LQfIEMt144n5qWST4lYTZVnem1RR60jW68T1FgQvLL7bKiYGiw/0
         NvbHpakosavvGJYggp1NBBwlbv2/UEsEjB5NaO4kAGhySFVP8FfjIBXORit+QKYdP3yH
         3d3A==
X-Forwarded-Encrypted: i=1; AJvYcCUBexJinPcXbaFhjb65COdD8ySIOAKb1PzAKpxXN+dncbzkWm37PTqMKB/gTduHccLlyb4PUBk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwX16GkeDPXcVNlPunTHP+ienqMvSFV79/5vsJ8fBlVeS2d8hmX
	2vRJAE73Crv8mPjNxbe1hXc4s89NFYD0y5exIeEQUMm5alFvLv9NRMFLTDpX1Hboy83S9ZCqMeB
	ScutnaIaBsn6+ZHPG5MJlS8DzzFucw3JgXK+5wCLDAbbdZGM77aDE7A==
X-Gm-Gg: ASbGncvYIwMx57qMTDFw6/3t6SYS5/MI3ugUX/LQ5p/9i1JeMFdOBALROm/xa5DVi2N
	9y8SaB5DKN3Jn8YTuALyLJAxdE/qGV7Gl98jQyAeetUSu2aw28YKKK1mSEq9epWr33Z62duOYPi
	ye87QPuZqQHO2RZjjcRvbKkq3VXhvzVJ1p9Gs9hyRyEkdf2U9IU+6o5KC2tbJeI7xHoZzLZSug3
	gmAqMliyy1QHqmQGhzwrTwEpkFpggIFB0Y2YFROsQlOPRtH70QAbzyu7Gy7is/w5PJhscGXs5Kp
	zTwttCjZ6QtJorm4ARSZ4ISTIG9Q2IAjX4550upAaNmoEgr0woazQtXy9oM=
X-Received: by 2002:a05:600c:3d0c:b0:43d:2230:300f with SMTP id 5b1f17b1804b1-442d6c31f3fmr173951105e9.0.1747147674348;
        Tue, 13 May 2025 07:47:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9i3LCubWcoWCnaAyoT+dRfk4oBEpL2SCgGb3oFyN1spbQp21KOH+bltdu8thC5kvb3d5NQA==
X-Received: by 2002:a05:600c:3d0c:b0:43d:2230:300f with SMTP id 5b1f17b1804b1-442d6c31f3fmr173950675e9.0.1747147673885;
        Tue, 13 May 2025 07:47:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442e9c9a193sm53493925e9.21.2025.05.13.07.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 07:47:53 -0700 (PDT)
Message-ID: <7a9279ee-99d3-4871-b9f7-5d5529864f1e@redhat.com>
Date: Tue, 13 May 2025 16:47:51 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 08/10] arm/cpu: more customization for the kvm host cpu
 model
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-9-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250414163849.321857-9-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9-6uLaxd13ClJpVHpqKvovdTLKnwWdPJ-unkOmjM0ng_1747147674
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 4/14/25 6:38 PM, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> If the interface for writable ID registers is available, expose uint64
> SYSREG properties for writable ID reg fields exposed by the host
> kernel. Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
I remember we had a comment in the early RFC that suggested to remove
the "SYSREG_" prefix. I introduced to ease the qmp introspection if I
remember correctly. Could we manage without it?
> being those used  in linux arch/arm64/tools/sysreg. This done by
s/used in/used in
> matching the writable fields retrieved from the host kernel against the
> generated description of sysregs.
>
> An example of invocation is:
> -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> which sets DP field of ID_AA64ISAR0_EL1 to 0.
>
> [CH: add properties to the host model instead of introducing a new
> "custom" model]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
> ---
>
> Interaction with the existing cpu properties is still a bit unclear --
> at the moment, the different configurations can overwrite each other.
> ---
>  target/arm/cpu.c        |  12 ++++
>  target/arm/cpu64.c      |  22 ++++++-
>  target/arm/kvm.c        | 135 ++++++++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h    |  10 +++
>  target/arm/trace-events |   4 ++
>  5 files changed, 182 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index a3de5ee2b19c..c03f38ad5cfe 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1991,6 +1991,18 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>          return;
>      }
>  
> +    /*
> +     * If we failed to retrieve the set of writable ID registers for the "host"
> +     * CPU model, report it here. No error if the interface for discovering
> +     * writable ID registers is not available.
> +     * In case we did get the set of writable ID registers, set the features to
> +     * the configured values here and perform some sanity checks.
> +     */
> +    if (cpu->writable_id_regs == WRITABLE_ID_REGS_FAILED) {
> +        error_setg(errp, "Failed to discover writable id registers");
> +        return;
> +    }
> +
>      if (!cpu->gt_cntfrq_hz) {
>          /*
>           * 0 means "the board didn't set a value, use the default". (We also
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 60a709502697..c595dbb532c1 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -757,11 +757,31 @@ static void aarch64_host_initfn(Object *obj)
>  {
>  #if defined(CONFIG_KVM)
>      ARMCPU *cpu = ARM_CPU(obj);
> -    kvm_arm_set_cpu_features_from_host(cpu, false);
> +    bool expose_id_regs = true;
> +    int ret;
> +
> +    cpu->writable_map = g_malloc(sizeof(IdRegMap));
> +
> +    /* discover via KVM_ARM_GET_REG_WRITABLE_MASKS */
> +    ret = kvm_arm_get_writable_id_regs(cpu, cpu->writable_map);
> +    if (ret == -ENOSYS) {
> +        /* legacy: continue without writable id regs */
> +        expose_id_regs = false;
> +    } else if (ret) {
> +        /* function will have marked an error */
> +        return;
> +    }
> +
> +    kvm_arm_set_cpu_features_from_host(cpu, expose_id_regs);
>      if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
>          aarch64_add_sve_properties(obj);
>          aarch64_add_pauth_properties(obj);
>      }
> +    if (expose_id_regs) {
> +        /* generate SYSREG properties according to writable masks */
> +        kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
> +    }
> +
>  #elif defined(CONFIG_HVF)
>      ARMCPU *cpu = ARM_CPU(obj);
>      hvf_arm_set_cpu_features_from_host(cpu);
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 9e4cca1705c8..63e27906cc42 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -335,6 +335,141 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
>      return err;
>  }
>  
> +static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
> +{
> +    GList *l;
> +
> +    for (l = reg->fields; l; l = l->next) {
> +        ARM64SysRegField *field = (ARM64SysRegField *)l->data;
> +
> +        if (i >= field->lower && i <= field->upper) {
> +            return field;
> +        }
> +    }
> +    return NULL;
> +}
> +
> +static void set_sysreg_prop(Object *obj, Visitor *v,
> +                            const char *name, void *opaque,
> +                            Error **errp)
> +{
> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    uint64_t *idregs = cpu->isar.idregs;
> +    uint64_t old, value, mask;
> +    int lower = field->lower;
> +    int upper = field->upper;
> +    int length = upper - lower + 1;
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
> +    int lower = field->lower;
> +    int upper = field->upper;
> +    int length = upper - lower + 1;
> +    int index = field->index;
> +
> +    mask = MAKE_64BIT_MASK(lower, length);
> +    value = (idregs[index] & mask) >> lower;
> +    visit_type_uint64(v, name, &value, errp);
> +    trace_get_sysreg_prop(name, value);
> +}
> +
> +/*
> + * decode_idreg_writemap: Generate props for writable fields
> + *
> + * @obj: CPU object
> + * @index: index of the sysreg
> + * @map: writable map for the sysreg
> + * @reg: description of the sysreg
> + */
> +static int
> +decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
> +{
> +    int i = ctz64(map);
> +    int nb_sysreg_props = 0;
> +
> +    while (map) {
> +
spurious empty line
> +        ARM64SysRegField *field = get_field(i, reg);
> +        int lower, upper;
> +        uint64_t mask;
> +        char *prop_name;
> +
> +        if (!field) {
> +            /* the field cannot be matched to any know id named field */
> +            warn_report("%s bit %d of %s is writable but cannot be matched",
> +                        __func__, i, reg->name);
> +            warn_report("%s is cpu-sysreg-properties.c up to date?", __func__);
> +            map =  map & ~BIT_ULL(i);
> +            i = ctz64(map);
> +            continue;
> +        }
> +        lower = field->lower;
> +        upper = field->upper;
> +        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
> +        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
> +        object_property_add(obj, prop_name, "uint64",
> +                            get_sysreg_prop, set_sysreg_prop, NULL, field);
> +        nb_sysreg_props++;
> +
> +        mask = MAKE_64BIT_MASK(lower, upper - lower + 1);
> +        map = map & ~mask;
> +        i = ctz64(map);
> +    }
> +    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
> +    return 0;
> +}
> +
> +/* analyze the writable mask and generate properties for writable fields */
> +void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
> +{
> +    int i, idx;
> +    IdRegMap *map = cpu->writable_map;
> +    Object *obj = OBJECT(cpu);
> +
> +    for (i = 0; i < NR_ID_REGS; i++) {
> +        uint64_t mask = map->regs[i];
> +
> +        if (mask) {
> +            /* reg @i has some writable fields, decode them */
> +            idx = kvm_idx_to_idregs_idx(i);
> +            if (idx < 0) {
can it happen? I understand it asserts?
> +                /* no matching reg? */
> +                warn_report("%s: reg %d writable, but not in list of idregs?",
> +                            __func__, i);
> +            } else {
> +                decode_idreg_writemap(obj, i, mask, &regs[idx]);
> +            }
> +        }
> +    }
> +}
> +
>  static bool
>  kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf,
>                                bool exhaustive)
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 90ba4f7d8987..ba5de45f868c 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -157,6 +157,16 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool exhaustive);
>   */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>  
> +typedef struct ARM64SysReg ARM64SysReg;
> +/**
> + * kvm_arm_expose_idreg_properties:
> + * @cpu: The CPU object to generate the properties for
> + * @reg: registers from the host
> + *
> + * analyze the writable mask and generate properties for writable fields
> + */
> +void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs);
> +
>  /**
>   * kvm_arm_steal_time_finalize:
>   * @cpu: ARMCPU for which to finalize kvm-steal-time
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 955149ee1ac4..8d2a234d5272 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -15,3 +15,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>  kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
> +decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
> +get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
> +set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
> +nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
Eric

