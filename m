Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB912144B7
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 09:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745919085; cv=none; b=JE/w1948qtKpIMszOeHPQ7FqwSBiVwCJ9RF7kTbXHOI28YYmZYZpfVphJrUmz/2s3hdLwRyfjm5hFI4edmktYRGEODA5gB/ee7cZhloR5uG2cnjJ1HSCocLP+mkf1y/TySMrWeJYk0fcfL7LJBPkE1+9OVnTj1p0BFK9e1l+Ey0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745919085; c=relaxed/simple;
	bh=FI5TFIGCoRolwCHLb2a3LJh3wJQgsYxJjWbaLgQ4OPg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bF7woNNXEuS+EgTkrKEfr1OySZBgCbYlkar+RtIAjnnuvOyx2erXm/jWDEQDGQI5kUzA9nhPnjrOMsPITlFr1us7ICilEf1NRHWDOvdLe8XDatFquVqWZu05aySPEKmFAJBJpPz9hkfuOhzd4+vEllaFOSz0L1L12FWpuUWctas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PvXyFyhk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvXyFyhk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745919083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Awc9uIR+YA34p1U+v9K0ZISzl9LL1kxrbkjQifYsg8Q=;
	b=PvXyFyhkUbW5fnfCx4U2DZnuVwG7UeFMwh4NKlx8LmWBPLsEz/g35vn47OJjfPrBFm9YTf
	0PPkwgawN4RXf9abNItWJMpCtokkHGrzyL6BKNyLihblsAPgZfXLllK9Ik2i/V955a5sap
	70MNd4JccbmsqbNOfHLnWpIi2nc6pKM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-cepCTW6KMW22o_qpF_ecqA-1; Tue,
 29 Apr 2025 05:31:17 -0400
X-MC-Unique: cepCTW6KMW22o_qpF_ecqA-1
X-Mimecast-MFC-AGG-ID: cepCTW6KMW22o_qpF_ecqA_1745919076
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B0FF1955DCF;
	Tue, 29 Apr 2025 09:31:15 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 128BB30002C3;
	Tue, 29 Apr 2025 09:31:12 +0000 (UTC)
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
Subject: Re: [PATCH for-10.1 v5 02/13] arm/cpu: Store aa64isar0/aa64zfr0
 into the idregs arrays
In-Reply-To: <470349f3-2539-4099-8958-980480459345@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250409144304.912325-1-cohuck@redhat.com>
 <20250409144304.912325-3-cohuck@redhat.com>
 <470349f3-2539-4099-8958-980480459345@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 29 Apr 2025 11:31:09 +0200
Message-ID: <87o6wfqppe.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Apr 28 2025, Eric Auger <eric.auger@redhat.com> wrote:

> Hi Connie,
>
> On 4/9/25 4:42 PM, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Also add kvm add accessors for storing host features into idregs.
> nit: add kvm add?

Too much adding, will substract one add :)

>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-features.h | 57 ++++++++++++++++++++-------------------
>>  target/arm/cpu-sysregs.h  |  4 +++
>>  target/arm/cpu.c          | 10 +++----
>>  target/arm/cpu.h          |  2 --
>>  target/arm/cpu64.c        |  8 +++---
>>  target/arm/helper.c       |  6 +++--
>>  target/arm/hvf/hvf.c      |  3 ++-
>>  target/arm/kvm.c          | 30 ++++++++++++++++++---
>>  target/arm/tcg/cpu64.c    | 44 ++++++++++++++++++------------
>>  9 files changed, 101 insertions(+), 63 deletions(-)

>> @@ -337,8 +361,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>                                ARM64_SYS_REG(3, 0, 0, 5, 0));
>>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr1,
>>                                ARM64_SYS_REG(3, 0, 0, 5, 1));
>> -        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar0,
> while at it you could add use fd in this other calls instead of
> fdarray[2]. But this can be done later.

Given that this series needs a respin anyway, might as well do that.

>> -                              ARM64_SYS_REG(3, 0, 0, 6, 0));
>> +        err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR0_EL1_IDX);
>>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar1,
>>                                ARM64_SYS_REG(3, 0, 0, 6, 1));
>>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar2,

