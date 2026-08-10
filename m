Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4D5399CED
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 06:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786344747; cv=none; b=ACTxDcBOuBZd4BJ3jTRFuWePmaUCL4Ix6nqxUT2DIG8ay1CZzSRrIdrD2ZJxj/mRftZtRMbQKLIzeUCx/AIlR1+NgDSg1mYUXySsIUnc9quxFeDoYd35OF+runcIQKAfvdOcJQIwJ6Ns5qXgwf/wIpvNc6G1ksZ5n7nLpn0qlbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786344747; c=relaxed/simple;
	bh=sNuukcM3D83y3AGrAcmDVUJWOr4AK1wbJYGoX6MXcZE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IOJr0pQz+soQ/foAFo/AxCCNRKP+shJm2GGV50hHzqPIgSEFZQPwN9d4O1OXpKII9J70/1N44UbZV9Ry+wJViTmgNNgj5dpcJZWmw0hvVZflBDDPUrr4RVrZkyl1wb8OHlmAU+5Y9FBc6zX//fLYYbk3Y+tJZxjcemAtVALC29c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HT5+OZ9E; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HT5+OZ9E"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954aff6088so13428825e9.3
        for <kvmarm@lists.linux.dev>; Sun, 09 Aug 2026 23:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786344744; x=1786949544; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8eGCU7QsDbQICJdJbOzdpd9Veffbk4TEd4ih/oR0Bp4=;
        b=HT5+OZ9EoXkOIYtUspN8gIJGc6snkcBCL6gv+GXlIBttkqcC8EG4edE0c7mUqVA0Dg
         LNWWW2Wkm6etr//Sxgfl597B1kkzH+sMmesyFy4PLF4vy9HbeHQHfj7EHVIQwIQjKGcD
         M+eIY18GxgQeIC7DKlZ4A5BMyCDjkFebxlxrXa9smyjJO36WIISO/Yr+avOSpxw0rhlu
         tdks8HmSCWChnw4uGFj3r4gvflJJPVm0tCl/pPEf0gpEgnoiW8sKmEYVNsaVgYi6jAWB
         fTLfvkHx14c4rqYS9DiX0zl3bjBwbkXJxigso1wrNrC3e9jTW6VBa/gRc+MGNyPSK0LG
         iHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786344744; x=1786949544;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8eGCU7QsDbQICJdJbOzdpd9Veffbk4TEd4ih/oR0Bp4=;
        b=HSlnoJJR7YNpvHtJJaw61cA7sHDSa76HNURPptIzkRwzwdk/EHaajzjP8kdY3aRLqZ
         z2rHnt/BudK40XFFeo4ldp//Fj3tTaenuIqJmVdiTVksXn8QbVMHDmjBlZmQmQOKsT+X
         MKvkDiAEw+oyOAYP8soVUw/urtP1OJcfb0E3CybZitjBeKkxgpfsNLtfLawqLLU+5wRA
         tOLBl1ReJghQZoFZBGvIN7LjXkAAyIYpsfsE7TPmerLtelSrpR8mCrDpeDEACAFn6SXJ
         dp1N+SbsJTgdUzuCzc5P9w4TP5p9IkA5J3t0H6X3FNa+1zHumxovMg1ZtKFaQhZ2U8U3
         ruwQ==
X-Forwarded-Encrypted: i=1; AHgh+RowH2fjuJfVhGtF45jYA2zw4vwKFZx4Yk6DdsxJ5v6WfZFg5IOCVZqi50Qehtwcj+hwxuL9KF4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNQfKMfemeqsqmxMu/3/99w2O08uoe8KWCoo2N0Tji+ysoZApt
	6J7ugQvCmCTWx53jZNISbepqzU5tNNWcTnTYcmJEYL8DCXrvigQsvbiw
X-Gm-Gg: AR+sD13bfOyPVKjXuLSdVJwb+dDbpHUvrrR9i65dmrKYDHwjh+rx5W6g3NlBOsAizQV
	0CwFQX01jJd6R6rt5wcwq336KHoHoO2l8ZGx/9YNz5XPXLMxqcSNRx/8i3QU2HnabT5EOuyREI0
	0g4Zp+tbrCakVDenETSCLw404itMHGbkxjF2XQYvSvLQ70dIRHsEWUT8T+GcCDt1keW7RGUjT3m
	iJ31UalC0llsSyQxACZwigoCDWpP4te7NXqzZbZa3ebHFn0eIK/1Z/gtuQTo8NYFilNXm4VW2Px
	xo5nRE17T3b3r9Ue57WtDoFwO4Ti21n+aLOSDgx60n0Z1j5Rh3i7LmZl321ejH4nFah18lipt4/
	M1Cz4liC+6CZI/ylwdxyPjOVZ+hlPyr3lRg29YhVmfTh06g74DqIoopygVwlkfsI3QL2sBqqWx8
	pcSHcWnLIMx0QprSFtbsDfs9ZGEpf4EaLYy8NjO+yJbainig5Sw0X5J3x3RSM4hEK9x5xBLF+SW
	Tg8i0xkUUIKgPIsbwpbpoIf5wM+jpYxMA2p5OI/T+BYEYzwXt2hUWjsc7q1U8W87nDRAELpo0oa
	GwEn4a7b3AfGzg0II8q+CzJvjH4u9pdywZFejnu+M1PLcL3xBpMv+CQ4HQz8IekS1tzE8a4lFan
	dKQ==
X-Received: by 2002:a05:600c:4595:b0:498:952:e276 with SMTP id 5b1f17b1804b1-4994e79e377mr389497355e9.8.1786344743398;
        Sun, 09 Aug 2026 23:52:23 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-a1e8-7401-78b1-a175-5d13-e92e.310.pool.telefonica.de. [2a02:3100:a1e8:7401:78b1:a175:5d13:e92e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995420c68fsm358800705e9.1.2026.08.09.23.52.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 09 Aug 2026 23:52:22 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 0/2] KVM: arm64: fix VGICv3 redistributor rollback
Date: Mon, 10 Aug 2026 08:52:15 +0200
Message-Id: <cover.1786344511.git.kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failed REDIST_REGION update can unregister redistributor iodevs
belonging to earlier regions without clearing their cached base
addresses. A corrected retry then succeeds without restoring the missing
iodevs.

Limit rollback to vCPUs assigned to the newly added region. Extend
vgic_init to access an earlier redistributor after a failed update and
retry.

Commits 8542a8f95a67, 59112e9c390b, and 0d92e4a7ffd5 progressively fixed
cleanup after a failed region update. Preserving earlier regions follows
that model.

Built with GCC 15.2.0 and tested under QEMU 10.2.1 TCG with
-machine virt,virtualization=on,gic-version=3 and -cpu max. Both runs
reached the VGICv3 tests. The patched kernel passed; the same selftest
against the unpatched base failed with:

  Unexpected MMIO exit at 0x8050008

Karl Mehltretter (2):
  KVM: arm64: vgic-v3: Roll back failed redistributor region setup
  KVM: arm64: selftests: Test VGICv3 redistributor region retry

 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  42 ++++---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 115 +++++++++++++-----
 2 files changed, 112 insertions(+), 45 deletions(-)


base-commit: b9b3e33b70b71e516930117e21de3ad2a7723747
-- 
2.53.0
