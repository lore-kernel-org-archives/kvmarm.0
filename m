Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EF838DD1
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 14:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747145130; cv=none; b=kaQzGvUJH3rs82SIJA3esPrLL4z6qT7sf5tFusKQdOUND6yr0ye6GFVVyQjAKaMUYedvcit6aRqvegyS9R+hHRCwK6h5LTtp91AW72SZCMvPxiQ4tqhk86dM+gVbPYTYquYhUii3b8lV7FfA/rX0Za03aYatRa414HFN/NgFirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747145130; c=relaxed/simple;
	bh=SEbsiwXvvijSFLEv5MfxUiyzLL+EQKFbncmjFpPm3J8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HHRhpRqcNSHxLREw80/KC0x8hrXAL1xcyCgEXgJu59piUTsnpc1pR6gNu494OCsqr32ZB7bS5wgrptCUeBSTQ4KkmSEKwIjjOFXE447NM1kaFU1q0tOHlhRTdiNyH+OLg5aPtIWHc+ZUTJuUP/qAj4yniqUPCtTdYWks4wxkLFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BlX7XblM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BlX7XblM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747145127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uk82EjzJtnyar56E26L6uDoZS2+bPln9a7V28aPdNsM=;
	b=BlX7XblMcrSm0WXJavtHND4pfziY9/56Jv8GCbfBohbtLfsh6wkwS0bKkjMQa+mO0draG3
	FC7PvLRuM7xg0WSdk8DbfsZS4gRxqLFa/shBvDK2Ff03JHcPVe5hLiljv1AQwpxEosUreM
	3n/+I/qeOJ4X8PFwdyho6QQgTqBNTJg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-l9mYAlONNdeqolyRROXIag-1; Tue,
 13 May 2025 10:05:24 -0400
X-MC-Unique: l9mYAlONNdeqolyRROXIag-1
X-Mimecast-MFC-AGG-ID: l9mYAlONNdeqolyRROXIag_1747145122
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDD37195DE5B;
	Tue, 13 May 2025 14:05:20 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8CEE19373EB;
	Tue, 13 May 2025 14:05:18 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 01/10] arm/cpu: Add infra to handle generated ID
 register definitions
In-Reply-To: <6c06a198-1608-4919-8b6e-68e3c28c2526@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-2-cohuck@redhat.com>
 <6c06a198-1608-4919-8b6e-68e3c28c2526@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 13 May 2025 16:05:16 +0200
Message-ID: <87bjrwppwj.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie,
>
> On 4/14/25 6:38 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> The known ID regs are described in a new initialization function
>> dubbed initialize_cpu_sysreg_properties(). That code will be
>> automatically generated from linux arch/arm64/tools/sysreg. For the
>> time being let's just describe a single id reg, CTR_EL0. In this
>> description we only care about non RES/RAZ fields, ie. named fields.
>>
>> The registers are populated in an array indexed by ARMIDRegisterIdx
>> and their fields are added in a sorted list.
>>
>> [CH: adapted to reworked register storage]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-custom.h            | 60 ++++++++++++++++++++++++++++++
>>  target/arm/cpu-sysreg-properties.c | 41 ++++++++++++++++++++
>>  target/arm/cpu64.c                 |  2 +
>>  target/arm/meson.build             |  1 +
>>  4 files changed, 104 insertions(+)
>>  create mode 100644 target/arm/cpu-custom.h
> do we still want reference to the "custom" terminology, following
> initial comments?

Hm, maybe 'cpu-idregs.h'?

>>  create mode 100644 target/arm/cpu-sysreg-properties.c
>>
>> diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
>> new file mode 100644
>> index 000000000000..615347376e56
>> --- /dev/null
>> +++ b/target/arm/cpu-custom.h
>> @@ -0,0 +1,60 @@
>> +/*
>> + * handle ID registers and their fields
>> + *
>> + * SPDX-License-Identifier: GPL-2.0-or-later
>> + */
>> +#ifndef ARM_CPU_CUSTOM_H
>> +#define ARM_CPU_CUSTOM_H
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "cpu.h"
>> +#include "cpu-sysregs.h"
>> +
>> +typedef struct ARM64SysRegField {
>> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
>> +    int index;
> worth to add a comment saying this is the ARMIDRegisterIdx of the parent
> sysreg.

ok

>> +    int lower;
>> +    int upper;
>> +} ARM64SysRegField;
>> +
>> +typedef struct ARM64SysReg {
>> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
>> +    ARMSysRegs sysreg;
>> +    int index;
> now that we have different kinds of indexing, may be worth adding a
> comment to explain which one is being used.
> I guess here it is ARMIDRegisterIdx. So you could even change the data type.

Yeah, comments are good, I'll add some.

>> +    GList *fields; /* list of named fields, excluding RES* */
>> +} ARM64SysReg;
>> +
>> +void initialize_cpu_sysreg_properties(void);
>> +
>> +/*
>> + * List of exposed ID regs (automatically populated from linux
>> + * arch/arm64/tools/sysreg)
>> + */
>> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>> +
>> +/* Allocate a new field and insert it at the head of the @reg list */
>> +static inline GList *arm64_sysreg_add_field(ARM64SysReg *reg, const char *name,
>> +                                     uint8_t min, uint8_t max) {
>> +
>> +     ARM64SysRegField *field = g_new0(ARM64SysRegField, 1);
>> +
>> +     field->name = name;
>> +     field->lower = min;
>> +     field->upper = max;
>> +     field->index = reg->index;
>> +
>> +     reg->fields = g_list_append(reg->fields, field);
>> +     return reg->fields;
>> +}
>> +
>> +static inline ARM64SysReg *arm64_sysreg_get(ARMIDRegisterIdx index)
>> +{
>> +        ARM64SysReg *reg = &arm64_id_regs[index];
>> +
>> +        reg->index = index;
>> +        reg->sysreg = id_register_sysreg[index];
>> +        return reg;
>> +}
>> +
>> +#endif
>> diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
>> new file mode 100644
>> index 000000000000..8b7ef5badfb9
>> --- /dev/null
>> +++ b/target/arm/cpu-sysreg-properties.c
>> @@ -0,0 +1,41 @@
>> +/*
>> + * QEMU ARM CPU SYSREG PROPERTIES
>> + * to be generated from linux sysreg
>> + *
>> + * Copyright (c) Red Hat, Inc. 2024
> maybe increment the year now ;-)

Wait, it is 2025 already? :)

