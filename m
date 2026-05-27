Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF0E37BE70
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897087; cv=none; b=A0Q/0BrKjxiGuv7Ha6XdvqkEEhjUpYP9JkSpVzYOer5oceAkCA3imPw3c9wQYw0tegsZDZE1hVmwtixbe1Oa5DYhtqlKjUdCyrc6F7ziiF8OAEx4H6uVNV3sScKpMqRPq8BE/DUva4ADBAUYivSxBwzp2m5JAJHwtO6JC4Ko1h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897087; c=relaxed/simple;
	bh=NpWeYvLTRKpoSKZrTZPRCDws+jOWqLVyytaA+mLihZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQxpR64TKQ8lcTZpi4IyXHheqQjfp0nzYaYJdD2CVv4iN2btTZJxk6T+L6K+VMdvEvHnW14I79lMgtkVJxthbtfW7fXaL1BpMNQyJOKt8TotDbiza1Sw07Z63yxgiOrVL8R4egy+chQzijY+A9g9rg1KZ2+psOyAKfcBbkoZWhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XiuwVA+F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XiuwVA+F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779897084;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TNh1EiqEZh1MvxlmuCepdse4lX9bTcWUvyZGOXaCV84=;
	b=XiuwVA+FiWJcB7v3Yq6FYlYoXni37nE1uFh+ReSuy5KvDoMF07pRokI1Aj3iax9pSEFeyJ
	zm8kP3/vERhotnm/YP9dSZPyqLUcMy5yK9I0uNIX7HD9TVIM7Mbc4yDC8KLWfz158VxQD+
	DYgsZORssMgO+C8rs6c144h9jx11uFM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-DTYAYHMFM96id3_YNrGvAw-1; Wed, 27 May 2026 11:51:23 -0400
X-MC-Unique: DTYAYHMFM96id3_YNrGvAw-1
X-Mimecast-MFC-AGG-ID: DTYAYHMFM96id3_YNrGvAw_1779897082
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4904ee02e72so40307895e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897082; x=1780501882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNh1EiqEZh1MvxlmuCepdse4lX9bTcWUvyZGOXaCV84=;
        b=NttQpzZErm6bNKU1swORSOdT1Ky4ddXHM1j9gr02yU5/6DDVh/ixM3kZY6OhBkd2E9
         3rSIhL1R3BRe8S/qRH4NnumOsnuLwwqk1YJqBzfq6LDxDjFhmQfbuP8VkhLVIKV9Tt5U
         5A/PxKoCFe+rkEi+pnNiRWkHEp8CTCSG6t1JplQ8FtjJSM21Yw4pxcIZo8BFNRL7cMsu
         06VgkVOovZaL1WRV+WKTttENwPe3L6UNqF5lBwTPyIq4owST3IW51j15yRKvkC6aKuiM
         cqzeifjx683ac8EH3L22YD1NnMle6VYAghuq8hcfebdc7AoM1sHNIHVxILqY2Q7k6km7
         r6jQ==
X-Forwarded-Encrypted: i=1; AFNElJ/eAYOh/pH3i8ZDCyDPpRDYuiClB+IBSv7kfNXP5fiB7hMF18C3cPxve4oPRemXPyBVonFHRO0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbAqlqCyVP1JnKM5TvAUJqf4mK9s24c3JNYYyiurOPYkP8nl50
	eD1eUMtm0BnYFa/a9mXwHjQWHvtDSuN4GcMIiLbDDvRZrwkUKfleXrGvkHDpVDBo10NXepX1JwR
	XoDdIFHwJAhP+/yIzc3cS1C1W42C3JAOxPW2DXymbJXqoYjJFYPLTu7RtUg==
X-Gm-Gg: Acq92OFjcQ1/H6elavV6n4HwuO8AzFhmKGzoKmpvUx2m2J0RumZ9nYGoLv6dYyI4Lko
	MtN85HMhYuXDENZaF/sntqOZFQQDcD2tq17pM+Vv9kwQfKMXrglsGLc4L/MhARUDlkdZnIJvQQt
	hOEkb7p8cdA/BJ8YJQ+yPN069TBfqj72Um59BM3SS1z/FRnZaG8T2w2cSFzoInP23leXAg0IMYI
	uyTmKC3rovlSN44jCT/tql2SOybrp+KQqYjE8pkw3/m7yGaILL3zIbFnk+FOa/tu6e+6WQn9FFS
	k/2/nkdjeGGDFcDehZEf+Ta2veYB4tcHZpm1pRNhUeDNV3TJUyGqJCUS/s+UQspkGgsmnsJQDMB
	2a5W0gSv9PokMOqBiXCVjL8cMnjJa/luTityZp85bb9LfrtzFFipbH1cYrUATnUMk9uCo68v2Ul
	8lGpJX
