Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257EF1DE4E0
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779896757; cv=none; b=NMYrWfmfku+hv7+rvZ+ktQvXQwmUke9X/Id42MfV5Du0p42yMevR6G/7MsK2qcKxUqvWhljhEYeiljpRtKMo8MuPntwA39NNfMaq66fkJ/qEjMN/WYITLr0vuqFxSiyExpn/H/a4hhm1Jioqli5ZvTVhY6XSaV84eHGlkft1lf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779896757; c=relaxed/simple;
	bh=N9zlgaizSOK4Iyhms5CxqY0q1UwUbAgqHD++cle33KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RJ/f3/UnUdAkK+H61IGmaI1aOwe9dnC7T2Cuk4DHqFtJdnmB9k9aQX8v1byBTaxhNsElKAkQsCX6R1DPBVacWvPKA5nBFHUxp00rGEj7bs1zcufGi429IsaK0e1v3piV2mSq4Y1olIrKgwcJ26IAWxBhhbkU313vhB0nfFqy0JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FepeHiLH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FepeHiLH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779896755;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9muSlnmiwd2mhBLAgro+7z3m7qZ5WDxt0cKhMmUlN+E=;
	b=FepeHiLH6+Tf+cLp68EeCLq+4ygE7LaA48TJd8oHiILz5W9qtPEcMtxze+RZU5IibXW46p
	9GoEXlHhWFGJTBJSpPpP3blyc7X83pNlYGyC3slMnBeoqzAzs8puCKESKqYCDA+jDw13LE
	YUe7u3aXkLsjcaoKzAkXUy/MtO4y2c0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-lgEey7lKMFmggC8RmxNm7w-1; Wed, 27 May 2026 11:45:53 -0400
X-MC-Unique: lgEey7lKMFmggC8RmxNm7w-1
X-Mimecast-MFC-AGG-ID: lgEey7lKMFmggC8RmxNm7w_1779896752
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4903dcb32f8so51869565e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779896752; x=1780501552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9muSlnmiwd2mhBLAgro+7z3m7qZ5WDxt0cKhMmUlN+E=;
        b=ckPk/v6oNhm8f3PiN7hBYOOpJ8/gT8rqU5NRG98ltfDtD1IOoPX7QEjI1TIMaWikZp
         5ufOW0hE+YYZ3iVpbXI9iRpJSq0MfS0PBeAORTsPZMvuAUKn7m4xN6sQhF93Q1UKn7o+
         dPkuNyqmgB3JVBcOl2ivLVxscQMyq/prAAK+UXiR55HMw1Ll+3mr54lubDm1Usypp8Em
         ogZOergsDk9jP8psK5hBOd0ztG26fYK5dHHRGo9pdTsM6oifrEnQPL7rgXq7onMN9X3J
         LnEQxagfq09kqScHfsz5YfF5B4u+AwSlfkMTLAfvVRyu+ImI+gd67/hqw6fNBuJNO8CD
         nXDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8guEC9eem5uVTp54JhpCvKBUvcUlVDE1v2ect6cfDv38U56hOn0nin3wshedrCJiTEg53aF4I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5Gjs1TNKVA9O1Ahf7zOsC+8WQWXstfZADYKXLFqJAtDXiCaxe
	WemXuNsc3zBevMaXuCnrn8sBEoGU06R617dTUAGcFX0xePqBR7X1EXg5JOB7rmc245vpW8Aiqlp
	x9HY0e5PcVMd6s/CxMiM8wVSlgU8L2H8fUq8XfaK85UVtn1YoD5bmGcZuhw==
X-Gm-Gg: Acq92OFOZPXKWVTExI09OlnNJ4kBVXeRsjZdMIjR/ONYbrUNH0UcntfDp48OSkqkhPf
	X7Q9yEFxzjUNfsABEbZEe3o8Joq/5RO+1wFm2xPvoFnpp+Fi13dcLzvor1o37EacXH8TKB3G1Ez
	0QkIUfs7moiInnjgqSI2h/CLjOaMsD1si2bewiKWg7XLbwsZi4ZQhh8RWFoOos4j/WO7iFE8hrh
	VeTIpgV/i8SKiJqwAoYfg2MHyyNLR9qjCPNVb/y8oMiDUyWQsy49HCu6JiFqg7QCNm+RIvN2oMr
	5Y4eHP1nblI4eOr9hrPnxMZEoNU3UvvljGySrTH1UcTrBF57LmyyWw6UyIccb/MwqvQ2/zyEFyV
	/8Q4tT3VyVjNl2qVr4IeWgXEs2eru6ZPJGfyy4MWv9o5RlLvCqfxlRo0hLOrxybIkYItoGBG8hD
	fkitqx
