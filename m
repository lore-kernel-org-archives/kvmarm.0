Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8849543B496
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 11:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226630; cv=none; b=Rd8yKWQ+Eo+IbECVxN4k4DAGSBvm3PPOZLx2f/ZfNOCJX4b6q3w9qbytR9q5k5j6xA8Tgbv8L59kRRsCQPUn+PiQMnio3Nk4R+mGbf6FG+Z2Wkh+Vk+0+ir+VOwcPYvV8FE1J7BqXF7wpu2vKgIML4/tdZO7i6Wir6IIfdl6zvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226630; c=relaxed/simple;
	bh=HlTOhfUZuPC0RzXmjK5sMe3hbQ0K+H4zs9u5bZY7YWA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OAdEqPORaj+THG4fFBet4Yhyg4YvY2IiH+jJf28PqJqQAwk21C/6z0mdKHxEJDlGMk9zpNPqnR2lxMGpQDSC2Sg1csTL5mUAX6fm4RDCzTKoUdH43sqKa8YhPVMcNgQBweoWUOTJe/c11KdZ6QGCi2P6BrAL/5cTrxebRTmjnWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BK4Azcmm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BK4Azcmm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787226627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bvSiCvexm0vGp60WArGjDkGI0kQakkk2uBehrXtZnc0=;
	b=BK4AzcmmpekSdMZx61swLw7IRIAlUmp6qZfBEnxirdB+Ujq+3uQc+ubDKPKoNqU9CgsbQF
	WeVDX++6wnHdVwB7O0vTNb6xCX/uelxjkom6vNyO4Ef+5KsHIfBzqin2rIT8K13uCVrA+T
	KuyRxuRVjppc0nez+NHePWaEEQjpWdE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-0xpJ89z0MzO6uic1vkL96A-1; Thu,
 20 Aug 2026 07:50:23 -0400
X-MC-Unique: 0xpJ89z0MzO6uic1vkL96A-1
X-Mimecast-MFC-AGG-ID: 0xpJ89z0MzO6uic1vkL96A_1787226622
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A7B6195605E;
	Thu, 20 Aug 2026 11:50:21 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 582B23001DAF;
	Thu, 20 Aug 2026 11:50:20 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D962521E6920; Thu, 20 Aug 2026 13:50:17 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com,  qemu-devel@nongnu.org,  qemu-arm@nongnu.org,
  kvmarm@lists.linux.dev,  peter.maydell@linaro.org,
  shaju.abraham@nutanix.com,  khushit.shah@nutanix.com,
  yangjinqian1@huawei.com,  cohuck@redhat.com,
  richard.henderson@linaro.org,  sebott@redhat.com,
  skolothumtho@nvidia.com,  philmd@oss.qualcomm.com,  maz@kernel.org,
  oliver.upton@linux.dev,  pbonzini@redhat.com,  berrange@redhat.com,
  abologna@redhat.com,  jdenemar@redhat.com
Subject: Re: [RFC PATCH v7 18/18] arm-qmp-cmds: introspection for ID
 register props
In-Reply-To: <20260726153221.24773-19-eric.auger@redhat.com> (Eric Auger's
	message of "Sun, 26 Jul 2026 17:29:56 +0200")
References: <20260726153221.24773-1-eric.auger@redhat.com>
	<20260726153221.24773-19-eric.auger@redhat.com>
Date: Thu, 20 Aug 2026 13:50:17 +0200
Message-ID: <878q613tae.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: MWl_QrJG59DsrVXQ_QfEhwxLvzHnNisOS7i1BuOkVGY_1787226622
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Eric Auger <eric.auger@redhat.com> writes:

> From: Cornelia Huck <cohuck@redhat.com>
>
> Implement the capability to query available ID register values by
> adding SYSREG_* options and values to the cpu model expansion for the
> host model, if available.
>
> Excerpt:
> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}

Is this qmp-shell?

> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
> ../..
>
> This allows the upper stack to detect available writable ID regs and
> the "host passthrough model" values.
>
> It also allows to test some ID reg field values:
> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>
> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}

The examples use CPU "host".  Inconvenient for me, because I run into
"The CPU type 'host' requires KVM" when I try to play with them myself.
If you don't actually need "host" here, consider using something that
works more widely, just to help reviewers.

