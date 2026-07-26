Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398C02D0C62
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785072879; cv=none; b=hjejZW1e4QEQbcwlrop6hqsv2L1pkLBMyNRgYtKfGjiWdOZtotJJ/K2f/mrOKBos19MSsRTBNLBdPN0l6stbcPuL940bJojS5cmYHmjlpdlkKKMHaGicvd6h2JhQcTjE8XXnZMPD8R5I42prkkYidTTcbRShc5hZcJ/zGxw6rGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785072879; c=relaxed/simple;
	bh=uAxWro1LWuNoP/oi+Fk1H04GQewoKmhEflyVkzL8pj8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=SefYQ1aeSMGFm/S2+MYPY/RSz35Ei+ZPDvJ5ICTFBxqhulq7WrECKdfCRtfQLG0AABdJPVwPDSSfw4VfcLygjkuupTLE8kBMLJBiGAMjbw5nREta0hSPDgAqJcYqZGRGzNW2i3AtMtDwfW3HflaB1hIQA9OPFZYEnjr6ERSxgIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8uOeTS8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8uOeTS8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785072876;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ndIDNx/XWo57F2qOFIBY/S7J+ZAldG16dMk/9EFoRc=;
	b=N8uOeTS8KCT3efcGwCTe8Gy1XeXqV63FXSna5b2HcN8hjjmTYdFvF0vABMtPOtdtJ+EFPs
	waOIxdTutmtbrt7eA9jCpbcrG0nyaatmu+ouUh7E3rYQynQtXhYt4xG2+uikV3sQIvo3Qm
	MAaXFrMG2072LDcSgKTbqN9HmczP8jA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-e4uKw_ZBNoq3XUOYi4XCiA-1; Sun, 26 Jul 2026 09:34:34 -0400
X-MC-Unique: e4uKw_ZBNoq3XUOYi4XCiA-1
X-Mimecast-MFC-AGG-ID: e4uKw_ZBNoq3XUOYi4XCiA_1785072874
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955ecd8a10so18339365e9.3
        for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 06:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785072873; x=1785677673;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:reply-to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ndIDNx/XWo57F2qOFIBY/S7J+ZAldG16dMk/9EFoRc=;
        b=NMASNj1BCta+Mml+6vsiMVn/BHFChGHKOASI40rnJqJGwy9EfCDFcHdPv/iRFwqPeT
         B+r+4WcjqlnvRT9aGASCnitufXGr6hwwroFpYb48fZJ47t9gsUx2Q1RXQS7plsJ19qQ5
         usD4JoXXCvSd4UMVkwZ6YAfI9RryTFozKOXoxf4+TQOXw1hiDjvIHUftJ80/nibVyPqR
         s79qMqio9v92XWJlegzKv8/6IC/SZS2iMfIqHlxPdjCl7ISsEJBddZaymcNTJE2EyN15
         Km2yDXcyL4wmFi4SAHDheJeLOjHCvlhBuGAAqxS2dh6h76gjcFihIXIjG27mcnIpNmrg
         NAlg==
X-Forwarded-Encrypted: i=1; AHgh+RpMxzfbZdTEqGT7rTlReLyRVWsVtyx2NiSSAkcDhs0MxNV14UY5wUcuuLQNu/AMqpIq6ueeTKc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYa+79gmiUZApBzNaL9BmJvTcFdvN/vcJAYR+MPw5fRW308qTY
	SJ3KL5d8rE45NK5PGReKyPekskgybiN3c+uggvMiT8SheQxrermyT9fypbYfcatwuZlPQKuOkRG
	5lDZnFGhH9euWOcF6/7Y6xewXhuCOwVhRTevSl6Q28bmBANty7twTj6EPrw==
X-Gm-Gg: AR+sD10+wB+a6tFcVUeNVSqIbvYIng6UitJhJon2fmHhIhx2DiZAiBm2zoQJGPvw1Zm
	m1JAtVZVdM7NPJjjFj//y9A0OYmoJTSzdX3uOVGUZQoZi/boVJj0arq32WxW+hP9oo+2fIQjtZ4
	tPKIPcmimi/eG0fJMx4UBVZABUCB7xuThoEJVqYikv+XZeUUbOMSX5c2nKTn3ejV2nSFW2ipTQe
	TpZJ21UKf2eEdym7PqPKmZPdAmnnxJgiPeX3BEBcAzUTHa7fZ3/xw2rfhI+/3eMCt7NxvqMSzqH
	hnl8SlGUH1kCnaNn82b/ea6JD/04n8qbvMjqFwcLkV8j7bGxuB6RJHPVe1n4YHWtwW7Un/zxvFe
	26OlRDCuHpiOXjQ04Tp4t/PyQfytALvlJOdE=
