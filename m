Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4443DDB13
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649633; cv=none; b=BofrO5ZRnZk+3BOUKoJFmCdd7mldNmKJzRBaRUb2IaOwHB7NhMDLCVWdYKmh6ymF+72ZEE2uQXSo9kH8wSVr6bh2PkvoP1OM2AWjOnXrqd4zEoo/9/9bK9dk39MxUxwnv8dIaOj/N11REliSuzaOdC1222SmbGroRaamZQUGuwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649633; c=relaxed/simple;
	bh=fmjDKcjAN0Eon8LoDkaxDEIQRKnnStFeUf5qXcGbj7U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LxhL4XhsO4yDNcuIauPwzZLLwux6eGX8XbKdCE+R87TKks1dtfKknSn14TVYLNJh9b6yluSfimY9Q7DUTktlifQ/6Y4uKEMVewMP/OCPbz5D8uPd2tU8P0Sozi0NKcP5odk6NVSS8PtiS0P3IClvzRIjX/vggcvbz5xQKLJ+jq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5mlA265; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5mlA265"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787649630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ssdJdZuf5yeXYvzWHL9J6SZ/LOSG0pjqAamgVaCMXsw=;
	b=J5mlA265gDBful+nu5dsf7/lVhYOhK9qxQsd7Fjjb9CNEBR9sJkTCkwXFqCtWQEF6c9Bqk
	RXRzEc7Vx8SHefsqETvJ9J/0KKPgADbv0J36uGJIqM6J0m2+Lra8N7uJP2EEzF9VeCGo/B
	MqURNycyQ19y9hDf0x4+nEF2c9yHeHo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-crrxDkEwNdmi3lHvHGLQJg-1; Tue,
 25 Aug 2026 05:20:27 -0400
X-MC-Unique: crrxDkEwNdmi3lHvHGLQJg-1
X-Mimecast-MFC-AGG-ID: crrxDkEwNdmi3lHvHGLQJg_1787649625
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A844187DBBD;
	Tue, 25 Aug 2026 09:20:24 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BD6918005B4;
	Tue, 25 Aug 2026 09:20:23 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DE8C721E6920; Tue, 25 Aug 2026 11:20:20 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>,  eric.auger.pro@gmail.com,
  qemu-devel@nongnu.org,  qemu-arm@nongnu.org,  kvmarm@lists.linux.dev,
  peter.maydell@linaro.org,  shaju.abraham@nutanix.com,
  khushit.shah@nutanix.com,  yangjinqian1@huawei.com,  cohuck@redhat.com,
  richard.henderson@linaro.org,  sebott@redhat.com,
  skolothumtho@nvidia.com,  philmd@oss.qualcomm.com,  maz@kernel.org,
  oliver.upton@linux.dev,  pbonzini@redhat.com,  berrange@redhat.com,
  abologna@redhat.com,  jdenemar@redhat.com
Subject: Re: [RFC PATCH v7 18/18] arm-qmp-cmds: introspection for ID
 register props
In-Reply-To: <cae6f5c2-edb2-4811-a915-cbd93bbd903b@redhat.com> (Eric Auger's
	message of "Tue, 25 Aug 2026 10:38:22 +0200")
References: <20260726153221.24773-1-eric.auger@redhat.com>
	<20260726153221.24773-19-eric.auger@redhat.com>
	<878q613tae.fsf@pond.sub.org>
	<cae6f5c2-edb2-4811-a915-cbd93bbd903b@redhat.com>
Date: Tue, 25 Aug 2026 11:20:20 +0200
Message-ID: <87wltemu97.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 5QmFW1klJWavY3VFRSPvZFQV8UYbBQi-TY7EDggtmvo_1787649625
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Eric Auger <eric.auger@redhat.com> writes:

> Hi Markus,
>
> On 8/20/26 1:50 PM, Markus Armbruster wrote:
>> Eric Auger <eric.auger@redhat.com> writes:
>>
>>> From: Cornelia Huck <cohuck@redhat.com>
>>>
>>> Implement the capability to query available ID register values by
>>> adding SYSREG_* options and values to the cpu model expansion for the
>>> host model, if available.
>>>
>>> Excerpt:
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>
>> Is this qmp-shell?
> yes it is. Is that a problem?

I wouldn't call use of qmp-shell a problem.  Except some reader may not
recognize it from the example input, or may not even know it exists.
Mentioning it takes care of all that.

