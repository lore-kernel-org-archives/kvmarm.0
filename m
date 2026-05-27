Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C91037F8B1
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897320; cv=none; b=ikeA7RZjoI3nAXr5KtS3wP3WfSoWSVxbExp4aDdKlYpueOJwfoHcAluP/AaaTiqnjd9RAZ+8hzjJbVcoi0BBXU9abW9d0H7elUW6YUhkM8fLmgiDLGJBMgOWsWugxZBZauJjk6b7wuj3UAl6Y9V/1SZXs59P8131BE3olRq55vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897320; c=relaxed/simple;
	bh=lA6fNZeLbMqhe4+lNGJiekDSNsjlJOkbal8HcuDjGU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AP34fo37UnYx6EZsHCjQKjWiUd4BFlt4MGeh/Z/xU3Sz4fLnjaMSPBpgy4YVqTx+Z41sIFCKuJmebhoO07NYfRmDu0wHS4YIAnHOSM+EJJMRt38jqmo2d8kzpB1Edbnjw90LJBEyRC7IMDgPj0flt42R57o7DM8NVUcBSzo3USk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hr4eZ0l+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hr4eZ0l+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779897316;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9xue6t6Y2IH3Dy0p/6rrAI0rQmnyMyM6T6+NiRWyUY=;
	b=hr4eZ0l+iPhNPlo5LTg2goPrpTEP5BPxuWs7Tnrq45PBqxUecLUqB68jeVxIV3ev+D0G7i
	TrleHqyTByIT/5fuEqCa3/WlcJtYPbiPVWBTL8Ol7OFFAijIkWGj6RGGnKKZiZ4ed3byk2
	JMVqRDPRZn2/ArMqeOoPjtwTcpJJ+Hc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-HkFQKOfzN9On0EYxA_Vq7Q-1; Wed, 27 May 2026 11:55:14 -0400
X-MC-Unique: HkFQKOfzN9On0EYxA_Vq7Q-1
X-Mimecast-MFC-AGG-ID: HkFQKOfzN9On0EYxA_Vq7Q_1779897312
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44f65835b77so8366405f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897312; x=1780502112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9xue6t6Y2IH3Dy0p/6rrAI0rQmnyMyM6T6+NiRWyUY=;
        b=qt1PctosNakdHIzpk6E9Y/3ctuw1HSz4CZYcE/15Z2tDtEM0h7+0QZNrZJgg9mIDvc
         oGm1CCsLriinofW4NblPNC/6tmgHiHmcdktMWJVjrgjFWmSq5fDCAB/EoEylK5e1J54c
         j8GBIj2VMo2/aOT31FW0ba45MnWvEVwTlq2AzqW50QKWcMKG0iDn/71sloQ3BJO1G4ns
         zyLifXJBNfUEUw+hemQXXPonCX7jARXP73FNdswkHo3JYNKbOjibHYTJX0/JDze3DRC4
         580dst16JUXSTTTJlgFuRVcL/DNFnwD57KXM0fIflB4IJnNR4TEI1eftDeNsRD+Kpcv+
         K1MQ==
X-Forwarded-Encrypted: i=1; AFNElJ8SySs/NCLr+paD+Gp3kNq8RbBFlQXuKyC0J3rhRs1fPRjtEvEQ+XqR8s6tUh9fYd8ONZlDIRE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6kfICNVu8THDKK95SjNR6+5MWJ21lShhNJKqlwlJxr8WWU9Ab
	X24jReOM9BOl537B58P0fvVRHMCDepQiz6J8cnz/kHaw4m3OrYJwdcTQNRV5FWcVLOuNSSsjuaE
	E8keUmdoZ5k0nG5TKrdlP8RxUkrNgQVsP8Gla4hdiiW9b9I4tCmLAmBZNKA==
