Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6207E3515D1
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790201; cv=none; b=m7OSo98A8Y9Sc3PwLi/Mmi/DOwPIQutc1XguQRjKsv2qayT2YSngXRjLX4LJFQdwU4KVTYhlODgvg4sX6ACYzM2aOChh1G7frbZ5P0axWOiAQ7BiYUGnEZQXFB4WJk70yA8mQ7b7F8fl8WI1sE4h6Mip8inkehD/sZXvwqpvAXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790201; c=relaxed/simple;
	bh=3LPLz8jd5fohmm2jQ9ljnF2HcO8sP6UNrmc9A/WOfJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnZbCsjsa1mDdZJhp0okg+Wqdjmzg8mglWu1BCpuJE2WO/Ow25ppmx5Hj/kHfjGuEcnRoBHE5HLhdx6at2cMSSibkDmg72ZrHKP6BqDp7+aS9+QZTP7yZrgYZS4SiOuq5Tp0JdxUh1M90DFKORCqFAxQywWYyKtRunwh0bdSbGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIotmULE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIotmULE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790790198;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SiFzGMFKKl+ozvaauMYdUK2l9xfAclZr0fBl6EjIlYQ=;
	b=gIotmULEQ/AbwXJAIkOaJzPNWBv/0pZs3mHsP+p6nd7L+ynZ0Y3ga9MZtR1oTO2ibecE2v
	3pII317HezDTD0ixW/koVFLAfwd0RsZ4tEFfXQFH47V4tnxc7hs3SVLGB0GdF2IfOOBhkQ
	ga1irk4Rpr7gitZLbS803CEj6NkG1uw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-DLVwF0dMP8yGsWVjNAYdgw-1; Wed, 30 Sep 2026 13:43:16 -0400
X-MC-Unique: DLVwF0dMP8yGsWVjNAYdgw-1
X-Mimecast-MFC-AGG-ID: DLVwF0dMP8yGsWVjNAYdgw_1790790195
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4887f71b1baso4663376f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 10:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790790195; x=1791394995;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SiFzGMFKKl+ozvaauMYdUK2l9xfAclZr0fBl6EjIlYQ=;
        b=qYnijnDUWaGqOErqCxoxSGVip/2/+0aReMK52wCpzsE3iVyV78UkcHd9uqdGL/szCG
         f9+hA6pBJBLtOsnEOuBboSiNlXfBVZayt5oabjKQC0FtYq1wRxefm10W5arR17Kp/TRM
         PI2lyKxMh83WECDBzuNN8cv/ycp+dEvzbSVJ+GlJndWMjxOeZXa7p6UzLkgU+kb9b0b6
         jm7YfIevsCMUnZOHlhSJaWq7V11YfOhNbnR0OeZrT3FYAaVFY9WPmMbfxOHVvm+2o9XJ
         FHmLNwGVQXW33vyXbwxmpMa5bDgpl3bYurds8Bps1h1+IOMK/fF0MhA3XbNLGcDCNlO7
         N61Q==
X-Forwarded-Encrypted: i=1; AKwUvBwtQ9cB2E6Gmn3Vi/QxocDs+iCtm22CrEsKuTyYj/rpRrikzen+iz0o+49Kt5Dpr/IojFF9QNs=@lists.linux.dev
X-Gm-Message-State: AFq9FYKZtih+XXkO5FCLvvHyRGv1+rUZZqUddwru6QgvBh6HGhJLlX+z
	azt0ytNQzkhPHaritsjHg4by6H8mjISBp/xvzq0PdpJwUJEcYzNmLktwnaks56N7fo03psGx5Hh
	L0ST58phOd3yA45BH4JVbrtBN7EErgLZSamG7F+ApiFEwQxQhMnk/NWFhIg==
X-Gm-Gg: AYBFou1HLoufjWtK/0Lu4wuvkAcecBN8OOgZ+6hxK8qCK6AFmvyknMezPmry2nDEu2Q
	/CZWAmQxnCzMT0BDMvyUYm1pkFfsjLnSmeZH0zSFg99K+by518dPHPVArA2tOyD4gbUvvVg76Ul
	qLpYkqcLaWn+13hJJzIAY5VC0ATIqfuYwwHbYgsLTOP56ib/0RT0yWOum6+uQfYMT9qiWpIw6td
	9Kfcpyrrf40jC4xOxBz0GAyI0YmyH8m3sIkXNKLDDjIHDhzLPqvP9/9Le+zy4pYViCefLaVLQJy
	L0iCGxLE3a+cRNSf7JCVxua1b+khODaiiGpTW+ruKQGN5U4FeNrtA1k0JkTEFQyiKE+SE9XV+HD
	CmFlBC3e3m2g2DcyJsGrbb8el6wr/7oM4TA6/CcJNpXvrPc2c
X-Received: by 2002:a05:6000:4029:b0:488:5d44:6680 with SMTP id ffacd0b85a97d-48b025083c4mr4389593f8f.36.1790790195187;
        Wed, 30 Sep 2026 10:43:15 -0700 (PDT)
X-Received: by 2002:a05:6000:4029:b0:488:5d44:6680 with SMTP id ffacd0b85a97d-48b025083c4mr4389553f8f.36.1790790194789;
        Wed, 30 Sep 2026 10:43:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b06a2d12fsm526748f8f.31.2026.09.30.10.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 10:43:14 -0700 (PDT)
