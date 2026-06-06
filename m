Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB9427AC4C
	for <kvmarm@lists.linux.dev>; Sat,  6 Jun 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780768635; cv=none; b=d+psEhsc9zXOuxhKJYmXVabCz6kHQhZ2gTz5HcXG0L6p7aQWhbRSIWRRDjtcJXMw407IOappmsYY38RM97Y2slNoZLfn9y0wBdqS/xVTDqwlRBNBUnO5ESgUTf8Xs3znEFj4gQ7gHgIxoZLLHQ6Jh5lEzYKVBokNBmt+KZ2/FmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780768635; c=relaxed/simple;
	bh=KSZGHumIxF19ChxQvl5ED5jRjJ8wnG3VPODwq1yEaVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hwYsWFWVZh+ZeT0CHZdo6Z/jKhXs8lbwdjFKStM9aDJnIWFsq0fa8QJSpixPNKVhhJalC6A34jEEx0KK7i5/7CVV9mXcJLPf3ewEdnYEpfXz5ZjZEiNMPSJEH9K3jDH3T7uoUmZvPx8xdYATg9EBgVdat0pjXv45aYlCOg0UT6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XaKJsSr8; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaKJsSr8"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36da151a152so2162583a91.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Jun 2026 10:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780768634; x=1781373434; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ME+xNkoeE4ctIAxfAzYaPkyPD55bBWMm21iy3jKU/r4=;
        b=XaKJsSr80VnLPaKTvIwpZKiLWgM5n5GdmKBXLM/wZakHdhvhnrm9wOpgOyHJmR2GiK
         Eu7EuKfVgGq2Gp7NS2x+ruhr06DLJVjkYcIvUiAZMc/nVDZKpC0Iks9aU8h7lBoJ7w1j
         zRXXLCfgbZNXh5zy6lJKpP7xxuo18VBICghHeMxLqDqjqwQlasaSUiYvawwS+Xfb/hbG
         TfkxcaKxH8mWW2B1Z01GU9MmynGFXHwSywoCh8r7F0+RMiakcwYkHZtDi1hjZa1hKag1
         bOuiNE3No0I3pQ+6vTQag/ChH477Ct2W4OmeY8PIlK5xkOvQ5cBczWcid1/hQY7xjyms
         FXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780768634; x=1781373434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ME+xNkoeE4ctIAxfAzYaPkyPD55bBWMm21iy3jKU/r4=;
        b=cKeczO2IvutOaHxI+TNNCeMUBGVLy4sHaBzZoMkoKVw5t1LepQB+x9Vh3I65esG5lo
         PrFKvHSz/dmou5dyiWaEazxLhWRT/s0K2x2kYEmf9CCxZ8f/JvSnSxmpGCw9TAPOIAyX
         ga0uhutGAeWYC7ieoglu6rOtUTjW6x1zF5+MOOfroVTaZhNPx7iBiv20PKLawx/SnU3b
         kft9o9MkKHWb9cAUaYPW4SRVv1QSecFw8e7I/BjDM47u2tWgCKdTKxpcDCotvl6njrV4
         dfd7412MUMV9wR4d0vpWJKETdhKgGPs3Kh5Amaa9SjMIHHX1tqTsM/TCep+NbNQfkz92
         6Zyg==
X-Forwarded-Encrypted: i=1; AFNElJ8PNyvQ+Sf9YzKfawulm40r4/F6uyXuOQHlMINxC/4CcQgmgd/1MyqP/A2fFiRSosVYrtdIQak=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNiAjCPgfFtLZfU9kkY2GJcjvoUqdC2fKZgmGnWHlQX8/qKedq
	SxP4cyj0naqgg9e1Rr0CuG18xTD9mE5diwSchsF1BgVJeixltwK8Hi8J
X-Gm-Gg: Acq92OGQIThcDU6+wK14dW2l/pMdFFCQEc7Dohw8DBxXvZt4urc7JEtfNv98JPHUs4G
	NqtRMod9rWn4gLwD0uRueiRCS+PbhVINN0ytUjGdFtMwXUtD3JExZSqXqUC7GOI3gOEpPgVSAEm
	Cjz6XDljMsWs/LWq+1Fz1PU3qWhO3niuvHz2EYXsvLOnmjqmurt2JKHlAM5Dlwlx07pe/jeCXXm
	6L8udNMK1SrUKJDKx2FT1cEfa+fx4FrTyU0QEAaY0mQJ5fF1THkgRb7tkahYM4C0CI80G8wdB68
	ypJyZqbyTNLST5tvTGbCYTXJbHJ1ziqYrcXsQ8SNhcwHlgY7ct6Xp6KZCcsM1PepT1AaTW2TgZ6
	1FwE8CmTSUSa7IPpLy/RtUuRICkxz2nlzSd/4FI1XSFyBEUrhGe7lOrKD7r9B25U6A9SI+drnRo
	03/nTDaQ/Cfp38WoatHTr0GfS++JVZ9haW74Eyvk0jWxtLmQRaTABio+Q9m0Xewkms45Y=
X-Received: by 2002:a17:902:e545:b0:2bf:1486:e6bc with SMTP id d9443c01a7336-2c1e80ee016mr102752615ad.29.1780768633594;
        Sat, 06 Jun 2026 10:57:13 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d69csm129196425ad.2.2026.06.06.10.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 10:57:13 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: tabba@google.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	stable@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH v3 0/2] KVM: arm64: Sanitise host vCPU fields copied in flush_hyp_vcpu()
Date: Sun,  7 Jun 2026 02:56:09 +0900
Message-ID: <20260606175614.83273-1-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
hyp's private vCPU on every run. This series sanitises two fields that
it currently copies verbatim (host -> EL2): __hyp_running_vcpu is
cleared in the guest context, and used_lrs is bounded by the number of
implemented list registers.

Changes in v3:
- 2/2: replicate kvm_vgic_global_state.nr_lr into hyp_gicv3_nr_lr
  once at init (guarded by gicv3_cpuif), instead of reading
  ICH_VTR_EL2 on every entry behind a gicv3_cpuif gate. (Marc)
- v2: https://lore.kernel.org/all/20260604151210.1304051-1-imv4bel@gmail.com/

Changes in v2:
- split into two patches, one per field, per review.
- v1: https://lore.kernel.org/all/aiFe-CXo-XVTFz1g@v4bel/

Hyunwoo Kim (2):
  KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
  KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU

 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/arm.c               |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++++
 3 files changed, 15 insertions(+)

-- 
2.43.0

