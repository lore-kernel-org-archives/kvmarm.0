Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB561C6897
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 13:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764116; cv=none; b=QmSAtFIuXD6h6OChJWDV4CSUMvqTpkBb4XgwAopd8j9s5S05+thcqklOmNcUBKN6ijBPlYJ0HNIr40w1G0D7fR7gxQpFDX1NvUrZnGBMfSKMv3SMqPUpksSj2aZZsn+lFhrc0qObR01+kPAAbUozigs9MkM3gLLN+9ZQWQ7n4mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764116; c=relaxed/simple;
	bh=aXlqjOf+2RvyqEdGkHnp+gbVK7RCcBbO0Rx1Vr5MLN8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=osEmgCJnD7JNqfrfgOGCMNhwPN5bCHszarATMvETx2PJI6BwHN2brc2TrUz3muboMCMZ8g0rfkbP50pztSk+4tR5fI4AuHe+e6uajy4IXW6he8wMZEjpDbr42pAVfeihDzJvhTbFGlm/javSW0xakg+YWuPP70V9dghi2pnDwhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lHm83nBx; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lHm83nBx"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-371aa511609so2756381f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724764112; x=1725368912; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vmhgoThXpsRE2ZPXF8R0CGdwPpFNc8Epv22ahkVAR6E=;
        b=lHm83nBxie85/S3pjRsOgv266KD7c0dyljbxaA2AxTygdNoUCgcTk25DO4xJDr2u72
         0R/kOmclV8gWRjWTyUIprelFfMtKSZiMWAflNOGqpR15F68e3pSmJT/yO84HMODh0FhF
         reQ20cqBtAI3hVeuSzc+Ti8y8NAZKWf5f/clZPYa3Kws8OuS1sPJFCnv+SI0qAvSZWN2
         1WNvxFfdH4OCRiPPZV1ZHq7p7wfoOrpXcYDmvrSftUrkjCUwQmbv+/bFo18857k722j2
         FTs7yHTTxBMhTYIPpJJy4TxmMtC7lAktVUqAlYih7e1Il/Cy7WAeC7LZOP9Sb3Mg0jAE
         8tMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724764112; x=1725368912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmhgoThXpsRE2ZPXF8R0CGdwPpFNc8Epv22ahkVAR6E=;
        b=HGc9VvrW/ums3DEyGDbCbHLJrG3fuWPpv9NY3VcjBqTr4axAcScpkz1zVkYl8HA4wv
         kppvWNzuzQ43VXQP+anPTek0AD8mUZ+sNDAW31v+Uu+Vhr80Uy7JiS7YWph1DdfJdeyQ
         aGRcpJexF9EKdKUBBZwP5YNnlFKqtarK1YS+fMlNGJ6D5tkMa/5LVL0SVV7m46tLREJU
         oGcKwKmx747yU3VlMeDGEprBL0sjdA5+HmqPnwOvlM2Msasbvzsb4N6Sti1/RI8Jk0Fz
         zEmN9mHLhCMYnM15uO/RhjVbz2VY//sJx2V8toV7Idgh1I8TLTCpGS38b6xQkG655mqb
         rAUw==
X-Forwarded-Encrypted: i=1; AJvYcCWB3f/YAqKSLyx8nZI96I6MmRvHkvz0B0X34IN+QmXTb4M/UVOJsAnzD74kPyzeiAVVXnIo8N8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLLSt2jNgAuzFVG+js0ANv6fKow9EcRGFvPhKcOJ1P2Aidrtt8
	D91Gi39SHNABnakjD63JxCpeLwCSbmCY5ZcsDU9UhKAWocwNDAjxHbppiVc8MWo1cIkN4MHLivw
	c
X-Google-Smtp-Source: AGHT+IGHn0fUmNiXD2kqIU9eVqVFjdu3ykcNSCWApUcSFi9kVI2cR/nL4JnTMb6vecuV/AX0n7YrfQ==
X-Received: by 2002:a5d:570b:0:b0:365:980c:d281 with SMTP id ffacd0b85a97d-3748c81a115mr1892925f8f.45.1724764111532;
        Tue, 27 Aug 2024 06:08:31 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ac516252asm184573695e9.26.2024.08.27.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 06:08:30 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0DA6E5F9E6;
	Tue, 27 Aug 2024 14:08:30 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	arnd@linaro.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 0/3] altra workarounds for PCIE_64 with instrumentation
Date: Tue, 27 Aug 2024 14:08:26 +0100
Message-Id: <20240827130829.43632-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

While testing virtio-vulkan on the AVA platform we needed to include
some fixups for its PCI handling. As far as I know these have only
been included in various downstream kernel repos:

  https://community.amperecomputing.com/t/gpu-support-for-ampere-altra/274

The initial two patches are as we found them save for a fix to
align_ldst_regoff_simdfp in the alignment handler. The third and new
patch is trace point instrumentation so we could see how often the
workaround is being invoked.

Combined with Sean's PFN patches:

  https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com/

And the Vulkan/Venus support for QEMU:

  https://patchew.org/QEMU/20240822185110.1757429-1-dmitry.osipenko@collabora.com/

I was able to test virtio-vulkan running in a Aarch64 KVM guest hosted
on my AVA platform with an AMD Radeon graphics card plugged into the
PCI bus.

I don't know if there is any interest in getting these upstream but I
figured it was worth posting to the lists for wider visibility and
discussion. For now I'll just carry these patches locally on my AVA
until I get a better system for PCI GPU experiments.

Thanks,

Alex.

Alex Bennée (1):
  ampere/arm64: instrument the altra workarounds

D Scott Phillips (2):
  ampere/arm64: Add a fixup handler for alignment faults in aarch64 code
  ampere/arm64: Work around Ampere Altra erratum #82288 PCIE_65

 arch/arm64/Kconfig                 |  22 +-
 arch/arm64/include/asm/insn.h      |   1 +
 arch/arm64/include/asm/io.h        |   3 +
 arch/arm64/include/asm/pgtable.h   |  29 +-
 arch/arm64/mm/Makefile             |   3 +-
 arch/arm64/mm/fault.c              | 726 +++++++++++++++++++++++++++++
 arch/arm64/mm/fault_neon.c         |  59 +++
 arch/arm64/mm/ioremap.c            |  38 ++
 drivers/pci/quirks.c               |   9 +
 include/asm-generic/io.h           |   4 +
 include/trace/events/altra_fixup.h |  57 +++
 mm/ioremap.c                       |   2 +-
 12 files changed, 945 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/mm/fault_neon.c
 create mode 100644 include/trace/events/altra_fixup.h

-- 
2.39.2

