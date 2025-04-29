Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E0129615B
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745920104; cv=none; b=MM4RBzTlOtdcjJeZ+LDEyINLodFndDJnDXn/P4pcsI1xBCBTRpna984nigw9xDZFR3YP3hUva6pYa4yRCeOiU8aFlxJ+Z9zSWqRd3VzkUEUDUqYiA8LtF7pBVqylZOleSAMlEhuG2TJhiVI2sACqxKgUSLI2Oe4M9ZRQ3Qfey5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745920104; c=relaxed/simple;
	bh=LsIP0aomKUsfdPYdyb2wG6yRs4Gt7P3vkdbQ93RpaOQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OyG6UhDs6gAQcf8x2uUst+PcXEmoSFj4wzFBCZFqE4ncP9cFJcCRDhyZwzZ8EDT7bH0EDrjxNE3slyZc/dg2aNMMBzY3mpLtRwGaKZTXD9gF4yhVXgPE1G86wyx1SSH32H3j9rA71GNKmKKxkb3wp4cUUz19Ntr8HhbeAxyzxOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RzuiGH5N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzuiGH5N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745920100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uAzYfmEA4ZlzMGzQV5ZXsXVfrmBmz8sqT7sNKurT35g=;
	b=RzuiGH5N2prbOZoGsmepT410WCoZpmn1O3SzReZpc5qUsqgPs13kbZFKesiHdIgCJoJIdo
	BGEz8Hq/gC7tGeclYrE7AfQ9QrhcIoeVOdA/kLg4Aq4LV93F6lsvpxe9tV3oFRnzW1INrw
	IaQmdIbrMaK0wIK5+O0Za74FK8ZZVTM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-3twGYU2DOAuXCRt-6zbOow-1; Tue,
 29 Apr 2025 05:48:16 -0400
X-MC-Unique: 3twGYU2DOAuXCRt-6zbOow-1
X-Mimecast-MFC-AGG-ID: 3twGYU2DOAuXCRt-6zbOow_1745920094
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D4581800876;
	Tue, 29 Apr 2025 09:48:13 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 606EF1956094;
	Tue, 29 Apr 2025 09:48:10 +0000 (UTC)
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
Subject: Re: [PATCH for-10.1 v5 06/13] arm/cpu: Store aa64dfr0/1 into the
 idregs array
In-Reply-To: <c150cb74-d11a-4090-90fa-0405a488c471@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250409144304.912325-1-cohuck@redhat.com>
 <20250409144304.912325-7-cohuck@redhat.com>
 <c150cb74-d11a-4090-90fa-0405a488c471@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 29 Apr 2025 11:48:08 +0200
Message-ID: <87ikmnqox3.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Apr 28 2025, Eric Auger <eric.auger@redhat.com> wrote:

> On 4/9/25 4:42 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-features.h | 16 ++++++++--------
>>  target/arm/cpu.c          | 15 +++++----------
>>  target/arm/cpu.h          |  2 --
>>  target/arm/cpu64.c        |  4 ++--
>>  target/arm/helper.c       |  4 ++--
>>  target/arm/hvf/hvf.c      |  4 ++--
>>  target/arm/internals.h    |  6 +++---
>>  target/arm/kvm.c          | 12 +++++-------
>>  target/arm/tcg/cpu64.c    | 33 +++++++++++++++++----------------
>>  9 files changed, 44 insertions(+), 52 deletions(-)

>> @@ -925,8 +925,9 @@ static void aarch64_a710_initfn(Object *obj)
>>      SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
>>      SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
>>      SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
>> -    cpu->isar.id_aa64dfr0  = 0x000011f010305619ull;
>> -    cpu->isar.id_aa64dfr1  = 0;
>> +    SET_IDREG(isar, ID_AA64DFR0, 0x000011f010305619ull);
>> +    SET_IDREG(isar, ID_AA64DFR0, 0x000011f010305619ull);
> this line is doubled.

Indeed, fixing.

