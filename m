Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8A4AB3DB
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 11:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596164; cv=none; b=qDe3HanktVEeZ9rY7sk/VgP1yzwk4ihbG5iGuhzMxiO8yGBrPPDjdZWBZlNltYNRixTgb+BMeR9slR8pYKPBrInUmwyvWgkx1/iB4YHZYkKrS1XluuGzyUv9ePm6fPwFAX8ojjal16vCne0/pHAvUEyOaU/K24pB4vgnylOqBfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596164; c=relaxed/simple;
	bh=a0rk1RXswnAcpbFUdohAzcTKLoXBYTuNE/WQnln9tV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAgeCzTfia+fKnyGb62PCGXhrdQdJIsur9eqqMAS5DeuT2X4K6Bzm6/AtbFfgi5bDADmGov7pdsu7dnwr6TUmPZAG/uGcQRdmVGEIV7szckWLVkhT1nWzw+IbriMlVyGXYsxP+FIQ3zkldQPLSsWr16UjXmWqTrHgsH47CriuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dtu6CUpc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dtu6CUpc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790596161;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWF37bj0FfdWjtg4WnDCuH4W9hlkjUX94zQ5tlDaGAY=;
	b=Dtu6CUpchg/1AicsDw4RdQwt2JxUQbXNRS+KulZ0H0FaI6YxNu/wF6tFFIPm/cIyr/axcC
	sB1Stn/I+RJyYebhUSKcUZi+TR/yPMZJj/iA/bFE5PkHwWkE+4pwKHDSn8/5x+znACTLV+
	Wd4pZH9rMqiikEuyFEKjEgj9I94dQl8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-6r9gv4yoPuuxzm76d2ul8A-1; Mon, 28 Sep 2026 07:49:18 -0400
X-MC-Unique: 6r9gv4yoPuuxzm76d2ul8A-1
X-Mimecast-MFC-AGG-ID: 6r9gv4yoPuuxzm76d2ul8A_1790596158
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4887b0303b0so1627418f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 04:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790596157; x=1791200957;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zWF37bj0FfdWjtg4WnDCuH4W9hlkjUX94zQ5tlDaGAY=;
        b=d0iEipYGkhZShf6YB4HSHmPlAhAm342FL7dkCuVjC7ZA+nGDHORdr/X1YQhCU4ppsS
         +GMpSSH6IF4e8WD7yLP4WF0s5wmYotb+qJNdlK3Q+mckea42lSo9PAt5qOw/ixI42Phl
         1sOIdpr2TUPzZtXCitxnLabkSdBDlua4G56VNVja3Z88Mdy+O2oTdynh90dmMDnDfPKa
         QAFToLqr0CABFTnYI1IhJFBvuOcu0KPowxhj0jfmye+mP1FOvOxXv4V88uqfSxffpvII
         A+gfqzq6VVo6BQJgqtMUmPU1ei1XdPTbnPlmxPoAWVx9JVZgTfBaHOUbdk7Ll12wZfq/
         1V6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxA9LG4qDlKqdcrxYHCuziVck/9mTKZVYFja+N+RK/DGcr2l0c9AwIZ8sh4xAl7TW6QOxrcV2M=@lists.linux.dev
X-Gm-Message-State: AFq9FYLU0dSUPUjTeMyoVgDzCPRtR36UNOAtoiZ7tbfRMecU0UFDi5Wk
	2803BmsI3opZVJ0fi/fFilqr4lQS/sfPFmv8hrIVDRuI3Lg5mK98tAvzZwHZU41HzN0eJtUzQHv
	mq5NpdLGMrs47cN7Ohc5WsKszyJcLmEECawnCNCPyTYxwlTvMfzLdNqXN1w==
