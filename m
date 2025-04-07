Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C73422B59F
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744027232; cv=none; b=HTeztYYfG+DHp0NPgi+F9ANiTXbotIlT6vIVUk6kjltJCnBSqZJAe5w4fcdMtQzI3Adb65opCb//mEfAlNsg/afGlO1K7WUiOiuiN28FVyf9G8B5V3uDp7r5zM/AMl4a0VKWwvKNqJgdY9K1VpXByw0l124brNrZuYSYnuJRNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744027232; c=relaxed/simple;
	bh=jHPr39jqrhoVhnOo0EmPhmXFmUay0W5NRjEYnqU2nNc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iBpgIUmwJ8HsDI5tFkK72r9umkH0OwLfNtRKlw3wWWYC2jwljNVeco5jPM3aUQ3TiBiiDW6UgQfsj78aNLDIPkaHRwOLcMNjsW0dv+XY1lzopd63UUD0korFT4RmTnfd90LvWh3BiD5d744nvivbwS+5eI9fzUW8mNpfAiD3adA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFKzrNbQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFKzrNbQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744027229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrLOjVCqCMsLo6/22WxxuDKmqoQV5liMyxCxtsLfqB0=;
	b=KFKzrNbQZ/hC7oB1DQsHeo3C0YGHpFi7IXjsxyHzkNTpcaUTJZZT/Kw4rC3XTz3MwQrZrv
	xplW8tgZ8lQqMjwXsNSoFXNcyy//FzHGBNoT8V7J8VneOKbP9lh1os/K4Hc7dTbZSpbI32
	zn3qKJy+jw1Bk47Fm1cHOsJOjT/99Dk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-C8XnyaP1Nj2sTs5S9CcQvg-1; Mon,
 07 Apr 2025 08:00:26 -0400
X-MC-Unique: C8XnyaP1Nj2sTs5S9CcQvg-1
X-Mimecast-MFC-AGG-ID: C8XnyaP1Nj2sTs5S9CcQvg_1744027224
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 261901828AB6;
	Mon,  7 Apr 2025 12:00:21 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF0F619541A6;
	Mon,  7 Apr 2025 12:00:19 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>
Subject: Re: [PATCH] arm64: Expose AIDR_EL1 via sysfs
In-Reply-To: <20250403231626.3181116-1-oliver.upton@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250403231626.3181116-1-oliver.upton@linux.dev>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 07 Apr 2025 14:00:17 +0200
Message-ID: <87jz7w9o6m.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VvNzIxbGWjyz_MNgOh2OD0zfvb4V2RR63_X-cOD65FE_1744027224
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Thu, Apr 03 2025, Oliver Upton <oliver.upton@linux.dev> wrote:

> The KVM PV ABI recently added a feature that allows the VM to discover
> the set of physical CPU implementations, identified by a tuple of
> {MIDR_EL1, REVIDR_EL1, AIDR_EL1}. Unlike other KVM PV features, the
> expectation is that the VMM implements the hypercall instead of KVM as
> it has the authoritative view of where the VM gets scheduled.
>
> To do this the VMM needs to know the values of these registers on any
> CPU in the system. While MIDR_EL1 and REVIDR_EL1 are already exposed,
> AIDR_EL1 is not. Provide it in sysfs along with the other identification
> registers.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |  1 +
>  Documentation/arch/arm64/cpu-feature-registers.rst | 13 +++++++------
>  arch/arm64/include/asm/cpu.h                       |  1 +
>  arch/arm64/kernel/cpuinfo.c                        |  3 +++
>  4 files changed, 12 insertions(+), 6 deletions(-)

Indeed, AIDR_EL1 should be available alongside the others.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

