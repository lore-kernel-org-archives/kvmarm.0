Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0823507F
	for <kvmarm@lists.linux.dev>; Thu,  7 Aug 2025 12:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754568099; cv=none; b=c/A/yZTruUKiPiIiOB6f6NVnYMiH5/8zYJQLGxjvXwm2tiTuTigGOPkDe6hmjoUpjC7bDSBUctcrQmZunahpS3ObgtYRuxZi0AG508LZ99J0PD5PK1e2YZIg1k5wal9J1Y5bu4QTMI2JhHh6QKQOfj5QbYb6UKPpPEmhSICX+g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754568099; c=relaxed/simple;
	bh=G7i6KCTQBxmT8/epoPM7BKLqjb/sdX9EkaS80XrWDb8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kyPt4/38qpS8fynxAoOsrYGVNs2EDqmESeOIK4CBq3OMcKQtV9/LMrfqC7hpts2JY0TVUX2ZqrtnII5LV/gTvSbJDEwhGk2+gqEGxbPQPDUFBiIlE9aZw9JbeQ4+BFllFyPb4LXdrdh5dh/en511ZS54q5huyfxjQ4kiYYbRMIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ngl5UXlE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ngl5UXlE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-459d3abb2b5so3391515e9.3
        for <kvmarm@lists.linux.dev>; Thu, 07 Aug 2025 05:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754568094; x=1755172894; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NJvDev6JiarMJWMxcbrKmT0EeRzHRecrSUf9b1TXS7Y=;
        b=Ngl5UXlE3bbnvCWelJsIXnbqarZIgnyU7fjN66lfKDk0pPWfMqEgNQdCLkR5bRmFDL
         Nz/ZP61451J6ZZugZQiw691eZbvOhd5H00yNcWclphf8H4wNvWbMiUDwgVNfelU8ODM3
         +9UxqhOTmX4p59cAZggpQ9TlHC0tQjKZWw+wrn/R0s2J/a0dFSdzaICVSeWhSTmuyl+V
         omIkoFs86YRIbnrQ4jnk6mjGVrrpx9eOXUH+vVB/+LrN3Uo7g9lFnYjM+BTAskyz70nh
         I6YFYLmWqZYfVbZYeIWHMR5yfwPyulF1uMg20+I3Ic+JpySa+EC9WY+5qpFAvc5XtELu
         J0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754568094; x=1755172894;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJvDev6JiarMJWMxcbrKmT0EeRzHRecrSUf9b1TXS7Y=;
        b=rhg1/u0VACBTaMcOVIcdkvi7iDlmsQMclIvSh3LpeFLYRdJmp0loi0GFlOl+F99Fic
         /6WZ0LMYhooknWCYTykv3A2tt6pioyN8s41VsMJ+TSK1PJ6loWya4rf3s3whb2/Ro6ug
         NqRnsrK3Xtc+2wwwLC8TrN4wcXCJp/apx1Kfk4ofHGCoG+h4ImrUa+JA+FiC/VcbSf3h
         ip3neXUn9qiwHrGZNv0Of9MBwCo6wAzMxx7bUsoWSdus2+ZlRS5GIF6I9X2NV1/lE8ZR
         mtdyfumX2usJfzhohbnaI7CZsfBdAqFfrQMXu/dZrEfesASa9BYjwB0JQUS0D30ND4sw
         YREw==
X-Gm-Message-State: AOJu0Yy53U4j3PwRzsPe3jDzQZnrimW/UEpIDyZG1QDXeDw0m7rhdIW8
	wK/WfwfCjuA14YQIZOHod/IDysTd5CRZTopNYSlGH0nH1z4u6Zy58CXanHEEkHLXSL5cMoUpIrM
	DWHddd7Q4zt2Ckei8uzfHCKjn28RDB7L2lPLcaIb8izWnYZNLicYkwUGX5OTFR1PGe/E8avQFBx
	6aD5PUnF53d43j20Ob1k5iFiNTlfTQr6M=
X-Google-Smtp-Source: AGHT+IF1zofXBCVZFK4r7lqTfARStajWiSiUpki2EYDcpjB2YB3WeHi7UsQXh6wQgWjdJzGmiZaDkDz8vw==
X-Received: from wmbdr26.prod.google.com ([2002:a05:600c:609a:b0:459:df20:248e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c0c3:20b0:456:2698:d4d9
 with SMTP id 5b1f17b1804b1-459e73a9797mr46541875e9.3.1754568094066; Thu, 07
 Aug 2025 05:01:34 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:01:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250807120133.871892-1-tabba@google.com>
Subject: [PATCH v2 0/3] KVM: arm64: Fixes to handling of restricted registers
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This patch series mainly fixes issues we've encountered in pKVM (in
downstream Android code), related to the handling of protected VM access
to restricted registers and injecting undefined exceptions into a
protected guest.

The last patch in this series isn't pKVM specific, but a fix to the
vgic-v2 code encountered while fixing the issues in this series. The
issue it fixes was indirectly introduced into the code with hVHE.

Changes from v1 [1]:
- Dropped the refactoring patch.
- Added Reported-by tags.

Based on Linux 6.16.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250805135617.831971-1-tabba@google.com/

Fuad Tabba (3):
  KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for protected VMs
  KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef
    exception
  arm64: vgic-v2: Fix guest endianness check in hVHE mode

 arch/arm64/kvm/hyp/nvhe/sys_regs.c       | 5 +++++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)


base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.50.1.565.gc32cd1483b-goog