X-Gm-Gg: AYBFou2cff8xsIFu9ExvB4qRtBH8GXky3SGnJ2yxpR9MDBgXzc8sxuFVjQBLHjpRmUe
	bH08FXEKDN5j1trQppavFUmyMqnSiuCmWrkhXyvDOrHHx8WPFCDwhJiYkJtdDmLgxhXeGg8UfpH
	0bTSdxZVWDhdPml1hdC1blR5DXgho/ajiomwOjw71hJSlImkLPciSGky9RI5UR2Br8to0pe3Xfe
	ebTR6GjCc7jZC5nhLQjfjaujTFnDYjebYdipUjuLa5SkGdTlDlWWYnq9EC12gxXzbLNcreKbLeb
	aUCAxxK0wUjY6hKhKmS5OM9COgXhIjfOBJxLkR6gyHtdh5TVBk4QKvWyc1wFgyVzLVvt0wmu/ur
	QnllR2twt9Vkt4ivp0AClGuJz0py2vvQQLD3AHSit534FaaEp
X-Received: by 2002:a5d:59c5:0:b0:487:faa:b1e0 with SMTP id ffacd0b85a97d-4887170dd86mr25423377f8f.12.1790596157528;
        Mon, 28 Sep 2026 04:49:17 -0700 (PDT)
X-Received: by 2002:a5d:59c5:0:b0:487:faa:b1e0 with SMTP id ffacd0b85a97d-4887170dd86mr25423321f8f.12.1790596157054;
        Mon, 28 Sep 2026 04:49:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-489bd7b1df0sm6535553f8f.31.2026.09.28.04.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 04:49:16 -0700 (PDT)
Message-ID: <810074ff-60af-4b36-9a7b-9b5ce4117eb4@redhat.com>
Date: Mon, 28 Sep 2026 13:49:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 14/26] target/arm/kvm: Implement SYSREG property setter
 and getter
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-15-eric.auger@redhat.com>
 <ABBAB5A1-BD41-4D5C-9D09-DD1D7C50D0FB@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ABBAB5A1-BD41-4D5C-9D09-DD1D7C50D0FB@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nuzw-NoKWcdRIdlQUEv-tLC7rwy-BgOH2dlj9KsdO8I_1790596158
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/28/26 11:28 AM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> When the setter is called, the final vcpu is not created yet.
>> Applying the override on vcpu.isar initialized with the max scratch
>> vcpu would not be correct because the final vcpu may have some features
>> turned off (for instance virtualization) while the scratch vcpu
>> features it. So we need to postpone the actual override until the
>> final vcpu has been initialized.
>>
>> In terms of input value validation what can be done now is checking
>> against field length and arch enum value if any.
>>
>> If this succeeds, the field value is added in the hash table to be
>> written later on once the final vcpu has been created
>>
>> With regards to the getter, if the sysreg prop was set, we return the
>> set value, otherwise, we return the value in cpu->isar.idregs[].
>>
> Hi Eric,
>
> Please mention that the cpreg override happens in later commits.
sure
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com <mailto:khushit.shah@nutanix.com>>
May I ask why?

