Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95A83DAACB
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540143; cv=none; b=h7L2te1/THSwsE7Pmq0gG9gZueU9FHWOEbSt2dPHhTp7T/lYPo5xOl1EVWLauknSK5JB6OncyB3sGUjTYPfgn6yABFdbRPGylCUSkdpcHXeDy40Gb/3yP0KjMMhMlVp1dkK4k5HrClWtlcnAcTuy+HDKazNeOmOTmqGKItPxNhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540143; c=relaxed/simple;
	bh=92UrW66BtjXfUI1STXO3w0uYYBln4Zx6moKjGyT8pRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cn4GBCvE85Es851uVUcH6JBsYm8CH90JbZovoo1gXKHDLf6m2sHRTTQMzbWQqVuLQlfEh3kbqFqR5ujNa2oZ4uXfXtWaOB15+/Bvc8YVcsyzXqhZA37BS+WBKNt4/WRoybIP4PiKdBJtlWb1FWVQsYpwTJ2Bmqku7zSVsGJ81A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fU1enxa8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fU1enxa8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791540140;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVw/AOI5Byij/EuNDA1o5GevYH9T8u9aG5UefmtnLlk=;
	b=fU1enxa8ZKYRRLQp+jfEXXF4YgA8gHYo0W4EJl+5X0YmQKQmdjgN3lJnDYn2nmy/q5yIIM
	ZmePWpJWRcPT9yA9mpLNOsSZHbjEA6VQPYW9539cAM0jlFISoVuMHIIcJxRiUd80qSG0Io
	463Vy3I9+DG5WN+dAXCAzRbPh8IAjrY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-_xXcGB3wNiCXPdpj6BZvNg-1; Fri, 09 Oct 2026 06:02:19 -0400
X-MC-Unique: _xXcGB3wNiCXPdpj6BZvNg-1
X-Mimecast-MFC-AGG-ID: _xXcGB3wNiCXPdpj6BZvNg_1791540138
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c29bc25836fso718330866b.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 03:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540138; x=1792144938;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qVw/AOI5Byij/EuNDA1o5GevYH9T8u9aG5UefmtnLlk=;
        b=k4dJWiI3EO8ou5/UkKsbQICNWsnVbixVlY3eH0LqtFl6yJBzRqD/TMn7hh4k6/4/uE
         keSmv/vlMQMAgw1179YpAQGyAWw2h4LL75hErfgrGnrCGhGBOQysDmPrFrcIlcimyWhc
         wdvJETFbPbyg79L2OBsKOzXhKnC3c0wR4SHisHcjePbKmMZSsGaOfwBH5XJ20VB+7KMv
         TPOqt35q5fBnJ9q1hJI93RBoyiCNDMeU/6X1BxIY/MQVn72K+5ocRQeCI4ufVTsXQBrL
         4hbclB+HdqMyl/gTO0E+SCUNs/pJfv0jHt0uMYPOF6LA0V/RasgR62p5wc/tsW7FP9Mo
         92Yg==
X-Forwarded-Encrypted: i=1; AKwUvBz7My2ky9txbjJiC5ubTp1IMOkYYa4WuyarckGhOvR7aGJh1GxYwiy9Uj5+xdZvaxNd1OkHNug=@lists.linux.dev
X-Gm-Message-State: AFq9FYIi8/q1YVzLIGW3yBcYNaHofTU9AJs/orECIsPdcEpAMPOa0FGo
	LBZrcTsKfSK3vHqvaFeQiP8aiG/4NLIXXRsfl3fkd/Z3PA6/dff4GdfSo79f+Ga12u6A9e5aDnC
	VEaHOCliyiSbh9jNVl9EIOHNVxScUyGF73Yms5EV6sCbJnizI48iXFOOfhA==
X-Gm-Gg: AYBFou3PRsp2txj1WFME3yQYZNlwEyKR7xb/iDYlLd04oQU78NTmYM0u9Y+0qX2Ghvn
	03MJ6hEaVorKHyS5c2w7kEdTNDqPRke3L+czrBc6sZOJ7ihBcG2GvBm0l+z7uxc6HNLxWseOXWZ
	zRA6Zz9YOzRpH687DHATL3WNOfiKAqAx+HHwQ8pCOJjupFnnAPrZeql8/kji0ltj00XM/f5WZas
	AYlmSxO7X2QDFxw3mDqhd/sY/W4QNrle2ZwCRKEaJJRe95f0erCdN3jSZ7woLN/9Rq5rjycpIc0
	bA6TpPNNR6pSXwtX6cyVDzmZfZRKFbavSeVjQ9zL30Hlgd0t53aMfSMARXjGDTYj++ET7WzfBlt
	TlPz6b9/L2UKuudjOO4GUJ9Ee8HbUCgC0TesuoDAl0FExDIZl
