Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93FA3BCD27
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774829; cv=none; b=Sit1YKwbRVwup12f+zjaLAfd7DreYzl2kRglJx42WWyVCGv4MwUMgmAYUMjl2DSRwR51X7LVJNRcYrlEkwsCgLp6QK/9EBDRkwLMAPdLhqAV9ayzmUbuHJV3yU4iSPpDOWh/eaf7slzSm5VCH2Ok1zv4HBaB8MoCF9nf0T5CU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774829; c=relaxed/simple;
	bh=XPn8FEVJwHcl5TgPdTjC322x1FlBvfmC/RCet9ispPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pxyyHscpad3gTXsjIdXRpw6n4YZoSDSEdirC2IAtvgCDFXumvZkWFS5grriYUUeT0TI0RryLbWNWoz530PHOz8cLCAcxBsXJWQso/2U+oaERAOoBaPKmJL7FSkSSeMZKdAzz0ECUb9dwjNNVwyLLb7kRxzmnSXudx6kOPiedwEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ieN5N+6e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ieN5N+6e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781774826;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0XZrGqbm2Ow0WjX6DNzQYXaAoRmQlfXg9mfNOE4Ri88=;
	b=ieN5N+6eGjDhjdYMrw0VEJ1GWdDg0n3Cu8m9bbz+2HTIpjzdOvytNrGrE961RJGw3leuVw
	i2m2sb70wNYV42xuoO2j+g5R6CIMg7bScyoAuhzsd7iPn1Xc65n/JpWza4I7IYOG7s5smU
	t5rV69smrilypJG9StFobZ/XxHDMtYk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-ECrxCBCDP4iEphZQzTc7Vw-1; Thu, 18 Jun 2026 05:27:03 -0400
X-MC-Unique: ECrxCBCDP4iEphZQzTc7Vw-1
X-Mimecast-MFC-AGG-ID: ECrxCBCDP4iEphZQzTc7Vw_1781774822
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45eec2badc4so383603f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781774822; x=1782379622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XZrGqbm2Ow0WjX6DNzQYXaAoRmQlfXg9mfNOE4Ri88=;
        b=RaRR6JCDVQNL7D+3rzs900Mgv1q883c9HurOg3+FZSogO6WGgDMBM2Lt7QfUgKF8oG
         2HWAaotZv/9sbFKjVxi0wDq/js7J79OCpbprcDykXWPmMgpfhpWOH5PQA7XkKurNSjPP
         x39WdEaY4GS+jgT/L/RcTQd1q9tNLSRiYoYJMK2EO5n5iEDHcnvB+gCTxhXAV3TCw/4h
         i/G7J7cJ8jYPdLA03HcsKPduNq5lg+bW36lmp05lloHskN3yeQCHvT7wzgHS68wG2iaZ
         I1LVXXV3v480nIJsRrfH01gYPfJdcYPFR7LsIif9DQoGOkDWGN+xHgXwSd14QVdot925
         SZUQ==
X-Forwarded-Encrypted: i=1; AFNElJ8h6Y8mq5w4gUGqMvJY1tytFVvcHjKfCr/tCJCFwl16bE9ubrLZAFELOwa/Tkg5OtZuO+hYrRU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVDoyf0IS7jxqE1lGEkix68PXvkH3BN2TUJ9+sggVSlCssLzRC
	Nx7SvTWzrN45OlMazxixmsOqyZll9m19k2q5C4eqR8wVuXrYKeNmmnRzXou5NilcY9xs/rQGG8F
	kf694+Q5/1mvZWaxpkKZJC1wxmehXlZz3JOCULq4A6h4ehz8EZj/kUK1t6g==
