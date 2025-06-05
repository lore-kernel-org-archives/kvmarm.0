Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA5E204098
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119823; cv=none; b=h2FszZri79ticREKaJeAtRH5FdUhqOTG9lXkCnuWnU6I04Nl1DHQvgbnCqyVPz9R1Fk3Us9Qr+IzpTAD/RCHOR2yE+YmVvh4Hw3Abv8QrccQiENwZjj4Um3qq9k5sdfWWHD1Wa0BU8Ded/ql34oTDxP7wUnRm3xmIMAMy8416U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119823; c=relaxed/simple;
	bh=HvbmQ8S8Xhki+213LburIQLRhHEu40jaB3IQomFM2a4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=l04trrwG32y2Szk4H7dAB5k+EGHaWi94mZ+IluIqgZb5tj6FpxiukzVABuyX+q7XBSlF1OpLsg4x6b9NLw0F5ylNAT3E+/X3y4tdctpKYAJvqUbn41tfLFgNJI336wsqEOj6r9RNiQ/kJpYlfNRhghXOfLN52os282n+ZXdvqws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WG1bS25m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WG1bS25m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749119820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HfZ+Rq3UxyS14Y2YLAxAGNmm5WZCXoHrHzmHr+0WtKs=;
	b=WG1bS25mtp8Lx11MI0+ZhoXggOMZbnVR8eDGhPDSglXPdlanClf14ZNAx2p7jELzEFVZuU
	VClF9uz9H8ipsc3FOdYFgbazgymmgs+Zkw8XXhjRqGph+QG1i3UV8kqhhwVZBWkwOjc12S
	2qx4gzZLCNYF8OS9FHLk2VHzagNx7EQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-gcT1VL1xPQCA3tV97XH3ZQ-1; Thu, 05 Jun 2025 06:36:59 -0400
X-MC-Unique: gcT1VL1xPQCA3tV97XH3ZQ-1
X-Mimecast-MFC-AGG-ID: gcT1VL1xPQCA3tV97XH3ZQ_1749119818
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d5600a54so6125225e9.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749119818; x=1749724618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HfZ+Rq3UxyS14Y2YLAxAGNmm5WZCXoHrHzmHr+0WtKs=;
        b=bNSJMOYutgj15Mf+tW/AKRP9VsCIYcgyRwARDHzBwxg13gjluyIqI8myRIuOxzIUI4
         DYcw3U/bU0JeGz9JsuOHBa1u2QNAK2YngylzI1Tu7k6ZFEcl0QvrcX34TyYxdrzckvyp
         R48isFInWbG9CaI261MRU6NPhAYrg0YaUUlvl2idWLYfJyuw0hfZKtbEAJZDDwG3p/Qi
         i7eg8iPHHEQ1NV6ZjOKbDayMi4iE/dswhdjlKE0EIPxs/PXBXiGnpDGZqJqCireC8rdA
         zB5Kk7YJ4FTVetSURCKQCGor7/EqnO28+3SJaY9a+8oRawwQscbGyQgtoIhtjU8lI2VG
         +4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJf2+N3/1rBSWYrK7/mqPXarG6kBzgNbAkGF00SNc+2bL2mRPasXiR/V921SVcTAGWZs+PxVs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx20mxmOUrWpeVqveOzr2wUaMTIPWW/8tppXGZOiYa/SL+a4X9j
	PipufMix6gT8ivFH5MU7vXZJINlxhD7ZDjqGUaqzhtik7eJxtK7GbGXy1tfJNykUS2qmwnxKJyA
	kxQrOI9Ccd8qVa5BBddpDn+yx67TUkD+vp44M+3t5Oveln1MSuSI3OHdThg==
X-Gm-Gg: ASbGncut1efBvekaYKI6eeVE8JivYipyjLALgWxyBLYGJnxMh1pmIt6fPq9Wy3B/GsG
	NL3KQ3VzB/IZza2AO9SzbcatqgrULZcJKo2kfXVDeGkTkajn9GjBjzOyQHiMewJrhcBrtxGDV+d
	hNx3SoKeYwe2sx7K/cEIHdC7phJjjUmw/o4I8LbRtBjt0RHyRblyaVgkrl+1h3cY+d1ukKE/8cu
	ceI3NPHs2kcuGt3VLp6dGRbzgyFvW8JSuLcUg1j4emLDqummDAB9jfkU7AoPW6cfvBa8meMMU/v
	je4VT4guEw6YykeANh6eMD+yUAH48p6PqNf+Bu0oDt8YcrhmWHst87Rf4ZofikZ4hEorYolJmw=
	=
X-Received: by 2002:a05:600c:64c3:b0:451:df07:f437 with SMTP id 5b1f17b1804b1-451f0b42832mr62125195e9.30.1749119818006;
        Thu, 05 Jun 2025 03:36:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1bx8suhPbgO55wHNgDBL3CiHw3bkoX/59SOoKYKbZiUG9FMRz0rmV3itW+HwRwGTHenI8UQ==
X-Received: by 2002:a05:600c:64c3:b0:451:df07:f437 with SMTP id 5b1f17b1804b1-451f0b42832mr62125005e9.30.1749119817668;
        Thu, 05 Jun 2025 03:36:57 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f8311ae6sm14105175e9.2.2025.06.05.03.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:36:57 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 0/4] KVM: arm64: selftests: arch_timer_edge_cases fixes
Date: Thu,  5 Jun 2025 12:36:09 +0200
Message-ID: <20250605103613.14544-1-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hy5SlFXpFDpSwXF0Sb5Q7vkgmh0t4_lIcom32oixnKc_1749119818
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Some small fixes for arch_timer_edge_cases that I stumbled upon
while debugging failures for this selftest on ampere-one.

Changes since v1:
 * determine effective counter width based on suggestions from Marc
Changes since v2:
 * new patch to fix xval initialization

I've done tests with this on various machines - no issues during
several hundreds of test runs.

v1: https://lore.kernel.org/kvmarm/20250509143312.34224-1-sebott@redhat.com/
v2: https://lore.kernel.org/kvmarm/20250527142434.25209-1-sebott@redhat.com/

Sebastian Ott (4):
  KVM: arm64: selftests: fix help text for arch_timer_edge_cases
  KVM: arm64: selftests: fix thread migration in arch_timer_edge_cases
  KVM: arm64: selftests: arch_timer_edge_cases - fix xval init
  KVM: arm64: selftests: arch_timer_edge_cases - determine effective counter width

 .../kvm/arm64/arch_timer_edge_cases.c         | 39 ++++++++++++-------
 1 file changed, 25 insertions(+), 14 deletions(-)


base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
-- 
2.49.0

