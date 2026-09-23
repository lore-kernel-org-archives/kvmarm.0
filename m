Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E1A51614C
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181457; cv=none; b=j5O7xnmpSOXLuPIrln7Jz+0M5xlF3wscl2qZs0JgZ4boGWWIoS9ngLmOyc7MiGfSVFfihBhJyS2ghuKD/L+Ry+VrLKXCbmqQAXj3owH/znNbpCGN+URtYQ7VcT4fJAKQr314Eq/Jd+kHHLColy4ptpLya7tS1oz9KA0IioVIqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181457; c=relaxed/simple;
	bh=AA2Dp1/VDHifBisJMQKzNoHYTwuTLAJVgLRfIWwsv84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZf+dzGudFZCtxfhW16qa0bWFch99wrqScr70by0JgOrcqUKAe7lz7JQSwx1fEJWfX2n3tqlYH/Htsr9+UZLi0ZS6MLQRgzKMTcVK85ukjGnNVKeoxzfMUKtbWcVXg2O43bwFnN8dd0Y+GeuSofT+eiOdF+3IovYmpgGE0BXSgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/92x5cA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/92x5cA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790181449;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQPxre5nfjVyJIkyz9ju4nrdHW/OB8SsTX3UAIiJ8qc=;
	b=M/92x5cApSktIamRO5xhVTMaKtfljvQYv3emKuEnXzuxkrCBp+VqJ9l72KYwh96IgCY58p
	Fg2yd2c/CD+eZnGNzaT06keeNzH/V3K1oBD5uZCPvtCP3hu3O5rhWsbot8zUXL5HaFV+eE
	7l1pI9eeDk9+W5w/I9HOEGTNzjyIypY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-uw861mLvPh2FdGXFpZNEyw-1; Wed, 23 Sep 2026 12:37:28 -0400
X-MC-Unique: uw861mLvPh2FdGXFpZNEyw-1
X-Mimecast-MFC-AGG-ID: uw861mLvPh2FdGXFpZNEyw_1790181447
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49cdc4080ddso276025e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 09:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790181447; x=1790786247;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NQPxre5nfjVyJIkyz9ju4nrdHW/OB8SsTX3UAIiJ8qc=;
        b=vCTw8tgf6bVSTRku6QKlynoJ5SXqt2kNn7i7zaK0cHSRsdTnyspr2Ou8AQ9u3rAefb
         l0E3peuRc07HR4XirYb+O+yqEAqGNglg+uIzqAIxgivtKPql+wxamtJ0E0RC8A2Xb6rs
         zjUV9/vIvi7LH/Xvvz7g7UrsF65n48YpCBoaaXeYzPfJ1L5iaQntXjoPddPlr2FYvB4o
         DG+vdGFbbC8E4PPDDTND+GM9xz8z15iILFK8cMJpo9yoiVq0N7ovER87aA8qnJ8Uzazh
         4WXJyWtf4EVg3gzJoi8FwMnZlq3dUkuqZi3e2pbLQyZ+gYkdRCEjL0E9uYnzZd3XHeXK
         pTpQ==
X-Forwarded-Encrypted: i=1; AKwUvBy+7PjM8heLWihCZr6rXgyFGE9k3TiV6iTXphw/oLa/Af2yaY10xmmOEsdGBczgxhPiZaGDxSc=@lists.linux.dev
X-Gm-Message-State: AFuF++mQmJmlY6J+AEPfRcFc0OCXhHHggs/t0RKjaCHH3/oqCOuBEH69
	JYW55ww6fcbg4fMaMJOygZxLhbX0VSXc23CVzMdNO0lkYsfO80x8x2l4K8bQu8ICeB87rnr/Pcl
	/Anmmz40ESGWTwt9Z5kRVhxt8MkQEQBLhiMW+GzMtRFprEe3bI+pqO7br8Q==
X-Gm-Gg: AYBFou2i0f3EgNZDF+MmSuFJ1m9Z+b22QwDcly/xlj0PNbuD7sgHeeaZ8I5lz35sujE
	2kG/1iRTTqiXyyTysnI0KikfD8b+sVYE/jbakRfMwp4bMdJ+DyRUff3yKXTxZegztlpLwtjDI3l
	4Aa8e1lEsWn6umb+JW3L7BLKaQd0Ice0qD+NkxVEECicdh1uupT70tapPwRxTBKW4Wr4SfjhquD
	OHTLowLVLxc8pkwaCAu3BajSNlMNEQMJ0aSsoIR1B2NJ1C3LldKHk9sxPXvs+veTi7IW2g80LE5
	YJ3XlmAYKWzXMBBQVNqdQlS6N6pLqCP0pTHEkj9W+M9RoIAzbjiG3HJUKlKrYgB7Zv/DhoRev2t
	NotQnSNPPtt2hqwPp0rktAs0lNitVEUz1O2i4z/dnzslLfaQ8
X-Received: by 2002:a05:600c:1910:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-49fde374f6cmr52414325e9.8.1790181447155;
        Wed, 23 Sep 2026 09:37:27 -0700 (PDT)
X-Received: by 2002:a05:600c:1910:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-49fde374f6cmr52413865e9.8.1790181446641;
        Wed, 23 Sep 2026 09:37:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18093csm101614415e9.3.2026.09.23.09.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 09:37:26 -0700 (PDT)
Message-ID: <3cd4f5c9-dc40-47ae-b008-c5dc2c60e0ec@redhat.com>
Date: Wed, 23 Sep 2026 18:37:24 +0200
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
X-Mimecast-MFC-PROC-ID: _AUXRXkRGXcNUPLFgrbItB5aCqbBN6KvMpkfmfXTTfs_1790181447
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
Rewording/corrections not related to the actual functional change in
this patch should be suggested on the prerequisite series and applied
there instead.

Besides after our discussions I understand you need to expose all ID reg
named fields for *named* vcpu models. This allows to relax the value
required by this named vcpu model to the host one. but to me this shall
only apply to derived named cpu models and not to the base host model.
Iif you expose non writable props on the host model, this latter won't
be able to apply any other value than the current one anyway. So it just
brings noise for the end user.
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
To me exposing non writable fields shall only happen for derived named
models.
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
Same here. If changes are not related to the functional change, the
right way to converge is to comment on the prerequisite series.
As I understand those changes are unrelated and can easily be retrofitted

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
why those removals
>  kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
>  
>  # cpu.c

Eric

