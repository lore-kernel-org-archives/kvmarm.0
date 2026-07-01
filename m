Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4D12DA75B
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914998; cv=none; b=E4siBQ6pGWj6Ovl9sSTE/QVx/UrtLA5ECabu90qXdq7iFRZ/hQ+4Yaa14QyArpHBd+ApBJBXC0BAcTsypE+N2q29X0jNs7AqpE8tuh0tNOCMpq3MY5xn/pNlEBgvV52mvyWeqj1six/UedadQfyoetzvucSr1uBZOzzej705/j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914998; c=relaxed/simple;
	bh=OFwP+pkMVADKt0UXYr+23yQYYFR6cnfpwehkutpLP1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ncxTCT91g8KhafvTAX3k20U3kbfHPbEZXFiSUquUKn9BhpX0YPXFyU2/lmsysvm7EUVey5syUMrRbUsPU1HAlx1AfYEl8EnuL/10FDqfqA6AJzfsxX3ZQYOErSmO9hoSsFsLannjiQ1Cm6sXlqHTJhYnajDW0A6rRBjQlUtfehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJ73NTB3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJ73NTB3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782914996;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wSJoBP1n90AixtXBkqkDbkBEiMdcH6OFxpJmUJV3xi0=;
	b=OJ73NTB3Phl2k2jh81GqwWfmonCvuC2Q4TDNlS+qsl3U3SgFo9OTnBSVMl3HvLoPhzl3TC
	8AQMKKMaxFdRPHkp1hQ3OKeM2X7xbyXxMo9d9jQRkKgUE8tiB/0NveQY00KzJ3GbTWNWa8
	klQuYnPgnAPAaMckReK0thkgHn1J0a4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-W47VBIP2OcKXJDF6xG-0vQ-1; Wed, 01 Jul 2026 10:09:55 -0400
X-MC-Unique: W47VBIP2OcKXJDF6xG-0vQ-1
X-Mimecast-MFC-AGG-ID: W47VBIP2OcKXJDF6xG-0vQ_1782914994
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c12823d7822so59546066b.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 07:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782914994; x=1783519794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSJoBP1n90AixtXBkqkDbkBEiMdcH6OFxpJmUJV3xi0=;
        b=e3Q2GPP1tk0Zv//WkLmDGPKGS9NWQqbof8H6y2BGvg+2ouHVl4bPvfNuyl5bAM8AwJ
         zywpHX7COwzIeltdWqPJveVpNJ4OzGpLdL0bE02KBV9Ce+bH7lEfAe9CkWgbpLmVxNGj
         Rob/4pMd9CqQjoAaDegSxFzENhnbrB5xitOTJGKolanqvkVcN7deEj2SBhRTv4Bf67ZI
         lt6QuQ8Je0E7SqwRL7b6tUWT824b2vJOCYSAeJI1TCtLuXiqqGMmieTQQ18Z+K0PjNEQ
         BAraLuIP4WpWpTDy95MAgQhz4O1goekn4X2aw2PtXAz11fMuBlaC9leEv1KEMNNRqtUH
         Qr6Q==
X-Forwarded-Encrypted: i=1; AHgh+Roxtgg/qdion8gJrNbLYzz3/1kC0LwtckSOP3qC38HSAiThMN8cB+HOy+H0pGiuY578lZfF70k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNKU31o/LQk0gFdeT5Ly4vgD3s4niJ251eharppqKS55BUXEpl
	EwVtpDULNJDVLMlsmFsj5jljs8DpNteBeh6Q4chMZL+S1rwIiLolEX/nVC0vA36ErcFN+GtrUSm
	e7kA0e5deCQju+qkuD+1j21GuEPUbHhsGCKvikvGA6OuZkJMdiT5GqsTmAA==
X-Gm-Gg: AfdE7clJH2aSCWTTkcb+A2hRB5tdPrh/w9g7st6gPPYYY2THoRtFmy0/lr8cV4+SNFP
	FotkzsTfCJ2xI8lK5lBzzNq/CKErTlzRbA6NoVajoJ3OPzllbD878F0DnwDawv53fCCOjvK4VWv
	PhK1tujh2tVb01NRY+e7EBMjeWOGula98dn6iJORlyTj6f4re54jOxw5B2V4T2IhMXlJ6Jo9kHz
	Znv0PY7Pko28mtTrzyO2ZWSgrzdBOPNTLKBImEKlblRoPSlHrGHRfDtaF+ynBOm9WrTWCsormPz
	xR+NaMpDTgfQyQ7gMXm+pzOvE7uXcqnyBiSSUChGkobITfQE/LWCd8kRh+meEQ7OU2eOXwYaLut
	CUvwVtlPcrL+XNeubT1k072HuHu7sScfEr1396e83JFz37YkLb2UKjdAuCjA=
X-Received: by 2002:a17:906:f84a:b0:c12:9136:8a1a with SMTP id a640c23a62f3a-c12aa137356mr70448566b.31.1782914994241;
        Wed, 01 Jul 2026 07:09:54 -0700 (PDT)
X-Received: by 2002:a17:906:f84a:b0:c12:9136:8a1a with SMTP id a640c23a62f3a-c12aa137356mr70444966b.31.1782914993819;
        Wed, 01 Jul 2026 07:09:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1288f0dfdesm279151066b.30.2026.07.01.07.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 07:09:53 -0700 (PDT)
