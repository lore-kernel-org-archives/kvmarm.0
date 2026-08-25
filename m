Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CC3480DC4
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787667138; cv=none; b=sEH7ajGlipCigayglqoLjIB8E/VHXhul++tYh+MaVkNrpvNQyXXWykkvGzyRHeAWS0YeOInBqkmDt+fjOyniNtSYaCuC0AHs02GO04IE6NMFuxlihzHQkPQxGBQE40HnNFNW4Xf5FVNWTP96AQ7dtbxgBFpOjXr+4DQ+F+f8yYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787667138; c=relaxed/simple;
	bh=yFCOWGyU0YU+TyY0yIEhY1HKYeZeTSfJSxiNbfsBwZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XEOWArZmBcF+dGJUWXH0/ez3B66UNX/CCQ9mUTS5NlC/Sqprou9RnZtXv/nvy3ayhYZ66vHsD88t9yaFRhqVSgffQqz9qe9hq/ALLul2pwnTgh+QwFlpEL1l9NWaiH8audHFFzuqzmm9PEw18tnZSfNiRE5EEzA2WlxM6RKMdN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMkcjgai; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMkcjgai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787667135;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4iL8cm9xLlw42MXWWTWh2uxD3jujV4/hT7MHer/4wA=;
	b=SMkcjgaiHIlHn/+cdUfi5cxS0LExxmCo/7TjxnD/sGkoE3HZHFNaK80N5K8olBaGArbfnQ
	sw0Lzzu52yuG4NwYkLKhbL7T6qNV4cNtIRqFSVddqkm6A0lVU94cu3NoLkS2WNzGw3ydtu
	lpP/7E4X6JiIL/cYsOE2ty6CI9lekmo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-f3_U5lPhP3ecXNE2dwE4yg-1; Tue, 25 Aug 2026 10:12:11 -0400
X-MC-Unique: f3_U5lPhP3ecXNE2dwE4yg-1
X-Mimecast-MFC-AGG-ID: f3_U5lPhP3ecXNE2dwE4yg_1787667130
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15fff01a30so302423066b.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787667130; x=1788271930;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M4iL8cm9xLlw42MXWWTWh2uxD3jujV4/hT7MHer/4wA=;
        b=qyqjVmRyLeYW9MsLluiM+HtOGMC23LMVWolxOGXZSUsRHa04RDPz2mRYoX/hmwEIFM
         2364OjuMSM7y+nRdekJ/sF7nYcPCS73fXFY1dGo2e/8lZamuk8daooqtW+3F2UjMmnDd
         r5j7dgMcQ0qMJBKRKGktL4vXPzC0XuV0GGA63k+X8BBCDKExj5Imdyd/MJ+6OgJsPV9q
         JQK2391gMKmG72EsKYB0ruLywuXfGTiH0tHqN0jA02kPyQ+6m6cyf6VvTqzIqwZwUvj0
         /e1I6bpC2qK6yriRdjwlruRTdvYRc4edVHQE8O0fc8K2f0lyLL3oCP9Oy2j3lhbDGLLX
         Y4hQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1mYXsWoLEkpXdrN7Jog+CM5qHeoqJMN8mSc0pVLvbifuzrqZb24def2NQLE6WgwScwgXvVBw=@lists.linux.dev
X-Gm-Message-State: AFuF++nnbylaMMt2K1wTdkXGEGGia8Wfh6FHkZ+bVQpjWUcOwYK3bwdb
	XLfXxolFlZaBYnMh8MlmlwgpBizFnhLn0BlsUmEaa6fP41b8/r+Jama//dGB/0wJFLoY35aEfng
	8NQYJI5XU7Ncc5Pm5/c1g94Bqyjer0xQmUfRYwbx84u2csogm9rSV7Tkf9Q==
