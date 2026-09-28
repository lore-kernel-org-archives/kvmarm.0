Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B192ECD32
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790598882; cv=none; b=UpiLsFxS4y+eLHFUmwc3yOI3cl8YTVA2TFeXhlerHQzRLHIOFN9OXfgA7CsUpYbn3iGdKtblRT8LT9D05hWq4Ja09HG6tyGeyTUZtSCFXPID5PaDScn8bZ4I9mploRB/EhZ7ZBq84cEEILrByGJt4Z4ifyR8fRKEVLokOfCaw9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790598882; c=relaxed/simple;
	bh=/BSWmXydNTW57WSAKLPD6prDhap006hX3usxhzl/j7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LVsDvYfSYmqArHhh1nI1dYG94rERlAb9Z3if+h2ucnyAA4fZgcQ4nwXKBY/VylbQe7QmXpu2lhjX2vI+YBYUO7q4rKX4G0jwr6OWtIWvUZVJS13OKyvQaKGlFRMjy01abm3y5QcIOtuv2ebo1k8NuzjcorpAz7uKFQ2VlO+/Gqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NR61W59g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NR61W59g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790598880;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZAeYsL9d3qjmBo71QrP8m38Q962rFexlqL7pjbHsys=;
	b=NR61W59gU7TuNAhBvKUztMlalFrr5Cw4lbCyoCdx0Iq2Hc87edT3WgJ9AxLAaDMHM66j+M
	UQCYXOXqZ3O0NGCUnGfrrqxOKCZbPfttHeNOTAx6JW+EqIyOSefNYksIeFKsCRx487gnXw
	oVBSq8+sc0/TXsevVNaLnQ1y0M5VsWQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-yJoM6GN5NiWyGFrCzu-aAg-1; Mon, 28 Sep 2026 08:34:39 -0400
X-MC-Unique: yJoM6GN5NiWyGFrCzu-aAg-1
X-Mimecast-MFC-AGG-ID: yJoM6GN5NiWyGFrCzu-aAg_1790598878
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4843227cfcfso2791571f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 05:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790598878; x=1791203678;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cZAeYsL9d3qjmBo71QrP8m38Q962rFexlqL7pjbHsys=;
        b=AM5yYuFfSeUTxG4cjv7xCatanUE5qH5yyg0gZYOiNzDiLfMjAACYIcl0GOjPqPZIkh
         LsEuD4PFFVrEW4zwIiHDSueU/MuhummfLd2dmzv3mj+Rvqbg3zVyoCQwIn1b23EYnku1
         xM+tRShcr7INv7SMIA/XMZBjznyj/qeiJs6PWHu54gnmMrbcg2Ez0VhdmpfDjXapKTcd
         R1g+RhzNME7a472oEro99YQncXBIYgow8SlKDRIGnpafTP3+ldEunyLjG6qZyFa3oEqn
         hB+TNJmfFEAmw4DAyCQsmB56SfpKkixn1eldkMAKIx3xBj1nQIMW/cJ99e3shOJCwvzW
         yTOA==
X-Forwarded-Encrypted: i=1; AKwUvByNKwTbb8yJs5zZfksHsL2naRTYgZe91eEnON6Cpl0SwuzeMRuQ0+hoNHb8ZWZNs3CgX9bQxys=@lists.linux.dev
X-Gm-Message-State: AFuF++m82P1aV5CFgsYyNLlPsMhMeVYlXbO3MiABMYkzwFQ8pAgtTEgN
	vAMI+NdtnLaVhVyHACVfZSXtWXdZ/NlKPACpmJEhOgYHz2wsREcQbZEDw0M6S61E7B6BwndN7pH
	y/61PIlKtRHlcbESNcF/7nxONF4zTosDFHkhzGV92nts1fddfiEVV+yj6lA==
X-Gm-Gg: AYBFou03fUOzD9iQGy6Kf8y9NHRoK8OSNJ/M5YVFm9MzKBjfH+gAHyOnlnZX5cTCWoH
	3Qf3jy8MCTGc9YybwJc6xFjT+dpj1ajcdssL8VicKMWRt+JbqUsufSz7/P74Gux6axiXDUqN4SN
	nkM07ZBk/4vSKNRVUzNtNLAY6rS4+b6/9JNyObTOCzhHA/oGiylJT6wdKGgBw07It44lBycjFrT
	411kNSOJDspLEbRRj2PUCHZLGlDJHN3egCv5LPjAe7yGMxf+yzp4fOgEpZONoQQV+FSQHtk8gKM
	cuLcijukLBq9TN8prMeJNHHK9hr5Zkxf20o3NqTfUe4yjy00EySfFUxRMBdhwXaT5jqz7whyv4Y
	lyAotTJthg7Tf7TwjmhttP50PTDOhYagzhcmd4YhJVjvQmCz2
X-Received: by 2002:a05:600d:864d:10b0:4a0:592:690b with SMTP id 5b1f17b1804b1-4a005926c0emr28887335e9.8.1790598877650;
        Mon, 28 Sep 2026 05:34:37 -0700 (PDT)