Message-ID: <5d91c5f7-9f69-4cd2-bc8c-7d06962e5fe6@redhat.com>
Date: Wed, 1 Jul 2026 16:09:51 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v6 14/17] arm-qmp-cmds: introspection for ID register
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
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 Sandesh Patel <sandesh.patel@nutanix.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <20260616132625.1732031-15-eric.auger@redhat.com>
 <c6f663fc-93ad-4a22-b9dc-d7a4653bf348@redhat.com>
 <A6010F6F-FF60-4227-ACFE-B141EEBE88AC@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <A6010F6F-FF60-4227-ACFE-B141EEBE88AC@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d1zm2z2LE4DjVcZpSDuULW1oOYZdHwjmZ-k5H4TfRx8_1782914994
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/19/26 8:05 AM, Khushit Shah wrote:
>
>> On 18 Jun 2026, at 2:56 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>>
>> On 6/16/26 3:17 PM, Eric Auger wrote:
>>> From: Cornelia Huck <cohuck@redhat.com>
>>>
>>> Implement the capability to query available ID register values by
>>> adding SYSREG_* options and values to the cpu model expansion for the
>>> host model, if available.
>>>
>>> Excerpt:
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
>>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
>>> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
>>> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
>>> ../..
>>>
>>> So this allows the upper stack to detect available writable ID
>>> regs and the "host passthrough model" values.
>>>
>>> It also allows to test some ID reg field values:
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>>>
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}
>> for your info I am currently exploring ways to test set field values
>> against KVM. Current check only test against field size and enum values
>> if any.
>>
>> I have a POC instantiating a scratch vcpu and it is totally feasible to
>> set the id reg with the modified value. What is more tricky is to build
>> an incremental scratch vcpu with all the set values accumulating But I
>> guess it should be feasible too.
>>
>> If we manage to do that, I don't think you need safe rules/values
>> anymore because using query-cpu-model-expansion you could directly check
>> the enhanced cpu model can safely apply on host. I will share as soon as
>> I get something clean enough. Thanks Eric
> This seems like it is definitely doable. But, I think it is inefficient and does not
> scale with the number of cpu models.
>
> It will essentially require 1 (vcpu create) + x (number of id register) ioctl calls
> per Named CPU model or a configuration that management software wants
> to test.
yes. But that's also the only way to test incremental stacked settings.
If an IDREG setting depends on a formerly applied one and is
incompatible, you will know. With only safe_rules/values you won't have
that precision I am afraid.
>
> In v3, I will  change how we handle safe_rules. As the analysis in mail to Marc
> almost all of the writeable ID register fields supports writing a lower value.
>
> There are only few exceptions.

OK
>
> Another point I want to raise is without safe_rules, we will not have
> QMP feature parity with x86 where cpu-definitions reports model
> blocker properties. This in-parity means some management
Interesting. I need to further look at cpu-definitions I acknowledge

Thanks

Eric
> software can not be easily ported to work with arm64 named
> cpu models. 
>
> Warm Regards,
> Khushit
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>
>>> ---
>>>
>>> v5 -> v6:
>>> - add the write capability
>>> ---
>>> target/arm/arm-qmp-cmds.c | 29 +++++++++++++++++++++++++++++
>>> 1 file changed, 29 insertions(+)
>>>
>>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>>> index 83ec95c290..edcfc82a25 100644
>>> --- a/target/arm/arm-qmp-cmds.c
>>> +++ b/target/arm/arm-qmp-cmds.c
>>> @@ -21,6 +21,7 @@
>>>  */
>>>
>>> #include "qemu/osdep.h"
>>> +#include "qemu/error-report.h"
>>> #include "qemu/target-info.h"
>>> #include "hw/core/boards.h"
>>> #include "kvm_arm.h"
>>> @@ -84,6 +85,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>                                                      Error **errp)
>>> {
>>>     CpuModelExpansionInfo *expansion_info;
>>> +    ObjectPropertyIterator iter;
>>> +    ObjectProperty *idregprop;
>>>     const QDict *qdict_in;
>>>     QDict *qdict_out;
>>>     ObjectClass *oc;
>>> @@ -145,6 +148,20 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>         }
>>>
>>>         qdict_in = qobject_to(QDict, model->props);
>>> +
>>> +        object_property_iter_init(&iter, obj);
>>> +
>>> +        while ((idregprop = object_property_iter_next(&iter))) {
>>> +            if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
>>> +                continue;
>>> +            }
>>> +            if (qdict_get(qdict_in, idregprop->name)) {
>>> +                if (!object_property_set(obj, idregprop->name, visitor, &err)) {
>>> +                    break;
>>> +                }
>>> +            }
>>> +        }
>>> +
>>>         i = 0;
>>>         while ((name = cpu_model_advertised_features[i++]) != NULL) {
>>>             if (qdict_get(qdict_in, name)) {
>>> @@ -190,6 +207,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>         }
>>>     }
>>>
>>> +    object_property_iter_init(&iter, obj);
>>> +
>>> +    while ((idregprop = object_property_iter_next(&iter))) {
>>> +        QObject *value;
>>> +
>>> +        if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
>>> +            continue;
>>> +        }
>>> +        value = object_property_get_qobject(obj, idregprop->name, &error_abort);
>>> +        qdict_put_obj(qdict_out, idregprop->name, value);
>>> +    }
>>> +
>>>     if (!qdict_size(qdict_out)) {
>>>         qobject_unref(qdict_out);
>>>     } else {
>

