Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F9298CB2
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749744474; cv=none; b=IFZkIjcg5i+nKAxIpMfbv9tKsYTUp+9Reg/tnQ2XMiF8Op3NcO58YbG6uJjXDJd8QFCBKFGKI1P6xnnOWUmK3iSHsg/IsSPfVDMZ8WIzVHvPAIaVt0GljzUn872kqWnLSjhoorjPgzzJRk7Y1Il3n8G8IzofyYs7onU26sAgj6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749744474; c=relaxed/simple;
	bh=+uVuub5Ky1bzhq7P2Mnf0OieKw5ECMBGCTcKWAjvVoM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BzKijFoXta/heQjf47VYENOtjnwg2ONQN2sKwa3l2axzcXi+p9eNxIFj0y/DuFUPpOxjCaUdpGRRifVUJoOH+KJIg0LDlGVdWljDlJ3yCP6E+nIU3cLuN7Yd9gMqJi4ps600holHntH9fMySvYZb3rZuMbJBVE+UmKZQMIYCh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jxq75ve3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jxq75ve3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749744471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+uVuub5Ky1bzhq7P2Mnf0OieKw5ECMBGCTcKWAjvVoM=;
	b=Jxq75ve3uT/zw7rYPtls0LnkVB3Vlrz1uMiHpU2Mug11/N2tP4S9/KCCCxTC+UBDqX1Szg
	BesElSeY4v6Sf9q9dAFNzlCCsH2PwoKIp3Y3cge76IAcXNl5rPeGd+hdOvBsQzyFry5Izj
	tO+NOxK7SjpAjKl38SGuDgmKvs5rh7Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-Uv3enwPvPyq8CXgvFQds9w-1; Thu,
 12 Jun 2025 12:07:47 -0400
X-MC-Unique: Uv3enwPvPyq8CXgvFQds9w-1
X-Mimecast-MFC-AGG-ID: Uv3enwPvPyq8CXgvFQds9w_1749744465
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D1B818001D1;
	Thu, 12 Jun 2025 16:07:44 +0000 (UTC)
Received: from localhost (unknown [10.45.224.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED9A019560AF;
	Thu, 12 Jun 2025 16:07:42 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v7 13/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
In-Reply-To: <CAFEAcA_Ju4QBUwiOyt9thPxuAFMcm6jVTZHpE8FFJeed5cJgsg@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Avril Crosse O'Flaherty"
References: <20250515153907.151174-1-cohuck@redhat.com>
 <20250515153907.151174-14-cohuck@redhat.com>
 <CAFEAcA_Ju4QBUwiOyt9thPxuAFMcm6jVTZHpE8FFJeed5cJgsg@mail.gmail.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 12 Jun 2025 18:07:40 +0200
Message-ID: <871prp9c4z.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Jun 12 2025, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> Generated against Linux 6.14-rc1.
>>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>
> Does it make sense to include all these extra registers?
> Some of them are not simple ID registers at all,
> for example ID_CCSIDR_EL1 is an array of registers, not
> a single value (in QEMU, stored in cpu->ccsidr[]),
> and CSSELR_EL1 is not an ID register at all, it's a
> normal read/write sysreg.

Oops, I think the generator needs to check for op1=={0,1,3} instead of
including op1==2...

[Another issue that came up in recent discussions for the cpu model
series is that recent kernels have made {MIDR,REVIDR,AIDR}_EL1 writable,
but even though they are in the range the kernel reports writable
registers in, the source sysreg file does not include them. I've changed
the script to add them manually so far, but not sure if that is the
best solution here.]

