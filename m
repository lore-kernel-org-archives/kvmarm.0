Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7919D2581
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:34 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-579dd7e77f5so59687187b3.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017073; x=1691609073;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=blbJsY1tevXkpN11ExS1lzOVNoR4ZYwKCSGaaCw8t6U=;
        b=CjZI5HUbA9pnkqip1gs9QRVz34a6qhwBmtysgri3RzvR08LQe/zefIRLxQ+k/m3iPg
         JYv56WOxNaHoTpKwE8Kdwxd+9fy2kDaKvDyPOCgVA2K8cbfl7EBBK0L2h4l37E4EdZhX
         zSySqR/M8D2PTfPDnmbaw8xglDtx8Z0ujrIYfYsPirhgl2JWN86zptFcecJ3axv7QvQJ
         UCYExHaiV5FzLuUgLIJkKoy47o9Vu5ILm5ubor1wPMRJCOF7ClhYrmewvoIgvea0br0s
         DWMoSidn0ur8mtJts784btGXJ+AkAMAwey2q4psdIlikdsc7RalhNggPNzrCPq38GAmq
         5TdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017073; x=1691609073;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=blbJsY1tevXkpN11ExS1lzOVNoR4ZYwKCSGaaCw8t6U=;
        b=aGo2CHm4mY7k/FSUFO2mxb1fOgWZu13Z6AP65x9MiUiQacGLDdL1CFAFT5j9g4nJgs
         G2jLu3I0gsd0tO3Hw25x3+KXOGpJoX8DyMAW6s47PAtzsNRIn+Mu80gPmQk0s+SwJL0A
         30pAQm7BWbYA7pT81bY60bPDvADDnAn4v2HXCXu/2YE4GHJkTecyXccOxY90XvDIM5EX
         91kquiAsXPFkhi52v0M69HdK+z7w9CDHQXRocpZ2i/cGFMxzk63WHcSmjmgzcz6kyGMC
         2cQtDYeBf/FQGV13cQuan2xkZD6RuBC1BWRdV+bB4SbimTUNSYrmBR6QHwID4SSova8p
         yrXQ==
X-Gm-Message-State: ABy/qLYVOwFd1gYLYn92Tj71ue9UjdSA6n0aCEHIsc1AL0R7Ry73fxIZ
	uboKoAidq1AmxRosIBK0zfXnZZB+pItod5J/wQ==
X-Google-Smtp-Source: APBJJlFfpoC9fJXsqOFcjrMpASNBzMzZhqXGDJedjyg3Esd8A1tWW4poDR1LpBHpcCPUD+QPxXBPSool9fvrH46tMw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:cf0c:0:b0:570:b1:ca37 with SMTP id
 u12-20020a81cf0c000000b0057000b1ca37mr94786ywi.5.1689017073377; Mon, 10 Jul
 2023 12:24:33 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-1-jingzhangos@google.com>
Subject: [PATCH v5 0/6] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2, 3}
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.

It is based on v6.5-rc1 which contains infrastructure for writable idregs.

A selftest is added to verify that KVM handles the writings from user space
correctly.

A relevant patch from Oliver is picked from [3].

---

* v4 -> v5
  - Rebase on v6.4-rc1 which contains infrastructure for writable idregs.
  - Use guest ID registers values for the sake of emulation.
  - Added a selftest to verify idreg userspace writing.

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com
[3] https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@linux.dev

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com

---

Jing Zhang (5):
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 arch/arm64/kvm/sys_regs.c                     |  62 +++++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 3 files changed, 213 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0.255.g8b1d071c50-goog

