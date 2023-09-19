Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFB828E24
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 17:50:24 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-690bb524a97so1512113b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 10:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145823; x=1695750623; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kWnTlx7Gdnm5Vz0/SIGYkkfnd0U6Pz1ne+euXaONdhM=;
        b=q0ggXUvTsBxVDfzeuy85smPh1e+Z9OxSRezICVENlNfeoHlnrGyim9ZFGnZYYXcpML
         Yf+1JrkwRZ44n9XAqtzjI68m9xvXYZBAQ8OdGYGXzNWi2ZxP2sTT3aRfeVQGV3ecUS2A
         OdxYdEgCGQ0pgGPbRFxqIqIUy/9wkhf2CrAlGaKf9S/7g7iO55/PKv7ewimDKCRZNLNV
         45zW+GWSfkq43kXR0VDWkKpfZKJb2PFJUxk0BjbKYeh1c71eC0Gt01mq4NgbimzdG7KQ
         W8208313COB62qtGW5Jq3IrTTCoq4SKxKrWYyzhPqspE7Uj0B6W+pyREDngZa8+max4p
         XczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145823; x=1695750623;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kWnTlx7Gdnm5Vz0/SIGYkkfnd0U6Pz1ne+euXaONdhM=;
        b=qP+hdzAE33ShT5X1g+5hjMeJUjkiQiwaXxnEcorYF45A+iXR7DSz9dZawh8Ir1rSxT
         F/XOfC6asc2ihwCZyfQc0xlGRkiNhkhoOGPvLXoqjrQp//kF4hbWZG2cHGiZ4VZg5zYI
         Idxp3h3C/CniDKTMIrnjsvKoM5C5oIi0myYjLGJbJ+DTtj5WHJQm3ybNl24XuANjxHYP
         t8AH+iCUXEyn+3qn9exR1eRoy4nY5RKRUcCokCR/79l/QVF29DFO1XgZQXqODE/hbGHE
         cvaRmRanFwVlD5/NSSMyHWvDHvpmT+f6bby08mGUISNztNth0RJb3jZ0rAc7B3mkPKbo
         aGAg==
X-Gm-Message-State: AOJu0Yx3XWBPz4RwTNlRtZ/SsPUigQ9PWXw8t+UkibiphejCToGXjst+
	zZklE02VyZzf6tWyAlGA+GDZ/tV6YWV+KfmPhQ==
X-Google-Smtp-Source: AGHT+IEeHiio7e1vKdIgqVCmVLTA7YryY2gvJQIIbbaxBDphMBRHHqcu+bML2gSb43lnX/ewy3LJgGjLyxr0jFKanA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2d84:b0:68f:f868:a4fe with
 SMTP id fb4-20020a056a002d8400b0068ff868a4femr10033pfb.2.1695145823586; Tue,
 19 Sep 2023 10:50:23 -0700 (PDT)
Date: Tue, 19 Sep 2023 10:50:12 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-1-jingzhangos@google.com>
Subject: [PATCH v1 0/4] Get writable masks for feature ID from userspace
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series were part of [1], but actually are independent from that.
In this patch series, a VM ioctl is added to allow userspace to get writable
masks for feature ID registers.
Another two fixes for ID registers are also included in this series.
This is based on v6.6-rc2.

[1] https://lore.kernel.org/all/20230821212243.491660-1-jingzhangos@google.com

---

Jing Zhang (3):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 Documentation/virt/kvm/api.rst    |  42 ++++++++++++
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/uapi/asm/kvm.h |  32 +++++++++
 arch/arm64/kvm/arm.c              |  10 +++
 arch/arm64/kvm/sys_regs.c         | 104 ++++++++++++++++++++++++++++--
 include/uapi/linux/kvm.h          |   2 +
 6 files changed, 186 insertions(+), 6 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.459.ge4e396fd5e-goog

