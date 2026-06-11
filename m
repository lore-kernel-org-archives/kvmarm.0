Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A965346FA0
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168985; cv=none; b=CM8jwI6W1AmjHeLsmyw0vzNr4mMGtbEng4+bSRrCVVHBzRuSz9midEMiom2CStwpeX2cglznTtUHxw3SptHcT6/NpNe6UprDvgTu2/BMAPhemPC4qSq5L5LOeLPaJ0AXkRZtIUEbI59I7K6SDckAX3vH8xIFr3p6PtGRdV0Ls3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168985; c=relaxed/simple;
	bh=Vj0xsfbJW6yds5QZbrTrwrbK465gmN8BZfUHquzUdA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nA0ESaGx/PRhdGGByDW7VYqnSM0u3Ml2jCAUtsfqAWeICNmjc418KY/mD2LE59+5HtrXUJmfAcTHTz5ToACwxt4/cDo4iSxVhcK4k7SCjXY65LkEeTiS10HtKmk6Y7Uuy/g5ExhW5MgfjmCKdn5avUBv0UBc437PBttV2RPREkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L5EfzUdQ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5EfzUdQ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf20f6be6bso61086425ad.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 02:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781168982; x=1781773782; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qWY0cY4kiEcnvfhTyEpxJWJH0RbYeJVpOwBgIukp5FI=;
        b=L5EfzUdQuMdrU5OSeYDDQ7u4n9TyW38lifhQJ6xa+FTqcmCBo2qXKbNQ8AgaAEGnXa
         9RvLdmblDvWH0sYp8h5FNfsjIwCJYfQO2aiw/922ermOEftFmiG73y5fSzheA1W4gZuf
         A+TLqPda6LQmOXhboWG48TXDNzktCUJvNsDCARXs27ssU5/TcraZWpzr6GD3QIQSlBZR
         tYCeCt+TCVrTE6YjDROkyeS9+R6kwUe30pTcRQRC66MjeAml/UZ25KRoQeCWMfRJMcRd
         lcDmbrJ6dOQZmmLdPqrmxfeRhnhpprmIQjU8SKSRipYS9LNdgTRW7UZ4HZfV7+HjLkSU
         StjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781168982; x=1781773782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWY0cY4kiEcnvfhTyEpxJWJH0RbYeJVpOwBgIukp5FI=;
        b=XcY7ZUUxbSxh4mv7I1b4Pwa4LjYQLz/aImgHQ/vw0JBCDJznm4vGajnaK1yVhF7F6J
         UuzsuJHLH8vIfLzMBUJD4530CHZFTmCdzOoTJUHJVzTULg5j0d8xlDoX6Aj+FBRULA1b
         qMN112JWRKpAjemJVSAa62dDUN/Iss44M+TyS3qF+g59sP9hEn0wWKP2ZjsUmeAuN1S0
         4bPLdTSvLu+684Qk9A0QT2xppvWdJ+lIPhkNKnA2lbuow+XCIzRMsSP37DDPvNuW4Z7R
         Fb7YTEISxkKS/mUzKWsl1a/8WKTcHkHHCBMpvvyyCkmkN6xTUz2kQn648+oJnn15262W
         b0Yg==
X-Forwarded-Encrypted: i=1; AFNElJ+iYOGEJCGF7a9xZMrxaJ7+qvJoITymY/bAygc8qXG0sYvV9DRqGEC8qT0R0pwISCS1r2fJlhk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9TVV3tYEv04XTJ+FHhVfTZCsZ2MERC8UWsVKp35gZdXL4aUAL
	WFgwe+IP+KYvBpsHOagLw190F9ljgwVLAv44WATuKvirvJjvBvTERzCUcxVzgAI6vwo=
X-Gm-Gg: Acq92OHwpj1IxSoF1bFBLXSsrTrqosSN7aaOEOWPO0y6eTR/XbSO2Vdw4ApiRP8ZquB
	dDvC0oJzWWxysVnrkTJ+g2H/E9VoBhbyhZS+XmLnfvd7b8A1r6u+r+E4lUbDHslRUpBhPDZRfEY
	iDRgXqJL1BEVDaaV8bVR5j6usl1bExjT3QPV1p1flU6GT9a4veDVyFenrv6xABJtUbphW+zXDeL
	+daBxu3O9fAef+utzPOF0V4nAMQ6e4kC7zwzC3xV8IVz2uGFf4TyrK4acjwEdR6c3HYxWjHUe1i
	CM9mLEyvAVEbVmTAPOJYDKJetuEJ+2JbpXzSfm9ttHI5n50RDodbftGRu+7u3xoQDeQRNtvLuXX
	+stSGRQsQtJ7cKqURQrU1LuMnvsp8naCbOUtPDmWWpZByGfpJzMtIuqjQ7cxjIRw/x89SIENjBa
	sOgHVMbebf8kCoKJ8Ns0ZRAIrmsFbgvED3t4oNrxla7qqdy55FbfOhVjBB23oRHLn+6Q==
X-Received: by 2002:a17:902:e5c1:b0:2bf:2369:a131 with SMTP id d9443c01a7336-2c2f37306bfmr22737375ad.34.1781168981750;
        Thu, 11 Jun 2026 02:09:41 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:4a46:1ea3:200a:5fb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f8792bsm279519355ad.23.2026.06.11.02.09.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 02:09:41 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>
Subject: [PATCH 0/2] KVM: arm64: Fix MPIDR lookup for unreset vCPUs
Date: Thu, 11 Jun 2026 17:09:32 +0800
Message-ID: <20260611090934.84469-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: wangfuqiang49 <wangfuqiang49@jd.com>

Hi,

This series fixes an MPIDR lookup issue when a VM is created with CPU
hotplug support.

kvm_init_mpidr_data() builds a compressed MPIDR-to-vCPU lookup table by
walking all possible vCPUs. However, vCPUs that have not been reset yet
still have a zero MPIDR_EL1 state, which aliases vCPU0. This can cause
cmpidr_to_idx[0] to be overwritten with the index of an unreset vCPU.

As a result, MPIDR 0 lookups can return the wrong vCPU, preventing
interrupts targeting vCPU0 from being delivered correctly and making
guest boot extremely slow in configurations using CPU hotplug.

Patch 1 adds named definitions for the MIDR_EL1 RES1 bit used to detect
whether a vCPU's MPIDR_EL1 state has been reset.
Patch 2 skips unreset vCPUs when populating the compressed MPIDR lookup
table.

Thanks,
Fuqiang

fuqiang wang (2):
  arm64: Add MIDR_EL1 RES1 definitions
  KVM: arm64: Skip unreset vCPUs in MPIDR lookup table

 arch/arm64/include/asm/cputype.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h |  9 +++++++++
 arch/arm64/kvm/arm.c                 | 10 ++++++++++
 3 files changed, 21 insertions(+)

-- 
2.47.0