X-Received: by 2002:a17:906:f5aa:b0:c26:19de:9ac5 with SMTP id a640c23a62f3a-c31aa0960bamr129187066b.29.1791540138046;
        Fri, 09 Oct 2026 03:02:18 -0700 (PDT)
X-Received: by 2002:a17:906:f5aa:b0:c26:19de:9ac5 with SMTP id a640c23a62f3a-c31aa0960bamr129181966b.29.1791540137592;
        Fri, 09 Oct 2026 03:02:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9aca657sm3041038f8f.43.2026.10.09.03.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 03:02:17 -0700 (PDT)
Message-ID: <00d6c513-b5ae-45d1-a31b-9729e2ca6451@redhat.com>
Date: Fri, 9 Oct 2026 12:02:15 +0200
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
 <df13670e-1502-4947-8a76-600dd045708b@redhat.com>
 <9E461CD6-E877-495A-BC4F-FB3AA32CB198@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <9E461CD6-E877-495A-BC4F-FB3AA32CB198@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w2y_R2ThXTItVeQxv23HDw9MlOfJ84Kk5ptZ4NAC73g_1791540138
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/8/26 11:45 AM, Khushit Shah wrote:
>
>> On 8 Oct 2026, at 1:22 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>>
>>
>> On 9/30/26 9:54 AM, Khushit Shah wrote:
>>>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>>
>>>> !-------------------------------------------------------------------|
>>>> CAUTION: External Email
>>>>
>>>> |-------------------------------------------------------------------!
>>>>
>>>> SYSREG prop settings were recorded in a hashtable but they
>>>> are not yet injected on guest. Iterate over all set fields and
>>>> apply the new value through KVM_SET_ONE_REG. The new field
>>>> value overrides the current observable vcpu register value.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> ---
>>>> target/arm/kvm.c        | 65 +++++++++++++++++++++++++++++++++++++++++
>>>> target/arm/trace-events |  1 +
>>>> 2 files changed, 66 insertions(+)
>>>>
>>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>> index 3ec2618cc1..ddf320d0e6 100644
>>>> --- a/target/arm/kvm.c
>>>> +++ b/target/arm/kvm.c
>>>> @@ -343,6 +343,9 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
>>>> #define MAKE_IDREG_KEY(reg_idx, field_shift) \
>>>>    (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
>>>>
>>>> +#define KEY_TO_REG_IDX(key)     ((uint32_t)(((uint64_t)(key)) >> 8))
>>>> +#define KEY_TO_SHIFT(key)       ((uint8_t)(((uint64_t)(key)) & 0xFF))
>>>> +
>>>> static void set_sysreg_prop(Object *obj, Visitor *v,
>>>>                            const char *name, void *opaque,
>>>>                            Error **errp)
>>>> @@ -2215,6 +2218,63 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>    return 0;
>>>> }
>>>>
>>>> +static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
>>>> +{
>>>> +    uint64_t *idregs = cpu->isar.idregs;
>>>> +    gpointer key_ptr, value_ptr;
>>>> +    CPUState *cs = CPU(cpu);
>>>> +    GHashTableIter iter;
>>>> +
>>>> +    g_hash_table_iter_init(&iter, cpu->sysreg_props);
>>>> +
>>>> +    while (g_hash_table_iter_next(&iter, &key_ptr, &value_ptr)) {
>>>> +        uint64_t key = (uint64_t)key_ptr;
>>>> +        uint64_t value = (uint64_t)value_ptr;
>>>> +        uint32_t reg_idx = KEY_TO_REG_IDX(key);
>>>> +        uint8_t lower    = KEY_TO_SHIFT(key);
>>>> +        ARM64SysReg *reg = &arm64_id_regs[reg_idx];
>>>> +        struct kvm_one_reg kvm_reg;
>>>> +        uint64_t current, old, mask;
>>>> +        uint64_t kvm_idx;
>>>> +        ARM64SysRegField *field = get_field(lower, reg);
>>>> +        int length = field->length;
>>>> +        uint64_t oldfv;
>>>> +        int ret;
>>>> +
>>>> +        mask = MAKE_64BIT_MASK(lower, length);
>>>> +        value = value << lower;
>>>> +
>>>> +        old = idregs[reg_idx];
>>>> +
>>>> +        kvm_idx = idregs_sysreg_to_kvm_reg(id_register_sysreg[reg_idx]);
>>>> +        ret = read_sys_reg64(cs->kvm_fd, &current, kvm_idx);
>>>> +        if (ret) {
>>>> +            error_setg(errp, "failed to read the current value of %s",
>>>> +                       reg->name);
>>>> +            return ret;
>>>> +        }
>>>> +        oldfv = (current & mask) >> lower;
>>>> +
>>>> +        idregs[reg_idx] = current & ~mask;
>>>> +        idregs[reg_idx] |= value;
>>>> +
>>>> +        kvm_reg.id = kvm_idx;
>>>> +        kvm_reg.addr = (uintptr_t)&idregs[reg_idx];
>>>> +
>>>> +        ret = ioctl(cs->kvm_fd, KVM_SET_ONE_REG, &kvm_reg);
>>>> +        if (ret) {
>>>> +            error_setg(errp, "failed to apply new value 0x%"PRIx64" for field %s.%s "
>>>> +                       "(previous is 0x%"PRIx64"): %m", idregs[reg_idx],
>>>> +                       reg->name, field->name, oldfv);
>>>> +            return ret;
>>>> +        }
>>> Hi Eric,
>>>
>>> The above is the only KVM-related code here. Can we split this into
>>>    1. Apply SYSREG_ props callback which resides in cpu64.c?
>>>    2. The previous writeback to cpregs function that writes back ID registers to KVM?
>> the problem is the previous method was copying all the idregs that
>> changed back to cpregs. But those idregs were populated from the "max"
>> vcpu which in some cases led to inconsistency with the final vcpu
>> setting. The setter now registers the new field value in a hash table.
>> Maybe we can just rely on an arch callback to apply them on the guest
>>
> Yes, this is what I am suggesting.
>
> What I was thinking is a KVM-specific code (kvm_arch_init_vcpu) will call callback to cpu64.c to set the property values after the vCPUs are init, and after the callback finishes, the values are written back to cpregs.
>
> With this the inconsistency problem does not arise as we will only call the callback after we properly setup the vCPU.

I have moved most of the code in cpu64, ie. hash table lookup and
cpu->isar.idregs[] update on success. The functional uses an
acceleration specific callback to apply the field value on guest vcpu.
However the arch agnostic function is still called in kvm so that the
kvmlist is synced to cpregs afterwards.

Let's see in v10 if it matches your expectations

Thanks

Eric
>
> FWIU, you are suggesting the same thing?
>
> Thanks,
> Khushit
>> Thanks
>>
>> Eric
>>> The reason being the SYSREG_ props otherwise do not work with any other accelerator.
>>> We are already trying to make the SYSREG_ getter/setter accel-agnostic.
>>>
>>> The above method still has the nicety that -cpu host without any SYSREG_ prop should
>>> behave the same as previous :)
>>>
>>> Side note:
>>> While we don’t target TCG support currently, I tried your v8 + named models on TCG
>>> (quick hack; ~20 LOC), and SYSREG_ props/named models works almost out of the box
>>> there (very minimal testing), which was cool.
>>>
>>> Thanks,
>>> Khushit
>>>
>>>> +
>>>> +        trace_apply_sysreg_prop(reg->name, field->name, old, current,
>>>> +                                mask, value, idregs[reg_idx]);
>>>> +    }
>>>> +    return 0;
>>>> +}
>>>> +
>>>> int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
>>>> {
>>>>    int ret;
>>>> @@ -2315,6 +2375,11 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
>>>>    }
>>>>    cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>>>>
>>>> +    ret = kvm_arm_apply_sysreg_props(cpu, errp);
>>>> +    if (ret) {
>>>> +        return ret;
>>>> +    }
>>>> +
>>>>    return kvm_arm_init_cpreg_list(cpu);
>>>> }
>>>>
>>>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>>>> index d72ad6b671..b4d2b45a7d 100644
>>>> --- a/target/arm/trace-events
>>>> +++ b/target/arm/trace-events
>>>> @@ -18,6 +18,7 @@ kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint6
>>>> decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
>>>> get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
>>>> set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
>>>> +apply_sysreg_prop(const char *reg_name, const char *field_name, uint64_t old, uint64_t current, uint64_t mask, uint64_t field_value, uint64_t new) "%s.%s old=0x%"PRIx64" current=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new=0x%"PRIx64
>>>> nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
>>>>
>>>> # cpu.c
>>>> -- 
>>>> 2.53.0
>

