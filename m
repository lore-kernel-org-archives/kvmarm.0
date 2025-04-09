Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A58C0E
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 10:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744193663; cv=none; b=AC6+X+XfqIHQ2MsPg9cUbUUddYvOcyb3W+vI6p31npdslacbIw4q7J6Xm3yPWfThR1PYLYvhqggm/hrNc8gg0S2RGvoT8axH5h2+nigfYknr8TnjDFmPmcqxDrwAxTSMtYE3XCIXoC4FdKpEBbXtHPBsCG6sBAPD/kYvMzE7zXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744193663; c=relaxed/simple;
	bh=8b+D5b8jySbK0G+S0uwSSxKFT82ctgNLICAgJyYk3oc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cBMe+y6OUphbV+nZiAzu8oZsPxVJCTFgxjRaJUg+cVnZ+EVmv4jeWZfYXh4DvO5oiWrQo7g1toe9JZcMkdHzag5CJIHllozmHzZe1WJYbCP1MnCciPGGuY9OWoolqvjhq/qY+at8SWwcOXETpbMwt2XWxPj/l70r3Z2G/wKcZy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bFJgoeUe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bFJgoeUe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744193661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+/lkyCl8vM9EFCkDS8zkM7kt4Y5/de55KVxrVIc8hfM=;
	b=bFJgoeUeN/WeZ+9eiIWpWXFZgwACHw+KybKF19M22XO94RKYjvqIgd1KylYr8Qi9v4GltO
	T4D6WvOax/S07O7/EsU0L0PViHHGbm8VDuWhII41fSN1V2gRzlb1IHWVTCiqqx3HQOHbHO
	ahyW2r+cPMHXocRFdxO3/bGk4zQOKf0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-bKlSA2fpNqG4c5vRinQghQ-1; Wed,
 09 Apr 2025 06:14:16 -0400
X-MC-Unique: bKlSA2fpNqG4c5vRinQghQ-1
X-Mimecast-MFC-AGG-ID: bKlSA2fpNqG4c5vRinQghQ_1744193654
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 486FC1954B39;
	Wed,  9 Apr 2025 10:14:12 +0000 (UTC)
Received: from localhost (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EA1A19560AD;
	Wed,  9 Apr 2025 10:14:09 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
Subject: Re: [PATCH for-10.1 v4 04/13] arm/cpu: Store aa64pfr0/1 into the
 idregs array
In-Reply-To: <20250326173723.389988-5-cohuck@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250326173723.389988-1-cohuck@redhat.com>
 <20250326173723.389988-5-cohuck@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 09 Apr 2025 12:14:07 +0200
Message-ID: <87bjt5abgw.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Mar 26 2025, Cornelia Huck <cohuck@redhat.com> wrote:

> From: Eric Auger <eric.auger@redhat.com>
>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-features.h | 40 ++++++++++++++++-----------------
>  target/arm/cpu.c          | 29 ++++++++----------------
>  target/arm/cpu.h          |  2 --
>  target/arm/cpu64.c        | 14 ++++--------
>  target/arm/helper.c       |  6 ++---
>  target/arm/hvf/hvf.c      |  6 ++---

I just noticed that there's a new line in hvf.c that needs to be
adapted, I'll respin :/

>  target/arm/kvm.c          | 24 +++++++++-----------
>  target/arm/tcg/cpu64.c    | 47 ++++++++++++++++++---------------------
>  8 files changed, 71 insertions(+), 97 deletions(-)

