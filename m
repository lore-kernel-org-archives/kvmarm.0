Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D0E383305
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 07:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445693; cv=none; b=r6bZVL7c9iWWWD4ZsRsb+D+kitFogTD8zR0KbLFoEzCQYd8y+A1mdNQPCKBXBCNXUfeZlMbtOmZqEs7N3DxrZsKJ9S1XqX9rJoJafH8fqVCfyK3hlE8VSwl4CFxRJXb9VRzELP79A2eACUXidyUKegY77vq9dyEczXQ78kwcK8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445693; c=relaxed/simple;
	bh=wR/cBAagIRAIKa0HIUJh+XSRRcYw3xTudA3rjMUp+RU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqgnlxfQEpg5aXCZhkoIV30PPsOzy8SPfcoZOm3vV1qdqY7pgm+yhON+f01RV+kQnRwRKl7QMfAHg2nvOq9mripVbur6UgZ0wTJZKCA4eb2pGax1QUcU9gM7Id9ssAE9zbjw5guSOAqYzQ5+Q6oWx0bNbK5/sWAh+YyaQWxONRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W1LIH1p+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1LIH1p+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791445690;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VhqT6V8g++wjj1+3kNOgPTPfwiIr9x2IrkCVTplXw/o=;
	b=W1LIH1p+yZe41wZAvREDuZfboB110O4BjV3/4MHWl8oCZQ5uzNxcWMhq4SuzP/R3Su5apb
	V7xvS2L5SMFDAUrLuaKYXDLsXfvvmr2wfWn5AlV6Ucvnm7TvbDpfvnAc+6a+ga9lAKREBk
	rKXvzuFPilaGUl2oL7UCwDwHwIR18YU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-EMGBacDXNGW1aNEFqOV3tQ-1; Thu, 08 Oct 2026 03:48:07 -0400
X-MC-Unique: EMGBacDXNGW1aNEFqOV3tQ-1
X-Mimecast-MFC-AGG-ID: EMGBacDXNGW1aNEFqOV3tQ_1791445686
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b00febba3so3357474f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 00:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791445686; x=1792050486;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VhqT6V8g++wjj1+3kNOgPTPfwiIr9x2IrkCVTplXw/o=;
        b=jDxnbgsCFJ2EXE0m1n+Kz2Fgm1V7YYZxeBiSvVGwP79xYVo0M6lGMBfourczKeM9L0
         vRpWjVyShOtLmh0INdSgzub8uMF5QeY30uz40xXmNZBcMulckaWB+QW/nnziAPw108ai
         mYTdK/fRikSeGApNqPL9BINZOOIHH+rM+9USbNC9L0yrK8nlmVOG+dWEqwDKDW2SK0NY
         TyA+6mgZi4/BcEhALw1qyIrvmtf+YnUmwuo/P1ZpRzefGPeRIeWbH2dowuHEVtZGeNXB
         BXj7ZW6SqmeKU7BkAmpnrbOPbzPzl3jRjCMQYU8USLdwuKnZAIDhgKtQd5XcyC19stx5
         UTng==
X-Forwarded-Encrypted: i=1; AKwUvBxRXPhNNCoPPQMrrsg8fKcj8m0Ovc30LgazuhGluuqZr3e00klzFcWIXx4Sbe4yUWVRSKc87e4=@lists.linux.dev
X-Gm-Message-State: AFuF++mjH4l7+nLlF4AzTIYMh4G7A2oRqTKbcAw7nxGeliBpPaLE66G1
	Gr+iArPUE4aAGslYpDmI2WVKFWxzghoWbYtgKsAUUVI735sjpau4Denb4NuC2UBZq39MSEilDuX
	+vfZ4MhR6+TKg/zYCFhVCduYqrx7BweAfubaCh7I6pwtYKLerN/NCI9bECw==
X-Gm-Gg: AYBFou1RRsOnCYJ441DUh0Y0lj4X/wuANGm0rItoq2ij37mB1gMyAbc14JDxKa7R0CC
	qtHeP9mGJcQh7XhVTFNK3J+t/oH3JZumrTm4h7h/ixkzgJLZqNoktRR5RaKPdBcTLptR9oX7dXl
	nR5vegeGJgFN1h+sMwVg8pGBQqNfQ1mHUo17xJ2gBG+wACSRd7TNviOa6wyQDRq7N0Cu39OqtT5
	K4P5ouOt/Ed4FjCfYBFyKZB32pgkZOb5tzypxPvGzp/b00TgWMDPJfZeOGD8UyTt6EfjjNIKJjQ
	aZme+d/rno03BacVNStHdxw26uKhiCuYgLbYtb0QoVmj511GH5pRBuBs14TglFgqskKc0GLOj5V
	A4WHGGSgoH3xuKwd8dBa6NeKSqsvNuAMj+SPIzQ8d4tmvh2nI
X-Received: by 2002:a05:600c:83c4:b0:4a1:698d:3044 with SMTP id 5b1f17b1804b1-4a180313c64mr78094575e9.11.1791445686261;
        Thu, 08 Oct 2026 00:48:06 -0700 (PDT)
X-Received: by 2002:a05:600c:83c4:b0:4a1:698d:3044 with SMTP id 5b1f17b1804b1-4a180313c64mr78094025e9.11.1791445685869;
        Thu, 08 Oct 2026 00:48:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18360c5ebsm43425585e9.3.2026.10.08.00.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 00:48:05 -0700 (PDT)
