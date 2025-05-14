Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5645A2A1C9
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234561; cv=none; b=EIaq9p08KBl/1N3rY79f/bmwgdWG+hlEhPSG7e1p/mML2QSmTGQUOUFUXliFkirtlp79rI6oWBhXY6ItaAYj8B582/AT3P02aCtjrTTthP1Gr5CT2wE+P2U7Q/NzcOh7GcmACV5AnHfp9WgbUp8rU1kQw8FOIZNhTh7M4/P+Gm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234561; c=relaxed/simple;
	bh=qGiLF9ytS58FK0q3+DZsytBFXTwHwfBH8psHFPN+3Ig=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=loIaDcuLtdMu+p2N1wFdegyGA4Gdy0ui8dTATu3pqRtIhj2vjIqHW1T7jXSzZIZXldnpmI2bqggM/KPumoq+XEUiREVRFXpLFZA0NWYb7pmiUmWfZIOUvvO3RGVtmf52uvt+fxj1c3E5O0I3WjmmhDkXCWKWu9eI7Yrd4wRErsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aBtVfDvP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBtVfDvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747234558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gubBPWsy/XGhmDxkfMCBUD6QZxWOn0NBq1+dq/fTvQI=;
	b=aBtVfDvPS6v56MVwZdXQkkIeESXAJ1UWC9S+tC8cGp7K2FwULzH0eqrfjXN3w/Zq30gprr
	TdWvJQzrfA3N7mbPtBab3f/VNG5ig2kTIxX9J/d5kBounTHDdOHoewBIMM66+vMQ1UMqOw
	voEb+V5i+WAv6pSB4jMh9PnEoA1idRg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-Mj8NsofDMnClnEKQIjtqPw-1; Wed,
 14 May 2025 10:55:54 -0400
X-MC-Unique: Mj8NsofDMnClnEKQIjtqPw-1
X-Mimecast-MFC-AGG-ID: Mj8NsofDMnClnEKQIjtqPw_1747234552
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 590011956050;
	Wed, 14 May 2025 14:55:51 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9396018004A7;
	Wed, 14 May 2025 14:55:48 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, agraf@csgraf.de,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH v6 02/14] arm/cpu: Store aa64isar0/aa64zfr0 into the
 idregs arrays
In-Reply-To: <aCNvHgB0dzJIQ8Yt@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-3-cohuck@redhat.com> <aCNvHgB0dzJIQ8Yt@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 14 May 2025 16:55:46 +0200
Message-ID: <87bjrvckct.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, May 13 2025, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Tue, May 06, 2025 at 10:52:22AM +0200, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>=20
>> Also add kvm accessors for storing host features into idregs.
>>=20
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-features.h | 57 ++++++++++++++++++++-------------------
>>  target/arm/cpu.c          | 10 +++----
>>  target/arm/cpu.h          |  2 --
>>  target/arm/cpu64.c        |  8 +++---
>>  target/arm/helper.c       |  6 +++--
>>  target/arm/hvf/hvf.c      |  3 ++-
>>  target/arm/kvm.c          | 30 ++++++++++++++++++---
>>  target/arm/tcg/cpu64.c    | 44 ++++++++++++++++++------------
>>  8 files changed, 97 insertions(+), 63 deletions(-)
>>=20
>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 5e951675c606..dc4b6edaa1d6 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -2225,12 +2226,9 @@ static void arm_cpu_realizefn(DeviceState *dev, E=
rror **errp)
>>      }
>>=20=20
>>      if (!cpu->has_neon && !cpu->has_vfp) {
>> -        uint64_t t;
>
> Premature removal because ....
>
>>          uint32_t u;
>>=20=20
>> -        t =3D cpu->isar.id_aa64isar0;
>> -        t =3D FIELD_DP64(t, ID_AA64ISAR0, FHM, 0);
>> -        cpu->isar.id_aa64isar0 =3D t;
>> +        FIELD_DP64_IDREG(isar, ID_AA64ISAR0, FHM, 0);
>>=20=20
>>          t =3D cpu->isar.id_aa64isar1;
>
> ...it is still used here and so breaks the build.
>
> Your next patch removes this line, so just need
> to shift the variable removal to the next patch
>
>>          t =3D FIELD_DP64(t, ID_AA64ISAR1, FRINTTS, 0);

To a v7 it goes, hopefully the last one...

