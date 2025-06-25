Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B48128935A
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869491; cv=none; b=OgIJnNJQiEZ1L87WTUzDF2wdgv2MPiT5KPJ04UPl9a5W8AiIQiAdLk18YQbKhEAZyf6G/XsZKRSCXjahopfcZyadISheqpa4wPl5Vt2cbMT6kzN6NmMjsglDn+uZxyqOU6yb0ajRVo6A/91d4Fq2ERly71EdhkJtDcsw86E5Hxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869491; c=relaxed/simple;
	bh=Z9ERmhepHwBvJ47JpkRd2f7oSMVE2aRZTimVKUdwW/M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=W9GgFdc80YYN0VErzeFoPBsWW2fbcPfyDnKMmCnbvQ/TB9CCFQKUZBfsXZiESVkqLzsjNa+Rg2GBf+GpBkiNo9TnuumzixJjX0H/eR/s9cE7GroqunYh1nxAEouWLGEKrXmA1agMiE6xDL2q4ULKAM9YdE/ZHeX8t2a6xqwt3HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=guS8dz6t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="guS8dz6t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750869488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oGUU/IPrSry2Fwx2P5b8O9w0u3Wyi69gqhC1KaKfI04=;
	b=guS8dz6tAhRd1aONf7FHgjpgZwkV+upD2Vel+m6aqyygwQDtLyHs4/lsotr35YIgLk04oX
	UYc9gwX/YmwKMtk3uYHNnzmG3fFuik9q6F63id2qWc3OjlvppfdNY2tacW8t3ioB2VVsTq
	dLjW8wRBLUCMdh2w5oyrqG+diDAJNXI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-zT2ApMJhOfizHJsQaD8EkA-1; Wed,
 25 Jun 2025 12:38:05 -0400
X-MC-Unique: zT2ApMJhOfizHJsQaD8EkA-1
X-Mimecast-MFC-AGG-ID: zT2ApMJhOfizHJsQaD8EkA_1750869483
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 119CB19560BA;
	Wed, 25 Jun 2025 16:38:02 +0000 (UTC)
Received: from localhost (mschlens-int.str.redhat.com [10.33.192.203])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD52F1956096;
	Wed, 25 Jun 2025 16:37:59 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>, eric.auger@redhat.com
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v8 00/14] arm: rework id register storage
In-Reply-To: <CAFEAcA95vCKpk1wXQh49xAWnqY=JZnKdr8NEQuYaRJr=jrKWyA@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250617153931.1330449-1-cohuck@redhat.com>
 <05e903b3-02bf-4c04-ac2b-cdec0b45fe3f@redhat.com>
 <CAFEAcA95vCKpk1wXQh49xAWnqY=JZnKdr8NEQuYaRJr=jrKWyA@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 25 Jun 2025 18:37:57 +0200
Message-ID: <87y0tfhj4q.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Jun 25 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Wed, 25 Jun 2025 at 10:10, Eric Auger <eric.auger@redhat.com> wrote:
>> However there are other checkpatch errors besides the one you reported, in
>> 52873a54ad arm/cpu: Store aa64isar0/aa64zfr0 into the idregs arrays
>> ERROR: line over 90 characters
>> #388: FILE: target/arm/kvm.c:225:
>> +    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >>
>> CP_REG_ARM64_SYSREG_OP0_SHIFT,
>>
>> ERROR: line over 90 characters
>> #389: FILE: target/arm/kvm.c:226:
>> +                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >>
>> CP_REG_ARM64_SYSREG_OP1_SHIFT,
>>
>> ERROR: line over 90 characters
>> #390: FILE: target/arm/kvm.c:227:
>> +                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >>
>> CP_REG_ARM64_SYSREG_CRN_SHIFT,
>>
>> ERROR: line over 90 characters
>> #391: FILE: target/arm/kvm.c:228:
>> +                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >>
>> CP_REG_ARM64_SYSREG_CRM_SHIFT,
>>
>> ERROR: line over 90 characters
>> #392: FILE: target/arm/kvm.c:229:
>> +                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >>
>> CP_REG_ARM64_SYSREG_OP2_SHIFT);
>>
>> WARNING: line over 80 characters
>> #396: FILE: target/arm/kvm.c:233:
>> +static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf,
>> ARMIDRegisterIdx index)
>
> The last one of those is probably easily fixed, but note the general
> remark in style.rst that it's better to have an overlong line than
> one with an awkward and unreadable wrapping. (We ought to fix
> checkpatch and style.rst to agree on whether to warn or error and
> whether that should be at 90 chars or 100 chars, but that would require
> reopening an old style argument and it's too much effort.)

I would not disagree with fixing the last one if wanted, but I think the
others are more readable if we do not try to break them up.

>
>> 5f15ebdf3f arm/cpu: Add sysreg definitions in cpu-sysregs.h
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #56: FILE: target/arm/cpu-sysregs.h:21:
>> +#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) NAME##_IDX,
>>
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #64: FILE: target/arm/cpu-sysregs.h:29:
>> +#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) \
>> +    SYS_##NAME = ENCODE_ID_REG(OP0, OP1, CRN, CRM, OP2),
>>
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #203: FILE: target/arm/cpu64.c:40:
>> +#define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
>> +    [NAME##_IDX] = SYS_##NAME,
>
> This is checkpatch not being able to cope with more complex
> uses of the preprocessor; the warning only makes sense for
> "acts like a function" macros.

Yep, that's why I ignored it.

In general, should we mention that we intentionally ignored
checkpatch.pl feedback, or would that be just noise?

