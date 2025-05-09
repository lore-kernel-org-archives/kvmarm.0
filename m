Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55FD223DE9
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746801210; cv=none; b=fqbO7Bu7GDC5ZXh6qL8s3BFAdnzRk3jhhtcadSRVgjiPQErisCNELeJ4LYjGrgqtUryn+WEIJ9Oui4KGCpRvcpf0Uq80fo3T1KeQYcrMUoKzI84Kf+aIZqcHGutxZIlaxwBKaxhKuC/ty01X8E61TDZOW840H6C6BsLQydJ9/Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746801210; c=relaxed/simple;
	bh=FFvBCknd8IuGRR/pjTvYSyuDF4+NszF59ge0pjk8rhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=T+NbUQNlzt9yU0kyRzX7fbv2ojZMLGNFPcnHEdohyNJLrY0Shk2rud4jg3wibHEpSsZiWoPUh66poP7vjkWyBOoMgVXzvXhCpoWtyv2QYkKV1Al4Jy5o4DjSOjQm+LFjYLwt26OHs8+s7INIGf5FVwDRn2KTt7IymmM4aa4w884=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2R7FJYZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2R7FJYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746801207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VL9vZro0BdFwyk98zVNm2YYJ6CabP26FrlBnQZyFPJw=;
	b=W2R7FJYZZRsUFUT+4t/TgEzdv/VV+yEw2g9JzgjrXVFtW6ZVJ1PeJiuB8yUt04L8D9oa5D
	5iUZQTiROyTkRsWWZYfBWLfssZEwVv6+RBHeAQJtrsGiLexyiCc0asOIw5LM3Sjs5gB6u9
	jd3P068ubqtGCuRRAlX6cDxvquyqiVs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-mGTuRkwROwOtwwaGx1tH1w-1; Fri, 09 May 2025 10:33:26 -0400
X-MC-Unique: mGTuRkwROwOtwwaGx1tH1w-1
X-Mimecast-MFC-AGG-ID: mGTuRkwROwOtwwaGx1tH1w_1746801205
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cf5196c25so10754315e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 07:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746801205; x=1747406005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VL9vZro0BdFwyk98zVNm2YYJ6CabP26FrlBnQZyFPJw=;
        b=LFh2j+bVZ+rgETzZPghRuMCMvA7cGsQk13KMC2eO0GfKJaEmnKJIy9KKFlODd0WtIt
         FxyPKNcL+qrRsxly6erJ+cOvveW3rM8T30nwY+UWu6oEhy0vwn3SNcc7h0eefOFhaajs
         DbdUP+47NiQuhLZH5unWjucIOs31ATRxtcQE7H7gbx7ju4MkIIvNOHU0rdg4eqI8OcJB
         /mICtV2XhRglYMJqXd4tZE3FSPdi0/SiCUyxp3iMpOAP30EdfkjqF5OSVmg+kNWarlBH
         FokFFNvrMURbqb+zLdHg/2jMoBx6eVtRE/thcCBN+wzmJb2iDr01HDfr0+GiAgLop9yh
         cqHA==
X-Forwarded-Encrypted: i=1; AJvYcCXC/3Pmuhy0iGwp+5iOIBCw0jtQ9bvbSR5DJ3UdpzsrUQNOQLPOzEnMc/ozJXQUwQ7ln8CLjiI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcNRgxW5/TYNbYFjJG7SZkhxOF2Fl7vtyh++erzbv8HlDk/rhA
	SiS+gS9BQemN4pBF0EaGtOfsTxtMCk7ZbjVVruHlLXFoTrVGivG6FosRGuFUzujT3ajkne5J7RV
	FfL9Zvp2Xr13+D+Ng8/d7jA0l/grrj+zRI0UD8TVhK9d/uuZCtyV0iA==
X-Gm-Gg: ASbGncuEXT9CdmKTU7sL7PY+QQ0b7QByI7XN3FK7/F9ZO+HGHsXMZn+/HxWTzN/U9a9
	eUnRC8lE7nq2FP3yvPeg7aKI1ns02GHAYEu6Wn4/pZQ8W8YTSa5SeGSxp7Eu1gTvJWtEDnbUIKE
	kYlaGN92xxZSd3EuXZp/fWHyszxnQR7swD/wCU2G94fhIBZpgfNmX4pNGgKq8XkrrYYMDK+QD+Q
	MiAoYbrdNdpzGWGUTgKvIawJ2inQb5DGDG2HIV8h54LxcPeCFScao/XiEULn/tBgj5sH+kKvXVt
	EG6GsLVmUjCO5Isog64fd4Tfz1q/GhxyuBBhZrfMpsuQNXooVi2eT2aIzZIPHcV9h9VF10tztLY
	=
X-Received: by 2002:a05:600c:83ca:b0:43d:2313:7b4a with SMTP id 5b1f17b1804b1-442d6d18302mr36807215e9.3.1746801204810;
        Fri, 09 May 2025 07:33:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsWDESg6zUq+whRTNp61iivnxaZlKkiv8gH+MG5fYiPl5xSd+s4VyqNCOQwrNmOxuB7m8DQQ==
X-Received: by 2002:a05:600c:83ca:b0:43d:2313:7b4a with SMTP id 5b1f17b1804b1-442d6d18302mr36806865e9.3.1746801204462;
        Fri, 09 May 2025 07:33:24 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67d5c7bsm32150775e9.4.2025.05.09.07.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:33:24 -0700 (PDT)
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
Subject: [PATCH 0/3] KVM: arm64: selftests: arch_timer_edge_cases fixes
Date: Fri,  9 May 2025 16:33:09 +0200
Message-ID: <20250509143312.34224-1-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oUz7RlG8FapGQr018A6pmk_BK28qQFEXVu5YHnifrk4_1746801205
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Some small fixes for arch_timer_edge_cases that I stumbled upon
while debugging failures for this selftest on ampere-one.

Sebastian Ott (3):
  KVM: arm64: selftests: fix help text for arch_timer_edge_cases
  KVM: arm64: selftests: fix thread migration in arch_timer_edge_cases
  KVM: arm64: selftests: arch_timer_edge_cases - workaround for
    AC03_CPU_14

 .../selftests/kvm/arm64/arch_timer_edge_cases.c      | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


base-commit: 9c69f88849045499e8ad114e5e13dbb3c85f4443
-- 
2.49.0