X-Gm-Gg: AfdE7cmMhNzlXDJ01UKnfglqNzoEpvOni5am6nL7wEp0VR3ejeo1NbguXOM75huUyAF
	jpLUlvQCm69DNqrPGq9RhgjYdcDk0J9MxQbvmCGjzmNUSrMHTVa47KrGJmr19m6OExWq41sHiGn
	hgXSU+aHoo67fMpZHi2t4aH/YFbo4YrURUqK2woVS21jnRE6NnxTDLG+3QqtXBNejV6ApjE1dOc
	7MfSTSht4okfJrbTQ6gETU8BF51yfvMTfwsEo0CfdGwFIavWIUHJDxtcQT8RtemJNeTYRtQvhaK
	eBE8SORJEs4pS0GxFjLNGShk7HPzet03Y6WEd5kVIiN6Rrp09lgc2U0BqBS6cQLKlt8INAp/rEH
	YYxCy9p0QorL40LKxVCkpQYJSstI/O+y0t+noYUkSPVvbi8tCcgiiq6ukSVk=
X-Received: by 2002:a05:6000:310f:b0:463:d9:5b35 with SMTP id ffacd0b85a97d-463ab328c3cmr4411207f8f.1.1781774822202;
        Thu, 18 Jun 2026 02:27:02 -0700 (PDT)
X-Received: by 2002:a05:6000:310f:b0:463:d9:5b35 with SMTP id ffacd0b85a97d-463ab328c3cmr4411151f8f.1.1781774821701;
        Thu, 18 Jun 2026 02:27:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4619fb12edbsm25076966f8f.17.2026.06.18.02.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 02:27:01 -0700 (PDT)
Message-ID: <c6f663fc-93ad-4a22-b9dc-d7a4653bf348@redhat.com>
Date: Thu, 18 Jun 2026 11:26:58 +0200
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
To: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, shaju.abraham@nutanix.com,
 khushit.shah@nutanix.com, yangjinqian1@huawei.com, cohuck@redhat.com,
 richard.henderson@linaro.org, sebott@redhat.com, skolothumtho@nvidia.com,
 philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <20260616132625.1732031-15-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-15-eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NiECRbhvMD_iRIsJhm2Khfd8JX1dEdSCxwcGQL1QkjY_1781774822
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 6/16/26 3:17 PM, Eric Auger wrote:
> From: Cornelia Huck <cohuck@redhat.com>
>
> Implement the capability to query available ID register values by
> adding SYSREG_* options and values to the cpu model expansion for the
> host model, if available.
>
> Excerpt:
> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
> ../..
>
> So this allows the upper stack to detect available writable ID
> regs and the "host passthrough model" values.
>
> It also allows to test some ID reg field values:
> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>
> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}

for your info I am currently exploring ways to test set field values
against KVM. Current check only test against field size and enum values
if any.

I have a POC instantiating a scratch vcpu and it is totally feasible to
set the id reg with the modified value. What is more tricky is to build
an incremental scratch vcpu with all the set values accumulating But I
guess it should be feasible too.

If we manage to do that, I don't think you need safe rules/values
anymore because using query-cpu-model-expansion you could directly check
the enhanced cpu model can safely apply on host. I will share as soon as
I get something clean enough. Thanks Eric
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
> ---
>
> v5 -> v6:
> - add the write capability
> ---
>  target/arm/arm-qmp-cmds.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index 83ec95c290..edcfc82a25 100644
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
> @@ -84,6 +85,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>                                                       Error **errp)
>  {
>      CpuModelExpansionInfo *expansion_info;
> +    ObjectPropertyIterator iter;
> +    ObjectProperty *idregprop;
>      const QDict *qdict_in;
>      QDict *qdict_out;
>      ObjectClass *oc;
> @@ -145,6 +148,20 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>          }
>  
>          qdict_in = qobject_to(QDict, model->props);
> +
> +        object_property_iter_init(&iter, obj);
> +
> +        while ((idregprop = object_property_iter_next(&iter))) {
> +            if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
> +                continue;
> +            }
> +            if (qdict_get(qdict_in, idregprop->name)) {
> +                if (!object_property_set(obj, idregprop->name, visitor, &err)) {
> +                    break;
> +                }
> +            }
> +        }
> +
>          i = 0;
>          while ((name = cpu_model_advertised_features[i++]) != NULL) {
>              if (qdict_get(qdict_in, name)) {
> @@ -190,6 +207,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
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

