Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7EC3E4115
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232401; cv=none; b=iIVoSwhheS1XeioJnIU3zJ1x5HP4ulXX0y9QudUZdjci6lAxMvgOkr3Eo17tqhN3+w+NYqpUDGe8zIL0oWmLvjQkdKRolo2aRjHRYadocc9oN9HcjrNqewC9aY8Qq0yNYP7+YlPT+dopsvOLpu6Deynm7buMKatvBq9/t2N6vuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232401; c=relaxed/simple;
	bh=QomAELx2DWxNjT075Xyd1zoRFnrn4PhQRgI8VDZwdSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g8ODioz0W0w2vincoOkF65ui4F4TjMx0S5rpgrVycc7K/WkNqJbdzjfRHollyMxVdtAz2McirXofBvrFsMo4x55D4lY2Z04k+pzmqMr4SuHNgh8LlU2HFUvIBbsGMqXgXw42hrlrEebvUVnWEUdEDP/TZh995CIrR3oZJjb80z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AHQvYQ+q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AHQvYQ+q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232398;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cl8MQ//gkhqzHpNXjgd51iETqP8SYiahro9/XV76stw=;
	b=AHQvYQ+qvtPlsHrdqOCf886R1gB10IPIz8ij2iIpEXCXmIXvUdDyT86zVZj6m0LipEzaPv
	cEyQcYzh+4UsX4G36Bi+Ua+C/Q+ofIi74QpweahVVwZb8NK5Ycc1/P9Y3gSvpgMfs3WGnD
	BJz0UAxl3bmghJnvbwd10QwmqM6m5Tw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-vXeXYg2eOTO1TETnJmDEuw-1; Thu, 24 Sep 2026 02:46:37 -0400
X-MC-Unique: vXeXYg2eOTO1TETnJmDEuw-1
X-Mimecast-MFC-AGG-ID: vXeXYg2eOTO1TETnJmDEuw_1790232396
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49cf4cc2125so7601865e9.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 23:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232396; x=1790837196;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cl8MQ//gkhqzHpNXjgd51iETqP8SYiahro9/XV76stw=;
        b=PvkNgUHZot6fD1jzqzGNkDFYVVUD9NityOHG8DU74BguHSu4wBAZD97OO4/5tksfr7
         6xYBb8xU/Y1AfwM1rwYGZl3eggmOY0Jle7x7mt99nS4vgTV5lUjkZS81KxlN/eeaa/d4
         Y821NwWqhtfCvYDj87RVz17sM5x4YByp272dOmpOtxvffND16rHwdKwyBdE4GUW1KtcE
         FPdBYwsqUh84osIoPXeIsaSXjRSJS2DwnEVPJ2jpCWMli/lBGjvP4rLBmMNa6F5ZZ+zS
         w2zjoqb3gS94aLqsWUaoX/jNG1zlkVzwo6Prs1ckXClKXt2ydzfS2nTl3WbK4mbXVT5S
         jpeg==
X-Forwarded-Encrypted: i=1; AKwUvBz1P68C7eaLX/VJk2FDA/5rJmpyVVJdvOVUX7UO8t84fznBa+cyhbPaDKrBwVKKYIy6RYcl3zM=@lists.linux.dev
X-Gm-Message-State: AFuF++niE+YigotbgqPOB/TzUU/bplNjOIN8bXMTCBnI8DOo3rT3B/sF
	sbxws4cxvUgtnq9kNU+p+dES31o8wudY9FxRF4Hfh/eoGuO01ww82ai4OFN4z/PhykNfnTChx/g
	h45DtvNaIQiFcU8CDXazzksIKKiQOT9b2UAqHSlW9WPY/ss0p6bb+vBA0tA==
X-Gm-Gg: AYBFou2zNxR1HR167Ox6DE+AuVrnzs3CCn0VHSrIJ4xQL9zbblV7+8a5YYV2XJHnSsV
	xc2zf37aBPvSd4qMHc4MHJjEfW8eSSF4kOKSWD/VYUpyoK/7RMjDPsSHLyGH2VbS8i0pe9a1mZO
	Agjy041Xwqd65W3iGwE2RaRgo3rWB6ryJvHOUUYv/6l1+egkNlVRWHa72qd3g/vXcDCFkmbwbml
	zU17n1yNRvy3AodsZJwrIYXDlmiKSYwymOXzqf/4N1b/Ghh0+RFEVEerm3NwXYhWCRyhUr143Pd
	hT5AlgK2GZIhkvu0nmKUK5bZKDeSHdeBegnWn1nRZqzPJaJ6VJn9bO2dncA+aiYGB0jHp7ln1AM
	Wp6ZbmAFkoKUmxgmLZnT7TlC4gIAYppUitzA/BXhxh0kl58tQ
