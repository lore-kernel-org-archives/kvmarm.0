Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04CE3E4C88
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 07:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445962; cv=none; b=FVcFW4sziG+TTwzKEonV4kiV/3llklk+jukQaBHoLBCsay1VbsusXIVlgi4wnyUnvZM9A2XjXeGgpawdw+SKdmxVXkfdq5WmYFr3kIcIZDP13jruQhItaSxIbGOkbrPh1Ibmnob3Gpc6J13xFnlocwMpWgMoleLQ3rwhSqxa75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445962; c=relaxed/simple;
	bh=6DTl0uwQ1yLTMh5cjmF/kl6BfX9oVPRW5+fpv8Jw9Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ChzSQqWtG1b9V9RZ3F2UfLzv6arj/R0pwhTLlpm05UfNAeQOWr6X1EOliHgDSTo96qqatqMSodL5nX2PcjSJn5YKIWcNhMpsWuDu21hcDZZ0HEoJwLK0uuNsD15qOcilAH6rdGwigPNdJJa7F4irGCas9ReWWWdrH5AFlg/nspY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dWTWRe/d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dWTWRe/d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791445957;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Py7x+AATRs+M7CC5CAtcFn0GVg+kSB4pWlgQwH92zJU=;
	b=dWTWRe/d84JEgoJmXlbtCHjurgPKG4DGMiF6ki6Rb2vm+PdQ3NLXnYcjaoL78D8H3vI+U+
	tJe8fqKURpoXmlxHPNMLl/vp9l0UkN6v1goqdwzYFusiiPBA8Q0L/phs8HV9WdZN1KcutM
	0HuVRyr3M4accGuj6R25S5Cmjskb/zo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-xS5fkjCmMmqVeQZHHM_kyA-1; Thu, 08 Oct 2026 03:52:36 -0400
X-MC-Unique: xS5fkjCmMmqVeQZHHM_kyA-1
X-Mimecast-MFC-AGG-ID: xS5fkjCmMmqVeQZHHM_kyA_1791445955
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b00febba3so3360980f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 00:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791445955; x=1792050755;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Py7x+AATRs+M7CC5CAtcFn0GVg+kSB4pWlgQwH92zJU=;
        b=U07haPXnxveWBlyynUg74skFsZ9VXUgxYb34lAYIGenx8h2QZFyghxgBs5MyuVZMOO
         CiSIU6nPYqevLmqPl0OLQP6bA9LPfRVVwWlh5bmMqCy1bazvH7F5nMWfY5PZykCKbnmg
         caVGSIDWNhgVAkGTjrx3aCU36vvgl5L0/HKeuTlJgkMe49c+ysY3ef/7F6FQhdPV/a/J
         CKxOXVKynM06OA4Vm9RFifDoF4WMdmVBUYKB2j0BR34a1Qpw6vrgmB2AdQBlu+rNlXLj
         /X8BN1OO7e1jXtLd3ww1/V0woevo9NLuVROiJn5eKBVgh6XdP9dsWuc6NHAd1O2midm3
         G57w==
X-Forwarded-Encrypted: i=1; AKwUvBxBpqveoo03wvwszhscCKDmVGbd4h+/WEy8PTMGdRSegOBlmSE2Ikryi4M3MLvCmwc72LEpbBo=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ0/Rwh5Y2nn6zc/FwanxVJh/bG73jAbdG7vrIixTLskr7DlzcN
	h7zEY7h/81Ci4tBo84TiDgspDwBkQBw2SnLCzJP8ncncnnP3aS8a5jutaDexZMkusA1k85hBdrG
	iRAJ7vreNOJCia9wKcjU4rOXvpaE7aF4y/Kf8CQ7zvqlnHcyudANmhhR2eQ==
X-Gm-Gg: AYBFou1jjHdWcdbRy0BmX0mKNYDs4cbboNwL/CRri1KN4hkSWxww8341YwtS8lWd8/b
	8/iGgM5noy6YlWdu7fkPlb2lIxtsFck4yFN73rYGe+Tk5MplkxrNLHWHqXjF/oDRJ+5Lv+FvjBd
	xbkuMPExG+2GEip5o7M6u59MTaTF+8pJZetBUtG+nX3xxqI5HWTD+2kP6n1T6rW0nnPFaHIQB+I
	uvF78G0g53ETs3ko7q0hT1EDsgPy6fcv/jjVQwOlSynTsdz7WKFVC9VKyXIvBEDTb7opl+0svMn
	56AXVLiPL1gmSRTug+JRSxcwjWEH5S2aj4upQ8Kw3MaS+4ne/nGZLjU03Lob77aCmaEZWLxpet2
	iQMYyCwxIj0407u+7oKwmm1+JcMyx9dYbeIPQCfB5cCq8AtB6
X-Received: by 2002:a05:6000:4818:b0:487:27f6:a4d3 with SMTP id ffacd0b85a97d-48c72884e65mr7905397f8f.35.1791445955192;
        Thu, 08 Oct 2026 00:52:35 -0700 (PDT)
X-Received: by 2002:a05:6000:4818:b0:487:27f6:a4d3 with SMTP id ffacd0b85a97d-48c72884e65mr7905271f8f.35.1791445952791;
        Thu, 08 Oct 2026 00:52:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c724b660fsm9300871f8f.18.2026.10.08.00.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 00:52:32 -0700 (PDT)
Message-ID: <df13670e-1502-4947-8a76-600dd045708b@redhat.com>
Date: Thu, 8 Oct 2026 09:52:30 +0200
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
 <5AC3258F-1F6E-491E-8B38-633C52199904@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <5AC3258F-1F6E-491E-8B38-633C52199904@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u81MQQcuVZaWMa1j_JM2mwucNjM6r5W1ZimfhOCxkJc_1791445955
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/30/26 9:54 AM, Khushit Shah wrote:
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
>> +
>> +        kvm_reg.id = kvm_idx;
>> +        kvm_reg.addr = (uintptr_t)&idregs[reg_idx];
>> +
>> +        ret = ioctl(cs->kvm_fd, KVM_SET_ONE_REG, &kvm_reg);
>> +        if (ret) {
>> +            error_setg(errp, "failed to apply new value 0x%"PRIx64" for field %s.%s "
>> +                       "(previous is 0x%"PRIx64"): %m", idregs[reg_idx],
>> +                       reg->name, field->name, oldfv);
>> +            return ret;
>> +        }
> Hi Eric,
>
> The above is the only KVM-related code here. Can we split this into
>     1. Apply SYSREG_ props callback which resides in cpu64.c?
>     2. The previous writeback to cpregs function that writes back ID registers to KVM?

the problem is the previous method was copying all the idregs that
changed back to cpregs. But those idregs were populated from the "max"
vcpu which in some cases led to inconsistency with the final vcpu
setting. The setter now registers the new field value in a hash table.
Maybe we can just rely on an arch callback to apply them on the guest

Thanks

Eric
>
> The reason being the SYSREG_ props otherwise do not work with any other accelerator.
> We are already trying to make the SYSREG_ getter/setter accel-agnostic.
>
> The above method still has the nicety that -cpu host without any SYSREG_ prop should
> behave the same as previous :)
>
> Side note:
> While we don’t target TCG support currently, I tried your v8 + named models on TCG
> (quick hack; ~20 LOC), and SYSREG_ props/named models works almost out of the box
> there (very minimal testing), which was cool.
>
> Thanks,
> Khushit
>
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