X-Received: by 2002:a05:600c:3b17:b0:495:5b02:23a8 with SMTP id 5b1f17b1804b1-496b570f00dmr76726185e9.34.1785072873459;
        Sun, 26 Jul 2026 06:34:33 -0700 (PDT)
X-Received: by 2002:a05:600c:3b17:b0:495:5b02:23a8 with SMTP id 5b1f17b1804b1-496b570f00dmr76725605e9.34.1785072872971;
        Sun, 26 Jul 2026 06:34:32 -0700 (PDT)
Received: from [192.168.3.191] (228.246.150.77.rev.sfr.net. [77.150.246.228])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531basm43542454f8f.19.2026.07.26.06.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 06:34:32 -0700 (PDT)
Message-ID: <4f07607b-b21a-4a5c-8daa-6aec5e288353@redhat.com>
Date: Sun, 26 Jul 2026 15:34:28 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC PATCH v3 09/19] target/arm: Add named cpu model infra +
 graviton3 named model
Reply-To: eric.auger@redhat.com
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-10-khushit.shah@nutanix.com>
In-Reply-To: <20260716213858.609699-10-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kisuEbIFGn_D_l4Tmti57AwtZc6Iqcp0WMcSWaWOh7s_1785072874
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 7/16/26 11:38 PM, Khushit Shah wrote:
> From: Shaju Abraham <shaju.abraham@nutanix.com>
>
> Introduce a small named-CPU-model layer on top of the field-backed
> property infrastructure. Each model is a flat table of (name, value)
> overrides and a parent pointer. At instance-init, the parent chain is
> walked root-first and every level's properties are applied via QOM,
> so a child entry overrides its ancestors for the same name.
>
> For example, the graviton3-v1 named model hierarchy is:
> non-zero-defaults-v1    Known non-zero default ID regs field values
>   arm-v8_4-a-v1       ARMv8.4-A architectural mandate
>     neoverse-v1-v1    Neoverse V1
>       graviton3-v1    AWS Graviton3
>
> non-zero-defaults-v1:
>    Field that should be populated with some non zero value by default.
following which specification? This is not clear to me. Is that layer
really meaningful? Shouldn't we start with the next one?
>
> arm-v8_4-a-v1:
>   Only features mandated by the ARM ARM.
>
> neoverse-v1-v1:
>   Reference manual derived feature values for the reference core.
>   Values differ from TRM values based on what was exposed to the guest
>   with -cpu host.
>
> graviton3-v1:
>   SoC integration choices (crypto pin, cache hints, PAuth alg).
>
> The model values are figured out from ID register dump visible to
> QEMU with -cpu host on Graviton3 machine.
>
> Model realization:
> 1. Zero out ID regs array.
> 2. Add all properties to the CPU Object
> 3. arm_realize_model_chain: Walk the parent chain from root first and
>                             apply all the properties.
>
> Co-authored-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  hw/arm/virt.c               |   5 +
>  target/arm/arm-cpu-models.c | 336 ++++++++++++++++++++++++++++++++++++
>  target/arm/arm-cpu-models.h |  35 ++++
>  target/arm/meson.build      |   7 +-
>  4 files changed, 381 insertions(+), 2 deletions(-)
>  create mode 100644 target/arm/arm-cpu-models.c
>  create mode 100644 target/arm/arm-cpu-models.h
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index fe19030886..34e56dc1f1 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -3812,6 +3812,11 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
>              g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("host")));
>          }
>      }
> +    if (kvm_enabled() && target_aarch64()) {
> +        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v8_4-a-v1")));
> +        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1-v1")));
> +        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton3-v1")));
> +    }
>      g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("max"))); return vct; diff --git a/target/arm/arm-cpu-models.c
> b/target/arm/arm-cpu-models.c new file mode 100644 index
> 0000000000..747e0df010 --- /dev/null +++ b/target/arm/arm-cpu-models.c
> @@ -0,0 +1,336 @@ +/* + * ARM named CPU model definitions. + * + *
> Each model is defined as an array of MODEL_PROP macro, listing only +
> * the properties that DIFFER from the parent model. + * + * At
> realisation the parent chain is walked root-first and + * every
> level's props are applied via QOM, so the leaf's values + * naturally
> override its ancestors. + * + * Hierarchy: + * + *
> non-zero-defaults-v1 Known non-zero default ID reg field values + *
> arm-v8_4-a-v1 ARMv8.4-A architectural mandate + * neoverse-v1-v1
> Neoverse V1 (TRM 102649) + * graviton3-v1 AWS Graviton3 + * + *
> SPDX-License-Identifier: GPL-2.0-or-later + */ + +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "system/kvm.h"
> +#include "cpu.h"
> +#include "internals.h"
> +#include "kvm_arm.h"
> +#include "arm-cpu-models.h"
> +#include "cpu-idregs.h"
> +
> +#define MODEL_PROP_FIELD_STR  str
> +#define MODEL_PROP_FIELD_BOOL b
> +#define MODEL_PROP_FIELD_NUM  num
> +
> +#define MODEL_PROP(_name, _type, _value) \
> +    { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
> +      .u.MODEL_PROP_FIELD_##_type = (_value) }
> +
> +#define MODEL_PROP_END  { .name = NULL }

Regarding settings somehow we end up with something that is quite
similar to TCG CPU
definitions like in
aarch64_neoverse_n1_initfn(). To me this is in general more readable
because we use name fields instead of putting the full reg value.
This does not prevent us from adding comments along settings to make
this more readable and explicit.
> +
> +/*
> + * These fields should be populated with some non-zero default values.
> + */
> +static const ArmModelPropValue non_zero_defaults_v1_props[] = {
> +    /* ID_AA64PFR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL0", NUM, 0b0001),
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL1", NUM, 0b0001),
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 0b1111),
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 0b1111),
> +
> +    /* ID_AA64PFR1_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0b1111),
so I still believe we want a wrapper that transparently either sets a
prop if the field happens to be writable or simply performs checks
against the host if the prop is not available.
> +
> +    /* ID_AA64MMFR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0b1111),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0b1111),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 0b0001),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 0b0001),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 0b0001),
> +
> +    /* ID_AA64DFR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DebugVer", NUM, 0x6),
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0b1111),
> +
> +    /* CTR_EL0 */
> +    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 0b10),
> +    MODEL_PROP("SYSREG_CTR_EL0_RES1_31", NUM, 1),
> +
> +    /* ID_AA64MMFR4_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0b1111),
> +
> +    MODEL_PROP_END,
> +};

To ease the review I would suggest to put a dump of all id regs of a
leaf model in the commit description. It is less error prone that
understanding the various overrides.
I would suggest to have separate patches for each model too.

So you said a leaf model shall have explicit values for each field,
including non writable ones. The code does not check that. How do we
make sure we are not missing settings?

> +
> +static const ArmModelPropValue armv8_4_a_v1_props[] = {
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_CRC32", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_Atomic", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_LO", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_RAS_frac", NUM, 0),
> +
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_PAN", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_UAO", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_CnP", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IESB", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_DIT", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DebugVer", NUM, 9),
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_PMUVer", NUM, 5),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TS", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_LRCPC", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_AT", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IDS", NUM, 1),
> +    /* KVM zeroes out these field when MTE is not enabled. */
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0),
> +    MODEL_PROP_END,
> +};
> +
> +static const ArmModelPropValue neoverse_v1_v1_props[] = {
> +    MODEL_PROP("SYSREG_MIDR_EL1_Implementer", NUM, 0x41),
> +    MODEL_PROP("SYSREG_MIDR_EL1_Variant", NUM, 0x1),
> +    MODEL_PROP("SYSREG_MIDR_EL1_Architecture", NUM, 0xF),
> +    MODEL_PROP("SYSREG_MIDR_EL1_PartNum", NUM, 0xD40),
> +    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_BRPs", NUM, 0x5),
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_WRPs", NUM, 0x3),
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_CTX_CMPs", NUM, 0x1),
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0xF),
> +
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RDM", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_DP", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_FHM", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_JSCVT", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FCMA", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_BF16", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DGH", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_I8MM", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_RAS_frac", NUM, 0),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_CSV2_frac", NUM, 0),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV3", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_SSBS", NUM, 2),
> +
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_PARange", NUM, 5),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_ASIDBits", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_BigEnd", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_SNSMem", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 0),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 0),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 0),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HAFDBS", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VMIDBits", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VH", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_XNX", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_SpecSEI", NUM, 0),
> +
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_FWB", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_BBM", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_EVT", NUM, 2),
> +
> +    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0),
> +
> +    MODEL_PROP("SYSREG_CTR_EL0_IminLine", NUM, 4),
> +    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 3),
> +    MODEL_PROP("SYSREG_CTR_EL0_DminLine", NUM, 4),
> +    MODEL_PROP("SYSREG_CTR_EL0_ERG", NUM, 4),
> +    MODEL_PROP("SYSREG_CTR_EL0_CWG", NUM, 4),
> +
> +    MODEL_PROP("SYSREG_DCZID_EL0_BS", NUM, 0x4),
> +
> +    /* pauth */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_APA", NUM, 3),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_GPA", NUM, 1),
> +
> +    /* sve */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_SVE", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_BF16", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_I8MM", NUM, 1),
> +    MODEL_PROP("sve128", BOOL, true),
> +
> +    MODEL_PROP_END,
> +};
> +
> +static const ArmModelPropValue graviton3_v1_props[] = {
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_AES", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA1", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA2", NUM, 2),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA3", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM3", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM4", NUM, 1),
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RNDR", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_CTR_EL0_IDC", NUM, 1),
> +    MODEL_PROP("SYSREG_CTR_EL0_DIC", NUM, 1),
> +
> +    MODEL_PROP("SYSREG_REVIDR_EL1_VAL", NUM, 1),
> +
> +    MODEL_PROP_END,
> +};
> +
> +static const ArmNamedCpuModel arm_cpu_models[] = {
> +    {
> +        .name   = "non-zero-defaults-v1",
> +        .parent = NULL,
> +        .props  = non_zero_defaults_v1_props,
> +    },
> +    {
> +        .name   = "arm-v8_4-a-v1",
> +        .parent = "non-zero-defaults-v1",
> +        .props  = armv8_4_a_v1_props,
> +    },
> +    {
> +        .name   = "neoverse-v1-v1",
> +        .parent = "arm-v8_4-a-v1",
> +        .props  = neoverse_v1_v1_props,
> +    },
> +    {
> +        .name   = "graviton3-v1",
> +        .parent = "neoverse-v1-v1",
> +        .props  = graviton3_v1_props,
> +    },
> +};
> +
> +static ARMCPUInfo arm_named_cpu_infos[ARRAY_SIZE(arm_cpu_models)];
> +const ArmNamedCpuModel *arm_find_model(const char *name)
> +{
> +    size_t i;
> +    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
> +        if (g_str_equal(arm_cpu_models[i].name, name)) {
> +            return &arm_cpu_models[i];
> +        }
> +    }
> +    return NULL;
> +}
> +
> +static void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
> +                                  Error **errp)
> +{
> +    const ArmModelPropValue *pv;
> +    ERRP_GUARD();
> +
> +    for (pv = props; pv->name; pv++) {
> +        switch (pv->type) {
> +        case ARM_MODEL_PROP_BOOL:
> +            object_property_set_bool(obj, pv->name, pv->u.b, errp);
> +            break;
> +        case ARM_MODEL_PROP_NUM:
> +            object_property_set_uint(obj, pv->name, pv->u.num, errp);
> +            break;
> +        default:
> +            g_assert_not_reached();
> +        }
> +        if (*errp) {
> +            error_prepend(errp, "property '%s': ", pv->name);
> +            return;
> +        }
> +    }
> +}
> +
> +static void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
> +                                    Error **errp)
> +{
> +    const ArmNamedCpuModel *cur, *parent;
> +    const ArmNamedCpuModel *chain[ARRAY_SIZE(arm_cpu_models)];
> +    size_t depth = 0;
> +    for (cur = model; cur; ) {
> +        if (depth >= ARRAY_SIZE(chain)) {
> +            error_setg(errp, "model '%s': parent chain too deep "
> +                       "(possible cycle)", model->name);
> +            return;
> +        }
> +        chain[depth++] = cur;
> +
> +        if (!cur->parent) {
> +            break;
> +        }
> +        parent = arm_find_model(cur->parent);
> +        if (!parent) {
> +            error_setg(errp, "model '%s': unknown parent '%s'",
> +                       cur->name, cur->parent);
> +            return;
> +        }
> +        cur = parent;
> +    }
> +
> +    while (depth--) {
> +        arm_apply_model_props(obj, chain[depth]->props, errp);
> +        if (*errp) {
> +            return;
> +        }
> +    }
> +}
> +
> +static void arm_named_cpu_initfn(Object *obj)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
> +    const ArmNamedCpuModel *model = arm_find_model(acc->info->name);
> +    if (!model) {
> +        error_report("'%s' CPU model entry not found)",
> +                     acc->info->name);
> +        return;
> +    }
> +
> +    if (!kvm_enabled()) {
> +        error_report("'%s' CPU model requires KVM (-accel kvm)",
> +                     acc->info->name);
> +        return;
> +    }
> +
> +    kvm_arm_set_cpu_features_from_host(cpu);
> +    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
> +        return;
> +    }
> +
> +    /* 1. Reset ID regs to 0 */
> +    memset(cpu->isar.idregs, 0, sizeof(cpu->isar.idregs));
> +
> +    /* 2. Add sveNNNN and SYSREG_ properties */
> +    aarch64_add_sve_properties(obj);
> +    aarch64_add_idregs_properties(obj);
> +
> +    /* 3. Realize the model chain. */
> +    arm_realize_model_chain(obj, model, &error_abort);
> +}
> +
> +void arm_register_named_cpu_models(void)
> +{
> +    size_t i;
> +    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
> +        arm_named_cpu_infos[i].name = arm_cpu_models[i].name;
> +        arm_named_cpu_infos[i].initfn = arm_named_cpu_initfn;
> +        arm_cpu_register(&arm_named_cpu_infos[i]);
> +    }
> +}
> +
> +type_init(arm_register_named_cpu_models)
> diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
> new file mode 100644
> index 0000000000..ac4e510499
> --- /dev/null
> +++ b/target/arm/arm-cpu-models.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * ARM named CPU model definitions - public API.
> + */
> +#ifndef ARM_CPU_MODELS_H
> +#define ARM_CPU_MODELS_H
> +
> +#include "qapi/error.h"
> +#include "qom/object.h"
> +
> +typedef enum ArmModelPropType {
> +    ARM_MODEL_PROP_BOOL,
> +    ARM_MODEL_PROP_NUM,
> +} ArmModelPropType;
> +
> +typedef struct ArmModelPropValue {
> +    const char     *name;
> +    ArmModelPropType type;
> +    union {
> +        bool            b;
> +        uint64_t        num;
> +    } u;
> +} ArmModelPropValue;
> +
> +typedef struct ArmNamedCpuModel {
> +    const char              *name;
> +    const char              *parent;
> +    const ArmModelPropValue *props;
> +} ArmNamedCpuModel;
> +
> +void arm_register_named_cpu_models(void);
> +
> +const ArmNamedCpuModel *arm_find_model(const char *name);
> +
> +#endif /* ARM_CPU_MODELS_H */
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index 64d1ec63ab..72eed1bcc6 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -10,7 +10,7 @@ arm_user_ss.add(files('gdbstub.c'))
>  
>  arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
>    'cpu64.c',
> -  'gdbstub64.c'
> +  'gdbstub64.c',
>  ))
>  
>  arm_common_ss.add(files(
> @@ -21,7 +21,10 @@ arm_common_system_ss.add(files(
>    'arm-qmp-cmds.c',
>    'cpu-idregs.c',
>  ))
> -arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
> +arm_system_ss.add(when: 'TARGET_AARCH64', if_true: files('arm-cpu-models.c'))
> +arm_system_ss.add(when: 'CONFIG_KVM',
> +                  if_true: files('hyp_gdbstub.c',
> +                                 'kvm.c'))
>  arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
>  
>  arm_user_ss.add(files('cpu.c'))
Thanks

Eric

