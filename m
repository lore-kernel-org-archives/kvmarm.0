Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D9A15AD9C
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 07:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734592170; cv=none; b=bWdpdNf0qYQm8dkw/5M+VEDGIZfR0amKAPePCNBzDyCBRyP85VXJS6iXku1MiZQ5cCwVtFNW1p0ylTIbat5o0Sdrnz9MVLNJy9aO83bsgzSiJ5F1a/ifCpH9+ZvOuwPlAcxS5vW3fpzHUNmYkkygBL7OhsOGKCufohv1fQMFlXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734592170; c=relaxed/simple;
	bh=N+42bC6i5vnqIWSNr4MVFnVKzVG2odC+LwzWFirJNi8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nd1hemoHzD8xzBatnKrzuwUkzParpx/X24RzSDSQTvykhekVhOO7TFoekP2eO+hovXHRoLnZbMjWq213EVni9sdI62u2ZqiBPeSKsxqejuzLSzDX1cbCUJf1ENYMVDzNcO+DGbknjpAQeLCNY45iDT07uMsa5WSrLPFrlBeaClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WkKBUZtr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkKBUZtr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734592168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lnsGswoO8H6/g2OCH/HQ0VPb3y4llpn7a8EdIjVsTVY=;
	b=WkKBUZtrTEGbYdpb/q/UdqgXBLLYf7P2BhbbjIgud+egm/I0W/RssPoyUeVHHagZQS205w
	U6ujtv7BSUT3PNzIScr7+KwlYJmFQeVUWoX9QwZ5chX4klJql9sJ36Gu7liSGScsAKejhR
	lCKFsoLdprxZTSMfUoigH28Qw6uDWFQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-UsmY8vrhO-i6lVhXnhjvKg-1; Thu,
 19 Dec 2024 02:09:22 -0500
X-MC-Unique: UsmY8vrhO-i6lVhXnhjvKg-1
X-Mimecast-MFC-AGG-ID: UsmY8vrhO-i6lVhXnhjvKg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32CAF195609D;
	Thu, 19 Dec 2024 07:09:20 +0000 (UTC)
Received: from localhost (unknown [10.39.192.67])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 097E719560AD;
	Thu, 19 Dec 2024 07:09:16 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v4 3/3] arm64: paravirt: Enable errata based on
 implementation CPUs
In-Reply-To: <20241218105345.73472-4-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
 <20241218105345.73472-4-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 19 Dec 2024 08:09:12 +0100
Message-ID: <87ldwcb147.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2JhF7klzeZS37lfBg4AwVse6-i5A-Mb5FSh9jzBmRhQ_1734592160
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Wed, Dec 18 2024, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Retrieve any migration target implementation CPUs using the hypercall
> and enable associated errata.
>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/cputype.h  | 25 +++++++++++++++++++++++--
>  arch/arm64/include/asm/paravirt.h |  3 +++
>  arch/arm64/kernel/cpu_errata.c    | 20 +++++++++++++++++---
>  arch/arm64/kernel/cpufeature.c    |  2 ++
>  arch/arm64/kernel/image-vars.h    |  2 ++
>  arch/arm64/kernel/paravirt.c      | 31 +++++++++++++++++++++++++++++++
>  6 files changed, 78 insertions(+), 5 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

