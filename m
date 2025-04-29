Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDCC1E521A
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 09:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745919539; cv=none; b=TsQiAlYy+GgfvfeARFBrn9i4F97xnzOlpCXQYy5iA7qHHjPkOkInkph7liRhC+300ZkKTa0otBq1npGvDMvSAODaT6omHM9MJBGhgsDazl/XHRFT83oSKAmUy+df5YZygTlS8E/OJ2zUqgRLRNSngbs1GKcK9RtDVEwdkmki3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745919539; c=relaxed/simple;
	bh=TQ7aE9z6pwXW+HdCJwlANjHJs/ofV8qItrJ9BMqm+lM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uQynN0xBJne4Kw56f44FQnmmn7ImH3uHRxFfr479NSkqi392N48QNbEIxavJuahsd6huEwaJfPA/qhV+1XdQ7WSVBnvu3ZXfoJNwMFwIXAMbHHesYzv8X/aJyAjhar7tqNV+XVVrCqQIrbfHkSPhXI8lO0XU8zBCJLKokgSZPkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y8cCCbMS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8cCCbMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745919536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KR1LcDvsP9uT0uOKvz6dwPjLfvp1L742V1Hmhtu47no=;
	b=Y8cCCbMSKJ1v2+eqeA3X4KYT+YJM4ccIWSPiWBcAoX/Y6Pd3h+QGJ5pW2AWjNkiDz/5nxD
	M+EHeIuXMPM6LCCSYerekAKrANsSqdqiZVM60Mi25TOK8dVPLqQSkmuyLIdaFS7lIjRa2Y
	9wgP4Ny9DRl5U9h8Pdr0tt1gBbxs/2c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691--vYir4OeNMaBV74Bv58JHw-1; Tue,
 29 Apr 2025 05:38:53 -0400
X-MC-Unique: -vYir4OeNMaBV74Bv58JHw-1
X-Mimecast-MFC-AGG-ID: -vYir4OeNMaBV74Bv58JHw_1745919531
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE9D41800368;
	Tue, 29 Apr 2025 09:38:50 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B73371800D97;
	Tue, 29 Apr 2025 09:38:49 +0000 (UTC)
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
Subject: Re: [PATCH for-10.1 v5 04/13] arm/cpu: Store aa64pfr0/1 into the
 idregs array
In-Reply-To: <07b785e0-431d-40ba-ab04-56336fdac483@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250409144304.912325-1-cohuck@redhat.com>
 <20250409144304.912325-5-cohuck@redhat.com>
 <07b785e0-431d-40ba-ab04-56336fdac483@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 29 Apr 2025 11:38:47 +0200
Message-ID: <87ldrjqpco.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Apr 28 2025, Eric Auger <eric.auger@redhat.com> wrote:

> On 4/9/25 4:42 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-features.h | 40 ++++++++++++++++-----------------
>>  target/arm/cpu.c          | 29 ++++++++----------------
>>  target/arm/cpu.h          |  2 --
>>  target/arm/cpu64.c        | 14 ++++--------
>>  target/arm/helper.c       |  6 ++---
>>  target/arm/hvf/hvf.c      |  9 ++++----
>>  target/arm/kvm.c          | 24 +++++++++-----------
>>  target/arm/tcg/cpu64.c    | 47 ++++++++++++++++++---------------------
>>  8 files changed, 73 insertions(+), 98 deletions(-)

>> @@ -380,10 +378,8 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>           * than skipping the reads and leaving 0, as we must avoid
>>           * considering the values in every case.
>>           */
>> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr0,
>> -                              ARM64_SYS_REG(3, 0, 0, 1, 0));
>> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr1,
>> -                              ARM64_SYS_REG(3, 0, 0, 1, 1));
>> +        err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR0_EL1_IDX);
> Hum I think we have a conversion mistake here:
>
> +DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
> +DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)

Indeed, wrong regs. Will fix.

