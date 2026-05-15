Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355963FF1DE
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860781; cv=none; b=d1E0gNYV/arOxxqv46XTTgWkvcKdIsq7DRkr/ZAOCxL5oYDN+28TMgTiUecxob2yiEgHsPMqCAkAcUeUpoZwBSX4GuhgJDYUX75qYhePOqf8yq86/8GkJPW+p8VKCJZgaWLgUDpMUEZOCu1CufqDzgjT8RLn09youUIq2kZXBhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860781; c=relaxed/simple;
	bh=JaUlt5b1vX2pHIWlYNxG6k1fvcKQdAne/3fvLwksa8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDHtB7gb+FL/nTButAZ0uWfpjjR/3X7m7R1wHFuiU72t4aIlwx3W6yTjobQm0gxwM2FC/j7GuQdMwuvdo4fQDUdyCWigndHAY735LAO1kHhsz1UzFHSSPH3CyCkYjnNwEdkRyS34ndpV+pXPo9O5QQLqZUGxLp9+7MLg8JpCqs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SykSkq0x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SykSkq0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778860778;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FC3oLSmnu8UdvlNQM2aun6fDBDKWRYloibSa7BMlBRo=;
	b=SykSkq0x0lrG1U2U1VJr22//eJh4e2qyy7n9NLRt8+usxu0wbYUfLomB51nU8TuzUGUtg1
	YyBjxWWBNDl5CNLViOaA5YYiCcvqGS/c8FCNBBkGieDFX+xgMK5OSpZrq0kQH2x9ph0rj1
	2XPgQqhXBwbPmPgjnHD8S/Ffk0dLEA4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-9Cy0a_K3PxaQMfVQdIKrlQ-1; Fri, 15 May 2026 11:59:37 -0400
X-MC-Unique: 9Cy0a_K3PxaQMfVQdIKrlQ-1
X-Mimecast-MFC-AGG-ID: 9Cy0a_K3PxaQMfVQdIKrlQ_1778860776
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fdad6cce4so5480305e9.1
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 08:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778860776; x=1779465576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FC3oLSmnu8UdvlNQM2aun6fDBDKWRYloibSa7BMlBRo=;
        b=Zn6vyXoFN8pLC+aoUONeyax2Tp91WAoH3CmMvY2tj8tLPk1FU2dGoYMroPkgf1odbT
         9mhF9sGFZgFnJ29B3Fi7ri4PYQS4U/x74+okiQ6BUAzb1PM9/Wovq4W3pXxd6iHuDbB/
         joXbCNEpPOkO6r2wyWucSw6bb2pQkAGMWwn9FhXqJ0mkzRtQjyKlW5JHFD1rWZ2FqjeC
         9Uvz04r3G+8ZvBhEUzH3NgbYh0EDdBJbxcrE3RoNqtI2i7SkbWd9qNoTMK7sBFEfHUN9
         q8BsqrHpGL/8aNAJ/uGShKtWRB9wj9iCHKB4sUHIHhDdd0TvcDOwBnVg5sqQZb5twq/t
         GuZw==
X-Forwarded-Encrypted: i=1; AFNElJ/o1k/qkXevqlNPTsafBHHIw2XeWJy+gPcFZzsf3L15g62UtdASI5/a5RqdkgWZS2PZDH39jA4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdHoi6coSHnGfVGA/+vRCdhpejhXws0wtbyQEn3Hrq3T45oUip
	fjIb3gHdDLXJCiQqtiBAiIOJp2d1OsMGolwttkRkC6QiDC4+JGtnNkFuWY+QuFpboIQyypUCbyY
	A4U/cZRZB1O/aiPoU0+cSO49iDCeYq4d1KsUGzlm3tcEOGwsGqRNJaJO3NQ==
X-Gm-Gg: Acq92OEc44iYek48m0LVobtTxWdirwBoZ4+ZOycEscWSoHnP85af8VutmhqYQb/6V7m
	fIKswbOUhFdO1RQzo4PtWC/Al697WMu5ZByKrQWIhcNgM9ZBAjHngDbU/6Rq2hPEpGF6ByTrlka
	aa+zSEw7xouWHKUpPNRn3H2MjP8jaawuXjhDd2pJdMf3UFGfK63FARQhsQfXOEzCif/cZDjbeNw
	1wAfMpYAcn7H14YBvd8USJRnuwXmM/9Z9CN6iFRQZFnf1PqyQkXqc0SEo2d7XDN6jgMH/Wysr2r
	swv8SOJ89CjsVfsFSKHCbhR9mIlod9MqY9Svyk4DyXB06cUvq26UkBs0d2w3+sjku2FzVl0xsH/
	bRE+XXUDlEVcdqN406ozxmo8xp51nsSL+HM46eCr3ZI0ly3if4uEEX0seh8tdEyPPNZF9Hw==
X-Received: by 2002:a05:600c:609b:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-48fe4cadfeemr70353445e9.2.1778860775654;
        Fri, 15 May 2026 08:59:35 -0700 (PDT)