Message-ID: <dc5aecf7-db4f-4b16-92fd-432d663ff900@redhat.com>
Date: Thu, 8 Oct 2026 09:48:03 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
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
 <20260916144721.751810-18-eric.auger@redhat.com>
 <CECAE32E-9A75-4D8D-827D-9F25D026F364@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CECAE32E-9A75-4D8D-827D-9F25D026F364@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yJHMtppcIpaJ3WwaWuyZFnCl2K7Vgf0nXVDfM71hGZ4_1791445686
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/30/26 9:34 AM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Since legacy composite options (such as SVE, virtualization, ...)
>> and new SYSREG props coexist, add some basic consistency checks.
>>
>> Those checks are performed both in kvm_arch_init_vcpu() before
>> applying the SYSREG props at the end of the initialization chain.
>>
>> Some ID reg fields corresponding to legacy composite option scope
>> are not writable. In that case we just check that the field has
>> not become writable.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Hi Eric,
>
> Gave this another look. I suggest moving this to kvm_arm_expose_idreg_properties().
> What I suggest specifically is:
> - Have a list of ID register fields which conflicts with legacy props.
this depends on the definition of "conflict". For instance does 

PMUVer conflicts with has_pmu?

Nevertheless your suggested approach could work for props below which in case they show up would trigger
        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
                   propname);

Thanks

Eric

> - in kvm_arm_expose_idreg_properties() (the new field based approach) never expose fields
>   which are part of the above list.
>
> This way the same consistency logic you have will carry over to named models by just adding different
> setters for the above field.
>
> What are your thoughts on this?
>
> Thanks,
> Khushit
>> — 
>> target/arm/kvm.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 105 insertions(+)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index ddf320d0e6..f52c03745e 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -340,6 +340,107 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
>>     return NULL;
>> }
>>
>> +
>> +/**
>> + * kvm_arm_vcpu_validate_sysreg:
>> + *
>> + * Validate a SYSREG field value is consistent with legacy composite options
>> + * Some checks are not implemented because the corresponding sysreg field
>> + * is not currently writable. In that case we make sure the field has not
>> + * become writable, which would mean the user had the capability to set the
>> + * corresponding property.
>> + *
>> + * return true if consistent. false if it is not, along with an error handle
>> + */
>> +static bool kvm_arm_vcpu_validate_sysreg(ARMCPU *cpu, ARM64SysRegField *field,
>> +                                         uint64_t value, Error **errp)
>> +{
>> +    const char *fieldname = field->name;
>> +    ARM64SysReg *sysregdesc = &arm64_id_regs[field->index];
>> +    const char *regname = sysregdesc->name;
>> +    g_autofree char *propname = g_strdup_printf("SYSREG_%s_%s", regname, fieldname);
>> +
>> +    /* virtualization */
>> +    if (!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL2")) {
>> +        /* consistency with machine virtualization property */
>> +        if (cpu->has_el2 && value == 0) {
>> +            error_setg(errp,
>> +                "Inconsistent -machine virtualization=on and "
>> +                "%s=0", propname);
>> +            return false;
>> +        } else if (!cpu->has_el2 && value > 0) {
>> +            error_setg(errp,
>> +                "Inconsistent -machine virtualization=off and "
>> +                "%s > 0", propname);
>> +            return false;
>> +        }
>> +    /* secure */
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL3") && value > 0) {
>> +        /* consistency with machine secure property */
>> +        error_setg(errp, "%s is set but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    /* MTE */
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64PFR1_EL1_MTE")) {
>> +        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    /* SVE */
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_SVE")) {
>> +        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64ZFR0_EL1_SVEver")) {
>> +        if (cpu_isar_feature(aa64_sve, cpu) && value == 0) {
>> +            error_setg(errp, "sve is set but %s is set to 0", propname);
>> +            return false;
>> +        } else if (!cpu_isar_feature(aa64_sve, cpu) && value > 0) {
>> +            error_setg(errp, "sve is not set but %s is greater than 0",
>> +                       propname);
>> +            return false;
>> +        }
>> +    /* PAUTH */
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_APA")) {
>> +        /* PAUTH QARMA5 address authentification */
>> +        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_API")) {
>> +        /* PAUTH Impl Defined address authentification */
>> +        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_GPA")) {
>> +        /* QARMA5 generic code authentification */
>> +        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_GPI")) {
>> +        /* QARMA5 generic code authentification */
>> +        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
>> +                   propname);
>> +        return false;
>> +    /* PMU */
>> +    } else if (!strcmp(propname, "SYSREG_ID_AA64DFR0_EL1_PMUVer")) {
>> +        if (cpu->has_pmu && value == 0) {
>> +            error_setg(errp, "%s is 0 whereas pmu is set", propname);
>> +            return false;
>> +        } else if (!cpu->has_pmu && value) {
>> +            error_setg(errp, "%s is non null whereas pmu is unset", propname);
>> +            return false;
>> +        }
>> +    /* aarch64 false */
>> +    } else if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
>> +        if ((!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL0") ||
>> +             !strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL1") ||
>> +             !strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL2")) && value < 2)
>> +            error_setg(errp, "%s is < 2 while aarch64 is set to off",
>> +                       propname);
>> +            return false;
>> +    }
>> +    return true;
>> +}
>> +
>> #define MAKE_IDREG_KEY(reg_idx, field_shift) \
>>     (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
>>
>> @@ -2241,6 +2342,10 @@ static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
>>         uint64_t oldfv;
>>         int ret;
>>
>> +        if (!kvm_arm_vcpu_validate_sysreg(cpu, field, value, errp)) {
>> +            return -1;
>> +        }
>> +
>>         mask = MAKE_64BIT_MASK(lower, length);
>>         value = value << lower;
>>
>> -- 
>> 2.53.0
>>

