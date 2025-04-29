Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1684829DB6C
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 09:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745920300; cv=none; b=KbNvPUcmFDUFbpWLFQH5gSYcSru+YxshBnj/f+bVdAI+8V04HMCx1K06n3zDbwLmNSm5J2/aod0cNv4mhAUZJ2Zc2zI+NKvsCX/mrJ/aWR9eYEbnn0Ef22bPgjJtyWxWxPHq40YOrrrbdrpYtGsZsHr/n0EOrGXSLiEFevA5aDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745920300; c=relaxed/simple;
	bh=QgLaM7sqF85kXS0OF6on1ZJuRav3zv51FYJYHSpca7A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Jby7sOAUpjZ83OXai9Un+6Bvtm1bEQtS0MYIzotqhvjHFNxhCfRmq9y2tM8vRe6zkuJJ3ms0Vq8a6eWZpU8Hco3ondp9q6SpI+4xSDfYJijuSGXgxwIpND3VfWs2z02BFdksWtYnfPR4Q21Emyy+l6HyDdU2bsut10P67w6+9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkBQJVhh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkBQJVhh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745920297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+8GuoJpXHY67E9m4XDNSYfnUTPZKJt4wgqR5NSW8jI=;
	b=gkBQJVhhG6KLvA5ISg8ffiZclgS4mZHdfhco+dMlFs368EWFaelo5f8rngUODrKbMsPHQY
	lxnDqu/7cffXxB4xOh68X7pH6JGD/iMheFYKI9zFwthognKT5jUYDzVyYD/cSGKzFxk3Ca
	0z1tswrV73w9XvqWST7zcQ0PSibBTkw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-om2IXWQ8MdK3-8e0j9SxtQ-1; Tue,
 29 Apr 2025 05:51:33 -0400
X-MC-Unique: om2IXWQ8MdK3-8e0j9SxtQ-1
X-Mimecast-MFC-AGG-ID: om2IXWQ8MdK3-8e0j9SxtQ_1745920291
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C0081800360;
	Tue, 29 Apr 2025 09:51:30 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CD6C195608D;
	Tue, 29 Apr 2025 09:51:27 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH for-10.1 v5 08/13] arm/cpu: Store id_isar0-7 into the
 idregs array
In-Reply-To: <7424a39c-9bde-452e-99d5-a18bd9a432aa@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250409144304.912325-1-cohuck@redhat.com>
 <20250409144304.912325-9-cohuck@redhat.com>
 <7424a39c-9bde-452e-99d5-a18bd9a432aa@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 29 Apr 2025 11:51:25 +0200
Message-ID: <87frhrqorm.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Apr 28 2025, Eric Auger <eric.auger@redhat.com> wrote:

> On 4/9/25 4:42 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  hw/intc/armv7m_nvic.c     |  12 ++--
>>  target/arm/cpu-features.h |  36 +++++-----
>>  target/arm/cpu.c          |  24 +++----
>>  target/arm/cpu.h          |   7 --
>>  target/arm/cpu64.c        |  28 ++++----
>>  target/arm/helper.c       |  14 ++--
>>  target/arm/kvm.c          |  21 ++----
>>  target/arm/tcg/cpu-v7m.c  |  90 +++++++++++++-----------
>>  target/arm/tcg/cpu32.c    | 144 +++++++++++++++++++++-----------------
>>  target/arm/tcg/cpu64.c    | 108 ++++++++++++++--------------
>>  10 files changed, 243 insertions(+), 241 deletions(-)

>> @@ -599,13 +609,13 @@ static void cortex_r5_initfn(Object *obj)
>>      cpu->isar.id_mmfr1 = 0x00000000;
>>      cpu->isar.id_mmfr2 = 0x01200000;
>>      cpu->isar.id_mmfr3 = 0x0211;
>> -    cpu->isar.id_isar0 = 0x02101111;
>> -    cpu->isar.id_isar1 = 0x13112111;
>> -    cpu->isar.id_isar2 = 0x21232141;
>> -    cpu->isar.id_isar3 = 0x01112131;
>> -    cpu->isar.id_isar4 = 0x0010142;
>> -    cpu->isar.id_isar5 = 0x0;
>> -    cpu->isar.id_isar6 = 0x0;
>> +    SET_IDREG(isar, ID_ISAR0, 0x02101111);
>> +    SET_IDREG(isar, ID_ISAR1, 0x13112111);
>> +    SET_IDREG(isar, ID_ISAR2, 0x21232141);
>> +    SET_IDREG(isar, ID_ISAR3, 0x01112131);
>> +    SET_IDREG(isar, ID_ISAR4, 0x0010142);
>> +    SET_IDREG(isar, ID_ISAR5, 0x21232141);
> glurp this one is bad
> it should be SET_IDREG(isar, ID_ISAR5, 0x0);

Huh, no idea where that came from. Fixing.

