Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A08D15957E
	for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 11:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720782226; cv=none; b=NSyzD6mEUjQsxmTQWsTWCKa+1pv17+g3AUEdcKEuDt1Ojr9wK+xBsYKdaZnhGSVnWVEoSXT6Xh+jej69Hbk5GUGCzAFTYdp7FP28s0CJi9TknM/iaEPeDHjGLqAK/CW2TlzDFzcDeOBIcvixvj3RlObVnyWDsCqYUYmdjHI7aaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720782226; c=relaxed/simple;
	bh=jUFzN99UWeSNj/5MosN+5qznAKMKEz//NePA30M+fHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rgw7grKtGz9IXVBYlLkAlNZ5KhSviut689yQKER3rKrncua4NxoCJS1PY7JjogFmmktvFyjVF6i+J070+4IWWj0HE71FyGgS8kFix3zr8rfr31YGMz1gvS4lsEt3JSHh2m0ianfgsSy7BJV45fW19B7NdWN5Lt0Ic+Ox8Hfcs5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JKP1bLRO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JKP1bLRO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720782223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1qQ7l0GWU5+sbaI9jPARmVRN2+U8L5NQD4xZcBL2aSc=;
	b=JKP1bLROggB8JwHWiHsavpL6ux41El+5y0yBHPlLPSnyHPwWHyRJPOA+w4ZzQCgLt+5ugU
	IqeHo/qEouvu8+w4Ba+MKGcYliWaimrCqhHexU0Jppvn3mrQcyN5pmTa2Xt16N6QbnJeD2
	XmfnxuNN/ldtvWXzlr3RN3cMu+n5EB8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-Y2AZhNwkNaKOsCzSvJSl_A-1; Fri, 12 Jul 2024 07:03:40 -0400
X-MC-Unique: Y2AZhNwkNaKOsCzSvJSl_A-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-79ef9c44d85so251154485a.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 04:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720782219; x=1721387019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1qQ7l0GWU5+sbaI9jPARmVRN2+U8L5NQD4xZcBL2aSc=;
        b=EHGlO05Ii3+PVchU0jA8zKCw1o5x6MHziwBSJopwVSJhlGQBaBiOvehLB2Iu1gNLBi
         oX8MfkAyzoplK2Uo50KpncXlolJUjkiPli8fNHfra2V63XrhGGMwp1t5ngXHPujnVIhS
         EntCKnrzybIutyKoteWHYVg9Tmf3PV6d92g1WMmzytvRztFgmIQ6xSS5o9NPQfqh7P+a
         xymxbKg+bZjUIyqQDE8TPd4mmDjpPJV0leDF0NFoSAqKiPMk8sjtr0r0lzELdN2lPTmc
         f7H9TY7Ckt+rKBW4NOf23JIcsy8MeB5IiBe6rMvvjDYa0GgVvP0IJN+LTZxQCtrNCvnK
         9lSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgYnsCrKDa2CjOu1VDVznzOcKWXaeEKOfgI+jjgquJLRym0TrUIqNyXVmUQFWyoyqf/JUqGalo+bMOky2ospe9cCkWKiRL
X-Gm-Message-State: AOJu0YytnoZlqLVqQ6mvKG8sycWHfBbtanc2wakwYhBg+CF/7D+DX8qb
	yM21ca/HA1BIQmxdVSWFhKhIo2kVg+aigke3Fnbm2ijwiODzDVEi4a9J3Brv9l6HQA8W2Pgj7HI
	CPukJbU3nr09FqRHKr2Dc4jwBa1PFpPoS3vPz4qa7La+HO/mF4tmDYQ==
X-Received: by 2002:ae9:e702:0:b0:79d:5a5a:61f0 with SMTP id af79cd13be357-79f19a7fba1mr1120360485a.34.1720782219452;
        Fri, 12 Jul 2024 04:03:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF49CeTtgwI6pw84NFDsgZPcLaXJC9eRYBAhVwf5iFp0zhdiGyDc2Go8V8cwq39LwXuNxN/xw==
X-Received: by 2002:ae9:e702:0:b0:79d:5a5a:61f0 with SMTP id af79cd13be357-79f19a7fba1mr1120357785a.34.1720782219139;
        Fri, 12 Jul 2024 04:03:39 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f18ff834csm390498685a.5.2024.07.12.04.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 04:03:38 -0700 (PDT)
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
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: fix warnings in W=1 build
Date: Fri, 12 Jul 2024 13:03:29 +0200
Message-ID: <20240712110332.10970-1-sebott@redhat.com>
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
warnings for me (fedora userspace, kvm-arm/next). Patch 3 gets rid
of sparse lock warnings in arch/arm64/kvm/vgic/.

Sebastian Ott (3):
  KVM: arm64: fix override-init warnings in W=1 builds
  KVM: arm64: fix kdoc warnings in W=1 builds
  KVM: arm64: vgic: fix unexpected unlock sparse warnings

 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/handle_exit.c     |  5 +++++
 arch/arm64/kvm/hyp/nvhe/switch.c |  6 ++----
 arch/arm64/kvm/hyp/vhe/switch.c  |  3 +--
 arch/arm64/kvm/sys_regs.c        |  5 +++++
 arch/arm64/kvm/vgic/vgic-irqfd.c |  7 ++++---
 arch/arm64/kvm/vgic/vgic-its.c   | 18 +++++++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.c       |  2 +-
 arch/arm64/kvm/vgic/vgic.h       |  2 +-
 10 files changed, 32 insertions(+), 19 deletions(-)

-- 
2.42.0

