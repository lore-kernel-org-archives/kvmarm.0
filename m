Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EED24503E
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749921; cv=none; b=l1NF37tw/14KYYNMG+jZp9JBPxpYXHAMW3nMVLvgcXcu2PtdjGcqfMZLj0rfH2FvcpgRlS59oBkz9QI4FxwVVmc+VrpRv6vf5G/Qb+Pdp7gejcuIVrubnfCMcIh6wU5VoOPonAuKlaOq8gShPeNE5qufdak/Ib+8axDxjObTlxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749921; c=relaxed/simple;
	bh=W0wvuAqJtwjPNZsphRu58z/MF8fEw377JO902o5elYY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aW/YAzIqyVV/8fsRd1mtTJ5/4H7N6PGnLzB8s7U9G+K9jUksw6N9q95pu5ENxY9qIuywOp3VvcCjKBe5aO7PCckSV3wHHGzybMy04uiFDUoOaaMdQ9qgBWU4VUS3j8uzXAbdCG0TpTtcDuHIfP634p82CgcmoG9vPiMGZqXX0FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/2QTa2z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/2QTa2z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747749918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dqea7MZDYhyQlC4xKO8LGx5epUTJ/uHF9sDafau5YHY=;
	b=M/2QTa2zZfg1Tbg+EnGbUm/Xm7F1z/WrXq1y1MRAPEcTBd84lBe/vTzcIJVtmRkfaz/Jl2
	H7X7pxsS2YqZ4Q29hd3WI9dq528dMVUDLQ6roP/8/ZC86g9JHZc45BIUlBlTqOyY+sjIo4
	Jt58qpcNO+4pzOCMLXlcrEda79l32iw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-bVnTc1EAMAylZKevhQ0_1Q-1; Tue,
 20 May 2025 10:05:14 -0400
X-MC-Unique: bVnTc1EAMAylZKevhQ0_1Q-1
X-Mimecast-MFC-AGG-ID: bVnTc1EAMAylZKevhQ0_1Q_1747749911
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C7151800874;
	Tue, 20 May 2025 14:05:10 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 693CB1956095;
	Tue, 20 May 2025 14:05:07 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
 registers
In-Reply-To: <a706e9a2-0a49-4296-ba0a-8001f433b8b8@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-7-cohuck@redhat.com>
 <a706e9a2-0a49-4296-ba0a-8001f433b8b8@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 20 May 2025 16:05:05 +0200
Message-ID: <87jz6bbcoe.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:

> On 4/14/25 6:38 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> At the moment kvm_arm_get_host_cpu_features() reads a subset of the
>> ID regs. As we want to introduce properties for all writable ID reg
>> fields, we want more genericity and read more default host register
>> values.
>>
>> Introduce a new get_host_cpu_idregs() helper and add a new exhaustive
>> boolean parameter to kvm_arm_get_host_cpu_features() and
>> kvm_arm_set_cpu_features_from_host() to select the right behavior.
>> The host cpu model will keep the legacy behavior unless the writable
>> id register interface is available.
>>
>> A writable_map IdRegMap is introduced in the CPU object. A subsequent
>> patch will populate it.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-sysregs.h |  2 ++
>>  target/arm/cpu.h         |  3 ++
>>  target/arm/cpu64.c       |  2 +-
>>  target/arm/kvm.c         | 78 ++++++++++++++++++++++++++++++++++++++--
>>  target/arm/kvm_arm.h     |  9 +++--
>>  target/arm/trace-events  |  1 +
>>  6 files changed, 89 insertions(+), 6 deletions(-)
>>

(...)

>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index 775a8aebc5d3..8717c5e7695b 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -1088,6 +1088,9 @@ struct ArchCPU {
>>       */
>>      ARMIdRegsState writable_id_regs;
>>  
>> +    /* ID reg writable bitmask (KVM only) */
>> +    IdRegMap *writable_map;
> as it is KVM only we may put it in ifdef CONFIG_KVM block above

Forgot to reply here; the CONFIG_KVM block is gone with a725f3710231
("target/arm/cpu: always define kvm related registers")

