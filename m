Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0B1C04
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 10:43:20 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f41d087b3bso18882335e9.0
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 03:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684406598; x=1686998598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a1A5zp19nox+z20d77L7kQ6GgRjn3J68bOPJdNDopDU=;
        b=C4Z+2kW0NH3TFvYfMcDnh0ui4OpD+d+98cpobngsB7pxYPY0QgTK2LZhRDtkuJnFls
         4muu/nbMWJLapcXfEegbMiBju0WqH5acOUbtjU7i6oy0PpbyOSjbydqPuFRweCg+iwGO
         v/3VrffkBI6d3M78kYdP6auO9rcF65UK5c7c3ew+Oi6tjGvhTDBfP7gTf5ml2zvyT2v9
         iEjFfyVD4GogSHZQLAxcEY9psllzznjsLKvjPCkq+f5nusLBTqTKVp/iLLvk3EUOA24k
         uDAHbiJWiHtG1YSffr0vNSc0bBHMVnkbnHtv8qznd0x1zbmMtQWvWHmT5aFo+uf59OVx
         0plA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684406598; x=1686998598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1A5zp19nox+z20d77L7kQ6GgRjn3J68bOPJdNDopDU=;
        b=CRJP+ykc2RRIPQHL+LQRmc/2j8/HJJeZ8/pImoUzB9PvS8pYr2e2TEwdYy0tZ11cLz
         tmJeGedhZpfqycAL7EZsYiEWfNfsfPRHT53Xwlibh1Hba8Cb97h1uHqzXDodle7tpiHE
         e6L8ZcYTDplqLXaIJFNg5vMblax7cwBQ58+ttM6hVyl+ARRX1dihwBTmMCVr9IRtsrb4
         DS1oSSBigMiQrA2PRrjR4MgTrHg3HInBGu9kMULVfr8oTanIrmZR2nw6yeEeI7xJqXJC
         P1AJQQsRqhEn97qG6T7zCXNjno66Grid48nDi1+Ld2lD8valpS2iK59dURG4XBrneYh0
         zN+w==
X-Gm-Message-State: AC+VfDzhdQymSV+MFHKAUUhANlNlZYy+rt+Ft/Xdoj2YXXR/MIh6g5t7
	mb+EroMq4VFR/RgjRqlRp1uAIg==
X-Google-Smtp-Source: ACHHUZ6pgQfC0TLqqQ1Hb+nrANs/LlC0ALkrv2lfrEpi5S7694C2yfzPXC5EkWVcGaYZoTsqRjoM2Q==
X-Received: by 2002:a05:600c:249:b0:3f5:f83:4d84 with SMTP id 9-20020a05600c024900b003f50f834d84mr1128550wmj.31.1684406598315;
        Thu, 18 May 2023 03:43:18 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id f6-20020a1c6a06000000b003f427cba193sm4880523wmc.41.2023.05.18.03.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 03:43:17 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: oliver.upton@linux.dev,
	maz@kernel.org
Cc: james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 0/4] KVM: arm64: vgic: Locking fixes
Date: Thu, 18 May 2023 11:09:14 +0100
Message-Id: <20230518100914.2837292-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another fun locking puzzle, between the new config_lock and srcu.
Patch 1 attempts to fix it, and the other patches fix simpler issues.

I got these lockdep reports while running KVM QEMU on a TCG QEMU, but it
can also be triggered by running the vgic_irq kselftest on TCG QEMU.
Now, with the fix and lockdep enabled, vgic_irq hangs but I believe it's
an unrelated weirdness: if I introduce a separate lockdep warning for
some made up locks, then the test passes again. So I'm sending this out
now for discussion, and will investigate that one later.

I run the host with:

qemu-system-aarch64 -M virt,virtualization=true,gic-version=3 -m 2G -smp 8 -cpu max -append 'console=hvc0 root=/dev/vda rw' -kernel Image -nodefaults -chardev stdio,mux=on,id=virtiocon0,signal=off -device virtio-serial-device -device virtconsole,chardev=virtiocon0 -mon chardev=virtiocon0,mode=readline -device virtio-blk-device,drive=hd0 -drive format=raw,if=none,file=virt_root.bin,id=hd0 -nographic

Jean-Philippe Brucker (4):
  KVM: arm64: vgic: Fix a circular locking issue
  KVM: arm64: vgic: Wrap vgic_its_create() with config_lock
  KVM: arm64: vgic: Fix locking comment
  KVM: arm64: vgic: Fix a comment

 arch/arm64/kvm/vgic/vgic-init.c       | 27 +++++++++++++++++------
 arch/arm64/kvm/vgic/vgic-its.c        | 14 ++++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 10 +++++++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 31 ++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic-mmio.c       |  8 ++-----
 arch/arm64/kvm/vgic/vgic-v2.c         |  6 ------
 arch/arm64/kvm/vgic/vgic-v3.c         |  7 ------
 arch/arm64/kvm/vgic/vgic-v4.c         |  3 ++-
 8 files changed, 64 insertions(+), 42 deletions(-)

-- 
2.40.0