X-Gm-Gg: Acq92OFEXAwhja3Ox2oA2kElhfsaJ4jDfm0Rnlw6kf9+WaseVr9vnlZF9bPfzGP1TKw
	r9xW7qdP6lITFQoSWtGsLPHIHr4yZUW9BqlXoJ4UJUH/e+DBlP8sIp1viIAC1JQ7cluY52ioudL
	U0OsCP1fDdTxWiG7VGMNtSFonMiVnzIOjpUjQt5C+f/+16okP04mz5LcfsDwris+3nve/vhzjkB
	SX13wcqIaHFMOq2oFnCcFh4+S71CaK6GixJITxcNl9XQew8zK3xeXH334sK2YmeOMMlfpObp0t8
	xfDQ/Yy/pici9ufbP6dlBGEdVjMQG/C0nyLkGBaFyB+7PR6/8U0VaUaiG0J64dMm8RNkngtDK/X
	EKLS6NT9F5O8zhRYei6l3nA9cJeYu0qL/zAHj6k31G2UPXH8gzjygpAbhhX5I2ELEqKLXuQ==
X-Received: by 2002:a05:600c:530c:b0:490:5527:3be2 with SMTP id 5b1f17b1804b1-49055273be6mr306169805e9.32.1779897312454;
        Wed, 27 May 2026 08:55:12 -0700 (PDT)
X-Received: by 2002:a05:600c:530c:b0:490:5527:3be2 with SMTP id 5b1f17b1804b1-49055273be6mr306169135e9.32.1779897311991;
        Wed, 27 May 2026 08:55:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb548dfasm6528455f8f.4.2026.05.27.08.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:55:11 -0700 (PDT)
Message-ID: <a72e17f4-0afa-4aab-9fbb-8ed5d806619a@redhat.com>
Date: Wed, 27 May 2026 17:55:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 17/18] arm-qmp-cmds: introspection for ID register
 props
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
 <20260519132905.145643-18-eric.auger@redhat.com>
 <36063617-EE1B-493A-929F-E8EC8655FC8A@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <36063617-EE1B-493A-929F-E8EC8655FC8A@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HQjZnxViFuF8WezHiOpnL9WRnYP_e3H0RSnozJzaflw_1779897312
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 5/27/26 5:17 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Implement the capability to query available ID register values by
>> adding SYSREG_* options and values to the cpu model expansion for the
>> host model, if available.
>>
>> Excerpt:
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>> {"return": {"model": {"name": "host", "props":
>> {"SYSREG_ID_AA64PFR0_EL1_EL3": 1224979098931106066,
>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
>> ../..
>>
>> So this allows the upper stack to detect available writable ID
>> regs and the "host passthrough model" values.
>>
>> [CH: moved SYSREG_* values to host model]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>>
>> TODO: Add the moment there is no way to test changing a given
>> ID reg field value. ie:
>>
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host", "prop":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
>> ---
>> target/arm/arm-qmp-cmds.c | 19 +++++++++++++++++++
>> 1 file changed, 19 insertions(+)
>>
>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>> index 83ec95c290..e6c717a872 100644
>> --- a/target/arm/arm-qmp-cmds.c
>> +++ b/target/arm/arm-qmp-cmds.c
>> @@ -21,6 +21,7 @@
>>  */
>>
>> #include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> #include "qemu/target-info.h"
>> #include "hw/core/boards.h"
>> #include "kvm_arm.h"
>> @@ -190,6 +191,24 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>         }
>>     }
>>
>> +    /* If writable ID regs are supported, add them as well */
>> +    if (ARM_CPU(obj)->writable_map) {
>> +        ObjectProperty *prop;
>> +        ObjectPropertyIterator iter;
>> +
>> +        object_property_iter_init(&iter, obj);
>> +
>> +        while ((prop = object_property_iter_next(&iter))) {
>> +            QObject *value;
>> +
>> +            if (!g_str_has_prefix(prop->name, "SYSREG_")) {
>> +                continue;
>> +            }
>> +            value = object_property_get_qobject(obj, prop->name, &error_abort);
>> +            qdict_put_obj(qdict_out, prop->name, value);
>> +        }
>> +    }
>> +
>>     if (!qdict_size(qdict_out)) {
>>         qobject_unref(qdict_out);
>>     } else {
>> -- 
>> 2.53.0
>>
>
> Why also not add support to set these properties? Like the function does for
> legacy properties?

Tbh I have not tested it yet in write mode. One problem we may encounter
is setting one ID reg value may change the value of others or at least
their visibility. So if my understanding is correct we should set each
if reg one at a time and each time read the whole set before applying
the next value. But I may be wrong

Thanks

Eric
>
> Warm Regards,
> Khushit
>