X-Received: by 2002:a05:600d:864d:10b0:4a0:592:690b with SMTP id 5b1f17b1804b1-4a005926c0emr28886895e9.8.1790598877230;
        Mon, 28 Sep 2026 05:34:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-489bd7b1df0sm6841186f8f.31.2026.09.28.05.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 05:34:36 -0700 (PDT)
Message-ID: <c70d8f51-958c-43cd-b07b-96f2a4fada6f@redhat.com>
Date: Mon, 28 Sep 2026 14:34:34 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 10/26] target/arm/kvm: Retrieve writable ID reg map
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
 <20260916144721.751810-11-eric.auger@redhat.com>
 <FC2C35F5-6C1D-4C8C-B4E2-9D2EB1924445@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <FC2C35F5-6C1D-4C8C-B4E2-9D2EB1924445@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: arGCkQpjN-8cxxBP9vzm2hS99X_ValqnXiWfxy9NEXY_1790598878
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 9/25/26 2:37 PM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Add an helper to retrieve the writable id reg bitmask.
> s/an/a
>> then retrieve the writable_map array and dispatch it in the writable_map
> s/writable_map/writable_mask
>> fields of arm64_id_regs[] elements.
> s/fields/field

fixed
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>>
>> v7 -> v8
>> - added kvm_enabled()
>>
>> v5 -> v6
>> - use arm64_id_regs[].writable_map
>> - squashed 2 commits (helper + user)
>> - removed stub
>> ---
>> target/arm/kvm.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 61 insertions(+)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index ed99be7fd8..c6eac41991 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -28,6 +28,7 @@
>> #include "kvm_arm.h"
>> #include "cpu.h"
>> #include "cpu-sysregs.h"
>> +#include "cpu-idregs.h"
>> #include "trace.h"
>> #include "internals.h"
>> #include "hw/pci/pci.h"
>> @@ -51,6 +52,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>> static bool cap_has_mp_state;
>> static bool cap_has_inject_serror_esr;
>> static bool cap_has_inject_ext_dabt;
>> +static bool writable_map_dispatched;
>>
>> /**
>>  * ARMHostCPUFeatures: information about the host CPU (identified
>> @@ -273,6 +275,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
>>     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
>> }
>>
>> +static int kvm_feature_idx_to_idregs_idx(int kidx)
>> +{
>> +    int op1, crm, op2;
>> +    ARMSysRegs sysreg;
>> +
>> +    op1 = kidx / 64;
>> +    if (op1 == 2) {
>> +        op1 = 3;
>> +    }
>> +    crm = (kidx % 64) / 8;
>> +    op2 = kidx % 8;
>> +    sysreg = ENCODE_ID_REG(3, op1, 0, crm, op2);
>> +    return get_sysreg_idx(sysreg);
>> +}
>> +
>> static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>> {
>>     /* Identify the feature bits corresponding to the host CPU, and
>> @@ -480,9 +497,53 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>     ahcf->features = features;
>> }
>>
>> +static int kvm_arm_get_writable_id_regs(uint64_t *idregmap)
>> +{
>> +    int cap_writable_id_regs;
>> +    struct reg_mask_range range = {
>> +        .range = KVM_ARM_FEATURE_ID_RANGE,
>> +        .reserved = {0},
>> +        .addr = (uint64_t)idregmap,
>> +    };
>> +
>> +    cap_writable_id_regs =
>> +        kvm_check_extension(kvm_state, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
>> +
>> +    if (!cap_writable_id_regs ||
>> +        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
>> +        return -ENOSYS;
>> +    }
>> +
>> +    if (kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range)) {
>> +        return -errno;
>> +    }
> I think just doing return kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range) is enough.
sure
>> +    return 0;
>> +}
>> +
>> void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>> {
>>     CPUARMState *env = &cpu->env;
>> +    uint64_t *writable_map;
>> +
>> +    writable_map = g_new(uint64_t, KVM_ARM_FEATURE_ID_RANGE_SIZE);
>> +
>> +    if (kvm_enabled() && !writable_map_dispatched &&
>> +        !kvm_arm_get_writable_id_regs(writable_map)) {
>> +        for (int i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
>> +            uint64_t mask = writable_map[i];
>> +
>> +            if (mask) {
>> +                int idx = kvm_feature_idx_to_idregs_idx(i);
>> +
>> +                if (idx < 0 || idx > ARRAY_SIZE(arm64_id_regs)) {
> Bug: >=
> Also, this condition will never be true, as get_sysreg_idx() asserts out on an unknown ID register. Which probably
> should not happen.

removed
>
>> +                    continue;
>> +                }
>> +                arm64_id_regs[idx].writable_mask = mask;
>> +            }
>> +        }
>> +        writable_map_dispatched = true;
> What is the need of writable_map_dispatched, why can’t we use arm_host_cpu_features.dtb_compatible as below?
Using a dtb related condition to decide whether we shall do the writable
mask dispatch looks far-fetched to me, although it would effectively work.

I would rather keep it as it and wait for other comments if any.

Thanks

Eric
>
> Warm Regards,
> Khushit
>> +    }
>> +    g_free(writable_map);
>>
>>     if (!arm_host_cpu_features.dtb_compatible) {
>>         kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
>> -- 
>> 2.53.0
>>