X-Received: by 2002:a05:600c:609b:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-48fe4cadfeemr70353085e9.2.1778860775243;
        Fri, 15 May 2026 08:59:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe6b60csm24134215e9.6.2026.05.15.08.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 08:59:34 -0700 (PDT)
Message-ID: <a73c5f14-ed64-4322-8315-482e5b621add@redhat.com>
Date: Fri, 15 May 2026 17:59:32 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v1 06/13] target/arm: named_cpu_model: data-structures
 required for the ARM property layer.
To: Shaju Abraham <shaju.abraham@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
 skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
 Khushit Shah <khushit.shah@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-7-shaju.abraham@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260513163356.3033159-7-shaju.abraham@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QdKhfH4MTArvTgV45lmlvcZP4K_Spo_gMzcm44nzw4o_1778860776
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/13/26 6:33 PM, Shaju Abraham wrote:
> Introduce data-structures required for the ARM property layer. There are
> four classes of properties:
>     STRING: Multi-bit fields with arch-defined named values, such as
>             ("off", "aes", "pmull", ...).
when you say "arch defined named values", if we take for instance SHA2
field of ID_AA64ISAR0

+IDREG_FIELD_START(ID_AA64ISAR0, SHA2,    12,  4, LOWER,  0)
+IDREG_FIELD_ARCH_VAL(0b0000, "off")
+IDREG_FIELD_ARCH_VAL(0b0001, "sha256")
+IDREG_FIELD_ARCH_VAL(0b0010, "sha512")
+IDREG_FIELD_END(ID_AA64ISAR0, SHA2)


I don't see such string value in the ARM ARM:

0b0000 No SHA2 instructions implemented.
0b0001 Implements instructions: SHA256H, SHA256H2, SHA256SU0, and SHA256SU1.
0b0010 Implements instructions: • SHA256H, SHA256H2, SHA256SU0, and
SHA256SU1. • SHA512H, SHA512H2, SHA512SU0, and SHA512SU1.

Where did you get those arch defined strings? The only source I can see
is linux sysreg and I am not sure this can be used as a reference.

Looking at  target/arm/cpu-idregs.h.inc

+IDREG_FIELD_START(ID_AA64ISAR0, TLB,     56,  4, LOWER,  0)
+IDREG_FIELD_ARCH_VAL(0b0000, "off")
+IDREG_FIELD_ARCH_VAL(0b0001, "os")
+IDREG_FIELD_ARCH_VAL(0b0010, "range")
+IDREG_FIELD_END(ID_AA64ISAR0, TLB)

it looks not straightforward to link with ARM ARM 

TLB, bits [59:56] Indicates support for Outer Shareable and TLB range
maintenance instructions. The value of this field is an IMPLEMENTATION
DEFINED choice of: 0b0000 Outer Shareable and TLB range maintenance
instructions are not implemented. 0b0001 Outer Shareable TLB maintenance
instructions are implemented. 0b0010 Outer Shareable and TLB range
maintenance instructions are implemented. All other values are reserved.
FEAT_TLBIOS implements the functionality identified by the values 0b0001
and 0b0010. FEAT_TLBIRANGE implements the functionality identified by
the value 0b0010. From Armv8.4, the only permitted value is 0b0010.
Access to this field is RO


Thanks

Eric
>     BOOLEAN: 1-bit fields.
>     NUMERIC: Numeric values like cache geometry, debug counter widths, etc.
>     FRACTIONAL: Paired (base, frac) fields exposed as a single "M.F" string
>           (e.g., CSV2/CSV2_FRAC, MPAM/MPAM_FRAC, RAS/RAS_FRAC, NV/NV_FRAC).
>
> Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
> Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
> ---
>  target/arm/arm-cpu-props.h | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 target/arm/arm-cpu-props.h
>
> diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
> new file mode 100644
> index 0000000000..1dc3786ea9
> --- /dev/null
> +++ b/target/arm/arm-cpu-props.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * ARM CPU feature properties.
> + *
> + * User-facing QOM properties that map to fields of the AArch64 ID
> + * registers described in cpu-idregs.inc.h.
> + *
> + */
> +
> +#ifndef ARM_CPU_PROPS_H
> +#define ARM_CPU_PROPS_H
> +
> +#include "cpu-idregs.h"
> +
> +typedef enum ArmCpuPropType {
> +    ARM_PROP_STRING,
> +    ARM_PROP_BOOLEAN,
> +    ARM_PROP_NUMERIC,
> +    ARM_PROP_FRACTIONAL,
> +} ArmCpuPropType;
> +
> +typedef struct ArmFracVal {
> +    const char *name;
> +    uint64_t base_val;
> +    uint64_t frac_val;
> +} ArmFracVal;
> +
> +typedef struct ArmCpuPropDesc {
> +    const char *name;
> +    ArmCpuPropType type;
> +    ArmFieldIdx base_field;
> +    ArmFieldIdx frac_field;
> +    const ArmFracVal *vals;
> +} ArmCpuPropDesc;
> +
> +#endif

