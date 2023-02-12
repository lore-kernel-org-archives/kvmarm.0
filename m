Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58187E5
	for <kvmarm@lists.linux.dev>; Sun, 12 Feb 2023 21:58:46 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id u6-20020a170903124600b00188cd4769bcso6246155plh.0
        for <kvmarm@lists.linux.dev>; Sun, 12 Feb 2023 13:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YlglMKTBSy12XB1b+5wjrUnRuLDhCORhwljl/9ofDP4=;
        b=fg4iEQUEI6uRQPWJascXrHqAOjfylcnqkirBcXA4bf7F4YXaurC3gikjLEMg5yhv9W
         UngABhzKDARAknK1KFEvsbkxH2bvYuJwPPa1OjjwB1NcKNIh92feHjgZ6SK1lsbqvnTT
         EA0LBvoW0Q+nie38Ml4jed37/w6kcMm9KJlx4utIKlD01MAOWvovxETxCfNZg9Z40Swz
         +MPWohMUsNKniQ63qREqxTYjcodN0TMXgjo3jzNd3y7bQPWutOJu5ZzIn2gDlpQM/SFe
         +42RRm2WzJUXiUR380iEXkmh9cvPLzjzMVsortlMcr5dLptVzIByQ2+etEXuG5MpeZfO
         HajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YlglMKTBSy12XB1b+5wjrUnRuLDhCORhwljl/9ofDP4=;
        b=pQu7FmYXIMcwckN0cXwZBKT0ucK4i/Yw4As5RVEsua62U9N0E9+3vf6/sk1cH6VIVS
         TIt4M8aO8gnwXg7Ay4v+3ox9eAgLOwAdJwRZosNAELVi/V7cYHAZMfQI321lq4YQmX9m
         t24im/3dNRuRrmy/y373wG8TC2CprslATBfHJkJwHA0j/ePWzmTzmBFnsAmDPk5giUAO
         Vb4PBXIc1nngCeMQx3uOiNedBgpw1IreNcRxl9B0gedoU5oexAESRcQrG+e8++T8Npsr
         J/j7Y7mFVhZ1dtQcxJ3TB+zDmyoAicvkXHvqXTnb+fY+RSmlFJ6KAJPn3KK7SUc09Yju
         s/2A==
X-Gm-Message-State: AO0yUKWeo/fH1GayPtEqfqXnhRFtpRhk2MHApA6tCN6Xw4jGD1JJGzsZ
	lgPTRkWAqT8D8nyolN7c/uIyX6dw46zT1ye3fg==
X-Google-Smtp-Source: AK7set9cS1waxyICeG1y/DFOllHWcaq/wqpbaF1RIoIWYgZrGicMuxIaDDjV3RKI47OBuvh1WW2Ap8YTRYdnzP2DkQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:8ece:0:b0:5a8:5e12:a12e with SMTP
 id b14-20020aa78ece000000b005a85e12a12emr2291938pfr.11.1676239126157; Sun, 12
 Feb 2023 13:58:46 -0800 (PST)
Date: Sun, 12 Feb 2023 21:58:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230212215830.2975485-1-jingzhangos@google.com>
Subject: [PATCH v2 0/6] Support writable CPU ID registers from userspace
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patchset refactors/adds code to support writable per guest CPU ID feature
registers. Part of the code/ideas are from
https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com .
No functional change is intended in this patchset. With the new CPU ID feature
registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does before.

Writable (Configurable) per guest CPU ID feature registers are useful for
creating/migrating guest on ARM CPUs with different kinds of features.

---

* v1 -> v2
  - Rebase to 7121a2e1d107 (kvmarm/next) Merge branch kvm-arm64/nv-prefix into kvmarm/next
  - Address writing issue for PMUVer

[1] https://lore.kernel.org/all/20230201025048.205820-1-jingzhangos@google.com

---

Jing Zhang (5):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Introduce ID register specific descriptor
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

Reiji Watanabe (1):
  KVM: arm64: Save ID registers' sanitized value per guest

 arch/arm64/include/asm/cpufeature.h |  25 +
 arch/arm64/include/asm/kvm_host.h   |  26 +-
 arch/arm64/kernel/cpufeature.c      |  26 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 +-
 arch/arm64/kvm/id_regs.c            | 773 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 468 +----------------
 arch/arm64/kvm/sys_regs.h           |  30 ++
 include/kvm/arm_pmu.h               |   6 +-
 10 files changed, 885 insertions(+), 502 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 7121a2e1d1070913f692d32806a36b8b3b3f0008
-- 
2.39.1.581.gbfd45094c4-goog