X-Received: by 2002:a05:600c:8719:b0:49e:6c11:c4fc with SMTP id 5b1f17b1804b1-49fe66c8a5amr23977975e9.7.1790232395812;
        Wed, 23 Sep 2026 23:46:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8719:b0:49e:6c11:c4fc with SMTP id 5b1f17b1804b1-49fe66c8a5amr23977555e9.7.1790232395400;
        Wed, 23 Sep 2026 23:46:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c4b51bsm95011855e9.4.2026.09.23.23.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 23:46:34 -0700 (PDT)
Message-ID: <06ba3ba8-409e-407f-8148-087f15edadbe@redhat.com>
Date: Thu, 24 Sep 2026 08:46:32 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 02/25] target/arm: expose all non-res ID reg fields
 as properties
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
 <20260921123249.1708067-3-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-3-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E1KIEzhrPYVU16VYMKPywpxO7TK6ZBVSRn7U8kVr-C0_1790232396
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> Upcoming named CPU model layer will require exposing all the ID register
> fields as properties.
>
> Furthermore, this exposes the host values of all ID register fields
> to the management stack, which can use them to infer migration
> compatibility constraints between different hosts.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  docs/system/arm/cpu-features.rst | 34 +++++++--------
>  target/arm/cpu64.c               |  2 +-
>  target/arm/kvm.c                 | 71 +++++++-------------------------
>  target/arm/trace-events          |  2 -
>  4 files changed, 31 insertions(+), 78 deletions(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 3a07a87bc3..62bb2bd999 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -34,17 +34,15 @@ running guests in AArch32.
>  CPU features that are inherently specific to KVM are
>  prefixed with "kvm-" and are described in "KVM VCPU Features".
>  
> -2. Additionally, the ``host`` CPU model on KVM allows to configure optional
> -CPU features via the corresponding ID registers. The host kernel allows
> -to write a subset of ID register fields. The host model exposes
> -properties for each writable ID register field. Those options are named
> -SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
> -ARM Architecture Reference Manual. Their availability depend on the host
> -capability to let the userspace write those fields. Values set with those
> -properties override the initial values retrieved from the host. They are
> -written back to KVM and the eventual value applied by KVM depends on whether
> -the value is sanitized or not by the host kernel. Then those field values
> -are likely to be overriden again by legacy CPU options which apply at the end.
> +2. Additionally, the ``host`` CPU model on KVM allows configuring optional
> +CPU features through the corresponding ID registers. The host model exposes
> +properties for every non-reserved ID register field known to QEMU. Those
> +properties are named SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those
> +used in the Arm Architecture Reference Manual. Values set with those
> +properties override the initial values retrieved from the host. Whether a
> +value that differs from the host value can be applied depends on KVM support
> +and any field-specific handling in QEMU. Legacy CPU options applied later may
> +override those field values.
>  
>  CPU Feature Probing
>  ===================
> @@ -534,12 +532,10 @@ Note that this is currently only supported under KVM, and with the
>  Querying available ID register fields
>  -------------------------------------
>  
> -QEMU will create properties for all ID register fields that are
> -reported as being writable by the kernel, and that are known to the
> -QEMU instance. Therefore, the same QEMU binary may expose different
> -properties when run under a different kernel.
> +QEMU creates properties for all non-reserved ID register fields known to
> +the QEMU instance.
>  
> -To find out all available writable ID register fields, use the
> +To find out all available ID register fields, use the
>  ``query-cpu-model-expansion`` QMP command::
>  
>    (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
> @@ -554,8 +550,10 @@ To find out all available writable ID register fields, use the
>     "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
>     }}}}
>  
> -If a certain field in an ID register does not show up in this list, it
> -is not writable with the specific host kernel.
> +The presence of a property does not imply that every value is supported.
> +Non-writable fields must retain their host value, while writable fields are
> +limited to the values supported by KVM. A configuration requesting an
> +unsupported value is rejected.
>  
>  A note on compatibility
>  -----------------------
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index e04062e848..3d522bf20d 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -809,7 +809,7 @@ void aarch64_host_initfn(Object *obj)
>      kvm_arm_set_cpu_features_from_host(cpu);
>      aarch64_add_sve_properties(obj);
>  
> -    /* generate SYSREG properties according to writable masks */
> +    /* generate SYSREG properties */
>      kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
>  
>  #elif defined(CONFIG_HVF)
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 8a823d0324..2f6c090e43 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -365,19 +365,6 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
>      return err;
>  }
>  
> -static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
> -{
> -    for (int f = 0; f < reg->fields_count; f++) {
> -        struct ARM64SysRegField *field = &reg->fields[f];
> -        int upper = field->shift + field->length - 1;
> -
> -        if (i >= field->shift && i <= upper) {
> -            return field;
> -        }
> -    }
> -    return NULL;
> -}
> -
>  bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
>                                    void *opaque, Error **errp)
>  {
> @@ -493,69 +480,39 @@ static void get_sysreg_prop(Object *obj, Visitor *v,
>      trace_get_sysreg_prop(name, value);
>  }
>  
> -/*
> - * decode_idreg_writemap: Generate props for writable fields
> - *
> - * @obj: CPU object
> - * @reg: description of the sysreg
> - */
> -static int
> -decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
> +static void
> +add_idreg_field_properties(Object *obj, ARM64SysReg *reg)
>  {
> -    uint64_t map = reg->writable_mask;
> -    int i = ctz64(map);
>      int nb_sysreg_props = 0;
>  
> -    while (map) {
> -        ARM64SysRegField *field = get_field(i, reg);
> -        int lower, upper;
> -        char *prop_name;
> -        uint64_t field_mask;
> -
> -        if (!field) {
> -            warn_report("%s bit %d of %s is writable but no named field "
> -                        "in target/arm/cpu-idregs.h.inc",
> -                        __func__, i, reg->name);
> -            map =  map & ~BIT_ULL(i);
> -            i = ctz64(map);
> -            continue;
> -        }
> -        lower = field->shift;
> -        upper = field->shift + field->length - 1;
> -
> -        /* Sanity check the field is not a reserved field */
> -        if (strstr(field->name, "RES0") || strstr(field->name, "RES1") ||
> -            strstr(field->name, "RAZ")) {
> -            trace_unexpected_writable_reserved_field(reg->name, field->name,
> -                                                     lower, upper);
> +    for (int i = 0; i < reg->fields_count; i++) {
> +        ARM64SysRegField *field = &reg->fields[i];
I agree this implementation is simpler than mine scanning the writable
bitmask. I will move to that. I think I will add an other operating mode
that checks the writable_mask too. That way the function may be able to
generate props only for writable fields (including some consistency
checks), or for non writable fields

Thanks

Eric
> +
> +        /* skip reserved fields */
> +        if (g_str_equal(field->name, "RES0") ||
> +            g_str_equal(field->name, "RES1") ||
> +            g_str_equal(field->name, "RAZ")) {
>              continue;
>          }
> -        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
> -        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
> +
> +        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
> +                                          field->name);
>          object_property_add(obj, prop_name, "uint64",
>                              get_sysreg_prop, set_sysreg_prop, NULL, field);
>          g_free(prop_name);
>          nb_sysreg_props++;
> -
> -        field_mask = MAKE_64BIT_MASK(lower, field->length);
> -        map = map & ~field_mask;
> -        i = ctz64(map);
>      }
> +
>      trace_nb_sysreg_props(reg->name, nb_sysreg_props);
> -    return 0;
>  }
>  
> -/* analyze the writable mask and generate properties for writable fields */
>  void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
>  {
>      Object *obj = OBJECT(cpu);
>  
>      for (int i = 0; i < NUM_ID_IDX; i++) {
>          ARM64SysReg *sysregdesc = &regs[i];
> -
> -        if (sysregdesc->writable_mask) {
> -            decode_idreg_writemap(obj, sysregdesc);
> -        }
> +        add_idreg_field_properties(obj, sysregdesc);
>      }
>  }
>  
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 71a2f5770c..7696a8ed40 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -15,11 +15,9 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>  get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>  kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
> -decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
>  get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
>  set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
>  nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
> -unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
>  kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
>  
>  # cpu.c