X-Gm-Gg: AR+sD10xYuaUyKxCSdstEAzWNupFedDDFBSUcYUbAWD9gy2GVd6TEhWNe9EADYPqaJL
	P3XqgF2EoklgwbM1eaqe8nH0p6PqsO20L1btLh+oWRdR1+61ImvDNuBXsz2INcDdRMgmZIZ/zF7
	cKggmD0DBFy+0Z3lwdGfU/RARZBWe+0gEY8BFeW8B1Ce/QH0Hsr5LHVPFFsL8JsNyJ3lRnE+/rN
	jLDEUprj+99mcQdMFRIFbYJk/jnl+EAlz5TQXTwK3DoyVsRInqxA88+0pJG9oo35WXy8ZrGjYnw
	Bne2SPNKU8dL/Nka3peSyEbdzvsEYdUDChPF6IIXQhQ6rFGZ8wJfiOwe1gII3cgmIOiIFEH1cKK
	+pjMrX7lA8pZ05Moox6D2pjngKepgxJVM6V6doXx/dXPWqPyl
X-Received: by 2002:a17:906:9f8e:b0:c24:b11a:46fc with SMTP id a640c23a62f3a-c24e5be5ae6mr717378066b.22.1787667130071;
        Tue, 25 Aug 2026 07:12:10 -0700 (PDT)
X-Received: by 2002:a17:906:9f8e:b0:c24:b11a:46fc with SMTP id a640c23a62f3a-c24e5be5ae6mr717373766b.22.1787667129592;
        Tue, 25 Aug 2026 07:12:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e1d7399sm20394026a12.26.2026.08.25.07.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 07:12:08 -0700 (PDT)
Message-ID: <54207f52-e9f0-49f1-9ac2-1653e4a1bd53@redhat.com>
Date: Tue, 25 Aug 2026 16:12:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 18/18] arm-qmp-cmds: introspection for ID register
 props
To: Markus Armbruster <armbru@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, shaju.abraham@nutanix.com,
 khushit.shah@nutanix.com, yangjinqian1@huawei.com, cohuck@redhat.com,
 richard.henderson@linaro.org, sebott@redhat.com, skolothumtho@nvidia.com,
 philmd@oss.qualcomm.com, maz@kernel.org, oliver.upton@linux.dev,
 pbonzini@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-19-eric.auger@redhat.com> <878q613tae.fsf@pond.sub.org>
 <cae6f5c2-edb2-4811-a915-cbd93bbd903b@redhat.com>
 <87wltemu97.fsf@pond.sub.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87wltemu97.fsf@pond.sub.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1IgkzdQieq95fO1kwCqtpmJawqbv6gmO4jr0JxU1mWA_1787667130
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Markus,

On 8/25/26 11:20 AM, Markus Armbruster wrote:
> Eric Auger <eric.auger@redhat.com> writes:
>
>> Hi Markus,
>>
>> On 8/20/26 1:50 PM, Markus Armbruster wrote:
>>> Eric Auger <eric.auger@redhat.com> writes:
>>>
>>>> From: Cornelia Huck <cohuck@redhat.com>
>>>>
>>>> Implement the capability to query available ID register values by
>>>> adding SYSREG_* options and values to the cpu model expansion for the
>>>> host model, if available.
>>>>
>>>> Excerpt:
>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>> Is this qmp-shell?
>> yes it is. Is that a problem?
> I wouldn't call use of qmp-shell a problem.  Except some reader may not
> recognize it from the example input, or may not even know it exists.
> Mentioning it takes care of all that.
>
> I prefer to use QMP directly myself, like this:
>
>     $ socat "READLINE,history=$HOME/.qmp_history,prompt=QMP> " UNIX-CONNECT:/path/to/socket
>
> But that's just personal preference.

OK thank you for the details. For now I clarified in the commit msg that
those are qmp-shell examples.