X-Received: by 2002:a05:600c:4ecc:b0:488:aa33:dcbd with SMTP id 5b1f17b1804b1-490428db91cmr360447585e9.26.1779896752298;
        Wed, 27 May 2026 08:45:52 -0700 (PDT)
X-Received: by 2002:a05:600c:4ecc:b0:488:aa33:dcbd with SMTP id 5b1f17b1804b1-490428db91cmr360446945e9.26.1779896751891;
        Wed, 27 May 2026 08:45:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4908097a320sm27674265e9.3.2026.05.27.08.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:45:51 -0700 (PDT)
Message-ID: <80fa5157-2376-4010-88b2-deb6ab50f87f@redhat.com>
Date: Wed, 27 May 2026 17:45:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 15/18] target/arm/kvm: Ignore some writable bits that
 shouldn't be
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
 <20260519132905.145643-16-eric.auger@redhat.com>
 <E5402D74-AE00-4088-801C-C87A749E17C9@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <E5402D74-AE00-4088-801C-C87A749E17C9@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2RnY-061TJRfG53yOa93hN5ObF6tC2jsyKTCYcA9PLo_1779896752
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 4:46 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>>
>> KVM currently reports some bits as writable whereas they are
>> RES0 or RAZ. This is detected because the code attempts to
>> match those bits against a named field and this later does not
>> exist in target/arm/cpu-idregs.h.inc.
>>
>> Let's silence warnings until those bits get fixed in the kernel.
>>
>> This was observed with v7.1-rc4 kernel.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> target/arm/kvm.c | 23 +++++++++++++++++++----
>> 1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 6373a66bbd..1688cc2106 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -405,6 +405,19 @@ static void get_sysreg_prop(Object *obj, Visitor *v,
>>     trace_get_sysreg_prop(name, value);
>> }
>>
>> +static bool ignore_unnamed_writable_field(ARM64SysReg *reg, int i)
>> +{
>> +    if ((!strcmp(reg->name, "ID_ISAR0_EL1") && i >= 28 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_ISAR5_EL1") && i >= 20 && i <= 23) || /* RES0 */
>> +        (!strcmp(reg->name, "MVFR2_EL1") && i >= 8 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_PFR2_EL1") && i >= 12 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_MMFR5_EL1") && i >= 8 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_AA64FPFR0_EL1") && i >= 2 && i <= 7)) { /* RAZ */
>> +        return true;
>> +    }
>> +    return false;
>> +}
>> +
>> /*
>>  * decode_idreg_writemap: Generate props for writable fields
>>  *
>> @@ -426,10 +439,12 @@ decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
>>         uint64_t mask;
>>
>>         if (!field) {
>> -            warn_report("%s bit %d of %s is writable but no named field "
>> -                        "in target/arm/cpu-idregs.h.inc",
>> -                        __func__, i, reg->name);
>> -            warn_report("%s is target/arm/cpu-idregs.h.inc?", __func__);
>> +            if (!ignore_unnamed_writable_field(reg, i)) {
>> +                warn_report("%s bit %d of %s is writable but no named field "
>> +                            "in target/arm/cpu-idregs.h.inc",
>> +                            __func__, i, reg->name);
>> +                warn_report("%s is target/arm/cpu-idregs.h.inc?", __func__);
>> +            }
>>             map =  map & ~BIT_ULL(i);
>>             i = ctz64(map);
>>             continue;
>> — 
> This is why I feel the generated cpu-idregs.h.inc should also have information of
> RES0/1 fields as in our RFC. These fields will obviously have only one architecturally
> valid value, hence we will never allow user to write something else.
The good thing is it allowed to detect that kind of kernel inconsistency ;-)

RES fields are not defined either in target/arm/cpu-features.h and since
they are not meant to be touched, it was not that obvious to add them.

What would it change anyway, if we detect we have a writable field
matching a RESx field, I guess we would continue raising a warning, no?

Thanks

Eric

 
>
> Warm Regards,
> Khushit