>
> The following checks are performed:
> - the value does not exceed the field size
> - if the field is associated to enum values, the set value must be one
>   of those enum values
> - the value is applied against a scratch vcpu making sure the setting is
>   not rejected for this host
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
> ---
>
> v5 -> v6:
> - add the write capability
> ---
>  target/arm/arm-qmp-cmds.c | 98 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index 83ec95c290..41fefadcea 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -21,6 +21,7 @@
>   */
>  
>  #include "qemu/osdep.h"
> +#include "qemu/error-report.h"
>  #include "qemu/target-info.h"
>  #include "hw/core/boards.h"
>  #include "kvm_arm.h"
> @@ -30,7 +31,10 @@
>  #include "qapi/qapi-commands-machine.h"
>  #include "qapi/qapi-commands-misc-arm.h"
>  #include "qobject/qdict.h"
> +#include "qobject/qnum.h"
>  #include "qom/qom-qobject.h"
> +#include <linux/kvm.h>
> +#include "system/kvm.h"
>  #include "cpu.h"
>  
>  static GICCapability *gic_cap_new(int version)
> @@ -84,11 +88,14 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>                                                       Error **errp)
>  {
>      CpuModelExpansionInfo *expansion_info;
> +    ObjectPropertyIterator iter;
>      const QDict *qdict_in;
> +    ObjectProperty *idregprop;
>      QDict *qdict_out;
>      ObjectClass *oc;
>      Object *obj;
>      const char *name;
> +    int fdarray[3];
>      int i;
>  
>      if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
> @@ -133,6 +140,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>  
>      obj = object_new(object_class_get_name(oc));
>  
> +    if (kvm_enabled()) {
> +        bool pmuv3_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
> +        bool sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
> +        struct kvm_vcpu_init init = { .target = -1, };
> +        bool el2_supported = kvm_arm_el2_supported();
> +        bool pauth_supported;
> +        int ret;
> +
> +        pauth_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +                          kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC);
> +
> +        if (sve_supported) {
> +            init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
> +        }
> +        if (el2_supported) {
> +            init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
> +        }
> +        if (pauth_supported) {
> +            init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
> +                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
> +        }
> +        if (pmuv3_supported) {
> +            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> +        }
> +
> +        ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init);
> +        if (!ret) {
> +            error_setg(errp, "failing creating a scratch vcpu");

This error message feels off.  I'd use something like "can't create
FOO".  Still bad, because it provides no clue on why.  What are the
possible failure modes?

> +            return NULL;
> +        }
> +    }
> +
>      if (model->props) {
>          Visitor *visitor;
>          Error *err = NULL;
> @@ -145,6 +184,49 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>          }
>  
>          qdict_in = qobject_to(QDict, model->props);
> +
> +        for (const QDictEntry *entry = qdict_first(qdict_in);
> +                 entry != NULL; entry = qdict_next(qdict_in, entry)) {
> +            const char *key = qdict_entry_key(entry);
> +            QObject *val_obj = qdict_entry_value(entry);
> +            ObjectProperty *prop;
> +            Visitor *v;
> +            bool success;
> +            uint64_t val;
> +
> +            prop = object_property_find(obj, key);
> +            if (!prop) {
> +                error_setg(errp, "%s does not exist!", key);

Scratch the !

From error_setg()'s contract:

 * The resulting message should be a single phrase, with no newline or
 * trailing punctuation.

Is this error reachable?  How?

> +                return NULL;
> +            }
> +
> +            if (!g_str_has_prefix(key, "SYSREG_")) {
> +                continue;
> +            }
> +
> +            /* consume the prop to avoid unexpected parameter */
> +            if (!visit_type_uint64(visitor, key, &val, errp)) {
> +                return NULL;
> +            }
> +
> +            v = qobject_input_visitor_new(val_obj);
> +
> +            if (!object_property_set(obj, key, v, &err)) {
> +                error_propagate(errp, err);

Pass @errp to object_property_set() and drop the error_propagate()?

> +                visit_free(v);
> +                return NULL;
> +            }
> +
> +            success = kvm_idreg_write_scratch_vcpu(fdarray[2], v, key,
> +                                                   prop->opaque, &err);
> +            if (!success) {
> +                error_propagate(errp, err);

Likewise?

> +                visit_free(v);
> +                return NULL;
> +            }
> +            visit_free(v);
> +        }
> +
>          i = 0;
>          while ((name = cpu_model_advertised_features[i++]) != NULL) {
>              if (qdict_get(qdict_in, name)) {
> @@ -160,6 +242,10 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>          if (!err) {
>              arm_cpu_finalize_features(ARM_CPU(obj), &err);
>          }
> +
> +        if (kvm_enabled()) {
> +            kvm_arm_destroy_scratch_host_vcpu(fdarray);
> +        }
>          visit_end_struct(visitor, NULL);
>          visit_free(visitor);
>          if (err) {
> @@ -190,6 +276,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>          }
>      }
>  
> +    object_property_iter_init(&iter, obj);
> +
> +    while ((idregprop = object_property_iter_next(&iter))) {
> +        QObject *value;
> +
> +        if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
> +            continue;
> +        }
> +        value = object_property_get_qobject(obj, idregprop->name, &error_abort);
> +        qdict_put_obj(qdict_out, idregprop->name, value);
> +    }
> +
>      if (!qdict_size(qdict_out)) {
>          qobject_unref(qdict_out);
>      } else {

