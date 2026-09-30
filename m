Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AF74EDCAF
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781103; cv=none; b=gx/MwqHaueZWQB255ScgpO8Oc8u4ssJm8T5bzrYJocMMrdyDOFm7UZY2taB9tABRsjeI1YNcfcERK7B9+kRDcgLLQZ4DKVYxU/MlP/4kGNRaAHwj20C6FY9luSqhEBJyYvwepZN9ifZAeL5+wKyVMcrMXNNDNQ4K2ANoafR3GEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781103; c=relaxed/simple;
	bh=YkqY5uptDFb5jMRAWYG2uoG8eSMzL0l9ljw5EgjUHeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pKmqmAGNDdL9pOTkXCcMenox9pWD9mtSxZwI4zxBgcjJqlJqlGNfvzIycphlLPXZ+L+vjFclrr3GiuZykuW3Vm+meHIkQ2ZMybLLJJnIbR3oLKUtY0TttAD8ahy+8K/BTRCZPwK+jfAYFi7qTQE3SpKp7kI/SncGcT17oouHs1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LegREHjG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LegREHjG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790781090;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7wSWouChO3YJdVcdwVjl9u7Qj6YLaKikGf1NY1itGlY=;
	b=LegREHjGwZGvz/pBbt5W9oDrYzBSGyCks/u5W7nUPiABYoGkSdWRlaRoruppeDLUChDE43
	qQ28qfSs7FAXpiT+qmMSJDs46ulmwSa3LYkHEoE9GDcb0sPXGjYOGt2mE2N+YAMwTWSe1m
	Sr/138DfmAVi710tFHixUOroTel3MoM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-UPBfv8MUM_yJTFukKw7MsQ-1; Wed, 30 Sep 2026 11:11:29 -0400
X-MC-Unique: UPBfv8MUM_yJTFukKw7MsQ-1
X-Mimecast-MFC-AGG-ID: UPBfv8MUM_yJTFukKw7MsQ_1790781088
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49fff093efcso51457955e9.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781088; x=1791385888;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7wSWouChO3YJdVcdwVjl9u7Qj6YLaKikGf1NY1itGlY=;
        b=XV2jTu0q8AM8EDtKQusHcBu1Q7sRRHtY3pnIJpcPCSoG/3gBM/kJcbjhccgUFM7rW3
         Pr7QmrxsvLO4D5g6G+VJsXWmXlxszG5j7a1fkI0SYJjuz2nuARyOBsFgedow31Y4TreZ
         ILcietDiuo36xx17zSM0c/nTGYkCAsH+7nQ87gxUJDN0qKGARNmoJXHacVDVPDCWn8Bt
         dzVFgRVw6j87s+K9zaLT6HuU9gZCjkmBqhJUTTt24vz/Wou81s0vhjgp9h0owRE2gD/b
         QhUDn64VVKD+uLXKZdkJlA7Y/plEUYaJWDrUrbDQFBZicIJ3e8hfY63j4PlBM8xZKJ4X
         R6Og==
X-Forwarded-Encrypted: i=1; AKwUvBzaoZ/loh36AYFjguDsWxp8SPrZ97BjeDtGID/kQVG/aQGLkDSyqPzSROqSXATz+gKHOyq7/pE=@lists.linux.dev
X-Gm-Message-State: AFuF++nrN7AmTDM2G2J+paiYq621hUA2zKTHULa5272wKfinNA/K493J
	YzHJJ3rRvz1J+21GloRd4/eCoM3L7Ozx0ZX79VAe/PT0eSxkmHm7xi8Gd8obdxfvj/iu3/bXdm8
	qSoX4FlZ9EMpKVk0r0Jjzl+gQjd2cb2Rvxpqdsz8Pn6OR2nMvicOAjiMQYQ==
X-Gm-Gg: AYBFou2ngt9msytpk2+sUp+OtGazfZdXmcVNGDLPMsBIXQ4rS+bpj5ZjobQQgXoJ94/
	hm86W2BX3pMtr4L2M6MKwv1kKqVl4fyEEMF0oqEtBUGE2VEr3UpBzDOwSQ/eexqatShP3E1dt6w
	CudgXw2NTfZlJJdZ99xHaMHdj8NVKUALjTWxdJmiB+OVs8orCcjeUpuDhb+5NCbpkKwJVsvePj6
	y804NgKwj77Cdtjo/AN1peaXqEJZDBVpDFWnp5SIpnAnAhFZDfDAyHlFSaSCqQ7Vh/5libK4K1K
	tbwUisd11WgWvrW49mbc9uuhBBy/XXoICgr9IHeeftiaHj1TRjkUWMW2FKtqSFvUmxrLG5+RQTu
	N0e6GFRKWEBgkNhxBg6JASOSRKiYkq/TthCWumU3IVz6DYaDW
X-Received: by 2002:a05:600c:3111:b0:49f:bc28:e8bc with SMTP id 5b1f17b1804b1-4a01afe731dmr31701715e9.17.1790781088248;
        Wed, 30 Sep 2026 08:11:28 -0700 (PDT)
X-Received: by 2002:a05:600c:3111:b0:49f:bc28:e8bc with SMTP id 5b1f17b1804b1-4a01afe731dmr31701265e9.17.1790781087824;
        Wed, 30 Sep 2026 08:11:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01e66b39csm4907525e9.15.2026.09.30.08.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 08:11:27 -0700 (PDT)
Message-ID: <f7e35493-02a4-4aa6-ac37-8d37369fa4e7@redhat.com>
Date: Wed, 30 Sep 2026 17:11:25 +0200
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
X-Mimecast-MFC-PROC-ID: PrndyPtS_OJc4RzdWxEiKi6FLbss-5nfr_bZRKY1sWY_1790781088
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



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
>
> Overall, I like this approach as if the user does not provide any property overrides, it should behave the same as older builds.
to me the risky part if the initialization of all cpu->isar.idregs[]
from host which can have side effects like the CLDIR_EL1 story.

Eric
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

