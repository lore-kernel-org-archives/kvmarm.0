Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EC914E2F4
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 10:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721729535; cv=none; b=pMzGLVCngxu3kbu8SY+n9qpS/rp1xMosDgniJGI9SFL1x1TYnBKwpmoV0pWFW8jZMOxmaYQqJbUG+ZMubfNej0xAtGcjzerGOEtopIcz40hGCSUQs7mcWf6GTgftG8/i1T4w0ttDWHn+itgTjUCzva36e1Y5BcGcjQXOx+M1ZKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721729535; c=relaxed/simple;
	bh=tIH8+pIIMMdAuQFVddSnwAJv1MQB2deGmxLg6GqUWmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KR3oxwB9gMXw8SlmexESPH6ZUNNWD0+741FuZIWKEMKIaWhAG9fvQu8uJpzPp4o+PDy03hnoay5MNLWN0Z7y9Kj6lxypYum3vMAp+yCHgMB/AtkgqMamaUgSr3Din6wL68gEh35bzdOIE6Z1ncmEE/6RzK8b0T5HrAa25CxJYzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pd94vRuv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pd94vRuv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721729532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8cUp6hq8Rf9yICEw+ij+wA/0ySScqHZkH2/Mn4b/iJI=;
	b=Pd94vRuvNvPkmMzGgB08j+Ns1jh6yEQzHZ9FtPqhNXl1N3l3tRh0rp3mhIphVoMF0Zu9Bb
	jlcn/GXqngZ4FJTOBSbHanL66pIgAL6icD0Yxi3/Ss/H0tOdgZcKtj+cO/0lbheG3mAN5C
	do7znY493edCNlAVP6tCmLYK9CiSr3Q=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-lsgEKo1VO16Jnm-UA6jlDg-1; Tue, 23 Jul 2024 06:12:10 -0400
X-MC-Unique: lsgEKo1VO16Jnm-UA6jlDg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-79f0a17bb2aso705635585a.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 03:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721729530; x=1722334330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8cUp6hq8Rf9yICEw+ij+wA/0ySScqHZkH2/Mn4b/iJI=;
        b=HvzRiuo0048szKi84Tf6Lq9lwvFWDMF8zYEs8aI+GD6/hAQLMv5QenuqS2aE+kJzJL
         FHjlNh2BncN+hMIVIkATqDzSfhpwdqfdC+/As0+kKXJe4aC1+XJpnJsJ1380yVG9zWyH
         wkXyuyZWbNv+R+GHd4LiJAdm9YBaHy/Dxq0yxS9QIkXOI1/2Ap05HZSjle4auHsLwdap
         zCPA87CjqeehID1OOy/JuZcaHzvA7m6+BSob+7Z7qGxW7sQaycUgWUtRccGrUZ3uDuil
         OLxpf+mRj8G1XFLjC13PRLpBXaVdp7BmglD7LecqaQ6jra8FKdUu5l2Zto5vFhSFcgPW
         nMsg==
X-Forwarded-Encrypted: i=1; AJvYcCX/95AZ9jrVy/j/en597vNiIzT4F//zjUHvXfieQ/5jELbk5zDd5rdc6wemB1dDcSgQSGtNdEsJbPdQstLOaJ2LJK+nYzyD
X-Gm-Message-State: AOJu0YyM0TW+rQqF6RYOUX87CZ/gpNBpNu1fl17cPrMqno65kJrS7Tuk
	EoZCobSYu/ydweii86MoqP/KhW8EZk1p32JltTVEGKE6sBlqRxk/eoiFBYmw9q32HB9ZrA36qhS
	DRQPo1Oq38uJM9mNtn+uqK2rm9gncecJa0oLNzrnHr6rk8siIhjPLhT1dor+rqw==
X-Received: by 2002:a05:620a:29d5:b0:79e:ff47:3307 with SMTP id af79cd13be357-7a1a130a702mr1465270685a.8.1721729530135;
        Tue, 23 Jul 2024 03:12:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyt0QS1IKTLLjiIiYvN5IywSbQLXxQfkNLU8SejKutptyLr0Xnp/x8tl4jKx3X5B48LdDkqQ==
X-Received: by 2002:a05:620a:29d5:b0:79e:ff47:3307 with SMTP id af79cd13be357-7a1a130a702mr1465268685a.8.1721729529791;
        Tue, 23 Jul 2024 03:12:09 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1990063f2sm463780085a.64.2024.07.23.03.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 03:12:09 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 0/3] KVM: arm64: fix warnings in W=1 build
Date: Tue, 23 Jul 2024 12:12:01 +0200
Message-ID: <20240723101204.7356-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Building arch/arm64/kvm/ with W=1 spills out a lot of warnings. When
changing stuff I try to use as much tooling as possible to make sure
that I don't screw up - having a clean baseline imho helps with that.

With the first 2 patches applied make W=1 arch/arm64/kvm/ runs without
warnings for me (fedora userspace, upstream linux after kvm merge).
Patch 3 gets rid of sparse lock warnings in arch/arm64/kvm/vgic/.

Patch 1 now just adds -Wno-override-init to the cflags of the affected
files. Alternatives would be to add this to the whole subdir or
reintroduce the flag for higher warn levels..

Sebastian Ott (3):
  KVM: arm64: fix override-init warnings in W=1 builds
  KVM: arm64: fix kdoc warnings in W=1 builds
  KVM: arm64: vgic: fix unexpected unlock sparse warnings

 arch/arm64/kvm/Makefile          |  3 +++
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/hyp/nvhe/Makefile |  2 ++
 arch/arm64/kvm/hyp/vhe/Makefile  |  2 ++
 arch/arm64/kvm/vgic/vgic-irqfd.c |  7 ++++---
 arch/arm64/kvm/vgic/vgic-its.c   | 18 +++++++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.c       |  2 +-
 arch/arm64/kvm/vgic/vgic.h       |  2 +-
 9 files changed, 26 insertions(+), 13 deletions(-)

-- 
2.42.0