Besides we need to be cautious about the fact that people who has signed
off the patches cannot review them ...
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> target/arm/cpu.h |  2 ++
>> target/arm/cpu.c |  5 ++--
>> target/arm/kvm.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++--
>> 3 files changed, 68 insertions(+), 4 deletions(-)
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index e3f931dba2..9bbd42dd2b 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -952,6 +952,8 @@ struct ArchCPU {
>>     uint64_t *cpreg_vmstate_values;
>>     int32_t cpreg_vmstate_array_len;
>>
>> +    GHashTable *sysreg_props;
>> +
>>     DynamicGDBFeatureInfo dyn_sysreg_feature;
>>     DynamicGDBFeatureInfo dyn_svereg_feature;
>>     DynamicGDBFeatureInfo dyn_smereg_feature;
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 77aa78f00e..917f709cb4 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1236,8 +1236,8 @@ static void arm_cpu_initfn(Object *obj)
>> {
>>     ARMCPU *cpu = ARM_CPU(obj);
>>
>> -    cpu->cp_regs = g_hash_table_new_full(g_direct_hash, g_direct_equal,
>> -                                         NULL, g_free);
>> +    cpu->cp_regs = g_hash_table_new(g_direct_hash, g_direct_equal);
>> +    cpu->sysreg_props = g_hash_table_new(g_direct_hash, g_direct_equal);
>>
>>     QLIST_INIT(&cpu->pre_el_change_hooks);
>>     QLIST_INIT(&cpu->el_change_hooks);
>> @@ -1725,6 +1725,7 @@ static void arm_cpu_finalizefn(Object *obj)
>>     ARMCPRegMigTolerance *t, *n;
>>
>>     g_hash_table_destroy(cpu->cp_regs);
>> +    g_hash_table_destroy(cpu->sysreg_props);
>>
>>     QLIST_FOREACH_SAFE(hook, &cpu->pre_el_change_hooks, node, next) {
>>         QLIST_REMOVE(hook, node);
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 341542279d..cdc3779321 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -340,18 +340,79 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
>>     return NULL;
>> }
>>
>> +#define MAKE_IDREG_KEY(reg_idx, field_shift) \
>> +    (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
>> +
> Maybe, IDREG_FIELD_KEY()?
Yes

Eric
>
> Warm Regards,
> Khushit
>> static void set_sysreg_prop(Object *obj, Visitor *v,
>>                             const char *name, void *opaque,
>>                             Error **errp)
>> {
>> -    error_setg(errp, "%s setter not yet implemented", name);
>> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    int index = field->index;
>> +    int lower = field->shift;
>> +    int length = field->length;
>> +    uint64_t key, value;
>> +
>> +    if (!visit_type_uint64(v, name, &value, errp)) {
>> +        return;
>> +    }
>> +
>> +    if (length < 64 && value > ((1 << length) - 1)) {
>> +        error_setg(errp,
>> +                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
>> +                   name, value, length);
>> +        return;
>> +    }
>> +
>> +    if (field->arch_vals) {
>> +        /* this field has some enum values */
>> +        for (int i = 0; i < field->arch_vals_count; i++) {
>> +            if (value == field->arch_vals[i]) {
>> +                goto valid;
>> +            }
>> +        }
>> +        error_setg(errp,
>> +                   "idreg %s set value (0x%lx) does not match any "
>> +                   "arch valid enum value", name, value);
>> +        return;
>> +    }
>> +
>> +valid:
>> +
>> +    key = MAKE_IDREG_KEY(index, lower);
>> +    g_hash_table_insert(cpu->sysreg_props, GUINT_TO_POINTER(key),
>> +                       GUINT_TO_POINTER(value));
>> }
>>
>> static void get_sysreg_prop(Object *obj, Visitor *v,
>>                             const char *name, void *opaque,
>>                             Error **errp)
>> {
>> -    error_setg(errp, "%s getter not yet implemented", name);
>> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    int index = field->index;
>> +    int lower = field->shift;
>> +    int length = field->length;
>> +    gpointer value_ptr;
>> +    uint64_t value;
>> +    uint64_t key = MAKE_IDREG_KEY(index, lower);
>> +    gboolean exists;
>> +
>> +    exists = g_hash_table_lookup_extended(cpu->sysreg_props,
>> +                                          GUINT_TO_POINTER(key), NULL,
>> +                                          &value_ptr);
>> +    if (exists) {
>> +        value = GPOINTER_TO_UINT(value_ptr);
>> +    } else {
>> +        uint64_t mask = MAKE_64BIT_MASK(lower, length);
>> +        uint64_t *idregs = cpu->isar.idregs;
>> +
>> +        value = (idregs[index] & mask) >> lower;
>> +    }
>> +
>> +    visit_type_uint64(v, name, &value, errp);
>> +    trace_get_sysreg_prop(name, value);
>> }
>>
>> /*
>> -- 
>> 2.53.0
>>

