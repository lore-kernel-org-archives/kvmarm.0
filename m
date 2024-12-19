Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED61F543B
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 07:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734591924; cv=none; b=sAzsOf3VS0fL1y4mYWo3+tZjKiQC+fQss3w1/cF4cnCY9kEIduorgS+dRVEG6zyKpAW1EKyQUivRbAyVbP50+VUirzw4QH0R0CfIb5qVqCqCxwqIOikFZMQ5tTI3jmTtjQEQ8u3yLFd5AKQ9h9JpFWnZMMq/DsRYYHtpIBePfHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734591924; c=relaxed/simple;
	bh=p28staRr1WCG1YrwT1+5ZvmAKkAQ4du59eG8a5dobJY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kRQUm7ko7Dabo7qgwqLPlhAsXYsYb61mHokb7w1ffpZM8oW49WL3zx681XMg4/HMk1TKWvKk2lhGuT8sY0Ry6GsWSQ7J+mtRTRNZFS3SuZ9GkgX6dH9fYppV+DOF5a2dfuo4oUs9E98EqHSTmrHqbQh0msifi2B/F6kTdG0f/pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qw8p9rX4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qw8p9rX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734591921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L8Wz87MF6s9ghUZeLLIp8a7pQi7LC/a2SSjxFUlu/Hw=;
	b=Qw8p9rX4ZnZ1i1Q7OkSSyPRFUvjYOw5xrl6lijfXBRc0wS6A5KjnOtCOcjQ7esOL9EFfQT
	0TPVntL2N16vNqWDFzASFp9QN4bHZm7vjmANLeor7A2I6axPMFXGutmTglQhp1m6axciyI
	rK3Z8GFeSboMT8vt6TuniUH86KDVmoQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-nK07GLf0PwuTwdoUNWgLnw-1; Thu,
 19 Dec 2024 02:05:17 -0500
X-MC-Unique: nK07GLf0PwuTwdoUNWgLnw-1
X-Mimecast-MFC-AGG-ID: nK07GLf0PwuTwdoUNWgLnw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74929195608F;
	Thu, 19 Dec 2024 07:05:14 +0000 (UTC)
Received: from localhost (unknown [10.39.192.67])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B40F195609D;
	Thu, 19 Dec 2024 07:05:10 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v4 1/3] arm64: Modify _midr_range() functions to read
 MIDR/REVIDR internally
In-Reply-To: <20241218105345.73472-2-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
 <20241218105345.73472-2-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Thu, 19 Dec 2024 08:05:06 +0100
Message-ID: <87r064b1b1.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fU9rxbyeMmwUgFk2s-2qJEFT9t9dBJjC_z9cemznlFc_1734591915
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Wed, Dec 18 2024, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> These changes lay the groundwork for adding support for guest kernels,
> allowing them to leverage target CPU implementations provided by the
> VMM.
>
> No functional changes intended.
>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/cputype.h     | 28 ++++++++++++++--------------
>  arch/arm64/include/asm/mmu.h         |  3 +--
>  arch/arm64/kernel/cpu_errata.c       | 23 +++++++++++++----------
>  arch/arm64/kernel/cpufeature.c       |  6 +++---
>  arch/arm64/kernel/proton-pack.c      | 17 ++++++++---------
>  arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
>  drivers/clocksource/arm_arch_timer.c |  2 +-
>  7 files changed, 41 insertions(+), 40 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

