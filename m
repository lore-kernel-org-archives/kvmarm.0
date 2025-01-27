Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3053BE
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 12:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737982401; cv=none; b=IIOIzrdlq1v/hjhKI4qHMbIqBhia1xmUUKYORbztCiRWRAh6uHwUvkV3EAptnCvEag+W5v2iQ/sl4VVJCRhSllgmUhxA4hmeqTFr9wUZWDIpNh+mBs1z0Kozce4Tlnc7YV2PKXcouAzIdDuULoU4t6S6GZYAnCHL2NK87cIe7Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737982401; c=relaxed/simple;
	bh=R1JgTlzfUcgA2eTnTDZY4Zta93/XBYsjOlwcdK0N8iw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DkdyqL34HknaQKIpw+sDTyxKNujbUwX0oZ6i2ToVK2FqWICCfV380Ek4pD5jCPJCl4I639L6edX+H4ZroIRn/nYwauQ5Zh6Uc9s9d32JoLZ8fDJSKadKACLPdOYbSh1ll9ZX2TQHQsBFSNb1YaiFTtJDd1FV7k2YwI1c9UPf6KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XA4+e/co; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XA4+e/co"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737982398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=40ApC6R1xp/vYItDa8VQ44GVCNZy/1Nh1lvi8wUg5RY=;
	b=XA4+e/coL2DFysk9XHLgopZNt6nuPhBstfxGLpSYLD22X6iprWQ+utge1F/SC72m4kf7QG
	QvbozVLwSe0CgzyHWGrnbB8HZnwCjMgLLPUJTaDzR9yOMGRwDVqD88JE1TAo4Sn0CGnd1A
	XIIROe5b2zNL3gRk4uhbwyl2F+beJOo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-pgoC5GM6PmuFcz-iUjWseQ-1; Mon,
 27 Jan 2025 07:53:15 -0500
X-MC-Unique: pgoC5GM6PmuFcz-iUjWseQ-1
X-Mimecast-MFC-AGG-ID: pgoC5GM6PmuFcz-iUjWseQ
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6835180036E;
	Mon, 27 Jan 2025 12:53:12 +0000 (UTC)
Received: from localhost (dhcp-192-212.str.redhat.com [10.33.192.212])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92CE01800348;
	Mon, 27 Jan 2025 12:53:10 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 4/4] arm64: paravirt: Enable errata based on
 implementation CPUs
In-Reply-To: <20250124151732.6072-5-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
 <20250124151732.6072-5-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 27 Jan 2025 13:53:08 +0100
Message-ID: <87wmeg770r.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZyvWHksZueTEPMu_1d3MLFTd6EUygoNywkML71L2jEc_1737982393
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Jan 24 2025, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Retrieve any migration target implementation CPUs using the hypercall
> and enable associated errata.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/cputype.h  | 24 +++++++++++--
>  arch/arm64/include/asm/paravirt.h |  3 ++
>  arch/arm64/kernel/cpu_errata.c    | 20 +++++++++--
>  arch/arm64/kernel/cpufeature.c    |  2 ++
>  arch/arm64/kernel/image-vars.h    |  2 ++
>  arch/arm64/kernel/paravirt.c      | 58 +++++++++++++++++++++++++++++++
>  include/linux/arm-smccc.h         |  2 ++
>  7 files changed, 106 insertions(+), 5 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

