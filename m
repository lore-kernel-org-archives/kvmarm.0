Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B94F85C5
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780913; cv=none; b=aG0tFFkkzjj2YawPA1GbIHss2VOTe6Id1QQi412ICFYUMPxcAyJPXpnDMQ2IXSsDxf1NIjScVs1YBu6U9C7rK/Y0KPzDJ5Hb3L0G9s7uajyRa3ubTJq8DDMAx3uxuEavvp28pbUVPD4nO7bjikwUltRBzLpCuSRPJ8GcjArAWnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780913; c=relaxed/simple;
	bh=pTqrQFkAmhNA6M1rsaOwKmxx6/dEPTFtcacQf6zer8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2o+MjzDXdmVUDnAcBLRe5RpOEko81sSPVIPDZWbLDJ8fZik9jz17LwvwEbR9qilrPRmLmagBWIQSgtNM5s+OlO7dONPhqyB4mLcLUeK/6KKSBJW5utOZH3gr5H9aorcDJSwYWGoqVlwX/W4s+ZK6HOaA4NGndmQrsP4eZ12ffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPXvbOhe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPXvbOhe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790780896;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ns+huMlBjpBINTzATYtJG6y2085LhnRydQuWQ6U4h1s=;
	b=NPXvbOheyZuwEOxnbmK9GXgDbpf0dI13D1fGzQJhDB4qAXG7W7R4JPCul2gmVkfyISAKBw
	YxMqMt865+k+iBx1XrsIVQ63T7AsN0VLeaTNiIRNkF8c0s6r1EexUrocqCGLgFLIdK7TDh
	nQgJS72pw62JZyzgQ/+vapf1li/9Vlc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-KtYLvSSQOee5UKWwDsgetw-1; Wed, 30 Sep 2026 11:08:15 -0400
X-MC-Unique: KtYLvSSQOee5UKWwDsgetw-1
X-Mimecast-MFC-AGG-ID: KtYLvSSQOee5UKWwDsgetw_1790780894
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e65bee41aso18073315e9.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790780894; x=1791385694;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ns+huMlBjpBINTzATYtJG6y2085LhnRydQuWQ6U4h1s=;
        b=keEKScVhj++QcAGt0Y6qhvwftfZDuetlQNajQq/hm3eu2LWzxOhScPRegKfRejXqgy
         Ci9KqVgmzrtY3aFUH5tmykcNw4cdMdf/L35HF7whuVGPCW2mjvoKOqGe4B3UwnExTnLP
         qIVNteywEJtu8u+mjZn7O0q3IY7XM5L8BUv6tyx6weoDXlRseFbUd19LjOzdRcGc5PpC
         oQkWkbkBex2lYHFouZiJOycDo0+x7+ii/gn9BkmgkS3i6BVDwFap8O27v4Wp/zudiWsf
         B2Rs+aSlTOocRXCZOZsyYmD8NsCowHyYZXNZQkfau8daf2z7xGzC/yv7saTKDyM9J/FD
         G0Wg==
X-Forwarded-Encrypted: i=1; AKwUvBzK78s1D6Rl4s1CF3RvvV9jGNm30tRoJTxAhhvbQbGbnz6WhX54b5MADTkyEbYjYy9SPtvlblk=@lists.linux.dev
X-Gm-Message-State: AFuF++kBh3NLjEmtJIBCPocEvnAePcUZSMItr3NCfO4FNCuqSEvx0hO/
	lsXTrdbaYhFuQwXzf99U7l1Rw/JTOEEYCu8SAXoyq4VvKR/VnsoSE1VWjIsTO/KHksIwYpsWP1o
	PEAzU6/FoJzdzViMCjUo138rsYMwym3CXlB5WzYcvOlviRMj5pKFuTuRBaQ==
X-Gm-Gg: AYBFou2fu0UhtLrXpBqo7g7Vrh7+2uSKOazNirDqzKypqBmUCnTuCgffygbRl7iSaN+
	T4cve7t8RDGJjq5BHA31im+f9oWSfSiuEN9biRUCjeIQmLYTSfba0QupfECjGXW/uNrGglAAw+T
	pPKglq2FIN4EDmxPebJR8D8EYqI3xOgdlIa2A387BSJQiQ6IhgQscxZgf0VdIZPhcB9dUvec19b
	GmmbYSv8/85GdeuTkO+Ih8j7gS+wA/RsEyvjC2pxHtqgU4ACw4oGnTQWcyIVtKU/Am297wOGuCL
	5cAj5c+fiYHGA7wgBTt7KLTBiIbalEpeONJ1MbsypIZ/Zvqbp57XITSA53vF590UnWuEoSnkoKg
	Plt8/j93Ch1yk4cYSZTVR3MgPGPwrvwcJAwNCfCDSgcYzBK0D
X-Received: by 2002:a05:600d:82c4:b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-4a01b188e38mr32968415e9.4.1790780893288;
        Wed, 30 Sep 2026 08:08:13 -0700 (PDT)
X-Received: by 2002:a05:600d:82c4:b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-4a01b188e38mr32967005e9.4.1790780892124;
        Wed, 30 Sep 2026 08:08:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01cd6cd2bsm10750735e9.4.2026.09.30.08.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 08:08:11 -0700 (PDT)
