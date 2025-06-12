Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A577C298994
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742590; cv=none; b=uTOehpqoy1Xhofit2x15bs5BOQMsQwhaWT5+2lRNIvKrx58s94imfV3HoH5vtyT6yoVuOWNVKShA7qWVK17kange9Q0uImNaUg7cWQH7UYuSGZjnPboZhXfTmPW+FEd6GQeYvkBIh85vH6lDv0EXTaBogEb0zTGtaRrdsc0p1uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742590; c=relaxed/simple;
	bh=7sfj9voWMza4zwFgAk0QKq1V1KsMMEUZstGi1LbMII4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hek4PiR1mNhuNWCWPWXvteeVo1yAbiRJhrPEpNEvg57awiMbiZ+7eMobiAjfef8j4N1LpdKY540GYfJ3dM1ODy+EBvZnhTjaSOmC4FjgkHyKTzcHghBWcle9Fk+c4TIjtnAa81snlmjwL83XybQKIYQqd7SYU+uZWrybgidLM8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SwKbuzro; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SwKbuzro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749742587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aN7OZ8GnoaJUynVwVsXnb6hzJQk2C53xbbNuavIdXdE=;
	b=SwKbuzroecdd7dBNRX3Klq/m0MmzMYjVNpA4NEHBRscvYpeikff07FmWlYNB2G28Y1mRO2
	Dc1uE168JFDiZOxMRKVUOFGnKHh5QLIgKb+v/BUGyzhm6KOhFz0UApYgZl4TpkGt9CwjM/
	FPqaPtxXgKk+bhaAdbFFae24r6ieF7E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-YKlXxlMZPkW2jWRmhKvNrA-1; Thu,
 12 Jun 2025 11:36:23 -0400
X-MC-Unique: YKlXxlMZPkW2jWRmhKvNrA-1
X-Mimecast-MFC-AGG-ID: YKlXxlMZPkW2jWRmhKvNrA_1749742581
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1DFD18011CD;
	Thu, 12 Jun 2025 15:36:20 +0000 (UTC)
Received: from localhost (unknown [10.45.224.54])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D06E230044CC;
	Thu, 12 Jun 2025 15:36:18 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v7 08/14] arm/cpu: Store id_isar0-7 into the idregs array
In-Reply-To: <CAFEAcA-c=EaE-Y4DMVz_meVd2cbxuCyFGFOXET-COOgMWHXWWA@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250515153907.151174-1-cohuck@redhat.com>
 <20250515153907.151174-9-cohuck@redhat.com>
 <CAFEAcA-c=EaE-Y4DMVz_meVd2cbxuCyFGFOXET-COOgMWHXWWA@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 12 Jun 2025 17:36:16 +0200
Message-ID: <87a56d9dlb.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jun 12 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
>>
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
>
> This doesn't compile:
>
> ../../target/arm/tcg/cpu-v7m.c:70:5: error: incompatible pointer types
> initializing 'ARMISARe
> gisters *' (aka 'struct ARMISARegisters *') with an expression of type
> 'uint64_t *' (aka 'unsigned long *')
> [-Werror,-Wincompatible-pointer-types]
>    70 |     SET_IDREG(idregs, ID_ISAR0, 0x01141110);
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../../target/arm/cpu.h:875:26: note: expanded from macro 'SET_IDREG'
>   875 |         ARMISARegisters *i_ = (ISAR);
>          \
>       |                          ^    ~~~~~~
> ../../target/arm/tcg/cpu-v7m.c:71:5: error: incompatible pointer types
> initializing 'ARMISARegisters *' (aka 'struct ARMISARegisters *') with
> an expression of type 'uint64_t *' (aka 'unsigned long *')
> [-Werror,-Wincompatible-pointer-types]
>    71 |     SET_IDREG(idregs, ID_ISAR1, 0x02111000);
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../../target/arm/cpu.h:875:26: note: expanded from macro 'SET_IDREG'
>   875 |         ARMISARegisters *i_ = (ISAR);
>          \
>       |                          ^    ~~~~~~
>
> (and more similar errors until the compiler gives up).

What configs/compiler are you using? I obviously would have fixed that
if I had hit it...

