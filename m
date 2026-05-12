Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3506C36A004
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778598759; cv=none; b=teewjoAKNudjIfLv0N3A7jHwLNUjnTr3LENB1bu2ht+c+72/jfdZ66Z2mupXg6MumT0CeCEBKVltvdVOygK21n9FtDZrx2jhK3JKl/TpmseshBVKfjXSSgWBsmOUAO8esTcsxopJ6Xj++w6tZtrpeVJMs6hzg2c0y4B9QXJ+pQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778598759; c=relaxed/simple;
	bh=mJ6zLI6M9cLlr3CmvobsgT5uMJ9MwkVxohQKtmaFry0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hk/OGRyAA2uQzSj3KsW8R4JO1+z66kX0YwGJwNfRkX52KojKVfiYdSH1vDai9xRmN8QPR1fNmJw4vKFDsjMIbd1v0OgUf24tUffoZcxH/jN3fSShdH6ZQbhicVgBfIn6pOvb+YLHUVOPeAcocLPWSzJyjR93pBI9Ln1AUUY5vXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMbtqDpZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMbtqDpZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778598757;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xHAgB6HV5/4LAPiF6vh00PMIU5wdo+azoQixOlaMg7A=;
	b=VMbtqDpZprd/EPO6PXsZMlcTQKNeOCwoW4I1876L1xEHhPDRxtaAgiaerQfIzPAGWVN+Ey
	cPUQPda/IqlhQJPOckXHt5RQSwAswTihC1tMlwWCEgxf//B5X0SJYqCGaelm7Vmxl7nThQ
	XXSzydgV2b+MoaJD8YHLytfd2Qxw0dE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-D2UJPJgSPV6LKh3p9_UaqA-1; Tue, 12 May 2026 11:12:35 -0400
X-MC-Unique: D2UJPJgSPV6LKh3p9_UaqA-1
X-Mimecast-MFC-AGG-ID: D2UJPJgSPV6LKh3p9_UaqA_1778598754
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4891f97aef0so30771885e9.2
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 08:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778598754; x=1779203554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHAgB6HV5/4LAPiF6vh00PMIU5wdo+azoQixOlaMg7A=;
        b=DgmHCKBxVpOWIrzzln9QK0tflNpD2BMGptmHSSccUUclqGosb5By3MuA8yLOmO0NSk
         xvskDVmhNy+XwMEoudlRSTx1sWZHAem+NQXNntK3NKPHcLSuLh6GLqBk/49Nozv0cmXy
         10FZn8cVJ/6kQ0pPQ+Pg5mlyIlmqQoPp2dZcr9HGH4x4I9TrSpZFPvoyJzZbIqhjCgpH
         IVKPx/rJXCeB0h7fyytP87Owa1XJ2KaUGIAyWnZu7SgVLqw2mrzOUezryj2F3Y3ERfJj
         gutVnbJCzsF+bRN5VVr91fcRJ+pMNlJroN8nWzZwsk61UlxwWIOx1Y4YR59LCpeTkbv9
         oW+g==
X-Forwarded-Encrypted: i=1; AFNElJ9HOUTccXWw9fnMIvgJiusvG5R+VtqlQ+kN+FxTIcngdlOTiEzkC+dYaXMA3h1TTKW8u7QZdls=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOyldteKqQrUvOBCEl+YU81H3edhKzOKvhbBKX1DHks0lTEtAv
	mjk7yehaRL+Fg7NP0B769A1tCt7SbZwITJa+Pt6HJken1FO2hvuVvKp4ve2+aoU6LykZ8WbK+Uk
	hVx8FCiufAf+yTB9ZUoj1TRfP4qh4rpl5ZxPmdUvZDxMVu7mAwKn0YWGsiQ==
X-Gm-Gg: Acq92OE3MUquHiwlpn8S0DWtA3GNyHEwS4EZ1MOdua4qCLkv5+plMzgEy9py5DTlGiP
	uRpi7Thp/Zd2hlbhTV6ZYFd7phXhPexLzo2DbfYd0LhvqHcJ6MQir9RdM6bu1XJoqzByfIRBSRS
	v4zy+IAy26u5l4ckdEsD7/spOId5JQO5dYbac38wNaUYrtXsOaMN5ZnKRLSZnsbF351u7lSQTIG
	cpzMbGOOknrfU3R5libt4LUaviRvJyRzznUogOZD4DgeJdKVulKW38b0PPTEYjgAgSdg4RJ5hVf
	Zv8esVNollJb1Ewr0kC+Vd+MU0eaNmEzUxfIGyMu1qmlx516W+A6OTxKzxTnezgL4RBv6QwM+kj
	rOSyxLaNUJ8Kq0sqM28eT7xwUjk1ZUVPkCp3jkjPDeDefaXsgrxoB0ZkYV0hn2crDq+Y/cg==
X-Received: by 2002:a05:600c:8214:b0:48a:6268:18a9 with SMTP id 5b1f17b1804b1-48e706b262amr240043325e9.13.1778598754000;
        Tue, 12 May 2026 08:12:34 -0700 (PDT)
X-Received: by 2002:a05:600c:8214:b0:48a:6268:18a9 with SMTP id 5b1f17b1804b1-48e706b262amr240042675e9.13.1778598753531;
        Tue, 12 May 2026 08:12:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491f8d4c3sm33029374f8f.34.2026.05.12.08.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 08:12:33 -0700 (PDT)