I prefer to use QMP directly myself, like this:

    $ socat "READLINE,history=$HOME/.qmp_history,prompt=QMP> " UNIX-CONNECT:/path/to/socket

But that's just personal preference.

>>> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
>>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
>>> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
>>> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
>>> ../..
>>>
>>> This allows the upper stack to detect available writable ID regs and
>>> the "host passthrough model" values.
>>>
>>> It also allows to test some ID reg field values:
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>>>
>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}
>>
>> The examples use CPU "host".  Inconvenient for me, because I run into
>> "The CPU type 'host' requires KVM" when I try to play with them myself.
>> If you don't actually need "host" here, consider using something that
>> works more widely, just to help reviewers.
> It only applies to the host model, that's the reason. Extending this to
> TCG models is theorerically feasible but would induce huge changes
> without much benefits I think. With TCG you already have named vcpu
> models you can migrate as is. The purpose of this series is to allow
> tweaking the host passthrough model to allow migration between
> differents hosts.

Thanks!

>>> The following checks are performed:
>>> - the value does not exceed the field size
>>> - if the field is associated to enum values, the set value must be one
>>>   of those enum values
>>> - the value is applied against a scratch vcpu making sure the setting is
>>>   not rejected for this host
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>
>>> ---
>>>
>>> v5 -> v6:
>>> - add the write capability
>>> ---
>>>  target/arm/arm-qmp-cmds.c | 98 +++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 98 insertions(+)
>>>
>>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>>> index 83ec95c290..41fefadcea 100644
>>> --- a/target/arm/arm-qmp-cmds.c
>>> +++ b/target/arm/arm-qmp-cmds.c
>>> @@ -21,6 +21,7 @@
>>>   */
>>>  
>>>  #include "qemu/osdep.h"
>>> +#include "qemu/error-report.h"
>>>  #include "qemu/target-info.h"
>>>  #include "hw/core/boards.h"
>>>  #include "kvm_arm.h"
>>> @@ -30,7 +31,10 @@
>>>  #include "qapi/qapi-commands-machine.h"
>>>  #include "qapi/qapi-commands-misc-arm.h"
>>>  #include "qobject/qdict.h"
>>> +#include "qobject/qnum.h"
>>>  #include "qom/qom-qobject.h"
>>> +#include <linux/kvm.h>
>>> +#include "system/kvm.h"
>>>  #include "cpu.h"
>>>  
>>>  static GICCapability *gic_cap_new(int version)
>>> @@ -84,11 +88,14 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>                                                       Error **errp)
>>>  {
>>>      CpuModelExpansionInfo *expansion_info;
>>> +    ObjectPropertyIterator iter;
>>>      const QDict *qdict_in;
>>> +    ObjectProperty *idregprop;
>>>      QDict *qdict_out;
>>>      ObjectClass *oc;
>>>      Object *obj;
>>>      const char *name;
>>> +    int fdarray[3];
>>>      int i;
>>>  
>>>      if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
>>> @@ -133,6 +140,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>  
>>>      obj = object_new(object_class_get_name(oc));
>>>  
>>> +    if (kvm_enabled()) {
>>> +        bool pmuv3_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
>>> +        bool sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
>>> +        struct kvm_vcpu_init init = { .target = -1, };
>>> +        bool el2_supported = kvm_arm_el2_supported();
>>> +        bool pauth_supported;
>>> +        int ret;
>>> +
>>> +        pauth_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>> +                          kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC);
>>> +
>>> +        if (sve_supported) {
>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
>>> +        }
>>> +        if (el2_supported) {
>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
>>> +        }
>>> +        if (pauth_supported) {
>>> +            init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
>>> +                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>> +        }
>>> +        if (pmuv3_supported) {
>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>> +        }
>>> +
>>> +        ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init);
>>> +        if (!ret) {
>>> +            error_setg(errp, "failing creating a scratch vcpu");
>>
>> This error message feels off.  I'd use something like "can't create
>> FOO".  Still bad, because it provides no clue on why.  What are the
>> possible failure modes?
> OK. There are quite a lot of possible failures which are handled in
> kvm_arm_create_scratch_host_vcpu()
> opening of /dev/kvm, KVM_CREATE_VM, KVM_CREATE_VCPU,
> KVM_ARM_PREFERRED_TARGET, KVM_ARM_VCPU_INIT.
> In next version I will add an Error handle to
> kvm_arm_create_scratch_host_vcpu() so that precise error message gets
> returned.

Makes sense.

[...]