X-Received: by 2002:a05:600c:35c8:b0:490:45bb:8dd9 with SMTP id 5b1f17b1804b1-49045bb8efdmr419559335e9.8.1779897081744;
        Wed, 27 May 2026 08:51:21 -0700 (PDT)
X-Received: by 2002:a05:600c:35c8:b0:490:45bb:8dd9 with SMTP id 5b1f17b1804b1-49045bb8efdmr419558785e9.8.1779897081304;
        Wed, 27 May 2026 08:51:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5a2a73sm6716947f8f.22.2026.05.27.08.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:51:20 -0700 (PDT)
Message-ID: <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
Date: Wed, 27 May 2026 17:51:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
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
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3g5J1G7s-sif1R5X4ovYSqAHoedN1igDLU2bkRDqc78_1779897082
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 5:16 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
>> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
>> of writable fields for all ID regs, expose uint64 SYSREG properties
>> for all the writable ID reg fields exposed by the host kernel which
>> can be matched in target/arm/cpu-idregs.h.inc.
>>
>> Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
>> being those used ARCHMRS Registers.json.
>>
>> When such properties are set, they override the default field value
>> retrieved from the host and reinjected into KVM. Then the actual value
>> being applied at KVM depends on the register, ie. it can be sanitized.
>> In case the field value is rejected by KVM, the vpcu init fails.
>>
>> Anyway there is a first attempt to write back this value into KVM.
>>
>> Then legacy CPU options (virtualization, secure, ...) can still
>> override the previous value. So low level IDREG field properties
>> apply before the legacy ones.
> No code to handle this right now right? Anyway I just think parse the
> props in order they are specified in command line. 
Actually I think it works that way already because we first override the
values with ID reg field prop values and then apply the legacy composite
props
>
> qmp cpu-model-expansion is a weird case, it defines an order in which
> props are processed.
Yeah that's effectively something that needs to be further tested

Thanks

Eric
>
>> An example of invocation is:
>> -cpu host,SYSREG_ID_AA64MMFR0_EL1_ECV=0x0
>> which sets ECV field of ID_AA64MMFR0_EL1 to 0 (enhanced counter
>> virtualization).
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - get rid of ret local variable, dynamically allocate and free writable_map
>>  here
>> ---
>> target/arm/cpu64.c | 11 ++++++++---
>> 1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
>> index f2edbfc437..e0e1ff6cfb 100644
>> --- a/target/arm/cpu64.c
>> +++ b/target/arm/cpu64.c
>> @@ -37,6 +37,7 @@
>> #include "hw/core/qdev-properties.h"
>> #include "internals.h"
>> #include "cpu-features.h"
>> +#include "cpu-idregs.h"
>>
>> /* convert between <register>_IDX and SYS_<register> */
>> #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
>> @@ -851,7 +852,6 @@ static void kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
>> static void aarch64_host_initfn(Object *obj)
>> {
>>     ARMCPU *cpu = ARM_CPU(obj);
>> -    int ret;
>>
>> #if defined(CONFIG_NITRO)
>>     if (nitro_enabled()) {
>> @@ -865,13 +865,18 @@ static void aarch64_host_initfn(Object *obj)
>>
>>     cpu->writable_map = g_new(uint64_t, KVM_ARM_FEATURE_ID_RANGE_SIZE);
>>
>> -    ret = kvm_arm_get_writable_id_regs(cpu->writable_map);
>> -    if (ret) {
>> +    if (kvm_arm_get_writable_id_regs(cpu->writable_map)) {
>>         g_free(cpu->writable_map);
>>         cpu->writable_map = NULL;
>>     }
>>     kvm_arm_set_cpu_features_from_host(cpu);
>>     aarch64_add_sve_properties(obj);
>> +
>> +    if (cpu->writable_map) {
>> +        /* generate SYSREG properties according to writable masks */
>> +        kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
>> +    }
>> +
>> #elif defined(CONFIG_HVF)
>>     hvf_arm_set_cpu_features_from_host(cpu);
>> #elif defined(CONFIG_WHPX)
>> -- 
>> 2.53.0
>>
> Warm Regards,
> Khushit
>

