Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CA21B5EB5
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 13:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746020916; cv=none; b=qrPt/fWzIlQpiFKs3hzmjA/2cIdxO8arqw99l2dKcY1TinSU5+wrYwMiXwwj/R3KGuCTzpkweS5WjV2Fp6f//yBhVxRDP4HplifZRXnh9Hw7rE4093AHLm6U7Tbcm3qNMGpBtCJ6t4KkI3qPJFkG72jjA42HHopr9g+00P22wq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746020916; c=relaxed/simple;
	bh=F7OHKbHBAWKGpOsKHwFjNVum8HITE016F5PD2hFPHxw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pTMqz2sG2d8a3HHBkKaIPLzLz2Gtw/PBu4YiU8+9uPYL1zGiK+8Y3GQNSMxtdyYugAbal4aYeJachqh/ZEA2mY4gJQq+7Db7yD/a86RMX2w4XjZXOP8THpTsr/DcvNvwAwYnUJdI6R5TSrQCIIeXrXBrYeYAbP60SZuevAeia8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OC5SXcpT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OC5SXcpT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746020913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oLVOo1RS7FiUiZjstQUcuIC9vXhBzHVmV4xEjiYp0vQ=;
	b=OC5SXcpT8QaFPlinnbwu1WY11MeP65aFlwwsGvVJ1ECVgEQtkikjcB6JuyDe9PxZltzlt+
	6V7M0rlAthfgSKcoW5K82OS711aXNWllUHefbMfOxX1QVvBa6jerADsekt2Loe8F3HSF/4
	7+p4mqmlBMGuzrUvd1NPnYP9qscF6nQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-9t1_IlpnMES5Gy2AHNDGcA-1; Wed,
 30 Apr 2025 09:48:32 -0400
X-MC-Unique: 9t1_IlpnMES5Gy2AHNDGcA-1
X-Mimecast-MFC-AGG-ID: 9t1_IlpnMES5Gy2AHNDGcA_1746020910
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0574B1800446;
	Wed, 30 Apr 2025 13:48:29 +0000 (UTC)
Received: from localhost (unknown [10.67.24.156])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 100E919560A3;
	Wed, 30 Apr 2025 13:48:25 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 05/10] arm/cpu: accessors for writable id registers
In-Reply-To: <bebefcad-d9db-a2b7-ab69-8eed34b9e63d@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-6-cohuck@redhat.com>
 <bebefcad-d9db-a2b7-ab69-8eed34b9e63d@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 30 Apr 2025 15:48:19 +0200
Message-ID: <877c31rc9o.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Apr 29 2025, Sebastian Ott <sebott@redhat.com> wrote:

> On Mon, 14 Apr 2025, Cornelia Huck wrote:
>> Also add conversion between the different indices.
>>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>> target/arm/cpu.h | 18 ++++++++++++++++++
>> 1 file changed, 18 insertions(+)
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index bbee7ff2414a..775a8aebc5d3 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -876,6 +876,13 @@ typedef struct IdRegMap {
>>     uint64_t regs[NR_ID_REGS];
>> } IdRegMap;
>>
>> +#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               \
>> +        ({                                                              \
>> +                __u64 __op1 = (op1) & 3;                                \
>> +                __op1 -= (__op1 == 3);                                  \
>> +                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
>> +        })
>> +
>> /* REG is ID_XXX */
>> #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>>     ({                                                                  \
>> @@ -923,6 +930,17 @@ typedef struct IdRegMap {
>>         i_->idregs[REG ## _EL1_IDX];                                    \
>>     })
>>
>> +#define GET_IDREG_WRITABLE(MAP, REG)                                  \
>> +    ({                                                                \
>> +    const IdRegMap *m_ = (MAP);                                       \
>> +    int index = ARM_FEATURE_ID_RANGE_IDX((sysreg >> 14) & 0x0000c000, \
>> +                                         (sysreg >> 11) & 0x00003800, \
>> +                                         (sysreg >> 7) & 0x00000780,  \
>> +                                         (sysreg >> 3) & 0x00000078,  \
>> +                                         sysreg & 0x00000007);        \
>> +    m_->regs[index];                                                  \
>> +    })
>> +
>
> s/sysreg/REG/
>
> Also GET_IDREG_WRITABLE doesn't seem to be used in this series.

Hm, and it wouldn't have worked if we did use it... probably an artifact
left over from earlier refactorings, I think we can get rid of it.