Eric
>
>>>> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
>>>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
>>>> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
>>>> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
>>>> ../..
>>>>
>>>> This allows the upper stack to detect available writable ID regs and
>>>> the "host passthrough model" values.
>>>>
>>>> It also allows to test some ID reg field values:
>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
>>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>>>>
>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
>>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}
>>> The examples use CPU "host".  Inconvenient for me, because I run into
>>> "The CPU type 'host' requires KVM" when I try to play with them myself.
>>> If you don't actually need "host" here, consider using something that
>>> works more widely, just to help reviewers.
>> It only applies to the host model, that's the reason. Extending this to
>> TCG models is theorerically feasible but would induce huge changes
>> without much benefits I think. With TCG you already have named vcpu
>> models you can migrate as is. The purpose of this series is to allow
>> tweaking the host passthrough model to allow migration between
>> differents hosts.
> Thanks!
>
>>>> The following checks are performed:
>>>> - the value does not exceed the field size
>>>> - if the field is associated to enum values, the set value must be one
>>>>   of those enum values
>>>> - the value is applied against a scratch vcpu making sure the setting is
>>>>   not rejected for this host
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>>
>>>> ---
>>>>
>>>> v5 -> v6:
>>>> - add the write capability
>>>> ---
>>>>  target/arm/arm-qmp-cmds.c | 98 +++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 98 insertions(+)
>>>>
>>>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>>>> index 83ec95c290..41fefadcea 100644
>>>> --- a/target/arm/arm-qmp-cmds.c
>>>> +++ b/target/arm/arm-qmp-cmds.c
>>>> @@ -21,6 +21,7 @@
>>>>   */
>>>>  
>>>>  #include "qemu/osdep.h"
>>>> +#include "qemu/error-report.h"
>>>>  #include "qemu/target-info.h"
>>>>  #include "hw/core/boards.h"
>>>>  #include "kvm_arm.h"
>>>> @@ -30,7 +31,10 @@
>>>>  #include "qapi/qapi-commands-machine.h"
>>>>  #include "qapi/qapi-commands-misc-arm.h"
>>>>  #include "qobject/qdict.h"
>>>> +#include "qobject/qnum.h"
>>>>  #include "qom/qom-qobject.h"
>>>> +#include <linux/kvm.h>
>>>> +#include "system/kvm.h"
>>>>  #include "cpu.h"
>>>>  
>>>>  static GICCapability *gic_cap_new(int version)
>>>> @@ -84,11 +88,14 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>                                                       Error **errp)
>>>>  {
>>>>      CpuModelExpansionInfo *expansion_info;
>>>> +    ObjectPropertyIterator iter;
>>>>      const QDict *qdict_in;
>>>> +    ObjectProperty *idregprop;
>>>>      QDict *qdict_out;
>>>>      ObjectClass *oc;
>>>>      Object *obj;
>>>>      const char *name;
>>>> +    int fdarray[3];
>>>>      int i;
>>>>  
>>>>      if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
>>>> @@ -133,6 +140,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>  
>>>>      obj = object_new(object_class_get_name(oc));
>>>>  
>>>> +    if (kvm_enabled()) {
>>>> +        bool pmuv3_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
>>>> +        bool sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
>>>> +        struct kvm_vcpu_init init = { .target = -1, };
>>>> +        bool el2_supported = kvm_arm_el2_supported();
>>>> +        bool pauth_supported;
>>>> +        int ret;
>>>> +
>>>> +        pauth_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>>> +                          kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC);
>>>> +
>>>> +        if (sve_supported) {
>>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
>>>> +        }
>>>> +        if (el2_supported) {
>>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
>>>> +        }
>>>> +        if (pauth_supported) {
>>>> +            init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
>>>> +                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>>> +        }
>>>> +        if (pmuv3_supported) {
>>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>>> +        }
>>>> +
>>>> +        ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init);
>>>> +        if (!ret) {
>>>> +            error_setg(errp, "failing creating a scratch vcpu");
>>> This error message feels off.  I'd use something like "can't create
>>> FOO".  Still bad, because it provides no clue on why.  What are the
>>> possible failure modes?
>> OK. There are quite a lot of possible failures which are handled in
>> kvm_arm_create_scratch_host_vcpu()
>> opening of /dev/kvm, KVM_CREATE_VM, KVM_CREATE_VCPU,
>> KVM_ARM_PREFERRED_TARGET, KVM_ARM_VCPU_INIT.
>> In next version I will add an Error handle to
>> kvm_arm_create_scratch_host_vcpu() so that precise error message gets
>> returned.
> Makes sense.
>
> [...]
>