Message-ID: <bd747536-c8eb-4c21-a859-ac1f2a28794f@redhat.com>
Date: Wed, 30 Sep 2026 17:08:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
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
 <20260916144721.751810-17-eric.auger@redhat.com>
 <8F110441-6D38-4134-9196-76AFA021250F@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <8F110441-6D38-4134-9196-76AFA021250F@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KpvcoxftF6ZChxwYPwL6qdHY779OJx8Hn9Mq-x-WAJ4_1790780894
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/28/26 12:44 PM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> SYSREG prop settings were recorded in a hashtable but they
>> are not yet injected on guest. Iterate over all set fields and
>> apply the new value through KVM_SET_ONE_REG. The new field
>> value overrides the current observable vcpu register value.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> With this, I suppose, what named models will do is directly write to
> ID register state, As it also defines state which affects vCPU init flags also.
That's not what I had in mind. I thought you would apply the SYSREG
settings at the same time. As mentionned, I don't think those settings
are meant to substitute to legacy composite options that affect vcpu
init settings.
Besides the principle of this preparatory series is that the props for
writable ID reg fields are meant to be fully reusable for named vcpu
models. Only props for non writable fields should be specific to named
vcpu models as they do not make sense on host/max vcpu model


>
>> ---
>> target/arm/kvm.c        | 65 +++++++++++++++++++++++++++++++++++++++++
>> target/arm/trace-events |  1 +
>> 2 files changed, 66 insertions(+)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 3ec2618cc1..ddf320d0e6 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -343,6 +343,9 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
>> #define MAKE_IDREG_KEY(reg_idx, field_shift) \
>>     (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
>>
>> +#define KEY_TO_REG_IDX(key)     ((uint32_t)(((uint64_t)(key)) >> 8))
>> +#define KEY_TO_SHIFT(key)       ((uint8_t)(((uint64_t)(key)) & 0xFF))
>> +
>> static void set_sysreg_prop(Object *obj, Visitor *v,
>>                             const char *name, void *opaque,
>>                             Error **errp)
>> @@ -2215,6 +2218,63 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>     return 0;
>> }
>>
>> +static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
>> +{
>> +    uint64_t *idregs = cpu->isar.idregs;
>> +    gpointer key_ptr, value_ptr;
>> +    CPUState *cs = CPU(cpu);
>> +    GHashTableIter iter;
>> +
>> +    g_hash_table_iter_init(&iter, cpu->sysreg_props);
>> +
>> +    while (g_hash_table_iter_next(&iter, &key_ptr, &value_ptr)) {
>> +        uint64_t key = (uint64_t)key_ptr;
>> +        uint64_t value = (uint64_t)value_ptr;
>> +        uint32_t reg_idx = KEY_TO_REG_IDX(key);
>> +        uint8_t lower    = KEY_TO_SHIFT(key);
>> +        ARM64SysReg *reg = &arm64_id_regs[reg_idx];
>> +        struct kvm_one_reg kvm_reg;
>> +        uint64_t current, old, mask;
>> +        uint64_t kvm_idx;
>> +        ARM64SysRegField *field = get_field(lower, reg);
>> +        int length = field->length;
>> +        uint64_t oldfv;
>> +        int ret;
>> +
>> +        mask = MAKE_64BIT_MASK(lower, length);
>> +        value = value << lower;
>> +
>> +        old = idregs[reg_idx];
>> +
>> +        kvm_idx = idregs_sysreg_to_kvm_reg(id_register_sysreg[reg_idx]);
>> +        ret = read_sys_reg64(cs->kvm_fd, &current, kvm_idx);
>> +        if (ret) {
>> +            error_setg(errp, "failed to read the current value of %s",
>> +                       reg->name);
>> +            return ret;
>> +        }
>> +        oldfv = (current & mask) >> lower;
>> +
>> +        idregs[reg_idx] = current & ~mask;
>> +        idregs[reg_idx] |= value;
>> +        kvm_reg.id = kvm_idx;
>> +        kvm_reg.addr = (uintptr_t)&idregs[reg_idx];
>> +
> We can ignore this if value == old value
sure, modified
>
>> +        ret = ioctl(cs->kvm_fd, KVM_SET_ONE_REG, &kvm_reg);
>> +        if (ret) {
>> +            error_setg(errp, "failed to apply new value 0x%"PRIx64" for field %s.%s "
>> +                       "(previous is 0x%"PRIx64"): %m", idregs[reg_idx],
>> +                       reg->name, field->name, oldfv);
>> +            return ret;
>> +        }
>> +
>> +        trace_apply_sysreg_prop(reg->name, field->name, old, current,
>> +                                mask, value, idregs[reg_idx]);
>> +    }
>> +    return 0;
>> +}
>> +
>> int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
>> {
>>     int ret;
>> @@ -2315,6 +2375,11 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
>>     }
>>     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>>
>> +    ret = kvm_arm_apply_sysreg_props(cpu, errp);
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +
> This should also happen on vCPU reset.
On which path is it needed? on qmp system_reset I can see that the
former values applied with SYSREG settings are kept.

Thanks

Eric
>
> Overall, I like this approach as if the user does not provide any property overrides, it should behave the same as older builds.
>
> Warm Regards,
> Khushit
>>     return kvm_arm_init_cpreg_list(cpu);
>> }
>>
>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>> index d72ad6b671..b4d2b45a7d 100644
>> --- a/target/arm/trace-events
>> +++ b/target/arm/trace-events
>> @@ -18,6 +18,7 @@ kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint6
>> decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
>> get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
>> set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
>> +apply_sysreg_prop(const char *reg_name, const char *field_name, uint64_t old, uint64_t current, uint64_t mask, uint64_t field_value, uint64_t new) "%s.%s old=0x%"PRIx64" current=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new=0x%"PRIx64
>> nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
>>
>> # cpu.c
>> -- 
>> 2.53.0
>>