Message-ID: <7678a671-db5e-43dc-b38f-1376bb0459e9@redhat.com>
Date: Tue, 12 May 2026 17:12:30 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 08/17] target/arm/kvm: Introduce
 kvm_get_writable_id_regs
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-9-eric.auger@redhat.com>
 <CH3PR12MB75488AAC8601BD74D6095FA6AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB75488AAC8601BD74D6095FA6AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uHyayGjhULgcvKsDCPyUl6lzwtPW-iAk64BnhM2Vo4c_1778598754
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/26 12:07 PM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:33
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 08/17] target/arm/kvm: Introduce
>> kvm_get_writable_id_regs
>>
>> External email: Use caution opening links or attachments
>>
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Add an helper to retrieve the writable id reg bitmask. The
>> status of the query is stored in the CPU struct so that an
>> an error, if any, can be reported on vcpu realize().
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu.h     | 26 ++++++++++++++++++++++++++
>>  target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
>>  target/arm/kvm_arm.h |  3 +++
>>  3 files changed, 61 insertions(+)
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index be14a47c35..2aa22360d2 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -866,6 +866,26 @@ typedef struct {
>>      uint32_t map, init, supported;
>>  } ARMVQMap;
>>
>> +typedef enum ARMIdRegsState {
>> +    WRITABLE_ID_REGS_UNKNOWN,
>> +    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
>> +    WRITABLE_ID_REGS_FAILED,
>> +    WRITABLE_ID_REGS_AVAIL,
>> +} ARMIdRegsState;
>> +
>> +/*
>> + * The following structures are for the purpose of mapping the output of
>> + * KVM_ARM_GET_REG_WRITABLE_MASKS that also may cover id registers
>> we do
>> + * not support in QEMU
>> + * ID registers in op0==3, op1=={0,1,3}, crn=0, crm=={0-7}, op2=={0-7},
>> + * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
>> + */
>> +#define NR_ID_REG_MASKS (3 * 8 * 8)
> Probably can re-use KVM_ARM_FEATURE_ID_RANGE_SIZE here.
> Looks like used for the same purpose in:
> tools/testing/selftests/kvm/arm64/set_id_regs.c

removed. The writable_map array is now dynamically allocated in
kvm_arch_init_vcpu()

Thanks

Eric
>
> Thanks,
> Shameer
>> +
>> +typedef struct IdRegMap {
>> +    uint64_t regs[NR_ID_REG_MASKS]; /* writable masks for registers */
>> +} IdRegMap;
>> +
>>  /* REG is ID_XXX */
>>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>>      ({                                                                  \
>> @@ -1054,6 +1074,12 @@ struct ArchCPU {
>>       */
>>      bool host_cpu_probe_failed;
>>
>> +    /*
>> +     * state of writable id regs query used to report an error, if any,
>> +     * on vcpu model realize
>> +     */
>> +    ARMIdRegsState writable_id_regs_status;
>> +
>>      /* QOM property to indicate we should use the back-compat CNTFRQ
>> default */
>>      bool backcompat_cntfrq;
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index d4a68874b8..f06a60804d 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -51,6 +51,7 @@ const KVMCapabilityInfo
>> kvm_arch_required_capabilities[] = {
>>  static bool cap_has_mp_state;
>>  static bool cap_has_inject_serror_esr;
>>  static bool cap_has_inject_ext_dabt;
>> +static int cap_writable_id_regs;
>>
>>  /**
>>   * ARMHostCPUFeatures: information about the host CPU (identified
>> @@ -499,6 +500,37 @@ void
>> kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>>      env->features = arm_host_cpu_features.features;
>>  }
>>
>> +int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
>> +{
>> +    struct reg_mask_range range = {
>> +        .range = 0, /* up to now only a single range is supported */
>> +        .addr = (uint64_t)idregmap,
>> +    };
>> +    int ret;
>> +
>> +    if (!kvm_enabled()) {
>> +        cpu->writable_id_regs_status =
>> WRITABLE_ID_REGS_NOT_DISCOVERABLE;
>> +        return -ENOSYS;
>> +    }
>> +
>> +    cap_writable_id_regs =
>> +        kvm_check_extension(kvm_state,
>> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
>> +
>> +    if (!cap_writable_id_regs ||
>> +        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
>> +        cpu->writable_id_regs_status =
>> WRITABLE_ID_REGS_NOT_DISCOVERABLE;
>> +        return -ENOSYS;
>> +    }
>> +
>> +    ret = kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS,
>> &range);
>> +    if (ret) {
>> +        cpu->writable_id_regs_status = WRITABLE_ID_REGS_FAILED;
>> +        return ret;
>> +     }
>> +    cpu->writable_id_regs_status = WRITABLE_ID_REGS_AVAIL;
>> +    return ret;
>> +}
>> +
>>  static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
>>  {
>>      return !ARM_CPU(obj)->kvm_adjvtime;
>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index e7c40fb003..b22a56fc17 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -240,4 +240,7 @@ void arm_gic_cap_kvm_probe(GICCapability *v2,
>> GICCapability *v3);
>>   */
>>  char *kvm_print_register_name(uint64_t regidx);
>>
>> +typedef struct IdRegMap IdRegMap;
>> +int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap);
>> +
>>  #endif
>> --
>> 2.53.0

