Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8827D4119E5
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 08:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786435865; cv=none; b=jiyJ88kO0CnnB2tlcqeM91U0D/sW5LTbhrqFOJ3Sbf2PMOQ8pB0bH6jokRyBW0rsQOGpNzXFGXnE0xKPNinD39h6UgsNAmqEUhxO1jIdUggvaN9kxZeBvM9Wh3myUTcuf0aNvu5gqIxkqZtR7OjeT+ERE188kyldxBvClDqKTBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786435865; c=relaxed/simple;
	bh=2kWB1zdQLxJopJW8QDZXLw5tFUIcuoAkbTonR3We1AQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jTth8ldrJRxbfgYC2nrs1eJ2pFiqLjQuTtIVwgQeyylKXnGLCFjfPBTODP5ysAaKZylgoLCy2bqXwNKBkBNTHOvxtxTg39f8jF88PVRv46vN5jPAD6T4TXXStV3Z5Oz5YKjyKVqTQH+lPJp6CgtGn16auuinjHMgZK6AUKAmzw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLXiBiyo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLXiBiyo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786435862;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCqV+LwYeH1TzbOC6x2tcguj3jnVdShCKf3wQhrW4jI=;
	b=WLXiBiyopXLcDBpMxvSkZBYtyX4Ipyp9qZe1CNWz4KfwjfctbK+70PWph20TDgp2oqOQwl
	dYKcfR5tamqNtjEKipwk+2z2iqPcvlRX0P3k+xBcXJF+HmctHp/MVe24RstPJW8Hm5Qda1
	A2ScpMf3H+7b4pwkDLt/OxbTRlPl/tQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-LQxI0lpiPYyDheeurAXXEQ-1; Tue, 11 Aug 2026 04:11:01 -0400
X-MC-Unique: LQxI0lpiPYyDheeurAXXEQ-1
X-Mimecast-MFC-AGG-ID: LQxI0lpiPYyDheeurAXXEQ_1786435860
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-492488f8583so22371495e9.2
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 01:11:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786435860; x=1787040660;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PCqV+LwYeH1TzbOC6x2tcguj3jnVdShCKf3wQhrW4jI=;
        b=Pkj3+6wJJdQQDfnVhJTqy3/7vcqH2o5z2UoLnZ+PsLwxIiouuUoNWK8vYsbAI9r26e
         veuRSuir+T1KQrQt5wbfGRDOYHz3903bvgkaK/gAZTn5m33/4md1Cb8QIBzPGq88efPT
         GUPYuROgPIozyl1eWXuv5hGVNS6KcTDgob5rBIq3W4AoLJPZR3rfE+3wcSmV/VL86NpI
         +qczcOk5U1AIJKiXFcl2Xs9jI1z6WtPhPUPngfzfu9ROKPWZgLwB+pgyigZHBAq9S9SU
         2Z8nKcU5GQjoBfp1D+3Q3yee5l5wZ9tViB0PnGGI2gs2Vu/9DVAO06qMO/qzXkbv0CnT
         V6Nw==
X-Forwarded-Encrypted: i=1; AHgh+RrlghFwSSMLF6BaJ9niwB1Spa64YORWCuCF4FeY3SLlpnac2Q00Oa7XREl7IhZJ1NG0Vj/KoGU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP6C4kUxbH9vn32UfPPGR3cZu2UIlb/DF6iAUAPVoq02fpOr2z
	DPLrIqsIrvq6YvHbn+8twN4v3Jo2T2hX4+93uPQRwXB3k5fGi8OzO8oLAwkD2rE4cyQ37dCnWPC
	KNAB3kOoiPDn1GALrn2uQvjsN+xfxVEafHqqBhljBMmMSY7m9H3CNTfLOIw==
X-Gm-Gg: AR+sD13lfgykHBWPKxybNCDxPkBdvmeUY2qa0OmhorGYoqCIPT54YRjWYxIaDjvnMHw
	CV2hghrrzYdgytu6Elv7lUjVb+S6RJQz70wpnAQZwEBmTbF+oqF3YNtR2WGAfahQoijYVgHkgHf
	H5Rh1ef6RtASV0elNl9gm1iWTEU8urfv0yyrwBQoNK24/PgSf5yK9rln83tOm8qAAHVWYIeopP0
	itwuqEbcfjeP68mqnF/tKiL5+Ir6ncaGJ0po5xXXJI8I6zRU5xH+zfO7e7iGWhEQe6UHGgi4hls
	Bc+zWGbmHha8si1uM3qxHKQsy7XaQGANoUx+kfxtHsQX8eLv56OImGAG6/g/hXdRIhNsZvmnjVX
	M/CgYrA4DaZOurZh7Px9cUbwWkGuiX1ggn3jyyr3aahGbL6uL
X-Received: by 2002:a05:600c:4585:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-499784612aemr23515525e9.10.1786435859997;
        Tue, 11 Aug 2026 01:10:59 -0700 (PDT)
X-Received: by 2002:a05:600c:4585:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-499784612aemr23513965e9.10.1786435859092;
        Tue, 11 Aug 2026 01:10:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49977e86b55sm41224385e9.4.2026.08.11.01.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 01:10:58 -0700 (PDT)
Message-ID: <de4f28a8-5f6a-4675-8daa-327ee7d938d7@redhat.com>
Date: Tue, 11 Aug 2026 10:10:55 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 10/18] target/arm/kvm: Retrieve writable ID reg map
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
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-11-eric.auger@redhat.com>
 <650A3325-5A8A-477A-9E60-D1D02363FA19@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <650A3325-5A8A-477A-9E60-D1D02363FA19@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C_aLPTdpwX49en44-WzuKXBdRP53SMJ_7zYs9yFUh5U_1786435860
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,
On 8/6/26 6:52 AM, Khushit Shah wrote:
>
>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Add an helper to retrieve the writable id reg bitmask.
>>
>> then retrieve the writable_map array and dispatch it in the writable_map
>> fields of arm64_id_regs[] elements.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
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
>> index d40a6a9859..d270f9870e 100644
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
> This should probably be gated with kvm_enabled()?
>
> qtest-aarch64/device-introspect-test fails on my aarch64 devvm, which does not
> have KVM.
Thanks for the report.

I will fix that in next respin

Eric
>
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
>> +    if (!writable_map_dispatched &&
>> +        !kvm_arm_get_writable_id_regs(writable_map)) {
>> +        for (int i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
>> +            uint64_t mask = writable_map[i];
>> +
>> +            if (mask) {
>> +                int idx = kvm_feature_idx_to_idregs_idx(i);
>> +
>> +                if (idx < 0 || idx > ARRAY_SIZE(arm64_id_regs)) {
>> +                    continue;
>> +                }
>> +                arm64_id_regs[idx].writable_mask = mask;
>> +            }
>> +        }
>> +        writable_map_dispatched = true;
>> +    }
>> +    g_free(writable_map);
>>
>>     if (!arm_host_cpu_features.dtb_compatible) {
>>         kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
>> -- 
>> 2.53.0
>>

