Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D1F51DAE8
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684044; cv=none; b=hVu1J1dXoEbSFAKWYlbxIGUDzYsphaKlxMvqd6jufjIp4GqPL6OIap7B7OfaJt9JULoRm2hJuZ4uE6guWIMlnzYvyNdxMvuAhzBybEt7y6Yjm+64B8JedXgPsMMtzmHZgwg0TBwwTHuP2e1NAnQhQpSsZ4vK+yLQnKRa3UiZruw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684044; c=relaxed/simple;
	bh=rH6D3wtfhQo6Gq1yRP66NXvmVq5gvlDfRS/TXs6FdXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FgS28Z8jHhLWMgB4WhvDAJG4p5a0tt8mdZJLTFonlpnNzeuKsmHdq+DwtNcpnec/3wUXFWtHy7/l9zGLZn7PzAyy3u9UL5p3O9VFYU3w881s9ZTwER6ADOIJ0V1+iMqHUuGMdvnDeA+MWhC9TIQsvXgext7k16oRQxmBZe2cth4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aqbD9WtB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqbD9WtB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790684041;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0p9GsPyqfCLG6Q3eZpXp3Aciwh0Q5G37w2jNJDtV/CM=;
	b=aqbD9WtB2IcBuwpYBLoftOyqE/rF87M+eMk2XsHudswx2ExzKt1QX16eGm3DxjiXrpGJor
	RT5AP5lhkmNtLafTGZ/UWZKg0zGx1T1bTtCJQG3B2auxd2aSppWizT7WXQ2dzCvDeQHPCJ
	Y8atqzJHD7BJsBETAapgUrvk7KuoTs0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-RBLhrLZLPnWXre9rDNGOJQ-1; Tue, 29 Sep 2026 08:13:58 -0400
X-MC-Unique: RBLhrLZLPnWXre9rDNGOJQ-1
X-Mimecast-MFC-AGG-ID: RBLhrLZLPnWXre9rDNGOJQ_1790684037
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49fcd86b8d3so34690215e9.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 05:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790684037; x=1791288837;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0p9GsPyqfCLG6Q3eZpXp3Aciwh0Q5G37w2jNJDtV/CM=;
        b=nPZiEPrM0kYMPWMYCzRsgHKpYB34jDjk6NBXjLXWRNRGCAkTGJktYlcX4wHR5dmURo
         A7dPnRGDzVPVkFnPD13cFtJz5KxXGe16KQiNiesJJFStNYItpS6o4A4KAYhhRWXm4dNb
         IJpgWRCW5Bzyx/GlIGIEV+oAwtf3D9Buzv96qFG7kXD0YPu2PyI2Bx+OizQNlRd/k2ON
         1SZN2Fqu9apOLzW69yFdh0ucUKCtdo6H33L31YlfoLyC9aeZ9nXhxzcWJP6XUJTIJh50
         sUn1Mk6C9GcjUajgasxRYwCXxZJvj5/8Dli/cJ4tnEOWppTvhO+mtOC3AtrvAIikZJVR
         QRmw==
X-Forwarded-Encrypted: i=1; AKwUvBzUmUmtdmbMLysgJ+erf6y6zM2KlktSqPkhDPPH4RIooOlLsFJRxbKBnDL7LvjbpSRzUa/Jsvo=@lists.linux.dev
X-Gm-Message-State: AFuF++mEr4tyABlmMnwrVv41Xdr9iFWjFUDC4fZXfc/plES1iznGYXX6
	q9BddynC4E7nTmlAWtry2GymxwwQm3OvSTj1SRHFITpgIjSO08R/DwRy+0UKEfHnFFmi0CXvTo1
	8zNjoIhKB+CQXZ0L1yfii1pm6w1Xo7iKVyELR+Pgi722XH7viBQscMiELTQ==
X-Gm-Gg: AYBFou2s+GxHoK4En2qviUsWJYLj2deMmMeBhLpMlWRPrg3E3qimC3PlXAIk9uPR7dM
	DUpA1AODEPEnq13gNC/IpVchkU99CiNiHTGDgi4yG1uWy8pdT6uzTL22hqocmHV6xegjcY+8Ga9
	x4Z3hAIFLQUt3FhO4b2VpxYO10lBsxEApc/uPzghx5gNshbbwUL5VCDHE/r0arVE+b3XrcDvb1K
	nQuKsByKfM2HWVyTeTd2UG2fB22vz5fkTF9F8IJTaBR50BrNCJLDtLa+Cp8gZTGzs7NpCjRgmTn
	/EUTKK6SEUjraWtbqkCWkKmPc+bA91T1TbJ3XJ2HBuhXRSTYnMxFd0/Dow3OM5vKynJwWE+KYqW
	DaJFVMrm9RbMAeAn3ynaT/vlNQYfGRxiCOf04D/f7WEuh2ivB
X-Received: by 2002:a05:600c:c094:b0:49f:f997:7ed7 with SMTP id 5b1f17b1804b1-49ff997807amr116111885e9.11.1790684036870;
        Tue, 29 Sep 2026 05:13:56 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:49f:f997:7ed7 with SMTP id 5b1f17b1804b1-49ff997807amr116111335e9.11.1790684036397;
        Tue, 29 Sep 2026 05:13:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c10c656sm111735875e9.2.2026.09.29.05.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 05:13:55 -0700 (PDT)
Message-ID: <1ce67e00-1037-4de0-84c5-8248fd4d4e97@redhat.com>
Date: Tue, 29 Sep 2026 14:13:53 +0200
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
 <7C929003-175E-450D-885B-CAB243B89645@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <7C929003-175E-450D-885B-CAB243B89645@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tZHo5uWvSnzwlSdE9aZ9XvSgnW1RuX57iWj71SOSswA_1790684037
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/28/26 2:53 PM, Khushit Shah wrote:
> Hi Eric,
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
> Where else?
nowhere, I shall remove the 'both'
>
>> Some ID reg fields corresponding to legacy composite option scope
>> are not writable. In that case we just check that the field has
>> not become writable.
> I don’t understand where the above happens in code.
Everywhere you have:

+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);

I modified the commit description with:

Some ID reg fields corresponding to legacy composite option scope
are not (yet) writable (EL3, MTE, SVE, ...). As such they are not
supposed to be exposed through SYSREG properties. However in the
hypothesis they would become writable, and thus would be exposed
and attempted to be set, we need to reject any setting because no
consistency check is implemented yet.



>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
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
> I don’t see a reason to build property name here.

a field is fully discriminated by the reg name string/index + the field name string/index. So I imagined I could use the prop name directly which has both. Now I can also remove "SYSREG_" if this was you prefer?


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
> This is actually an valid configuration.
OK I removed that

Thanks!

Eric
>
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
> return should be covered in braces.
>
> Warm Regards,
> Khushit
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