Message-ID: <aca67e8c-7599-45aa-a6c7-542c0461ad19@redhat.com>
Date: Wed, 30 Sep 2026 19:43:12 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 21/26] target/arm/kvm: add helper to test SYSREG props
 against a scratch vcpu
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
 <20260916144721.751810-22-eric.auger@redhat.com>
 <E471D5C1-D254-4DC9-BD22-E02660DE144F@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <E471D5C1-D254-4DC9-BD22-E02660DE144F@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hyIuQawJuaqOCRPO_MmIlin948zswmkAkgDBNwwYFjI_1790790195
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/28/26 3:34 PM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Add kvm_idreg_write_scratch_vcpu helper that will be used
>> by qmp_query_cpu_model_expansion code to test SYSREG settings
>> against a scratch vcpu. Indeed when the expansion code is called
>> the actual vcpu has not been initialized so we use a scratch vcpu.
>> This latter has been initialized with features taken from
>> legacy compositive options (EL2, SVE, ...). So the trial is
>> very close to the final setup.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> target/arm/kvm_arm.h    |  4 ++++
>> target/arm/kvm-stub.c   |  7 ++++++
>> target/arm/kvm.c        | 51 +++++++++++++++++++++++++++++++++++++++++
>> target/arm/trace-events |  1 +
>> 4 files changed, 63 insertions(+)
>>
>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index 2b3474cc36..bace69efed 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -14,6 +14,7 @@
>> #include "qapi/qapi-types-misc-arm.h"
>> #include "system/kvm.h"
>> #include "target/arm/cpu-qom.h"
>> +#include "cpu-idregs.h"
>>
>> #define KVM_ARM_VGIC_V2   (1 << 0)
>> #define KVM_ARM_VGIC_V3   (1 << 1)
>> @@ -250,4 +251,7 @@ void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
>>  */
>> char *kvm_print_register_name(uint64_t regidx);
>>
>> +bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
>> +                                  ARM64SysRegField *field, uint64_t newfv,
>> +                                  Error **errp);
>> #endif
>> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
>> index 88cbe8d85c..8e6fae0a4d 100644
>> --- a/target/arm/kvm-stub.c
>> +++ b/target/arm/kvm-stub.c
>> @@ -119,3 +119,10 @@ char *kvm_print_register_name(uint64_t regidx)
>> {
>>     g_assert_not_reached();
>> }
>> +
>> +bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
>> +                                  ARM64SysRegField *field, uint64_t newfv,
>> +                                  Error **errp)
>> +{
>> +    g_assert_not_reached();
>> +}
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 537673177a..f7ca0e0250 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -447,6 +447,57 @@ static bool kvm_arm_vcpu_validate_sysreg(ARMCPU *cpu, ARM64SysRegField *field,
>> #define KEY_TO_REG_IDX(key)     ((uint32_t)(((uint64_t)(key)) >> 8))
>> #define KEY_TO_SHIFT(key)       ((uint8_t)(((uint64_t)(key)) & 0xFF))
>>
>> +bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
>> +                                  ARM64SysRegField *field, uint64_t newfv,
>> +                                  Error **errp)
>> +{
>> +    uint64_t mask, old_reg_val, new_reg_val, oldfv;
>> +    struct kvm_one_reg reg;
>> +    int lower = field->shift;
>> +    int length = field->length;
>> +    int index = field->index;
>> +    uint64_t kidx;
>> +    int ret;
>> +
>> +    mask = MAKE_64BIT_MASK(lower, length);
>> +
>> +    if (!kvm_arm_vcpu_validate_sysreg(cpu, field, newfv, errp)) {
>> +        return false;
>> +    };
>> +
>> +    kidx = idregs_sysreg_to_kvm_reg(id_register_sysreg[index]);
>> +    ret = read_sys_reg64(cpufd, &old_reg_val, kidx);
>> +    if (ret) {
>> +        error_setg(errp, "failed to read the scratch vcpu value for field %s %m",
>> +                   field->name);
>> +        return false;
>> +    }
>> +    oldfv = (old_reg_val & mask) >> lower;
>> +
>> +    new_reg_val = old_reg_val & ~mask;
>> +    new_reg_val |= newfv << lower;
>> +
>> +    reg.id = kidx;
>> +    reg.addr = (uintptr_t)&new_reg_val;
>> +    ret = ioctl(cpufd, KVM_SET_ONE_REG, &reg);
>> +    if (ret) {
>> +        error_setg(errp, "failed to apply new value 0x%"PRIx64" for field %s "
>> +                   "(previous is 0x%"PRIx64"): %m", newfv, field->name, oldfv);
>> +        return false;
>> +    } else {
>> +        uint64_t check_val, actualfv;
>> +
>> +        ret = read_sys_reg64(cpufd, &check_val, kidx);
>> +        if (ret) {
>> +            error_setg(errp, "failed to read the new reg value: %m");
>> +            return false;
>> +        }
>> +        actualfv = (check_val & mask) >> lower;
>> +        trace_kvm_idreg_write_scratch_vcpu(field->name, oldfv, newfv, actualfv);
>> +    }
>> +    return true;
>> +}
>> +
> Hi Eric,
>
> This looks similar to kvm_arm_apply_sysreg_props(), we maybe be able to abstract out kvm_arm_apply_sysreg_prop(),
> which can then be used by both these functions.

done in v10

Thanks!

Eric
>
>> static void set_sysreg_prop(Object *obj, Visitor *v,
>>                             const char *name, void *opaque,
>>                             Error **errp)
>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>> index 2a9cc67035..7a3f499a0e 100644
>> --- a/target/arm/trace-events
>> +++ b/target/arm/trace-events
>> @@ -21,6 +21,7 @@ set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_va
>> apply_sysreg_prop(const char *reg_name, const char *field_name, uint64_t old, uint64_t current, uint64_t mask, uint64_t field_value, uint64_t new) "%s.%s old=0x%"PRIx64" current=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new=0x%"PRIx64
>> nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
>> unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
>> +kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
>>
>> # cpu.c
>> arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
>> -- 
>> 2.53.0
>>

